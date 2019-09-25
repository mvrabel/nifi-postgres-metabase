CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_organization_relation_i()
RETURNS INTEGER
AS $$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table organization_relation_i
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

    DROP TABLE IF EXISTS tmp_organization_relation_i cascade;

    CREATE TEMPORARY TABLE tmp_organization_relation_i ( 
        organization_key                            TEXT NOT NULL
        ,organization_key_related_organization      TEXT NOT NULL
        ,fk_organization_id                         INTEGER NOT NULL
        ,fk_organization_id_related_organization    INTEGER NOT NULL
        ,related_organization_is                    TEXT NOT NULL
        ,tech_insert_function                       TEXT NOT NULL
        ,tech_insert_utc_timestamp                  BIGINT NOT NULL
        ,tech_row_hash                              TEXT NOT NULL
        ,tech_data_load_utc_timestamp               BIGINT NOT NULL
        ,tech_data_load_uuid                        TEXT NOT NULL
        ,tech_deleted_in_source_system              BOOL NOT NULL
    );

    INSERT INTO tmp_organization_relation_i (
        organization_key
        ,organization_key_related_organization
        ,fk_organization_id
        ,fk_organization_id_related_organization
        ,related_organization_is
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        DEAL_KEY_PREFIX || organization_relation_map.rel_linked_org_id_value AS deal_key
        ,CONTACT_KEY_PREFIX || organization_relation_map.calculated_related_org_id AS contact_key
        ,organization.organization_id AS fk_organization_id
        ,related_organization.organization_id AS fk_organization_id_related_organization
        ,organization_relation_map.calculated_type AS related_organization_is
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(           
            COALESCE(organization_relation_map.rel_linked_org_id_value::TEXT, '')
            || COALESCE(organization_relation_map.calculated_related_org_id::TEXT, '')
        ) AS tech_row_hash
        ,organization_relation_map.tech_data_load_utc_timestamp
        ,organization_relation_map.tech_data_load_uuid
    FROM stage.pipedrive_organization_relation_i AS organization_relation_map
    LEFT JOIN core.organization_i AS organization ON organization.organization_key = ORGANIZATION_KEY_PREFIX || organization_relation_map.rel_linked_org_id_value
    LEFT JOIN core.organization_i AS related_organization ON related_organization.organization_key = ORGANIZATION_KEY_PREFIX || organization_relation_map.calculated_related_org_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.organization_relation_i (
        organization_key
        ,organization_key_related_organization
        ,fk_organization_id
        ,fk_organization_id_related_organization
        ,related_organization_is
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT 
        tmp_organization_relation_i.organization_key
        ,tmp_organization_relation_i.organization_key_related_organization
        ,tmp_organization_relation_i.fk_organization_id
        ,tmp_organization_relation_i.fk_organization_id_related_organization
        ,tmp_organization_relation_i.related_organization_is
        ,tmp_organization_relation_i.tech_insert_function
        ,tmp_organization_relation_i.tech_insert_utc_timestamp
        ,tmp_organization_relation_i.tech_deleted_in_source_system
        ,tmp_organization_relation_i.tech_row_hash
        ,tmp_organization_relation_i.tech_data_load_utc_timestamp
        ,tmp_organization_relation_i.tech_data_load_uuid
    FROM tmp_organization_relation_i;
    
    RETURN 0;
    
END;$$

LANGUAGE plpgsql
