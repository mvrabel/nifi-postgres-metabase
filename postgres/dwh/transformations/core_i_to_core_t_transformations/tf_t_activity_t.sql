CREATE OR REPLACE FUNCTION core.tf_t_activity_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:    Insert data from core deal_i input table into core 'today' table activity_t
    AUTHOR:         Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:     2018-11-12 (YYYY-MM-DD)
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

    INSERT INTO core.activity_t (
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
        ,marked_as_done_timestamp
        ,fk_date_id_created_date
        ,created_timestamp
        ,subject
        ,fk_employee_id_assigned_to
        ,note
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT 
        input_activity.activity_id
        ,input_activity.activity_key
        ,COALESCE(input_employee_created_by.employee_id, -1) AS fk_employee_id_created_by
        ,COALESCE(input_organization.organization_id, -1) AS fk_organization_id
        ,COALESCE(input_contact.contact_id, -1) AS fk_contact_id
        ,COALESCE(input_deal.deal_id, -1) AS fk_deal_id
        ,input_activity.fk_date_id_due_date
        ,input_activity.due_timestamp
        ,input_activity.marked_as_done
        ,input_activity.fk_date_id_marked_as_done
        ,input_activity.marked_as_done_timestamp
        ,input_activity.fk_date_id_created_date
        ,input_activity.created_timestamp
        ,input_activity.subject
        ,input_activity.fk_employee_id_assigned_to
        ,input_activity.note
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_activity.tech_row_hash
        ,input_activity.tech_data_load_utc_timestamp
        ,input_activity.tech_data_load_uuid
    FROM core.activity_i AS input_activity
    LEFT JOIN core.employee_i AS input_employee_created_by ON input_activity.fk_employee_id_created_by = input_employee_created_by.employee_id
        AND input_employee_created_by.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.organization_i AS input_organization ON input_activity.fk_organization_id = input_organization.organization_id
        AND input_organization.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.contact_i AS input_contact ON input_activity.fk_organization_id = input_contact.contact_id
        AND input_contact.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.deal_i AS input_deal ON input_activity.fk_organization_id = input_deal.deal_id
        AND input_deal.tech_deleted_in_source_system IS FALSE
    WHERE input_activity.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
