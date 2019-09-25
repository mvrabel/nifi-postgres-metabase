CREATE OR REPLACE FUNCTION core.tf_t_list_segment_list_member_map_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core list_segment_list_member_map_i input table into core 'today' table list_segment_list_member_map_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-21 (YYYY-MM-DD)
    NOTE:
    =================================================================================================================================
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

    INSERT INTO core.list_segment_list_member_map_t (
        list_segment_list_member_map_id
        ,list_segment_key
        ,list_member_key
        ,fk_mailing_list_segment_id
        ,fk_mailing_list_member_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_list_segment_list_member_map.list_segment_list_member_map_id
        ,input_list_segment_list_member_map.list_segment_key
        ,input_list_segment_list_member_map.list_member_key
        ,input_list_segment_list_member_map.fk_mailing_list_segment_id
        ,input_list_segment_list_member_map.fk_mailing_list_member_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_list_segment_list_member_map.tech_row_hash
        ,input_list_segment_list_member_map.tech_data_load_utc_timestamp
        ,input_list_segment_list_member_map.tech_data_load_uuid
    FROM core.list_segment_list_member_map_i AS input_list_segment_list_member_map
    WHERE input_list_segment_list_member_map.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
