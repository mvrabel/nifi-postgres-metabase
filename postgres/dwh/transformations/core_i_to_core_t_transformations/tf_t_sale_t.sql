CREATE OR REPLACE FUNCTION core.tf_t_sale_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core sale_i input table into core 'today' table sale_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-15 (YYYY-MM-DD)
    NOTE:
    =================================================================================================================================
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

    ----------------------------------------------------
    -- INSERT RECORDS FROM INPUT TABLE TO TODAY TABLE --
    ----------------------------------------------------

    INSERT INTO core.sale_t (
        sale_id
        ,sale_key
        ,fk_organization_id_customer
        ,fk_organization_id_reseller
        ,fk_organization_id_seller
        ,fk_party_id_sales_representative
        ,fk_revenue_type_id
        ,fk_date_id_booking_date
        ,booking_date
        ,usd_amount
        ,czk_amount
        ,eur_amount
        ,local_currency_amount
        ,fk_currency_id_local_currency
        ,sale_comment
        ,payment_received
        ,invoice
        ,fk_date_id_revenue_start
        ,revenue_start_date
        ,fk_date_id_revenue_end
        ,revenue_end_date
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_sale.sale_id
        ,input_sale.sale_key
        ,organization_customer.organization_id AS fk_organization_id_customer
        ,organization_reseller.organization_id AS fk_organization_id_reseller
        ,organization_seller.organization_id AS fk_organization_id_seller
        ,input_sale.fk_party_id_sales_representative
        ,input_sale.fk_revenue_type_id
        ,input_sale.fk_date_id_booking_date
        ,input_sale.booking_date
        ,input_sale.usd_amount
        ,input_sale.czk_amount
        ,input_sale.eur_amount
        ,input_sale.local_currency_amount
        ,input_sale.fk_currency_id_local_currency
        ,input_sale.sale_comment
        ,input_sale.payment_received
        ,input_sale.invoice
        ,input_sale.fk_date_id_revenue_start
        ,input_sale.revenue_start_date
        ,input_sale.fk_date_id_revenue_end
        ,input_sale.revenue_end_date
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_sale.tech_row_hash
        ,input_sale.tech_data_load_utc_timestamp
        ,input_sale.tech_data_load_uuid
    FROM core.sale_i AS input_sale
    LEFT JOIN core.organization_i AS organization_customer ON organization_customer.organization_id = input_sale.fk_organization_id_customer
        AND organization_customer.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.organization_i AS organization_seller ON organization_seller.organization_id = input_sale.fk_organization_id_seller
        AND organization_seller.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.organization_i AS organization_reseller ON organization_reseller.organization_id = input_sale.fk_organization_id_reseller
        AND organization_reseller.tech_deleted_in_source_system IS FALSE
    WHERE input_sale.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql

