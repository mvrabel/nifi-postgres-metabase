CREATE OR REPLACE FUNCTION core.tf_i_stage_i_to_core_i_uber_transformation()
RETURNS INTEGER AS $$

BEGIN

    ---------------------------------------------------------------------------
    -- Populate Global Code List Tables That Have Generated Data | If Needed --
    ---------------------------------------------------------------------------

    IF (SELECT COUNT(*) FROM core.c_date_g) = 0 THEN
        PERFORM core.tf_g_c_date_g();
    END IF;

    IF (SELECT COUNT(*) FROM core.c_currency_g) = 0 THEN
        PERFORM core.tf_g_c_currency_g();
    END IF;

    IF (SELECT COUNT(*) FROM core.c_null_replacement_g) = 0 THEN
        PERFORM core.tf_g_c_null_replacement_g();
    END IF;

    --------------------------------------------------
    -- Insert New Rows Into Global Code List Tables --
    --------------------------------------------------

    PERFORM core.tf_i_src_cnb_trg_c_exchange_rate_g();
    PERFORM core.tf_g_c_contry_name_map_g();

    -------------------------------
    -- Populate Code List Tables --
    -------------------------------

    PERFORM core.tf_i_src_ocean_trg_c_partner_list_i();
    PERFORM core.tf_i_src_ocean_trg_c_revenue_type_i();

    ---------------------
    -- Reset Sequences --
    ---------------------

    PERFORM setval('core.seq_c_revenue_type_i_revenue_type_id', 1, FALSE);
    PERFORM setval('core.seq_c_partner_list_i_partner_list_id', 1, FALSE);
    PERFORM setval('core.seq_employee_i_employee_id', 1, FALSE);
    PERFORM setval('core.seq_party_i_party_id', 1, FALSE);
    PERFORM setval('core.seq_organization_i_organization_id', 1, FALSE);
    PERFORM setval('core.seq_organization_relation_i_organization_relation_id', 1, FALSE);
    PERFORM setval('core.seq_deal_i_deal_id', 1, FALSE);
    PERFORM setval('core.seq_deal_contact_map_i_deal_contact_map_id', 1, FALSE);
    PERFORM setval('core.seq_contact_i_contact_id', 1, FALSE);
    PERFORM setval('core.seq_project_i_project_id', 1, FALSE);
    PERFORM setval('core.seq_release_i_release_id', 1, FALSE);
    PERFORM setval('core.seq_issue_i_issue_id', 1, FALSE);
    PERFORM setval('core.seq_issue_comment_i_issue_comment_id', 1, FALSE);
    PERFORM setval('core.seq_issue_relation_map_i_issue_relation_map_id', 1, FALSE);
    PERFORM setval('core.seq_worklog_i_worklog_id', 1, FALSE);
    PERFORM setval('core.seq_sale_i_sale_id', 1, FALSE);
    PERFORM setval('core.seq_activity_i_activity_id', 1, FALSE);
    PERFORM setval('core.seq_deal_change_log_i_deal_change_log_id', 1, FALSE);
    PERFORM setval('core.seq_mail_message_i_mail_message_id', 1, FALSE);
    PERFORM setval('core.seq_note_i_note_id', 1, FALSE);
    PERFORM setval('core.seq_email_campaign_report_i', 1, FALSE);
    PERFORM setval('core.seq_email_campaign_recipient_i', 1, FALSE);
    PERFORM setval('core.seq_email_campaign_opened_by_i', 1, FALSE);
    PERFORM setval('core.seq_email_campaign_clicked_url_i', 1, FALSE);
    PERFORM setval('core.seq_email_campaign_bounced_email_i', 1, FALSE);
    PERFORM setval('core.seq_mailing_list_i', 1, FALSE);
    PERFORM setval('core.seq_mailing_list_segment_i', 1, FALSE);
    PERFORM setval('core.seq_mailing_list_member_i', 1, FALSE);
    PERFORM setval('core.seq_list_segment_list_member_map_i', 1, FALSE);
    PERFORM setval('core.seq_iso_3166_country_list_i_iso_3166_country_list_id', 1, FALSE);

    ------------------------
    -- ISO 3166 Countries --
    ------------------------

    PERFORM core.tf_i_src_rest_countries_trg_iso_3166_country_list_i();

    ----------
    -- JIRA --
    ----------

    PERFORM core.tf_i_src_jira_trg_employee_i();
    PERFORM core.tf_i_src_jira_trg_party_i();
    PERFORM core.tf_i_src_jira_trg_project_i();
    PERFORM core.tf_i_src_jira_trg_release_i();
    PERFORM core.tf_i_src_jira_trg_issue_i();
    PERFORM core.tf_i_src_jira_trg_issue_relation_map_i();
    PERFORM core.tf_i_src_jira_trg_worklog_i();
    PERFORM core.tf_i_src_jira_trg_issue_comment_i();

    ---------------
    -- PIPEDRIVE --
    ---------------

    PERFORM core.tf_i_src_pipedrive_trg_employee_i();
    PERFORM core.tf_i_src_pipedrive_trg_party_i();
    PERFORM core.tf_i_src_pipedrive_trg_organization_i();
    PERFORM core.tf_i_src_pipedrive_trg_organization_relation_i();
    PERFORM core.tf_i_src_pipedrive_trg_contact_i();
    PERFORM core.tf_i_src_pipedrive_trg_deal_i();
    PERFORM core.tf_i_src_pipedrive_trg_deal_contact_map_i();
    PERFORM core.tf_i_src_pipedrive_trg_deal_change_log_i();
    PERFORM core.tf_i_src_pipedrive_trg_activity_i();
    PERFORM core.tf_i_src_pipedrive_trg_note_i();
    PERFORM core.tf_i_src_pipedrive_trg_mail_message_i();

    -----------------------
    -- NextCloud / Ocean --
    -----------------------

    PERFORM core.tf_i_src_ocean_trg_sale_i();

    ---------------
    -- Mailchimp --
    ---------------

    PERFORM core.tf_i_src_mailchimp_trg_employee_i();
    PERFORM core.tf_i_src_mailchimp_trg_party_i();
    PERFORM core.tf_i_src_mailchimp_trg_mailing_list_i();
    PERFORM core.tf_i_src_mailchimp_trg_mailing_list_member_i();
    PERFORM core.tf_i_src_mailchimp_trg_mailing_list_segment_i();
    PERFORM core.tf_i_src_mailchimp_trg_list_segment_list_member_map_i();
    PERFORM core.tf_i_src_mailchimp_trg_email_campaign_report_i();
    PERFORM core.tf_i_src_mailchimp_trg_email_campaign_recipient_i();
    PERFORM core.tf_i_src_mailchimp_trg_email_campaign_opened_by_i();
    PERFORM core.tf_i_src_mailchimp_trg_email_campaign_clicked_url_i();
    PERFORM core.tf_i_src_mailchimp_trg_email_campaign_bounced_email_i();

    RETURN 0;

END;$$

LANGUAGE plpgsql

