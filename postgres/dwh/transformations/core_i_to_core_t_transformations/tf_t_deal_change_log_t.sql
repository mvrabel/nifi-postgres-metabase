CREATE OR REPLACE FUNCTION core.tf_t_deal_change_log_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:    Insert data from core deal_i input table into core 'today' table deal_change_log_t
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

    INSERT INTO core.deal_change_log_t (
        deal_change_log_id
        ,deal_change_log_key
        ,field
        ,old_value
        ,new_value
        ,fk_deal_id
        ,fk_employee_id
        ,fk_date_id_log_date
        ,log_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT 
        input_deal_change_log.deal_change_log_id
        ,input_deal_change_log.deal_change_log_key
        ,input_deal_change_log.field
        ,input_deal_change_log.old_value
        ,input_deal_change_log.new_value
        ,input_deal.deal_id AS fk_deal_id
        ,input_employee.employee_id AS fk_employee_id
        ,input_deal_change_log.fk_date_id_log_date
        ,input_deal_change_log.log_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_deal_change_log.tech_row_hash
        ,input_deal_change_log.tech_data_load_utc_timestamp
        ,input_deal_change_log.tech_data_load_uuid
    FROM core.deal_change_log_i AS input_deal_change_log
    JOIN core.deal_i AS input_deal ON input_deal_change_log.fk_deal_id = input_deal.deal_id
        AND input_deal.tech_deleted_in_source_system IS FALSE
    JOIN core.employee_i AS input_employee ON input_deal_change_log.fk_employee_id = input_employee.employee_id
        AND input_employee.tech_deleted_in_source_system IS FALSE
    WHERE input_deal_change_log.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
