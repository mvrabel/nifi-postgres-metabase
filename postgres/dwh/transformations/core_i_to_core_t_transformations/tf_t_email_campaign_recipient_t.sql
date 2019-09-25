CREATE OR REPLACE FUNCTION core.tf_t_email_campaign_recipient_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core email_campaign_recipient_i input table into core 'today' table email_campaign_recipient_t
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

    INSERT INTO core.email_campaign_recipient_t (
        email_campaign_recipient_id
        ,email_campaign_recipient_key
        ,fk_email_campaign_report_id
        ,email_address
        ,first_name
        ,last_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_email_campaign_recipient.email_campaign_recipient_id
        ,input_email_campaign_recipient.email_campaign_recipient_key
        ,input_email_campaign_recipient.fk_email_campaign_report_id
        ,input_email_campaign_recipient.email_address
        ,input_email_campaign_recipient.first_name
        ,input_email_campaign_recipient.last_name
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_email_campaign_recipient.tech_row_hash
        ,input_email_campaign_recipient.tech_data_load_utc_timestamp
        ,input_email_campaign_recipient.tech_data_load_uuid
    FROM core.email_campaign_recipient_i AS input_email_campaign_recipient
    WHERE input_email_campaign_recipient.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql

