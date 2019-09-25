CREATE OR REPLACE FUNCTION mart.tf_r_jira_support_issues_not_linked_with_pipedrive()
RETURNS INTEGER AS $$

DECLARE

ISSUE_TYPE_SUPPORT TEXT := 'Support';

BEGIN

    INSERT INTO mart.jira_support_issues_not_linked_with_pipedrive (
        jira_key
        ,summary
        ,status
        ,account
        ,customer
        ,link_to_issue
        )
    SELECT
        issue.jira_key
        ,issue.summary
        ,issue.status
        ,issue.account
        ,issue.customer
        ,'https://JIRA/browse/' || issue.jira_key AS link_to_issue
    FROM core.issue_t AS issue
    WHERE issue.issue_type = ISSUE_TYPE_SUPPORT
        AND issue.jira_key NOT IN (
            SELECT
                DISTINCT issue.jira_key
            FROM core.deal_t AS deal
            JOIN core.issue_t AS issue ON deal.fk_issue_id = issue.issue_id
            WHERE issue.issue_type = ISSUE_TYPE_SUPPORT
            );

    RETURN 0;
END;$$

LANGUAGE plpgsql;
