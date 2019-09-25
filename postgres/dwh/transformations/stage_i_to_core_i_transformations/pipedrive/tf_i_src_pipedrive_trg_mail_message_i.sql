CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_mail_message_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table mail_message_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-11-13 (YYYY-MM-DD)
    NOTE:               
    ===========================================================================================================
    */

DECLARE

PERSON_KEY_PREFIX TEXT := 'PIPEDRIVE_PERSON_';
CONTACT_KEY_PREFIX TEXT := 'PIPEDRIVE_CONTACT_';
ORGANIZATION_KEY_PREFIX TEXT := 'PIPEDRIVE_ORGANIZATION_';
DEAL_KEY_PREFIX TEXT := 'PIPEDRIVE_DEAL_';
EMPLOYEE_KEY_PREFIX TEXT := 'PIPEDRIVE_EMPLOYEE_';
CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
stack TEXT;
FUNCTION_NAME TEXT;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::TEXT;

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.mail_message_i (
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
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    VALUES (
        -1 -- mail_message_id
        ,TEXT_NULL -- mail_message_key
        ,-1 -- fk_deal_id
        ,-1 -- fk_date_id_sent_date
        ,TIMESTAMP_NEVER -- sent_timestamp
        ,TEXT_NULL -- from_email_address
        ,-1 -- fk_contact_id_from
        ,TEXT_NULL -- to_email_address
        ,-1 -- fk_contact_id_to
        ,TEXT_NULL -- cc_email_address
        ,-1 -- fk_contact_id_cc
        ,TEXT_NULL -- bcc_email_address
        ,-1 -- fk_contact_id_bcc
        ,TEXT_NULL -- body_url
        ,-1 -- fk_employee_id
        ,TEXT_NULL -- subject
        ,TEXT_NULL -- body_snippet
        ,FALSE -- read_flag
        ,-1 -- pipedrive_mail_message_id
        ,-1 -- pipedrive_mail_thread_id
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

    DROP TABLE IF EXISTS tmp_mail_message_i;

    CREATE TEMPORARY TABLE tmp_mail_message_i ( 	
        mail_message_key                TEXT  NOT NULL,
        fk_deal_id                      INTEGER  NOT NULL,
        fk_date_id_sent_date            INTEGER  NOT NULL,
        sent_timestamp                  TIMESTAMP WITH TIME ZONE  NOT NULL,
        from_email_address              TEXT NOT NULL,
        fk_contact_id_from              INTEGER  NOT NULL,
        to_email_address                TEXT NOT NULL,
        fk_contact_id_to                INTEGER  NOT NULL,
        cc_email_address                TEXT NOT NULL,
        fk_contact_id_cc                INTEGER  NOT NULL,
        bcc_email_address               TEXT NOT NULL,
        fk_contact_id_bcc               INTEGER  NOT NULL,
        body_url                        TEXT NOT NULL,
        fk_employee_id                  INTEGER  NOT NULL,
        subject                         TEXT  NOT NULL,
        body_snippet                    TEXT  NOT NULL,
        read_flag                       BOOL  NOT NULL,
        pipedrive_mail_message_id       INTEGER  NOT NULL,
        pipedrive_mail_thread_id        INTEGER  NOT NULL,
        tech_insert_function            TEXT  NOT NULL,
        tech_insert_utc_timestamp       BIGINT  NOT NULL,
        tech_row_hash                   TEXT  NOT NULL,
        tech_data_load_utc_timestamp    BIGINT  NOT NULL,
        tech_data_load_uuid             TEXT  NOT NULL,
        tech_deleted_in_source_system   BOOL NOT NULL	
    );

    INSERT INTO tmp_mail_message_i (
        mail_message_key
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
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT 
        (pipedrive_mail_message.id + (floor(random() * 1000 + 1)::int)) mail_message_key
        ,COALESCE(deal.deal_id, -1) AS fk_deal_id
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer("timestamp"), -1) AS fk_date_id_sent_date
        ,COALESCE("timestamp"::TIMESTAMP WITH TIME ZONE, TIMESTAMP_NEVER) AS sent_timestamp
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_mail_message.from_email_address) AS from_email_address
        ,COALESCE(contact_from.contact_id, -1) AS fk_contact_id_from
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_mail_message.to_email_address) AS to_email_address
        ,COALESCE(contact_to.contact_id, -1) AS fk_contact_id_to
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_mail_message.cc_email_address) AS cc_email_address
        ,COALESCE(contact_cc.contact_id, -1) AS fk_contact_id_cc
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_mail_message.bcc_email_address) AS bcc_email_address
        ,COALESCE(contact_bcc.contact_id, -1) AS fk_contact_id_bcc
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_mail_message.body_url) AS body_url
        ,COALESCE(employee.employee_id, -1) fk_employee_id
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_mail_message.subject) AS subject
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_mail_message.snippet) AS body_snippet
        ,pipedrive_mail_message.read_flag::BOOL AS read_flag
        ,COALESCE(pipedrive_mail_message.id, -1) AS pipedrive_mail_message_id
        ,COALESCE(pipedrive_mail_message.mail_thread_id, -1) AS pipedrive_mail_thread_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
        COALESCE(pipedrive_mail_message.deal_id::TEXT, '')
        || COALESCE(pipedrive_mail_message."timestamp"::TEXT, '')
        || COALESCE(pipedrive_mail_message.from_linked_person_id::TEXT, '')
        || COALESCE(pipedrive_mail_message.to_linked_person_id::TEXT, '')
        || COALESCE(pipedrive_mail_message.cc_linked_person_id::TEXT, '')
        || COALESCE(pipedrive_mail_message.bcc_linked_person_id::TEXT, '')
        || COALESCE(pipedrive_mail_message.from_email_address::TEXT, '')
        || COALESCE(pipedrive_mail_message.to_email_address::TEXT, '')
        || COALESCE(pipedrive_mail_message.cc_email_address::TEXT, '')
        || COALESCE(pipedrive_mail_message.bcc_email_address::TEXT, '')
        || COALESCE(pipedrive_mail_message.id::TEXT, '')
        || COALESCE(pipedrive_mail_message.mail_thread_id::TEXT, '')
        ) AS tech_row_hash
        ,pipedrive_mail_message.tech_data_load_utc_timestamp
        ,pipedrive_mail_message.tech_data_load_uuid
    FROM stage.pipedrive_deal_mail_message_i AS pipedrive_mail_message
    LEFT JOIN core.deal_i AS deal ON deal.deal_key = DEAL_KEY_PREFIX || pipedrive_mail_message.deal_id
    LEFT JOIN core.contact_i AS contact_to ON contact_to.contact_key = CONTACT_KEY_PREFIX || pipedrive_mail_message.to_linked_person_id
    LEFT JOIN core.contact_i AS contact_from ON contact_from.contact_key = CONTACT_KEY_PREFIX || pipedrive_mail_message.from_linked_person_id
    LEFT JOIN core.contact_i AS contact_cc ON contact_cc.contact_key = CONTACT_KEY_PREFIX || pipedrive_mail_message.cc_linked_person_id
    LEFT JOIN core.contact_i AS contact_bcc ON contact_bcc.contact_key = CONTACT_KEY_PREFIX || pipedrive_mail_message.bcc_linked_person_id
    LEFT JOIN core.employee_i AS employee ON employee.employee_key = EMPLOYEE_KEY_PREFIX || pipedrive_mail_message.user_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.mail_message_i (
       mail_message_key
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
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        tmp_mail_message_i.mail_message_key
        ,tmp_mail_message_i.fk_deal_id
        ,tmp_mail_message_i.fk_date_id_sent_date
        ,tmp_mail_message_i.sent_timestamp
        ,tmp_mail_message_i.from_email_address
        ,tmp_mail_message_i.fk_contact_id_from
        ,tmp_mail_message_i.to_email_address
        ,tmp_mail_message_i.fk_contact_id_to
        ,tmp_mail_message_i.cc_email_address
        ,tmp_mail_message_i.fk_contact_id_cc
        ,tmp_mail_message_i.bcc_email_address
        ,tmp_mail_message_i.fk_contact_id_bcc
        ,tmp_mail_message_i.body_url
        ,tmp_mail_message_i.fk_employee_id
        ,tmp_mail_message_i.subject
        ,tmp_mail_message_i.body_snippet
        ,tmp_mail_message_i.read_flag
        ,tmp_mail_message_i.pipedrive_mail_message_id
        ,tmp_mail_message_i.pipedrive_mail_thread_id
        ,tmp_mail_message_i.tech_insert_function
        ,tmp_mail_message_i.tech_insert_utc_timestamp
        ,tmp_mail_message_i.tech_deleted_in_source_system
        ,tmp_mail_message_i.tech_row_hash
        ,tmp_mail_message_i.tech_data_load_utc_timestamp
        ,tmp_mail_message_i.tech_data_load_uuid
    FROM tmp_mail_message_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
