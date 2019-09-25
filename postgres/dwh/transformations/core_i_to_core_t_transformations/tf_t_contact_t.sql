CREATE OR REPLACE FUNCTION core.tf_t_contact_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:    Insert data from core contact_i input table into core 'today' table contact_t
    AUTHOR:         Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:     2018-05-15 (YYYY-MM-DD)
    NOTE:
    =================================================================================================================================
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

    ----------------------------------------------------
    -- INSERT RECORDS FROM INPUT TABLE TO TODAY TABLE --
    ----------------------------------------------------

    INSERT INTO core.contact_t (
        contact_id
        ,contact_key
        ,fk_organization_id
        ,fk_party_id
        ,fk_date_id_created_date
        ,created_timestamp
        ,phone_number
        ,email_address
        ,location_full
        ,location_city
        ,location_country
        ,location_region
        ,pipedrive_label
        ,fk_employee_id_owner
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,pipedrive_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        input_contact.contact_id
        ,input_contact.contact_key
        ,input_organization.organization_id AS fk_organization_id
        ,input_party.party_id AS fk_party_id
        ,input_contact.fk_date_id_created_date
        ,input_contact.created_timestamp
        ,input_contact.phone_number
        ,input_contact.email_address
        ,input_contact.location_full
        ,input_contact.location_city
        ,input_contact.location_country
        ,input_contact.location_region
        ,input_contact.pipedrive_label
        ,input_employee_owner.employee_id AS fk_employee_id_owner
        ,input_contact.fk_date_id_last_updated_date
        ,input_contact.last_updated_timestamp
        ,input_contact.pipedrive_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_contact.tech_row_hash
        ,input_contact.tech_data_load_utc_timestamp
        ,input_contact.tech_data_load_uuid
    FROM core.contact_i AS input_contact
    LEFT JOIN core.employee_i AS input_employee_owner ON input_contact.fk_employee_id_owner = input_employee_owner.employee_id
        AND input_employee_owner.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.organization_i AS input_organization ON input_contact.fk_organization_id = input_organization.organization_id
        AND input_organization.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.party_i AS input_party ON input_contact.fk_party_id = input_party.party_id
        AND input_contact.tech_deleted_in_source_system IS FALSE
    WHERE input_contact.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql

