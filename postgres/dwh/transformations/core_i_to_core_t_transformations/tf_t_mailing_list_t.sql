CREATE OR REPLACE FUNCTION core.tf_t_mailing_list_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core mailing_list_i input table into core 'today' table mailing_list_t
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

    INSERT INTO core.mailing_list_t (
        mailing_list_id
        ,mailing_list_key
        ,mailchimp_id
        ,mailchimp_id_web_id
        ,mailing_list_name
        ,notify_on_subscribe_email
        ,notify_on_unsubscribe_email
        ,fk_date_id_created_date
        ,created_timestamp
        ,subscribe_url_short
        ,subscribe_url_long
        ,visibility
        ,double_optin
        ,marketing_permissions
        ,member_count
        ,unsubscribe_count
        ,cleaned_count
        ,member_count_since_last_campaign
        ,unsubscribe_count_last_campaign
        ,cleaned_count_last_campaign
        ,campaign_count
        ,fk_date_id_last_sent_date
        ,campaign_last_sent_timestamp
        ,merge_field_count
        ,avg_sub_rate
        ,avg_unsub_rate
        ,target_sub_rate
        ,open_rate
        ,click_rate
        ,fk_date_id_last_sub_date
        ,last_sub_timestamp
        ,fk_date_id_last_unsub_date
        ,last_unsub_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_mailing_list.mailing_list_id
        ,input_mailing_list.mailing_list_key
        ,input_mailing_list.mailchimp_id
        ,input_mailing_list.mailchimp_id_web_id
        ,input_mailing_list.mailing_list_name
        ,input_mailing_list.notify_on_subscribe_email
        ,input_mailing_list.notify_on_unsubscribe_email
        ,input_mailing_list.fk_date_id_created_date
        ,input_mailing_list.created_timestamp
        ,input_mailing_list.subscribe_url_short
        ,input_mailing_list.subscribe_url_long
        ,input_mailing_list.visibility
        ,input_mailing_list.double_optin
        ,input_mailing_list.marketing_permissions
        ,input_mailing_list.member_count
        ,input_mailing_list.unsubscribe_count
        ,input_mailing_list.cleaned_count
        ,input_mailing_list.member_count_since_last_campaign
        ,input_mailing_list.unsubscribe_count_last_campaign
        ,input_mailing_list.cleaned_count_last_campaign
        ,input_mailing_list.campaign_count
        ,input_mailing_list.fk_date_id_last_sent_date
        ,input_mailing_list.campaign_last_sent_timestamp
        ,input_mailing_list.merge_field_count
        ,input_mailing_list.avg_sub_rate
        ,input_mailing_list.avg_unsub_rate
        ,input_mailing_list.target_sub_rate
        ,input_mailing_list.open_rate
        ,input_mailing_list.click_rate
        ,input_mailing_list.fk_date_id_last_sub_date
        ,input_mailing_list.last_sub_timestamp
        ,input_mailing_list.fk_date_id_last_unsub_date
        ,input_mailing_list.last_unsub_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_mailing_list.tech_row_hash
        ,input_mailing_list.tech_data_load_utc_timestamp
        ,input_mailing_list.tech_data_load_uuid
    FROM core.mailing_list_i AS input_mailing_list
    WHERE input_mailing_list.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
