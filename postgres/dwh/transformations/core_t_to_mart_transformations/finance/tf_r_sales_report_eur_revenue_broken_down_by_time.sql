CREATE OR REPLACE FUNCTION mart.tf_r_sales_report_eur_revenue_broken_down_by_time()
RETURNS INTEGER AS $$

DECLARE

DATE_NEVER DATE := (SELECT date_never FROM core.c_null_replacement_g);

BEGIN

    WITH
    base_report AS (
        SELECT
            sale.sale_key
            ,party_org_customer.full_name AS customer
            ,party_org_reseller.full_name AS reseller
            ,revenue_type.revenue_type_name AS sale_type
            ,party_org_seller.full_name AS seller
            ,sale.eur_amount
            ,sale.local_currency_amount
            ,local_currency.alphabetical_code AS local_currency_code
            ,CASE WHEN sale.booking_date = DATE_NEVER THEN NULL ELSE sale.booking_date END AS booking_date
            ,CASE WHEN sale.revenue_start_date = DATE_NEVER THEN NULL ELSE sale.revenue_start_date END AS revenue_start
            ,CASE WHEN sale.revenue_end_date = DATE_NEVER THEN NULL ELSE sale.revenue_end_date END AS revenue_end
            ,sale.sale_comment
            ,sale.invoice
            ,CASE
                WHEN sale.payment_received = TRUE THEN 'YES'
                WHEN sale.payment_received = FALSE THEN 'NO'
            END AS paid
            ,party_sales_representative.full_name AS sales_representative
        FROM core.sale_t AS sale
        JOIN core.c_revenue_type_t AS revenue_type ON revenue_type.revenue_type_id = sale.fk_revenue_type_id
        JOIN core.organization_t AS org_customer ON org_customer.organization_id = sale.fk_organization_id_customer
        JOIN core.party_t AS party_org_customer ON party_org_customer.party_id = org_customer.fk_party_id
        JOIN core.party_t AS party_sales_representative ON party_sales_representative.party_id = sale.fk_party_id_sales_representative
        LEFT JOIN core.organization_t AS org_reseller ON org_reseller.organization_id = sale.fk_organization_id_reseller
        LEFT JOIN core.party_t AS party_org_reseller ON party_org_reseller.party_id = org_reseller.fk_party_id
        JOIN core.organization_t AS org_seller ON org_seller.organization_id = sale.fk_organization_id_seller
        JOIN core.party_t AS party_org_seller ON party_org_seller.party_id = org_seller.fk_party_id
        JOIN core.c_currency_g AS local_currency ON local_currency.currency_id = sale.fk_currency_id_local_currency
        WHERE sale.sale_id != -1
    )
    ,revenue_per_trade_key_per_year_table AS (
        SELECT *
        FROM crosstab('SELECT
                            trade_key
                            ,revenue_year
                            ,SUM(eur_revenue) AS usd_revenue
                        FROM mart.revenue_per_month_per_sale
                        WHERE revenue_year >= 2016
                            AND revenue_year <= 2020
                        GROUP BY revenue_year
                            ,trade_key
                        ORDER BY 1'::TEXT
                ,'SELECT 
                    year_series 
                FROM generate_series(2016, 2020) AS year_series'::TEXT) AS (
                trade_key TEXT
                ,"2016 Total" NUMERIC(10, 2)
                ,"2017 Total" NUMERIC(10, 2)
                ,"2018 Total" NUMERIC(10, 2)
                ,"2019 Total" NUMERIC(10, 2)
                ,"2020 Total" NUMERIC(10, 2)
                )
        )
    ,sum_revenue_per_year_table AS (
        SELECT *
        FROM crosstab('SELECT 
                            ''SUM''
                            ,revenue_year
                            ,SUM(eur_revenue) AS usd_revenue
                        FROM mart.revenue_per_month_per_sale
                        WHERE revenue_year >= 2016
                            AND revenue_year <= 2020
                        GROUP BY revenue_year
                        ORDER BY 1'::TEXT
                        , 'SELECT 
                            year_series
                        FROM generate_series(2016, 2020) AS year_series'::TEXT) AS (
                trade_key TEXT
                ,"2016 Total" NUMERIC(10, 2)
                ,"2017 Total" NUMERIC(10, 2)
                ,"2018 Total" NUMERIC(10, 2)
                ,"2019 Total" NUMERIC(10, 2)
                ,"2020 Total" NUMERIC(10, 2)
                )
        )
    ,revenue_per_trade_key_per_quarter_table AS (
        SELECT *
        FROM crosstab('SELECT 
                            trade_key
                            ,revenue_quarter_year
                            ,SUM(eur_revenue) AS usd_revenue
                        FROM mart.revenue_per_month_per_sale
                        WHERE revenue_year >= 2016
                            AND revenue_year <= 2020
                        GROUP BY revenue_quarter_year
                            ,trade_key
                        ORDER BY 1'::TEXT
                        ,'SELECT 
                            ''Q'' || quartal_series || '' '' || year_series
                        FROM generate_series(2016, 2020) year_series
                            ,generate_series(1, 4) quartal_series'::TEXT) AS (
                trade_key TEXT
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
    ,sum_revenue_per_quarter_table AS (
        SELECT *
        FROM crosstab('SELECT ''SUM''
                            ,revenue_quarter_year
                            ,SUM(eur_revenue) AS usd_revenue
                        FROM mart.revenue_per_month_per_sale
                        WHERE revenue_year >= 2016
                            AND revenue_year <= 2020
                        GROUP BY revenue_quarter_year
                        ORDER BY 1'::TEXT
                        ,'SELECT 
                            ''Q'' || quartal_series || '' '' || year_series
                        FROM generate_series(2016, 2020) year_series
                            ,generate_series(1, 4) quartal_series'::TEXT) AS (
                trade_key TEXT
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
    ,revenue_per_trade_key_per_month_table AS (
        SELECT *
        FROM crosstab('SELECT 
                            trade_key
                            ,revenue_month_year
                            ,SUM(eur_revenue) AS usd_revenue
                        FROM mart.revenue_per_month_per_sale
                        WHERE revenue_year >= 2016
                            AND revenue_year <= 2020
                        GROUP BY revenue_month_year
                            ,trade_key
                        ORDER BY 1'::TEXT
                        ,'SELECT 
                            to_char(month_series, ''fm00'') || '' '' || year_series
                        FROM generate_series(2016, 2020) AS year_series
                            ,generate_series(1, 12) AS month_series'::TEXT) AS (
                trade_key TEXT
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
    ,sum_revenue_per_month_table AS (
        SELECT *
        FROM crosstab('SELECT ''SUM''
                            ,revenue_month_year
                            ,SUM(eur_revenue) AS usd_revenue
                        FROM mart.revenue_per_month_per_sale
                        WHERE revenue_year >= 2016
                            AND revenue_year <= 2020
                        GROUP BY revenue_month_year
                        ORDER BY 1'::TEXT
                        ,'SELECT 
                            to_char(month_series, ''fm00'') || '' '' || year_series
                        FROM generate_series(2016, 2020) AS year_series
                            ,generate_series(1, 12) AS month_series'::TEXT) AS (
                trade_key TEXT
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
    INSERT INTO mart.sales_report_eur_revenue_broken_down_by_time (
        sale_key
        ,customer
        ,reseller
        ,sale_type
        ,seller
        ,sales_representative
        ,booking_date
        ,revenue_start
        ,revenue_end
        ,paid
        ,eur_amount
        ,sale_comment
        ,invoice
        ,local_currency_amount
        ,local_currency_code
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
        trade_key
        ,base_report.customer
        ,base_report.reseller
        ,base_report.sale_type
        ,base_report.seller
        ,base_report.sales_representative
        ,base_report.booking_date
        ,base_report.revenue_start
        ,base_report.revenue_end
        ,base_report.paid
        ,base_report.eur_amount
        ,base_report.sale_comment
        ,base_report.invoice
        ,base_report.local_currency_amount
        ,base_report.local_currency_code
        ,COALESCE("01 2016"			, 0)
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
        SELECT revenue_per_trade_key_per_month_table.trade_key
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
        FROM revenue_per_trade_key_per_month_table
        JOIN revenue_per_trade_key_per_quarter_table ON revenue_per_trade_key_per_quarter_table.trade_key = revenue_per_trade_key_per_month_table.trade_key
        JOIN revenue_per_trade_key_per_year_table ON revenue_per_trade_key_per_year_table.trade_key = revenue_per_trade_key_per_month_table.trade_key
        
        UNION ALL
        
        SELECT sum_revenue_per_month_table.trade_key
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
        FROM sum_revenue_per_month_table
        JOIN sum_revenue_per_quarter_table ON sum_revenue_per_quarter_table.trade_key = sum_revenue_per_month_table.trade_key
        JOIN sum_revenue_per_year_table ON sum_revenue_per_month_table.trade_key = sum_revenue_per_month_table.trade_key
        ) AS foo
    LEFT JOIN base_report ON base_report.sale_key = foo.trade_key;

    RETURN 0;

END;$$

LANGUAGE plpgsql
