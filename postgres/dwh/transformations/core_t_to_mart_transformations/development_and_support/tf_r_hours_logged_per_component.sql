CREATE
    OR REPLACE FUNCTION mart.tf_r_hours_logged_per_component()
RETURNS INTEGER AS $$

DECLARE

TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
NO_COMPONENT_FLAG TEXT[] := '{Common}';
BUSINESS_INTELLIGENCE_PROJECT_KEY TEXT := 'BI';
HELP_DESK_PROJECT_KEY TEXT := 'HD';
DEVELOPMENT_PROJECT_KEY TEXT := 'DEV';
PRESALE_PROJECT_KEY TEXT := 'PRS';
SUPPORT_ISSUE_FLAG TEXT := 'Support';
FEATURE_ISSUE_FLAG TEXT := 'Feature';
ACTIVITY_ISSUE_FLAG TEXT := 'Activity';
TASK_ISSUE_FLAG TEXT := 'Task';
BUG_ISSUE_FLAG TEXT := 'Bug';

BEGIN

    WITH worklogs AS (
        WITH dev_worklogs AS (
                SELECT
                    CASE WHEN issue.components = TEXT_ARRAY_NULL THEN NO_COMPONENT_FLAG
                        ELSE issue.components
                    END AS components
                    ,project.project_name
                    ,project.jira_key AS project_jira_key
                    ,employee.full_name AS employee
                    ,worklog.hours_logged
                    ,array_length(issue.components, 1) AS number_of_components
                    ,worklog.work_started_at_timestamp
                FROM core.issue_t AS issue
                JOIN core.project_t AS project ON project.project_id = issue.fk_project_id
                JOIN core.worklog_t AS worklog ON worklog.fk_issue_id = issue.issue_id
                JOIN core.employee_t AS employee ON employee.employee_id = worklog.fk_employee_id_created_by
                WHERE issue.issue_type IN (FEATURE_ISSUE_FLAG, ACTIVITY_ISSUE_FLAG, TASK_ISSUE_FLAG, BUG_ISSUE_FLAG)
                    AND project.jira_key = DEVELOPMENT_PROJECT_KEY
            ),bi_worklogs AS (
             SELECT
                    CASE WHEN issue.components = TEXT_ARRAY_NULL THEN NO_COMPONENT_FLAG
                        ELSE issue.components
                    END AS components
                    ,project.project_name
                    ,project.jira_key AS project_jira_key
                    ,employee.full_name AS employee
                    ,worklog.hours_logged
                    ,array_length(issue.components, 1) AS number_of_components
                    ,worklog.work_started_at_timestamp
                FROM core.issue_t AS issue
                JOIN core.project_t AS project ON project.project_id = issue.fk_project_id
                JOIN core.worklog_t AS worklog ON worklog.fk_issue_id = issue.issue_id
                JOIN core.employee_t AS employee ON employee.employee_id = worklog.fk_employee_id_created_by
                WHERE project.jira_key = BUSINESS_INTELLIGENCE_PROJECT_KEY
        ), presale_worklogs AS (
                SELECT
                    CASE WHEN issue.components = TEXT_ARRAY_NULL THEN NO_COMPONENT_FLAG
                        ELSE issue.components
                    END AS components
                    ,project.project_name
                    ,project.jira_key AS project_jira_key
                    ,employee.full_name AS employee
                    ,worklog.hours_logged
                    ,array_length(issue.components, 1) AS number_of_components
                    ,worklog.work_started_at_timestamp
                FROM core.issue_t AS issue
                JOIN core.project_t AS project ON project.project_id = issue.fk_project_id
                JOIN core.worklog_t AS worklog ON worklog.fk_issue_id = issue.issue_id
                JOIN core.employee_t AS employee ON employee.employee_id = worklog.fk_employee_id_created_by
                WHERE project.jira_key = PRESALE_PROJECT_KEY
            )
        SELECT
            unnest(components) AS component
            ,project_jira_key AS project_key
            ,project_name AS project_name
            ,employee AS employee
            ,hours_logged / number_of_components AS hours_logged
            ,work_started_at_timestamp
        FROM dev_worklogs

        UNION ALL

        SELECT
            unnest(components) AS component
            ,project_jira_key AS project_key
            ,project_name AS project_name
            ,employee AS employee
            ,hours_logged / number_of_components AS hours_logged
            ,work_started_at_timestamp
        FROM bi_worklogs

        UNION ALL

        SELECT
            unnest(components) AS component
            ,project_jira_key AS project_key
            ,project_name AS project_name
            ,employee AS employee
            ,hours_logged / number_of_components AS hours_logged
            ,work_started_at_timestamp
        FROM presale_worklogs
    )
    ,releases AS (
        SELECT
            release.release_name
            ,release.release_number
            ,CASE WHEN release.fk_date_id_start_date = -1 THEN NULL ELSE release.start_date END AS start_date
            ,CASE WHEN release.fk_date_id_release_date = -1 THEN NULL ELSE release.release_date END AS release_date
        FROM core.release_t AS release
    )
    INSERT INTO mart.report_hours_logged_per_component (
        component
        ,project_key
        ,project_name
        ,employee
        ,hours_logged
        ,work_started_at_timestamp
        ,release_name
        ,release_number
    )
    SELECT
        worklogs.component
        ,worklogs.project_key
        ,worklogs.project_name
        ,worklogs.employee
        ,worklogs.hours_logged
        ,worklogs.work_started_at_timestamp
        ,releases.release_name
        ,releases.release_number
    FROM worklogs
    LEFT JOIN releases ON worklogs.work_started_at_timestamp >= releases.start_date
        AND worklogs.work_started_at_timestamp < releases.release_date + interval '1 day';

RETURN 0;

END;$$

LANGUAGE plpgsql
