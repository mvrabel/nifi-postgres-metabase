CREATE OR REPLACE FUNCTION core.tf_t_c_partner_list_t()
RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Copy data from code list talbe partner_list into today table partner_list
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-16 (YYYY-MM-DD)
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

    INSERT INTO core.c_partner_list_t (
        partner_list_id
        ,partner_name
        ,is_tracked
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_partner_list.partner_list_id
        ,input_partner_list.partner_name
        ,input_partner_list.is_tracked
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_partner_list.tech_row_hash
        ,input_partner_list.tech_data_load_utc_timestamp
        ,input_partner_list.tech_data_load_uuid
    FROM core.c_partner_list_i AS input_partner_list
    WHERE input_partner_list.tech_deleted_in_source_system IS FALSE;

    RETURN 0;
END;$$

LANGUAGE plpgsql
