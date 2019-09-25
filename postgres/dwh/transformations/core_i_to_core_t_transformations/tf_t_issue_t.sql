CREATE OR REPLACE FUNCTION core.tf_t_issue_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from core issue_i input table into core 'today' table issue_t
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

    INSERT INTO core.issue_t (
        issue_id
        ,issue_key
        ,jira_key
        ,jira_id
        ,account
        ,customer
        ,status
        ,summary
        ,priority
        ,sla_priority
        ,description
        ,issue_type
        ,resolution
        ,deployment
        ,epic_name
        ,epic_jira_key
        ,original_estimate
        ,remaining_estimate
        ,aggregate_original_estimate
        ,aggregate_remaining_estimate
        ,hours_logged_total
        ,days_logged_total
        ,labels
        ,components
        ,fix_versions
        ,affected_versions
        ,inception_to_first_response_days
        ,inception_to_pilot_days
        ,inception_to_sales_days
        ,inception_to_deployment_days
        ,inception_to_resolution_days
        ,inception_to_now_days
        ,first_response_to_resolution_days
        ,activation_to_pilot_days
        ,activation_to_sales_days
        ,activation_to_deployment_days
        ,activation_to_now_days
        ,pilot_to_pilot_finished_days
        ,pilot_to_sales_days
        ,pilot_to_deployment_days
        ,pilot_to_now_days
        ,pilot_finished_to_sales_days
        ,pilot_finished_to_now_days
        ,sales_to_deployment_days
        ,sales_to_now_days
        ,deployment_to_now_days
        ,fk_date_id_activation_date
        ,activation_timestamp
        ,fk_date_id_first_response_date
        ,first_response_timestamp
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_resolution_date
        ,resolution_timestamp
        ,fk_date_id_inception_date
        ,inception_date
        ,fk_date_id_pilot_date
        ,pilot_date
        ,fk_date_id_pilot_finished_date
        ,pilot_finished_date
        ,fk_date_id_sales_date
        ,sales_date
        ,fk_date_id_deployment_date
        ,deployment_date
        ,fk_project_id
        ,fk_party_id_created_by
        ,fk_party_id_reported_by
        ,fk_employee_id_assigned_to
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_issue.issue_id
        ,input_issue.issue_key
        ,input_issue.jira_key
        ,input_issue.jira_id
        ,input_issue.account
        ,input_issue.customer
        ,input_issue.status
        ,input_issue.summary
        ,input_issue.priority
        ,input_issue.sla_priority
        ,input_issue.description
        ,input_issue.issue_type
        ,input_issue.resolution
        ,input_issue.deployment
        ,input_issue.epic_name
        ,input_issue.epic_jira_key
        ,input_issue.original_estimate
        ,input_issue.remaining_estimate
        ,input_issue.aggregate_original_estimate
        ,input_issue.aggregate_remaining_estimate
        ,input_issue.hours_logged_total
        ,input_issue.days_logged_total
        ,input_issue.labels
        ,input_issue.components
        ,input_issue.fix_versions
        ,input_issue.affected_versions
        ,input_issue.inception_to_first_response_days
        ,input_issue.inception_to_pilot_days
        ,input_issue.inception_to_sales_days
        ,input_issue.inception_to_deployment_days
        ,input_issue.inception_to_resolution_days
        ,input_issue.inception_to_now_days
        ,input_issue.first_response_to_resolution_days
        ,input_issue.activation_to_pilot_days
        ,input_issue.activation_to_sales_days
        ,input_issue.activation_to_deployment_days
        ,input_issue.activation_to_now_days
        ,input_issue.pilot_to_pilot_finished_days
        ,input_issue.pilot_to_sales_days
        ,input_issue.pilot_to_deployment_days
        ,input_issue.pilot_to_now_days
        ,input_issue.pilot_finished_to_sales_days
        ,input_issue.pilot_finished_to_now_days
        ,input_issue.sales_to_deployment_days
        ,input_issue.sales_to_now_days
        ,input_issue.deployment_to_now_days
        ,input_issue.fk_date_id_activation_date
        ,input_issue.activation_timestamp
        ,input_issue.fk_date_id_first_response_date
        ,input_issue.first_response_timestamp
        ,input_issue.fk_date_id_created_date
        ,input_issue.created_timestamp
        ,input_issue.fk_date_id_resolution_date
        ,input_issue.resolution_timestamp
        ,input_issue.fk_date_id_inception_date
        ,input_issue.inception_date
        ,input_issue.fk_date_id_pilot_date
        ,input_issue.pilot_date
        ,input_issue.fk_date_id_pilot_finished_date
        ,input_issue.pilot_finished_date
        ,input_issue.fk_date_id_sales_date
        ,input_issue.sales_date
        ,input_issue.fk_date_id_deployment_date
        ,input_issue.deployment_date
        ,input_issue.fk_project_id
        ,party_created.party_id AS fk_party_id_created_by
        ,party_reported.party_id AS fk_party_id_reported_by
        ,employee_assigned.employee_id AS fk_employee_id_assigned_to
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_issue.tech_row_hash
        ,input_issue.tech_data_load_utc_timestamp
        ,input_issue.tech_data_load_uuid
    FROM core.issue_i AS input_issue
    LEFT JOIN core.employee_i AS employee_assigned ON input_issue.fk_employee_id_assigned_to = employee_assigned.employee_id
        AND employee_assigned.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.party_i AS party_reported ON input_issue.fk_party_id_reported_by = party_reported.party_id
        AND party_reported.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.party_i AS party_created ON input_issue.fk_party_id_created_by = party_created.party_id
        AND party_created.tech_deleted_in_source_system IS FALSE
    WHERE input_issue.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql

