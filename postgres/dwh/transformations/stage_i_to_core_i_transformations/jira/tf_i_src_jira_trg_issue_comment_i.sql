CREATE OR REPLACE FUNCTION core.tf_i_src_jira_trg_issue_comment_i()
RETURNS INTEGER AS $$

    /*
    =============================================================================================
    DESCRIPTION:        Insert data from stage 'jira_issue_comment_i' table into core input table issue_comment_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-08-28 (YYYY-MM-DD)
    NOTE:
    =============================================================================================
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

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_issue_comment_i;

    CREATE TEMPORARY TABLE tmp_issue_comment_i (
        issue_comment_key               TEXT NOT NULL
        ,fk_date_id_created_date        INTEGER NOT NULL
        ,created_timestamp              TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_last_updated_date   INTEGER NOT NULL
        ,last_updated_timestamp         TIMESTAMP WITH TIME ZONE NOT NULL
        ,body                           TEXT NOT NULL
        ,fk_employee_id_created_by      INTEGER NOT NULL
        ,fk_employee_id_updated_by      INTEGER NOT NULL
        ,fk_issue_id                    INTEGER NOT NULL
        ,is_public                      bool NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_deleted_in_source_system  BOOL NOT NULL DEFAULT FALSE
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULL
    );

    INSERT INTO tmp_issue_comment_i (
        issue_comment_key
        ,body
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,fk_employee_id_created_by
        ,fk_employee_id_updated_by
        ,fk_issue_id
        ,is_public
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        jira_comment.id AS issue_comment_key
        ,jira_comment.body AS body
        ,REPLACE(SUBSTRING(jira_comment.created FROM 1 FOR 10), '-', '')::INTEGER AS fk_date_id_created_date
        ,jira_comment.created::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,REPLACE(SUBSTRING(jira_comment.updated FROM 1 FOR 10), '-', '')::INTEGER AS fk_date_id_last_updated_date
        ,jira_comment.updated::TIMESTAMP WITH TIME ZONE AS last_updated_timestamp
        ,COALESCE(employee_created_by.employee_id, -1) AS fk_employee_id_created_by
        ,COALESCE(employee_updated_by.employee_id, -1) AS fk_employee_id_updated_by
        ,issue.issue_id AS fk_issue_id
        ,jira_comment.jsdpublic AS is_public
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(jira_comment.body::TEXT, '')
            || COALESCE(jira_comment.updated::TEXT, '')
            || COALESCE(jira_comment.jsdpublic::TEXT, '')
            || COALESCE(jira_comment.update_author_account_id::TEXT, '')
        ) AS tech_row_hash
        ,jira_comment.tech_data_load_utc_timestamp
        ,jira_comment.tech_data_load_uuid
    FROM stage.jira_issue_comment_i AS jira_comment
    LEFT JOIN core.employee_i AS employee_created_by ON employee_created_by.employee_key = jira_comment.author_account_id
    LEFT JOIN core.employee_i AS employee_updated_by ON employee_updated_by.employee_key = jira_comment.update_author_account_id
    LEFT JOIN core.issue_i AS issue ON issue.issue_key = jira_comment.issue_key;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.issue_comment_i (
        issue_comment_key
        ,body
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,fk_employee_id_created_by
        ,fk_employee_id_updated_by
        ,fk_issue_id
        ,is_public
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        tmp_issue_comment_i.issue_comment_key
        ,tmp_issue_comment_i.body
        ,tmp_issue_comment_i.fk_date_id_created_date
        ,tmp_issue_comment_i.created_timestamp
        ,tmp_issue_comment_i.fk_date_id_last_updated_date
        ,tmp_issue_comment_i.last_updated_timestamp
        ,tmp_issue_comment_i.fk_employee_id_created_by
        ,tmp_issue_comment_i.fk_employee_id_updated_by
        ,tmp_issue_comment_i.fk_issue_id
        ,tmp_issue_comment_i.is_public
        ,tmp_issue_comment_i.tech_insert_function
        ,tmp_issue_comment_i.tech_insert_utc_timestamp
        ,tmp_issue_comment_i.tech_deleted_in_source_system
        ,tmp_issue_comment_i.tech_row_hash
        ,tmp_issue_comment_i.tech_data_load_utc_timestamp
        ,tmp_issue_comment_i.tech_data_load_uuid
    FROM tmp_issue_comment_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
