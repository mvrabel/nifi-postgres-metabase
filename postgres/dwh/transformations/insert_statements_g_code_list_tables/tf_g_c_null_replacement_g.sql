CREATE OR REPLACE FUNCTION core.tf_g_c_null_replacement_g()
RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Populates table with replacement values for different null values
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-12-13 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
    */

DECLARE

stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    ------------------------------
    -- POPULATE CODE LIST TABLE --
    ------------------------------

    INSERT INTO core.c_null_replacement_g (
        text_null
        ,date_never
        ,date_infinity
        ,timestamp_never
        ,timestamp_infinity
        ,interval_never
        ,interval_infinity
        ,text_array_null
        ,timestamp_array_null
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
        'N/A' -- text_null
        ,'1970-01-01'::DATE -- date_never
        ,'3000-01-01'::DATE -- date_infinity
        ,'1970-01-01+00'::TIMESTAMP WITH TIME ZONE -- timestamp_never
        ,'3000-01-01+00'::TIMESTAMP WITH TIME ZONE -- timestamp_infinity
        ,'-178000000 years'::INTERVAL -- interval_never
        ,'178000000 years'::INTERVAL -- interval_infinity
        ,'{N/A}'::TEXT[] -- text_array_null
        ,'{1970-01-01+00}'::TIMESTAMP WITH TIME ZONE[] -- timestamp_array_null
        ,FUNCTION_NAME -- tech_insert_function
        ,-1 -- tech_insert_utc_timestamp
        ,-1 -- tech_data_load_utc_timestamp
        ,'N/A' -- tech_data_load_uuid
        );

    RETURN 0;

END;$$

LANGUAGE plpgsql
