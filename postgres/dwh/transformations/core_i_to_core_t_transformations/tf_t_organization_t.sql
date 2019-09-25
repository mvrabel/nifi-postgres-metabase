CREATE OR REPLACE FUNCTION core.tf_t_organization_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from core organization_i input table into core 'today' table organization_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
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

    INSERT INTO core.organization_t (
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
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_organization.organization_id
        ,input_organization.organization_key
        ,input_organization.address_full
        ,input_organization.address_city
        ,input_organization.address_country
        ,input_organization.address_region
        ,input_organization.pipedrive_label
        ,input_party.party_id AS fk_party_id
        ,input_employee_owner.employee_id AS fk_employee_id_owner
        ,input_organization.fk_date_id_created_date
        ,input_organization.created_timestamp
        ,input_organization.fk_date_id_last_updated_date
        ,input_organization.last_updated_timestamp
        ,input_organization.pipedrive_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_organization.tech_row_hash
        ,input_organization.tech_data_load_utc_timestamp
        ,input_organization.tech_data_load_uuid
    FROM core.organization_i AS input_organization
    LEFT JOIN core.party_i AS input_party ON input_organization.fk_party_id = input_party.party_id
        AND input_party.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.employee_i AS input_employee_owner ON input_organization.fk_employee_id_owner = input_employee_owner.employee_id
        AND input_employee_owner.tech_deleted_in_source_system IS FALSE
    WHERE input_organization.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql

