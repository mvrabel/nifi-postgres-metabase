CREATE OR REPLACE FUNCTION core.tf_t_mail_message_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:    Insert data from core mail_message_i input table into core 'today' table mail_message_t
    AUTHOR:         Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:     2018-05-21 (YYYY-MM-DD)
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

    INSERT INTO core.mail_message_t (
        mail_message_id
        ,mail_message_key
        ,fk_deal_id
        ,fk_date_id_sent_date
        ,sent_timestamp
        ,from_email_address
        ,fk_contact_id_from
        ,to_email_address
        ,fk_contact_id_to
        ,cc_email_address
        ,fk_contact_id_cc
        ,bcc_email_address
        ,fk_contact_id_bcc
        ,body_url
        ,fk_employee_id
        ,subject
        ,body_snippet
        ,read_flag
        ,pipedrive_mail_message_id
        ,pipedrive_mail_thread_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_mail_message.mail_message_id
        ,input_mail_message.mail_message_key
        ,COALESCE(input_deal.deal_id, -1) AS fk_deal_id
        ,input_mail_message.fk_date_id_sent_date
        ,input_mail_message.sent_timestamp
        ,input_mail_message.from_email_address
        ,input_contact_from.contact_id AS fk_contact_id_from
        ,input_mail_message.to_email_address
        ,input_contact_to.contact_id AS fk_contact_id_to
        ,input_mail_message.cc_email_address
        ,input_contact_cc.contact_id AS fk_contact_id_cc
        ,input_mail_message.bcc_email_address
        ,input_contact_bcc.contact_id AS fk_contact_id_bcc
        ,input_mail_message.body_url
        ,COALESCE(input_employee.employee_id, -1) AS fk_employee_id
        ,input_mail_message.subject
        ,input_mail_message.body_snippet
        ,input_mail_message.read_flag
        ,input_mail_message.pipedrive_mail_message_id
        ,input_mail_message.pipedrive_mail_thread_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_mail_message.tech_row_hash
        ,input_mail_message.tech_data_load_utc_timestamp
        ,input_mail_message.tech_data_load_uuid
    FROM core.mail_message_i AS input_mail_message
    LEFT JOIN core.deal_i AS input_deal ON input_mail_message.fk_deal_id = input_deal.deal_id
        AND input_deal.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.contact_i AS input_contact_from ON input_mail_message.fk_contact_id_from = input_contact_from.contact_id
        AND input_contact_from.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.contact_i AS input_contact_to ON input_mail_message.fk_contact_id_to = input_contact_to.contact_id
        AND input_contact_to.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.contact_i AS input_contact_cc ON input_mail_message.fk_contact_id_cc = input_contact_cc.contact_id
        AND input_contact_cc.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.contact_i AS input_contact_bcc ON input_mail_message.fk_contact_id_bcc = input_contact_bcc.contact_id
        AND input_contact_bcc.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.employee_i AS input_employee ON input_mail_message.fk_employee_id = input_employee.employee_id
        AND input_employee.tech_deleted_in_source_system IS FALSE
    WHERE input_mail_message.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
