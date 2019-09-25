CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_email_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table email_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;

LEAD_CONTACT_FLAG TEXT := 'CONTACT';
LEAD_ORGANIZATION_FLAG TEXT:= 'ORGANIZATION';

ORGANIZATION_TABLE TEXT:= 'core.organization';
CONTACT_TABLE TEXT:= 'core.contact';
LOPP_TABLE TEXT:= 'core.lopp';
SERVICE_CONTRACT_TABLE TEXT:= 'core.service_contract';

stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack FROM 'function (.*?) line')::text;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_email_i;

    CREATE TEMPORARY TABLE tmp_email_i (
        email_key                       TEXT
        ,subject                        TEXT
        ,body                           TEXT
        ,recipients_list                _text
        ,cc_list                        _text
        ,bcc_list                       _text
        ,table_name_related_to      TEXT NOT NULL
        ,record_key_related_to          TEXT NOT NULL
        ,email_sender                   TEXT NOT NULL
        ,sent_timestamp                 TIMESTAMP WITH TIME ZONE NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_deleted_in_source_system  BOOL NOT NULL
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULL
    );

    WITH foo AS (
    SELECT
        email.emailid AS email_key
        ,activity.subject AS subject
        ,crm_entiry_email.description AS body
        ,string_to_array(regexp_replace(replace(substring(email.to_email,3,length(email.to_email)-4),'","', ','),'^,*',''),',')::_text  AS recipients_list
        ,string_to_array(regexp_replace(replace(substring(email.cc_email,3,length(email.cc_email)-4),'","', ','),'^,*',''),',')::_text  AS cc_list
        ,string_to_array(regexp_replace(replace(substring(email.bcc_email,3,length(email.bcc_email)-4),'","', ','),'^,*',''),',')::_text  AS bcc_list
        ,email.from_email::TEXT AS email_sender
        ,(activity.date_start || ' ' || time_start || ' ' || users.time_zone)::TIMESTAMP WITH TIME ZONE AS sent_timestamp
        ,unnest(regexp_matches(email.idlists, '([0-9]*)@', 'g'))::TEXT AS related_to
        ,FUNCTION_NAME::TEXT AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm_entiry_email.deleted::BOOL AS tech_deleted_in_source_system
        ,md5(
        COALESCE(activity.subject, '')
        || COALESCE(crm_entiry_email.description, '')
        || COALESCE(email.to_email, '')
        || COALESCE(email.cc_email, '')
        || COALESCE(email.bcc_email, '')
        || COALESCE(email.from_email, '')
        || COALESCE(activity.date_start, '')
        || COALESCE(activity.time_start, '')
        || COALESCE(email.idlists, '')
        || crm_entiry_email.deleted::TEXT
        ) AS tech_row_hash
        ,email.tech_data_load_utc_timestamp
        ,email.tech_data_load_uuid
    FROM stage.vtiger_emaildetails_i AS email
    JOIN stage.vtiger_activity_i AS activity ON activity.activityid = email.emailid
    JOIN stage.vtiger_crmentity_i AS crm_entiry_email ON crm_entiry_email.crmid = email.emailid
    JOIN stage.vtiger_users_i AS users ON users.id = crm_entiry_email.smownerid
    )
    INSERT INTO tmp_email_i (
        email_key
        ,subject
        ,body
        ,recipients_list
        ,cc_list
        ,bcc_list
        ,table_name_related_to
        ,record_key_related_to
        ,email_sender
        ,sent_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    -- comments FROM contacts
    )
    SELECT
        foo.email_key
        ,foo.subject
        ,foo.body
        ,foo.recipients_list
        ,foo.cc_list
        ,foo.bcc_list
        ,CONTACT_TABLE AS table_name_related_to
        ,stage_contact.contact_no AS record_key_related_to
        ,foo.email_sender
        ,foo.sent_timestamp
        ,foo.tech_insert_function
        ,foo.tech_insert_utc_timestamp
        ,foo.tech_deleted_in_source_system
        ,foo.tech_row_hash
        ,foo.tech_data_load_utc_timestamp
        ,foo.tech_data_load_uuid
    FROM foo
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = foo.related_to::integer AND crm.setype = 'Contacts'
    JOIN stage.vtiger_contactdetails_i AS stage_contact ON stage_contact.contactid = crm.crmid
    JOIN core.contact_i AS core_contact ON core_contact.contact_key = stage_contact.contact_no
    WHERE foo.related_to != ''

    UNION ALL
    -- comments FROM potentials
    SELECT
        foo.email_key
        ,foo.subject
        ,foo.body
        ,foo.recipients_list
        ,foo.cc_list
        ,foo.bcc_list
        ,LOPP_TABLE AS table_name_related_to
        ,potential.potential_no AS record_key_related_to
        ,foo.email_sender
        ,foo.sent_timestamp
        ,foo.tech_insert_function
        ,foo.tech_insert_utc_timestamp
        ,foo.tech_deleted_in_source_system
        ,foo.tech_row_hash
        ,foo.tech_data_load_utc_timestamp
        ,foo.tech_data_load_uuid
    FROM foo
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = foo.related_to::integer AND crm.setype = 'Potentials'
    JOIN stage.vtiger_potential_i AS potential ON potential.potentialid = crm.crmid
    WHERE foo.related_to != ''

    UNION ALL
    -- comments FROM leads
    SELECT
        foo.email_key
        ,foo.subject
        ,foo.body
        ,foo.recipients_list
        ,foo.cc_list
        ,foo.bcc_list
        ,LOPP_TABLE AS table_name_related_to
        ,lead.lead_no AS record_key_related_to
        ,foo.email_sender
        ,foo.sent_timestamp
        ,foo.tech_insert_function
        ,foo.tech_insert_utc_timestamp
        ,foo.tech_deleted_in_source_system
        ,foo.tech_row_hash
        ,foo.tech_data_load_utc_timestamp
        ,foo.tech_data_load_uuid
    FROM foo
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = foo.related_to::INTEGER AND crm.setype = 'Leads'
    JOIN stage.vtiger_leaddetails_i AS lead ON lead.leadid = crm.crmid
    WHERE foo.related_to != ''

    UNION ALL
    -- comments for contacts FROM leads
    SELECT
        foo.email_key
        ,foo.subject
        ,foo.body
        ,foo.recipients_list
        ,foo.cc_list
        ,foo.bcc_list
        ,CONTACT_TABLE AS table_name_related_to
        ,lead.lead_no || LEAD_CONTACT_FLAG AS record_key_related_to
        ,foo.email_sender
        ,foo.sent_timestamp
        ,foo.tech_insert_function
        ,foo.tech_insert_utc_timestamp
        ,foo.tech_deleted_in_source_system
        ,foo.tech_row_hash
        ,foo.tech_data_load_utc_timestamp
        ,foo.tech_data_load_uuid
    FROM foo
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = foo.related_to::INTEGER AND crm.setype = 'Leads'
    JOIN stage.vtiger_leaddetails_i AS lead ON lead.leadid = crm.crmid
    WHERE foo.related_to != ''

    UNION ALL
    -- comments for organization FROM leads
    SELECT
        foo.email_key
        ,foo.subject
        ,foo.body
        ,foo.recipients_list
        ,foo.cc_list
        ,foo.bcc_list
        ,ORGANIZATION_TABLE AS table_name_related_to
        ,lead.lead_no || LEAD_ORGANIZATION_FLAG AS record_key_related_to
        ,foo.email_sender
        ,foo.sent_timestamp
        ,foo.tech_insert_function
        ,foo.tech_insert_utc_timestamp
        ,foo.tech_deleted_in_source_system
        ,foo.tech_row_hash
        ,foo.tech_data_load_utc_timestamp
        ,foo.tech_data_load_uuid
    FROM foo
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = foo.related_to::INTEGER AND crm.setype = 'Leads'
    JOIN stage.vtiger_leaddetails_i AS lead ON lead.leadid = crm.crmid
    WHERE foo.related_to != ''

    UNION ALL
    -- comments FROM service contracts
    SELECT
        foo.email_key
        ,foo.subject
        ,foo.body
        ,foo.recipients_list
        ,foo.cc_list
        ,foo.bcc_list
        ,SERVICE_CONTRACT_TABLE AS table_name_related_to
        --service contract doens't have a code so we use CRM_ID as a UID. -> therefore we can JOIN core table ON stage crm table directly.
        ,crm.crmid::text AS record_key_related_to
        ,foo.email_sender
        ,foo.sent_timestamp
        ,foo.tech_insert_function
        ,foo.tech_insert_utc_timestamp
        ,foo.tech_deleted_in_source_system
        ,foo.tech_row_hash
        ,foo.tech_data_load_utc_timestamp
        ,foo.tech_data_load_uuid
    FROM foo
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = foo.related_to::INTEGER AND crm.setype = 'ServiceContracts'
    WHERE foo.related_to != ''

    UNION ALL
    -- comments FROM Accounts
    SELECT
        foo.email_key
        ,foo.subject
        ,foo.body
        ,foo.recipients_list
        ,foo.cc_list
        ,foo.bcc_list
        ,ORGANIZATION_TABLE as table_name_related_to
        ,account.account_no as record_key_related_to
        ,foo.email_sender
        ,foo.sent_timestamp
        ,foo.tech_insert_function
        ,foo.tech_insert_utc_timestamp
        ,foo.tech_deleted_in_source_system
        ,foo.tech_row_hash
        ,foo.tech_data_load_utc_timestamp
        ,foo.tech_data_load_uuid
    FROM foo
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = foo.related_to::INTEGER AND crm.setype = 'Accounts'
    JOIN stage.vtiger_account_i AS account ON account.accountid = crm.crmid
    WHERE foo.related_to != '';

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.email_i (
        email_key
        ,subject
        ,body
        ,recipients_list
        ,cc_list
        ,bcc_list
        ,table_name_related_to
        ,record_key_related_to
        ,email_sender
        ,sent_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_email_i.email_key
        ,tmp_email_i.subject
        ,tmp_email_i.body
        ,tmp_email_i.recipients_list
        ,tmp_email_i.cc_list
        ,tmp_email_i.bcc_list
        ,tmp_email_i.table_name_related_to
        ,tmp_email_i.record_key_related_to
        ,tmp_email_i.email_sender
        ,tmp_email_i.sent_timestamp
        ,tmp_email_i.tech_insert_function
        ,tmp_email_i.tech_insert_utc_timestamp
        ,tmp_email_i.tech_deleted_in_source_system
        ,tmp_email_i.tech_row_hash
        ,tmp_email_i.tech_data_load_utc_timestamp
        ,tmp_email_i.tech_data_load_uuid
    FROM tmp_email_i;

    RETURN 0;
END;$$

LANGUAGE plpgsql
