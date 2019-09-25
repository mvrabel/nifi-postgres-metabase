CREATE OR REPLACE FUNCTION core.tf_h_issue_ih()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        SCD2 historization of table issue_i.
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-11-27 (YYYY-MM-DD)
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

    INSERT INTO core.issue_ih (
        jira_key
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
        ,labels
        ,components
        ,fix_versions
        ,affected_versions
        ,first_response_timestamp
        ,resolution_timestamp
        ,created_timestamp
        ,fk_date_id_pilot_date
        ,fk_date_id_sales_date
        ,fk_date_id_deployment_date
        ,fk_project_id
        ,fk_party_id_created_by
        ,fk_party_id_reported_by
        ,fk_employee_id_assigned_to
        ,fk_date_id_inception_date
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
        input_issue.jira_key
        ,input_issue.jira_id
        ,input_issue.issue_key
        ,input_issue.account
        ,input_issue.customer
        ,input_issue.status
        ,input_issue.summary
        ,input_issue.priority
        ,input_issue.sla_priority
        ,input_issue.description
        ,input_issue.issue_type
        ,input_issue.resolution
        ,input_issue.deployment
        ,input_issue.epic_name
        ,input_issue.epic_jira_key
        ,input_issue.original_estimate
        ,input_issue.remaining_estimate
        ,input_issue.aggregate_original_estimate
        ,input_issue.aggregate_remaining_estimate
        ,input_issue.labels
        ,input_issue.components
        ,input_issue.fix_versions
        ,input_issue.affected_versions
        ,input_issue.first_response_timestamp
        ,input_issue.resolution_timestamp
        ,input_issue.created_timestamp
        ,input_issue.fk_date_id_pilot_date
        ,input_issue.fk_date_id_sales_date
        ,input_issue.fk_date_id_deployment_date
        ,hist_project.project_id AS fk_project_id
        ,hist_party_created.party_id AS fk_party_id_created_by
        ,hist_party_reported.party_id AS fk_party_id_reported_by
        ,hist_employee_assigned.employee_id AS fk_employee_id_assigned_to
        ,input_issue.fk_date_id_inception_date
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_issue.tech_deleted_in_source_system
        ,input_issue.tech_row_hash
        ,input_issue.tech_data_load_utc_timestamp
        ,input_issue.tech_data_load_uuid
    FROM core.issue_i AS input_issue    
    JOIN core.employee_i AS input_employee_assigned ON input_issue.fk_employee_id_assigned_to = input_employee_assigned.employee_id    
    JOIN core.employee_ih AS hist_employee_assigned ON hist_employee_assigned.employee_key = input_employee_assigned.employee_key
        AND hist_employee_assigned.tech_is_current = TRUE
    JOIN core.party_i AS input_party_reported ON input_issue.fk_party_id_reported_by = input_party_reported.party_id    
    JOIN core.party_ih AS hist_party_reported ON hist_party_reported.party_key = input_party_reported.party_key
        AND hist_party_reported.tech_is_current = TRUE
    JOIN core.party_i AS input_party_created ON input_issue.fk_party_id_created_by = input_party_created.party_id    
    JOIN core.party_ih AS hist_party_created ON hist_party_created.party_key = input_party_created.party_key
        AND hist_party_created.tech_is_current = TRUE
    JOIN core.project_i AS input_project ON input_issue.fk_project_id = input_project.project_id    
    JOIN core.project_ih AS hist_project ON hist_project.project_key = input_project.project_key
        AND hist_project.tech_is_current = TRUE
    LEFT JOIN core.issue_ih AS hist_issue ON hist_issue.issue_key = input_issue.issue_key
    WHERE hist_issue.issue_key IS NULL;

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

    DROP TABLE IF EXISTS updated_issue;

    CREATE TEMPORARY TABLE updated_issue (
        issue_key TEXT NOT NULL
    );
    
    INSERT INTO updated_issue (
        issue_key
    )
    SELECT
        input_issue.issue_key
    FROM core.issue_i AS input_issue
    JOIN core.issue_ih AS hist_issue ON hist_issue.issue_key = input_issue.issue_key
        AND hist_issue.tech_is_current = TRUE
    WHERE input_issue.tech_row_hash != hist_issue.tech_row_hash
        -- This "OR" is maybe unnecessary but let's keep it just to be sure.
        OR (
            input_issue.tech_row_hash = hist_issue.tech_row_hash
            AND hist_issue.tech_deleted_in_source_system = TRUE
            AND input_issue.tech_deleted_in_source_system = FALSE
            );

    ----------------------------------------------------------
    -- SET tech_is_current FLAG ON UPDATED RECORDS TO FALSE --
    -- AND                                                  --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP     --
    ----------------------------------------------------------

    UPDATE core.issue_ih AS hist_issue
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM updated_issue
    WHERE updated_issue.issue_key = hist_issue.issue_key
        AND hist_issue.tech_is_current = TRUE;

    ----------------------------
    -- INSERT UPDATED RECORDS --
    ----------------------------

    INSERT INTO core.issue_ih (
        jira_key
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
        ,labels
        ,components
        ,fix_versions
        ,affected_versions
        ,first_response_timestamp
        ,resolution_timestamp
        ,created_timestamp
        ,fk_date_id_pilot_date
        ,fk_date_id_sales_date
        ,fk_date_id_deployment_date
        ,fk_project_id
        ,fk_party_id_created_by
        ,fk_party_id_reported_by
        ,fk_employee_id_assigned_to
        ,fk_date_id_inception_date
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
        input_issue.jira_key
        ,input_issue.jira_id
        ,input_issue.issue_key
        ,input_issue.account
        ,input_issue.customer
        ,input_issue.status
        ,input_issue.summary
        ,input_issue.priority
        ,input_issue.sla_priority
        ,input_issue.description
        ,input_issue.issue_type
        ,input_issue.resolution
        ,input_issue.deployment
        ,input_issue.epic_name
        ,input_issue.epic_jira_key
        ,input_issue.original_estimate
        ,input_issue.remaining_estimate
        ,input_issue.aggregate_original_estimate
        ,input_issue.aggregate_remaining_estimate
        ,input_issue.labels
        ,input_issue.components
        ,input_issue.fix_versions
        ,input_issue.affected_versions
        ,input_issue.first_response_timestamp
        ,input_issue.resolution_timestamp
        ,input_issue.created_timestamp
        ,input_issue.fk_date_id_pilot_date
        ,input_issue.fk_date_id_sales_date
        ,input_issue.fk_date_id_deployment_date
        ,hist_project.project_id AS fk_project_id
        ,hist_party_created.party_id AS fk_party_id_created_by
        ,hist_party_reported.party_id AS fk_party_id_reported_by
        ,hist_employee_assigned.employee_id AS fk_employee_id_assigned_to
        ,input_issue.fk_date_id_inception_date
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_issue.tech_deleted_in_source_system
        ,input_issue.tech_row_hash
        ,input_issue.tech_data_load_utc_timestamp
        ,input_issue.tech_data_load_uuid
    FROM core.issue_i AS input_issue
    JOIN core.employee_i AS input_employee_assigned ON input_issue.fk_employee_id_assigned_to = input_employee_assigned.employee_id    
    JOIN core.employee_ih AS hist_employee_assigned ON hist_employee_assigned.employee_key = input_employee_assigned.employee_key
        AND hist_employee_assigned.tech_is_current = TRUE
    JOIN core.party_i AS input_party_reported ON input_issue.fk_party_id_reported_by = input_party_reported.party_id    
    JOIN core.party_ih AS hist_party_reported ON hist_party_reported.party_key = input_party_reported.party_key
        AND hist_party_reported.tech_is_current = TRUE
    JOIN core.party_i AS input_party_created ON input_issue.fk_party_id_created_by = input_party_created.party_id    
    JOIN core.party_ih AS hist_party_created ON hist_party_created.party_key = input_party_created.party_key
        AND hist_party_created.tech_is_current = TRUE
    JOIN core.project_i AS input_project ON input_issue.fk_project_id = input_project.project_id    
    JOIN core.project_ih AS hist_project ON hist_project.project_key = input_project.project_key
        AND hist_project.tech_is_current = TRUE
    WHERE input_issue.issue_key IN (SELECT issue_key FROM updated_issue);

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

    DROP TABLE IF EXISTS deleted_issue;

    CREATE TEMPORARY TABLE deleted_issue (
        issue_id INTEGER NOT NULL
    );
    
    INSERT INTO deleted_issue (
        issue_id
    )
    SELECT
        hist_issue.issue_id
    FROM core.issue_ih AS hist_issue
    LEFT JOIN core.issue_i AS input_issue ON input_issue.issue_key = hist_issue.issue_key
    WHERE input_issue.issue_key IS NULL 
        AND hist_issue.tech_is_current = TRUE
        AND hist_issue.tech_deleted_in_source_system = FALSE;

    ---------------------------------------------------------------
    -- SET tech_is_current FLAG ON DELETED RECORDS TO FALSE      --
    -- AND                                                       --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP --
    ---------------------------------------------------------------

    UPDATE core.issue_ih AS hist_issue
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM deleted_issue
    WHERE deleted_issue.issue_id = hist_issue.issue_id
        AND hist_issue.tech_is_current = TRUE;

    ----------------------------
    -- INSERT DELETED RECORDS --
    ----------------------------

    INSERT INTO core.issue_ih (
        jira_key
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
        ,labels
        ,components
        ,fix_versions
        ,affected_versions
        ,first_response_timestamp
        ,resolution_timestamp
        ,created_timestamp
        ,fk_date_id_pilot_date
        ,fk_date_id_sales_date
        ,fk_date_id_deployment_date
        ,fk_project_id
        ,fk_party_id_created_by
        ,fk_party_id_reported_by
        ,fk_employee_id_assigned_to
        ,fk_date_id_inception_date
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
        hist_issue.jira_key
        ,hist_issue.jira_id
        ,hist_issue.issue_key
        ,hist_issue.account
        ,hist_issue.customer
        ,hist_issue.status
        ,hist_issue.summary
        ,hist_issue.priority
        ,hist_issue.sla_priority
        ,hist_issue.description
        ,hist_issue.issue_type
        ,hist_issue.resolution
        ,hist_issue.deployment
        ,hist_issue.epic_name
        ,hist_issue.epic_jira_key
        ,hist_issue.original_estimate
        ,hist_issue.remaining_estimate
        ,hist_issue.aggregate_original_estimate
        ,hist_issue.aggregate_remaining_estimate
        ,hist_issue.labels
        ,hist_issue.components
        ,hist_issue.fix_versions
        ,hist_issue.affected_versions
        ,hist_issue.first_response_timestamp
        ,hist_issue.resolution_timestamp
        ,hist_issue.created_timestamp
        ,hist_issue.fk_date_id_pilot_date
        ,hist_issue.fk_date_id_sales_date
        ,hist_issue.fk_date_id_deployment_date
        ,hist_issue.fk_project_id
        ,hist_issue.fk_party_id_created_by
        ,hist_issue.fk_party_id_reported_by
        ,hist_issue.fk_employee_id_assigned_to
        ,hist_issue.fk_date_id_inception_date
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,TRUE AS tech_deleted_in_source_system
        ,hist_issue.tech_row_hash
        ,hist_issue.tech_data_load_utc_timestamp
        ,hist_issue.tech_data_load_uuid
    FROM core.issue_ih AS hist_issue
    WHERE hist_issue.issue_id IN (SELECT issue_id FROM deleted_issue);

    RETURN 0;

END;$$

LANGUAGE plpgsql

