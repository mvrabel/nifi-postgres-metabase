CREATE OR REPLACE FUNCTION core.tf_i_src_jira_trg_project_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'jira_*' tables into core input table project_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
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

    INSERT INTO core.project_i (
        project_id
        ,project_key
        ,jira_id
        ,jira_key
        ,project_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
        -1 -- project_id
        ,TEXT_NULL -- project_key
        ,-1 -- jira_id
        ,TEXT_NULL -- jira_key
        ,TEXT_NULL -- project_name
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,TEXT_NULL -- tech_row_hash
        ,-1 -- tech_data_load_utc_timestamp
        ,TEXT_NULL -- tech_data_load_uuid
    );

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_project_i;

    CREATE TEMPORARY TABLE tmp_project_i (
        project_key                     TEXT NOT NULL
        ,jira_id                        INTEGER NOT NULL
        ,jira_key                       TEXT NOT NULL
        ,project_name                   TEXT NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULL
        ,tech_deleted_in_source_system  bool DEFAULT false NOT NULL
    );

    INSERT INTO tmp_project_i (
        project_key
        ,jira_key
        ,jira_id
        ,project_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT 
        jira_project.project_key AS project_key
        ,jira_project.project_key AS jira_key
        ,jira_project.project_id AS jira_id
        ,jira_project.name AS project_name
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
        COALESCE(jira_project.name,'')
        ) AS tech_row_hash
        ,jira_project.tech_data_load_utc_timestamp
        ,jira_project.tech_data_load_uuid
    FROM stage.jira_project_i AS jira_project;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.project_i (
        project_key
        ,jira_key
        ,jira_id
        ,project_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_project_i.project_key
        ,tmp_project_i.jira_key
        ,tmp_project_i.jira_id
        ,tmp_project_i.project_name
        ,tmp_project_i.tech_insert_function
        ,tmp_project_i.tech_insert_utc_timestamp
        ,tmp_project_i.tech_deleted_in_source_system
        ,tmp_project_i.tech_row_hash
        ,tmp_project_i.tech_data_load_utc_timestamp
        ,tmp_project_i.tech_data_load_uuid		
    FROM tmp_project_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
