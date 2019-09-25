CREATE OR REPLACE FUNCTION core.tf_t_c_revenue_type_t()
RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Copy data from code list talbe revenue_type into today table revenue_type
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

    INSERT INTO core.c_revenue_type_t (
        revenue_type_id
        ,revenue_type_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_revenue_type.revenue_type_id
        ,input_revenue_type.revenue_type_name
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_revenue_type.tech_row_hash
        ,input_revenue_type.tech_data_load_utc_timestamp
        ,input_revenue_type.tech_data_load_uuid
    FROM core.c_revenue_type_i AS input_revenue_type
    WHERE input_revenue_type.tech_deleted_in_source_system IS FALSE;

    RETURN 0;
END;$$

LANGUAGE plpgsql
