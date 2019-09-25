CREATE OR REPLACE FUNCTION core.tf_h_contact_ih()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        SCD2 historization of table contact_i.
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-29 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
INFINITY_TIMESTAMP bigint := 300001010000;
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -------------------------------------------
    -------------------------------------------
    --                                       --
    --              NEW RECORDS              --
    --                                       --
    -------------------------------------------
    -------------------------------------------

    ------------------------
    -- INSERT NEW RECORDS --
    ------------------------

    INSERT INTO core.contact_ih (
        contact_key
        ,fk_organization_id
        ,fk_party_id
        ,created_timestamp
        ,phone_number
        ,email_address
        ,location_full
        ,location_city
        ,location_country
        ,pipedrive_label
        ,fk_employee_id_owner
        ,last_updated_timestamp
        ,pipedrive_id
        ,tech_insert_function
        ,tech_begin_effective_utc_timestamp
        ,tech_end_effective_utc_timestamp
        ,tech_is_current
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
	SELECT
		input_contact.contact_key
        ,hist_organization.organization_id AS fk_organization_id
        ,hist_party.party_id AS fk_party_id
        ,input_contact.created_timestamp
        ,input_contact.phone_number
        ,input_contact.email_address
        ,input_contact.location_full
        ,input_contact.location_city
        ,input_contact.location_country
        ,input_contact.pipedrive_label
        ,hist_employee_owner.employee_id AS fk_employee_id_owner
        ,input_contact.last_updated_timestamp
        ,input_contact.pipedrive_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_contact.tech_deleted_in_source_system
        ,input_contact.tech_row_hash
        ,input_contact.tech_data_load_utc_timestamp
        ,input_contact.tech_data_load_uuid
    FROM core.contact_i AS input_contact
    JOIN core.party_i AS input_party ON input_contact.fk_party_id = input_party.party_id
    JOIN core.employee_i AS input_employee_owner ON input_contact.fk_employee_id_owner = input_employee_owner.employee_id
    JOIN core.organization_i AS input_organization ON input_contact.fk_organization_id = input_organization.organization_id
    JOIN core.party_ih AS hist_party ON hist_party.party_key = input_party.party_key
        AND hist_party.tech_is_current = TRUE
    JOIN core.organization_ih AS hist_organization ON hist_organization.organization_key = input_organization.organization_key
        AND hist_organization.tech_is_current = TRUE
    JOIN core.employee_ih AS hist_employee_owner ON hist_employee_owner.employee_key = input_employee_owner.employee_key
        AND hist_employee_owner.tech_is_current = TRUE
    LEFT JOIN core.contact_ih AS hist_contact ON hist_contact.contact_key = input_contact.contact_key
    WHERE hist_contact.contact_key IS NULL;

    -----------------------------------------------
    -----------------------------------------------
    --                                           --
    --              UPDATED RECORDS              --
    --                                           --
    -----------------------------------------------
    -----------------------------------------------

    ------------------------------------------------
    -- GET KEYS OF RECORDS THAT HAVE BEEN UPDATED --
    ------------------------------------------------

    DROP TABLE IF EXISTS updated_contact;
    
    CREATE TEMPORARY TABLE updated_contact (
        contact_key TEXT NOT NULL
    );
    
    INSERT INTO updated_contact (
        contact_key
    )
    SELECT
        input_contact.contact_key
    FROM core.contact_i AS input_contact
    JOIN core.contact_ih AS hist_contact ON hist_contact.contact_key = input_contact.contact_key
        AND hist_contact.tech_is_current = TRUE
    WHERE input_contact.tech_row_hash != hist_contact.tech_row_hash
        -- This "OR" is maybe unnecessary but let's keep it just to be sure.
        OR (
            input_contact.tech_row_hash = hist_contact.tech_row_hash
            AND hist_contact.tech_deleted_in_source_system = TRUE
            AND input_contact.tech_deleted_in_source_system = FALSE
            );

    ----------------------------------------------------------
    -- SET tech_is_current FLAG ON UPDATED RECORDS TO FALSE --
    -- AND                                                  --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP     --
    ----------------------------------------------------------

    UPDATE core.contact_ih AS hist_contact
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM updated_contact
    WHERE updated_contact.contact_key = hist_contact.contact_key
        AND hist_contact.tech_is_current = TRUE;

    ----------------------------
    -- INSERT UPDATED RECORDS --
    ----------------------------

    INSERT INTO core.contact_ih (
        contact_key
        ,fk_organization_id
        ,fk_party_id
        ,created_timestamp
        ,phone_number
        ,email_address
        ,location_full
        ,location_city
        ,location_country
        ,pipedrive_label
        ,fk_employee_id_owner
        ,last_updated_timestamp
        ,pipedrive_id
        ,tech_insert_function
        ,tech_begin_effective_utc_timestamp
        ,tech_end_effective_utc_timestamp
        ,tech_is_current
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_contact.contact_key
        ,hist_organization.organization_id AS fk_organization_id
        ,hist_party.party_id AS fk_party_id
        ,input_contact.created_timestamp
        ,input_contact.phone_number
        ,input_contact.email_address
        ,input_contact.location_full
        ,input_contact.location_city
        ,input_contact.location_country
        ,input_contact.pipedrive_label
        ,hist_employee_owner.employee_id AS fk_employee_id_owner
        ,input_contact.last_updated_timestamp
        ,input_contact.pipedrive_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_contact.tech_deleted_in_source_system
        ,input_contact.tech_row_hash
        ,input_contact.tech_data_load_utc_timestamp
        ,input_contact.tech_data_load_uuid
    FROM core.contact_i AS input_contact
    JOIN core.party_i AS input_party ON input_contact.fk_party_id = input_party.party_id
    JOIN core.employee_i AS input_employee_owner ON input_contact.fk_employee_id_owner = input_employee_owner.employee_id
    JOIN core.organization_i AS input_organization ON input_contact.fk_organization_id = input_organization.organization_id
    JOIN core.party_ih AS hist_party ON hist_party.party_key = input_party.party_key
        AND hist_party.tech_is_current = TRUE
    JOIN core.organization_ih AS hist_organization ON hist_organization.organization_key = input_organization.organization_key
        AND hist_organization.tech_is_current = TRUE
    JOIN core.employee_ih AS hist_employee_owner ON hist_employee_owner.employee_key = input_employee_owner.employee_key
        AND hist_employee_owner.tech_is_current = TRUE
    WHERE input_contact.contact_key IN (SELECT contact_key FROM updated_contact);

    -----------------------------------------------
    -----------------------------------------------
    --                                           --
    --              DELETED RECORDS              --
    --                                           --
    -----------------------------------------------
    -----------------------------------------------

    ------------------------------------------------
    -- GET KEYS OF RECORDS THAT HAVE BEEN DELETED --
    ------------------------------------------------

    DROP TABLE IF EXISTS deleted_contact;

    CREATE TEMPORARY TABLE deleted_contact (
        contact_id INTEGER NOT NULL
    );
    
    INSERT INTO deleted_contact (
        contact_id
    )
    SELECT
        hist_contact.contact_id
    FROM core.contact_ih AS hist_contact
    LEFT JOIN core.contact_i AS input_contact ON input_contact.contact_key = hist_contact.contact_key
    WHERE input_contact.contact_key IS NULL 
        AND hist_contact.tech_is_current = TRUE
        AND hist_contact.tech_deleted_in_source_system = FALSE;

    ---------------------------------------------------------------
    -- SET tech_is_current FLAG ON DELETED RECORDS TO FALSE      --
    -- AND                                                       --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP --
    ---------------------------------------------------------------

    UPDATE core.contact_ih AS hist_contact
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM deleted_contact
    WHERE deleted_contact.contact_id = hist_contact.contact_id
        AND hist_contact.tech_is_current = TRUE;

    ----------------------------
    -- INSERT DELETED RECORDS --
    ----------------------------

    INSERT INTO core.contact_ih (
        contact_key
        ,fk_organization_id
        ,fk_party_id
        ,created_timestamp
        ,phone_number
        ,email_address
        ,location_full
        ,location_city
        ,location_country
        ,pipedrive_label
        ,fk_employee_id_owner
        ,last_updated_timestamp
        ,pipedrive_id
        ,tech_insert_function
        ,tech_begin_effective_utc_timestamp
        ,tech_end_effective_utc_timestamp
        ,tech_is_current
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        hist_contact.contact_key
        ,hist_contact.fk_organization_id
        ,hist_contact.fk_party_id
        ,hist_contact.created_timestamp
        ,hist_contact.phone_number
        ,hist_contact.email_address
        ,hist_contact.location_full
        ,hist_contact.location_city
        ,hist_contact.location_country
        ,hist_contact.pipedrive_label
        ,hist_contact.fk_employee_id_owner
        ,hist_contact.last_updated_timestamp
        ,hist_contact.pipedrive_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,TRUE AS tech_deleted_in_source_system
        ,hist_contact.tech_row_hash
        ,hist_contact.tech_data_load_utc_timestamp
        ,hist_contact.tech_data_load_uuid
    FROM core.contact_ih AS hist_contact
    WHERE hist_contact.contact_id IN (SELECT contact_id FROM deleted_contact);

    RETURN 0;

END;$$

LANGUAGE plpgsql

