CREATE OR REPLACE FUNCTION core.tf_t_party_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from core party_i input table into core 'today' table party_t
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

    INSERT INTO core.party_t (
        party_id
        ,party_key
        ,full_name
        ,short_name
        ,fk_employee_id_last_modified_by
        ,fk_employee_id_created_by
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_modified_date
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        input_party.party_id
        ,input_party.party_key
        ,input_party.full_name
        ,input_party.short_name
        ,input_employee_last_modified.employee_id AS fk_employee_id_last_modified_by
        ,input_employee_created.employee_id AS fk_employee_id_created_by
        ,input_party.fk_date_id_created_date
        ,input_party.created_timestamp
        ,input_party.fk_date_id_last_modified_date
        ,input_party.last_modified_timestamp
        ,input_party.tech_insert_function
        ,input_party.tech_insert_utc_timestamp
        ,input_party.tech_row_hash
        ,input_party.tech_data_load_utc_timestamp
        ,input_party.tech_data_load_uuid
    FROM core.party_i AS input_party
    LEFT JOIN core.employee_i AS input_employee_created ON input_party.fk_employee_id_created_by = input_employee_created.employee_id
        AND input_employee_created.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.employee_i AS input_employee_last_modified ON input_party.fk_employee_id_last_modified_by = input_employee_last_modified.employee_id
        AND input_employee_last_modified.tech_deleted_in_source_system IS FALSE
    WHERE input_party.tech_deleted_in_source_system IS FALSE;

    RETURN 0;
END;$$

LANGUAGE plpgsql

