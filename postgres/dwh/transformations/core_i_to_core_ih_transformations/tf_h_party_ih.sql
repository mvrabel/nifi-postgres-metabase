CREATE OR REPLACE FUNCTION core.tf_h_party_ih()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        SCD2 historization of table party_i.
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

    INSERT INTO core.party_ih (
        party_key
        ,full_name
        ,short_name
        ,fk_employee_id_last_modified_by
        ,fk_employee_id_created_by
        ,created_timestamp
        ,last_modified_timestamp
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
        input_party.party_key
        ,input_party.full_name
        ,input_party.short_name
        ,hist_employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,hist_employee_created.employee_id AS fk_employee_id_created_by
        ,input_party.created_timestamp
        ,input_party.last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_party.tech_deleted_in_source_system
        ,input_party.tech_row_hash
        ,input_party.tech_data_load_utc_timestamp
        ,input_party.tech_data_load_uuid
    FROM core.party_i AS input_party
    JOIN core.employee_i AS input_employee_created ON input_party.fk_employee_id_created_by = input_employee_created.employee_id
    JOIN core.employee_i AS input_employee_last_modified ON input_party.fk_employee_id_last_modified_by = input_employee_last_modified.employee_id
    JOIN core.employee_ih AS hist_employee_modified ON hist_employee_modified.employee_key = input_employee_last_modified.employee_key
        AND hist_employee_modified.tech_is_current = TRUE
    JOIN core.employee_ih AS hist_employee_created ON hist_employee_created.employee_key = input_employee_created.employee_key
        AND hist_employee_created.tech_is_current = TRUE
    LEFT JOIN core.party_ih AS hist_party ON hist_party.party_key = input_party.party_key
    WHERE hist_party.party_key IS NULL;

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

    DROP TABLE IF EXISTS updated_party;

    CREATE TEMPORARY TABLE updated_party (
        party_key TEXT NOT NULL
    );
    
    INSERT INTO updated_party (
        party_key
    )
    SELECT
        input_party.party_key
    FROM core.party_i AS input_party
    JOIN core.party_ih AS hist_party ON hist_party.party_key = input_party.party_key
        AND hist_party.tech_is_current = TRUE
    WHERE input_party.tech_row_hash != hist_party.tech_row_hash
        -- This "OR" is maybe unnecessary but let's keep it just to be sure.
        OR (
            input_party.tech_row_hash = hist_party.tech_row_hash
            AND hist_party.tech_deleted_in_source_system = TRUE
            AND input_party.tech_deleted_in_source_system = FALSE
            );

    ----------------------------------------------------------
    -- SET tech_is_current FLAG ON UPDATED RECORDS TO FALSE --
    -- AND                                                  --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP     --
    ----------------------------------------------------------

    UPDATE core.party_ih AS hist_party
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM updated_party
    WHERE updated_party.party_key = hist_party.party_key
        AND hist_party.tech_is_current = TRUE;

    ----------------------------
    -- INSERT UPDATED RECORDS --
    ----------------------------

    INSERT INTO core.party_ih (
        party_key
        ,full_name
        ,short_name
        ,fk_employee_id_last_modified_by
        ,fk_employee_id_created_by
        ,created_timestamp
        ,last_modified_timestamp
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
        input_party.party_key
        ,input_party.full_name
        ,input_party.short_name
        ,hist_employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,hist_employee_created.employee_id AS fk_employee_id_created_by
        ,input_party.created_timestamp
        ,input_party.last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_party.tech_deleted_in_source_system
        ,input_party.tech_row_hash
        ,input_party.tech_data_load_utc_timestamp
        ,input_party.tech_data_load_uuid
    FROM core.party_i AS input_party
    JOIN core.employee_i AS input_employee_created ON input_party.fk_employee_id_created_by = input_employee_created.employee_id
    JOIN core.employee_i AS input_employee_last_modified ON input_party.fk_employee_id_last_modified_by = input_employee_last_modified.employee_id
    JOIN core.employee_ih AS hist_employee_modified ON hist_employee_modified.employee_key = input_employee_last_modified.employee_key
        AND hist_employee_modified.tech_is_current = TRUE
    JOIN core.employee_ih AS hist_employee_created ON hist_employee_created.employee_key = input_employee_created.employee_key
        AND hist_employee_created.tech_is_current = TRUE
    WHERE input_party.party_key IN (SELECT party_key FROM updated_party);

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

    DROP TABLE IF EXISTS deleted_party;
    
    CREATE TEMPORARY TABLE deleted_party (
        party_id INTEGER NOT NULL
    );
    
    INSERT INTO deleted_party (
        party_id
    )
    SELECT
        hist_party.party_id
    FROM core.party_ih AS hist_party
    LEFT JOIN core.party_i AS input_party ON input_party.party_key = hist_party.party_key
    WHERE input_party.party_key IS NULL 
        AND hist_party.tech_is_current = TRUE
        AND hist_party.tech_deleted_in_source_system = FALSE;

    ---------------------------------------------------------------
    -- SET tech_is_current FLAG ON DELETED RECORDS TO FALSE      --
    -- AND                                                       --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP --
    ---------------------------------------------------------------

    UPDATE core.party_ih AS hist_party
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM deleted_party
    WHERE deleted_party.party_id = hist_party.party_id
        AND hist_party.tech_is_current = TRUE;

    ----------------------------
    -- INSERT DELETED RECORDS --
    ----------------------------

    INSERT INTO core.party_ih (
        party_key
        ,full_name
        ,short_name
        ,fk_employee_id_last_modified_by
        ,fk_employee_id_created_by
        ,created_timestamp
        ,last_modified_timestamp
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
        hist_party.party_key
        ,hist_party.full_name
        ,hist_party.short_name
        ,hist_party.fk_employee_id_last_modified_by
        ,hist_party.fk_employee_id_created_by
        ,hist_party.created_timestamp
        ,hist_party.last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,TRUE AS tech_deleted_in_source_system
        ,hist_party.tech_row_hash
        ,hist_party.tech_data_load_utc_timestamp
        ,hist_party.tech_data_load_uuid
    FROM core.party_ih AS hist_party
    WHERE hist_party.party_id IN (SELECT party_id FROM deleted_party);

    RETURN 0;

END;$$

LANGUAGE plpgsql

