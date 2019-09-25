CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_deal_contact_map_i()
RETURNS INTEGER
AS $$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table deal_contact_map_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-11-01 (YYYY-MM-DD)
    NOTE:
    ==============================================================================================
    */

DECLARE 

PIPEDRIVE_PREFIX TEXT := 'PIPEDRIVE_';
ORGANIZATION_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'ORGANIZATION_';
PERSON_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'PERSON_';
CONTACT_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'CONTACT_';
EMPLOYEE_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'EMPLOYEE_';
DEAL_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'DEAL_';
CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
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

    DROP TABLE IF EXISTS tmp_deal_contact_map_i cascade;

    CREATE TEMPORARY TABLE tmp_deal_contact_map_i ( 
        deal_key                         TEXT NOT NULL
        ,contact_key                     TEXT NOT NULL
        ,fk_deal_id                      INTEGER NOT NULL
        ,fk_contact_id                   INTEGER NOT NULL
        ,tech_insert_function            TEXT NOT NULL
        ,tech_insert_utc_timestamp       BIGINT NOT NULL
        ,tech_row_hash                   TEXT NOT NULL
        ,tech_data_load_utc_timestamp    BIGINT NOT NULL
        ,tech_data_load_uuid             TEXT NOT NULL
        ,tech_deleted_in_source_system   BOOL NOT NULL
    );

    INSERT INTO tmp_deal_contact_map_i (
        deal_key
        ,contact_key
        ,fk_deal_id
        ,fk_contact_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        core_deal.deal_key AS deal_key
        ,core_contact.contact_key AS contact_key
        ,core_deal.deal_id AS fk_deal_id
        ,core_contact.contact_id AS fk_deal_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(           
            COALESCE(pipedrive_deal.id::TEXT, '')
            || COALESCE(pipedrive_deal.person_id::TEXT, '')
        ) AS tech_row_hash
        ,pipedrive_deal.tech_data_load_utc_timestamp
        ,pipedrive_deal.tech_data_load_uuid
    FROM stage.pipedrive_deal_i AS pipedrive_deal
    JOIN core.deal_i AS core_deal ON core_deal.deal_key = DEAL_KEY_PREFIX || pipedrive_deal.id
    JOIN core.contact_i AS core_contact ON core_contact.contact_key = CONTACT_KEY_PREFIX || pipedrive_deal.person_id

    UNION ALL

    SELECT
        core_deal.deal_key AS deal_key
        ,core_contact.contact_key AS contact_key
        ,core_deal.deal_id AS fk_deal_id
        ,core_contact.contact_id AS fk_deal_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(           
            COALESCE(stage_deal_contact_map.deal_id::TEXT, '')
            || COALESCE(stage_deal_contact_map.participant_person_id::TEXT, '')
        ) AS tech_row_hash
        ,pipedrive_deal.tech_data_load_utc_timestamp
        ,pipedrive_deal.tech_data_load_uuid
    FROM stage.pipedrive_deal_i AS pipedrive_deal
    JOIN stage.pipedrive_deal_participants_i AS stage_deal_contact_map ON stage_deal_contact_map.deal_id = pipedrive_deal.id
    JOIN core.deal_i AS core_deal ON core_deal.deal_key = DEAL_KEY_PREFIX || stage_deal_contact_map.deal_id
    JOIN core.contact_i AS core_contact ON core_contact.contact_key = CONTACT_KEY_PREFIX || stage_deal_contact_map.participant_person_id
    WHERE pipedrive_deal.person_id IS NOT NULL
        AND stage_deal_contact_map.participant_person_id != pipedrive_deal.person_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.deal_contact_map_i (
        deal_key
        ,contact_key
        ,fk_deal_id
        ,fk_contact_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT 
        tmp_deal_contact_map_i.deal_key
        ,tmp_deal_contact_map_i.contact_key
        ,tmp_deal_contact_map_i.fk_deal_id
        ,tmp_deal_contact_map_i.fk_contact_id
        ,tmp_deal_contact_map_i.tech_insert_function
        ,tmp_deal_contact_map_i.tech_insert_utc_timestamp
        ,tmp_deal_contact_map_i.tech_deleted_in_source_system
        ,tmp_deal_contact_map_i.tech_row_hash
        ,tmp_deal_contact_map_i.tech_data_load_utc_timestamp
        ,tmp_deal_contact_map_i.tech_data_load_uuid
    FROM tmp_deal_contact_map_i;

    RETURN 0;
    
END;$$

LANGUAGE plpgsql
