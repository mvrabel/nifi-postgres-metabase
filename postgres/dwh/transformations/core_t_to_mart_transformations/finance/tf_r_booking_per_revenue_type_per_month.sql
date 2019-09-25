CREATE OR REPLACE FUNCTION mart.tf_r_booking_per_revenue_type_per_month()
RETURNS INTEGER AS $$

BEGIN

    WITH
    series_base_dates AS (
        SELECT *
        FROM generate_series('2012-01-01'::DATE, '2020-12-31'::DATE, '1 months') AS series
        )
    ,formated_series AS (
        SELECT series::DATE AS date_series_date
            ,extract('month' FROM series)::INTEGER AS date_series_month
            ,extract('quarter' FROM series)::INTEGER AS date_series_quarter
            ,extract('year' FROM series)::INTEGER AS date_series_year
            ,revenue_type_name
        FROM series_base_dates
            ,core.c_revenue_type_t
        WHERE revenue_type_name != 'Intercompany'
        )
    ,booking_base_report AS (
        SELECT
            sale.sale_key
            ,party_org_customer.full_name AS customer
            ,party_org_reseller.full_name AS reseller
            ,revenue_type.revenue_type_name
            ,party_org_seller.full_name AS seller
            ,sale.booking_date
            ,sale.usd_amount
            ,sale.local_currency_amount
            ,local_currency.alphabetical_code AS local_currency_code
            ,extract('month' FROM booking_date)::INTEGER AS booking_month
            ,extract('quarter' FROM booking_date)::INTEGER AS booking_quarter
            ,extract('year' FROM booking_date)::INTEGER AS booking_year
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
        WHERE revenue_type.revenue_type_name != 'Intercompany'
        )
    ,booking_report_including_0_booking_months AS (
        SELECT sale_key
            ,customer
            ,reseller
            ,formated_series.revenue_type_name AS revenue_type
            ,seller
            ,formated_series.date_series_date
            ,CASE WHEN usd_amount IS NULL THEN 0 ELSE usd_amount END AS booked_usd_amount
            ,CASE WHEN local_currency_amount IS NULL THEN 0 ELSE local_currency_amount END AS booked_local_currency_amount
            ,local_currency_code
            ,formated_series.date_series_date AS booking_date
            ,formated_series.date_series_month AS booking_month
            ,formated_series.date_series_quarter AS booking_quarter
            ,formated_series.date_series_year AS booking_year
            ,sale_comment
            ,invoice
        FROM formated_series
        LEFT JOIN booking_base_report ON booking_base_report.booking_month = formated_series.date_series_month
            AND booking_base_report.booking_quarter = formated_series.date_series_quarter
            AND booking_base_report.booking_year = formated_series.date_series_year
            AND booking_base_report.revenue_type_name = formated_series.revenue_type_name
        ORDER BY formated_series.date_series_year
            ,formated_series.date_series_quarter
            ,formated_series.date_series_month
        )
    ,booking_per_revenue_type_per_month AS (
        SELECT revenue_type
            ,to_char(booking_month, 'fm00') || ' ' || booking_year AS booking_month_year
            ,booking_month
            ,booking_quarter
            ,booking_year
            ,sum(booked_usd_amount) AS booked_usd_amount
        FROM booking_report_including_0_booking_months
        GROUP BY revenue_type
            ,booking_month
            ,booking_quarter
            ,booking_year
        )
    INSERT INTO mart.booking_per_revenue_type_per_month (
        booking_month_year
        ,revenue_type
        ,booked_usd_amount
        ,booking_month
        ,booking_quarter
        ,booking_year
        )
    SELECT booking_month_year
        ,revenue_type
        ,booked_usd_amount
        ,booking_month
        ,booking_quarter
        ,booking_year
    FROM booking_per_revenue_type_per_month;

    RETURN 0;

END;$$

LANGUAGE plpgsql;
