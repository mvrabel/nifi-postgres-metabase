CREATE OR REPLACE FUNCTION core.tf_h_employee_ih()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        SCD2 historization of table employee_i.
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-21 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
INFINITY_TIMESTAMP bigint := 300001010000;
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;
    
    -------------------------------------------
    -------------------------------------------
    --                                       --
    --              NEW RECORDS              --
    --                                       --
    -------------------------------------------
    -------------------------------------------

    ------------------------
    -- INSERT NEW RECORDS --
    ------------------------

    INSERT INTO core.employee_ih (
        employee_key
        ,full_name
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,created_timestamp
        ,tech_insert_function
        ,tech_begin_effective_utc_timestamp
        ,tech_end_effective_utc_timestamp
        ,tech_is_current
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )	
    SELECT 
        input_employee.employee_key
        ,input_employee.full_name
        ,input_employee.email
        ,input_employee.secondary_email
        ,input_employee.phone
        ,input_employee.mobile_phone
        ,input_employee.created_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_employee.tech_deleted_in_source_system
        ,input_employee.tech_row_hash
        ,input_employee.tech_data_load_utc_timestamp
        ,input_employee.tech_data_load_uuid
    FROM core.employee_i AS input_employee
    LEFT JOIN core.employee_ih AS hist_employee ON hist_employee.employee_key = input_employee.employee_key
        AND hist_employee.tech_is_current = TRUE
    WHERE hist_employee.employee_key IS NULL;

    -----------------------------------------------
    -----------------------------------------------
    --                                           --
    --              UPDATED RECORDS              --
    --                                           --
    -----------------------------------------------
    -----------------------------------------------

    ------------------------------------------------
    -- GET KEYS OF RECORDS THAT HAVE BEEN UPDATED --
    ------------------------------------------------

    DROP TABLE IF EXISTS updated_employee;
    
    CREATE TEMPORARY TABLE updated_employee (
        employee_key TEXT NOT NULL
    );
    
    INSERT INTO updated_employee (
        employee_key
    )
    SELECT
        input_employee.employee_key
    FROM core.employee_i AS input_employee
    JOIN core.employee_ih AS hist_employee ON hist_employee.employee_key = input_employee.employee_key
        AND hist_employee.tech_is_current = TRUE
    WHERE input_employee.tech_row_hash != hist_employee.tech_row_hash
        -- This "OR" is maybe unnecessary but let's keep it just to be sure.
        OR (
            input_employee.tech_row_hash = hist_employee.tech_row_hash
            AND hist_employee.tech_deleted_in_source_system = TRUE
            AND input_employee.tech_deleted_in_source_system = FALSE
            );

    ----------------------------------------------------------
    -- SET tech_is_current FLAG ON UPDATED RECORDS TO FALSE --
    -- AND                                                  --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP     --
    ----------------------------------------------------------

    UPDATE core.employee_ih AS hist_employee
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM updated_employee
    WHERE updated_employee.employee_key = hist_employee.employee_key
        AND hist_employee.tech_is_current = TRUE;

    ----------------------------
    -- INSERT UPDATED RECORDS --
    ----------------------------

    INSERT INTO core.employee_ih (
        employee_key
        ,full_name
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,created_timestamp
        ,tech_insert_function
        ,tech_begin_effective_utc_timestamp
        ,tech_end_effective_utc_timestamp
        ,tech_is_current
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT 
        input_employee.employee_key
        ,input_employee.full_name
        ,input_employee.email
        ,input_employee.secondary_email
        ,input_employee.phone
        ,input_employee.mobile_phone
        ,input_employee.created_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_employee.tech_deleted_in_source_system
        ,input_employee.tech_row_hash
        ,input_employee.tech_data_load_utc_timestamp
        ,input_employee.tech_data_load_uuid
    FROM core.employee_i AS input_employee
    WHERE input_employee.employee_key IN (SELECT employee_key FROM updated_employee);

    -----------------------------------------------
    -----------------------------------------------
    --                                           --
    --              DELETED RECORDS              --
    --                                           --
    -----------------------------------------------
    -----------------------------------------------

    ------------------------------------------------
    -- GET KEYS OF RECORDS THAT HAVE BEEN DELETED --
    ------------------------------------------------

    DROP TABLE IF EXISTS deleted_employee;

    CREATE TEMPORARY TABLE deleted_employee (
        employee_id INTEGER NOT NULL
    );
    
    INSERT INTO deleted_employee (
        employee_id
    )
    SELECT
        hist_employee.employee_id
    FROM core.employee_ih AS hist_employee
    LEFT JOIN core.employee_i AS input_employee ON input_employee.employee_key = hist_employee.employee_key
    WHERE input_employee.employee_key IS NULL 
        AND hist_employee.tech_is_current = TRUE
        AND hist_employee.tech_deleted_in_source_system = FALSE;

    ---------------------------------------------------------------
    -- SET tech_is_current FLAG ON DELETED RECORDS TO FALSE      --
    -- AND                                                       --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP --
    ---------------------------------------------------------------

    UPDATE core.employee_ih AS hist_employee
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM deleted_employee
    WHERE deleted_employee.employee_id = hist_employee.employee_id
        AND hist_employee.tech_is_current = TRUE;

    ----------------------------
    -- INSERT DELETED RECORDS --
    ----------------------------

    INSERT INTO core.employee_ih (
        employee_key
        ,full_name
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,created_timestamp
        ,tech_insert_function
        ,tech_begin_effective_utc_timestamp
        ,tech_end_effective_utc_timestamp
        ,tech_is_current
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT 
        hist_employee.employee_key
        ,hist_employee.full_name
        ,hist_employee.email
        ,hist_employee.secondary_email
        ,hist_employee.phone
        ,hist_employee.mobile_phone
        ,hist_employee.created_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,TRUE AS tech_deleted_in_source_system
        ,hist_employee.tech_row_hash
        ,hist_employee.tech_data_load_utc_timestamp
        ,hist_employee.tech_data_load_uuid
    FROM core.employee_ih AS hist_employee
    WHERE hist_employee.employee_id IN (SELECT employee_id FROM deleted_employee);

    RETURN 0;

END;$$

LANGUAGE plpgsql

