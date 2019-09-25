CREATE OR REPLACE FUNCTION core.tf_t_worklog_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core worklog_i input table into core 'today' table worklog_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-15 (YYYY-MM-DD)
    NOTE:
    =================================================================================================================================
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

    INSERT INTO core.worklog_t (
        worklog_id
        ,worklog_key
        ,fk_issue_id
        ,fk_employee_id_created_by
        ,time_logged
        ,hours_logged
        ,days_logged
        ,worklog_comment
        ,fk_date_id_work_started_date
        ,work_started_at_timestamp
        ,tempo_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_worklog.worklog_id
        ,input_worklog.worklog_key
        ,input_worklog.fk_issue_id
        ,input_employee.employee_id AS fk_employee_id_created_by
        ,input_worklog.time_logged
        ,input_worklog.hours_logged
        ,input_worklog.days_logged
        ,input_worklog.worklog_comment
        ,input_worklog.fk_date_id_work_started_date
        ,input_worklog.work_started_at_timestamp
        ,input_worklog.tempo_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_worklog.tech_row_hash
        ,input_worklog.tech_data_load_utc_timestamp
        ,input_worklog.tech_data_load_uuid
    FROM core.worklog_i AS input_worklog
    LEFT JOIN core.employee_i AS input_employee ON input_worklog.fk_employee_id_created_by = input_employee.employee_id
        AND input_employee.tech_deleted_in_source_system IS FALSE
    WHERE input_worklog.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql

