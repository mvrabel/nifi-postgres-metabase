CREATE OR REPLACE FUNCTION core.tf_t_deal_contact_map_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:    Insert data from core deal_contact_map_i input table into core 'today' table deal_contact_map_t
    AUTHOR:         Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:     2018-11-06 (YYYY-MM-DD)
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

    INSERT INTO core.deal_contact_map_t (
        deal_contact_map_id
        ,deal_key
        ,contact_key
        ,fk_deal_id
        ,fk_contact_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )

    SELECT
        input_deal_contact_map.deal_contact_map_id
        ,input_deal_contact_map.deal_key
        ,input_deal_contact_map.contact_key
        ,input_deal.deal_id AS fk_deal_id
        ,input_contact.contact_id AS fk_contact_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_deal_contact_map.tech_row_hash
        ,input_deal_contact_map.tech_data_load_utc_timestamp
        ,input_deal_contact_map.tech_data_load_uuid
    FROM core.deal_contact_map_i AS input_deal_contact_map
    JOIN core.deal_i AS input_deal ON input_deal_contact_map.fk_deal_id = input_deal.deal_id
        AND input_deal.tech_deleted_in_source_system IS FALSE
    JOIN core.contact_i AS input_contact ON input_deal_contact_map.fk_contact_id = input_contact.contact_id
        AND input_contact.tech_deleted_in_source_system IS FALSE
    WHERE input_deal_contact_map.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
