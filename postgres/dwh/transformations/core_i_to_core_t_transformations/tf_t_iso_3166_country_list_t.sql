CREATE OR REPLACE FUNCTION core.tf_t_iso_3166_country_list_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from core iso_3166_country_list_i input table into core 'today' table iso_3166_country_list_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-12-07 (YYYY-MM-DD)
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

    INSERT INTO core.iso_3166_country_list_t (
        iso_3166_country_list_id
        ,iso_3166_country_list_key
        ,country_name
        ,alpha2code
        ,alpha3code
        ,capital
        ,region
        ,subregion
        ,numericcode
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )

    SELECT
        input_country_list.iso_3166_country_list_id
        ,input_country_list.iso_3166_country_list_key
        ,input_country_list.country_name
        ,input_country_list.alpha2code
        ,input_country_list.alpha3code
        ,input_country_list.capital
        ,input_country_list.region
        ,input_country_list.subregion
        ,input_country_list.numericcode
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_country_list.tech_row_hash
        ,input_country_list.tech_data_load_utc_timestamp
        ,input_country_list.tech_data_load_uuid
    FROM core.iso_3166_country_list_i AS input_country_list
    WHERE input_country_list.tech_deleted_in_source_system IS FALSE;

    RETURN 0;
END;$$

LANGUAGE plpgsql

