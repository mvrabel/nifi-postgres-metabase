CREATE OR REPLACE FUNCTION core.tf_t_project_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from core project_i input table into core 'today' table project_t
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

    INSERT INTO core.project_t (
        project_id
        ,project_key
        ,jira_id
        ,jira_key
        ,project_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_project.project_id
        ,input_project.project_key
        ,input_project.jira_id
        ,input_project.jira_key
        ,input_project.project_name
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_project.tech_row_hash
        ,input_project.tech_data_load_utc_timestamp
        ,input_project.tech_data_load_uuid
    FROM core.project_i AS input_project
    WHERE input_project.tech_deleted_in_source_system IS FALSE;

    RETURN 0;
END;$$

LANGUAGE plpgsql

