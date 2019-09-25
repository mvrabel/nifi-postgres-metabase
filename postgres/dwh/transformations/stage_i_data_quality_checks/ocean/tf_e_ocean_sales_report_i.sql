CREATE OR REPLACE FUNCTION stage.tf_e_ocean_sales_report_i()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$


    /*
    ===========================================================================================================
    DESCRIPTION:        Marks rows which have invalid data in stage input table sales_report_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-15 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */
    DECLARE

    CURRENCY_ERROR_MESSAGE TEXT := 'Incorrect currency';
    REVENUE_TYPE_ERROR_MESSAGE TEXT := 'Incorrect revenue type';
    SELLER_ERROR_MESSAGE TEXT := 'Incorrect seller';
    SALES_REPRESENTATIVE_ERROR_MESSAGE TEXT := 'Incorrect sales representative';
    REVENUE_START_ERROR_MESSAGE TEXT := 'Revenue End before Revenue Start';
    PAID_ERROR_MESSAGE TEXT := 'Incorrect paid';
    NULL_CHECK_ERROR_MESSAGE TEXT := 'Null values in one of these columns: customer, seller, revenue_type, booking_date, currency, amount, revenue_start';

    BEGIN

        -- Unique sale_key
        UPDATE stage.ocean_sales_report_i
        SET error = TRUE
        WHERE sale_key IN (
                SELECT sales_report.sale_key
                FROM stage.ocean_sales_report_i AS sales_report
                GROUP BY sales_report.sale_key
                HAVING count(sales_report.sale_key) > 1
                );

        -- currency check
        UPDATE stage.ocean_sales_report_i
        SET error = True, error_description = COALESCE(error_description || ' | ' || CURRENCY_ERROR_MESSAGE, CURRENCY_ERROR_MESSAGE)
        WHERE currency NOT IN (SELECT currency FROM stage.ocean_currency_i);

        -- revenue type check
        UPDATE stage.ocean_sales_report_i
        SET error = True, error_description = COALESCE(error_description || ' | ' || REVENUE_TYPE_ERROR_MESSAGE, REVENUE_TYPE_ERROR_MESSAGE)
        WHERE revenue_type NOT IN (SELECT revenue_type FROM stage.ocean_revenue_type_i);

        -- seller check
        UPDATE stage.ocean_sales_report_i
        SET error = True, error_description = COALESCE(error_description || ' | ' || SELLER_ERROR_MESSAGE, SELLER_ERROR_MESSAGE)
        WHERE seller NOT IN (SELECT seller FROM stage.ocean_seller_i);

        -- sales representative check
        UPDATE stage.ocean_sales_report_i
        SET error = True, error_description = COALESCE(error_description || ' | ' || SALES_REPRESENTATIVE_ERROR_MESSAGE, SALES_REPRESENTATIVE_ERROR_MESSAGE)
        WHERE sales_rep NOT IN (SELECT sales_rep_code FROM stage.ocean_sales_representative_i) AND sales_rep <> '';

        -- revenue_start is before revenue_end check
        UPDATE stage.ocean_sales_report_i
        SET error = TRUE, error_description = COALESCE(error_description || ' | ' || REVENUE_START_ERROR_MESSAGE, REVENUE_START_ERROR_MESSAGE)
        WHERE revenue_end <> ''
            AND revenue_start <> ''
            AND to_date(revenue_start,'dd.mm.yyyy') > to_date(revenue_end,'dd.mm.yyyy');

        -- paid check
        UPDATE stage.ocean_sales_report_i
        SET error = True, error_description = COALESCE(error_description || ' | ' || PAID_ERROR_MESSAGE, PAID_ERROR_MESSAGE)
        WHERE paid NOT IN (SELECT payment_received FROM stage.ocean_payment_received_i);

        -- NULL or empty string check
        UPDATE stage.ocean_sales_report_i
        SET error = TRUE, error_description = COALESCE(error_description || ' | ' || NULL_CHECK_ERROR_MESSAGE, NULL_CHECK_ERROR_MESSAGE)
        WHERE (customer <> '') IS NOT TRUE
            OR (seller <> '') IS NOT TRUE
            OR (revenue_type <> '') IS NOT TRUE
            OR (booking_date <> '') IS NOT TRUE
            OR (currency <> '') IS NOT TRUE
            OR (amount <> 0) IS NOT TRUE
            OR (revenue_start <> '')IS NOT TRUE ;

        RETURN 0;

    END;$function$
