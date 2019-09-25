CREATE OR REPLACE FUNCTION mart.tf_r_bugs_per_account()
RETURNS INTEGER AS $$

DECLARE

TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);

NO_COMPONENT_FLAG TEXT[] := '{Common}';
NO_ACCOUNT_FLAG TEXT := 'Common';
NO_CUSTOMER_FLAG TEXT := 'Common';
NONE_TEXT TEXT := 'None';
UNDEFINED_TEXT TEXT := 'Undefined';
NO_SLA_PRIORITY_FLAG TEXT := 'NO_SLA';
NO_PRIORITY_FLAG TEXT := 'NO_PRIORITY';
BUSINESS_INTELLIGENCE_PROJECT_KEY TEXT := 'BI';
HELP_DESK_PROJECT_KEY TEXT := 'HD';
DEVELOPMENT_PROJECT_KEY TEXT := 'DEV';
SUPPORT_ISSUE_FLAG TEXT := 'Support';
FEATURE_ISSUE_FLAG TEXT := 'Feature';
ACTIVITY_ISSUE_FLAG TEXT := 'Activity';
TASK_ISSUE_FLAG TEXT := 'Task';
BUG_ISSUE_FLAG TEXT := 'Bug';
STATUS_RESOLVED TEXT := 'Resolved';
STATUS_CLOSED TEXT := 'Closed';

BEGIN

    WITH resolved_bugs AS (
        SELECT
            issue.account
            ,issue.customer
            ,issue.priority
            ,issue.sla_priority
            ,issue.deployment
            ,1 AS created_bugs_number
            ,CASE 
                WHEN issue.status = STATUS_RESOLVED OR status = STATUS_CLOSED THEN 1
                ELSE 0 
            END AS resolved_bugs_number
            ,CASE WHEN issue.inception_to_resolution_days = -1 THEN NULL ELSE issue.inception_to_resolution_days END AS inception_to_resolution_days
            ,CASE WHEN issue.first_response_to_resolution_days = -1 THEN NULL ELSE issue.first_response_to_resolution_days END AS first_response_to_resolution_days
            ,CASE WHEN issue.inception_to_first_response_days = -1 THEN NULL ELSE issue.inception_to_first_response_days END AS inception_to_first_response_days
            ,CASE WHEN issue.first_response_timestamp = TIMESTAMP_NEVER THEN NULL ELSE issue.first_response_timestamp END AS first_response_timestamp
            ,CASE WHEN issue.created_timestamp = TIMESTAMP_NEVER THEN NULL ELSE issue.created_timestamp END AS created_timestamp
            ,CASE WHEN issue.resolution_timestamp = TIMESTAMP_NEVER THEN NULL ELSE issue.resolution_timestamp END AS resolution_timestamp
        FROM core.issue_t AS issue
        JOIN core.project_t AS project ON project.project_id = issue.fk_project_id
        WHERE project.jira_key = HELP_DESK_PROJECT_KEY
            AND issue_type = BUG_ISSUE_FLAG
        )
    INSERT INTO mart.report_bugs_per_account (
        account
        ,customer
        ,priority
        ,sla_priority
        ,deployment
        ,created_bugs_number
        ,resolved_bugs_number
        ,created_to_resoluion_hours
        ,first_response_to_resolution_hours
        ,created_to_first_response_hours
        ,first_response_timestamp
        ,created_timestamp
        ,resolution_timestamp
        )
    SELECT
        account
        ,customer
        ,priority
        ,sla_priority
        ,deployment
        ,created_bugs_number
        ,resolved_bugs_number
        ,inception_to_resolution_days*24 AS inception_to_resoluion_hours
        ,first_response_to_resolution_days*24 AS first_response_to_resolution_hours
        ,inception_to_first_response_days*24 AS inception_to_first_response_hours
        ,first_response_timestamp
        ,created_timestamp
        ,resolution_timestamp
    FROM resolved_bugs;
    
    RETURN 0;
END;$$

LANGUAGE plpgsql