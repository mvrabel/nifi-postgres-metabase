CREATE OR REPLACE FUNCTION core.tf_t_issue_comment_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from core issue_coment_i input table into core 'today' table issue_coment_t
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

    INSERT INTO core.issue_comment_t (
        issue_comment_id
        ,issue_comment_key
        ,body
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,fk_employee_id_created_by
        ,fk_employee_id_updated_by
        ,fk_issue_id
        ,is_public
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_issue_comment.issue_comment_id
        ,input_issue_comment.issue_comment_key
        ,input_issue_comment.body
        ,input_issue_comment.fk_date_id_created_date
        ,input_issue_comment.created_timestamp
        ,input_issue_comment.fk_date_id_last_updated_date
        ,input_issue_comment.last_updated_timestamp
        ,input_employee_created_by.employee_id AS fk_employee_id_created_by
        ,input_employee_updated_by.employee_id AS fk_employee_id_updated_by
        ,input_issue.issue_id AS fk_issue_id
        ,input_issue_comment.is_public
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_issue_comment.tech_row_hash
        ,input_issue_comment.tech_data_load_utc_timestamp
        ,input_issue_comment.tech_data_load_uuid
    FROM core.issue_comment_i AS input_issue_comment
    LEFT JOIN core.employee_i AS input_employee_created_by ON input_issue_comment.fk_employee_id_created_by = input_employee_created_by.employee_id
        AND input_employee_created_by.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.employee_i AS input_employee_updated_by ON input_issue_comment.fk_employee_id_updated_by = input_employee_updated_by.employee_id
        AND input_employee_updated_by.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.issue_i AS input_issue ON input_issue_comment.fk_issue_id = input_issue.issue_id
        AND input_issue.tech_deleted_in_source_system IS FALSE
    WHERE input_issue_comment.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql

