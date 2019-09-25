CREATE OR REPLACE FUNCTION core.tf_i_src_mailchimp_trg_email_campaign_bounced_email_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'mailchimp_*' tables into core input table email_campaign_bounced_email_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-08-13 (YYYY-MM-DD)
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

    INSERT INTO core.email_campaign_bounced_email_i (
        email_campaign_bounced_email_id
        ,email_campaign_bounced_email_key
        ,fk_email_campaign_report_id
        ,email_address
        ,bounce_type
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    VALUES (
        -1 -- email_campaign_bounced_email_id
        ,TEXT_NULL -- email_campaign_bounced_email_key
        ,-1 -- fk_email_campaign_report_id
        ,TEXT_NULL -- email_address
        ,TEXT_NULL -- bounce_type
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

    DROP TABLE IF EXISTS tmp_email_campaign_bounce_report;

    CREATE TEMPORARY TABLE tmp_email_campaign_bounce_report (
        email_campaign_bounced_email_key    TEXT NOT NULL
        ,email_address                      TEXT NOT NULL
        ,fk_email_campaign_report_id        INTEGER NOT NULL
        ,bounce_type                        TEXT NOT NULL
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
        ,tech_deleted_in_source_system      bool NOT NULL
     );

    INSERT INTO tmp_email_campaign_bounce_report (
        email_campaign_bounced_email_key
        ,fk_email_campaign_report_id
        ,email_address
        ,bounce_type
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        mailchimp_bounce_report.campaign_id || mailchimp_bounce_report.list_id || mailchimp_bounce_report.email_id AS email_campaign_bounced_email_key
        ,core_email_campaign_report.email_campaign_report_id AS fk_email_campaign_report_id
        ,mailchimp_bounce_report.email_address AS email_address
        ,mailchimp_bounce_report.activity_type AS bounce_type
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(mailchimp_bounce_report.email_address, '')
            || COALESCE(mailchimp_bounce_report.activity_type, '')
        ) AS tech_row_hash
        ,mailchimp_bounce_report.tech_data_load_utc_timestamp
        ,mailchimp_bounce_report.tech_data_load_uuid
    FROM stage.mailchimp_report_email_activity_i AS mailchimp_bounce_report
    JOIN core.email_campaign_report_i AS core_email_campaign_report ON core_email_campaign_report.email_campaign_report_key = mailchimp_bounce_report.campaign_id
    WHERE activity_action = 'bounce';

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.email_campaign_bounced_email_i (
        email_campaign_bounced_email_key
        ,fk_email_campaign_report_id
        ,email_address
        ,bounce_type
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_email_campaign_bounce_report.email_campaign_bounced_email_key
        ,tmp_email_campaign_bounce_report.fk_email_campaign_report_id
        ,tmp_email_campaign_bounce_report.email_address
        ,tmp_email_campaign_bounce_report.bounce_type
        ,tmp_email_campaign_bounce_report.tech_insert_function
        ,tmp_email_campaign_bounce_report.tech_insert_utc_timestamp
        ,tmp_email_campaign_bounce_report.tech_deleted_in_source_system
        ,tmp_email_campaign_bounce_report.tech_row_hash
        ,tmp_email_campaign_bounce_report.tech_data_load_utc_timestamp
        ,tmp_email_campaign_bounce_report.tech_data_load_uuid
    FROM tmp_email_campaign_bounce_report;

    RETURN 0;

END;$$

LANGUAGE plpgsql
