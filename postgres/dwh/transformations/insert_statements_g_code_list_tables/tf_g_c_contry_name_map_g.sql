CREATE OR REPLACE FUNCTION core.tf_g_c_contry_name_map_g()
RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Populates Table that maps country name retrieved from google api to country name from ISO 3166
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:	        2018-12-07 (YYYY-MM-DD)
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

    --------------------
    -- POPULATE TABLE --
    --------------------

    INSERT INTO core.c_contry_name_map_g (
        google_country_name
        ,iso_3166_country_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES
        ('Czechia','Czech Republic', FUNCTION_NAME, -1, -1, 'N/A'),
        ('Palestine','Palestine, State of', FUNCTION_NAME, -1, -1, 'N/A'),
        ('Russia','Russian Federation', FUNCTION_NAME, -1, -1, 'N/A'),
        ('United Kingdom','United Kingdom of Great Britain and Northern Ireland', FUNCTION_NAME, -1, -1, 'N/A'),
        ('United States','United States of America', FUNCTION_NAME, -1, -1, 'N/A'),
        ('Venezuela','Venezuela (Bolivarian Republic of)', FUNCTION_NAME, -1, -1, 'N/A'),
        ('Vietnam','Viet Nam', FUNCTION_NAME, -1, -1, 'N/A')
        ON CONFLICT DO NOTHING;

    RETURN 0;

END;$$

LANGUAGE plpgsql
