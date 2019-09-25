CREATE OR REPLACE FUNCTION core.tf_i_src_jira_trg_worklog_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'jira_*' tables into core input table worklog_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
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

    DROP TABLE IF EXISTS tmp_worklog_i;

    CREATE TEMPORARY TABLE tmp_worklog_i (
        worklog_key                     TEXT NOT NULL
        ,tempo_id                       INTEGER NOT NULL
        ,time_logged                    INTERVAL NOT NULL
        ,hours_logged                   NUMERIC(10, 5) NOT NULL
        ,days_logged                    NUMERIC(10, 5) NOT NULL
        ,worklog_comment                TEXT NOT NULL
        ,fk_issue_id                    INTEGER NOT NULL
        ,fk_employee_id_created_by      INTEGER NOT NULL
        ,fk_date_id_work_started_date   INTEGER NOT NULL
        ,work_started_at_timestamp      TIMESTAMP WITH TIME ZONE NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULL
        ,tech_deleted_in_source_system  bool DEFAULT false NOT NULL
    );

    INSERT INTO tmp_worklog_i (
        worklog_key
        ,tempo_id
        ,time_logged
        ,hours_logged
        ,days_logged
        ,worklog_comment
        ,fk_issue_id
        ,fk_employee_id_created_by
        ,fk_date_id_work_started_date
        ,work_started_at_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        jira_tempo_worklog.tempo_worklog_id AS worklog_key
        ,jira_tempo_worklog.tempo_worklog_id AS tempo_id
        ,(time_logged_seconds || ' ' || 'seconds')::INTERVAL AS time_logged
        ,tf_u_convert_interval_to_hours((time_logged_seconds || ' ' || 'seconds')::INTERVAL) AS hours_logged
        ,tf_u_convert_interval_to_days((time_logged_seconds || ' ' || 'seconds')::INTERVAL) AS days_logged
        ,tf_u_replace_empty_string_with_null_flag(jira_tempo_worklog.worklog_comment) AS worklog_comment
        ,issue.issue_id AS fk_issue_id
        ,COALESCE(employee.employee_id, -1) AS fk_employee_id_created_by
        ,REPLACE(jira_tempo_worklog.work_started_at_date, '-', '')::INTEGER AS fk_date_id_work_started_date
        ,(jira_tempo_worklog.work_started_at_date || ' ' || jira_tempo_worklog.work_started_at_time || ' UTC')::TIMESTAMP WITH TIME ZONE AS work_started_at_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
           COALESCE(jira_tempo_worklog.worklog_comment, '')
        || COALESCE(jira_tempo_worklog.time_logged_seconds, 0)
        || COALESCE(jira_tempo_worklog.work_started_at_date, '')
        || COALESCE(jira_tempo_worklog.work_started_at_time, '')
        || COALESCE(jira_tempo_worklog.author_account_id, '')
        ) AS tech_row_hash
        ,jira_tempo_worklog.tech_data_load_utc_timestamp
        ,jira_tempo_worklog.tech_data_load_uuid
    FROM stage.jira_worklog_i AS jira_tempo_worklog
    LEFT JOIN core.issue_i AS issue ON issue.jira_id = jira_tempo_worklog.issue_id
    LEFT JOIN core.employee_i AS employee ON employee.employee_key = jira_tempo_worklog.author_account_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.worklog_i (
        worklog_key
        ,tempo_id
        ,time_logged
        ,hours_logged
        ,days_logged
        ,worklog_comment
        ,fk_issue_id
        ,fk_employee_id_created_by
        ,fk_date_id_work_started_date
        ,work_started_at_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT 		
        tmp_worklog_i.worklog_key
        ,tmp_worklog_i.tempo_id
        ,tmp_worklog_i.time_logged
        ,tmp_worklog_i.hours_logged
        ,tmp_worklog_i.days_logged
        ,tmp_worklog_i.worklog_comment
        ,tmp_worklog_i.fk_issue_id
        ,tmp_worklog_i.fk_employee_id_created_by
        ,tmp_worklog_i.fk_date_id_work_started_date
        ,tmp_worklog_i.work_started_at_timestamp
        ,tmp_worklog_i.tech_insert_function
        ,tmp_worklog_i.tech_insert_utc_timestamp
        ,tmp_worklog_i.tech_deleted_in_source_system
        ,tmp_worklog_i.tech_row_hash
        ,tmp_worklog_i.tech_data_load_utc_timestamp
        ,tmp_worklog_i.tech_data_load_uuid
    FROM tmp_worklog_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
