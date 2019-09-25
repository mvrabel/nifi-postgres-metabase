CREATE OR REPLACE FUNCTION mart.tf_r_revenue_per_month_per_sale()
RETURNS INTEGER AS $$

DECLARE

REVENUE_TYPE_INTERCOMPANY TEXT := 'Intercompany';
DATE_ID_FORMAT TEXT := 'YYYYMMDD';

BEGIN

    WITH
    series_base_dates AS (
        SELECT
            series
        FROM generate_series('2012-01-01'::DATE, '2050-12-31'::DATE, '1 months') AS series
        )
    ,formated_series AS (
        SELECT
            series::DATE AS date_series_date
            ,extract('month' FROM series)::INTEGER AS date_series_month
            ,extract('quarter' FROM series)::INTEGER AS date_series_quarter
            ,extract('year' FROM series)::INTEGER AS date_series_year
            ,revenue_type_name AS revenue_type
        FROM series_base_dates
            ,core.c_revenue_type_t
        WHERE revenue_type_name != REVENUE_TYPE_INTERCOMPANY
        )
    ,base_report AS (
        -- revenue_start_day_01 And revenue_end_day_01 simplfy the process of calculating number of months between revenue_start and revenue_end dates.
        -- revenue_start_day_01 And revenue_end_day_01 are dates with the same year and month as their prents but with the day is the first day of the month (1.)
        SELECT
            sale.sale_key
            ,revenue_start_date
            ,revenue_end_date
            ,TO_DATE(SUBSTRING(sale.fk_date_id_revenue_start::TEXT FROM 1 FOR 6) || '01', DATE_ID_FORMAT) AS revenue_start_day_01
            ,TO_DATE(SUBSTRING(sale.fk_date_id_revenue_end::TEXT FROM 1 FOR 6) || '01', DATE_ID_FORMAT) + interval '1 month' AS revenue_end_day_01
            ,generate_series(TO_DATE(SUBSTRING(sale.fk_date_id_revenue_start::TEXT FROM 1 FOR 6) || '01', DATE_ID_FORMAT), TO_DATE(SUBSTRING(sale.fk_date_id_revenue_end::TEXT FROM 1 FOR 6) || '01', DATE_ID_FORMAT), interval '1 month')::DATE AS date_series
            ,CASE 
                WHEN SUBSTRING(sale.fk_date_id_revenue_start::TEXT FROM 7 FOR 2) = '01'
                    AND SUBSTRING(sale.fk_date_id_revenue_end::TEXT FROM 7 FOR 2)::INTEGER = (
                        SELECT extract(day FROM TO_DATE(SUBSTRING(sale.fk_date_id_revenue_end::TEXT FROM 1 FOR 6) || '01', DATE_ID_FORMAT) + '1 month'::interval - '1 day'::interval)
                        )::INTEGER
                    THEN TRUE
                ELSE FALSE
            END AS is_end_date_day_the_last_day_in_month
            ,sale.usd_amount
            ,sale.czk_amount
            ,sale.eur_amount
            ,local_currency.alphabetical_code AS local_currency_code
            ,sale.local_currency_amount
        FROM core.sale_t AS sale
        JOIN core.c_revenue_type_t AS revenue_type ON revenue_type.revenue_type_id = sale.fk_revenue_type_id
        JOIN core.c_currency_g AS local_currency ON local_currency.currency_id = sale.fk_currency_id_local_currency
        WHERE sale.fk_date_id_revenue_end != - 1
            AND revenue_type.revenue_type_name != REVENUE_TYPE_INTERCOMPANY
            AND sale.sale_id != -1
        )
    ,start_and_end_days_info AS (
        SELECT
            base_report.sale_key
            ,base_report.date_series
            ,base_report.usd_amount
            ,base_report.czk_amount
            ,base_report.eur_amount
            ,base_report.local_currency_code
            ,base_report.local_currency_amount
            ,EXTRACT(month FROM age(base_report.revenue_end_day_01, base_report.revenue_start_day_01))::INT + 12 * extract(year FROM age(base_report.revenue_end_day_01, base_report.revenue_start_day_01))::INT AS months
            ,EXTRACT(day FROM (DATE_TRUNC('month', base_report.revenue_start_date) + INTERVAL '1 MONTH') - base_report.revenue_start_date)::INT AS days_until_end_of_month
            ,EXTRACT(day FROM (base_report.revenue_end_date))::INT AS days_from_month_start
            ,base_report.is_end_date_day_the_last_day_in_month
            ,rank() OVER (
                PARTITION BY base_report.sale_key ORDER BY date_series
                ) AS rank
        FROM base_report
        )
    ,revenue_per_sale_per_month AS (
        SELECT
            start_and_end_days_info.sale_key
            ,start_and_end_days_info.date_series AS revenue_date
            ,CASE 
                WHEN start_and_end_days_info.is_end_date_day_the_last_day_in_month
                    THEN start_and_end_days_info.usd_amount / start_and_end_days_info.months
                WHEN rank != 1
                    AND rank != start_and_end_days_info.months
                    THEN usd_amount / (start_and_end_days_info.months - 1)
                WHEN rank = 1                    
                    THEN usd_amount / (start_and_end_days_info.months - 1) * (start_and_end_days_info.days_until_end_of_month / (start_and_end_days_info.days_from_month_start + start_and_end_days_info.days_until_end_of_month)::NUMERIC(10, 2))
                WHEN rank = start_and_end_days_info.months
                    THEN usd_amount / (start_and_end_days_info.months - 1) * (start_and_end_days_info.days_from_month_start / (start_and_end_days_info.days_from_month_start + start_and_end_days_info.days_until_end_of_month)::NUMERIC(10, 2))
            ELSE
                NULL
            END AS usd_revenue_per_month
            ,CASE
                WHEN start_and_end_days_info.is_end_date_day_the_last_day_in_month
                    THEN start_and_end_days_info.czk_amount / start_and_end_days_info.months
                WHEN rank != 1
                    AND rank != start_and_end_days_info.months
                    THEN czk_amount / (start_and_end_days_info.months - 1)
                WHEN rank = 1                    
                    THEN czk_amount / (start_and_end_days_info.months - 1) * (start_and_end_days_info.days_until_end_of_month / (start_and_end_days_info.days_from_month_start + start_and_end_days_info.days_until_end_of_month)::NUMERIC(10, 2))
                WHEN rank = start_and_end_days_info.months
                    THEN czk_amount / (start_and_end_days_info.months - 1) * (start_and_end_days_info.days_from_month_start / (start_and_end_days_info.days_from_month_start + start_and_end_days_info.days_until_end_of_month)::NUMERIC(10, 2))
                ELSE
                    NULL
            END AS czk_revenue_per_month
            ,CASE
                WHEN start_and_end_days_info.is_end_date_day_the_last_day_in_month
                    THEN start_and_end_days_info.eur_amount / start_and_end_days_info.months
                WHEN rank != 1
                    AND rank != start_and_end_days_info.months
                    THEN eur_amount / (start_and_end_days_info.months - 1)
                WHEN rank = 1                    
                    THEN eur_amount / (start_and_end_days_info.months - 1) * (start_and_end_days_info.days_until_end_of_month / (start_and_end_days_info.days_from_month_start + start_and_end_days_info.days_until_end_of_month)::NUMERIC(10, 2))
                WHEN rank = start_and_end_days_info.months
                    THEN eur_amount / (start_and_end_days_info.months - 1) * (start_and_end_days_info.days_from_month_start / (start_and_end_days_info.days_from_month_start + start_and_end_days_info.days_until_end_of_month)::NUMERIC(10, 2))
                ELSE 
                    NULL
            END AS eur_revenue_per_month
            ,CASE
                WHEN start_and_end_days_info.is_end_date_day_the_last_day_in_month
                    THEN start_and_end_days_info.usd_amount / start_and_end_days_info.months
                WHEN rank != 1
                    AND rank != start_and_end_days_info.months
                    THEN start_and_end_days_info.local_currency_amount / (start_and_end_days_info.months - 1)
                WHEN rank = 1
                    THEN start_and_end_days_info.local_currency_amount / (start_and_end_days_info.months - 1) * (start_and_end_days_info.days_until_end_of_month / (start_and_end_days_info.days_from_month_start + start_and_end_days_info.days_until_end_of_month)::NUMERIC(10, 2))
                WHEN rank = start_and_end_days_info.months
                     THEN start_and_end_days_info.local_currency_amount / (start_and_end_days_info.months - 1) * (start_and_end_days_info.days_from_month_start / (start_and_end_days_info.days_from_month_start + start_and_end_days_info.days_until_end_of_month)::NUMERIC(10, 2))           
                ELSE
                    NULL
                END AS local_currency_revenue_per_month
            ,start_and_end_days_info.local_currency_code
        FROM start_and_end_days_info
        )
    ,revenue_base_report AS (
        -- Spport,Substription,etc  sales / sales who's revenue is speard linear from revenue_start to revenue_end dates    
        SELECT
            revenue_per_sale_per_month.sale_key
            ,party_org_customer.full_name AS customer
            ,party_org_reseller.full_name AS reseller
            ,revenue_type.revenue_type_name AS sale_type
            ,party_org_seller.full_name AS seller
            ,org_seller.organization_key AS seller_code
            ,sale.booking_date
            ,revenue_per_sale_per_month.usd_revenue_per_month
            ,revenue_per_sale_per_month.czk_revenue_per_month
            ,revenue_per_sale_per_month.eur_revenue_per_month
            ,revenue_per_sale_per_month.local_currency_revenue_per_month
            ,revenue_per_sale_per_month.local_currency_code
            ,revenue_per_sale_per_month.revenue_date
            ,EXTRACT('month' FROM revenue_per_sale_per_month.revenue_date)::INTEGER AS revenue_month
            ,EXTRACT('quarter' FROM revenue_per_sale_per_month.revenue_date)::INTEGER AS revenue_quarter
            ,EXTRACT('year' FROM revenue_per_sale_per_month.revenue_date)::INTEGER AS revenue_year
            ,sale.sale_comment
            ,sale.invoice
        FROM revenue_per_sale_per_month
        JOIN core.sale_t AS sale ON sale.sale_key = revenue_per_sale_per_month.sale_key
        JOIN core.c_revenue_type_t AS revenue_type ON revenue_type.revenue_type_id = sale.fk_revenue_type_id
        JOIN core.organization_t AS org_customer ON org_customer.organization_id = sale.fk_organization_id_customer
        JOIN core.party_t AS party_org_customer ON party_org_customer.party_id = org_customer.fk_party_id
        JOIN core.party_t AS party_sales_representative ON party_sales_representative.party_id = sale.fk_party_id_sales_representative
        LEFT JOIN core.organization_t AS org_reseller ON org_reseller.organization_id = sale.fk_organization_id_reseller
        LEFT JOIN core.party_t AS party_org_reseller ON party_org_reseller.party_id = org_reseller.fk_party_id
        JOIN core.organization_t AS org_seller ON org_seller.organization_id = sale.fk_organization_id_seller
        JOIN core.party_t AS party_org_seller ON party_org_seller.party_id = org_seller.fk_party_id
        JOIN core.c_currency_g AS local_currency ON local_currency.currency_id = sale.fk_currency_id_local_currency
        
        UNION ALL
        
        -- licence sales / single transaction sales / sales without revenue_end 
        SELECT
            sale.sale_key
            ,party_org_customer.full_name AS customer
            ,party_org_reseller.full_name AS reseller
            ,revenue_type.revenue_type_name AS sale_type
            ,party_org_seller.full_name AS seller
            ,org_seller.organization_key AS seller_code
            ,sale.booking_date
            ,sale.usd_amount
            ,sale.czk_amount
            ,sale.eur_amount
            ,sale.local_currency_amount
            ,local_currency.alphabetical_code AS local_currency_code
            ,sale.revenue_start_date AS revenue_date
            ,EXTRACT('month' FROM sale.revenue_start_date)::INTEGER AS revenue_month
            ,EXTRACT('quarter' FROM sale.revenue_start_date)::INTEGER AS revenue_quarter
            ,EXTRACT('year' FROM sale.revenue_start_date)::INTEGER AS revenue_year
            ,sale.sale_comment
            ,sale.invoice
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
        WHERE sale.fk_date_id_revenue_end = -1
            AND revenue_type.revenue_type_name != REVENUE_TYPE_INTERCOMPANY
            AND sale.sale_id != -1
        )
    INSERT INTO mart.revenue_per_month_per_sale (
        revenue_month_year
        ,revenue_quarter_year
        ,seller
        ,seller_code
        ,trade_key
        ,revenue_type
        ,usd_revenue
        ,czk_revenue
        ,eur_revenue
        ,revenue_month
        ,revenue_quarter
        ,revenue_year
        )
    SELECT
        TO_CHAR(revenue_month, 'fm00') || ' ' || revenue_year AS revenue_month_year
        ,'Q' || revenue_quarter || ' ' || revenue_year AS revenue_quarter_year
        ,seller
        ,seller_code
        ,sale_key
        ,sale_type
        ,usd_revenue_per_month
        ,czk_revenue_per_month
        ,eur_revenue_per_month
        ,revenue_month
        ,revenue_quarter
        ,revenue_year
    FROM revenue_base_report;

    RETURN 0;

END;$$

LANGUAGE plpgsql;
