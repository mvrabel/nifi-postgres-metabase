CREATE OR REPLACE FUNCTION mart.tf_r_revenue_per_customer_by_time()
RETURNS INTEGER AS $$

BEGIN

    INSERT INTO mart.revenue_per_customer_by_time (
        customer
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
        ,"Total Revenue"
    )
    SELECT
        customer
        ,sum("01 2016") AS "01 2016"
        ,sum("02 2016") AS "02 2016"
        ,sum("03 2016") AS "03 2016"
        ,sum("Q1 2016") AS "Q1 2016"
        ,sum("04 2016") AS "04 2016"
        ,sum("05 2016") AS "05 2016"
        ,sum("06 2016") AS "06 2016"
        ,sum("Q2 2016") AS "Q2 2016"
        ,sum("07 2016") AS "07 2016"
        ,sum("08 2016") AS "08 2016"
        ,sum("09 2016") AS "09 2016"
        ,sum("Q3 2016") AS "Q3 2016"
        ,sum("10 2016") AS "10 2016"
        ,sum("11 2016") AS "11 2016"
        ,sum("12 2016") AS "12 2016"
        ,sum("Q4 2016") AS "Q4 2016"
        ,sum("2016 Total") AS "2016 Total"
        ,sum("01 2017") AS "01 2017"
        ,sum("02 2017") AS "02 2017"
        ,sum("03 2017") AS "03 2017"
        ,sum("Q1 2017") AS "Q1 2017"
        ,sum("04 2017") AS "04 2017"
        ,sum("05 2017") AS "05 2017"
        ,sum("06 2017") AS "06 2017"
        ,sum("Q2 2017") AS "Q2 2017"
        ,sum("07 2017") AS "07 2017"
        ,sum("08 2017") AS "08 2017"
        ,sum("Q3 2017") AS "Q3 2017"
        ,sum("09 2017") AS "09 2017"
        ,sum("10 2017") AS "10 2017"
        ,sum("11 2017") AS "11 2017"
        ,sum("12 2017") AS "12 2017"
        ,sum("Q4 2017") AS "Q4 2017"
        ,sum("2017 Total") AS "2017 Total"
        ,sum("01 2018") AS "01 2018"
        ,sum("02 2018") AS "02 2018"
        ,sum("03 2018") AS "03 2018"
        ,sum("Q1 2018") AS "Q1 2018"
        ,sum("04 2018") AS "04 2018"
        ,sum("05 2018") AS "05 2018"
        ,sum("06 2018") AS "06 2018"
        ,sum("Q2 2018") AS "Q2 2018"
        ,sum("07 2018") AS "07 2018"
        ,sum("08 2018") AS "08 2018"
        ,sum("09 2018") AS "09 2018"
        ,sum("Q3 2018") AS "Q3 2018"
        ,sum("10 2018") AS "10 2018"
        ,sum("11 2018") AS "11 2018"
        ,sum("12 2018") AS "12 2018"
        ,sum("Q4 2018") AS "Q4 2018"
        ,sum("2018 Total" ) AS "2018 Total"
        ,sum("01 2019") AS "01 2019"
        ,sum("02 2019") AS "02 2019"
        ,sum("03 2019") AS "03 2019"
        ,sum("Q1 2019") AS "Q1 2019"
        ,sum("04 2019") AS "04 2019"
        ,sum("05 2019") AS "05 2019"
        ,sum("06 2019") AS "06 2019"
        ,sum("Q2 2019") AS "Q2 2019"
        ,sum("07 2019") AS "07 2019"
        ,sum("08 2019") AS "08 2019"
        ,sum("09 2019") AS "09 2019"
        ,sum("Q3 2019") AS "Q3 2019"
        ,sum("10 2019") AS "10 2019"
        ,sum("11 2019") AS "11 2019"
        ,sum("12 2019") AS "12 2019"
        ,sum("Q4 2019") AS "Q4 2019"
        ,sum("2019 Total" ) AS "2019 Total"
        ,sum("01 2020") AS "01 2020"
        ,sum("02 2020") AS "02 2020"
        ,sum("03 2020") AS "03 2020"
        ,sum("Q1 2020") AS "Q1 2020"
        ,sum("04 2020") AS "04 2020"
        ,sum("05 2020") AS "05 2020"
        ,sum("06 2020") AS "06 2020"
        ,sum("Q2 2020") AS "Q2 2020"
        ,sum("07 2020") AS "07 2020"
        ,sum("08 2020") AS "08 2020"
        ,sum("09 2020") AS "09 2020"
        ,sum("Q3 2020") AS "Q3 2020"
        ,sum("10 2020") AS "10 2020"
        ,sum("11 2020") AS "11 2020"
        ,sum("12 2020") AS "12 2020"
        ,sum("Q4 2020") AS "Q4 2020"
        ,sum("2020 Total" ) AS "2020 Total"
        ,SUM(usd_amount) AS "Total Revenue"
    FROM mart.sales_report_extended
    WHERE customer IS NOT NULL
    GROUP BY customer;

    RETURN 0;

END;$$

LANGUAGE plpgsql;
