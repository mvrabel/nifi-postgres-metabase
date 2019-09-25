CREATE OR REPLACE FUNCTION core.tf_i_src_jira_trg_release_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'jira_*' tables into core input table release_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_release_i;

    CREATE TEMPORARY TABLE tmp_release_i (
        release_key                     TEXT NOT NULL
        ,jira_id                        INTEGER NOT NULL
        ,fk_date_id_release_date        INTEGER NOT NULL
        ,release_date                   DATE NOT NULL
        ,release_name                   TEXT NOT NULL
        ,release_number                 INTEGER NOT NULL
        ,fk_date_id_start_date          INTEGER NOT NULL
        ,start_date                     DATE NOT NULL
        ,fk_project_id                  INTEGER NOT NULL
        ,description                    TEXT NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULL
        ,tech_deleted_in_source_system  bool DEFAULT false NOT NULL
    );

    INSERT INTO tmp_release_i (
        release_key
        ,jira_id
        ,release_name
        ,release_number
        ,description
        ,fk_date_id_start_date
        ,start_date
        ,fk_date_id_release_date
        ,release_date
        ,fk_project_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        jira_release.release_id AS release_key
        ,jira_release.release_id AS jira_id
        ,jira_release.name AS release_name
        ,CASE
            WHEN project.project_key = 'DEV' THEN SUBSTRING(jira_release.name FROM 2 )::INTEGER
            ELSE -1
        END AS release_number
        ,tf_u_replace_empty_string_with_null_flag(jira_release.description) AS description
        ,COALESCE(REPLACE(jira_release.start_date, '-', '')::INTEGER, -1) AS fk_date_id_start_date
        ,COALESCE(jira_release.start_date::DATE, NULL_DATE) AS start_date
        ,COALESCE(REPLACE(jira_release.release_date, '-', '')::INTEGER, -1) AS fk_date_id_release_date
        ,COALESCE(jira_release.release_date::DATE, NULL_DATE) AS release_date
        ,CASE WHEN project.project_id IS NULL THEN - 1
            ELSE project.project_id
        END AS fk_project_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
           COALESCE(jira_release.NAME, '')
        || COALESCE(jira_release.description, '')
        || COALESCE(jira_release.start_date, '')
        || COALESCE(jira_release.release_date, '')
        || COALESCE(project.project_key, '')
        ) AS tech_row_hash
        ,jira_release.tech_data_load_utc_timestamp
        ,jira_release.tech_data_load_uuid
    FROM stage.jira_release_i AS jira_release
    LEFT JOIN core.project_i AS project ON project.jira_id = jira_release.project_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.release_i (
        release_key
        ,jira_id
        ,release_name
        ,release_number
        ,description
        ,fk_date_id_start_date
        ,start_date
        ,fk_date_id_release_date
        ,release_date
        ,fk_project_id
        ,tech_insert_function
        ,tech_deleted_in_source_system
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_release_i.release_key
        ,tmp_release_i.jira_id
        ,tmp_release_i.release_name
        ,tmp_release_i.release_number
        ,tmp_release_i.description
        ,tmp_release_i.fk_date_id_start_date
        ,tmp_release_i.start_date
        ,tmp_release_i.fk_date_id_release_date
        ,tmp_release_i.release_date
        ,tmp_release_i.fk_project_id
        ,tmp_release_i.tech_insert_function
        ,tmp_release_i.tech_deleted_in_source_system
        ,tmp_release_i.tech_insert_utc_timestamp
        ,tmp_release_i.tech_row_hash
        ,tmp_release_i.tech_data_load_utc_timestamp
        ,tmp_release_i.tech_data_load_uuid
    FROM tmp_release_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
