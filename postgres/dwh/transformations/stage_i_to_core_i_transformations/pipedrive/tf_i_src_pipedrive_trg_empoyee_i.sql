CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_employee_i()
RETURNS INTEGER
AS $$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table employee_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-10-25 (YYYY-MM-DD)
    NOTE:
    ==============================================================================================
    */

DECLARE 

EMPLOYEE_KEY_PREFIX TEXT := 'PIPEDRIVE_EMPLOYEE_';
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

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.employee_i (
        employee_id
        ,employee_key
        ,full_name
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,fk_date_id_created_date
        ,created_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    VALUES ( 
        -1 -- employee_id
        ,TEXT_NULL -- employee_key
        ,TEXT_NULL-- full_name
        ,TEXT_NULL -- email
        ,TEXT_NULL -- secondary_email
        ,TEXT_NULL -- phone
        ,TEXT_NULL -- mobile_phone
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,TEXT_NULL -- tech_row_hash
        ,-1 -- tech_data_load_utc_timestamp
        ,TEXT_NULL -- tech_data_load_uuid
    ) ON CONFLICT DO NOTHING;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_employee_i cascade;

    CREATE TEMPORARY TABLE tmp_employee_i (
        employee_key                    TEXT PRIMARY KEY
        ,full_name                      TEXT NOT NULL
        ,email                          TEXT NOT NULL
        ,secondary_email                TEXT NOT NULL
        ,phone                          TEXT NOT NULL
        ,mobile_phone                   TEXT NOT NULL
        ,fk_date_id_created_date        INTEGER NOT NULL
        ,created_timestamp              TIMESTAMP WITH TIME ZONE NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_deleted_in_source_system  BOOL NOT NULL
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULL
    );

    INSERT INTO tmp_employee_i (
        employee_key
        ,full_name
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,fk_date_id_created_date
        ,created_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        EMPLOYEE_KEY_PREFIX || pipedrive_user.id AS employee_key
        ,pipedrive_user.name AS full_name
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_user.email) AS email
        ,tf_u_replace_empty_string_with_null_flag(NULL) AS secondary_email
        ,tf_u_replace_empty_string_with_null_flag(NULL) AS phone
        ,tf_u_replace_empty_string_with_null_flag(NULL) AS mobile_phone
        ,tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_user.created) AS fk_date_id_created_date
        ,(pipedrive_user.created || ' ' || 'UTC')::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
        COALESCE(pipedrive_user.name, '')
        || COALESCE(pipedrive_user.email, '')
        || COALESCE(pipedrive_user.active_flag::TEXT, '')
        ) AS tech_row_hash
        ,pipedrive_user.tech_data_load_utc_timestamp
        ,pipedrive_user.tech_data_load_uuid
    FROM stage.pipedrive_user_i AS pipedrive_user;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.employee_i (
        employee_key
        ,full_name
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,fk_date_id_created_date
        ,created_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT 
        tmp_employee_i.employee_key
        ,tmp_employee_i.full_name
        ,tmp_employee_i.email
        ,tmp_employee_i.secondary_email
        ,tmp_employee_i.phone
        ,tmp_employee_i.mobile_phone
        ,tmp_employee_i.fk_date_id_created_date
        ,tmp_employee_i.created_timestamp
        ,tmp_employee_i.tech_insert_function
        ,tmp_employee_i.tech_insert_utc_timestamp
        ,tmp_employee_i.tech_deleted_in_source_system
        ,tmp_employee_i.tech_row_hash
        ,tmp_employee_i.tech_data_load_utc_timestamp
        ,tmp_employee_i.tech_data_load_uuid
    FROM tmp_employee_i;

    RETURN 0;

END;$$
LANGUAGE plpgsql
