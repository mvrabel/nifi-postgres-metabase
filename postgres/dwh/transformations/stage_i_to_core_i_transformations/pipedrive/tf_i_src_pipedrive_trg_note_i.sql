CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_note_i()
RETURNS INTEGER
AS $$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table note_i
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
NOTE_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'NOTE_';
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

    INSERT INTO core.note_i (
        note_id
        ,note_key
        ,fk_deal_id
        ,fk_contact_id
        ,fk_organization_id
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_modified_date
        ,last_modified_timestamp
        ,pinned_to_deal_flag
        ,pinned_to_person_flag
        ,pinned_to_organization_flag
        ,content
        ,fk_employee_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    VALUES (
        -1 -- note_id
        ,TEXT_NULL -- note_key
        ,-1 -- fk_deal_id
        ,-1 -- fk_contact_id
        ,-1 -- fk_organization_id
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
        ,-1 -- fk_date_id_last_modified_date
        ,TIMESTAMP_NEVER -- last_modified_timestamp
        ,FALSE -- pinned_to_deal_flag
        ,FALSE -- pinned_to_person_flag
        ,FALSE -- pinned_to_organization_flag
        ,TEXT_NULL -- content
        ,-1 -- fk_employee_id
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

    DROP TABLE IF EXISTS tmp_note_i;

    CREATE TEMPORARY TABLE tmp_note_i ( 
        note_key                        text  NOT NULL,
        fk_deal_id                      integer  NOT NULL,
        fk_contact_id                   integer  NOT NULL,
        fk_organization_id              integer  NOT NULL,
        fk_date_id_created_date         integer  NOT NULL,
        created_timestamp               timestamp with time zone  NOT NULL,
        fk_date_id_last_modified_date   integer  NOT NULL,
        last_modified_timestamp         timestamp with time zone  NOT NULL,
        pinned_to_deal_flag             bool  NOT NULL,
        pinned_to_person_flag           bool  NOT NULL,
        pinned_to_organization_flag     bool  NOT NULL,
        content                         text  NOT NULL,
        fk_employee_id                  integer  NOT NULL,
        tech_insert_function            text  NOT NULL,
        tech_insert_utc_timestamp       bigint  NOT NULL,
        tech_row_hash                   text  NOT NULL,
        tech_data_load_utc_timestamp    bigint  NOT NULL,
        tech_data_load_uuid             text  NOT NULL,
        tech_deleted_in_source_system   bool  NOT NULL
    );

    INSERT INTO tmp_note_i (
        note_key
        ,fk_deal_id
        ,fk_contact_id
        ,fk_organization_id
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_modified_date
        ,last_modified_timestamp
        ,pinned_to_deal_flag
        ,pinned_to_person_flag
        ,pinned_to_organization_flag
        ,content
        ,fk_employee_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        NOTE_KEY_PREFIX ||pipedrive_note.id AS note_key
        ,COALESCE(core_deal.deal_id, -1) AS fk_deal_id
        ,COALESCE(core_contact.contact_id, -1) AS fk_contact_id
        ,COALESCE(core_organization.organization_id, -1) AS fk_organization_id
        ,tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_note.add_time) AS fk_date_id_created_date
        ,(pipedrive_note.add_time || '+00')::TIMESTAMP WITH TIME ZONE AS created_timestamp
        ,tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_note.update_time) fk_date_id_last_modified_date
        ,(pipedrive_note.update_time || '+00')::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,pipedrive_note.pinned_to_deal_flag AS pinned_to_deal_flag
        ,pipedrive_note.pinned_to_person_flag AS pinned_to_person_flag
        ,pipedrive_note.pinned_to_organization_flag AS pinned_to_organization_flag
        ,pipedrive_note.content AS content
        ,COALESCE(core_employee.employee_id, -1) AS fk_employee_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,NOT pipedrive_note.active_flag AS tech_deleted_in_source_system
        ,md5(
            COALESCE(pipedrive_note.deal_id::TEXT, '')
            || COALESCE(pipedrive_note.person_id::TEXT, '')
            || COALESCE(pipedrive_note.pinned_to_deal_flag::TEXT, '')
            || COALESCE(pipedrive_note.pinned_to_person_flag::TEXT, '')
            || COALESCE(pipedrive_note.pinned_to_organization_flag::TEXT, '')
            || COALESCE(pipedrive_note.content::TEXT, '')
            || COALESCE(pipedrive_note.user_id::TEXT, '')
            || COALESCE(pipedrive_note.active_flag::TEXT, '')
        ) AS tech_row_hash
        ,pipedrive_note.tech_data_load_utc_timestamp
        ,pipedrive_note.tech_data_load_uuid
    FROM stage.pipedrive_note_i AS pipedrive_note
    LEFT JOIN core.organization_i AS core_organization ON core_organization.organization_key = ORGANIZATION_KEY_PREFIX || pipedrive_note.org_id
    LEFT JOIN core.contact_i AS core_contact ON core_contact.contact_key = CONTACT_KEY_PREFIX || pipedrive_note.person_id
    LEFT JOIN core.deal_i AS core_deal ON core_deal.deal_key = DEAL_KEY_PREFIX || pipedrive_note.deal_id
    LEFT JOIN core.employee_i AS core_employee ON core_employee.employee_key = EMPLOYEE_KEY_PREFIX || pipedrive_note.user_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.note_i (
        note_key
        ,fk_deal_id
        ,fk_contact_id
        ,fk_organization_id
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_modified_date
        ,last_modified_timestamp
        ,pinned_to_deal_flag
        ,pinned_to_person_flag
        ,pinned_to_organization_flag
        ,content
        ,fk_employee_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT 
        tmp_note_i.note_key
        ,tmp_note_i.fk_deal_id
        ,tmp_note_i.fk_contact_id
        ,tmp_note_i.fk_organization_id
        ,tmp_note_i.fk_date_id_created_date
        ,tmp_note_i.created_timestamp
        ,tmp_note_i.fk_date_id_last_modified_date
        ,tmp_note_i.last_modified_timestamp
        ,tmp_note_i.pinned_to_deal_flag
        ,tmp_note_i.pinned_to_person_flag
        ,tmp_note_i.pinned_to_organization_flag
        ,tmp_note_i.content
        ,tmp_note_i.fk_employee_id
        ,tmp_note_i.tech_insert_function
        ,tmp_note_i.tech_insert_utc_timestamp
        ,tmp_note_i.tech_deleted_in_source_system
        ,tmp_note_i.tech_row_hash
        ,tmp_note_i.tech_data_load_utc_timestamp
        ,tmp_note_i.tech_data_load_uuid
    FROM tmp_note_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
