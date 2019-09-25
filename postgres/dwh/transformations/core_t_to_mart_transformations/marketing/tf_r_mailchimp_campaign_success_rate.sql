CREATE OR REPLACE FUNCTION mart.tf_r_mailchimp_campaign_success_rate()
RETURNS INTEGER AS $$

BEGIN

    INSERT INTO mart.mailchimp_campaign_success_rate (
        campaign_title
        ,campaign_type
        ,used_timewarp
        ,total_open_to_unique_open_rate
        ,unique_opens_total
        ,opens_total
        ,send_timestamp
        ,sent_to_mailing_list
        ,optional_mailing_list_segment_filter
        ,avg_list_open_rate
        )
    SELECT
        campaign_report.campaign_title
        ,campaign_report.campaign_type
        ,campaign_report.was_timewarp_used AS used_timewarp
        ,campaign_report.total_open_to_unique_open_rate
        ,campaign_report.unique_opens_total
        ,campaign_report.opens_total
        ,campaign_report.send_timestamp
        ,campaign_report.sent_to_mailing_list
        ,campaign_report.sent_to_mailing_list_segment_filter AS optional_mailing_list_segment_filter
        ,list.open_rate AS avg_list_open_rate        
    FROM core.email_campaign_report_t AS campaign_report
    LEFT JOIN core.mailing_list_t AS list ON list.mailing_list_name = sent_to_mailing_list;

    RETURN 0;

END;$$

LANGUAGE plpgsql
