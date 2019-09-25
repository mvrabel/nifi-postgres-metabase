CREATE OR REPLACE FUNCTION core.tf_i_src_mailchimp_trg_mailing_list_segment_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'mailchimp_*' tables into core input table mailing_list_segment_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-07-14 (YYYY-MM-DD)
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

    DROP TABLE IF EXISTS tmp_mailing_list_segment;

    CREATE TEMPORARY TABLE tmp_mailing_list_segment (
        mailing_list_segment_key        TEXT NOT NULL
        ,segment_name                   TEXT NOT NULL
        ,mailchimp_id                   INTEGER
        ,segment_type                   TEXT
        ,fk_date_id_created_date        INTEGER NOT NULL
        ,created_timestamp              TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_last_updated_date   INTEGER NOT NULL
        ,last_updated_timestamp         TIMESTAMP WITH TIME ZONE NOT NULL
        ,segment_filter_options         JSONB
        ,fk_mailing_list_id             INTEGER NOT NULL
        ,tech_insert_function           TEXT  NOT NULL
        ,tech_insert_utc_timestamp      bigint  NOT NULL
        ,tech_row_hash                  TEXT  NOT NULL
        ,tech_data_load_utc_timestamp   bigint  NOT NULL
        ,tech_data_load_uuid            TEXT  NOT NULL
        ,tech_deleted_in_source_system  BOOL NOT NULL
     );

    INSERT INTO tmp_mailing_list_segment (
        mailing_list_segment_key
        ,segment_name
        ,mailchimp_id
        ,segment_type
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,segment_filter_options
        ,fk_mailing_list_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )

    SELECT
        list_segment.id  AS mailing_list_segment_key
        ,list_segment.name AS segment_name
        ,list_segment.id AS mailchimp_id
        ,list_segment."type" AS segment_type
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(list_segment.created_at), -1) AS fk_date_id_created_date
        ,list_segment.created_at::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(list_segment.updated_at), -1) AS fk_date_id_last_updated_date
        ,list_segment.updated_at::TIMESTAMP WITH TIME ZONE AS last_updated_timestamp
        ,list_segment.options::JSONB AS segment_filter_options
        ,core_input_list.mailing_list_id AS fk_mailing_list_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(list_segment.id::TEXT, '')
            || COALESCE(list_segment.name, '')
            || COALESCE(list_segment."type"::TEXT, '')
            || COALESCE(list_segment.created_at::TEXT, '')
            || COALESCE(list_segment.updated_at, '')
            || COALESCE(list_segment.options, '')
            || COALESCE(list_segment.list_id, '')
        ) AS tech_row_hash
        ,list_segment.tech_data_load_utc_timestamp
        ,list_segment.tech_data_load_uuid
    FROM stage.mailchimp_list_segment_i AS list_segment
    JOIN core.mailing_list_i AS core_input_list ON core_input_list.mailing_list_key = list_segment.list_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.mailing_list_segment_i (
        mailing_list_segment_key
        ,segment_name
        ,mailchimp_id
        ,segment_type
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,segment_filter_options
        ,fk_mailing_list_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_mailing_list_segment.mailing_list_segment_key
        ,tmp_mailing_list_segment.segment_name
        ,tmp_mailing_list_segment.mailchimp_id
        ,tmp_mailing_list_segment.segment_type
        ,tmp_mailing_list_segment.fk_date_id_created_date
        ,tmp_mailing_list_segment.created_timestamp
        ,tmp_mailing_list_segment.fk_date_id_last_updated_date
        ,tmp_mailing_list_segment.last_updated_timestamp
        ,tmp_mailing_list_segment.segment_filter_options
        ,tmp_mailing_list_segment.fk_mailing_list_id
        ,tmp_mailing_list_segment.tech_insert_function
        ,tmp_mailing_list_segment.tech_insert_utc_timestamp
        ,tmp_mailing_list_segment.tech_deleted_in_source_system
        ,tmp_mailing_list_segment.tech_row_hash
        ,tmp_mailing_list_segment.tech_data_load_utc_timestamp
        ,tmp_mailing_list_segment.tech_data_load_uuid
    FROM tmp_mailing_list_segment;

    RETURN 0;

END;$$

LANGUAGE plpgsql
