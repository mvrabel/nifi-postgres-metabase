CREATE OR REPLACE FUNCTION core.tf_h_organization_ih()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        SCD2 historization of table organization_i.
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

    INSERT INTO core.organization_ih (
        organization_key
        ,fk_party_id
        ,created_timestamp
        ,address_full
        ,address_city
        ,address_country
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
        input_organization.organization_key
        ,hist_party.party_id AS fk_party_id
        ,input_organization.created_timestamp
        ,input_organization.address_full
        ,input_organization.address_city
        ,input_organization.address_country
        ,input_organization.pipedrive_label
        ,hist_employee_owner.employee_id AS fk_employee_id_owner
        ,input_organization.last_updated_timestamp
        ,input_organization.pipedrive_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_organization.tech_deleted_in_source_system
        ,input_organization.tech_row_hash
        ,input_organization.tech_data_load_utc_timestamp
        ,input_organization.tech_data_load_uuid
    FROM core.organization_i AS input_organization
    JOIN core.employee_i AS input_employee_owner ON input_organization.fk_employee_id_owner = input_employee_owner.employee_id    
    JOIN core.employee_ih AS hist_employee_owner ON hist_employee_owner.employee_key = input_employee_owner.employee_key
        AND hist_employee_owner.tech_is_current = TRUE
    JOIN core.party_i AS input_party ON input_organization.fk_party_id = input_party.party_id    
    JOIN core.party_ih AS hist_party ON hist_party.party_key = input_party.party_key
        AND hist_party.tech_is_current = TRUE
    LEFT JOIN core.organization_ih AS hist_organization ON hist_organization.organization_key = input_organization.organization_key
    WHERE hist_organization.organization_key IS NULL;

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

    DROP TABLE IF EXISTS updated_organization;

    CREATE TEMPORARY TABLE updated_organization (
        organization_key TEXT NOT NULL
    );
    
    INSERT INTO updated_organization (
        organization_key
    )
    SELECT
        input_organization.organization_key
    FROM core.organization_i AS input_organization
    JOIN core.organization_ih AS hist_organization ON hist_organization.organization_key = input_organization.organization_key
        AND hist_organization.tech_is_current = TRUE
    WHERE input_organization.tech_row_hash != hist_organization.tech_row_hash
        -- This "OR" is maybe unnecessary but let's keep it just to be sure.
        OR (
            input_organization.tech_row_hash = hist_organization.tech_row_hash
            AND hist_organization.tech_deleted_in_source_system = TRUE
            AND input_organization.tech_deleted_in_source_system = FALSE
    );

    ----------------------------------------------------------
    -- SET tech_is_current FLAG ON UPDATED RECORDS TO FALSE --
    -- AND                                                  --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP     --
    ----------------------------------------------------------

    UPDATE core.organization_ih AS hist_organization
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM updated_organization
    WHERE updated_organization.organization_key = hist_organization.organization_key
        AND hist_organization.tech_is_current = TRUE;

    ----------------------------
    -- INSERT UPDATED RECORDS --
    ----------------------------

    INSERT INTO core.organization_ih (
        organization_key
        ,fk_party_id
        ,created_timestamp
        ,address_full
        ,address_city
        ,address_country
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
        input_organization.organization_key
        ,hist_party.party_id AS fk_party_id
        ,input_organization.created_timestamp
        ,input_organization.address_full
        ,input_organization.address_city
        ,input_organization.address_country
        ,input_organization.pipedrive_label
        ,hist_employee_owner.employee_id AS fk_employee_id_owner
        ,input_organization.last_updated_timestamp
        ,input_organization.pipedrive_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_organization.tech_deleted_in_source_system
        ,input_organization.tech_row_hash
        ,input_organization.tech_data_load_utc_timestamp
        ,input_organization.tech_data_load_uuid
    FROM core.organization_i AS input_organization
    JOIN core.employee_i AS input_employee_owner ON input_organization.fk_employee_id_owner = input_employee_owner.employee_id    
    JOIN core.employee_ih AS hist_employee_owner ON hist_employee_owner.employee_key = input_employee_owner.employee_key
        AND hist_employee_owner.tech_is_current = TRUE
    JOIN core.party_i AS input_party ON input_organization.fk_party_id = input_party.party_id    
    JOIN core.party_ih AS hist_party ON hist_party.party_key = input_party.party_key
        AND hist_party.tech_is_current = TRUE
    WHERE input_organization.organization_key IN (SELECT organization_key FROM updated_organization);

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

    DROP TABLE IF EXISTS deleted_organization;

    CREATE TEMPORARY TABLE deleted_organization (
        organization_id INTEGER NOT NULL
    );
    
    INSERT INTO deleted_organization (
        organization_id
    )
    SELECT
        hist_organization.organization_id
    FROM core.organization_ih AS hist_organization
    LEFT JOIN core.organization_i AS input_organization ON input_organization.organization_key = hist_organization.organization_key
    WHERE input_organization.organization_key IS NULL 
        AND hist_organization.tech_is_current = TRUE
        AND hist_organization.tech_deleted_in_source_system = FALSE;

    ---------------------------------------------------------------
    -- SET tech_is_current FLAG ON DELETED RECORDS TO FALSE      --
    -- AND                                                       --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP --
    ---------------------------------------------------------------

    UPDATE core.organization_ih AS hist_organization
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM deleted_organization
    WHERE deleted_organization.organization_id = hist_organization.organization_id
        AND hist_organization.tech_is_current = TRUE;

    ----------------------------
    -- INSERT DELETED RECORDS --
    ----------------------------

    INSERT INTO core.organization_ih (
        organization_key
        ,fk_party_id
        ,created_timestamp
        ,address_full
        ,address_city
        ,address_country
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
        hist_organization.organization_key
        ,hist_organization.fk_party_id
        ,hist_organization.created_timestamp
        ,hist_organization.address_full
        ,hist_organization.address_city
        ,hist_organization.address_country
        ,hist_organization.pipedrive_label
        ,hist_organization.fk_employee_id_owner
        ,hist_organization.last_updated_timestamp
        ,hist_organization.pipedrive_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,TRUE AS tech_deleted_in_source_system
        ,hist_organization.tech_row_hash
        ,hist_organization.tech_data_load_utc_timestamp
        ,hist_organization.tech_data_load_uuid
    FROM core.organization_ih AS hist_organization
    WHERE hist_organization.organization_id IN (SELECT organization_id FROM deleted_organization);

    RETURN 0;

END;$$

LANGUAGE plpgsql

