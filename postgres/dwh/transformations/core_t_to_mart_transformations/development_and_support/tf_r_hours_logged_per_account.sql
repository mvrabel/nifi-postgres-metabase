CREATE
    OR REPLACE FUNCTION mart.tf_r_hours_logged_per_account()
RETURNS INTEGER AS $$

DECLARE

NO_ACCOUNT_FLAG TEXT := 'Common';
NO_CUSTOMER_FLAG TEXT := 'Common';
HELP_DESK_PROJECT_KEY TEXT := 'HD';
DEVELOPMENT_PROJECT_KEY TEXT := 'DEV';
PRESALE_PROJECT_KEY TEXT := 'PRS';
SUPPORT_ISSUE_FLAG TEXT := 'Support';
FEATURE_ISSUE_FLAG TEXT := 'Feature';
ACTIVITY_ISSUE_FLAG TEXT := 'Activity';
TASK_ISSUE_FLAG TEXT := 'Task';
BUG_ISSUE_FLAG TEXT := 'Bug';
stack text;
FUNCTION_NAME text;

BEGIN

    WITH
    hd_worklogs AS (
        SELECT
            account
            ,customer
            ,employee.full_name AS employee    
            ,worklog.hours_logged
            ,worklog.work_started_at_timestamp
        FROM core.issue_t AS issue
        JOIN core.project_t AS project ON project.project_id = issue.fk_project_id 
        JOIN core.worklog_t AS worklog ON worklog.fk_issue_id = issue.issue_id
        JOIN core.employee_t AS employee ON employee.employee_id = worklog.fk_employee_id_created_by
        WHERE project.jira_key = HELP_DESK_PROJECT_KEY
    )
    ,prs_worklogs AS (
        SELECT
            issue.account
            ,issue.customer
            ,employee.full_name AS employee    
            ,worklog.hours_logged
            ,worklog.work_started_at_timestamp
        FROM core.issue_t AS issue
        JOIN core.project_t AS project ON project.project_id = issue.fk_project_id 
        JOIN core.worklog_t AS worklog ON worklog.fk_issue_id = issue.issue_id
        JOIN core.employee_t AS employee ON employee.employee_id = worklog.fk_employee_id_created_by
        WHERE project.jira_key = PRESALE_PROJECT_KEY
    )
    ,dev_support_worklogs AS (
        SELECT
            issue.account
            ,issue.customer
            ,employee.full_name AS employee    
            ,worklog.hours_logged
            ,worklog.work_started_at_timestamp
        FROM core.issue_t AS issue
        JOIN core.project_t AS project ON project.project_id = issue.fk_project_id 
        JOIN core.worklog_t AS worklog ON worklog.fk_issue_id = issue.issue_id
        JOIN core.employee_t AS employee ON employee.employee_id = worklog.fk_employee_id_created_by
        WHERE project.jira_key = DEVELOPMENT_PROJECT_KEY
        AND issue.issue_type = SUPPORT_ISSUE_FLAG
    )
    ,dev_other_worklogs AS (
        SELECT
            issue.account
            ,issue.customer
            ,employee.full_name AS employee    
            ,worklog.hours_logged
            ,worklog.work_started_at_timestamp
        FROM core.issue_t AS issue
        JOIN core.project_t AS project ON project.project_id = issue.fk_project_id 
        JOIN core.worklog_t AS worklog ON worklog.fk_issue_id = issue.issue_id
        JOIN core.employee_t AS employee ON employee.employee_id = worklog.fk_employee_id_created_by
        WHERE project.jira_key = DEVELOPMENT_PROJECT_KEY AND issue.account IS NOT NULL
        AND issue.issue_type IN (FEATURE_ISSUE_FLAG, ACTIVITY_ISSUE_FLAG, TASK_ISSUE_FLAG, BUG_ISSUE_FLAG)
    )
    INSERT INTO mart.report_hours_logged_per_account (
        account
        ,customer
        ,employee
        ,hours_logged
        ,work_started_at_timestamp
    ) 
    SELECT
        account
        ,customer
        ,employee
        ,hours_logged
        ,work_started_at_timestamp
    FROM hd_worklogs
    
    UNION
    
    SELECT
        account
        ,customer
        ,employee
        ,hours_logged
        ,work_started_at_timestamp
    FROM dev_support_worklogs
    
    UNION
    
    SELECT
        account
        ,customer
        ,employee
        ,hours_logged
        ,work_started_at_timestamp
    FROM dev_other_worklogs

    UNION 
    
    SELECT
        account
        ,customer
        ,employee
        ,hours_logged
        ,work_started_at_timestamp
    FROM prs_worklogs;
    
    RETURN 0;

END;$$

LANGUAGE plpgsql
