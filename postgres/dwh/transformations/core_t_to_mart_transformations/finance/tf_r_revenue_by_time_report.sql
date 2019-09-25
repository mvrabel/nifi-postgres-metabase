CREATE OR REPLACE FUNCTION mart.tf_r_revenue_by_time_report()
RETURNS INTEGER AS $$

DECLARE

-- TODO: rewrite those variables
YOUR_COMPANY_IN_PIPEDRIVE TEXT := E'\'PIPEDRIVE_ORGANIZATION_XYZ\'';

BEGIN

    WITH

    ------------------------------------
    -- Yearly Revene Per Revenue Type --
    ------------------------------------
    revenue_per_revenue_type_per_year_table AS (
        SELECT *
        FROM crosstab('SELECT
                    revenue_type
                    ,seller
                    ,revenue_year
                    ,sum(usd_revenue) AS usd_revenue
                FROM mart.revenue_per_month_per_sale
                WHERE revenue_year >= 2016
                    AND revenue_year <= 2020
                    AND seller_code = ' || YOUR_COMPANY_IN_PIPEDRIVE || '
                GROUP BY
                    revenue_year
                    ,revenue_type
                    ,seller
                ORDER BY 1'
                ,
                'SELECT year_series
                FROM generate_series(2016, 2020) AS year_series
                ') AS (
                revenue_type TEXT
                ,seller TEXT
                ,"2016 Total" NUMERIC(10, 2)
                ,"2017 Total" NUMERIC(10, 2)
                ,"2018 Total" NUMERIC(10, 2)
                ,"2019 Total" NUMERIC(10, 2)
                ,"2020 Total" NUMERIC(10, 2)
                )
        
    )
    -----------------------
    -- Yearly Revene SUM --
    -----------------------
    ,sum_revenue_per_year_table AS (
        SELECT *
        FROM crosstab('SELECT
                    ''SUM'' AS revenue_type
                    ,seller
                    ,revenue_year
                    ,sum(usd_revenue) AS usd_revenue
                FROM mart.revenue_per_month_per_sale
                WHERE revenue_year >= 2016
                    AND revenue_year <= 2020
                    AND seller_code = ' || YOUR_COMPANY_IN_PIPEDRIVE || '
                GROUP BY
                    revenue_year
                    ,seller
                ORDER BY 1'
                ,
                'SELECT year_series
                FROM generate_series(2016, 2020) AS year_series
                ') AS (
                revenue_type TEXT
                ,seller TEXT
                ,"2016 Total" NUMERIC(10, 2)
                ,"2017 Total" NUMERIC(10, 2)
                ,"2018 Total" NUMERIC(10, 2)
                ,"2019 Total" NUMERIC(10, 2)
                ,"2020 Total" NUMERIC(10, 2)
                )
    )
    ---------------------------------------
    -- Quarterly Revene Per Revenue Type --
    ---------------------------------------
    ,revenue_per_revenue_type_per_quarter_table AS (
        SELECT *
        FROM crosstab('SELECT
                    revenue_type
                    ,seller
                    ,revenue_quarter_year
                    ,sum(usd_revenue) AS usd_revenue
                FROM mart.revenue_per_month_per_sale
                WHERE revenue_year >= 2016
                    AND revenue_year <= 2020
                    AND seller_code = ' || YOUR_COMPANY_IN_PIPEDRIVE || '
                GROUP BY revenue_quarter_year
                    ,revenue_type
                    ,seller
                ORDER BY 1'
                ,
                'SELECT ''Q'' || quartal_series || '' '' || year__series
                FROM generate_series(2016, 2020) year__series
                    ,generate_series(1, 4) quartal_series
                ') AS (
                revenue_type TEXT
                ,seller TEXT
                ,"Q1 2016" NUMERIC(10, 2)
                ,"Q2 2016" NUMERIC(10, 2)
                ,"Q3 2016" NUMERIC(10, 2)
                ,"Q4 2016" NUMERIC(10, 2)
                ,"Q1 2017" NUMERIC(10, 2)
                ,"Q2 2017" NUMERIC(10, 2)
                ,"Q3 2017" NUMERIC(10, 2)
                ,"Q4 2017" NUMERIC(10, 2)
                ,"Q1 2018" NUMERIC(10, 2)
                ,"Q2 2018" NUMERIC(10, 2)
                ,"Q3 2018" NUMERIC(10, 2)
                ,"Q4 2018" NUMERIC(10, 2)
                ,"Q1 2019" NUMERIC(10, 2)
                ,"Q2 2019" NUMERIC(10, 2)
                ,"Q3 2019" NUMERIC(10, 2)
                ,"Q4 2019" NUMERIC(10, 2)
                ,"Q1 2020" NUMERIC(10, 2)
                ,"Q2 2020" NUMERIC(10, 2)
                ,"Q3 2020" NUMERIC(10, 2)
                ,"Q4 2020" NUMERIC(10, 2)
                )
    )
    --------------------------
    -- Quarterly Revene SUM --
    --------------------------
    ,sum_revenue_per_quarter_table AS (
        SELECT *
        FROM crosstab('SELECT
                        ''SUM''
                        ,seller
                        ,revenue_quarter_year
                        ,sum(usd_revenue) AS usd_revenue
                    FROM mart.revenue_per_month_per_sale
                    WHERE revenue_year >= 2016
                        AND revenue_year <= 2020
                        AND seller_code = ' || YOUR_COMPANY_IN_PIPEDRIVE || '
                    GROUP BY
                        revenue_quarter_year
                        ,seller
                    ORDER BY 1'
                    ,
                'SELECT ''Q'' || quartal_series || '' '' || year__series
                FROM generate_series(2016, 2020) year__series
                    ,generate_series(1, 4) quartal_series
                ') AS (
                revenue_type TEXT
                ,seller TEXT
                ,"Q1 2016" NUMERIC(10, 2)
                ,"Q2 2016" NUMERIC(10, 2)
                ,"Q3 2016" NUMERIC(10, 2)
                ,"Q4 2016" NUMERIC(10, 2)
                ,"Q1 2017" NUMERIC(10, 2)
                ,"Q2 2017" NUMERIC(10, 2)
                ,"Q3 2017" NUMERIC(10, 2)
                ,"Q4 2017" NUMERIC(10, 2)
                ,"Q1 2018" NUMERIC(10, 2)
                ,"Q2 2018" NUMERIC(10, 2)
                ,"Q3 2018" NUMERIC(10, 2)
                ,"Q4 2018" NUMERIC(10, 2)
                ,"Q1 2019" NUMERIC(10, 2)
                ,"Q2 2019" NUMERIC(10, 2)
                ,"Q3 2019" NUMERIC(10, 2)
                ,"Q4 2019" NUMERIC(10, 2)
                ,"Q1 2020" NUMERIC(10, 2)
                ,"Q2 2020" NUMERIC(10, 2)
                ,"Q3 2020" NUMERIC(10, 2)
                ,"Q4 2020" NUMERIC(10, 2)
                )
    )
    -------------------------------------
    -- Monthly Revene Per Revenue Type --
    -------------------------------------
    ,revenue_per_revenue_type_per_month_table AS (
        SELECT *
        FROM crosstab('SELECT
                        revenue_type
                        ,seller
                        ,revenue_month_year
                        ,sum(usd_revenue) AS usd_revenue
                    FROM mart.revenue_per_month_per_sale
                    WHERE revenue_year >= 2016
                        AND revenue_year <= 2020
                        AND seller_code = ' || YOUR_COMPANY_IN_PIPEDRIVE || '
                    GROUP BY
                        revenue_month_year
                        ,revenue_type
                        ,seller
                    ORDER BY 1'
                    ,
                    'SELECT to_char(month_series, ''fm00'') || '' '' || year__series
                    FROM generate_series(2016, 2020) AS year__series
                        ,generate_series(1, 12) AS month_series
                    ') AS (
                revenue_type TEXT
                ,seller TEXT
                ,"01 2016" NUMERIC(10, 2)
                ,"02 2016" NUMERIC(10, 2)
                ,"03 2016" NUMERIC(10, 2)
                ,"04 2016" NUMERIC(10, 2)
                ,"05 2016" NUMERIC(10, 2)
                ,"06 2016" NUMERIC(10, 2)
                ,"07 2016" NUMERIC(10, 2)
                ,"08 2016" NUMERIC(10, 2)
                ,"09 2016" NUMERIC(10, 2)
                ,"10 2016" NUMERIC(10, 2)
                ,"11 2016" NUMERIC(10, 2)
                ,"12 2016" NUMERIC(10, 2)
                ,"01 2017" NUMERIC(10, 2)
                ,"02 2017" NUMERIC(10, 2)
                ,"03 2017" NUMERIC(10, 2)
                ,"04 2017" NUMERIC(10, 2)
                ,"05 2017" NUMERIC(10, 2)
                ,"06 2017" NUMERIC(10, 2)
                ,"07 2017" NUMERIC(10, 2)
                ,"08 2017" NUMERIC(10, 2)
                ,"09 2017" NUMERIC(10, 2)
                ,"10 2017" NUMERIC(10, 2)
                ,"11 2017" NUMERIC(10, 2)
                ,"12 2017" NUMERIC(10, 2)
                ,"01 2018" NUMERIC(10, 2)
                ,"02 2018" NUMERIC(10, 2)
                ,"03 2018" NUMERIC(10, 2)
                ,"04 2018" NUMERIC(10, 2)
                ,"05 2018" NUMERIC(10, 2)
                ,"06 2018" NUMERIC(10, 2)
                ,"07 2018" NUMERIC(10, 2)
                ,"08 2018" NUMERIC(10, 2)
                ,"09 2018" NUMERIC(10, 2)
                ,"10 2018" NUMERIC(10, 2)
                ,"11 2018" NUMERIC(10, 2)
                ,"12 2018" NUMERIC(10, 2)
                ,"01 2019" NUMERIC(10, 2)
                ,"02 2019" NUMERIC(10, 2)
                ,"03 2019" NUMERIC(10, 2)
                ,"04 2019" NUMERIC(10, 2)
                ,"05 2019" NUMERIC(10, 2)
                ,"06 2019" NUMERIC(10, 2)
                ,"07 2019" NUMERIC(10, 2)
                ,"08 2019" NUMERIC(10, 2)
                ,"09 2019" NUMERIC(10, 2)
                ,"10 2019" NUMERIC(10, 2)
                ,"11 2019" NUMERIC(10, 2)
                ,"12 2019" NUMERIC(10, 2)
                ,"01 2020" NUMERIC(10, 2)
                ,"02 2020" NUMERIC(10, 2)
                ,"03 2020" NUMERIC(10, 2)
                ,"04 2020" NUMERIC(10, 2)
                ,"05 2020" NUMERIC(10, 2)
                ,"06 2020" NUMERIC(10, 2)
                ,"07 2020" NUMERIC(10, 2)
                ,"08 2020" NUMERIC(10, 2)
                ,"09 2020" NUMERIC(10, 2)
                ,"10 2020" NUMERIC(10, 2)
                ,"11 2020" NUMERIC(10, 2)
                ,"12 2020" NUMERIC(10, 2)
                )
    )
    -----------------------
    -- Monthly Revene SUM --
    -----------------------
    ,sum_revenue_per_month_table AS (
        SELECT *
        FROM crosstab('SELECT
                        ''SUM''
                        ,seller
                        ,revenue_month_year
                        ,sum(usd_revenue) AS usd_revenue
                    FROM mart.revenue_per_month_per_sale
                    WHERE revenue_year >= 2015
                        AND revenue_year <= 2020
                        AND seller_code = ' || YOUR_COMPANY_IN_PIPEDRIVE || '
                    GROUP BY
                        revenue_month_year
                        ,seller
                    ORDER BY 1'
                    ,
                    'SELECT to_char(month_series, ''fm00'') || '' '' || year__series
                    FROM generate_series(2016, 2020) AS year__series
                        ,generate_series(1, 12) AS month_series
                    ') AS (
                revenue_type TEXT
                ,seller TEXT
                ,"01 2016" NUMERIC(10, 2)
                ,"02 2016" NUMERIC(10, 2)
                ,"03 2016" NUMERIC(10, 2)
                ,"04 2016" NUMERIC(10, 2)
                ,"05 2016" NUMERIC(10, 2)
                ,"06 2016" NUMERIC(10, 2)
                ,"07 2016" NUMERIC(10, 2)
                ,"08 2016" NUMERIC(10, 2)
                ,"09 2016" NUMERIC(10, 2)
                ,"10 2016" NUMERIC(10, 2)
                ,"11 2016" NUMERIC(10, 2)
                ,"12 2016" NUMERIC(10, 2)
                ,"01 2017" NUMERIC(10, 2)
                ,"02 2017" NUMERIC(10, 2)
                ,"03 2017" NUMERIC(10, 2)
                ,"04 2017" NUMERIC(10, 2)
                ,"05 2017" NUMERIC(10, 2)
                ,"06 2017" NUMERIC(10, 2)
                ,"07 2017" NUMERIC(10, 2)
                ,"08 2017" NUMERIC(10, 2)
                ,"09 2017" NUMERIC(10, 2)
                ,"10 2017" NUMERIC(10, 2)
                ,"11 2017" NUMERIC(10, 2)
                ,"12 2017" NUMERIC(10, 2)
                ,"01 2018" NUMERIC(10, 2)
                ,"02 2018" NUMERIC(10, 2)
                ,"03 2018" NUMERIC(10, 2)
                ,"04 2018" NUMERIC(10, 2)
                ,"05 2018" NUMERIC(10, 2)
                ,"06 2018" NUMERIC(10, 2)
                ,"07 2018" NUMERIC(10, 2)
                ,"08 2018" NUMERIC(10, 2)
                ,"09 2018" NUMERIC(10, 2)
                ,"10 2018" NUMERIC(10, 2)
                ,"11 2018" NUMERIC(10, 2)
                ,"12 2018" NUMERIC(10, 2)
                ,"01 2019" NUMERIC(10, 2)
                ,"02 2019" NUMERIC(10, 2)
                ,"03 2019" NUMERIC(10, 2)
                ,"04 2019" NUMERIC(10, 2)
                ,"05 2019" NUMERIC(10, 2)
                ,"06 2019" NUMERIC(10, 2)
                ,"07 2019" NUMERIC(10, 2)
                ,"08 2019" NUMERIC(10, 2)
                ,"09 2019" NUMERIC(10, 2)
                ,"10 2019" NUMERIC(10, 2)
                ,"11 2019" NUMERIC(10, 2)
                ,"12 2019" NUMERIC(10, 2)
                ,"01 2020" NUMERIC(10, 2)
                ,"02 2020" NUMERIC(10, 2)
                ,"03 2020" NUMERIC(10, 2)
                ,"04 2020" NUMERIC(10, 2)
                ,"05 2020" NUMERIC(10, 2)
                ,"06 2020" NUMERIC(10, 2)
                ,"07 2020" NUMERIC(10, 2)
                ,"08 2020" NUMERIC(10, 2)
                ,"09 2020" NUMERIC(10, 2)
                ,"10 2020" NUMERIC(10, 2)
                ,"11 2020" NUMERIC(10, 2)
                ,"12 2020" NUMERIC(10, 2)
                )
    )
    INSERT INTO mart.revenue_by_time_report (
        revenue_type
        ,seller
        ,"01 2016"
        ,"02 2016"
        ,"03 2016"
        ,"Q1 2016"
        ,"04 2016"
        ,"05 2016"
        ,"06 2016"
        ,"Q2 2016"
        ,"07 2016"
        ,"08 2016"
        ,"09 2016"
        ,"Q3 2016"
        ,"10 2016"
        ,"11 2016"
        ,"12 2016"
        ,"Q4 2016"
        ,"2016 Total"
        ,"01 2017"
        ,"02 2017"
        ,"03 2017"
        ,"Q1 2017"
        ,"04 2017"
        ,"05 2017"
        ,"06 2017"
        ,"Q2 2017"
        ,"07 2017"
        ,"08 2017"
        ,"09 2017"
        ,"Q3 2017"
        ,"10 2017"
        ,"11 2017"
        ,"12 2017"
        ,"Q4 2017"
        ,"2017 Total"
        ,"01 2018"
        ,"02 2018"
        ,"03 2018"
        ,"Q1 2018"
        ,"04 2018"
        ,"05 2018"
        ,"06 2018"
        ,"Q2 2018"
        ,"07 2018"
        ,"08 2018"
        ,"09 2018"
        ,"Q3 2018"
        ,"10 2018"
        ,"11 2018"
        ,"12 2018"
        ,"Q4 2018"
        ,"2018 Total"
        ,"01 2019"
        ,"02 2019"
        ,"03 2019"
        ,"Q1 2019"
        ,"04 2019"
        ,"05 2019"
        ,"06 2019"
        ,"Q2 2019"
        ,"07 2019"
        ,"08 2019"
        ,"09 2019"
        ,"Q3 2019"
        ,"10 2019"
        ,"11 2019"
        ,"12 2019"
        ,"Q4 2019"
        ,"2019 Total"
        ,"01 2020"
        ,"02 2020"
        ,"03 2020"
        ,"Q1 2020"
        ,"04 2020"
        ,"05 2020"
        ,"06 2020"
        ,"Q2 2020"
        ,"07 2020"
        ,"08 2020"
        ,"09 2020"
        ,"Q3 2020"
        ,"10 2020"
        ,"11 2020"
        ,"12 2020"
        ,"Q4 2020"
        ,"2020 Total"
        )
    SELECT
        revenue_type
        ,seller
        ,COALESCE("01 2016", 0)      AS "01 2016"
        ,COALESCE("02 2016", 0)      AS "02 2016"
        ,COALESCE("03 2016", 0)      AS "03 2016"
        ,COALESCE("Q1 2016", 0)      AS "Q1 2016"
        ,COALESCE("04 2016", 0)      AS "04 2016"
        ,COALESCE("05 2016", 0)      AS "05 2016"
        ,COALESCE("06 2016", 0)      AS "06 2016"
        ,COALESCE("Q2 2016", 0)      AS "Q2 2016"
        ,COALESCE("07 2016", 0)      AS "07 2016"
        ,COALESCE("08 2016", 0)      AS "08 2016"
        ,COALESCE("09 2016", 0)      AS "09 2016"
        ,COALESCE("Q3 2016", 0)      AS "Q3 2016"
        ,COALESCE("10 2016", 0)      AS "10 2016"
        ,COALESCE("11 2016", 0)      AS "11 2016"
        ,COALESCE("12 2016", 0)      AS "12 2016"
        ,COALESCE("Q4 2016", 0)      AS "Q4 2016"
        ,COALESCE("2016 Total", 0)   AS "2016 Total"
        ,COALESCE("01 2017", 0)      AS "01 2017"
        ,COALESCE("02 2017", 0)      AS "02 2017"
        ,COALESCE("03 2017", 0)      AS "03 2017"
        ,COALESCE("Q1 2017", 0)      AS "Q1 2017"
        ,COALESCE("04 2017", 0)      AS "04 2017"
        ,COALESCE("05 2017", 0)      AS "05 2017"
        ,COALESCE("06 2017", 0)      AS "06 2017"
        ,COALESCE("Q2 2017", 0)      AS "Q2 2017"
        ,COALESCE("07 2017", 0)      AS "07 2017"
        ,COALESCE("08 2017", 0)      AS "08 2017"
        ,COALESCE("09 2017", 0)      AS "09 2017"
        ,COALESCE("Q3 2017", 0)      AS "Q3 2017"
        ,COALESCE("10 2017", 0)      AS "10 2017"
        ,COALESCE("11 2017", 0)      AS "11 2017"
        ,COALESCE("12 2017", 0)      AS "12 2017"
        ,COALESCE("Q4 2017", 0)      AS "Q4 2017"
        ,COALESCE("2017 Total", 0)   AS "2017 Total"
        ,COALESCE("01 2018", 0)      AS "01 2018"
        ,COALESCE("02 2018", 0)      AS "02 2018"
        ,COALESCE("03 2018", 0)      AS "03 2018"
        ,COALESCE("Q1 2018", 0)      AS "Q1 2018"
        ,COALESCE("04 2018", 0)      AS "04 2018"
        ,COALESCE("05 2018", 0)      AS "05 2018"
        ,COALESCE("06 2018", 0)      AS "06 2018"
        ,COALESCE("Q2 2018", 0)      AS "Q2 2018"
        ,COALESCE("07 2018", 0)      AS "07 2018"
        ,COALESCE("08 2018", 0)      AS "08 2018"
        ,COALESCE("09 2018", 0)      AS "09 2018"
        ,COALESCE("Q3 2018", 0)      AS "Q3 2018"
        ,COALESCE("10 2018", 0)      AS "10 2018"
        ,COALESCE("11 2018", 0)      AS "11 2018"
        ,COALESCE("12 2018", 0)      AS "12 2018"
        ,COALESCE("Q4 2018", 0)      AS "Q4 2018"
        ,COALESCE("2018 Total", 0)   AS "2018 Total"
        ,COALESCE("01 2019", 0)      AS "01 2019"
        ,COALESCE("02 2019", 0)      AS "02 2019"
        ,COALESCE("03 2019", 0)      AS "03 2019"
        ,COALESCE("Q1 2019", 0)      AS "Q1 2019"
        ,COALESCE("04 2019", 0)      AS "04 2019"
        ,COALESCE("05 2019", 0)      AS "05 2019"
        ,COALESCE("06 2019", 0)      AS "06 2019"
        ,COALESCE("Q2 2019", 0)      AS "Q2 2019"
        ,COALESCE("07 2019", 0)      AS "07 2019"
        ,COALESCE("08 2019", 0)      AS "08 2019"
        ,COALESCE("09 2019", 0)      AS "09 2019"
        ,COALESCE("Q3 2019", 0)      AS "Q3 2019"
        ,COALESCE("10 2019", 0)      AS "10 2019"
        ,COALESCE("11 2019", 0)      AS "11 2019"
        ,COALESCE("12 2019", 0)      AS "12 2019"
        ,COALESCE("Q4 2019", 0)      AS "Q4 2019"
        ,COALESCE("2019 Total", 0)   AS "2019 Total"
        ,COALESCE("01 2020", 0)      AS "01 2020"
        ,COALESCE("02 2020", 0)      AS "02 2020"
        ,COALESCE("03 2020", 0)      AS "03 2020"
        ,COALESCE("Q1 2020", 0)      AS "Q1 2020"
        ,COALESCE("04 2020", 0)      AS "04 2020"
        ,COALESCE("05 2020", 0)      AS "05 2020"
        ,COALESCE("06 2020", 0)      AS "06 2020"
        ,COALESCE("Q2 2020", 0)      AS "Q2 2020"
        ,COALESCE("07 2020", 0)      AS "07 2020"
        ,COALESCE("08 2020", 0)      AS "08 2020"
        ,COALESCE("09 2020", 0)      AS "09 2020"
        ,COALESCE("Q3 2020", 0)      AS "Q3 2020"
        ,COALESCE("10 2020", 0)      AS "10 2020"
        ,COALESCE("11 2020", 0)      AS "11 2020"
        ,COALESCE("12 2020", 0)      AS "12 2020"
        ,COALESCE("Q4 2020", 0)      AS "Q4 2020"
        ,COALESCE("2020 Total", 0)   AS "2020 Total"
        FROM (
        SELECT
            revenue_per_revenue_type_per_year_table.revenue_type
            ,revenue_per_revenue_type_per_year_table.seller
            ,"01 2016"
            ,"02 2016"
            ,"03 2016"
            ,"Q1 2016"
            ,"04 2016"
            ,"05 2016"
            ,"06 2016"
            ,"Q2 2016"
            ,"07 2016"
            ,"08 2016"
            ,"09 2016"
            ,"Q3 2016"
            ,"10 2016"
            ,"11 2016"
            ,"12 2016"
            ,"Q4 2016"
            ,"2016 Total"
            ,"01 2017"
            ,"02 2017"
            ,"03 2017"
            ,"Q1 2017"
            ,"04 2017"
            ,"05 2017"
            ,"06 2017"
            ,"Q2 2017"
            ,"07 2017"
            ,"08 2017"
            ,"09 2017"
            ,"Q3 2017"
            ,"10 2017"
            ,"11 2017"
            ,"12 2017"
            ,"Q4 2017"
            ,"2017 Total"
            ,"01 2018"
            ,"02 2018"
            ,"03 2018"
            ,"Q1 2018"
            ,"04 2018"
            ,"05 2018"
            ,"06 2018"
            ,"Q2 2018"
            ,"07 2018"
            ,"08 2018"
            ,"09 2018"
            ,"Q3 2018"
            ,"10 2018"
            ,"11 2018"
            ,"12 2018"
            ,"Q4 2018"
            ,"2018 Total"
            ,"01 2019"
            ,"02 2019"
            ,"03 2019"
            ,"Q1 2019"
            ,"04 2019"
            ,"05 2019"
            ,"06 2019"
            ,"Q2 2019"
            ,"07 2019"
            ,"08 2019"
            ,"09 2019"
            ,"Q3 2019"
            ,"10 2019"
            ,"11 2019"
            ,"12 2019"
            ,"Q4 2019"
            ,"2019 Total"
            ,"01 2020"
            ,"02 2020"
            ,"03 2020"
            ,"Q1 2020"
            ,"04 2020"
            ,"05 2020"
            ,"06 2020"
            ,"Q2 2020"
            ,"07 2020"
            ,"08 2020"
            ,"09 2020"
            ,"Q3 2020"
            ,"10 2020"
            ,"11 2020"
            ,"12 2020"
            ,"Q4 2020"
            ,"2020 Total"
        FROM revenue_per_revenue_type_per_year_table
        JOIN revenue_per_revenue_type_per_quarter_table ON revenue_per_revenue_type_per_quarter_table.revenue_type = revenue_per_revenue_type_per_year_table.revenue_type
        AND revenue_per_revenue_type_per_quarter_table.seller = revenue_per_revenue_type_per_year_table.seller
        JOIN revenue_per_revenue_type_per_month_table ON revenue_per_revenue_type_per_month_table.revenue_type = revenue_per_revenue_type_per_year_table.revenue_type
        AND revenue_per_revenue_type_per_month_table.seller = revenue_per_revenue_type_per_year_table.seller

        UNION ALL

        SELECT
            sum_revenue_per_year_table.revenue_type
            ,sum_revenue_per_year_table.seller
            ,"01 2016"
            ,"02 2016"
            ,"03 2016"
            ,"Q1 2016"
            ,"04 2016"
            ,"05 2016"
            ,"06 2016"
            ,"Q2 2016"
            ,"07 2016"
            ,"08 2016"
            ,"09 2016"
            ,"Q3 2016"
            ,"10 2016"
            ,"11 2016"
            ,"12 2016"
            ,"Q4 2016"
            ,"2016 Total"
            ,"01 2017"
            ,"02 2017"
            ,"03 2017"
            ,"Q1 2017"
            ,"04 2017"
            ,"05 2017"
            ,"06 2017"
            ,"Q2 2017"
            ,"07 2017"
            ,"08 2017"
            ,"09 2017"
            ,"Q3 2017"
            ,"10 2017"
            ,"11 2017"
            ,"12 2017"
            ,"Q4 2017"
            ,"2017 Total"
            ,"01 2018"
            ,"02 2018"
            ,"03 2018"
            ,"Q1 2018"
            ,"04 2018"
            ,"05 2018"
            ,"06 2018"
            ,"Q2 2018"
            ,"07 2018"
            ,"08 2018"
            ,"09 2018"
            ,"Q3 2018"
            ,"10 2018"
            ,"11 2018"
            ,"12 2018"
            ,"Q4 2018"
            ,"2018 Total"
            ,"01 2019"
            ,"02 2019"
            ,"03 2019"
            ,"Q1 2019"
            ,"04 2019"
            ,"05 2019"
            ,"06 2019"
            ,"Q2 2019"
            ,"07 2019"
            ,"08 2019"
            ,"09 2019"
            ,"Q3 2019"
            ,"10 2019"
            ,"11 2019"
            ,"12 2019"
            ,"Q4 2019"
            ,"2019 Total"
            ,"01 2020"
            ,"02 2020"
            ,"03 2020"
            ,"Q1 2020"
            ,"04 2020"
            ,"05 2020"
            ,"06 2020"
            ,"Q2 2020"
            ,"07 2020"
            ,"08 2020"
            ,"09 2020"
            ,"Q3 2020"
            ,"10 2020"
            ,"11 2020"
            ,"12 2020"
            ,"Q4 2020"
            ,"2020 Total"
        FROM sum_revenue_per_year_table
        JOIN sum_revenue_per_quarter_table ON sum_revenue_per_quarter_table.revenue_type = sum_revenue_per_year_table.revenue_type
            AND sum_revenue_per_quarter_table.seller = sum_revenue_per_year_table.seller
        JOIN sum_revenue_per_month_table ON sum_revenue_per_month_table.revenue_type = sum_revenue_per_quarter_table.revenue_type
            AND sum_revenue_per_month_table.seller = sum_revenue_per_quarter_table.seller
        ) AS foo
    ORDER BY array_position(array ['Licence','Subscription','Support','Services','Other'], revenue_type);

    RETURN 0;

END;$$

LANGUAGE plpgsql;
