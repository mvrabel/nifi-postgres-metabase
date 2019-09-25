CREATE OR REPLACE FUNCTION core.tf_i_src_ocean_trg_sale_i()
RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from stage 'ocean_*' tables into core input table sale_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
USD_ALPHABETICAL_CODE TEXT := 'USD';
EUR_ALPHABETICAL_CODE TEXT := 'EUR';
CZK_ALPHABETICAL_CODE TEXT := 'CZK';
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_sale_i;

    CREATE TEMPORARY TABLE tmp_sale_i (
        sale_key                            TEXT NOT NULL
        ,fk_organization_id_customer        INTEGER NOT NULL
        ,fk_organization_id_seller          INTEGER NOT NULL
        ,fk_organization_id_reseller        INTEGER NOT NULL
        ,fk_party_id_sales_representative   INTEGER NOT NULL
        ,fk_revenue_type_id                 INTEGER NOT NULL
        ,fk_date_id_booking_date            INTEGER NOT NULL
        ,booking_date                       DATE NOT NULL
        ,payment_received                   boolean NOT NULL
        ,invoice                            TEXT NOT NULL
        ,usd_amount                         NUMERIC(10, 2) NOT NULL
        ,czk_amount                         NUMERIC(10, 2) NOT NULL
        ,eur_amount                         NUMERIC(10, 2) NOT NULL
        ,local_currency_amount              NUMERIC(10, 2) NOT NULL
        ,fk_currency_id_local_currency      INTEGER NOT NULL
        ,fk_date_id_revenue_start           INTEGER NOT NULL
        ,revenue_start_date                 TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_revenue_end             INTEGER NOT NULL
        ,revenue_end_date                   TIMESTAMP WITH TIME ZONE NOT NULL
        ,sale_comment                       TEXT NOT NULL
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_deleted_in_source_system      BOOL NOT NULL
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
    );

    WITH
    last_known_czk_to_usd_exchange_rate AS (
        SELECT exchange_rate
        FROM core.c_exchange_rate_g
        WHERE fk_currency_id_counter_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = USD_ALPHABETICAL_CODE)
            AND fk_currency_id_base_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = CZK_ALPHABETICAL_CODE)
        ORDER BY fk_date_id DESC
        LIMIT 1
    )
    ,last_known_eur_to_usd_exchange_rate AS (
        SELECT exchange_rate
        FROM core.c_exchange_rate_g
        WHERE fk_currency_id_counter_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = USD_ALPHABETICAL_CODE)
            AND fk_currency_id_base_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = EUR_ALPHABETICAL_CODE)
        ORDER BY fk_date_id DESC
        LIMIT 1
    )
    ,last_known_czk_to_eur_exchange_rate AS (
        SELECT exchange_rate
        FROM core.c_exchange_rate_g
        WHERE fk_currency_id_counter_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = EUR_ALPHABETICAL_CODE)
            AND fk_currency_id_base_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = CZK_ALPHABETICAL_CODE)
        ORDER BY fk_date_id DESC
        LIMIT 1
    )
    ,last_known_usd_to_eur_exchange_rate AS (
        SELECT exchange_rate
        FROM core.c_exchange_rate_g
        WHERE fk_currency_id_counter_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = EUR_ALPHABETICAL_CODE)
            AND fk_currency_id_base_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = USD_ALPHABETICAL_CODE)
        ORDER BY fk_date_id DESC
        LIMIT 1
    )
    ,last_known_eur_to_czk_exchange_rate AS (
        SELECT exchange_rate
        FROM core.c_exchange_rate_g
        WHERE fk_currency_id_counter_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = CZK_ALPHABETICAL_CODE)
            AND fk_currency_id_base_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = EUR_ALPHABETICAL_CODE)
        ORDER BY fk_date_id DESC
        LIMIT 1
    )
    ,last_known_usd_to_czk_exchange_rate AS (
        SELECT exchange_rate
        FROM core.c_exchange_rate_g
        WHERE fk_currency_id_counter_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = CZK_ALPHABETICAL_CODE)
            AND fk_currency_id_base_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = USD_ALPHABETICAL_CODE)
        ORDER BY fk_date_id DESC
        LIMIT 1
    )
    INSERT INTO tmp_sale_i (
        sale_key
        ,fk_revenue_type_id
        ,fk_organization_id_customer
        ,fk_organization_id_seller
        ,fk_organization_id_reseller
        ,fk_party_id_sales_representative
        ,fk_date_id_booking_date
        ,booking_date
        ,usd_amount
        ,czk_amount
        ,eur_amount
        ,fk_currency_id_local_currency
        ,local_currency_amount
        ,invoice
        ,payment_received
        ,sale_comment
        ,fk_date_id_revenue_start
        ,revenue_start_date
        ,fk_date_id_revenue_end
        ,revenue_end_date
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        sale_report.sale_key AS sale_key
        ,input_revenue_type.revenue_type_id AS fk_revenue_type_id
        ,COALESCE(customer_organization.organization_id, -1) AS fk_organization_id_customer
        ,COALESCE(seller_organization.organization_id, -1) AS fk_organization_id_seller
        ,COALESCE(reseller_organization.organization_id, -1) AS fk_organization_id_reseller
        ,COALESCE(sales_representative_party.party_id, -1) AS fk_party_id_sales_representative
        ,(TO_CHAR(TO_DATE(sale_report.booking_date, 'DD.MM.YYYY'), 'YYYYMMDD'))::INTEGER AS fk_date_id_booking_date
        ,TO_DATE(sale_report.booking_date, 'DD.MM.YYYY') AS booking_date
        ,CASE
            WHEN sale_report.currency = USD_ALPHABETICAL_CODE THEN sale_report.amount
            WHEN local_to_usd_exchange_rate.exchange_rate IS NOT NULL THEN sale_report.amount * local_to_usd_exchange_rate.exchange_rate
            -- If we don't have the exchange_rate for a given date we use the last known exchange_rate
            WHEN sale_report.currency = CZK_ALPHABETICAL_CODE THEN sale_report.amount * (SELECT exchange_rate FROM last_known_czk_to_usd_exchange_rate)
            WHEN sale_report.currency = EUR_ALPHABETICAL_CODE THEN sale_report.amount * (SELECT exchange_rate FROM last_known_eur_to_usd_exchange_rate)
            ELSE NULL
        END AS usd_amount
        ,CASE
            WHEN sale_report.currency = CZK_ALPHABETICAL_CODE THEN sale_report.amount
            WHEN local_to_czk_exchange_rate.exchange_rate IS NOT NULL THEN sale_report.amount * local_to_czk_exchange_rate.exchange_rate
            -- If we don't have the exchange_rate for a given date we use the last known exchange_rate
            WHEN sale_report.currency = USD_ALPHABETICAL_CODE THEN sale_report.amount * (SELECT exchange_rate FROM last_known_usd_to_czk_exchange_rate)
            WHEN sale_report.currency = EUR_ALPHABETICAL_CODE THEN sale_report.amount * (SELECT exchange_rate FROM last_known_eur_to_czk_exchange_rate)
        END AS czk_amount
        ,CASE
            WHEN sale_report.currency = EUR_ALPHABETICAL_CODE THEN sale_report.amount
            WHEN local_to_eur_exchange_rate.exchange_rate IS NOT NULL THEN sale_report.amount * local_to_eur_exchange_rate.exchange_rate
            -- If we don't have the exchange_rate for a given date we use the last known exchange_rate
            WHEN sale_report.currency = USD_ALPHABETICAL_CODE THEN sale_report.amount * (SELECT exchange_rate FROM last_known_usd_to_eur_exchange_rate)
            WHEN sale_report.currency = CZK_ALPHABETICAL_CODE THEN sale_report.amount * (SELECT exchange_rate FROM last_known_czk_to_eur_exchange_rate)
        END AS eur_amount
        ,base_currency.currency_id AS fk_currency_id_local_currency
        ,sale_report.amount AS local_currency_amount
        ,tf_u_replace_empty_string_with_null_flag(sale_report.invoice) AS invoice
        ,sale_report.paid::BOOLEAN AS payment_received
        ,tf_u_replace_empty_string_with_null_flag(sale_report.trade_comment) AS sale_comment
        ,TO_CHAR(TO_DATE(sale_report.revenue_start, 'DD.MM.YYYY'), 'YYYYMMDD')::INTEGER AS fk_date_id_revenue_start
        ,TO_DATE(sale_report.revenue_start, 'DD.MM.YYYY') AS revenue_start_date
        ,CASE
            WHEN sale_report.revenue_end <> '' THEN (TO_CHAR(TO_DATE(sale_report.revenue_end, 'DD.MM.YYYY'), 'YYYYMMDD'))::INTEGER
            ELSE - 1
        END AS fk_date_id_revenue_end
        ,CASE
            WHEN sale_report.revenue_end <> '' THEN TO_DATE(sale_report.revenue_end, 'DD.MM.YYYY')
            ELSE NULL_DATE
        END AS revenue_end_date
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE::bool AS tech_deleted_in_source_system
        ,md5 (
            COALESCE(customer_organization.organization_key::TEXT, '')
            || COALESCE(reseller_organization.organization_key::TEXT, '')
            || COALESCE(sale_report.revenue_type::TEXT, '')
            || COALESCE(sale_report.invoice::TEXT, '')
            || COALESCE(sale_report.seller::TEXT, '')
            || COALESCE(sale_report.reseller::TEXT, '')
            || COALESCE(sale_report.sales_rep::TEXT, '')
            || COALESCE(sale_report.paid::TEXT, '')
            || COALESCE(sale_report.booking_date::TEXT, '')
            || COALESCE(sale_report.amount::TEXT, '')
            || COALESCE(sale_report.currency::TEXT, '')
            || COALESCE(sale_report.revenue_start::TEXT, '')
            || COALESCE(sale_report.revenue_end::TEXT, '')
            || COALESCE(sale_report.trade_comment::TEXT, '')
        ) AS tech_row_hash
        ,sale_report.tech_data_load_utc_timestamp
        ,sale_report.tech_data_load_uuid
    FROM stage.ocean_sales_report_i AS sale_report
    JOIN stage.ocean_seller_i AS seller ON seller.seller_code = sale_report.seller
    JOIN stage.ocean_organziation_to_crm_map_i AS customer_org_map ON customer_org_map.organization_name = sale_report.customer
    LEFT JOIN stage.ocean_sales_representative_i AS stage_sales_representative ON stage_sales_representative.sales_rep_code = sale_report.sales_rep
    LEFT JOIN core.party_i AS sales_representative_party ON sales_representative_party.party_key = 'PIPEDRIVE_EMPLOYEE_' || stage_sales_representative.crm_id
    LEFT JOIN stage.ocean_organziation_to_crm_map_i AS reseller_org_map ON reseller_org_map.organization_name = sale_report.reseller
    JOIN core.c_revenue_type_i AS input_revenue_type ON input_revenue_type.revenue_type_name = sale_report.revenue_type
    LEFT JOIN core.organization_i AS customer_organization ON customer_organization.pipedrive_id = customer_org_map.crm_id::TEXT
    LEFT JOIN core.organization_i AS reseller_organization ON reseller_organization.pipedrive_id = reseller_org_map.crm_id::TEXT
    LEFT JOIN core.organization_i AS seller_organization ON seller_organization.pipedrive_id = seller.crm_id::TEXT
    JOIN core.c_currency_g AS base_currency ON base_currency.alphabetical_code = sale_report.currency
    LEFT JOIN core.c_exchange_rate_g AS local_to_usd_exchange_rate ON local_to_usd_exchange_rate.fk_currency_id_base_currency = base_currency.currency_id
        AND (TO_CHAR(TO_DATE(sale_report.booking_date, 'DD.MM.YYYY'), 'YYYYMMDD'))::INTEGER = local_to_usd_exchange_rate.fk_date_id
        AND local_to_usd_exchange_rate.fk_currency_id_counter_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = 'USD')
    LEFT JOIN core.c_exchange_rate_g AS local_to_eur_exchange_rate ON local_to_eur_exchange_rate.fk_currency_id_base_currency = base_currency.currency_id
        AND (TO_CHAR(TO_DATE(sale_report.booking_date, 'DD.MM.YYYY'), 'YYYYMMDD'))::INTEGER = local_to_eur_exchange_rate.fk_date_id
        AND local_to_eur_exchange_rate.fk_currency_id_counter_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = 'EUR')
    LEFT JOIN core.c_exchange_rate_g AS local_to_czk_exchange_rate ON local_to_czk_exchange_rate.fk_currency_id_base_currency = base_currency.currency_id
        AND (TO_CHAR(TO_DATE(sale_report.booking_date, 'DD.MM.YYYY'), 'YYYYMMDD'))::INTEGER = local_to_czk_exchange_rate.fk_date_id
        AND local_to_czk_exchange_rate.fk_currency_id_counter_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = 'CZK')
    LEFT JOIN stage.ocean_sales_representative_i AS sales_representative ON sale_report.sales_rep = sales_representative.sales_rep_code
    WHERE sale_report.error = FALSE
        AND customer_org_map.error = FALSE
        AND (
            reseller_org_map.error IS NULL
            OR reseller_org_map.error = FALSE
            );

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.sale_i (
        sale_key
        ,fk_revenue_type_id
        ,fk_organization_id_customer
        ,fk_organization_id_seller
        ,fk_organization_id_reseller
        ,fk_party_id_sales_representative
        ,fk_date_id_booking_date
        ,booking_date
        ,usd_amount
        ,czk_amount
        ,eur_amount
        ,fk_currency_id_local_currency
        ,local_currency_amount
        ,invoice
        ,payment_received
        ,sale_comment
        ,fk_date_id_revenue_start
        ,revenue_start_date
        ,fk_date_id_revenue_end
        ,revenue_end_date
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        tmp_sale_i.sale_key
        ,tmp_sale_i.fk_revenue_type_id
        ,tmp_sale_i.fk_organization_id_customer
        ,tmp_sale_i.fk_organization_id_seller
        ,tmp_sale_i.fk_organization_id_reseller
        ,tmp_sale_i.fk_party_id_sales_representative
        ,tmp_sale_i.fk_date_id_booking_date
        ,tmp_sale_i.booking_date
        ,tmp_sale_i.usd_amount
        ,tmp_sale_i.czk_amount
        ,tmp_sale_i.eur_amount
        ,tmp_sale_i.fk_currency_id_local_currency
        ,tmp_sale_i.local_currency_amount
        ,tmp_sale_i.invoice
        ,tmp_sale_i.payment_received
        ,tmp_sale_i.sale_comment
        ,tmp_sale_i.fk_date_id_revenue_start
        ,tmp_sale_i.revenue_start_date
        ,tmp_sale_i.fk_date_id_revenue_end
        ,tmp_sale_i.revenue_end_date
        ,tmp_sale_i.tech_insert_function
        ,tmp_sale_i.tech_insert_utc_timestamp
        ,tmp_sale_i.tech_deleted_in_source_system
        ,tmp_sale_i.tech_row_hash
        ,tmp_sale_i.tech_data_load_utc_timestamp
        ,tmp_sale_i.tech_data_load_uuid
    FROM tmp_sale_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
