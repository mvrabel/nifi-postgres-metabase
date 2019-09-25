CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_contact_i()
RETURNS INTEGER
AS $$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table contact_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-10-26 (YYYY-MM-DD)
    NOTE:
    ==============================================================================================
    */

DECLARE 

PIPEDRIVE_PREFIX TEXT := 'PIPEDRIVE_';
ORGANIZATION_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'ORGANIZATION_';
PERSON_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'PERSON_';
CONTACT_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'CONTACT_';
EMPLOYEE_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'EMPLOYEE_';
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

    INSERT INTO core.contact_i (
        contact_id
        ,contact_key
        ,phone_number
        ,email_address
        ,location_full
        ,location_city
        ,location_country
        ,location_region
        ,fk_organization_id
        ,fk_party_id
        ,fk_employee_id_owner
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,pipedrive_id
        ,pipedrive_label
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
        -1 -- contact_id
        ,TEXT_NULL -- contact_key
        ,TEXT_NULL -- phone_number
        ,TEXT_NULL -- email_address
        ,TEXT_NULL -- location_full
        ,TEXT_NULL -- location_city
        ,TEXT_NULL -- location_country
        ,TEXT_NULL -- location_region
        ,-1 -- fk_organization_id
        ,-1 -- fk_party_id
        ,-1 -- fk_employee_id_owner
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
        ,-1 -- fk_date_id_last_updated_date
        ,TIMESTAMP_NEVER -- last_updated_timestamp
        ,TEXT_NULL -- pipedrive_id
        ,TEXT_NULL -- pipedrive_label
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

    DROP TABLE IF EXISTS tmp_contact_i cascade;

    CREATE TEMPORARY TABLE tmp_contact_i (
        contact_key                         TEXT  NOT NULL
        ,phone_number                       TEXT
        ,email_address                      TEXT
        ,location_full                      TEXT
        ,location_city                      TEXT
        ,location_country                   TEXT
        ,location_region                    TEXT
        ,fk_party_id                        INTEGER  NOT NULL
        ,fk_employee_id_owner               INTEGER  NOT NULL
        ,fk_organization_id                 INTEGER  NOT NULL
        ,fk_date_id_created_date            INTEGER  NOT NULL
        ,created_timestamp                  TIMESTAMP WITH TIME ZONE  NOT NULL
        ,fk_date_id_last_updated_date       INTEGER  NOT NULL
        ,last_updated_timestamp             TIMESTAMP WITH TIME ZONE  NOT NULL
        ,pipedrive_id                       TEXT  NOT NULL
        ,pipedrive_label                    TEXT
        ,tech_insert_function               TEXT  NOT NULL
        ,tech_insert_utc_timestamp          BIGINT  NOT NULL
        ,tech_row_hash                      TEXT  NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT  NOT NULL
        ,tech_data_load_uuid                TEXT  NOT NULL
        ,tech_deleted_in_source_system      BOOL DEFAULT FALSE NOT NULL
    );

    INSERT INTO tmp_contact_i (
        contact_key
        ,phone_number
        ,email_address
        ,location_full
        ,location_city
        ,location_country
        ,location_region
        ,fk_organization_id
        ,fk_party_id
        ,fk_employee_id_owner
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,pipedrive_id
        ,pipedrive_label
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        CONTACT_KEY_PREFIX || pipedrive_person.id AS contact_key
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_person.phone_1_value) AS phone_number
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_person.email_1_value) AS email_address
        ,CASE
            WHEN pipedrive_person.location_formatted_address <> '' THEN pipedrive_person.location_formatted_address
            ELSE tf_u_replace_empty_string_with_null_flag(pipedrive_person.location)
        END AS location_full
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_person.location_locality) AS location_city
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_person.location_country) AS location_country
        ,tf_u_replace_empty_string_with_null_flag(iso_country_list.region) AS location_region
        ,COALESCE(core_organization.organization_id, -1) AS fk_organization_id
        ,contact_party.party_id AS fk_party_id
        ,employee.employee_id AS fk_employee_id_owner
        ,tf_u_convert_iso_8601_to_yyyymmdd_integer(add_time) AS fk_date_id_created_date
        ,(pipedrive_person.add_time || '+00')::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,tf_u_convert_iso_8601_to_yyyymmdd_integer(update_time) AS fk_date_id_last_updated_date
        ,(pipedrive_person.update_time || '+00')::TIMESTAMP WITH TIME ZONE AS last_updated_timestamp
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_person.id::TEXT) AS pipedrive_id
        ,tf_u_replace_empty_string_with_null_flag(person_label.label) AS pipedrive_label
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,NOT pipedrive_person.active_flag AS tech_deleted_in_source_system
        ,md5(
            COALESCE(pipedrive_person.phone_1_value::TEXT, '')
            || COALESCE(pipedrive_person.email_1_value::TEXT, '')
            || COALESCE(pipedrive_person.location_formatted_address::TEXT, '')
            || COALESCE(pipedrive_person.location_locality::TEXT, '')
            || COALESCE(pipedrive_person.location_country::TEXT, '')
            || COALESCE(pipedrive_person.org_id::TEXT, '')
            || COALESCE(pipedrive_person.id::TEXT, '')
            || COALESCE(pipedrive_person.label::TEXT, '')
        ) AS tech_row_hash
        ,pipedrive_person.tech_data_load_utc_timestamp
        ,pipedrive_person.tech_data_load_uuid
    FROM stage.pipedrive_person_i AS pipedrive_person
    LEFT JOIN stage.pipedrive_person_label_options_i AS person_label ON person_label.id = pipedrive_person.label
    LEFT JOIN core.organization_i AS core_organization ON core_organization.organization_key = ORGANIZATION_KEY_PREFIX || pipedrive_person.org_id
    LEFT JOIN core.party_i AS contact_party ON contact_party.party_key = PERSON_KEY_PREFIX || pipedrive_person.id
    LEFT JOIN core.employee_i AS employee ON employee.employee_key = EMPLOYEE_KEY_PREFIX || pipedrive_person.owner_id
    LEFT JOIN core.c_contry_name_map_g AS country_name_map ON country_name_map.google_country_name = pipedrive_person.location_country
    LEFT JOIN core.iso_3166_country_list_i AS iso_country_list ON iso_country_list.country_name = COALESCE(country_name_map.iso_3166_country_name, pipedrive_person.location_country);

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.contact_i (
        contact_key
        ,phone_number
        ,email_address
        ,location_full
        ,location_city
        ,location_country
        ,location_region
        ,fk_organization_id
        ,fk_party_id
        ,fk_employee_id_owner
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,pipedrive_id
        ,pipedrive_label
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT 
        tmp_contact_i.contact_key
        ,tmp_contact_i.phone_number
        ,tmp_contact_i.email_address
        ,tmp_contact_i.location_full
        ,tmp_contact_i.location_city
        ,tmp_contact_i.location_country
        ,tmp_contact_i.location_region
        ,tmp_contact_i.fk_organization_id
        ,tmp_contact_i.fk_party_id
        ,tmp_contact_i.fk_employee_id_owner
        ,tmp_contact_i.fk_date_id_created_date
        ,tmp_contact_i.created_timestamp
        ,tmp_contact_i.fk_date_id_last_updated_date
        ,tmp_contact_i.last_updated_timestamp
        ,tmp_contact_i.pipedrive_id
        ,tmp_contact_i.pipedrive_label
        ,tmp_contact_i.tech_insert_function
        ,tmp_contact_i.tech_insert_utc_timestamp
        ,tmp_contact_i.tech_deleted_in_source_system
        ,tmp_contact_i.tech_row_hash
        ,tmp_contact_i.tech_data_load_utc_timestamp
        ,tmp_contact_i.tech_data_load_uuid
    FROM tmp_contact_i;
    
    RETURN 0;
    
END;$$

LANGUAGE plpgsql
