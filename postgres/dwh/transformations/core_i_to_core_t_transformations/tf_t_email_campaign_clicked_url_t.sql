CREATE OR REPLACE FUNCTION core.tf_t_email_campaign_clicked_url_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core email_campaign_clicked_url_i input table into core 'today' table email_campaign_clicked_url_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-21 (YYYY-MM-DD)
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

    INSERT INTO core.email_campaign_clicked_url_t (
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
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_email_campaign_clicked_url.email_campaign_clicked_url_id
        ,input_email_campaign_clicked_url.email_campaign_clicked_url_key
        ,input_email_campaign_clicked_url.fk_email_campaign_report_id
        ,input_email_campaign_clicked_url.url
        ,input_email_campaign_clicked_url.clicks
        ,input_email_campaign_clicked_url.unique_clicks
        ,input_email_campaign_clicked_url.percentage_ot_total_clicks
        ,input_email_campaign_clicked_url.percentage_ot_unique_clicks
        ,input_email_campaign_clicked_url.last_click_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_email_campaign_clicked_url.tech_row_hash
        ,input_email_campaign_clicked_url.tech_data_load_utc_timestamp
        ,input_email_campaign_clicked_url.tech_data_load_uuid
    FROM core.email_campaign_clicked_url_i AS input_email_campaign_clicked_url
    WHERE input_email_campaign_clicked_url.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
