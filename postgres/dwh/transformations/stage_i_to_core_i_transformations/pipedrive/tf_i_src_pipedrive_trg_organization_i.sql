CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_organization_i()
RETURNS integer 
AS $$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table organization_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-10-26 (YYYY-MM-DD)
    NOTE:
    ==============================================================================================
    */

DECLARE 

ORGANIZATION_KEY_PREFIX TEXT := 'PIPEDRIVE_ORGANIZATION_';
EMPLOYEE_KEY_PREFIX TEXT := 'PIPEDRIVE_EMPLOYEE_';
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

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.organization_i (
        organization_id
        ,organization_key
        ,address_full
        ,address_city
        ,address_country
        ,address_region
        ,pipedrive_label
        ,fk_party_id
        ,fk_employee_id_owner
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,pipedrive_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    VALUES (
        -1 -- organization_id
        ,TEXT_NULL -- organization_key
        ,TEXT_NULL -- address_full
        ,TEXT_NULL -- address_city
        ,TEXT_NULL -- address_country
        ,TEXT_NULL -- address_region
        ,TEXT_NULL -- pipedrive_label
        ,-1 -- fk_party_id
        ,-1 -- fk_employee_id_owner
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
        ,-1 -- fk_date_id_last_updated_date
        ,TIMESTAMP_NEVER -- last_updated_timestamp
        ,TEXT_NULL -- pipedrive_id
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

    DROP TABLE IF EXISTS tmp_organization_i cascade;

    CREATE TEMPORARY TABLE tmp_organization_i (
        organization_key                 TEXT  NOT NULL
        ,address_full                    TEXT  NOT NULL
        ,address_city                    TEXT  NOT NULL
        ,address_country                 TEXT  NOT NULL
        ,address_region                  TEXT  NOT NULL
        ,pipedrive_label                 TEXT  NOT NULL
        ,fk_party_id                     INTEGER  NOT NULL
        ,fk_employee_id_owner            INTEGER  NOT NULL
        ,fk_date_id_created_date         INTEGER  NOT NULL
        ,created_timestamp               TIMESTAMP WITH TIME ZONE  NOT NULL
        ,fk_date_id_last_updated_date    INTEGER  NOT NULL
        ,last_updated_timestamp          TIMESTAMP WITH TIME ZONE  NOT NULL
        ,pipedrive_id                    TEXT  NOT NULL
        ,tech_insert_function            TEXT  NOT NULL
        ,tech_insert_utc_timestamp       BIGINT  NOT NULL
        ,tech_row_hash                   TEXT  NOT NULL
        ,tech_data_load_utc_timestamp    BIGINT  NOT NULL
        ,tech_data_load_uuid             TEXT  NOT NULL
        ,tech_deleted_in_source_system   BOOL DEFAULT FALSE NOT NULL
    );

    INSERT INTO tmp_organization_i (
        organization_key
        ,address_full
        ,address_city
        ,address_country
        ,address_region
        ,pipedrive_label
        ,fk_party_id
        ,fk_employee_id_owner
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,pipedrive_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        ORGANIZATION_KEY_PREFIX || pipedrive_organization.id AS organization_key
        ,CASE
            WHEN pipedrive_organization.address_formatted_address <> '' THEN tf_u_replace_empty_string_with_null_flag(pipedrive_organization.address_formatted_address)
            ELSE tf_u_replace_empty_string_with_null_flag(pipedrive_organization.address)
        END AS address_full
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_organization.address_locality) AS address_city
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_organization.address_country) AS address_country
        ,tf_u_replace_empty_string_with_null_flag(iso_country_list.region) AS address_region
        ,tf_u_replace_empty_string_with_null_flag(organization_label.label) AS pipedrive_label
        ,organization_party.party_id AS fk_party_id
        ,employee.employee_id AS fk_employee_id_owner
        ,tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_organization.add_time) AS fk_date_id_created_date
        ,(pipedrive_organization.add_time || '+00')::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_organization.update_time) AS fk_date_id_last_updated_date
        ,(pipedrive_organization.update_time || '+00')::TIMESTAMP WITH TIME ZONE AS last_updated_timestamp
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_organization.id::TEXT) AS pipedrive_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,NOT pipedrive_organization.active_flag AS tech_deleted_in_source_system
        ,md5(
        COALESCE(pipedrive_organization.address_formatted_address::TEXT, '')
        || COALESCE(pipedrive_organization.address::TEXT, '')
        || COALESCE(pipedrive_organization.address_locality::TEXT, '')
        || COALESCE(pipedrive_organization.address_country::TEXT, '')
        || COALESCE(pipedrive_organization.label::TEXT, '')
        || COALESCE(pipedrive_organization.active_flag::TEXT, '')
        ) AS tech_row_hash
        ,pipedrive_organization.tech_data_load_utc_timestamp
        ,pipedrive_organization.tech_data_load_uuid
    FROM stage.pipedrive_organization_i AS pipedrive_organization
    LEFT JOIN stage.pipedrive_organization_label_options_i AS organization_label ON organization_label.id = pipedrive_organization.label
    LEFT JOIN core.party_i AS organization_party ON organization_party.party_key = ORGANIZATION_KEY_PREFIX || pipedrive_organization.id
    LEFT JOIN core.employee_i AS employee ON employee.employee_key = EMPLOYEE_KEY_PREFIX || pipedrive_organization.owner_id
    LEFT JOIN core.c_contry_name_map_g AS country_name_map ON country_name_map.google_country_name = pipedrive_organization.address_country
    LEFT JOIN core.iso_3166_country_list_i AS iso_country_list ON iso_country_list.country_name = COALESCE(country_name_map.iso_3166_country_name, pipedrive_organization.address_country);

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.organization_i (
        organization_key
        ,address_full
        ,address_city
        ,address_country
        ,address_region
        ,pipedrive_label
        ,fk_party_id
        ,fk_employee_id_owner
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,pipedrive_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT 
        tmp_organization_i.organization_key
        ,tmp_organization_i.address_full
        ,tmp_organization_i.address_city
        ,tmp_organization_i.address_country
        ,tmp_organization_i.address_region
        ,tmp_organization_i.pipedrive_label
        ,tmp_organization_i.fk_party_id
        ,tmp_organization_i.fk_employee_id_owner
        ,tmp_organization_i.fk_date_id_created_date
        ,tmp_organization_i.created_timestamp
        ,tmp_organization_i.fk_date_id_last_updated_date
        ,tmp_organization_i.last_updated_timestamp
        ,tmp_organization_i.pipedrive_id
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
