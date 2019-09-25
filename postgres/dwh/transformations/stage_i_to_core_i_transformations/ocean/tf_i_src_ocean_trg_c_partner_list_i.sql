CREATE OR REPLACE FUNCTION core.tf_i_src_ocean_trg_c_partner_list_i()
RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from stage 'ocean_*' tables into core input table partner_list_i
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

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_c_partner_list_i;

    CREATE TEMPORARY TABLE tmp_c_partner_list_i (
        partner_name                    TEXT NOT NULL
        ,is_tracked                     BOOL NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_deleted_in_source_system  BOOL NOT NULL
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULL
    );

    INSERT INTO tmp_c_partner_list_i (
        partner_name
        ,is_tracked
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        partner_list.partner_name AS partner_name
        ,partner_list.is_tracked
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            partner_list.partner_name::TEXT
            || partner_list.is_tracked::TEXT
        ) AS tech_row_hash
        ,partner_list.tech_data_load_utc_timestamp
        ,partner_list.tech_data_load_uuid
    FROM stage.ocean_partner_list_i AS partner_list;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.c_partner_list_i (
        partner_name
        ,is_tracked
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_c_partner_list_i.partner_name
        ,tmp_c_partner_list_i.is_tracked
        ,tmp_c_partner_list_i.tech_insert_function
        ,tmp_c_partner_list_i.tech_insert_utc_timestamp
        ,tmp_c_partner_list_i.tech_deleted_in_source_system
        ,tmp_c_partner_list_i.tech_row_hash
        ,tmp_c_partner_list_i.tech_data_load_utc_timestamp
        ,tmp_c_partner_list_i.tech_data_load_uuid
    FROM tmp_c_partner_list_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
