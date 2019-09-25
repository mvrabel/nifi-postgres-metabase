CREATE OR REPLACE FUNCTION core.tf_i_src_jira_trg_issue_relation_map_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'jira_*' tables into core input table issue_relation_map_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

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
    FUNCTION_NAME = SUBSTRING(stack FROM 'function (.*?) line')::text;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_issue_relation_map_i;

    CREATE TEMPORARY TABLE tmp_issue_relation_map_i (
        issue_key                       TEXT NOT NULL
        ,issue_key_related_issue        TEXT NOT NULL
        ,fk_issue_id                    INTEGER NOT NULL
        ,fk_issue_id_related_issue      INTEGER NOT NULL
        ,relation                       TEXT NOT NULL
        ,relation_direction             TEXT NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULl
        ,tech_deleted_in_source_system  bool DEFAULT false NOT NULL
    );

    INSERT INTO tmp_issue_relation_map_i (
        issue_key
        ,issue_key_related_issue
        ,fk_issue_id
        ,fk_issue_id_related_issue
        ,relation
        ,relation_direction
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        issue_relation_map.issue_key AS issue_key
        ,issue_relation_map.issue_key_related_issue AS issue_key_related_issue
        ,issue.issue_id AS fk_issue_id
        ,related_issue.issue_id AS fk_issue_id_related_issue
        ,relation AS relation
        ,relation_direction	AS relation_direction
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
               COALESCE(issue.issue_key, '')::TEXT
            || COALESCE(related_issue.issue_key, '')::TEXT
            || COALESCE(relation, '')
            || COALESCE(relation_direction, '')
        ) AS tech_row_hash
        ,issue_relation_map.tech_data_load_utc_timestamp
        ,issue_relation_map.tech_data_load_uuid
    FROM stage.jira_issue_relation_i AS issue_relation_map
    LEFT JOIN core.issue_i AS issue ON issue.jira_key = issue_relation_map.issue_key
    LEFT JOIN core.issue_i AS related_issue ON related_issue.jira_key = issue_relation_map.issue_key_related_issue;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.issue_relation_map_i (
        issue_key
        ,issue_key_related_issue
        ,fk_issue_id
        ,fk_issue_id_related_issue
        ,relation
        ,relation_direction
        ,tech_insert_function
        ,tech_deleted_in_source_system
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        tmp_issue_relation_map_i.issue_key
        ,tmp_issue_relation_map_i.issue_key_related_issue
        ,tmp_issue_relation_map_i.fk_issue_id
        ,tmp_issue_relation_map_i.fk_issue_id_related_issue
        ,tmp_issue_relation_map_i.relation
        ,tmp_issue_relation_map_i.relation_direction
        ,tmp_issue_relation_map_i.tech_insert_function
        ,tmp_issue_relation_map_i.tech_deleted_in_source_system
        ,tmp_issue_relation_map_i.tech_insert_utc_timestamp
        ,tmp_issue_relation_map_i.tech_row_hash
        ,tmp_issue_relation_map_i.tech_data_load_utc_timestamp
        ,tmp_issue_relation_map_i.tech_data_load_uuid
    FROM tmp_issue_relation_map_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
