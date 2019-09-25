CREATE OR REPLACE FUNCTION core.tf_t_release_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from core release_i input table into core 'today' table release_t
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

    INSERT INTO core.release_t (
        release_id
        ,release_key
        ,jira_id
        ,fk_date_id_release_date
        ,release_date
        ,release_name
        ,release_number
        ,fk_date_id_start_date
        ,start_date
        ,fk_project_id
        ,description
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_release.release_id
        ,input_release.release_key
        ,input_release.jira_id
        ,input_release.fk_date_id_release_date
        ,input_release.release_date
        ,input_release.release_name
        ,input_release.release_number
        ,input_release.fk_date_id_start_date
        ,input_release.start_date
        ,input_release.fk_project_id
        ,input_release.description
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_release.tech_row_hash
        ,input_release.tech_data_load_utc_timestamp
        ,input_release.tech_data_load_uuid
    FROM core.release_i AS input_release
    WHERE input_release.tech_deleted_in_source_system IS FALSE;

    RETURN 0;
END;$$

LANGUAGE plpgsql

