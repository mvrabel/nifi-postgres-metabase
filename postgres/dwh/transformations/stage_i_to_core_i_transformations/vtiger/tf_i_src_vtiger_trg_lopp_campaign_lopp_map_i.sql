CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_lopp_campaign_lopp_map_i()
RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table lopp_campaign__lopp_map_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
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

    DROP TABLE IF EXISTS tmp_lopp_campaign_lopp_map_i;

    CREATE TEMPORARY TABLE tmp_lopp_campaign_lopp_map_i (
        lopp_campaign_key               TEXT NOT NULL
        ,lopp_key                       TEXT NOT NULL
        ,fk_lopp_campaign_id            INTEGER NOT NULL
        ,fk_lopp_id                     INTEGER NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_deleted_in_source_system  BOOL NOT NULL
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULL
     );

    INSERT INTO tmp_lopp_campaign_lopp_map_i (
        lopp_campaign_key
        ,lopp_key
        ,fk_lopp_campaign_id
        ,fk_lopp_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        lopp_campaign.lopp_campaign_key
        ,lopp.lopp_key
        ,lopp_campaign.lopp_campaign_id AS fk_lopp_campaign_id
        ,lopp.lopp_id AS fk_lopp_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,lopp_campaign.tech_deleted_in_source_system OR lopp.tech_deleted_in_source_system AS tech_deleted_in_source_system
        ,md5(
        lopp_campaign.lopp_campaign_key
        || lopp.lopp_key
        ) AS tech_row_hash
        ,campaign_lead_map.tech_data_load_utc_timestamp
        ,campaign_lead_map.tech_data_load_uuid
    FROM stage.vtiger_campaignleadrel_i AS campaign_lead_map
    JOIN core.lopp_campaign_i AS lopp_campaign ON lopp_campaign.crm_id = campaign_lead_map.campaignid
    JOIN core.lopp_i AS lopp ON lopp.crm_id = campaign_lead_map.leadid

    UNION

    SELECT
        lopp_campaign.lopp_campaign_key
        ,lopp.lopp_key
        ,lopp_campaign.lopp_campaign_id AS fk_lopp_campaign_id
        ,lopp.lopp_id AS fk_lopp_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,lopp.tech_deleted_in_source_system OR lopp_campaign.tech_deleted_in_source_system AS tech_deleted_in_source_system
        ,md5(
        lopp_campaign.lopp_campaign_key
        || lopp.lopp_key
        ) AS tech_row_hash
        ,vt_potential.tech_data_load_utc_timestamp
        ,vt_potential.tech_data_load_uuid
    FROM stage.vtiger_potential_i AS vt_potential
    JOIN stage.vtiger_crmentity_i AS vt_potential_crm_entity ON vt_potential_crm_entity.crmid = vt_potential.potentialid
    JOIN stage.vtiger_campaign_i AS vt_campaign ON vt_campaign.campaignid = vt_potential.campaignid
    JOIN stage.vtiger_crmentity_i AS vt_campaign_crm_entity ON vt_campaign_crm_entity.crmid = vt_campaign.campaignid
    JOIN core.lopp_campaign_i AS lopp_campaign ON lopp_campaign.crm_id = vt_potential.campaignid
    JOIN core.lopp_i AS lopp ON lopp.crm_id = vt_potential.potentialid;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.lopp_campaign__lopp_map_i (
        lopp_key
        ,lopp_campaign_key
        ,fk_lopp_id
        ,fk_lopp_campaign_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_lopp_campaign_lopp_map_i.lopp_key
        ,tmp_lopp_campaign_lopp_map_i.lopp_campaign_key
        ,tmp_lopp_campaign_lopp_map_i.fk_lopp_id
        ,tmp_lopp_campaign_lopp_map_i.fk_lopp_campaign_id
        ,tmp_lopp_campaign_lopp_map_i.tech_insert_function
        ,tmp_lopp_campaign_lopp_map_i.tech_insert_utc_timestamp
        ,tmp_lopp_campaign_lopp_map_i.tech_deleted_in_source_system
        ,tmp_lopp_campaign_lopp_map_i.tech_row_hash
        ,tmp_lopp_campaign_lopp_map_i.tech_data_load_utc_timestamp
        ,tmp_lopp_campaign_lopp_map_i.tech_data_load_uuid
    FROM tmp_lopp_campaign_lopp_map_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
