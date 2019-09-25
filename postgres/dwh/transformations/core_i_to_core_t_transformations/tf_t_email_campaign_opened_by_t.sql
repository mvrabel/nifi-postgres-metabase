CREATE OR REPLACE FUNCTION core.tf_t_email_campaign_opened_by_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core email_campaign_opened_by_i input table into core 'today' table email_campaign_opened_by_t
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

    INSERT INTO core.email_campaign_opened_by_t (
        email_campaign_opened_by_id
        ,email_campaign_opened_by_key
        ,fk_email_campaign_report_id
        ,email_address
        ,opens_count
        ,open_timestamps
        ,first_name
        ,last_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        input_email_campaign_opened_by.email_campaign_opened_by_id
        ,input_email_campaign_opened_by.email_campaign_opened_by_key
        ,input_email_campaign_opened_by.fk_email_campaign_report_id
        ,input_email_campaign_opened_by.email_address
        ,input_email_campaign_opened_by.opens_count
        ,input_email_campaign_opened_by.open_timestamps
        ,input_email_campaign_opened_by.first_name
        ,input_email_campaign_opened_by.last_name
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_email_campaign_opened_by.tech_row_hash
        ,input_email_campaign_opened_by.tech_data_load_utc_timestamp
        ,input_email_campaign_opened_by.tech_data_load_uuid
    FROM core.email_campaign_opened_by_i AS input_email_campaign_opened_by
    WHERE input_email_campaign_opened_by.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
