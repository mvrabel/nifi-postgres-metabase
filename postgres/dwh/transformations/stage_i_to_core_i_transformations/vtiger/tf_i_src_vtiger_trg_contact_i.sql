CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_contact_i()
RETURNS INTEGER AS $$

    /*
    =============================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table contact_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =============================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
NULL_UTC_TIMESTAMP TIMESTAMP := to_timestamp(0)::TIMESTAMP AT TIME ZONE 'UTC';
stack text;
FUNCTION_NAME text;

LEAD_CONTACT_FLAG TEXT := 'CONTACT';
LEAD_ORGANIZATION_FLAG TEXT:= 'ORGANIZATION';

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.contact_i (
        contact_id
        ,contact_key
        ,crm_id
        ,salutation
        ,fk_organization_id
        ,title
        ,department
        ,reference
        ,lead_source
        ,lead_source_details
        ,profesional_profile
        ,external_inteligence
        ,description
        ,flag_do_not_contact
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,mailing_country
        ,mailing_state
        ,mailing_city
        ,mailing_zip
        ,mailing_post_office_box
        ,mailing_street
        ,fk_party_id
        ,fk_employee_id_assigned_to
        ,fk_employee_id_created_by
        ,fk_employee_id_last_modified_by
        ,created_timestamp
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
        -1 -- contact_id
        ,'NULL_CONTACT' -- contact_key
        ,0 -- crm_id
        ,'' -- salutation
        ,-1 -- fk_organization_id
        ,'' -- title
        ,'' -- department
        ,'' -- reference
        ,'' -- lead_source
        ,'' -- lead_source_details
        ,'' -- profesional_profile
        ,'' -- external_inteligence
        ,'' -- description
        ,TRUE -- flag_do_not_contact
        ,'' -- email
        ,'' -- secondary_email
        ,'' -- phone
        ,'' -- mobile_phone
        ,'' -- mailing_country
        ,'' -- mailing_state
        ,'' -- mailing_city
        ,'' -- mailing_zip
        ,'' -- mailing_post_office_box
        ,'' -- mailing_street
        ,-1 -- fk_party_id
        ,-1 -- fk_employee_id_assigned_to
        ,-1 -- fk_employee_id_created_by
        ,-1 -- fk_employee_id_last_modified_by
        ,NULL_UTC_TIMESTAMP -- created_timestamp
        ,NULL_UTC_TIMESTAMP -- last_modified_timestamp
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,'' -- tech_row_hash
        ,0 -- tech_data_load_utc_timestamp
        ,'' -- tech_data_load_uuid
    ) ON CONFLICT DO NOTHING;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_contact_i;

    CREATE TEMPORARY TABLE tmp_contact_i (
        contact_key                         TEXT NOT NULL
        ,crm_id                             INTEGER NOT NULL
        ,salutation                         TEXT
        ,fk_organization_id                 INTEGER NOT NULL
        ,title                              TEXT
        ,department                         TEXT
        ,reference                          TEXT
        ,lead_source                        TEXT
        ,lead_source_details                TEXT
        ,profesional_profile                TEXT
        ,external_inteligence               TEXT
        ,description                        TEXT
        ,flag_do_not_contact                bool
        ,email                              TEXT
        ,secondary_email                    TEXT
        ,phone                              TEXT
        ,mobile_phone                       TEXT
        ,fk_party_id                        INTEGER NOT NULL
        ,mailing_country                    TEXT
        ,mailing_state                      TEXT
        ,mailing_city                       TEXT
        ,mailing_zip                        TEXT
        ,mailing_post_office_box            TEXT
        ,mailing_street                     TEXT
        ,fk_employee_id_assigned_to         INTEGER NOT NULL
        ,fk_employee_id_created_by          INTEGER NOT NULL
        ,fk_employee_id_last_modified_by    INTEGER NOT NULL
        ,created_timestamp                  timestamptz NOT NULL
        ,last_modified_timestamp            timestamptz NOT NULL
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_deleted_in_source_system      BOOL NOT NULL
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
     );

    INSERT INTO tmp_contact_i (
        contact_key
        ,crm_id
        ,salutation
        ,fk_organization_id
        ,title
        ,department
        ,reference
        ,lead_source
        ,lead_source_details
        ,profesional_profile
        ,external_inteligence
        ,description
        ,flag_do_not_contact
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,mailing_country
        ,mailing_state
        ,mailing_city
        ,mailing_street
        ,mailing_zip
        ,mailing_post_office_box
        ,fk_party_id
        ,fk_employee_id_assigned_to
        ,fk_employee_id_created_by
        ,fk_employee_id_last_modified_by
        ,created_timestamp
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    --from contact
    SELECT
        contact.contact_no AS contact_key
        ,crm.crmid AS crm_id
        ,contact.salutation
        ,CASE WHEN organization.organization_id IS NULL THEN -1
            ELSE organization.organization_id
        END AS fk_organization_id
        ,contact.title AS title
        ,contact.department
        ,contact.reference
        ,subdetail.leadsource AS lead_source
        ,contact_custom_field.cf_787 AS lead_source_details
        ,contact_custom_field.cf_773 AS profesional_profile
        ,contact_custom_field.cf_843 AS external_inteligence
        ,crm.description
        ,contact.emailoptout::bool AS flag_do_not_contact
        ,contact.email AS email
        ,contact.secondaryemail AS secondary_email
        ,contact.phone AS phone
        ,contact.mobile AS mobile_phone
        ,address.mailingcountry AS mailing_country
        ,address.mailingstate AS mailing_state
        ,address.mailingcity AS mailing_city
        ,address.mailingstreet AS mailing_street
        ,address.mailingzip AS mailing_zip
        ,address.mailingpobox AS mailing_post_office_box
        ,party.party_id AS fk_party_id
        ,employee_assigned.employee_id AS fk_employee_id_assigned_to
        ,employee_created.employee_id AS fk_employee_id_created_by
        ,employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,(crm.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,(crm.modifiedtime || ' ' || user_modified.time_zone)::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm.deleted::bool AS tech_deleted_in_source_system
        ,md5(
           COALESCE(contact.salutation, '')
        || COALESCE(organization.organization_key, '')
        || COALESCE(contact.title, '')
        || COALESCE(contact.department, '')
        || COALESCE(contact.reference, '')
        || COALESCE(subdetail.leadsource, '')
        || COALESCE(contact_custom_field.cf_787, '')
        || COALESCE(contact_custom_field.cf_773, '')
        || COALESCE(contact_custom_field.cf_843, '')
        || COALESCE(crm.description, '')
        || COALESCE(contact.emailoptout, '')
        || COALESCE(contact.email, '')
        || COALESCE(contact.secondaryemail, '')
        || COALESCE(contact.phone, '')
        || COALESCE(contact.mobile, '')
        || COALESCE(address.mailingcountry, '')
        || COALESCE(address.mailingstreet, '')
        || COALESCE(address.mailingpobox, '')
        || COALESCE(address.mailingcity, '')
        || COALESCE(address.mailingzip, '')
        || COALESCE(address.mailingstate)
        || employee_assigned.employee_key
        || employee_created.employee_key
        || crm.deleted
        ) AS tech_row_hash
        ,contact.tech_data_load_utc_timestamp
        ,contact.tech_data_load_uuid
    FROM stage.vtiger_contactdetails_i AS contact
    JOIN stage.vtiger_contactsubdetails_i AS subdetail ON subdetail.contactsubscriptionid = contact.contactid
    JOIN stage.vtiger_contactscf_i AS contact_custom_field ON contact_custom_field.contactid = contact.contactid
    JOIN stage.vtiger_contactaddress_i AS address ON address.contactaddressid = contact.contactid
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = contact.contactid
    JOIN stage.vtiger_users_i AS user_assigned ON user_assigned.id = crm.smownerid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm.modifiedby
    JOIN core.employee_i AS employee_assigned ON employee_assigned.employee_key = user_assigned.user_name
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name
    JOIN pg_timezone_names AS tz_created ON tz_created.name = user_created.time_zone
    JOIN pg_timezone_names AS tz_modified ON tz_modified.name = user_modified.time_zone
    JOIN core.party_i AS party ON contact.contact_no = party.party_key
    LEFT JOIN stage.vtiger_account_i AS account ON account.accountid = contact.accountid
    LEFT JOIN core.organization_i AS organization ON organization.organization_key = account.account_no

    UNION ALL

    --from lead
    SELECT
        lead.lead_no || LEAD_CONTACT_FLAG AS contact_key
        ,crm.crmid AS crm_id
        ,lead.salutation
        ,CASE WHEN organization.organization_id IS NULL THEN -1
            ELSE organization.organization_id
        END AS fk_organization_id
        ,lead.designation AS title
        ,null::text AS department
        ,lead_custom_field.cf_757 AS reference
        ,lead.leadsource AS lead_source
        ,lead_custom_field.cf_791 AS lead_source_details
        ,lead_custom_field.cf_771 AS profesional_profile
        ,lead_custom_field.cf_864 AS external_inteligence
        ,crm.description
        ,false AS flag_do_not_contact --lead doesn't have this flag so we set it to TRUE
        ,lead.email AS email
        ,lead.secondaryemail AS secondary_email
        ,address.phone AS phone
        ,address.mobile AS mobile_phone
        ,address.country AS mailing_country
        ,address."state" AS mailing_state
        ,address.city AS mailing_city
        ,address.lane AS mailing_street
        ,address.code AS mailing_zip
        ,address.pobox AS mailing_post_office_box
        ,party.party_id AS fk_party_id
        ,employee_assigned.employee_id AS fk_employee_id_assigned_to
        ,employee_created.employee_id AS fk_employee_id_created_by
        ,employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,(crm.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,(crm.modifiedtime || ' ' || user_modified.time_zone)::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm.deleted::bool OR lead.converted::bool AS tech_deleted_in_source_system
        ,md5(
           COALESCE(lead.salutation, '')
        || COALESCE(organization.organization_key, '')
        || COALESCE(lead.designation, '')
        || COALESCE(lead_custom_field.cf_757, '')
        || COALESCE(lead.leadsource, '')
        || COALESCE(lead_custom_field.cf_791, '')
        || COALESCE(lead_custom_field.cf_771, '')
        || COALESCE(lead_custom_field.cf_864, '')
        || COALESCE(crm.description, '')
        || COALESCE(lead.email, '')
        || COALESCE(lead.secondaryemail, '')
        || COALESCE(address.phone, '')
        || COALESCE(address.mobile, '')
        || COALESCE(address.country, '')
        || COALESCE(address."state" )
        || COALESCE(address.city, '')
        || COALESCE(address.lane, '')
        || COALESCE(address.code, '')
        || COALESCE(address.pobox, '')
        || employee_assigned.employee_key
        || employee_created.employee_key
        || crm.deleted
        || lead.converted
        ) AS tech_row_hash
        ,lead.tech_data_load_utc_timestamp
        ,lead.tech_data_load_uuid
    FROM stage.vtiger_leaddetails_i AS lead
    JOIN stage.vtiger_leadaddress_i AS address ON address.leadaddressid = lead.leadid
    JOIN stage.vtiger_leadscf_i AS lead_custom_field ON lead.leadid = lead_custom_field.leadid
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = lead.leadid
    JOIN stage.vtiger_users_i AS user_assigned ON user_assigned.id = crm.smownerid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm.modifiedby
    JOIN core.employee_i AS employee_assigned ON employee_assigned.employee_key = user_assigned.user_name
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name
    JOIN core.party_i AS party ON lead.lead_no || LEAD_CONTACT_FLAG = party.party_key
    LEFT JOIN core.organization_i AS organization ON organization.organization_key = lead.lead_no || LEAD_ORGANIZATION_FLAG;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.contact_i (
        contact_key
        ,crm_id
        ,salutation
        ,fk_organization_id
        ,title
        ,department
        ,reference
        ,lead_source
        ,lead_source_details
        ,profesional_profile
        ,external_inteligence
        ,description
        ,flag_do_not_contact
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,mailing_country
        ,mailing_state
        ,mailing_city
        ,mailing_zip
        ,mailing_post_office_box
        ,mailing_street
        ,fk_party_id
        ,fk_employee_id_assigned_to
        ,fk_employee_id_created_by
        ,fk_employee_id_last_modified_by
        ,created_timestamp
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_contact_i.contact_key
        ,tmp_contact_i.crm_id
        ,tmp_contact_i.salutation
        ,tmp_contact_i.fk_organization_id
        ,tmp_contact_i.title
        ,tmp_contact_i.department
        ,tmp_contact_i.reference
        ,tmp_contact_i.lead_source
        ,tmp_contact_i.lead_source_details
        ,tmp_contact_i.profesional_profile
        ,tmp_contact_i.external_inteligence
        ,tmp_contact_i.description
        ,tmp_contact_i.flag_do_not_contact
        ,tmp_contact_i.email
        ,tmp_contact_i.secondary_email
        ,tmp_contact_i.phone
        ,tmp_contact_i.mobile_phone
        ,tmp_contact_i.mailing_country
        ,tmp_contact_i.mailing_state
        ,tmp_contact_i.mailing_city
        ,tmp_contact_i.mailing_zip
        ,tmp_contact_i.mailing_post_office_box
        ,tmp_contact_i.mailing_street
        ,tmp_contact_i.fk_party_id
        ,tmp_contact_i.fk_employee_id_assigned_to
        ,tmp_contact_i.fk_employee_id_created_by
        ,tmp_contact_i.fk_employee_id_last_modified_by
        ,tmp_contact_i.created_timestamp
        ,tmp_contact_i.last_modified_timestamp
        ,tmp_contact_i.tech_insert_function
        ,tmp_contact_i.tech_insert_utc_timestamp
        ,tmp_contact_i.tech_deleted_in_source_system
        ,tmp_contact_i.tech_row_hash
        ,tmp_contact_i.tech_data_load_utc_timestamp
        ,tmp_contact_i.tech_data_load_uuid
    FROM tmp_contact_i;

    RETURN 0;
END;$$

LANGUAGE plpgsql
