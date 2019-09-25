CREATE OR REPLACE FUNCTION core.tf_t_email_campaign_report_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core email_campaign_report_i input table into core 'today' table email_campaign_report_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-15 (YYYY-MM-DD)
    NOTE:
    =================================================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    ----------------------------------------------------
    -- INSERT RECORDS FROM INPUT TABLE TO TODAY TABLE --
    ----------------------------------------------------

    INSERT INTO core.email_campaign_report_t (
        email_campaign_report_id
        ,email_campaign_report_key
        ,mailchimp_id
        ,mailchimp_web_id
        ,campaign_title
        ,campaign_type
        ,sent_to_mailing_list
        ,sent_to_mailing_list_segment_filter
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_send_date
        ,send_timestamp
        ,emails_sent_total
        ,abuse_reports_total
        ,unsubscribed_total
        ,hard_bounces_total
        ,soft_bounces_total
        ,syntax_error_bounce_total
        ,forwards_total
        ,forwards_opens_total
        ,opens_total
        ,unique_opens_total
        ,total_open_to_unique_open_rate
        ,fk_date_id_last_open_date
        ,last_open_timestamp
        ,clicks_total
        ,unique_clicks_total
        ,total_clicks_to_unique_clicks_rate
        ,unique_subscriiber_clicks_total
        ,fk_date_id_last_click_date
        ,last_click_timestamp
        ,industry_type
        ,industry_open_to_unique_open_rate
        ,industry_click_to_unique_click_rate
        ,industry_bounce_rate
        ,industry_unopen_rate
        ,industry_unsub_rate
        ,industry_abuse_rate
        ,was_timewarp_used
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_email_campaign.email_campaign_report_id
        ,input_email_campaign.email_campaign_report_key
        ,input_email_campaign.mailchimp_id
        ,input_email_campaign.mailchimp_web_id
        ,input_email_campaign.campaign_title
        ,input_email_campaign.campaign_type
        ,input_email_campaign.sent_to_mailing_list
        ,input_email_campaign.sent_to_mailing_list_segment_filter
        ,input_email_campaign.fk_date_id_created_date
        ,input_email_campaign.created_timestamp
        ,input_email_campaign.fk_date_id_send_date
        ,input_email_campaign.send_timestamp
        ,input_email_campaign.emails_sent_total
        ,input_email_campaign.abuse_reports_total
        ,input_email_campaign.unsubscribed_total
        ,input_email_campaign.hard_bounces_total
        ,input_email_campaign.soft_bounces_total
        ,input_email_campaign.syntax_error_bounce_total
        ,input_email_campaign.forwards_total
        ,input_email_campaign.forwards_opens_total
        ,input_email_campaign.opens_total
        ,input_email_campaign.unique_opens_total
        ,input_email_campaign.total_open_to_unique_open_rate
        ,input_email_campaign.fk_date_id_last_open_date
        ,input_email_campaign.last_open_timestamp
        ,input_email_campaign.clicks_total
        ,input_email_campaign.unique_clicks_total
        ,input_email_campaign.total_clicks_to_unique_clicks_rate
        ,input_email_campaign.unique_subscriiber_clicks_total
        ,input_email_campaign.fk_date_id_last_click_date
        ,input_email_campaign.last_click_timestamp
        ,input_email_campaign.industry_type
        ,input_email_campaign.industry_open_to_unique_open_rate
        ,input_email_campaign.industry_click_to_unique_click_rate
        ,input_email_campaign.industry_bounce_rate
        ,input_email_campaign.industry_unopen_rate
        ,input_email_campaign.industry_unsub_rate
        ,input_email_campaign.industry_abuse_rate
        ,input_email_campaign.was_timewarp_used
        ,input_email_campaign.tech_insert_function
        ,input_email_campaign.tech_insert_utc_timestamp
        ,input_email_campaign.tech_row_hash
        ,input_email_campaign.tech_data_load_utc_timestamp
        ,input_email_campaign.tech_data_load_uuid
    FROM core.email_campaign_report_i AS input_email_campaign
    WHERE input_email_campaign.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql

