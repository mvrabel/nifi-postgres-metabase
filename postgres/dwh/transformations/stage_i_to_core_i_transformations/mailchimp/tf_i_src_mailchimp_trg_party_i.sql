CREATE OR REPLACE FUNCTION core.tf_i_src_mailchimp_trg_party_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'mailchimp_member_i' table into core input table party_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-07-03 (YYYY-MM-DD)
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

    DROP TABLE IF EXISTS tmp_party_i;

    CREATE TEMPORARY TABLE tmp_party_i (
        party_key                       text  NOT NULL,
        full_name                       text  NOT NULL,
        short_name                      text  NOT NULL,
        fk_employee_id_last_modified_by integer  NOT NULL,
        fk_employee_id_created_by       integer  NOT NULL,
        fk_date_id_created_date         integer  NOT NULL,
        created_timestamp               timestamptz  NOT NULL,
        fk_date_id_last_modified_date   integer  NOT NULL,
        last_modified_timestamp         timestamptz  NOT NULL,
        tech_insert_function text       NOT NULL,
        tech_insert_utc_timestamp       bigint  NOT NULL,
        tech_row_hash                   text  NOT NULL,
        tech_data_load_utc_timestamp    bigint  NOT NULL,
        tech_data_load_uuid             text  NOT NULL,
        tech_deleted_in_source_system   bool NOT NULL
     );

    INSERT INTO tmp_party_i (
        party_key
        ,full_name
        ,short_name
        ,fk_employee_id_last_modified_by
        ,fk_employee_id_created_by
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_modified_date
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        list_member.id || list_member.list_id AS party_key
        ,list_member.merge_fields_fname || ' ' || merge_fields_lname AS full_name
        ,list_member.merge_fields_fname AS short_name
        ,-1 AS fk_employee_id_last_modified_by
        ,-1 AS fk_employee_id_created_by
        ,-1 AS fk_date_id_created_date
        ,TIMESTAMP_NEVER AS created_timestamp
        ,-1 AS fk_date_id_last_modified_date
        ,TIMESTAMP_NEVER AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(list_member.merge_fields_fname, '')
            || COALESCE(list_member.merge_fields_lname, '')
            || COALESCE(list_member.list_id, '')
        ) AS tech_row_hash
        ,list_member.tech_data_load_utc_timestamp
        ,list_member.tech_data_load_uuid
    FROM stage.mailchimp_list_member_i AS list_member;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.party_i (
        party_key
        ,full_name
        ,short_name
        ,fk_employee_id_last_modified_by
        ,fk_employee_id_created_by
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_modified_date
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_party_i.party_key
        ,tmp_party_i.full_name
        ,tmp_party_i.short_name
        ,tmp_party_i.fk_employee_id_last_modified_by
        ,tmp_party_i.fk_employee_id_created_by
        ,tmp_party_i.fk_date_id_created_date
        ,tmp_party_i.created_timestamp
        ,tmp_party_i.fk_date_id_last_modified_date
        ,tmp_party_i.last_modified_timestamp
        ,tmp_party_i.tech_insert_function
        ,tmp_party_i.tech_insert_utc_timestamp
        ,tmp_party_i.tech_deleted_in_source_system
        ,tmp_party_i.tech_row_hash
        ,tmp_party_i.tech_data_load_utc_timestamp
        ,tmp_party_i.tech_data_load_uuid
    FROM tmp_party_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
