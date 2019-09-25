CREATE OR REPLACE FUNCTION core.tf_t_issue_relation_map_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core issue_relation_map_i input table into core 'today' table issue_relation_map_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-15 (YYYY-MM-DD)
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

    INSERT INTO core.issue_relation_map_t (
        issue_relation_map_id
        ,issue_key
        ,issue_key_related_issue
        ,fk_issue_id
        ,fk_issue_id_related_issue
        ,relation
        ,relation_direction
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_issue_relation_map.issue_relation_map_id
        ,input_issue_relation_map.issue_key
        ,input_issue_relation_map.issue_key_related_issue
        ,input_issue_relation_map.fk_issue_id
        ,input_issue_relation_map.fk_issue_id_related_issue
        ,input_issue_relation_map.relation
        ,input_issue_relation_map.relation_direction
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_issue_relation_map.tech_row_hash
        ,input_issue_relation_map.tech_data_load_utc_timestamp
        ,input_issue_relation_map.tech_data_load_uuid
    FROM core.issue_relation_map_i AS input_issue_relation_map
    WHERE input_issue_relation_map.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql

