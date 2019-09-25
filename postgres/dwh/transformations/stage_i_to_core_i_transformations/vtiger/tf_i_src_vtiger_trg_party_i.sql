CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_party_i()
RETURNS INTEGER AS $$

    /*
    =====================================================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table party_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =====================================================================================================================
    */

DECLARE

LEAD_CONTACT_FLAG TEXT := 'CONTACT';
LEAD_ORGANIZATION_FLAG TEXT:= 'ORGANIZATION';
CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
NULL_UTC_TIMESTAMP timestamp := to_timestamp(0)::timestamp at time zone 'UTC';
--PL/pgSQL function get_curr_fx_name() line 6 at GET DIAGNOSTICS
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.party_i (
        party_id
        ,party_key
        ,full_name
        ,short_name
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
        -1 -- party_id
        ,'NULL_PARTY' -- party_key
        ,'' -- full_name
        ,'' -- short_name
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

    DROP TABLE IF EXISTS tmp_party_i;

    CREATE TEMPORARY TABLE tmp_party_i (
        party_key                           TEXT NOT NULL
        ,full_name                          TEXT
        ,short_name                         TEXT
        ,fk_employee_id_last_modified_by    INTEGER NOT NULL
        ,fk_employee_id_created_by          INTEGER NOT NULL
        ,created_timestamp                  TIMESTAMP WITH TIME ZONE
        ,last_modified_timestamp            TIMESTAMP WITH TIME ZONE
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_deleted_in_source_system      BOOL NOT NULL
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
    );

    INSERT INTO tmp_party_i (
        party_key
        ,full_name
        ,short_name
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
    --from CRM accounts
    SELECT
        account.account_no AS party_key
        ,account.accountname AS full_name
        ,account.accountname AS short_name
        ,employee_created.employee_id AS fk_employee_id_created_by
        ,employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,(crm.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,(crm.modifiedtime || ' ' || user_modified.time_zone)::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm.deleted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(account.accountname, '')
        || crm.deleted
        ) AS tech_row_hash
        ,account.tech_data_load_utc_timestamp
        ,account.tech_data_load_uuid
    FROM stage.vtiger_account_i AS account
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = account.accountid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm.modifiedby
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name

    UNION ALL
    --from CRM contacts
    SELECT
        contact.contact_no AS party_key
        ,contact.firstname || ' ' || contact.lastname AS full_name
        ,contact.firstname AS short_name
        ,employee_created.employee_id AS fk_employee_id_created_by
        ,employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,(crm.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,(crm.modifiedtime || ' ' || user_modified.time_zone)::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm.deleted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(contact.firstname, '')
        || COALESCE(contact.lastname, '')
        || crm.deleted
        ) AS tech_row_hash
        ,contact.tech_data_load_utc_timestamp
        ,contact.tech_data_load_uuid
    FROM stage.vtiger_contactdetails_i AS contact
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = contact.contactid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm.modifiedby
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name

    UNION ALL
    --Contacts from CRM leads
    SELECT
        lead.lead_no || LEAD_CONTACT_FLAG AS party_key
        ,lead.firstname || ' ' || lead.lastname AS full_name
        ,lead.firstname AS short_name
        ,employee_created.employee_id AS fk_employee_id_created_by
        ,employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,(crm.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,(crm.modifiedtime || ' ' || user_modified.time_zone)::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm.deleted::bool OR lead.converted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(lead.firstname ,'')
        || COALESCE(lead.lastname ,'')
        || crm.deleted
        || lead.converted
        ) AS tech_row_hash
        ,lead.tech_data_load_utc_timestamp
        ,lead.tech_data_load_uuid
    FROM stage.vtiger_leaddetails_i AS lead
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = lead.leadid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm.modifiedby
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name

    UNION ALL
    --Organizations from CRM leads
    SELECT
        lead.lead_no ||  LEAD_ORGANIZATION_FLAG AS party_key
        ,lead.company AS full_name
        ,lead.company AS short_name
        ,employee_created.employee_id AS fk_employee_id_created_by
        ,employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,(crm.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,(crm.modifiedtime || ' ' || user_modified.time_zone)::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm.deleted::bool OR lead.converted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(lead.company ,'')
        || crm.deleted
        || lead.converted
        ) AS tech_row_hash
        ,lead.tech_data_load_utc_timestamp
        ,lead.tech_data_load_uuid
    FROM stage.vtiger_leaddetails_i AS lead
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = lead.leadid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm.modifiedby
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name

    UNION ALL
    --Employees
    SELECT
        vtiger_users.user_name AS party_key
        ,vtiger_users.first_name || ' ' || vtiger_users.last_name AS full_name
        ,vtiger_users.first_name AS short_name
        ,-1 AS fk_employee_id_created_by
        ,-1 AS fk_employee_id_last_modified_by
        ,(vtiger_users.date_entered || ' ' || 'UTC')::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,CASE
            WHEN vtiger_users.date_modified IS NULL THEN NULL_UTC_TIMESTAMP
            ELSE (vtiger_users.date_modified || ' ' || 'UTC')::TIMESTAMP WITH TIME ZONE
        END AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,vtiger_users.deleted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(vtiger_users.first_name, '')
        || COALESCE(vtiger_users.last_name, '')
        ) AS tech_row_hash
        ,vtiger_users.tech_data_load_utc_timestamp
        ,vtiger_users.tech_data_load_uuid
    FROM stage.vtiger_users_i AS vtiger_users;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.party_i (
        party_key
        ,full_name
        ,short_name
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
        tmp_party_i.party_key
        ,tmp_party_i.full_name
        ,tmp_party_i.short_name
        ,tmp_party_i.fk_employee_id_created_by
        ,tmp_party_i.fk_employee_id_last_modified_by
        ,tmp_party_i.created_timestamp
        ,tmp_party_i.last_modified_timestamp
        ,tmp_party_i.tech_insert_function
        ,tmp_party_i.tech_insert_utc_timestamp
        ,tmp_party_i.tech_deleted_in_source_system
        ,tmp_party_i.tech_row_hash
        ,tmp_party_i.tech_data_load_utc_timestamp
        ,tmp_party_i.tech_data_load_uuid
    FROM tmp_party_i;

    RETURN 0;
END;$$

LANGUAGE plpgsql
