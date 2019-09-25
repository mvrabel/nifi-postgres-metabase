CREATE OR REPLACE FUNCTION core.tf_g_c_date_g()
RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Populates date table from 1970-01-01 until 3000-01-01
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:               MIN (NEVER) DATE '1970-01-01'
                        MAX (TO INFINITY) DATE '3000-01-01'
                        NO (NULL) DATE '-1'
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

    -------------------------
    -- POPULATE DATE TABLE --
    -------------------------

    INSERT INTO core.c_date_g (
        date_id
        ,date_actual
        ,epoch
        ,day_suffix
        ,day_name
        ,day_of_week
        ,day_of_month
        ,day_of_quarter
        ,day_of_year
        ,week_of_month
        ,week_of_year
        ,week_of_year_iso
        ,month_actual
        ,month_name
        ,month_name_abbreviated
        ,quarter_actual
        ,quarter_name
        ,year_actual
        ,first_day_of_week
        ,last_day_of_week
        ,first_day_of_month
        ,last_day_of_month
        ,first_day_of_quarter
        ,last_day_of_quarter
        ,first_day_of_year
        ,last_day_of_year
        ,mmyyyy
        ,mmddyyyy
        ,weekend_indr
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        TO_CHAR(datum, 'yyyymmdd')::INT AS date_id
        ,datum AS date_actual
        ,EXTRACT(epoch FROM datum) AS epoch
        ,TO_CHAR(datum, 'Dth') AS day_suffix
        ,TO_CHAR(datum, 'Day') AS day_name
        ,EXTRACT(isodow FROM datum) AS day_of_week
        ,EXTRACT(DAY FROM datum) AS day_of_month
        ,datum - DATE_TRUNC('quarter', datum)::DATE + 1 AS day_of_quarter
        ,EXTRACT(doy FROM datum) AS day_of_year
        ,TO_CHAR(datum, 'W')::INT AS week_of_month
        ,EXTRACT(week FROM datum) AS week_of_year
        ,TO_CHAR(datum, 'YYYY"-W"IW-D') AS week_of_year_iso
        ,EXTRACT(MONTH FROM datum) AS month_actual
        ,TO_CHAR(datum, 'Month') AS month_name
        ,TO_CHAR(datum, 'Mon') AS month_name_abbreviated
        ,EXTRACT(quarter FROM datum) AS quarter_actual
        ,CASE WHEN EXTRACT(quarter FROM datum) = 1 THEN 'First' WHEN EXTRACT(quarter FROM datum) = 2 THEN 'Second' WHEN EXTRACT(quarter FROM datum) = 3 THEN 'Third' WHEN EXTRACT(quarter FROM datum) = 4 THEN 'Fourth' END AS quarter_name
        ,EXTRACT(isoyear FROM datum) AS year_actual
        ,datum + (1 - EXTRACT(isodow FROM datum))::INT AS first_day_of_week
        ,datum + (7 - EXTRACT(isodow FROM datum))::INT AS last_day_of_week
        ,datum + (1 - EXTRACT(DAY FROM datum))::INT AS first_day_of_month
        ,(DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month
        ,DATE_TRUNC('quarter', datum)::DATE AS first_day_of_quarter
        ,(DATE_TRUNC('quarter', datum) + INTERVAL '3 MONTH - 1 day')::DATE AS last_day_of_quarter
        ,TO_DATE(EXTRACT(isoyear FROM datum) || '-01-01', 'YYYY-MM-DD') AS first_day_of_year
        ,TO_DATE(EXTRACT(isoyear FROM datum) || '-12-31', 'YYYY-MM-DD') AS last_day_of_year
        ,TO_CHAR(datum, 'mmyyyy') AS mmyyyy
        ,TO_CHAR(datum, 'mmddyyyy') AS mmddyyyy
        ,CASE WHEN EXTRACT(isodow FROM datum) IN (
                    6
                    ,7
                    ) THEN TRUE ELSE FALSE END AS weekend_indr
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,-1 AS tech_data_load_utc_timestamp
        ,'Manualy Generated Data' AS tech_data_load_uuid
    FROM (
        SELECT '1970-01-01'::DATE + SEQUENCE.DAY AS datum
        FROM GENERATE_SERIES(0, 29219) AS SEQUENCE(DAY)
        GROUP BY SEQUENCE.DAY
        UNION
        SELECT '3000-01-01'::DATE + SEQUENCE.DAY AS datum
        FROM GENERATE_SERIES(0, 0) AS SEQUENCE(DAY)
        GROUP BY SEQUENCE.DAY
        ) DQ
    ORDER BY 1;

    -----------------------
    -- INSERT NULL DATE --
    -----------------------

    INSERT INTO core.c_date_g (
        date_id
        ,date_actual
        ,epoch
        ,day_suffix
        ,day_name
        ,day_of_week
        ,day_of_month
        ,day_of_quarter
        ,day_of_year
        ,week_of_month
        ,week_of_year
        ,week_of_year_iso
        ,month_actual
        ,month_name
        ,month_name_abbreviated
        ,quarter_actual
        ,quarter_name
        ,year_actual
        ,first_day_of_week
        ,last_day_of_week
        ,first_day_of_month
        ,last_day_of_month
        ,first_day_of_quarter
        ,last_day_of_quarter
        ,first_day_of_year
        ,last_day_of_year
        ,mmyyyy
        ,mmddyyyy
        ,weekend_indr
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
        -1
        ,to_date('1970-01-01','YYYY-MM-DD')
        ,0
        ,'0'
        ,'0'
        ,0
        ,0
        ,0
        ,0
        ,0
        ,0
        ,'0'
        ,0
        ,'0'
        ,'0'
        ,0
        ,'0'
        ,0
        ,to_timestamp(0)::date
        ,to_timestamp(0)::date
        ,to_timestamp(0)::date
        ,to_timestamp(0)::date
        ,to_timestamp(0)::date
        ,to_timestamp(0)::date
        ,to_timestamp(0)::date
        ,to_timestamp(0)::date
        ,'0'
        ,'0'
        ,false
        ,FUNCTION_NAME
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT
        ,-1
        ,'Manualy Generated Data'
        );

    RETURN 0;
END;$$
LANGUAGE plpgsql
