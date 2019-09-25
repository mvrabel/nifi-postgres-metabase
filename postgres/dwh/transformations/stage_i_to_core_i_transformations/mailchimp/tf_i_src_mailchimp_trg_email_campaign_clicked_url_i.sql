CREATE OR REPLACE FUNCTION core.tf_i_src_mailchimp_trg_email_campaign_clicked_url_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'mailchimp_*' tables into core input table email_campaign_clicked_url_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-08-14 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
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

    INSERT INTO core.email_campaign_clicked_url_i (
        email_campaign_clicked_url_id
        ,email_campaign_clicked_url_key
        ,fk_email_campaign_report_id
        ,url
        ,clicks
        ,unique_clicks
        ,percentage_ot_total_clicks
        ,percentage_ot_unique_clicks
        ,last_click_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    VALUES (
        -1 -- email_campaign_clicked_url_id
        ,TEXT_NULL -- email_campaign_clicked_url_key
        ,-1 -- fk_email_campaign_report_id
        ,TEXT_NULL -- url
        ,-1 -- clicks
        ,-1 -- unique_clicks
        ,-1 -- percentage_ot_total_clicks
        ,-1 -- percentage_ot_unique_clicks
        ,TIMESTAMP_NEVER -- last_click_timestamp
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

    DROP TABLE IF EXISTS tmp_email_campaign_clicked_url;

    CREATE TEMPORARY TABLE tmp_email_campaign_clicked_url (
        email_campaign_clicked_url_key      TEXT NOT NULL
        ,fk_email_campaign_report_id        INTEGER NOT NULL
        ,url                                TEXT NOT NULL
        ,clicks                             INTEGER NOT NULL
        ,unique_clicks                      INTEGER NOT NULL
        ,percentage_ot_total_clicks         REAL NOT NULL
        ,percentage_ot_unique_clicks        REAL NOT NULL
        ,last_click_timestamp               TIMESTAMP WITH TIME ZONE
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
        ,tech_deleted_in_source_system      BOOL NOT NULL
    );

    INSERT INTO tmp_email_campaign_clicked_url (
        email_campaign_clicked_url_key
        ,fk_email_campaign_report_id
        ,url
        ,clicks
        ,unique_clicks
        ,percentage_ot_total_clicks
        ,percentage_ot_unique_clicks
        ,last_click_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        mailchimp_click_report.id AS email_campaign_clicked_url_key
        ,core_email_campaign_report.email_campaign_report_id AS fk_email_campaign_report_id
        ,mailchimp_click_report.url AS url
        ,mailchimp_click_report.total_clicks AS clicks
        ,mailchimp_click_report.unique_clicks AS unique_clicks
        ,mailchimp_click_report.click_percentage AS percentage_ot_total_clicks
        ,mailchimp_click_report.unique_click_percentage AS percentage_ot_unique_clicks
        ,CASE
            WHEN mailchimp_click_report.last_click <> '' THEN mailchimp_click_report.last_click::TIMESTAMP
            ELSE NULL
        END AS last_click_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(mailchimp_click_report.id, '')
            || COALESCE(mailchimp_click_report.campaign_id, '')
            || COALESCE(mailchimp_click_report.url, '')
            || COALESCE(mailchimp_click_report.total_clicks::TEXT, '')
            || COALESCE(mailchimp_click_report.click_percentage::TEXT, '')
            || COALESCE(mailchimp_click_report.unique_clicks::TEXT, '')
            || COALESCE(mailchimp_click_report.unique_click_percentage::TEXT, '')
            || COALESCE(mailchimp_click_report.last_click, '')
        ) AS tech_row_hash
        ,mailchimp_click_report.tech_data_load_utc_timestamp
        ,mailchimp_click_report.tech_data_load_uuid
    FROM stage.mailchimp_report_click_report_i AS mailchimp_click_report
    JOIN core.email_campaign_report_i AS core_email_campaign_report ON core_email_campaign_report.email_campaign_report_key = mailchimp_click_report.campaign_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.email_campaign_clicked_url_i (
        email_campaign_clicked_url_key
        ,fk_email_campaign_report_id
        ,url
        ,clicks
        ,unique_clicks
        ,percentage_ot_total_clicks
        ,percentage_ot_unique_clicks
        ,last_click_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_email_campaign_clicked_url.email_campaign_clicked_url_key
        ,tmp_email_campaign_clicked_url.fk_email_campaign_report_id
        ,tmp_email_campaign_clicked_url.url
        ,tmp_email_campaign_clicked_url.clicks
        ,tmp_email_campaign_clicked_url.unique_clicks
        ,tmp_email_campaign_clicked_url.percentage_ot_total_clicks
        ,tmp_email_campaign_clicked_url.percentage_ot_unique_clicks
        ,tmp_email_campaign_clicked_url.last_click_timestamp
        ,tmp_email_campaign_clicked_url.tech_insert_function
        ,tmp_email_campaign_clicked_url.tech_insert_utc_timestamp
        ,tmp_email_campaign_clicked_url.tech_deleted_in_source_system
        ,tmp_email_campaign_clicked_url.tech_row_hash
        ,tmp_email_campaign_clicked_url.tech_data_load_utc_timestamp
        ,tmp_email_campaign_clicked_url.tech_data_load_uuid
    FROM tmp_email_campaign_clicked_url;

    RETURN 0;

END;$$

LANGUAGE plpgsql
