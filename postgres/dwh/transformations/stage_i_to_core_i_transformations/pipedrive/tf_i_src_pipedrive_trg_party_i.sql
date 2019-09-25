CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_party_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table party_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-10-25 (YYYY-MM-DD)
    NOTE:               
    ===========================================================================================================
    */

DECLARE

EMPLOYEE_KEY_PREFIX TEXT := 'PIPEDRIVE_EMPLOYEE_';
PERSON_KEY_PREFIX TEXT := 'PIPEDRIVE_PERSON_';
ORGANIZATION_KEY_PREFIX TEXT := 'PIPEDRIVE_ORGANIZATION_';
CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
stack TEXT;
FUNCTION_NAME TEXT;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::TEXT;

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.party_i (
       party_id
       ,party_key
       ,full_name
       ,short_name
       ,fk_employee_id_last_modified_by
       ,fk_employee_id_created_by
       ,fk_date_id_created_date
       ,created_timestamp
       ,fk_date_id_last_modified_date
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
        ,TEXT_NULL -- party_key
        ,TEXT_NULL -- full_name
        ,TEXT_NULL -- short_name
        ,-1 -- fk_employee_id_last_modified_by
        ,-1 -- fk_employee_id_created_by
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
        ,-1 -- fk_date_id_last_modified_date
        ,TIMESTAMP_NEVER -- last_modified_timestamp
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,TEXT_NULL -- tech_row_hash
        ,-1 -- tech_data_load_utc_timestamp
        ,TEXT_NULL -- tech_data_load_uuid
    ) ON CONFLICT DO NOTHING;
    
    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_party_i;

    CREATE TEMPORARY TABLE tmp_party_i(
        party_key                        TEXT  NOT NULL
        ,full_name                       TEXT  NOT NULL
        ,short_name                      TEXT  NOT NULL
        ,fk_employee_id_last_modified_by INTEGER  NOT NULL
        ,fk_employee_id_created_by       INTEGER  NOT NULL
        ,fk_date_id_created_date         INTEGER NULL
        ,created_timestamp               TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_last_modified_date   INTEGER  NOT NULL
        ,last_modified_timestamp         TIMESTAMP WITH TIME ZONE NOT NULL
        ,tech_insert_function            TEXT  NOT NULL
        ,tech_insert_utc_timestamp       BIGINT  NOT NULL
        ,tech_row_hash                   TEXT  NOT NULL
        ,tech_data_load_utc_timestamp    BIGINT  NOT NULL
        ,tech_data_load_uuid             TEXT  NOT NULL
        ,tech_deleted_in_source_system   BOOL DEFAULT FALSE NOT NULL
    );

    INSERT INTO tmp_party_i (
       party_key
       ,full_name
       ,short_name
       ,fk_employee_id_last_modified_by
       ,fk_employee_id_created_by
       ,fk_date_id_created_date
       ,created_timestamp
       ,fk_date_id_last_modified_date
       ,last_modified_timestamp
       ,tech_insert_function
       ,tech_insert_utc_timestamp
       ,tech_deleted_in_source_system
       ,tech_row_hash
       ,tech_data_load_utc_timestamp
       ,tech_data_load_uuid
    )
    SELECT 
        ORGANIZATION_KEY_PREFIX || pipedrive_organization.id AS party_key
        ,COALESCE(pipedrive_organization.name, '') AS full_name
        ,COALESCE(pipedrive_organization.name, '') AS short_name
        ,-1 AS fk_employee_id_last_modified_by
        ,-1 AS fk_employee_id_created_by
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_organization.add_time), -1) AS fk_date_id_created_date
        ,(pipedrive_organization.add_time || ' UTC')::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_organization.update_time), -1) AS fk_date_id_last_modified_date
        ,(pipedrive_organization.update_time || ' UTC')::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(pipedrive_organization.name, '')
        ) AS tech_row_hash
        ,pipedrive_organization.tech_data_load_utc_timestamp
        ,pipedrive_organization.tech_data_load_uuid
    FROM stage.pipedrive_organization_i AS pipedrive_organization

    UNION ALL

    SELECT 
        PERSON_KEY_PREFIX || pipedrive_person.id AS party_key
        ,COALESCE(pipedrive_person.name, '') AS full_name
        ,COALESCE(pipedrive_person.first_name, '') AS short_name
        ,-1 AS fk_employee_id_last_modified_by
        ,-1 AS fk_employee_id_created_by
        ,tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_person.add_time) AS fk_date_id_created_date
        ,(pipedrive_person.add_time || ' UTC')::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_person.update_time), -1) AS fk_date_id_last_modified_date
        ,(pipedrive_person.update_time || ' UTC')::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(pipedrive_person.name, '')
        ) AS tech_row_hash
        ,pipedrive_person.tech_data_load_utc_timestamp
        ,pipedrive_person.tech_data_load_uuid
    FROM stage.pipedrive_person_i AS pipedrive_person
    
    UNION ALL
    
    SELECT
        EMPLOYEE_KEY_PREFIX || pipedrive_user.id AS party_key
        ,pipedrive_user.name AS full_name
        ,pipedrive_user.name AS short_name
        ,-1 AS fk_employee_id_last_modified_by
        ,-1 AS fk_employee_id_created_by
        ,tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_user.created) AS fk_date_id_created_date
        ,(pipedrive_user.created || ' ' || 'UTC')::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,-1 AS fk_date_id_last_modified_date
        ,TIMESTAMP_NEVER AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(pipedrive_user.name, '')
            || COALESCE(pipedrive_user.email, '')
        ) AS tech_row_hash
        ,pipedrive_user.tech_data_load_utc_timestamp
        ,pipedrive_user.tech_data_load_uuid
    FROM stage.pipedrive_user_i AS pipedrive_user;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------
    
    INSERT INTO core.party_i (
       party_key
       ,full_name
       ,short_name
       ,fk_employee_id_last_modified_by
       ,fk_employee_id_created_by
       ,fk_date_id_created_date
       ,created_timestamp
       ,fk_date_id_last_modified_date
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
       ,tmp_party_i.fk_employee_id_last_modified_by
       ,tmp_party_i.fk_employee_id_created_by
       ,tmp_party_i.fk_date_id_created_date
       ,tmp_party_i.created_timestamp
       ,tmp_party_i.fk_date_id_last_modified_date
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
