CREATE
    OR REPLACE FUNCTION mart.tf_r_bugs_created_after_fix_version_release()
RETURNS INTEGER AS $$

DECLARE

BUG_ISSUE_FLAG TEXT := 'Bug';

BEGIN

    WITH bugs AS (
        SELECT
            issue.jira_key AS jira_key
            ,unnest(issue.fix_versions) AS fix_version
            ,issue.summary
            ,issue.created_timestamp
        FROM core.issue_t AS issue
        WHERE issue.issue_type = BUG_ISSUE_FLAG
        )
    INSERT INTO mart.bugs_created_after_fix_version_release (
        fix_version_name
        ,fix_version_number
        ,bug_key
        ,bug_summary
        ,bug_creation_date
        ,fix_version_release_date
        )
    SELECT
        released_versions.release_name AS fix_version_name
        ,released_versions.release_number AS fix_version_number
        ,bugs.jira_key AS bug_key
        ,bugs.summary AS bug_summary
        ,bugs.created_timestamp AS bug_creation_date
        ,released_versions.release_date
    FROM bugs
    JOIN core.release_t AS released_versions ON released_versions.release_name = bugs.fix_version
        AND released_versions.fk_date_id_release_date != - 1
    WHERE bugs.created_timestamp > released_versions.release_date;

    RETURN 0;

END;$$

LANGUAGE plpgsql