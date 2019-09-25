CREATE OR REPLACE FUNCTION core.tf_t_email_campaign_bounced_email_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core email_campaign_bounced_email_i input table into core 'today' table email_campaign_bounced_email_t
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

    INSERT INTO core.email_campaign_bounced_email_t (
        email_campaign_bounced_email_id
        ,email_campaign_bounced_email_key
        ,fk_email_campaign_report_id
        ,bounce_type
        ,email_address
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_email_campaign_bounced_email.email_campaign_bounced_email_id
        ,input_email_campaign_bounced_email.email_campaign_bounced_email_key
        ,input_email_campaign_bounced_email.fk_email_campaign_report_id
        ,input_email_campaign_bounced_email.bounce_type
        ,input_email_campaign_bounced_email.email_address
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_email_campaign_bounced_email.tech_row_hash
        ,input_email_campaign_bounced_email.tech_data_load_utc_timestamp
        ,input_email_campaign_bounced_email.tech_data_load_uuid
    FROM core.email_campaign_bounced_email_i AS input_email_campaign_bounced_email
    WHERE input_email_campaign_bounced_email.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
