CREATE OR REPLACE FUNCTION core.tf_t_mailing_list_member_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core mailing_list_member_i input table into core 'today' table mailing_list_member_t
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

    INSERT INTO core.mailing_list_member_t (
        mailing_list_member_id
        ,mailing_list_member_key
        ,mailchimp_id
        ,email_address
        ,mailchimp_unique_email_id
        ,status
        ,fk_party_id
        ,avg_open_rate
        ,avg_click_rate
        ,ip_address_signup
        ,fk_date_id_signup_date
        ,timestamp_signup
        ,ip_address_opt_in
        ,fk_date_id_opt_in_date
        ,timestamp_opt_in
        ,fk_date_id_last_changed_date
        ,last_changed_timestamp
        ,email_client
        ,location_latitude
        ,location_longitude
        ,location_country_code
        ,fk_mailing_list_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        input_mailing_list_member.mailing_list_member_id
        ,input_mailing_list_member.mailing_list_member_key
        ,input_mailing_list_member.mailchimp_id
        ,input_mailing_list_member.email_address
        ,input_mailing_list_member.mailchimp_unique_email_id
        ,input_mailing_list_member.status
        ,input_mailing_list_member.fk_party_id
        ,input_mailing_list_member.avg_open_rate
        ,input_mailing_list_member.avg_click_rate
        ,input_mailing_list_member.ip_address_signup
        ,input_mailing_list_member.fk_date_id_signup_date
        ,input_mailing_list_member.timestamp_signup
        ,input_mailing_list_member.ip_address_opt_in
        ,input_mailing_list_member.fk_date_id_opt_in_date
        ,input_mailing_list_member.timestamp_opt_in
        ,input_mailing_list_member.fk_date_id_last_changed_date
        ,input_mailing_list_member.last_changed_timestamp
        ,input_mailing_list_member.email_client
        ,input_mailing_list_member.location_latitude
        ,input_mailing_list_member.location_longitude
        ,input_mailing_list_member.location_country_code
        ,input_mailing_list_member.fk_mailing_list_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_mailing_list_member.tech_row_hash
        ,input_mailing_list_member.tech_data_load_utc_timestamp
        ,input_mailing_list_member.tech_data_load_uuid
    FROM core.mailing_list_member_i AS input_mailing_list_member
    WHERE input_mailing_list_member.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
