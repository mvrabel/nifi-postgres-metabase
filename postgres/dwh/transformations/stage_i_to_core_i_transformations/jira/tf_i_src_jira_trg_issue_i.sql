CREATE OR REPLACE FUNCTION core.tf_i_src_jira_trg_issue_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'jira_*' tables into core input table issue_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
DATE_NEVER DATE := (SELECT date_never FROM core.c_null_replacement_g);
INTERVAL_NEVER INTERVAL := (SELECT interval_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
DEVELOPMENT_PROJECT_KEY TEXT := 'DEV';
SUPPORT_ISSUE_FLAG TEXT := 'Support';
COMMON_SUPPORT_ISSUE_ACCOUNT_FLAG TEXT := 'Common';
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

    INSERT INTO core.issue_i (
        issue_id
        ,jira_key
        ,jira_id
        ,issue_key
        ,account
        ,customer
        ,status
        ,summary
        ,priority
        ,sla_priority
        ,description
        ,issue_type
        ,resolution
        ,deployment
        ,epic_name
        ,epic_jira_key
        ,original_estimate
        ,remaining_estimate
        ,aggregate_original_estimate
        ,aggregate_remaining_estimate
        ,hours_logged_total
        ,days_logged_total
        ,labels
        ,components
        ,fix_versions
        ,affected_versions
        ,inception_to_first_response_days
        ,inception_to_pilot_days
        ,inception_to_sales_days
        ,inception_to_deployment_days
        ,inception_to_resolution_days
        ,inception_to_now_days
        ,first_response_to_resolution_days
        ,activation_to_pilot_days
        ,activation_to_sales_days
        ,activation_to_deployment_days
        ,activation_to_now_days
        ,pilot_to_pilot_finished_days
        ,pilot_to_sales_days
        ,pilot_to_deployment_days
        ,pilot_to_now_days
        ,pilot_finished_to_sales_days
        ,pilot_finished_to_now_days
        ,sales_to_deployment_days
        ,sales_to_now_days
        ,deployment_to_now_days
        ,fk_date_id_activation_date
        ,activation_timestamp
        ,fk_date_id_first_response_date
        ,first_response_timestamp
        ,fk_date_id_resolution_date
        ,resolution_timestamp
        ,fk_date_id_pilot_date
        ,pilot_date
        ,fk_date_id_pilot_finished_date
        ,pilot_finished_date
        ,fk_date_id_sales_date
        ,sales_date
        ,fk_project_id
        ,fk_party_id_created_by
        ,fk_party_id_reported_by
        ,fk_employee_id_assigned_to
        ,fk_date_id_inception_date
        ,inception_date
        ,fk_date_id_deployment_date
        ,deployment_date
        ,fk_date_id_created_date
        ,created_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
        -1 -- issue_id
        ,TEXT_NULL -- jira_key
        ,-1 -- jira_id
        ,TEXT_NULL -- issue_key
        ,TEXT_NULL -- account
        ,TEXT_NULL -- customer
        ,TEXT_NULL -- status
        ,TEXT_NULL -- summary
        ,TEXT_NULL -- priority
        ,TEXT_NULL -- sla_priority
        ,TEXT_NULL -- description
        ,TEXT_NULL -- issue_type
        ,TEXT_NULL -- resolution
        ,TEXT_NULL -- deployment
        ,TEXT_NULL -- epic_name
        ,TEXT_NULL -- epic_jira_key
        ,INTERVAL_NEVER -- original_estimate
        ,INTERVAL_NEVER -- remaining_estimate
        ,INTERVAL_NEVER -- aggregate_original_estimate
        ,INTERVAL_NEVER -- aggregate_remaining_estimate
        ,0 -- hours_logged_total
        ,0 -- days_logged_total
        ,TEXT_ARRAY_NULL -- labels
        ,TEXT_ARRAY_NULL -- components
        ,TEXT_ARRAY_NULL -- fix_versions
        ,TEXT_ARRAY_NULL -- affected_versions
        ,-1 -- inception_to_first_response_days
        ,-1 -- inception_to_pilot_days
        ,-1 -- inception_to_sales_days
        ,-1 -- inception_to_deployment_days
        ,-1 -- inception_to_resolution_days
        ,-1 -- inception_to_now_days
        ,-1 -- first_response_to_resolution_days
        ,-1 -- activation_to_pilot_days
        ,-1 -- activation_to_sales_days
        ,-1 -- activation_to_deployment_days
        ,-1 -- activation_to_now_days
        ,-1 -- pilot_to_pilot_finished_days
        ,-1 -- pilot_to_sales_days
        ,-1 -- pilot_to_deployment_days
        ,-1 -- pilot_to_now_days
        ,-1 -- pilot_finished_to_sales_days
        ,-1 -- pilot_finished_to_now_days
        ,-1 -- sales_to_deployment_days
        ,-1 -- sales_to_now_days
        ,-1 -- deployment_to_now_days
        ,-1 -- fk_date_id_activation_date
        ,TIMESTAMP_NEVER -- activation_timestamp
        ,-1 -- fk_date_id_first_response_date
        ,TIMESTAMP_NEVER -- first_response_timestamp
        ,-1 -- fk_date_id_resolution_date
        ,TIMESTAMP_NEVER -- resolution_timestamp
        ,-1 -- fk_date_id_pilot_date
        ,DATE_NEVER -- pilot_date
        ,-1 -- fk_date_id_pilot_finished_date
        ,DATE_NEVER -- pilot_finished_date
        ,-1 -- fk_date_id_sales_date
        ,DATE_NEVER -- sales_date
        ,-1 -- fk_project_id
        ,-1 -- fk_party_id_created_by
        ,-1 -- fk_party_id_reported_by
        ,-1 -- fk_employee_id_assigned_to
        ,-1 -- fk_date_id_inception_date
        ,DATE_NEVER -- inception_date
        ,-1 -- fk_date_id_deployment_date
        ,DATE_NEVER -- deployment_date
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
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
    
    DROP TABLE IF EXISTS tmp_issue_i;
        
    CREATE TEMPORARY TABLE tmp_issue_i (
        issue_key                               TEXT NOT NULL
        ,jira_key                               TEXT NOT NULL
        ,jira_id                                INTEGER NOT NULL
        ,status                                 TEXT NOT NULL
        ,summary                                TEXT NOT NULL
        ,priority                               TEXT NOT NULL
        ,sla_priority                           TEXT NOT NULL
        ,description                            TEXT NOT NULL
        ,issue_type                             TEXT NOT NULL
        ,resolution                             TEXT NOT NULL
        ,deployment                             TEXT NOT NULL
        ,epic_name                              TEXT NOT NULL
        ,epic_jira_key                          TEXT NOT NULL
        ,original_estimate                      INTERVAL
        ,remaining_estimate                     INTERVAL
        ,aggregate_original_estimate            INTERVAL
        ,aggregate_remaining_estimate           INTERVAL
        ,hours_logged_total                     NUMERIC(10,5)
        ,days_logged_total                      NUMERIC(10,5)
        ,labels                                 TEXT[]
        ,components                             TEXT[]
        ,fix_versions                           TEXT[]
        ,affected_versions                      TEXT[]
        ,inception_to_first_response_days       INTEGER NOT NULL
        ,inception_to_pilot_days                INTEGER NOT NULL
        ,inception_to_sales_days                INTEGER NOT NULL
        ,inception_to_deployment_days           INTEGER NOT NULL
        ,inception_to_resolution_days           INTEGER NOT NULL
        ,inception_to_now_days                  INTEGER NOT NULL
        ,first_response_to_resolution_days      INTEGER NOT NULL
        ,activation_to_pilot_days               INTEGER NOT NULL
        ,activation_to_sales_days               INTEGER NOT NULL
        ,activation_to_deployment_days          INTEGER NOT NULL
        ,activation_to_now_days                 INTEGER NOT NULL
        ,pilot_to_pilot_finished_days           INTEGER NOT NULL
        ,pilot_to_sales_days                    INTEGER NOT NULL
        ,pilot_to_deployment_days               INTEGER NOT NULL
        ,pilot_to_now_days                      INTEGER NOT NULL
        ,pilot_finished_to_sales_days           INTEGER NOT NULL
        ,pilot_finished_to_now_days             INTEGER NOT NULL
        ,sales_to_deployment_days               INTEGER NOT NULL
        ,sales_to_now_days                      INTEGER NOT NULL
        ,deployment_to_now_days                 INTEGER NOT NULL
        ,fk_project_id                          INTEGER NOT NULL
        ,fk_party_id_created_by                 INTEGER NOT NULL
        ,fk_party_id_reported_by                INTEGER NOT NULL
        ,fk_employee_id_assigned_to             INTEGER NOT NULL
        ,account                                TEXT NOT NULL
        ,customer                               TEXT NOT NULL
        ,fk_date_id_activation_date             INTEGER NOT NULL
        ,activation_timestamp                   TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_inception_date              INTEGER NOT NULL
        ,inception_date                         DATE NOT NULL
        ,fk_date_id_pilot_date                  INTEGER NOT NULL
        ,pilot_date                             DATE NOT NULL
        ,fk_date_id_pilot_finished_date         INTEGER NULL
        ,pilot_finished_date                    DATE NOT NULL
        ,fk_date_id_sales_date                  INTEGER NOT NULL
        ,sales_date                             DATE NOT NULL
        ,fk_date_id_deployment_date             INTEGER NOT NULL
        ,deployment_date                        DATE NOT NULL
        ,fk_date_id_first_response_date         INTEGER NOT NULL
        ,first_response_timestamp               TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_created_date                INTEGER NOT NULL
        ,created_timestamp                      TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_resolution_date             INTEGER NOT NULL
        ,resolution_timestamp                   TIMESTAMP WITH TIME ZONE
        ,tech_insert_function                   TEXT NOT NULL
        ,tech_insert_utc_timestamp              BIGINT NOT NULL
        ,tech_row_hash                          TEXT NOT NULL
        ,tech_data_load_utc_timestamp           BIGINT NOT NULL
        ,tech_data_load_uuid                    TEXT NOT NULL
        ,tech_deleted_in_source_system          bool DEFAULT false NOT NULL
    );

    WITH first_worklog_for_issue AS (
        WITH ranked_worklogs AS (
            SELECT
                jira_issue.issue_id
                ,(jira_tempo_worklog.work_started_at_date || ' ' || jira_tempo_worklog.work_started_at_time || ' UTC')::TIMESTAMP WITH TIME ZONE AS work_started_at_timestamp
                ,RANK() OVER (
                    PARTITION BY jira_issue.issue_id ORDER BY jira_tempo_worklog.work_started_at_date ASC, jira_tempo_worklog.work_started_at_time ASC
                ) AS worklogs_asc_rank
            FROM stage.jira_issue_i AS jira_issue
        LEFT JOIN stage.jira_worklog_i AS jira_tempo_worklog ON jira_issue.issue_id = jira_tempo_worklog.issue_id
        GROUP BY jira_issue.issue_id, jira_tempo_worklog.work_started_at_date, jira_tempo_worklog.work_started_at_time
        )
        SELECT
            ranked_worklogs.issue_id
            ,ranked_worklogs.work_started_at_timestamp
        FROM ranked_worklogs
        WHERE ranked_worklogs.worklogs_asc_rank = 1
    )
    ,issue_dates AS (
        SELECT 
            jira_issue.issue_id
            ,COALESCE(jira_issue.inception_date::DATE, jira_issue.created_timestamp::DATE) AS inception_date
            ,jira_issue.created_timestamp::TIMESTAMP WITH TIME ZONE AS created_timestamp
            ,COALESCE(
                LEAST(
                    first_worklog_for_issue.work_started_at_timestamp::TIMESTAMP WITH TIME ZONE
                    ,jira_issue.pilot_date::DATE
                    ,jira_issue.pilot_finished_date::DATE
                    ,jira_issue.sales_date::DATE
                )
                ,jira_issue.created_timestamp::DATE
                ,jira_issue.inception_date::DATE
            ) AS activation_timestamp
            ,jira_issue.first_response_timestamp::TIMESTAMP WITH TIME ZONE AS first_response_timestamp
            ,jira_issue.resolution_timestamp::TIMESTAMP WITH TIME ZONE AS resolution_timestamp
            ,jira_issue.pilot_date::DATE AS pilot_date
            ,jira_issue.pilot_finished_date::DATE AS pilot_finished_date
            ,jira_issue.sales_date::DATE AS sales_date
            ,jira_issue.deployment_date::DATE AS deployment_date
         FROM stage.jira_issue_i AS jira_issue
         LEFT JOIN first_worklog_for_issue ON first_worklog_for_issue.issue_id = jira_issue.issue_id
    )
    ,hours_logged_per_issue_in_aggregate AS (
        SELECT
            jira_issue.issue_id
            ,COALESCE(SUM((time_logged_seconds || ' ' || 'seconds')::INTERVAL), '0 seconds'::INTERVAL) AS time_interval_logged
            ,COALESCE(tf_u_convert_interval_to_hours(SUM((jira_tempo_worklog.time_logged_seconds || ' ' || 'seconds')::INTERVAL)), 0) AS hours_logged_total
            ,COALESCE(tf_u_convert_interval_to_days(SUM((jira_tempo_worklog.time_logged_seconds || ' ' || 'seconds')::INTERVAL)), 0) AS days_logged_total
        FROM stage.jira_issue_i AS jira_issue
        LEFT JOIN stage.jira_worklog_i AS jira_tempo_worklog ON jira_issue.issue_id = jira_tempo_worklog.issue_id
        GROUP BY jira_issue.issue_id
    )
    INSERT INTO tmp_issue_i (
        issue_key
        ,jira_key
        ,jira_id
        ,account
        ,customer
        ,status
        ,summary
        ,priority
        ,sla_priority
        ,description
        ,issue_type
        ,resolution
        ,deployment
        ,epic_name
        ,epic_jira_key
        ,original_estimate
        ,remaining_estimate
        ,aggregate_original_estimate
        ,aggregate_remaining_estimate
        ,hours_logged_total
        ,days_logged_total
        ,labels
        ,components
        ,fix_versions
        ,affected_versions
        ,inception_to_first_response_days
        ,inception_to_pilot_days
        ,inception_to_sales_days
        ,inception_to_deployment_days
        ,inception_to_resolution_days
        ,inception_to_now_days
        ,first_response_to_resolution_days
        ,activation_to_pilot_days
        ,activation_to_sales_days
        ,activation_to_deployment_days
        ,activation_to_now_days
        ,pilot_to_pilot_finished_days
        ,pilot_to_sales_days
        ,pilot_to_deployment_days
        ,pilot_to_now_days
        ,pilot_finished_to_sales_days
        ,pilot_finished_to_now_days
        ,sales_to_deployment_days
        ,sales_to_now_days
        ,deployment_to_now_days
        ,fk_date_id_activation_date
        ,activation_timestamp
        ,fk_date_id_first_response_date
        ,first_response_timestamp
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_resolution_date
        ,resolution_timestamp
        ,fk_date_id_inception_date
        ,inception_date
        ,fk_date_id_pilot_date
        ,pilot_date
        ,fk_date_id_pilot_finished_date
        ,pilot_finished_date
        ,fk_date_id_sales_date
        ,sales_date
        ,fk_date_id_deployment_date
        ,deployment_date
        ,fk_project_id
        ,fk_party_id_created_by
        ,fk_party_id_reported_by
        ,fk_employee_id_assigned_to
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT 
        jira_issue.issue_key AS issue_key
        ,jira_issue.issue_key AS jira_key
        ,jira_issue.issue_id AS jira_id
        ,CASE
            WHEN jira_issue.account_name IS NULL
                AND jira_issue.project_key = DEVELOPMENT_PROJECT_KEY
                AND jira_issue.issue_type = SUPPORT_ISSUE_FLAG
                AND POSITION(' - ' IN jira_issue.summary) = 0
                    THEN COMMON_SUPPORT_ISSUE_ACCOUNT_FLAG
            WHEN jira_issue.account_name IS NULL
                AND jira_issue.project_key = DEVELOPMENT_PROJECT_KEY
                AND jira_issue.issue_type = SUPPORT_ISSUE_FLAG
                AND POSITION(' - ' IN jira_issue.summary) > 0
                    THEN SUBSTRING(jira_issue.summary FROM 0 FOR position(' - ' IN jira_issue.summary))
            ELSE tf_u_replace_empty_string_with_null_flag(jira_issue.account_name)
        END AS account
        ,CASE
            WHEN jira_tempo_account.customer_name IS NULL
                AND jira_issue.project_key = DEVELOPMENT_PROJECT_KEY
                AND jira_issue.issue_type = SUPPORT_ISSUE_FLAG
                AND POSITION(' - ' IN jira_issue.summary) = 0
                    THEN COMMON_SUPPORT_ISSUE_ACCOUNT_FLAG
            WHEN jira_tempo_account.customer_name IS NULL
                AND jira_issue.project_key = DEVELOPMENT_PROJECT_KEY
                AND jira_issue.issue_type = SUPPORT_ISSUE_FLAG
                AND POSITION(' - ' IN jira_issue.summary) > 0
                    THEN SUBSTRING(jira_issue.summary FROM 0 FOR position(' - ' IN jira_issue.summary))
            ELSE tf_u_replace_empty_string_with_null_flag(jira_tempo_account.customer_name)
        END AS customer
        ,tf_u_replace_empty_string_with_null_flag(jira_issue.status) AS status
        ,tf_u_replace_empty_string_with_null_flag(jira_issue.summary) AS summary
        ,tf_u_replace_empty_string_with_null_flag(jira_issue.priority) AS priority
        ,tf_u_replace_empty_string_with_null_flag(jira_issue.sla_priority) AS sla_priority
        ,tf_u_replace_empty_string_with_null_flag(jira_issue.description) AS description
        ,tf_u_replace_empty_string_with_null_flag(jira_issue.issue_type) AS issue_type
        ,tf_u_replace_empty_string_with_null_flag(jira_issue.resolution) AS resolution
        ,tf_u_replace_empty_string_with_null_flag(jira_issue.deployment) AS deployment
        ,tf_u_replace_empty_string_with_null_flag(epic_issue.summary) AS epic_name
        ,tf_u_replace_empty_string_with_null_flag(epic_issue.issue_key) AS epic_jira_key
        ,COALESCE((jira_issue.original_estimate_seconds || ' seconds')::INTERVAL, INTERVAL_NEVER) AS original_estimate
        ,COALESCE((jira_issue.remaining_estimate_seconds || ' seconds')::INTERVAL, INTERVAL_NEVER) AS remaining_estimate
        ,COALESCE((jira_issue.aggregate_original_estimate_seconds || ' seconds')::INTERVAL, INTERVAL_NEVER) AS aggregate_original_estimate
        ,COALESCE((jira_issue.aggregate_remaining_estimate_seconds || ' seconds')::INTERVAL, INTERVAL_NEVER) AS aggregate_remaining_estimate
        ,hours_logged_per_issue_in_aggregate.hours_logged_total
        ,hours_logged_per_issue_in_aggregate.days_logged_total
        ,string_to_array(tf_u_replace_empty_string_with_null_flag(jira_issue.labels),',') AS labels
        ,string_to_array(tf_u_replace_empty_string_with_null_flag(jira_issue.components),',') AS components
        ,string_to_array(tf_u_replace_empty_string_with_null_flag(jira_issue.fix_versions),',') AS fix_versions
        ,string_to_array(tf_u_replace_empty_string_with_null_flag(jira_issue.affected_versions),',') AS affected_versions
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.first_response_timestamp::DATE, issue_dates.inception_date), -1) AS inception_to_first_response_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.pilot_date, issue_dates.inception_date), -1) AS inception_to_pilot_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.sales_date, issue_dates.inception_date), -1) AS inception_to_sales_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.deployment_date, issue_dates.inception_date), -1) AS inception_to_deployment_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.resolution_timestamp::DATE, issue_dates.inception_date), -1) AS inception_to_resolution_days
        ,COALESCE(tf_u_days_diff_between_dates(now()::DATE, issue_dates.inception_date), -1) AS inception_to_now_days
        ,CASE
            WHEN issue_dates.resolution_timestamp IS NOT NULL
                AND issue_dates.first_response_timestamp IS NOT NULL
                AND issue_dates.first_response_timestamp IS NOT NULL
                AND issue_dates.resolution_timestamp > issue_dates.first_response_timestamp::DATE
                THEN tf_u_days_diff_between_dates(issue_dates.resolution_timestamp::DATE, issue_dates.first_response_timestamp::DATE)
            ELSE -1
        END AS first_response_to_resolution_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.pilot_date, issue_dates.activation_timestamp::DATE), -1) AS activation_to_pilot_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.sales_date, issue_dates.activation_timestamp::DATE), -1) AS activation_to_sales_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.deployment_date, issue_dates.activation_timestamp::DATE), -1) AS activation_to_deployment_days
        ,COALESCE(tf_u_days_diff_between_dates(now()::DATE, issue_dates.activation_timestamp::DATE), -1) AS activation_to_now_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.pilot_finished_date, issue_dates.pilot_date), -1) AS pilot_to_pilot_finished_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.sales_date, issue_dates.pilot_date), -1) AS pilot_to_sales_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.deployment_date, issue_dates.pilot_date), -1) AS pilot_to_deployment_days
        ,COALESCE(tf_u_days_diff_between_dates(now()::DATE, issue_dates.pilot_date), -1) AS pilot_to_now_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.sales_date, issue_dates.pilot_finished_date), -1) AS pilot_finished_to_sales_days
        ,COALESCE(tf_u_days_diff_between_dates(now()::DATE, issue_dates.pilot_finished_date), -1) AS pilot_finished_to_now_days
        ,COALESCE(tf_u_days_diff_between_dates(issue_dates.deployment_date, issue_dates.sales_date), -1) AS sales_to_deployment_days
        ,COALESCE(tf_u_days_diff_between_dates(now()::DATE, issue_dates.sales_date), -1) AS sales_to_now_days
        ,COALESCE(tf_u_days_diff_between_dates(now()::DATE, issue_dates.deployment_date), -1) AS deployment_to_now_days
        ,COALESCE(tf_u_convert_date_to_yyyymmdd_integer(issue_dates.activation_timestamp::DATE), -1) AS fk_date_id_activation_date
        ,COALESCE(issue_dates.activation_timestamp, TIMESTAMP_NEVER) AS activation_timestamp
        ,COALESCE(tf_u_convert_date_to_yyyymmdd_integer(issue_dates.first_response_timestamp::DATE), -1) AS fk_date_id_first_response_date
        ,COALESCE(issue_dates.first_response_timestamp, TIMESTAMP_NEVER) AS first_response_timestamp
        ,COALESCE(tf_u_convert_date_to_yyyymmdd_integer(issue_dates.created_timestamp::DATE), -1) AS fk_date_id_created_date
        ,COALESCE(issue_dates.created_timestamp, TIMESTAMP_NEVER) AS created_timestamp
        ,COALESCE(tf_u_convert_date_to_yyyymmdd_integer(issue_dates.resolution_timestamp::DATE), -1) AS fk_date_id_resolution_date
        ,COALESCE(issue_dates.resolution_timestamp, TIMESTAMP_NEVER) AS resolution_timestamp
        ,COALESCE(tf_u_convert_date_to_yyyymmdd_integer(issue_dates.inception_date), -1) AS fk_date_id_inception_date
        ,COALESCE(issue_dates.inception_date, DATE_NEVER) AS inception_date
        ,COALESCE(tf_u_convert_date_to_yyyymmdd_integer(issue_dates.pilot_date), -1) AS fk_date_id_pilot_date
        ,COALESCE(issue_dates.pilot_date, DATE_NEVER) AS pilot_date
        ,COALESCE(tf_u_convert_date_to_yyyymmdd_integer(issue_dates.pilot_finished_date), -1) AS fk_date_id_pilot_finished_date
        ,COALESCE(issue_dates.pilot_finished_date, DATE_NEVER) AS pilot_finished_date
        ,COALESCE(tf_u_convert_date_to_yyyymmdd_integer(issue_dates.sales_date), -1) AS fk_date_id_sales_date
        ,COALESCE(issue_dates.sales_date, DATE_NEVER) AS sales_date
        ,COALESCE(tf_u_convert_date_to_yyyymmdd_integer(issue_dates.deployment_date), -1) AS fk_date_id_deployment_date
        ,COALESCE(issue_dates.deployment_date, DATE_NEVER) AS deployment_date
        ,project.project_id AS fk_project_id
        ,COALESCE(party_creator.party_id, -1) AS fk_party_id_created_by
        ,COALESCE(party_reporter.party_id, -1) AS fk_party_id_reported_by
        ,COALESCE(employee.employee_id, -1) AS fk_employee_id_assigned_to 
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
           COALESCE(jira_issue.status, '')
        || COALESCE(jira_issue.summary, '')
        || COALESCE(jira_issue.priority, '')
        || COALESCE(jira_issue.sla_priority, '')
        || COALESCE(jira_issue.description, '')
        || COALESCE(jira_issue.issue_type, '')
        || COALESCE(jira_issue.resolution, '')
        || COALESCE(jira_issue.deployment, '')
        || COALESCE(jira_issue.epic, '')
        || COALESCE(jira_issue.original_estimate_seconds, '')
        || COALESCE(jira_issue.remaining_estimate_seconds, '')
        || COALESCE(jira_issue.aggregate_original_estimate_seconds, '')
        || COALESCE(jira_issue.aggregate_remaining_estimate_seconds, '')
        || COALESCE(jira_issue.labels, '')
        || COALESCE(jira_issue.components, '')
        || COALESCE(jira_issue.fix_versions, '')
        || COALESCE(jira_issue.affected_versions, '')
        || COALESCE(jira_issue.project_key, '')
        || COALESCE(jira_issue.creator_account_id, '')
        || COALESCE(jira_issue.reporter_account_id, '')
        || COALESCE(jira_issue.assignee_account_id, '')
        || COALESCE(jira_issue.account_name, '')
        || COALESCE(jira_tempo_account.customer_name, '')
        || COALESCE(jira_issue.inception_date, '')
        || COALESCE(jira_issue.pilot_date, '')
        || COALESCE(jira_issue.pilot_finished_date, '')
        || COALESCE(jira_issue.sales_date, '')
        || COALESCE(jira_issue.deployment_date, '')
        || COALESCE(jira_issue.first_response_timestamp, '')
        || COALESCE(jira_issue.created_timestamp, '')
        || COALESCE(jira_issue.resolution_timestamp, '')
        || COALESCE(jira_issue.account_id::TEXT, '')
        ) AS tech_row_hash
        ,jira_issue.tech_data_load_utc_timestamp
        ,jira_issue.tech_data_load_uuid
    FROM stage.jira_issue_i AS jira_issue
    LEFT JOIN hours_logged_per_issue_in_aggregate ON hours_logged_per_issue_in_aggregate.issue_id = jira_issue.issue_id
    LEFT JOIN issue_dates ON issue_dates.issue_id = jira_issue.issue_id
    LEFT JOIN stage.jira_tempo_account_i AS jira_tempo_account ON jira_tempo_account.id = jira_issue.account_id
    LEFT JOIN stage.jira_issue_i AS epic_issue ON epic_issue.issue_key = jira_issue.epic
    LEFT JOIN core.project_i AS project ON project.jira_key = jira_issue.project_key
    LEFT JOIN core.party_i AS party_creator ON party_creator.party_key = jira_issue.creator_account_id
    LEFT JOIN core.party_i AS party_reporter ON party_reporter.party_key = jira_issue.reporter_account_id
    LEFT JOIN core.employee_i AS employee ON employee.employee_key = jira_issue.assignee_account_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------
    
    INSERT INTO core.issue_i (
        issue_key
        ,jira_key
        ,jira_id
        ,account
        ,customer
        ,status
        ,summary
        ,priority
        ,sla_priority
        ,description
        ,issue_type
        ,resolution
        ,deployment
        ,epic_name
        ,epic_jira_key
        ,original_estimate
        ,remaining_estimate
        ,aggregate_original_estimate
        ,aggregate_remaining_estimate
        ,hours_logged_total
        ,days_logged_total
        ,labels
        ,components
        ,fix_versions
        ,affected_versions
        ,inception_to_first_response_days
        ,inception_to_pilot_days
        ,inception_to_sales_days
        ,inception_to_deployment_days
        ,inception_to_resolution_days
        ,inception_to_now_days
        ,first_response_to_resolution_days
        ,activation_to_pilot_days
        ,activation_to_sales_days
        ,activation_to_deployment_days
        ,activation_to_now_days
        ,pilot_to_pilot_finished_days
        ,pilot_to_sales_days
        ,pilot_to_deployment_days
        ,pilot_to_now_days
        ,pilot_finished_to_sales_days
        ,pilot_finished_to_now_days
        ,sales_to_deployment_days
        ,sales_to_now_days
        ,deployment_to_now_days
        ,fk_date_id_activation_date
        ,activation_timestamp
        ,fk_date_id_first_response_date
        ,first_response_timestamp
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_resolution_date
        ,resolution_timestamp
        ,fk_date_id_inception_date
        ,inception_date
        ,fk_date_id_pilot_date
        ,pilot_date
        ,fk_date_id_pilot_finished_date
        ,pilot_finished_date
        ,fk_date_id_sales_date
        ,sales_date
        ,fk_date_id_deployment_date
        ,deployment_date
        ,fk_project_id
        ,fk_party_id_created_by
        ,fk_party_id_reported_by
        ,fk_employee_id_assigned_to
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_issue_i.issue_key
        ,tmp_issue_i.jira_key
        ,tmp_issue_i.jira_id
        ,tmp_issue_i.account
        ,tmp_issue_i.customer
        ,tmp_issue_i.status
        ,tmp_issue_i.summary
        ,tmp_issue_i.priority
        ,tmp_issue_i.sla_priority
        ,tmp_issue_i.description
        ,tmp_issue_i.issue_type
        ,tmp_issue_i.resolution
        ,tmp_issue_i.deployment
        ,tmp_issue_i.epic_name
        ,tmp_issue_i.epic_jira_key
        ,tmp_issue_i.original_estimate
        ,tmp_issue_i.remaining_estimate
        ,tmp_issue_i.aggregate_original_estimate
        ,tmp_issue_i.aggregate_remaining_estimate
        ,tmp_issue_i.hours_logged_total
        ,tmp_issue_i.days_logged_total
        ,tmp_issue_i.labels
        ,tmp_issue_i.components
        ,tmp_issue_i.fix_versions
        ,tmp_issue_i.affected_versions
        ,tmp_issue_i.inception_to_first_response_days
        ,tmp_issue_i.inception_to_pilot_days
        ,tmp_issue_i.inception_to_sales_days
        ,tmp_issue_i.inception_to_deployment_days
        ,tmp_issue_i.inception_to_resolution_days
        ,tmp_issue_i.inception_to_now_days
        ,tmp_issue_i.first_response_to_resolution_days
        ,tmp_issue_i.activation_to_pilot_days
        ,tmp_issue_i.activation_to_sales_days
        ,tmp_issue_i.activation_to_deployment_days
        ,tmp_issue_i.activation_to_now_days
        ,tmp_issue_i.pilot_to_pilot_finished_days
        ,tmp_issue_i.pilot_to_sales_days
        ,tmp_issue_i.pilot_to_deployment_days
        ,tmp_issue_i.pilot_to_now_days
        ,tmp_issue_i.pilot_finished_to_sales_days
        ,tmp_issue_i.pilot_finished_to_now_days
        ,tmp_issue_i.sales_to_deployment_days
        ,tmp_issue_i.sales_to_now_days
        ,tmp_issue_i.deployment_to_now_days
        ,tmp_issue_i.fk_date_id_activation_date
        ,tmp_issue_i.activation_timestamp
        ,tmp_issue_i.fk_date_id_first_response_date
        ,tmp_issue_i.first_response_timestamp
        ,tmp_issue_i.fk_date_id_created_date
        ,tmp_issue_i.created_timestamp
        ,tmp_issue_i.fk_date_id_resolution_date
        ,tmp_issue_i.resolution_timestamp
        ,tmp_issue_i.fk_date_id_inception_date
        ,tmp_issue_i.inception_date
        ,tmp_issue_i.fk_date_id_pilot_date
        ,tmp_issue_i.pilot_date
        ,tmp_issue_i.fk_date_id_pilot_finished_date
        ,tmp_issue_i.pilot_finished_date
        ,tmp_issue_i.fk_date_id_sales_date
        ,tmp_issue_i.sales_date
        ,tmp_issue_i.fk_date_id_deployment_date
        ,tmp_issue_i.deployment_date
        ,tmp_issue_i.fk_project_id
        ,tmp_issue_i.fk_party_id_created_by
        ,tmp_issue_i.fk_party_id_reported_by
        ,tmp_issue_i.fk_employee_id_assigned_to
        ,tmp_issue_i.tech_insert_function
        ,tmp_issue_i.tech_insert_utc_timestamp
        ,tmp_issue_i.tech_deleted_in_source_system
        ,tmp_issue_i.tech_row_hash
        ,tmp_issue_i.tech_data_load_utc_timestamp
        ,tmp_issue_i.tech_data_load_uuid
    FROM tmp_issue_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
