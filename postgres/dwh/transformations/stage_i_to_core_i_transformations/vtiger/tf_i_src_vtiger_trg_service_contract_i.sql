CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_service_contract_i()
RETURNS INTEGER AS $$

    /*
    =====================================================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table service_contract_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =====================================================================================================================
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

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_service_contract_i;

    CREATE TEMPORARY TABLE tmp_service_contract_i(
        service_contract_key                TEXT PRIMARY KEY NOT NULL
        ,crm_id                             INTEGER NOT NULL
        ,subject                            TEXT NOT NULL
        ,fk_organization_id_related_to      INTEGER NOT NULL
        ,contract_type                      TEXT
        ,priority                           TEXT
        ,STATUS                             TEXT
        ,fk_date_id_start_date              INTEGER NOT NULL
        ,fk_date_id_due_date                INTEGER NOT NULL
        ,fk_date_id_end_date                INTEGER NOT NULL
        ,fk_date_id_billed_until_date       INTEGER NOT NULL
        ,partner                            TEXT
        ,support_thread                     TEXT
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


    INSERT INTO tmp_service_contract_i (
        service_contract_key
        ,crm_id
        ,subject
        ,fk_organization_id_related_to
        ,contract_type
        ,priority
        ,STATUS
        ,fk_date_id_start_date
        ,fk_date_id_due_date
        ,fk_date_id_end_date
        ,fk_date_id_billed_until_date
        ,partner
        ,support_thread
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
        service_contract.contract_no AS service_contract_key
        ,crm.crmid AS crm_id
        ,service_contract.subject
        ,CASE WHEN organization.organization_id IS NULL THEN -1
            ELSE organization.organization_id
        END AS fk_organization_id_related_to
        ,service_contract.contract_type
        ,service_contract.priority
        ,service_contract.contract_status as status
        ,CASE WHEN service_contract.start_date IS NULL THEN -1
            WHEN service_contract.start_date = '' THEN -1
            ELSE replace(service_contract.start_date,'-','')::integer
        END AS fk_date_id_start_date
        ,CASE WHEN service_contract.due_date IS NULL THEN -1
            WHEN service_contract.due_date = '' THEN -1
            ELSE replace(service_contract.due_date,'-','')::integer
        END AS fk_date_id_due_date
        ,CASE WHEN service_contract.end_date IS NULL THEN -1
            WHEN service_contract.end_date = '' THEN -1
            ELSE replace(service_contract.end_date,'-','')::integer
        END AS fk_date_id_end_date
        ,CASE WHEN scf.cf_878 IS NULL THEN -1
            WHEN scf.cf_878 = '' THEN -1
            ELSE replace(scf.cf_878,'-','')::integer
        END AS fk_date_id_billed_until_date
        ,scf.cf_801 AS partner
        ,scf.cf_849 AS support_thread
        ,employee_assigned.employee_id AS fk_employee_id_assigned_to
        ,employee_created.employee_id AS fk_employee_id_created_by
        ,employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,(crm.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,(crm.modifiedtime || ' ' || user_modified.time_zone)::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm.deleted::bool AS tech_deleted_in_source_system
        ,md5(
           COALESCE(service_contract.subject, '')
        || COALESCE(service_contract.contract_type, '')
        || COALESCE(service_contract.priority, '')
        || COALESCE(service_contract.contract_status, '')
        || COALESCE(service_contract.start_date, '')
        || COALESCE(service_contract.due_date, '')
        || COALESCE(service_contract.end_date, '')
        || COALESCE(scf.cf_878, '')
        || COALESCE(scf.cf_801, '')
        || COALESCE(scf.cf_849, '')
        || COALESCE(organization.organization_key, '')
        || employee_created.employee_key
        || employee_assigned.employee_key
        || employee_modified.employee_key
        || crm.modifiedtime
        || crm.deleted
        ) AS tech_row_hash
        ,service_contract.tech_data_load_utc_timestamp
        ,service_contract.tech_data_load_uuid
    FROM stage.vtiger_servicecontracts_i AS service_contract
    JOIN stage.vtiger_servicecontractscf_i AS scf ON scf.servicecontractsid = service_contract.servicecontractsid
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = service_contract.servicecontractsid
    JOIN stage.vtiger_users_i AS user_assigned ON user_assigned.id = crm.smownerid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm.modifiedby
    JOIN core.employee_i AS employee_assigned ON employee_assigned.employee_key = user_assigned.user_name
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name
    LEFT JOIN core.organization_i AS organization ON organization.crm_id = service_contract.sc_related_to;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.service_contract_i(
        service_contract_key
        ,crm_id
        ,subject
        ,fk_organization_id_related_to
        ,contract_type
        ,priority
        ,STATUS
        ,fk_date_id_start_date
        ,fk_date_id_due_date
        ,fk_date_id_end_date
        ,fk_date_id_billed_until_date
        ,partner
        ,support_thread
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
        tmp_service_contract_i.service_contract_key
        ,tmp_service_contract_i.crm_id
        ,tmp_service_contract_i.subject
        ,tmp_service_contract_i.fk_organization_id_related_to
        ,tmp_service_contract_i.contract_type
        ,tmp_service_contract_i.priority
        ,tmp_service_contract_i.STATUS
        ,tmp_service_contract_i.fk_date_id_start_date
        ,tmp_service_contract_i.fk_date_id_due_date
        ,tmp_service_contract_i.fk_date_id_end_date
        ,tmp_service_contract_i.fk_date_id_billed_until_date
        ,tmp_service_contract_i.partner
        ,tmp_service_contract_i.support_thread
        ,tmp_service_contract_i.fk_employee_id_assigned_to
        ,tmp_service_contract_i.fk_employee_id_created_by
        ,tmp_service_contract_i.fk_employee_id_last_modified_by
        ,tmp_service_contract_i.created_timestamp
        ,tmp_service_contract_i.last_modified_timestamp
        ,tmp_service_contract_i.tech_insert_function
        ,tmp_service_contract_i.tech_insert_utc_timestamp
        ,tmp_service_contract_i.tech_deleted_in_source_system
        ,tmp_service_contract_i.tech_row_hash
        ,tmp_service_contract_i.tech_data_load_utc_timestamp
        ,tmp_service_contract_i.tech_data_load_uuid
    FROM tmp_service_contract_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
