CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_employee_i()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table employee_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    ==============================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
NULL_UTC_TIMESTAMP TIMESTAMP := to_timestamp(0)::TIMESTAMP AT TIME ZONE 'UTC';
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
        ,'NULL_EMPLOYEE' -- employee_key
        ,''-- full_name
        ,'' -- email
        ,'' -- secondary_email
        ,'' -- phone
        ,'' -- mobile_phone
        ,NULL_UTC_TIMESTAMP -- created_timestamp
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,'' -- tech_row_hash
        ,0 -- tech_data_load_utc_timestamp
        ,'' -- tech_data_load_uuid
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
        ,created_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        vt_user.user_name AS employee_key
        ,COALESCE(vt_user.first_name || ' ' || vt_user.last_name, vt_user.last_name, vt_user.last_name) AS full_name
        ,vt_user.email1 AS email
        ,vt_user.email2 AS secondary_email
        ,vt_user.phone_work AS phone
        ,vt_user.phone_mobile AS mobile_phone
        ,(vt_user.date_entered || ' ' || vt_user.time_zone)::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,vt_user.deleted::bool AS tech_deleted_in_source_system
        ,md5(
           COALESCE(vt_user.first_name, '')
        || COALESCE(vt_user.last_name, '')
        || COALESCE(vt_user.email1, '')
        || COALESCE(vt_user.email2, '')
        || COALESCE(vt_user.phone_work, '')
        || COALESCE(vt_user.phone_mobile, '')
        || vt_user.deleted
        ) AS tech_row_hash
        ,vt_user.tech_data_load_utc_timestamp
        ,vt_user.tech_data_load_uuid
    FROM stage.vtiger_users_i AS vt_user;

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
        ,tmp_employee_i.created_timestamp
        ,tmp_employee_i.tech_insert_function
        ,tmp_employee_i.tech_insert_utc_timestamp
        ,tmp_employee_i.tech_deleted_in_source_system
        ,tmp_employee_i.tech_row_hash
        ,tmp_employee_i.tech_data_load_utc_timestamp
        ,tmp_employee_i.tech_data_load_uuid
    FROM tmp_employee_i;

    RETURN 0;

END;$function$
