CREATE OR REPLACE FUNCTION core.tf_i_src_rest_countries_trg_iso_3166_country_list_i()
RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Populates Table of ISO 3166-1 Countries 
    AUTHOR:             Martin Vrabel ('https://github.com/mvrabel)
    CREATED ON:         2018-12-07 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
    */

DECLARE 

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.iso_3166_country_list_i (
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
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    VALUES (
        -1 -- iso_3166_country_list_id
        ,TEXT_NULL -- iso_3166_country_list_key
        ,TEXT_NULL -- country_name
        ,TEXT_NULL -- alpha2code
        ,TEXT_NULL -- alpha3code
        ,TEXT_NULL -- capital
        ,TEXT_NULL -- region
        ,TEXT_NULL -- subregion
        ,TEXT_NULL -- numericcode
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,TEXT_NULL -- tech_row_hash
        ,-1 -- tech_data_load_utc_timestamp
        ,TEXT_NULL -- tech_data_load_uuid
    ) ON CONFLICT DO NOTHING;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_iso_3166_country_list_i cascade;

    CREATE TEMPORARY TABLE tmp_iso_3166_country_list_i (
        iso_3166_country_list_key           TEXT  NOT NULL
        ,country_name                       TEXT  NOT NULL
        ,alpha2code                         TEXT  NOT NULL
        ,alpha3code                         TEXT  NOT NULL
        ,capital                            TEXT  NOT NULL
        ,region                             TEXT  NOT NULL
        ,subregion                          TEXT  NOT NULL
        ,numericcode                        TEXT  NOT NULL
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
        ,tech_deleted_in_source_system      BOOL NOT NULL
     );

    INSERT INTO tmp_iso_3166_country_list_i (
        iso_3166_country_list_key
        ,country_name
        ,alpha2code
        ,alpha3code
        ,capital
        ,region
        ,subregion
        ,numericcode
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        country_list.alpha3code AS iso_3166_country_list_key
        ,country_list.name AS country_name
        ,tf_u_replace_empty_string_with_null_flag(country_list.alpha2code) AS alpha2code
        ,tf_u_replace_empty_string_with_null_flag(country_list.alpha3code) AS alpha3code
        ,tf_u_replace_empty_string_with_null_flag(country_list.capital) AS capital
        ,tf_u_replace_empty_string_with_null_flag(country_list.region) AS region
        ,tf_u_replace_empty_string_with_null_flag(country_list.subregion) AS subregion 
        ,tf_u_replace_empty_string_with_null_flag(country_list.numericcode) AS numericcode
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(country_list.name::TEXT, '')
            || COALESCE(country_list.alpha2code::TEXT, '')
            || COALESCE(country_list.alpha3code::TEXT, '')
            || COALESCE(country_list.capital::TEXT, '')
            || COALESCE(country_list.region::TEXT, '')
            || COALESCE(country_list.subregion::TEXT, '')
            || COALESCE(country_list.numericcode::TEXT, '')
        ) AS tech_row_hash
        ,country_list.tech_data_load_utc_timestamp
        ,country_list.tech_data_load_uuid
    FROM stage.restcountries_country_list_i AS country_list;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.iso_3166_country_list_i (
        iso_3166_country_list_key
        ,country_name
        ,alpha2code
        ,alpha3code
        ,capital
        ,region
        ,subregion
        ,numericcode
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT 
        tmp_iso_3166_country_list_i.iso_3166_country_list_key
        ,tmp_iso_3166_country_list_i.country_name
        ,tmp_iso_3166_country_list_i.alpha2code
        ,tmp_iso_3166_country_list_i.alpha3code
        ,tmp_iso_3166_country_list_i.capital
        ,tmp_iso_3166_country_list_i.region
        ,tmp_iso_3166_country_list_i.subregion
        ,tmp_iso_3166_country_list_i.numericcode
        ,tmp_iso_3166_country_list_i.tech_insert_function
        ,tmp_iso_3166_country_list_i.tech_insert_utc_timestamp
        ,tmp_iso_3166_country_list_i.tech_deleted_in_source_system
        ,tmp_iso_3166_country_list_i.tech_row_hash
        ,tmp_iso_3166_country_list_i.tech_data_load_utc_timestamp
        ,tmp_iso_3166_country_list_i.tech_data_load_uuid
    FROM tmp_iso_3166_country_list_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql