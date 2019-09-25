CREATE OR REPLACE FUNCTION mart.tf_r_booking_by_time_report()
RETURNS INTEGER AS $$

BEGIN

    WITH
    booking_per_revenue_type_per_year_table AS (
        SELECT *
        FROM crosstab('SELECT
                        revenue_type
                        ,booking_year
                        ,booked_usd_amount
                    FROM mart.booking_per_revenue_type_per_year
                    WHERE booking_year >= 2016
                        AND booking_year <= 2020
                    ORDER BY 1'
                ,
                'SELECT m FROM generate_series(2016,2020) m') AS (
                revenue_type TEXT
                ,"2016 Total" NUMERIC(10, 2)
                ,"2017 Total" NUMERIC(10, 2)
                ,"2018 Total" NUMERIC(10, 2)
                ,"2019 Total" NUMERIC(10, 2)
                ,"2020 Total" NUMERIC(10, 2)
                )
        )
    ,sum_booking_per_year_table AS (
        SELECT *
        FROM crosstab('SELECT
                    ''SUM''
                    ,booking_year
                    ,SUM(booked_usd_amount)
                    FROM mart.booking_per_revenue_type_per_year
                    GROUP BY booking_year'
                ,'SELECT m FROM generate_series(2016,2020) m') AS (
                revenue_type TEXT
                ,"2016 Total" NUMERIC(10, 2)
                ,"2017 Total" NUMERIC(10, 2)
                ,"2018 Total" NUMERIC(10, 2)
                ,"2019 Total" NUMERIC(10, 2)
                ,"2020 Total" NUMERIC(10, 2)
                )
        )
        -- select * from sum_booking_per_year_table
        -- select * from booking_per_revenue_type_per_year_table
    ,booking_per_revenue_type_per_quarter_table AS (
        SELECT *
        FROM crosstab('SELECT
                        revenue_type
                        ,booking_quarter_year
                        ,booked_usd_amount
                    FROM mart.booking_per_revenue_type_per_quarter
                    WHERE booking_year >= 2016
                        AND booking_year <= 2020
                    ORDER BY 1'
                ,
                'SELECT booking_quarter_year FROM (
                        SELECT
                            booking_quarter_year
                            ,dense_rank() OVER (
                                ORDER BY booking_year
                                    ,booking_quarter
                                ) AS rank
                        FROM mart.booking_per_revenue_type_per_quarter m
                        WHERE booking_year >= 2016
                            AND booking_year <= 2020
                ) foo
               group by  booking_quarter_year, rank
               ORDER BY rank') AS (
                revenue_type TEXT
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
        --select * from booking_per_revenue_type_per_quarter_table
    ,sum_booking_per_quarter_table AS (
        SELECT *
        FROM crosstab('SELECT ''SUM''
                        ,booking_quarter_year
                        ,SUM(booked_usd_amount)
                    FROM mart.booking_per_revenue_type_per_quarter
                    GROUP BY booking_quarter_year'
                ,
                'SELECT booking_quarter_year FROM (
                        SELECT
                            booking_quarter_year
                            ,dense_rank() OVER (
                                ORDER BY booking_year
                                    ,booking_quarter
                                ) AS rank
                        FROM mart.booking_per_revenue_type_per_quarter m
                        WHERE booking_year >= 2016
                            AND booking_year <= 2020
                ) foo
               group by  booking_quarter_year, rank
               ORDER BY rank') AS (
                revenue_type TEXT
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
        -- select * from sum_booking_per_quarter_table
    ,booking_per_revenue_type_per_month_table AS (
        SELECT *
        FROM crosstab('SELECT
                        revenue_type
                        ,booking_month_year
                        ,booked_usd_amount
                    FROM mart.booking_per_revenue_type_per_month
                    WHERE booking_year >= 2016
                        AND booking_year <= 2020
                    ORDER BY 1'
                , --array_position(array['Licence','Subscription','Support','Services','Other'], revenue_type
                'SELECT
                    to_char(month_number, ''fm00'') || '' '' || year_number AS month_year
                FROM generate_series(2016, 2020) AS year_number
                    ,generate_series(1, 12) AS month_number
                ') AS (
                revenue_type TEXT
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
        --select * from booking_per_revenue_type_per_month_table
    ,sum_booking_per_month_table AS (
        SELECT *
        FROM crosstab('SELECT ''SUM''
                        ,booking_month_year
                        ,SUM(booked_usd_amount)
                    FROM mart.booking_per_revenue_type_per_month
                    WHERE booking_year >= 2016
                        AND booking_year <= 2020
                    GROUP BY booking_month_year
                    ORDER BY 1'
                , --array_position(array['Licence','Subscription','Support','Services','Other'], revenue_type
                'SELECT
                    to_char(month_number, ''fm00'') || '' '' || year_number AS month_year
                FROM generate_series(2016, 2020) AS year_number
                    ,generate_series(1, 12) AS month_number
                ') AS (
                revenue_type TEXT
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
    INSERT INTO mart.booking_by_time_report (
        revenue_type
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
        ,COALESCE("01 2016"         , 0)
        ,COALESCE("02 2016"         , 0)
        ,COALESCE("03 2016"         , 0)
        ,COALESCE("Q1 2016"         , 0)
        ,COALESCE("04 2016"         , 0)
        ,COALESCE("05 2016"         , 0)
        ,COALESCE("06 2016"         , 0)
        ,COALESCE("Q2 2016"         , 0)
        ,COALESCE("07 2016"         , 0)
        ,COALESCE("08 2016"         , 0)
        ,COALESCE("09 2016"         , 0)
        ,COALESCE("Q3 2016"         , 0)
        ,COALESCE("10 2016"         , 0)
        ,COALESCE("11 2016"         , 0)
        ,COALESCE("12 2016"         , 0)
        ,COALESCE("Q4 2016"         , 0)
        ,COALESCE("2016 Total"      , 0)
        ,COALESCE("01 2017"         , 0)
        ,COALESCE("02 2017"         , 0)
        ,COALESCE("03 2017"         , 0)
        ,COALESCE("Q1 2017"         , 0)
        ,COALESCE("04 2017"         , 0)
        ,COALESCE("05 2017"         , 0)
        ,COALESCE("06 2017"         , 0)
        ,COALESCE("Q2 2017"         , 0)
        ,COALESCE("07 2017"         , 0)
        ,COALESCE("08 2017"         , 0)
        ,COALESCE("09 2017"         , 0)
        ,COALESCE("Q3 2017"         , 0)
        ,COALESCE("10 2017"         , 0)
        ,COALESCE("11 2017"         , 0)
        ,COALESCE("12 2017"         , 0)
        ,COALESCE("Q4 2017"         , 0)
        ,COALESCE("2017 Total"      , 0)
        ,COALESCE("01 2018"         , 0)
        ,COALESCE("02 2018"         , 0)
        ,COALESCE("03 2018"         , 0)
        ,COALESCE("Q1 2018"         , 0)
        ,COALESCE("04 2018"         , 0)
        ,COALESCE("05 2018"         , 0)
        ,COALESCE("06 2018"         , 0)
        ,COALESCE("Q2 2018"         , 0)
        ,COALESCE("07 2018"         , 0)
        ,COALESCE("08 2018"         , 0)
        ,COALESCE("09 2018"         , 0)
        ,COALESCE("Q3 2018"         , 0)
        ,COALESCE("10 2018"         , 0)
        ,COALESCE("11 2018"         , 0)
        ,COALESCE("12 2018"         , 0)
        ,COALESCE("Q4 2018"         , 0)
        ,COALESCE("2018 Total"      , 0)
        ,COALESCE("01 2019"         , 0)
        ,COALESCE("02 2019"         , 0)
        ,COALESCE("03 2019"         , 0)
        ,COALESCE("Q1 2019"         , 0)
        ,COALESCE("04 2019"         , 0)
        ,COALESCE("05 2019"         , 0)
        ,COALESCE("06 2019"         , 0)
        ,COALESCE("Q2 2019"         , 0)
        ,COALESCE("07 2019"         , 0)
        ,COALESCE("08 2019"         , 0)
        ,COALESCE("09 2019"         , 0)
        ,COALESCE("Q3 2019"         , 0)
        ,COALESCE("10 2019"         , 0)
        ,COALESCE("11 2019"         , 0)
        ,COALESCE("12 2019"         , 0)
        ,COALESCE("Q4 2019"         , 0)
        ,COALESCE("2019 Total"      , 0)
        ,COALESCE("01 2020"         , 0)
        ,COALESCE("02 2020"         , 0)
        ,COALESCE("03 2020"         , 0)
        ,COALESCE("Q1 2020"         , 0)
        ,COALESCE("04 2020"         , 0)
        ,COALESCE("05 2020"         , 0)
        ,COALESCE("06 2020"         , 0)
        ,COALESCE("Q2 2020"         , 0)
        ,COALESCE("07 2020"         , 0)
        ,COALESCE("08 2020"         , 0)
        ,COALESCE("09 2020"         , 0)
        ,COALESCE("Q3 2020"         , 0)
        ,COALESCE("10 2020"         , 0)
        ,COALESCE("11 2020"         , 0)
        ,COALESCE("12 2020"         , 0)
        ,COALESCE("Q4 2020"         , 0)
        ,COALESCE("2020 Total"      , 0)
    FROM (
        SELECT booking_per_revenue_type_per_quarter_table.revenue_type
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
        FROM booking_per_revenue_type_per_quarter_table
        JOIN booking_per_revenue_type_per_year_table ON booking_per_revenue_type_per_year_table.revenue_type = booking_per_revenue_type_per_quarter_table.revenue_type
        JOIN booking_per_revenue_type_per_month_table ON booking_per_revenue_type_per_month_table.revenue_type = booking_per_revenue_type_per_quarter_table.revenue_type

        UNION ALL

        SELECT sum_booking_per_year_table.revenue_type
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
        FROM sum_booking_per_year_table
        JOIN sum_booking_per_quarter_table ON sum_booking_per_quarter_table.revenue_type = sum_booking_per_year_table.revenue_type
        JOIN sum_booking_per_month_table ON sum_booking_per_month_table.revenue_type = sum_booking_per_quarter_table.revenue_type
        ) AS foo
    ORDER BY array_position(array ['Licence','Subscription','Support','Services','Other', 'Intercompany'], revenue_type);

    RETURN 0;

END;$$

LANGUAGE plpgsql;
