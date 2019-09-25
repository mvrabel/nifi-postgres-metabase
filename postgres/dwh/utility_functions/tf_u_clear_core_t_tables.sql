CREATE OR REPLACE FUNCTION core.tf_u_clear_core_t_tables()
RETURNS INTEGER AS $$

BEGIN

    DELETE FROM core.iso_3166_country_list_t;

    DELETE FROM core.email_campaign_opened_by_t;
    DELETE FROM core.email_campaign_recipient_t;
    DELETE FROM core.email_campaign_clicked_url_t;
    DELETE FROM core.email_campaign_bounced_email_t;
    DELETE FROM core.email_campaign_report_t;
    DELETE FROM core.list_segment_list_member_map_t;
    DELETE FROM core.mailing_list_member_t;
    DELETE FROM core.mailing_list_segment_t;
    DELETE FROM core.mailing_list_t;

    DELETE FROM core.sale_t;
    DELETE FROM core.c_partner_list_t;
    DELETE FROM core.c_revenue_type_t;

    DELETE FROM core.deal_change_log_t;
    DELETE FROM core.activity_t;
    DELETE FROM core.mail_message_t;
    DELETE FROM core.note_t;
    DELETE FROM core.deal_contact_map_t;
    DELETE FROM core.deal_t;

    DELETE FROM core.worklog_t;
    DELETE FROM core.issue_relation_map_t;
    DELETE FROM core.issue_comment_t;
    DELETE FROM core.issue_t;
    DELETE FROM core.release_t;
    DELETE FROM core.project_t;

    DELETE FROM core.contact_t;
    DELETE FROM core.organization_relation_t;
    DELETE FROM core.organization_t;
    DELETE FROM core.party_t;
    DELETE FROM core.employee_t;

    RETURN 0;

END;$$

LANGUAGE plpgsql
