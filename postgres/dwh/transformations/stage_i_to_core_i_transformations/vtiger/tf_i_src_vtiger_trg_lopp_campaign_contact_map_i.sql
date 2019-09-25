CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_lopp_campaign_contact_map_i()
RETURNS INTEGER AS $$

    /*
    ===============================================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table lopp_campaign_contact_map_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    ===============================================================================================================
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

    DROP TABLE IF EXISTS tmp_lopp_campaign_contact_map_i;

    CREATE TEMPORARY TABLE tmp_lopp_campaign_contact_map_i (
        lopp_campaign_key                   TEXT NOT NULL
        ,contact_key                        TEXT NOT NULL
        ,fk_lopp_campaign_id                INTEGER NOT NULL
        ,fk_contact_id                      INTEGER NOT NULL
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_deleted_in_source_system      BOOL NOT NULL DEFAULT FALSE
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
     );

    INSERT INTO tmp_lopp_campaign_contact_map_i (
        lopp_campaign_key
        ,contact_key
        ,fk_lopp_campaign_id
        ,fk_contact_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        lopp_campaign.lopp_campaign_key AS lopp_campaign_key
        ,contact.contact_key AS contact_key
        ,lopp_campaign.lopp_campaign_id AS fk_lopp_campaign_id
        ,contact.contact_id AS fk_contact_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,lopp_campaign.tech_deleted_in_source_system OR contact.tech_deleted_in_source_system AS tech_deleted_in_source_system -- sometimes vtiger points briges deleted and non-deleted records
        ,md5(
        vt_campaign_contanct_map.campaignid::TEXT
        || vt_campaign_contanct_map.contactid::TEXT
        || lopp_campaign.lopp_campaign_key
        || contact.contact_key
        ) AS tech_row_hash
        ,vt_campaign_contanct_map.tech_data_load_utc_timestamp
        ,vt_campaign_contanct_map.tech_data_load_uuid
    -- TABLE vtiger_campaigncontrel is not historized, when a contact is removed from campaign the associated record(row) is removed
    FROM stage.vtiger_campaigncontrel_i AS vt_campaign_contanct_map
    JOIN stage.vtiger_crmentity_i AS vt_campaign_crm_entity ON vt_campaign_crm_entity.crmid = vt_campaign_contanct_map.campaignid
    JOIN stage.vtiger_crmentity_i AS vt_contact_crm_entity ON vt_contact_crm_entity.crmid = vt_campaign_contanct_map.contactid
    JOIN core.lopp_campaign_i AS lopp_campaign ON lopp_campaign.crm_id = vt_campaign_contanct_map.campaignid
    JOIN core.contact_i AS contact ON contact.crm_id = vt_campaign_contanct_map.contactid

    UNION ALL

    SELECT
        lopp_campaign.lopp_campaign_key AS lopp_campaign_key
        ,contact.contact_key AS contact_key
        ,lopp_campaign.lopp_campaign_id AS fk_lopp_campaign_id
        ,contact.contact_id AS fk_contact_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,lopp_campaign.tech_deleted_in_source_system OR contact.tech_deleted_in_source_system AS tech_deleted_in_source_system -- sometimes vtiger points briges deleted and non-deleted records
        ,md5(
        vt_campaign_lead_map.campaignid::TEXT
        || vt_campaign_lead_map.leadid::TEXT
        || lopp_campaign.lopp_campaign_key
        || contact.contact_key
        ) AS tech_row_hash
        ,vt_campaign_lead_map.tech_data_load_utc_timestamp
        ,vt_campaign_lead_map.tech_data_load_uuid
    -- We add contacts that were created from leads
    FROM stage.vtiger_campaignleadrel_i AS vt_campaign_lead_map
    JOIN stage.vtiger_crmentity_i AS vt_campaign_crm_entity ON vt_campaign_crm_entity.crmid = vt_campaign_lead_map.campaignid
    JOIN stage.vtiger_crmentity_i AS vt_lead_crm_entity ON vt_lead_crm_entity.crmid = vt_campaign_lead_map.leadid
    JOIN core.lopp_campaign_i AS lopp_campaign ON lopp_campaign.crm_id = vt_campaign_lead_map.campaignid
    JOIN core.contact_i AS contact ON contact.crm_id = vt_campaign_lead_map.leadid;  -- leadid is the crm_id of contact because contacts were created from leads

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.lopp_campaign__contact_map_i (
        lopp_campaign_key
        ,contact_key
        ,fk_lopp_campaign_id
        ,fk_contact_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_lopp_campaign_contact_map_i.lopp_campaign_key
        ,tmp_lopp_campaign_contact_map_i.contact_key
        ,tmp_lopp_campaign_contact_map_i.fk_lopp_campaign_id
        ,tmp_lopp_campaign_contact_map_i.fk_contact_id
        ,tmp_lopp_campaign_contact_map_i.tech_insert_function
        ,tmp_lopp_campaign_contact_map_i.tech_insert_utc_timestamp
        ,tmp_lopp_campaign_contact_map_i.tech_deleted_in_source_system
        ,tmp_lopp_campaign_contact_map_i.tech_row_hash
        ,tmp_lopp_campaign_contact_map_i.tech_data_load_utc_timestamp
        ,tmp_lopp_campaign_contact_map_i.tech_data_load_uuid
    FROM tmp_lopp_campaign_contact_map_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
