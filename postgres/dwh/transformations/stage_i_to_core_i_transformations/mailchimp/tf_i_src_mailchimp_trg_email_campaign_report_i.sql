CREATE OR REPLACE FUNCTION core.tf_i_src_mailchimp_trg_email_campaign_report_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'mailchimp_*' tables into core input table email_campaign_report_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-07-03 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.email_campaign_report_i (
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
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    VALUES (
        -1 -- email_campaign_report_id
        ,TEXT_NULL -- email_campaign_report_key
        ,TEXT_NULL -- mailchimp_id
        ,-1 -- mailchimp_web_id
        ,TEXT_NULL -- campaign_title
        ,TEXT_NULL -- campaign_type
        ,TEXT_NULL -- sent_to_mailing_list
        ,TEXT_NULL -- sent_to_mailing_list_segment_filter
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
        ,-1 -- fk_date_id_send_date
        ,TIMESTAMP_NEVER -- send_timestamp
        ,-1 -- emails_sent_total
        ,-1 -- abuse_reports_total
        ,-1 -- unsubscribed_total
        ,-1 -- hard_bounces_total
        ,-1 -- soft_bounces_total
        ,-1 -- syntax_error_bounce_total
        ,-1 -- forwards_total
        ,-1 -- forwards_opens_total
        ,-1 -- opens_total
        ,-1 -- unique_opens_total
        ,-1 -- total_open_to_unique_open_rate
        ,-1 -- fk_date_id_last_open_date
        ,TIMESTAMP_NEVER -- last_open_timestamp
        ,-1 -- clicks_total
        ,-1 -- unique_clicks_total
        ,-1 -- total_clicks_to_unique_clicks_rate
        ,-1 -- unique_subscriiber_clicks_total
        ,-1 -- fk_date_id_last_click_date
        ,TIMESTAMP_NEVER -- last_click_timestamp
        ,-1 -- industry_type
        ,-1 -- industry_open_to_unique_open_rate
        ,-1 -- industry_click_to_unique_click_rate
        ,-1 -- industry_bounce_rate
        ,-1 -- industry_unopen_rate
        ,-1 -- industry_unsub_rate
        ,-1 -- industry_abuse_rate
        ,FALSE -- was_timewarp_used
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,TEXT_NULL -- tech_row_hash
        ,-1 -- tech_data_load_utc_timestamp
        ,TEXT_NULL -- tech_data_load_uuid
    ) ON CONFLICT DO NOTHING;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_email_campaign_report;

    CREATE TEMPORARY TABLE tmp_email_campaign_report (
        email_campaign_report_key               text  NOT NULL
        ,mailchimp_id                           text
        ,mailchimp_web_id                       integer
        ,campaign_title                         text  NOT NULL
        ,campaign_type                          text  NOT NULL
        ,sent_to_mailing_list                   text
        ,sent_to_mailing_list_segment_filter    text
        ,fk_date_id_created_date                integer not null
        ,created_timestamp                      timestamp with time zone
        ,fk_date_id_send_date                   integer NOT NULL
        ,send_timestamp                         timestamp with time zone NOT NULL
        ,emails_sent_total                      integer  NOT NULL
        ,abuse_reports_total                    integer  NOT NULL
        ,unsubscribed_total                     integer  NOT NULL
        ,hard_bounces_total                     integer  NOT NULL
        ,soft_bounces_total                     integer  NOT NULL
        ,syntax_error_bounce_total              integer
        ,forwards_total                         integer  NOT NULL
        ,forwards_opens_total                   integer  NOT NULL
        ,opens_total                            integer  NOT NULL
        ,unique_opens_total                     integer
        ,total_open_to_unique_open_rate         real
        ,fk_date_id_last_open_date              integer NOT NULL
        ,last_open_timestamp                    timestamp with time zone
        ,clicks_total                           integer  NOT NULL
        ,unique_clicks_total                    integer
        ,total_clicks_to_unique_clicks_rate     real
        ,unique_subscriiber_clicks_total        integer
        ,fk_date_id_last_click_date             integer not null
        ,last_click_timestamp                   timestamp with time zone
        ,industry_type                          text
        ,industry_open_to_unique_open_rate      real
        ,industry_click_to_unique_click_rate    real
        ,industry_bounce_rate                   real
        ,industry_unopen_rate                   real
        ,industry_unsub_rate                    real
        ,industry_abuse_rate                    real
        ,was_timewarp_used                      bool  NOT NULL
        ,tech_insert_function                   text  NOT NULL
        ,tech_insert_utc_timestamp              bigint  NOT NULL
        ,tech_row_hash                          text  NOT NULL
        ,tech_data_load_utc_timestamp           bigint  NOT NULL
        ,tech_data_load_uuid                    text  NOT NULL
        ,tech_deleted_in_source_system          bool  NOT NULL
     );

    INSERT INTO tmp_email_campaign_report (
        email_campaign_report_key
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
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
         mailchimp_campaign.id AS email_campaign_report_key
        ,mailchimp_campaign.id  AS mailchimp_id
        ,mailchimp_campaign.web_id  AS mailchimp_web_id
        ,mailchimp_campaign.settings_title AS campaign_title
        ,mailchimp_campaign."type"  AS campaign_type
        ,mailchimp_list.name AS sent_to_mailing_list
        ,regexp_replace(regexp_replace(mailchimp_campaign.recipients_segment_text, '<[^<]+>', '', 'gs'), '(For a total of [0-9]+ emails sent.)', '', 'gs') /* Remove Tags */ AS sent_to_mailing_list_segment_filter
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(mailchimp_campaign.create_time), -1) AS fk_date_id_created_date
        ,CASE
            WHEN mailchimp_campaign.create_time = '' THEN NULL
            ELSE mailchimp_campaign.create_time::TIMESTAMP WITH TIME ZONE
        END AS created_timestamp
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(mailchimp_report.send_time), -1) AS fk_date_id_send_date
        ,CASE
            WHEN mailchimp_report.send_time = '' THEN NULL
            ELSE mailchimp_report.send_time::TIMESTAMP WITH TIME ZONE
        END AS send_timestamp
        ,mailchimp_report.emails_sent AS emails_sent_total
        ,mailchimp_report.abuse_reports AS abuse_reports_total
        ,mailchimp_report.unsubscribed AS unsubscribed_total
        ,mailchimp_report.bounces_hard_bounces AS hard_bounces_total
        ,mailchimp_report.bounces_soft_bounces AS soft_bounces_total
        ,mailchimp_report.bounces_syntax_errors AS syntax_error_bounce_total
        ,mailchimp_report.forwards_forwards_count AS forwards_total
        ,mailchimp_report.forwards_forwards_opens AS forwards_opens_total
        ,mailchimp_report.opens_opens_total AS opens_total
        ,mailchimp_report.opens_unique_opens AS unique_opens_total
        ,mailchimp_report.opens_open_rate AS total_open_to_unique_open_rate
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(mailchimp_report.opens_last_open), -1) AS fk_date_id_last_open_date
        ,CASE
            WHEN mailchimp_report.opens_last_open = '' THEN NULL
            ELSE mailchimp_report.opens_last_open::TIMESTAMP WITH TIME ZONE
        END AS last_open_timestamp
        ,mailchimp_report.clicks_clicks_total AS clicks_total
        ,mailchimp_report.clicks_unique_clicks AS unique_clicks_total
        ,mailchimp_report.clicks_click_rate AS total_clicks_to_unique_clicks_rate
        ,mailchimp_report.clicks_unique_subscriber_clicks AS unique_subscriiber_clicks_total
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(mailchimp_report.clicks_last_click), -1) AS fk_date_id_last_click_date
        ,CASE
            WHEN mailchimp_report.clicks_last_click = '' THEN NULL
            ELSE mailchimp_report.clicks_last_click::TIMESTAMP WITH TIME ZONE
        END AS last_click_timestamp
        ,mailchimp_report.industry_stats_type AS industry_type
        ,mailchimp_report.industry_stats_open_rate AS industry_open_to_unique_open_rate
        ,mailchimp_report.industry_stats_click_rate AS industry_click_to_unique_click_rate
        ,mailchimp_report.industry_stats_bounce_rate AS industry_bounce_rate
        ,mailchimp_report.industry_stats_unopen_rate AS industry_unopen_rate
        ,mailchimp_report.industry_stats_unsub_rate AS industry_unsub_rate
        ,mailchimp_report.industry_stats_abuse_rate AS industry_abuse_rate
        ,mailchimp_campaign.settings_timewarp AS was_timewarp_used
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(mailchimp_campaign.id, '')
            || COALESCE(mailchimp_campaign.web_id::TEXT , '')
            || COALESCE(mailchimp_campaign.settings_title, '')
            || COALESCE(mailchimp_campaign.create_time, '')
            || COALESCE(mailchimp_campaign.recipients_list_id::TEXT, '')
            || COALESCE(mailchimp_campaign.recipients_segment_text, '')
            || COALESCE(mailchimp_campaign.status, '')
            || COALESCE(mailchimp_campaign.settings_timewarp::TEXT, '')
            || COALESCE(mailchimp_report.campaign_title, '')
            || COALESCE(mailchimp_report."type"::TEXT, '')
            || COALESCE(mailchimp_report.send_time, '')
            || COALESCE(mailchimp_report.subject_line, '')
            || COALESCE(mailchimp_report.emails_sent::TEXT, '')
            || COALESCE(mailchimp_report.abuse_reports::TEXT, '')
            || COALESCE(mailchimp_report.unsubscribed::TEXT, '')
            || COALESCE(mailchimp_report.bounces_hard_bounces::TEXT, '')
            || COALESCE(mailchimp_report.bounces_soft_bounces::TEXT, '')
            || COALESCE(mailchimp_report.bounces_syntax_errors::TEXT, '')
            || COALESCE(mailchimp_report.forwards_forwards_count::TEXT, '')
            || COALESCE(mailchimp_report.forwards_forwards_opens::TEXT, '')
            || COALESCE(mailchimp_report.opens_opens_total::TEXT, '')
            || COALESCE(mailchimp_report.opens_unique_opens::TEXT, '')
            || COALESCE(mailchimp_report.opens_open_rate::TEXT, '')
            || COALESCE(mailchimp_report.opens_last_open, '')
            || COALESCE(mailchimp_report.clicks_clicks_total::TEXT, '')
            || COALESCE(mailchimp_report.clicks_unique_clicks::TEXT, '')
            || COALESCE(mailchimp_report.clicks_unique_subscriber_clicks::TEXT, '')
            || COALESCE(mailchimp_report.clicks_click_rate::TEXT, '')
            || COALESCE(mailchimp_report.clicks_last_click, '')
            || COALESCE(mailchimp_report.industry_stats_type, '')
            || COALESCE(mailchimp_report.industry_stats_open_rate::TEXT, '')
            || COALESCE(mailchimp_report.industry_stats_click_rate::TEXT, '')
            || COALESCE(mailchimp_report.industry_stats_bounce_rate::TEXT, '')
            || COALESCE(mailchimp_report.industry_stats_unopen_rate::TEXT, '')
            || COALESCE(mailchimp_report.industry_stats_unsub_rate::TEXT, '')
            || COALESCE(mailchimp_report.industry_stats_abuse_rate::TEXT, '')
        ) AS tech_row_hash
        ,mailchimp_campaign.tech_data_load_utc_timestamp
        ,mailchimp_campaign.tech_data_load_uuid
    FROM stage.mailchimp_campaign_i AS mailchimp_campaign
    LEFT JOIN stage.mailchimp_report_i AS mailchimp_report ON mailchimp_report.id = mailchimp_campaign.id
    LEFT JOIN stage.mailchimp_list_i AS mailchimp_list ON mailchimp_list.id = mailchimp_campaign.recipients_list_id
    WHERE mailchimp_campaign.status = 'sent';

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.email_campaign_report_i (
        email_campaign_report_key
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
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_email_campaign_report.email_campaign_report_key
        ,tmp_email_campaign_report.mailchimp_id
        ,tmp_email_campaign_report.mailchimp_web_id
        ,tmp_email_campaign_report.campaign_title
        ,tmp_email_campaign_report.campaign_type
        ,tmp_email_campaign_report.sent_to_mailing_list
        ,tmp_email_campaign_report.sent_to_mailing_list_segment_filter
        ,tmp_email_campaign_report.fk_date_id_created_date
        ,tmp_email_campaign_report.created_timestamp
        ,tmp_email_campaign_report.fk_date_id_send_date
        ,tmp_email_campaign_report.send_timestamp
        ,tmp_email_campaign_report.emails_sent_total
        ,tmp_email_campaign_report.abuse_reports_total
        ,tmp_email_campaign_report.unsubscribed_total
        ,tmp_email_campaign_report.hard_bounces_total
        ,tmp_email_campaign_report.soft_bounces_total
        ,tmp_email_campaign_report.syntax_error_bounce_total
        ,tmp_email_campaign_report.forwards_total
        ,tmp_email_campaign_report.forwards_opens_total
        ,tmp_email_campaign_report.opens_total
        ,tmp_email_campaign_report.unique_opens_total
        ,tmp_email_campaign_report.total_open_to_unique_open_rate
        ,tmp_email_campaign_report.fk_date_id_last_open_date
        ,tmp_email_campaign_report.last_open_timestamp
        ,tmp_email_campaign_report.clicks_total
        ,tmp_email_campaign_report.unique_clicks_total
        ,tmp_email_campaign_report.total_clicks_to_unique_clicks_rate
        ,tmp_email_campaign_report.unique_subscriiber_clicks_total
        ,tmp_email_campaign_report.fk_date_id_last_click_date
        ,tmp_email_campaign_report.last_click_timestamp
        ,tmp_email_campaign_report.industry_type
        ,tmp_email_campaign_report.industry_open_to_unique_open_rate
        ,tmp_email_campaign_report.industry_click_to_unique_click_rate
        ,tmp_email_campaign_report.industry_bounce_rate
        ,tmp_email_campaign_report.industry_unopen_rate
        ,tmp_email_campaign_report.industry_unsub_rate
        ,tmp_email_campaign_report.industry_abuse_rate
        ,tmp_email_campaign_report.was_timewarp_used
        ,tmp_email_campaign_report.tech_insert_function
        ,tmp_email_campaign_report.tech_insert_utc_timestamp
        ,tmp_email_campaign_report.tech_deleted_in_source_system
        ,tmp_email_campaign_report.tech_row_hash
        ,tmp_email_campaign_report.tech_data_load_utc_timestamp
        ,tmp_email_campaign_report.tech_data_load_uuid
    FROM tmp_email_campaign_report;

    RETURN 0;

END;$$

LANGUAGE plpgsql
