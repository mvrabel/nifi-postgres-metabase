CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_organization_i()
RETURNS INTEGER AS $$

    /*
    =====================================================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table organization_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =====================================================================================================================
    */

DECLARE

LEAD_CONTACT_FLAG TEXT := 'CONTACT';
LEAD_ORGANIZATION_FLAG TEXT:= 'ORGANIZATION';
CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
NULL_UTC_TIMESTAMP TIMESTAMP := to_timestamp(0)::TIMESTAMP AT TIME ZONE 'UTC';
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    ---------------------------------------------------------
    -- INSERT NULL ORGANIZATION IF NOT ALREADY IN DATABASE --
    ---------------------------------------------------------

    INSERT INTO core.organization_i (
        organization_id
        ,organization_key
        ,crm_id
        ,organization_type
        ,description
        ,industry
        ,number_of_employees
        ,partner
        ,website
        ,external_inteligence
        ,nda
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,region
        ,billing_country
        ,billing_state
        ,billing_city
        ,billing_zip
        ,billing_post_office_box
        ,billing_street
        ,shipping_country
        ,shipping_state
        ,shipping_city
        ,shipping_zip
        ,shipping_post_office_box
        ,shipping_street
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
        -1 -- organization_id
        ,'NULL_ORGANIZATION' -- organization_key
        ,-1 -- crm_id
        ,'' -- organization_type
        ,'' -- description
        ,'' -- industry
        ,0  -- number_of_employees
        ,'' -- partner
        ,'' -- website
        ,'' -- external_inteligence
        ,'' -- nda
        ,'' -- email
        ,'' -- secondary_email
        ,'' -- phone
        ,'' -- mobile_phone
        ,'' -- region
        ,'' -- billing_country
        ,'' -- billing_state
        ,'' -- billing_city
        ,'' -- billing_zip
        ,'' -- billing_post_office_box
        ,'' -- billing_street
        ,'' -- shipping_country
        ,'' -- shipping_state
        ,'' -- shipping_city
        ,'' -- shipping_zip
        ,'' -- shipping_post_office_box
        ,'' -- shipping_street
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

    DROP TABLE IF EXISTS tmp_organization_i ;

    CREATE TEMPORARY TABLE tmp_organization_i (
        organization_key                    text NOT NULL
        ,crm_id                             integer NOT NULL
        ,organization_type                  text
        ,description                        text
        ,industry                           text
        ,number_of_employees                integer
        ,partner                            text
        ,website                            text
        ,external_inteligence               text
        ,nda                                text
        ,email                              text
        ,secondary_email                    text
        ,phone                              text
        ,mobile_phone                       text
        ,region                             text
        ,billing_country                    text
        ,billing_state                      text
        ,billing_city                       text
        ,billing_zip                        text
        ,billing_post_office_box            text
        ,billing_street                     text
        ,shipping_country                   text
        ,shipping_state                     text
        ,shipping_city                      text
        ,shipping_zip                       text
        ,shipping_post_office_box           text
        ,shipping_street                    text
        ,fk_party_id                        integer  NOT NULL
        ,fk_employee_id_assigned_to         integer  NOT NULL
        ,fk_employee_id_created_by          integer  NOT NULL
        ,fk_employee_id_last_modified_by    integer  NOT NULL
        ,created_timestamp                  TIMESTAMP WITH TIME ZONE NOT NULL
        ,last_modified_timestamp            TIMESTAMP WITH TIME ZONE  NOT NULL
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_deleted_in_source_system      BOOL NOT NULL
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
     );

    INSERT INTO tmp_organization_i (
        organization_key
        ,crm_id
        ,organization_type
        ,description
        ,industry
        ,number_of_employees
        ,partner
        ,website
        ,external_inteligence
        ,nda
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,region
        ,billing_country
        ,billing_state
        ,billing_city
        ,billing_zip
        ,billing_post_office_box
        ,billing_street
        ,shipping_country
        ,shipping_state
        ,shipping_city
        ,shipping_street
        ,shipping_zip
        ,shipping_post_office_box
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
        account.account_no AS organization_key
        ,crm.crmid
        ,account.account_type AS organization_type
        ,crm.description
        ,account.industry
        ,account.employees AS number_of_employees
        ,scf.cf_755 AS partner
        ,account.website
        ,scf.cf_839 AS external_inteligence
        ,scf.cf_813 AS nda
        ,account.email1 AS email
        ,account.email2 AS secondary_email
        ,account.phone
        ,null::text AS mobile_phone
        ,scf.cf_751 AS region
        ,bill_address.bill_country AS billing_country
        ,bill_address.bill_state AS billing_state
        ,bill_address.bill_city AS billing_city
        ,bill_address.bill_code AS billing_zip
        ,bill_address.bill_pobox AS billing_post_office_box
        ,bill_address.bill_street AS billing_street
        ,ship_address.ship_country AS shipping_country
        ,ship_address.ship_state AS shipping_state
        ,ship_address.ship_city AS shipping_city
        ,ship_address.ship_code AS shipping_zip
        ,ship_address.ship_pobox AS shipping_post_office_box
        ,ship_address.ship_street AS shipping_street
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
        COALESCE(account.account_type, '')
        || COALESCE(crm.description, '')
        || COALESCE(account.industry, '')
        || COALESCE(account.employees, 0)
        || COALESCE(scf.cf_755 , '')
        || COALESCE(account.website, '')
        || COALESCE(scf.cf_839 , '')
        || COALESCE(scf.cf_813 , '')
        || COALESCE(account.email1 , '')
        || COALESCE(account.email2, '')
        || COALESCE(account.phone       , '')
        || COALESCE(scf.cf_751 , '')
        || COALESCE(bill_address.bill_country , '')
        || COALESCE(bill_address.bill_state , '')
        || COALESCE(bill_address.bill_city, '')
        || COALESCE(bill_address.bill_code , '')
        || COALESCE(bill_address.bill_pobox, '')
        || COALESCE(bill_address.bill_street, '')
        || COALESCE(ship_address.ship_country , '')
        || COALESCE(ship_address.ship_state, '')
        || COALESCE(ship_address.ship_city, '')
        || COALESCE(ship_address.ship_street, '')
        || COALESCE(ship_address.ship_code, '')
        || COALESCE(ship_address.ship_pobox, '')
        || employee_assigned.employee_key
        || crm.deleted
        ) AS tech_row_hash
        ,account.tech_data_load_utc_timestamp
        ,account.tech_data_load_uuid
    FROM stage.vtiger_account_i AS account
    JOIN stage.vtiger_accountscf_i AS scf ON account.accountid = scf.accountid
    JOIN stage.vtiger_accountbillads_i AS bill_address ON account.accountid = bill_address.accountaddressid
    JOIN stage.vtiger_accountshipads_i AS ship_address ON account.accountid = ship_address.accountaddressid
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = account.accountid
    JOIN stage.vtiger_users_i AS user_assigned ON user_assigned.id = crm.smownerid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm.modifiedby
    JOIN core.employee_i AS employee_assigned ON employee_assigned.employee_key = user_assigned.user_name
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name
    JOIN core.party_i AS party ON account.account_no = party.party_key

    UNION ALL

    SELECT
        lead.lead_no || LEAD_ORGANIZATION_FLAG AS organization_key
        ,crm.crmid
        ,scf.cf_799 AS organization_type
        ,crm.description
        ,lead.industry
        ,null::integer AS number_of_employees
        ,null::text AS partner
        ,subdetail.website
        ,scf.cf_864 AS external_inteligence
        ,null::text AS nda
        ,lead.email
        ,lead.secondaryemail AS secondary_email
        ,lead_addr.phone
        ,lead_addr.mobile AS mobile_phone
        ,scf.cf_795 AS region
        ,lead_addr.country AS billing_country
        ,lead_addr."state" AS billing_state
        ,lead_addr.city AS billing_city
        ,lead_addr.code AS billing_zip
        ,lead_addr.pobox AS billing_post_office_box
        ,lead_addr.lane AS billing_street
        ,null::text AS shipping_country
        ,null::text AS shipping_state
        ,null::text AS shipping_city
        ,null::text AS shipping_street
        ,null::text AS shipping_zip
        ,null::text AS shipping_post_office_box
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
        COALESCE(scf.cf_799, '')
        || COALESCE(crm.description, '')
        || COALESCE(lead.industry, '')
        || COALESCE(subdetail.website, '')
        || COALESCE(scf.cf_795, '')
        || COALESCE(scf.cf_864, '')
        || COALESCE(lead.email, '')
        || COALESCE(lead.secondaryemail, '')
        || COALESCE(lead_addr.phone, '')
        || COALESCE(lead_addr.mobile, '')
        || COALESCE(lead_addr.country, '')
        || COALESCE(lead_addr."state", '')
        || COALESCE(lead_addr.city, '')
        || COALESCE(lead_addr.lane, '')
        || COALESCE(lead_addr.code, '')
        || COALESCE(lead_addr.pobox, '')
        || employee_assigned.employee_key
        || crm.deleted
        || lead.converted
        ) AS tech_row_hash
        ,lead.tech_data_load_utc_timestamp
        ,lead.tech_data_load_uuid
    FROM stage.vtiger_leaddetails_i AS lead
    JOIN stage.vtiger_leadaddress_i AS lead_addr ON lead.leadid = lead_addr.leadaddressid
    JOIN stage.vtiger_leadscf_i AS scf ON lead.leadid = scf.leadid
    JOIN stage.vtiger_leadsubdetails_i AS subdetail ON lead.leadid = subdetail.leadsubscriptionid
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = lead.leadid
    JOIN stage.vtiger_users_i AS user_assigned ON user_assigned.id = crm.smownerid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm.modifiedby
    JOIN core.employee_i AS employee_assigned ON employee_assigned.employee_key = user_assigned.user_name
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name
    JOIN core.party_i AS party ON lead.lead_no || LEAD_ORGANIZATION_FLAG = party.party_key;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.organization_i (
        organization_key
        ,crm_id
        ,organization_type
        ,description
        ,industry
        ,number_of_employees
        ,partner
        ,website
        ,external_inteligence
        ,nda
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,region
        ,billing_country
        ,billing_state
        ,billing_city
        ,billing_zip
        ,billing_post_office_box
        ,billing_street
        ,shipping_country
        ,shipping_state
        ,shipping_city
        ,shipping_zip
        ,shipping_post_office_box
        ,shipping_street
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
        tmp_organization_i.organization_key
        ,tmp_organization_i.crm_id
        ,tmp_organization_i.organization_type
        ,tmp_organization_i.description
        ,tmp_organization_i.industry
        ,tmp_organization_i.number_of_employees
        ,tmp_organization_i.partner
        ,tmp_organization_i.website
        ,tmp_organization_i.external_inteligence
        ,tmp_organization_i.nda
        ,tmp_organization_i.email
        ,tmp_organization_i.secondary_email
        ,tmp_organization_i.phone
        ,tmp_organization_i.mobile_phone
        ,tmp_organization_i.region
        ,tmp_organization_i.billing_country
        ,tmp_organization_i.billing_state
        ,tmp_organization_i.billing_city
        ,tmp_organization_i.billing_zip
        ,tmp_organization_i.billing_post_office_box
        ,tmp_organization_i.billing_street
        ,tmp_organization_i.shipping_country
        ,tmp_organization_i.shipping_state
        ,tmp_organization_i.shipping_city
        ,tmp_organization_i.shipping_zip
        ,tmp_organization_i.shipping_post_office_box
        ,tmp_organization_i.shipping_street
        ,tmp_organization_i.fk_party_id
        ,tmp_organization_i.fk_employee_id_assigned_to
        ,tmp_organization_i.fk_employee_id_created_by
        ,tmp_organization_i.fk_employee_id_last_modified_by
        ,tmp_organization_i.created_timestamp
        ,tmp_organization_i.last_modified_timestamp
        ,tmp_organization_i.tech_insert_function
        ,tmp_organization_i.tech_insert_utc_timestamp
        ,tmp_organization_i.tech_deleted_in_source_system
        ,tmp_organization_i.tech_row_hash
        ,tmp_organization_i.tech_data_load_utc_timestamp
        ,tmp_organization_i.tech_data_load_uuid
    FROM tmp_organization_i;

    RETURN 0;
END;$$

LANGUAGE plpgsql
