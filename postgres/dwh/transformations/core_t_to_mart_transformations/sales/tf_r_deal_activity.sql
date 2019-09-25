CREATE OR REPLACE FUNCTION mart.tf_r_deal_activity()
RETURNS INTEGER AS $$

DECLARE

TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);

BEGIN

    WITH
    aggregated_emails AS (
        SELECT
            fk_deal_id
            ,subject
            ,sent_timestamp
            ,string_agg(DISTINCT from_email_address, ', ') AS from_email
            ,string_agg(DISTINCT to_email_address, ', ') AS to_email
            ,string_agg(DISTINCT cc_email_address, ', ') AS cc_email
            ,body_snippet
            ,body_url
            ,pipedrive_mail_message_id
            ,pipedrive_mail_thread_id
            ,read_flag
            ,fk_employee_id
        FROM core.mail_message_t
        WHERE fk_deal_id != - 1
        GROUP BY fk_deal_id
            ,subject
            ,sent_timestamp
            ,body_snippet
            ,body_url
            ,pipedrive_mail_message_id
            ,pipedrive_mail_thread_id
            ,read_flag
            ,fk_employee_id
        )
    INSERT INTO mart.deal_activity (
        source_system_link
        ,source_system
        ,activity_type
        ,activity_detail
        ,new_value
        ,previous_value
        ,activity_timestamp
        ,done_by
        ,from_email
        ,to_email
        ,pipedrive_deal_id
        )
    SELECT
        'https://YOUR_PIPEDRIVE_HOST/deal/'::TEXT || deal.pipedrive_id AS source_system_link
        ,'Pipedrive'::TEXT AS source_system
        ,'Deal Update'::TEXT AS activity_type
        ,change_log.field AS activity_detail
        ,change_log.new_value AS new_value
        ,change_log.old_value AS previous_value
        ,change_log.log_timestamp AS activity_timestamp
        ,employee.full_name AS done_by
        ,TEXT_NULL AS from_email
        ,TEXT_NULL AS to_email
        ,deal.pipedrive_id AS pipedrive_deal_id
    FROM core.deal_change_log_t AS change_log
    JOIN core.deal_t AS deal ON change_log.fk_deal_id = deal.deal_id
    JOIN core.employee_t AS employee ON change_log.fk_employee_id = employee.employee_id
    WHERE deal.deal_id != - 1

    UNION ALL

    SELECT
        'https://YOUR_PIPEDRIVE_HOST/deal/'::TEXT || deal.pipedrive_id AS source_system_link
        ,'Pipedrive'::TEXT AS source_system
        ,'Deal Email'::TEXT AS activity_type
        ,deal_mail_message.body_snippet AS activity_detail
        ,TEXT_NULL AS new_value
        ,TEXT_NULL AS previous_value
        ,deal_mail_message.sent_timestamp AS activity_timestamp
        ,employee.full_name AS done_by
        ,deal_mail_message.from_email
        ,deal_mail_message.to_email
        ,deal.pipedrive_id AS pipedrive_deal_id
    FROM aggregated_emails AS deal_mail_message
    JOIN core.deal_t AS deal ON deal_mail_message.fk_deal_id = deal.deal_id
    JOIN core.employee_t AS employee ON deal_mail_message.fk_employee_id = employee.employee_id
    WHERE deal.deal_id != - 1

    UNION ALL

    SELECT
        'https://YOUR_PIPEDRIVE_HOST/deal/'::TEXT || deal.pipedrive_id AS source_system_link
        ,'Pipedrive'::TEXT AS source_system
        ,'Deal Note'::TEXT AS activity_type
        ,deal_note.content AS activity_detail
        ,TEXT_NULL AS new_value
        ,TEXT_NULL AS previous_value
        ,deal_note.last_modified_timestamp AS activity_timestamp
        ,employee.full_name AS done_by
        ,TEXT_NULL AS from_email
        ,TEXT_NULL AS to_email
        ,deal.pipedrive_id AS pipedrive_deal_id
    FROM core.note_t AS deal_note
    JOIN core.deal_t AS deal ON deal_note.fk_deal_id = deal.deal_id
    JOIN core.employee_t AS employee ON deal_note.fk_employee_id = employee.employee_id
    WHERE deal.deal_id != - 1

    UNION ALL

    SELECT
        'https://YOUR_JIRA_HOST/browse/' || jira_issue.jira_key || '?focusedCommentId=' || jira_comment.issue_comment_key || '&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-' || jira_comment.issue_comment_key AS source_system_link
        ,'JIRA'::TEXT AS source_system
        ,'JIRA Comment'::TEXT AS activity_type
        ,jira_comment.body AS activity_detail
        ,TEXT_NULL AS new_value
        ,TEXT_NULL AS previous_value
        ,jira_comment.last_updated_timestamp AS activity_timestamp
        ,comment_creator.full_name AS done_by
        ,TEXT_NULL AS from_email
        ,TEXT_NULL AS to_email
        ,deal.pipedrive_id AS pipedrive_deal_id
    FROM core.deal_t AS deal
    JOIN core.issue_t AS jira_issue ON deal.fk_issue_id = jira_issue.issue_id
    JOIN core.issue_comment_t AS jira_comment ON jira_comment.fk_issue_id = jira_issue.issue_id
    JOIN core.employee_t AS comment_creator ON comment_creator.employee_id = jira_comment.fk_employee_id_updated_by
    WHERE deal.deal_id != - 1;

    RETURN 0;

END;$$

LANGUAGE plpgsql
