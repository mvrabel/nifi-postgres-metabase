CREATE OR REPLACE FUNCTION core.tf_i_src_mailchimp_trg_list_segment_list_member_map_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'mailchimp_*' tables into core input table list_segment_list_member_map_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-07-20 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_mailing_list_segment_list_member_map;

    CREATE TEMPORARY TABLE tmp_mailing_list_segment_list_member_map (
        list_segment_key                TEXT NOT NULL
        ,list_member_key                TEXT NOT NULL
        ,fk_mailing_list_segment_id     INTEGER NOT NULL
        ,fk_mailing_list_member_id      INTEGER NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULL
        ,tech_deleted_in_source_system  BOOL NOT NULL
    );

    INSERT INTO tmp_mailing_list_segment_list_member_map (
        list_segment_key
        ,list_member_key
        ,fk_mailing_list_segment_id
        ,fk_mailing_list_member_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )

    SELECT
        list_segment_member.list_segment_id AS list_segment_key
        ,list_segment_member.unique_email_id || list_segment_member.list_id AS list_member_key
        ,core_input_list_segment.mailing_list_segment_id AS fk_mailing_list_segment_id
        ,core_input_list_member.mailing_list_member_id AS fk_mailing_list_member_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(list_segment_member.list_segment_id::TEXT, '')
            || COALESCE(list_segment_member.unique_email_id::TEXT, '')
            || COALESCE(list_segment_member.list_id::TEXT, '')
        ) AS tech_row_hash
        ,list_segment_member.tech_data_load_utc_timestamp
        ,list_segment_member.tech_data_load_uuid
    FROM stage.mailchimp_list_segment_member_i AS list_segment_member
    JOIN core.mailing_list_segment_i AS core_input_list_segment ON core_input_list_segment.mailing_list_segment_key = list_segment_member.list_segment_id::TEXT
    JOIN core.mailing_list_member_i AS core_input_list_member ON core_input_list_member.mailing_list_member_key = list_segment_member.id || list_segment_member.list_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.list_segment_list_member_map_i (
        list_segment_key
        ,list_member_key
        ,fk_mailing_list_segment_id
        ,fk_mailing_list_member_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_mailing_list_segment_list_member_map.list_segment_key
        ,tmp_mailing_list_segment_list_member_map.list_member_key
        ,tmp_mailing_list_segment_list_member_map.fk_mailing_list_segment_id
        ,tmp_mailing_list_segment_list_member_map.fk_mailing_list_member_id
        ,tmp_mailing_list_segment_list_member_map.tech_insert_function
        ,tmp_mailing_list_segment_list_member_map.tech_insert_utc_timestamp
        ,tmp_mailing_list_segment_list_member_map.tech_deleted_in_source_system
        ,tmp_mailing_list_segment_list_member_map.tech_row_hash
        ,tmp_mailing_list_segment_list_member_map.tech_data_load_utc_timestamp
        ,tmp_mailing_list_segment_list_member_map.tech_data_load_uuid
    FROM tmp_mailing_list_segment_list_member_map;

    RETURN 0;

END;$$

LANGUAGE plpgsql
