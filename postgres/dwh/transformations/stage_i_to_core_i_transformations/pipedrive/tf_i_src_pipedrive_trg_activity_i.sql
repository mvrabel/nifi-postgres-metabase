CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_activity_i()
RETURNS INTEGER
AS $$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table activity_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-11-12 (YYYY-MM-DD)
    NOTE:
    ==============================================================================================
    */

DECLARE

PIPEDRIVE_PREFIX TEXT := 'PIPEDRIVE_';
DEAL_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'DEAL_';
ORGANIZATION_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'ORGANIZATION_';
PERSON_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'PERSON_';
CONTACT_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'CONTACT_';
EMPLOYEE_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'EMPLOYEE_';
ACTIVITY_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'ACTIVITY_';
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
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.activity_i (
        activity_id
        ,activity_key
        ,fk_employee_id_created_by
        ,fk_organization_id
        ,fk_contact_id
        ,fk_deal_id
        ,fk_date_id_due_date
        ,due_timestamp
        ,marked_as_done
        ,fk_date_id_marked_as_done
        ,fk_date_id_created_date
        ,marked_as_done_timestamp
        ,subject
        ,fk_employee_id_assigned_to
        ,note
        ,created_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
       -1 -- activity_id
        ,TEXT_NULL -- activity_key
        ,-1 -- fk_employee_id_created_by
        ,-1 -- fk_organization_id
        ,-1 -- fk_contact_id
        ,-1 -- fk_deal_id
        ,-1 -- fk_date_id_due_date
        ,TIMESTAMP_NEVER -- due_timestamp
        ,FALSE -- marked_as_done
        ,-1 -- fk_date_id_marked_as_done
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- marked_as_done_timestamp
        ,TEXT_NULL -- subject
        ,-1 -- fk_employee_id_assigned_to
        ,TEXT_NULL -- note
        ,TIMESTAMP_NEVER -- created_timestamp
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,TEXT_NULL -- tech_row_hash
        ,-1 -- tech_data_load_utc_timestamp
        ,TEXT_NULL -- tech_data_load_uuid
    ) ON CONFLICT DO NOTHING;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_activity_i cascade;

    CREATE TEMPORARY TABLE tmp_activity_i (
        activity_key                    text NOT NULL,
        fk_employee_id_created_by       integer NOT NULL,
        fk_organization_id              integer NOT NULL,
        fk_contact_id                   integer NOT NULL,
        fk_deal_id                      integer NOT NULL,
        fk_date_id_due_date             integer NOT NULL,
        due_timestamp                   timestamp with time zone NOT NULL,
        fk_date_id_marked_as_done       integer NOT NULL,
        fk_date_id_created_date         integer NOT NULL,
        marked_as_done                  bool NOT NULL,
        marked_as_done_timestamp        timestamp with time zone NOT NULL,
        subject                         text NOT NULL,
        fk_employee_id_assigned_to      integer NOT NULL,
        note                            text NOT NULL,
        created_timestamp               timestamp with time zone NOT NULL,
        tech_insert_function            text NOT NULL,
        tech_insert_utc_timestamp       bigint NOT NULL,
        tech_row_hash                   text NOT NULL,
        tech_data_load_utc_timestamp    bigint NOT NULL,
        tech_data_load_uuid             text NOT NULL,
        tech_deleted_in_source_system   bool NOT NULL
    );

    INSERT INTO tmp_activity_i (
        activity_key
        ,fk_employee_id_created_by
        ,fk_organization_id
        ,fk_contact_id
        ,fk_deal_id
        ,fk_date_id_due_date
        ,due_timestamp
        ,marked_as_done
        ,fk_date_id_marked_as_done
        ,fk_date_id_created_date
        ,marked_as_done_timestamp
        ,subject
        ,fk_employee_id_assigned_to
        ,note
        ,created_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        ACTIVITY_KEY_PREFIX || pipedrive_activity.id AS activity_key
        ,COALESCE(core_employee_created_by.employee_id, -1) AS fk_employee_id_created_by
        ,COALESCE(core_organization.organization_id, -1) AS fk_organization_id
        ,COALESCE(core_contact.contact_id, -1) AS fk_contact_id
        ,COALESCE(core_deal.deal_id, -1) AS fk_deal_id
        ,CASE
            WHEN pipedrive_activity.due_date <> '' THEN TO_CHAR(TO_DATE(pipedrive_activity.due_date, 'YYYY-MM-DD'), 'YYYYMMDD')::INTEGER
            ELSE -1
        END AS fk_date_id_due_date
        ,(pipedrive_activity.due_date || '+00')::TIMESTAMP WITH TIME ZONE AS due_timestamp
        ,pipedrive_activity.done AS marked_as_done
        ,CASE
            WHEN pipedrive_activity.marked_as_done_time <> '' THEN TO_CHAR(TO_DATE(pipedrive_activity.marked_as_done_time, 'YYYY-MM-DD'), 'YYYYMMDD')::INTEGER
            ELSE -1
        END AS fk_date_id_marked_as_done
        ,CASE
            WHEN pipedrive_activity.add_time <> '' THEN TO_CHAR(TO_DATE(pipedrive_activity.add_time, 'YYYY-MM-DD'), 'YYYYMMDD')::INTEGER
            ELSE -1
        END AS fk_date_id_created_date
        ,(pipedrive_activity.add_time || '+00')::TIMESTAMP WITH TIME ZONE AS marked_as_done_timestamp
        ,pipedrive_activity.subject AS subject
        ,COALESCE(core_employee_assigned_to.employee_id, -1) AS fk_employee_id_assigned_to
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_activity.note) AS note
        ,(pipedrive_activity.add_time || '+00')::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,NOT pipedrive_activity.active_flag AS tech_deleted_in_source_system
        ,md5(
            COALESCE(pipedrive_activity.created_by_user_id::TEXT, '')
            || COALESCE(pipedrive_activity.org_id::TEXT, '')
            || COALESCE(pipedrive_activity.person_id::TEXT, '')
            || COALESCE(pipedrive_activity.deal_id::TEXT, '')
            || COALESCE(pipedrive_activity.due_date::TEXT, '')
            || COALESCE(pipedrive_activity.marked_as_done_time::TEXT, '')
            || COALESCE(pipedrive_activity.done::TEXT, '')
            || COALESCE(pipedrive_activity.add_time::TEXT, '')
            || COALESCE(pipedrive_activity.subject::TEXT, '')
            || COALESCE(pipedrive_activity.assigned_to_user_id::TEXT, '')
            || COALESCE(pipedrive_activity.note::TEXT, '')
        ) AS tech_row_hash
        ,pipedrive_activity.tech_data_load_utc_timestamp
        ,pipedrive_activity.tech_data_load_uuid
    FROM stage.pipedrive_activity_i AS pipedrive_activity
    LEFT JOIN core.organization_i AS core_organization ON core_organization.organization_key = ORGANIZATION_KEY_PREFIX || pipedrive_activity.org_id
    LEFT JOIN core.contact_i AS core_contact ON core_contact.contact_key = CONTACT_KEY_PREFIX || pipedrive_activity.person_id
    LEFT JOIN core.deal_i AS core_deal ON core_deal.deal_key = DEAL_KEY_PREFIX || pipedrive_activity.deal_id
    LEFT JOIN core.employee_i AS core_employee_created_by ON core_employee_created_by.employee_key = EMPLOYEE_KEY_PREFIX || pipedrive_activity.created_by_user_id
    LEFT JOIN core.employee_i AS core_employee_assigned_to ON core_employee_assigned_to.employee_key = EMPLOYEE_KEY_PREFIX || pipedrive_activity.assigned_to_user_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.activity_i (
        activity_key
        ,fk_employee_id_created_by
        ,fk_organization_id
        ,fk_contact_id
        ,fk_deal_id
        ,fk_date_id_due_date
        ,due_timestamp
        ,marked_as_done
        ,fk_date_id_marked_as_done
        ,fk_date_id_created_date
        ,marked_as_done_timestamp
        ,subject
        ,fk_employee_id_assigned_to
        ,note
        ,created_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        tmp_activity_i.activity_key
        ,tmp_activity_i.fk_employee_id_created_by
        ,tmp_activity_i.fk_organization_id
        ,tmp_activity_i.fk_contact_id
        ,tmp_activity_i.fk_deal_id
        ,tmp_activity_i.fk_date_id_due_date
        ,tmp_activity_i.due_timestamp
        ,tmp_activity_i.marked_as_done
        ,tmp_activity_i.fk_date_id_marked_as_done
        ,tmp_activity_i.fk_date_id_created_date
        ,tmp_activity_i.marked_as_done_timestamp
        ,tmp_activity_i.subject
        ,tmp_activity_i.fk_employee_id_assigned_to
        ,tmp_activity_i.note
        ,tmp_activity_i.created_timestamp
        ,tmp_activity_i.tech_insert_function
        ,tmp_activity_i.tech_insert_utc_timestamp
        ,tmp_activity_i.tech_deleted_in_source_system
        ,tmp_activity_i.tech_row_hash
        ,tmp_activity_i.tech_data_load_utc_timestamp
        ,tmp_activity_i.tech_data_load_uuid
    FROM tmp_activity_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
