CREATE OR REPLACE FUNCTION core.tf_t_core_i_to_core_t_uber_transformation()
RETURNS INTEGER AS $$

BEGIN

    ------------------------
    -- Clear Today Tables --
    ------------------------

    PERFORM core.tf_u_clear_core_t_tables();

    ---------------------
    -- Reset Sequences --
    ---------------------

    PERFORM setval('core.seq_c_revenue_type_t_revenue_type_id', 1, FALSE);
    PERFORM setval('core.seq_c_partner_list_t_partner_list_id', 1, FALSE);
    PERFORM setval('core.seq_employee_t_employee_id', 1, FALSE);
    PERFORM setval('core.seq_party_t_party_id', 1, FALSE);
    PERFORM setval('core.seq_organization_t_organization_id', 1, FALSE);
    PERFORM setval('core.seq_organization_relation_t_organization_relation_id', 1, FALSE);
    PERFORM setval('core.seq_deal_t_deal_id', 1, FALSE);
    PERFORM setval('core.seq_deal_contact_map_t_deal_contact_map_id', 1, FALSE);
    PERFORM setval('core.seq_contact_t_contact_id', 1, FALSE);
    PERFORM setval('core.seq_project_t_project_id', 1, FALSE);
    PERFORM setval('core.seq_release_t_release_id', 1, FALSE);
    PERFORM setval('core.seq_issue_t_issue_id', 1, FALSE);
    PERFORM setval('core.seq_issue_comment_t_issue_comment_id', 1, FALSE);
    PERFORM setval('core.seq_issue_relation_map_t_issue_relation_map_id', 1, FALSE);
    PERFORM setval('core.seq_worklog_t_worklog_id', 1, FALSE);
    PERFORM setval('core.seq_sale_t_sale_id', 1, FALSE);
    PERFORM setval('core.seq_activity_t_activity_id', 1, FALSE);
    PERFORM setval('core.seq_deal_change_log_t_deal_change_log_id', 1, FALSE);
    PERFORM setval('core.seq_mail_message_t_mail_message_id', 1, FALSE);
    PERFORM setval('core.seq_note_t_note_id', 1, FALSE);
    PERFORM setval('core.seq_email_campaign_report_t', 1, FALSE);
    PERFORM setval('core.seq_email_campaign_recipient_t', 1, FALSE);
    PERFORM setval('core.seq_email_campaign_opened_by_t', 1, FALSE);
    PERFORM setval('core.seq_email_campaign_clicked_url_t', 1, FALSE);
    PERFORM setval('core.seq_email_campaign_bounced_email_t', 1, FALSE);
    PERFORM setval('core.seq_mailing_list_t', 1, FALSE);
    PERFORM setval('core.seq_mailing_list_segment_t', 1, FALSE);
    PERFORM setval('core.seq_mailing_list_member_t', 1, FALSE);
    PERFORM setval('core.seq_list_segment_list_member_map_t', 1, FALSE);
    PERFORM setval('core.seq_iso_3166_country_list_t_iso_3166_country_list_id', 1, FALSE);

    ----------------------
    -- CODE LIST TABLES --
    ----------------------

    PERFORM core.tf_t_c_partner_list_t();
    PERFORM core.tf_t_c_revenue_type_t();
    
    ------------------------
    -- ISO 3166 Countries --
    ------------------------

    PERFORM core.tf_t_iso_3166_country_list_t();

    ----------
    -- JIRA --
    ----------

    PERFORM core.tf_t_employee_t();
    PERFORM core.tf_t_party_t();
    PERFORM core.tf_t_project_t();
    PERFORM core.tf_t_release_t();
    PERFORM core.tf_t_issue_t();
    PERFORM core.tf_t_issue_relation_map_t();
    PERFORM core.tf_t_worklog_t();
    PERFORM core.tf_t_issue_comment_t();

    ---------------
    -- PIPEDRIVE --
    ---------------

    PERFORM core.tf_t_organization_t();
    PERFORM core.tf_t_organization_relation_t();
    PERFORM core.tf_t_contact_t();
    PERFORM core.tf_t_deal_t();
    PERFORM core.tf_t_deal_contact_map_t();
    PERFORM core.tf_t_deal_change_log_t();
    PERFORM core.tf_t_activity_t();
    PERFORM core.tf_t_note_t();
    PERFORM core.tf_t_mail_message_t();

    -----------------------
    -- NextCloud / Ocean --
    -----------------------

    PERFORM core.tf_t_sale_t();

    ---------------
    -- Mailchimp --
    ---------------

    PERFORM core.tf_t_mailing_list_t();
    PERFORM core.tf_t_mailing_list_member_t();
    PERFORM core.tf_t_mailing_list_segment_t();
    PERFORM core.tf_t_list_segment_list_member_map_t();
    PERFORM core.tf_t_email_campaign_report_t();
    PERFORM core.tf_t_email_campaign_recipient_t();
    PERFORM core.tf_t_email_campaign_opened_by_t();
    PERFORM core.tf_t_email_campaign_clicked_url_t();
    PERFORM core.tf_t_email_campaign_bounced_email_t();


    RETURN 0;

END;$$

LANGUAGE plpgsql

