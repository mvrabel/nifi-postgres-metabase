CREATE OR REPLACE FUNCTION mart.tf_r_hours_logged_per_issue()
RETURNS INTEGER AS $$

DECLARE

BEGIN

    INSERT INTO mart.report_hours_logged_per_issue (
        issue_key
        ,issue_summary
        ,project_key
        ,employee
        ,hours_logged
        ,work_started_at_timestamp
        )
    SELECT
        issue.jira_key AS issue_key
        ,issue.summary AS issue_summary
        ,project.jira_key AS project_key
        ,employee.full_name AS employee
        ,worklog.hours_logged
        ,worklog.work_started_at_timestamp
    FROM core.issue_t AS issue
    JOIN core.worklog_t AS worklog ON worklog.fk_issue_id = issue.issue_id
    JOIN core.employee_t AS employee ON employee.employee_id = worklog.fk_employee_id_created_by
    JOIN core.project_t AS project ON project.project_id = issue.fk_project_id;
    
	RETURN 0;

END;$$

LANGUAGE plpgsql