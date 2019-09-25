CREATE OR REPLACE FUNCTION core.tf_t_note_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from core note_i input table into core 'today' table note_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
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

    ----------------------------------------------------
    -- INSERT RECORDS FROM INPUT TABLE TO TODAY TABLE --
    ----------------------------------------------------

    INSERT INTO core.note_t (
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
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_note.note_id
        ,input_note.note_key
        ,input_deal.deal_id
        ,input_contact.contact_id
        ,input_organization.organization_id
        ,input_note.fk_date_id_created_date
        ,input_note.created_timestamp
        ,input_note.fk_date_id_last_modified_date
        ,input_note.last_modified_timestamp
        ,input_note.pinned_to_deal_flag
        ,input_note.pinned_to_person_flag
        ,input_note.pinned_to_organization_flag
        ,input_note.content
        ,input_note.fk_employee_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_note.tech_row_hash
        ,input_note.tech_data_load_utc_timestamp
        ,input_note.tech_data_load_uuid
    FROM core.note_i AS input_note
    JOIN core.deal_i AS input_deal ON input_note.fk_deal_id = input_deal.deal_id
        AND input_deal.tech_deleted_in_source_system IS FALSE
    JOIN core.contact_i AS input_contact ON input_note.fk_contact_id = input_contact.contact_id
        AND input_contact.tech_deleted_in_source_system IS FALSE
    JOIN core.organization_i AS input_organization ON input_note.fk_organization_id = input_organization.organization_id
        AND input_organization.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.employee_i AS input_employee ON input_note.fk_employee_id = input_employee.employee_id
        AND input_employee.tech_deleted_in_source_system IS FALSE
    WHERE input_note.tech_deleted_in_source_system IS FALSE;

    RETURN 0;
END;$$

LANGUAGE plpgsql

