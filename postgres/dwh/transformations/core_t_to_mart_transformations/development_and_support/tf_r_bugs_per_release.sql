CREATE OR REPLACE FUNCTION mart.tf_r_bugs_per_release()
RETURNS INTEGER AS $$

BEGIN

    INSERT INTO mart.report_bugs_per_release (
        project_key
        ,release_name
        ,release_number
        ,bug_key
        ,bug_summary
        ,bug_number
        )
    SELECT
        project.jira_key AS project_jira_key
        ,release.release_name AS release_name
        ,release.release_number AS release_number
        ,related_issue.jira_key AS bug_key
        ,related_issue.summary AS bug_summary
        ,1 AS bug_number    
    FROM core.project_t AS project
    JOIN core.release_t AS release ON release.fk_project_id = project.project_id
    JOIN core.issue_t AS issue ON issue.fk_project_id = project.project_id
        AND issue.fix_versions [1] = release.release_name
    JOIN core.issue_relation_map_t AS issue_relation_map ON issue_relation_map.fk_issue_id = issue.issue_id
    JOIN core.issue_t AS related_issue ON related_issue.issue_id = issue_relation_map.fk_issue_id_related_issue
    WHERE issue.summary LIKE 'Kvalifikační testování%' 
        AND related_issue.issue_type = 'Bug';

    RETURN 0;
END;$$

LANGUAGE plpgsql
