CREATE OR REPLACE FUNCTION core.tf_u_clear_core_i_tables()
RETURNS INTEGER AS $$

BEGIN

    DELETE FROM core.iso_3166_country_list_i;

    DELETE FROM core.email_campaign_opened_by_i;
    DELETE FROM core.email_campaign_recipient_i;
    DELETE FROM core.email_campaign_clicked_url_i;
    DELETE FROM core.email_campaign_bounced_email_i;
    DELETE FROM core.email_campaign_report_i;
    DELETE FROM core.list_segment_list_member_map_i;
    DELETE FROM core.mailing_list_member_i;
    DELETE FROM core.mailing_list_segment_i;
    DELETE FROM core.mailing_list_i;

    DELETE FROM core.sale_i;
    DELETE FROM core.c_partner_list_i;
    DELETE FROM core.c_revenue_type_i;
    
    DELETE FROM core.deal_change_log_i;
    DELETE FROM core.activity_i;
    DELETE FROM core.mail_message_i;
    DELETE FROM core.note_i;
    DELETE FROM core.deal_contact_map_i;
    DELETE FROM core.deal_i;

    DELETE FROM core.worklog_i;
    DELETE FROM core.issue_relation_map_i;
    DELETE FROM core.issue_comment_i;
    DELETE FROM core.issue_i;
    DELETE FROM core.release_i;
    DELETE FROM core.project_i;

    DELETE FROM core.contact_i;
    DELETE FROM core.organization_relation_i;
    DELETE FROM core.organization_i;
    DELETE FROM core.party_i;
    DELETE FROM core.employee_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
