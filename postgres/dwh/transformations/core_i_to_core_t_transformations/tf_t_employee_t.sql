CREATE OR REPLACE FUNCTION core.tf_t_employee_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from core employee_i input table into core 'today' table employee_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    ----------------------------------------------------
    -- INSERT RECORDS FROM INPUT TABLE TO TODAY TABLE --
    ----------------------------------------------------

    INSERT INTO core.employee_t (
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
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
         input_employee.employee_id
        ,input_employee.employee_key
        ,input_employee.full_name
        ,input_employee.email
        ,input_employee.secondary_email
        ,input_employee.phone
        ,input_employee.mobile_phone
        ,input_employee.fk_date_id_created_date
        ,input_employee.created_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_employee.tech_row_hash
        ,input_employee.tech_data_load_utc_timestamp
        ,input_employee.tech_data_load_uuid
    FROM core.employee_i AS input_employee;

    RETURN 0;
END;$$

LANGUAGE plpgsql

