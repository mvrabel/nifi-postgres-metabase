CREATE OR REPLACE FUNCTION mart.tf_r_bugs_per_component_per_release()
RETURNS INTEGER AS $$

DECLARE

TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
COMMON_COMPONENT_FLAG TEXT[] := '{Common}';
BUSINESS_INTELLIGENCE_PROJECT_KEY TEXT := 'BI';
HELP_DESK_PROJECT_KEY TEXT := 'HD';
DEVELOPMENT_PROJECT_KEY TEXT := 'DEV';
SUPPORT_ISSUE_FLAG TEXT := 'Support';
FEATURE_ISSUE_FLAG TEXT := 'Feature';
ACTIVITY_ISSUE_FLAG TEXT := 'Activity';
TASK_ISSUE_FLAG TEXT := 'Task';
BUG_ISSUE_FLAG TEXT := 'Bug';

BEGIN

    WITH issue AS (
        SELECT
            CASE
                WHEN issue.components = TEXT_ARRAY_NULL THEN COMMON_COMPONENT_FLAG
                ELSE issue.components
            END AS components
            ,issue.fix_versions
            ,project.project_name AS project_name
            ,project.jira_key AS project_jira_key
            ,created_timestamp
            ,resolution_timestamp
        FROM core.issue_t AS issue
        JOIN core.project_t AS project ON project.project_id = issue.fk_project_id
        WHERE issue.issue_type = BUG_ISSUE_FLAG
            AND project.jira_key = DEVELOPMENT_PROJECT_KEY
            AND NOT issue.fix_versions = TEXT_ARRAY_NULL
    )
    ,unnested_components AS (
        SELECT
            unnest(components) AS component
            ,fix_versions
            ,project_jira_key
            ,project_name
            ,1 AS bugs_number
            ,created_timestamp
            ,resolution_timestamp
        FROM issue
    )
    ,unnested_components_and_versions AS (
        SELECT 
            component
            ,unnest(fix_versions) AS fix_version
            ,project_jira_key
            ,project_name
            ,1 AS bugs_number
            ,created_timestamp
            ,resolution_timestamp
        FROM unnested_components
    )
    INSERT INTO mart.report_bugs_per_component_pre_release (
        project_key
        ,release_name
        ,release_number
        ,component
        ,bugs_number
        ,bug_created_at
        ,bug_resolved_at
        )
    SELECT
        project_jira_key
        ,fix_version AS release_name
        ,SUBSTRING(fix_version from 2 )::INTEGER AS release_number
        ,component
        ,bugs_number
        ,created_timestamp
        ,resolution_timestamp
    FROM unnested_components_and_versions;

    RETURN 0;

END;$$

LANGUAGE plpgsql
