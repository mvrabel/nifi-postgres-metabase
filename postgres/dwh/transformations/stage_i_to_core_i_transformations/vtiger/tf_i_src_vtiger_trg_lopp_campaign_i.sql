CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_lopp_campaign_i()
RETURNS INTEGER AS $$

    /*
    ===================================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table lopp_campaign_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    ===================================================================================================
    */

DECLARE

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

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_lopp_campaign_i;

    CREATE TEMPORARY TABLE tmp_lopp_campaign_i (
        lopp_campaign_key                   TEXT NOT NULL
        ,crm_id                             INTEGER NOT NULL
        ,campaign_name                      TEXT NOT NULL
        ,campaign_type                      TEXT
        ,campaign_status                    TEXT
        ,is_running                         bool NOT NULL
        ,description                        TEXT
        ,fk_date_id_start_date              INTEGER NOT NULL
        ,fk_date_id_expected_close_date     INTEGER NOT NULL
        ,fk_employee_id_created_by          INTEGER NOT NULL
        ,fk_employee_id_last_modified_by    INTEGER NOT NULL
        ,created_timestamp                  TIMESTAMP WITH TIME ZONE NOT NULL
        ,last_modified_timestamp            TIMESTAMP WITH TIME ZONE NOT NULL
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_deleted_in_source_system      BOOL NOT NULL
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
     );

    INSERT INTO tmp_lopp_campaign_i(
        lopp_campaign_key
        ,crm_id
        ,campaign_name
        ,campaign_type
        ,campaign_status
        ,is_running
        ,description
        ,fk_date_id_start_date
        ,fk_date_id_expected_close_date
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
        campaign.campaign_no AS lopp_campaign_key
        ,crm_entity.crmid AS crm_id
        ,campaign.campaignname AS campaign_name
        ,campaign.campaigntype AS campaign_type
        ,campaign.campaignstatus AS campaign_status
        ,campaign_custom_field.cf_781::bool AS is_running
        ,crm_entity.description AS description
        ,CASE WHEN campaign_custom_field.cf_779 IS NULL THEN -1
            WHEN cf_779 = '' THEN -1
            ELSE replace(cf_779,'-','')::integer
        END AS fk_date_id_start_date
        ,CASE WHEN campaign.closingdate IS NULL THEN -1
            WHEN campaign.closingdate = '' THEN -1
            ELSE replace(campaign.closingdate,'-','')::integer
        END AS fk_date_id_end_date
        ,employee_created.employee_id AS fk_employee_id_created_by
        ,employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,(crm_entity.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,(crm_entity.modifiedtime || ' ' || user_modified.time_zone)::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm_entity.deleted::bool AS tech_deleted_in_source_system
        ,md5(
           COALESCE(campaign.campaignname, '')
        || COALESCE(campaign.campaigntype, '')
        || COALESCE(campaign.campaignstatus, '')
        || COALESCE(campaign_custom_field.cf_781, '')
        || COALESCE(crm_entity.description, '')
        || COALESCE(campaign_custom_field.cf_779, '')
        || COALESCE(campaign.closingdate, '')
        || employee_created.employee_key
        || employee_modified.employee_key
        || crm_entity.modifiedtime
        || crm_entity.modifiedby::TEXT
        || crm_entity.deleted
        ) AS tech_row_hash
        ,campaign.tech_data_load_utc_timestamp
        ,campaign.tech_data_load_uuid
    FROM stage.vtiger_campaign_i AS campaign
    JOIN stage.vtiger_campaignscf_i AS campaign_custom_field ON campaign_custom_field.campaignid = campaign.campaignid
    JOIN stage.vtiger_crmentity_i AS crm_entity ON crm_entity.crmid = campaign.campaignid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm_entity.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm_entity.modifiedby
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.lopp_campaign_i (
        lopp_campaign_key
        ,crm_id
        ,campaign_name
        ,campaign_type
        ,campaign_status
        ,is_running
        ,description
        ,fk_date_id_start_date
        ,fk_date_id_expected_close_date
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
         tmp_lopp_campaign_i.lopp_campaign_key
        ,tmp_lopp_campaign_i.crm_id
        ,tmp_lopp_campaign_i.campaign_name
        ,tmp_lopp_campaign_i.campaign_type
        ,tmp_lopp_campaign_i.campaign_status
        ,tmp_lopp_campaign_i.is_running
        ,tmp_lopp_campaign_i.description
        ,tmp_lopp_campaign_i.fk_date_id_start_date
        ,tmp_lopp_campaign_i.fk_date_id_expected_close_date
        ,tmp_lopp_campaign_i.fk_employee_id_created_by
        ,tmp_lopp_campaign_i.fk_employee_id_last_modified_by
        ,tmp_lopp_campaign_i.created_timestamp
        ,tmp_lopp_campaign_i.last_modified_timestamp
        ,tmp_lopp_campaign_i.tech_insert_function
        ,tmp_lopp_campaign_i.tech_insert_utc_timestamp
        ,tmp_lopp_campaign_i.tech_deleted_in_source_system
        ,tmp_lopp_campaign_i.tech_row_hash
        ,tmp_lopp_campaign_i.tech_data_load_utc_timestamp
        ,tmp_lopp_campaign_i.tech_data_load_uuid
    FROM tmp_lopp_campaign_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
