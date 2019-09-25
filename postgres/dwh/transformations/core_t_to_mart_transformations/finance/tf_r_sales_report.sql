CREATE OR REPLACE FUNCTION mart.tf_r_sales_report()
RETURNS INTEGER AS $$

DECLARE

DATE_NEVER DATE := (SELECT date_never FROM core.c_null_replacement_g);

BEGIN

    INSERT INTO mart.sales_report (
        sale_key
        ,customer
        ,reseller
        ,sale_type
        ,seller
        ,usd_amount
        ,local_currency_amount
        ,local_currency_code
        ,booking_date
        ,revenue_start
        ,revenue_end
        ,sale_comment
        ,invoice
        ,paid
        ,sales_representative
        )
    SELECT
        sale.sale_key
        ,party_org_customer.full_name AS customer
        ,party_org_reseller.full_name AS reseller
        ,revenue_type.revenue_type_name AS sale_type
        ,party_org_seller.full_name AS seller
        ,sale.usd_amount
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
    WHERE sale.sale_id != -1;

    RETURN 0;
    
END;$$

LANGUAGE plpgsql
