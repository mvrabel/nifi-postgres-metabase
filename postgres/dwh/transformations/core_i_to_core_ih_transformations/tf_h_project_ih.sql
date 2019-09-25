CREATE OR REPLACE FUNCTION core.tf_h_project_ih()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:    SCD2 historization of table project_i.
    AUTHOR:         Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:     2018-11-27 (YYYY-MM-DD)
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

    INSERT INTO core.project_ih (
        project_key
        ,jira_id
        ,jira_key
        ,project_name
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
        input_project.project_key
        ,input_project.jira_id
        ,input_project.jira_key
        ,input_project.project_name
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_project.tech_deleted_in_source_system
        ,input_project.tech_row_hash
        ,input_project.tech_data_load_utc_timestamp
        ,input_project.tech_data_load_uuid
    FROM core.project_i AS input_project
    LEFT JOIN core.project_ih AS hist_project ON hist_project.project_key = input_project.project_key
    WHERE hist_project.project_key IS NULL;

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

    DROP TABLE IF EXISTS updated_project;
    
    CREATE TEMPORARY TABLE updated_project (
        project_key TEXT NOT NULL
    );

    INSERT INTO updated_project (
        project_key
    )
    SELECT
        input_project.project_key
    FROM core.project_i AS input_project
    JOIN core.project_ih AS hist_project ON hist_project.project_key = input_project.project_key
        AND hist_project.tech_is_current = TRUE
    WHERE input_project.tech_row_hash != hist_project.tech_row_hash
        -- This "OR" is maybe unnecessary but let's keep it just to be sure.
        OR (
            input_project.tech_row_hash = hist_project.tech_row_hash
            AND hist_project.tech_deleted_in_source_system = TRUE
            AND input_project.tech_deleted_in_source_system = FALSE
            );

    ----------------------------------------------------------
    -- SET tech_is_current FLAG ON UPDATED RECORDS TO FALSE --
    -- AND                                                  --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP     --
    ----------------------------------------------------------

    UPDATE core.project_ih AS hist_project
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM updated_project
    WHERE updated_project.project_key = hist_project.project_key
        AND hist_project.tech_is_current = TRUE;

    ----------------------------
    -- INSERT UPDATED RECORDS --
    ----------------------------

    INSERT INTO core.project_ih (
        project_key
        ,jira_id
        ,jira_key
        ,project_name
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
        input_project.project_key
        ,input_project.jira_id
        ,input_project.jira_key
        ,input_project.project_name
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_project.tech_deleted_in_source_system
        ,input_project.tech_row_hash
        ,input_project.tech_data_load_utc_timestamp
        ,input_project.tech_data_load_uuid
    FROM core.project_i AS input_project
    WHERE input_project.project_key IN (SELECT project_key FROM updated_project);

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

    DROP TABLE IF EXISTS deleted_project;

    CREATE TEMPORARY TABLE deleted_project (
        project_id INTEGER NOT NULL
    );
    
    INSERT INTO deleted_project (
        project_id
    )
    SELECT
        hist_project.project_id
    FROM core.project_ih AS hist_project
    LEFT JOIN core.project_i AS input_project ON input_project.project_key = hist_project.project_key
    WHERE input_project.project_key IS NULL 
        AND hist_project.tech_is_current = TRUE
        AND hist_project.tech_deleted_in_source_system = FALSE;

    ---------------------------------------------------------------
    -- SET tech_is_current FLAG ON DELETED RECORDS TO FALSE      --
    -- AND                                                       --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP --
    ---------------------------------------------------------------

    UPDATE core.project_ih AS hist_project
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM deleted_project
    WHERE deleted_project.project_id = hist_project.project_id
        AND hist_project.tech_is_current = TRUE;

    ----------------------------
    -- INSERT DELETED RECORDS --
    ----------------------------

    INSERT INTO core.project_ih (
        project_key
        ,jira_id
        ,jira_key
        ,project_name
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
        hist_project.project_key
        ,hist_project.jira_id
        ,hist_project.jira_key
        ,hist_project.project_name
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,TRUE AS tech_deleted_in_source_system
        ,hist_project.tech_row_hash
        ,hist_project.tech_data_load_utc_timestamp
        ,hist_project.tech_data_load_uuid
    FROM core.project_ih AS hist_project
    WHERE hist_project.project_id IN (SELECT project_id FROM deleted_project);

    RETURN 0;

END;$$

LANGUAGE plpgsql

