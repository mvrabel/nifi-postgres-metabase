CREATE OR REPLACE FUNCTION core.tf_i_src_cnb_trg_c_exchange_rate_g()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from stage 'cnb_*' tables into core code list table c_exchange_rate_g
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:               Data from CNB (Czech National Bank) has no values for weekends and hodildays.
                        This transformation adds those values, *!* it copies the last non null value *!* .

                        Example:

                        Input *After* LEFT JOIN with 'date' table:
                        Counter_currency    Base_currency   Exchange_rate   Date
                        CZK                 USD             NULL            20 100 105
                        CZK                 USD             18,35           20 100 106
                        CZK                 USD             18,44           20 100 107
                        CZK                 USD             NULL            20 100 108
                        CZK                 USD             NULL            20 100 109
                        CZK                 USD             NULL            20 100 110
                        CZK                 USD             18,03           20 100 111

                        Input *After* Transformation:
                        Counter_currency    Base_currency   Exchange_rate   Date
                        CZK                 USD             NULL            20 100 105
                        CZK                 USD             18,35           20 100 106
                        CZK                 USD             18,44           20 100 107
                        CZK                 USD             18,44           20 100 108
                        CZK                 USD             18,44           20 100 109
                        CZK                 USD             18,44           20 100 110
                        CZK                 USD             18,03           20 100 111

    =============================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
first_exchange_rate_date integer := 20100101; --date as integer in format YYYYMMDD
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

    DROP TABLE IF EXISTS tmp_c_exchange_rate_g;

    CREATE TEMPORARY TABLE tmp_c_exchange_rate_g (
        fk_currency_id_counter_currency     INTEGER NOT NULL
        ,fk_currency_id_base_currency       INTEGER NOT NULL
        ,exchange_rate                      DOUBLE PRECISION NOT NULL
        ,fk_date_id                         INTEGER NOT NULL
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
    );

    WITH
        --Get the latest date that was in the the API response from ČNB.
        latest_exchange_rate_date AS (
            SELECT
                (TO_CHAR(TO_DATE(cnb_exchange_rate.datum, 'DD.MM.YYYY'), 'YYYYMMDD'::TEXT))::INTEGER AS date_as_integer
            FROM stage.cnb_exchange_rate_counter_currency_czk_i AS cnb_exchange_rate
            ORDER BY (TO_CHAR(TO_DATE(cnb_exchange_rate.datum, 'DD.MM.YYYY'), 'YYYYMMDD'::TEXT))::INTEGER DESC LIMIT 1
            )
        ,usd_to_czk_missing_holidays AS (
            SELECT
                czk_currency.currency_id AS fk_currency_id_counter_currency
                ,usd_currency.currency_id AS fk_currency_id_base_currency
                ,REPLACE(cnb_exchange_rate.usd_1, ',', '.')::DOUBLE PRECISION AS exchange_rate
                ,(TO_CHAR(TO_DATE(cnb_exchange_rate.datum, 'DD.MM.YYYY'), 'YYYYMMDD'::TEXT))::INTEGER AS fk_date_id
                ,cnb_exchange_rate.tech_data_load_utc_timestamp
                ,cnb_exchange_rate.tech_data_load_uuid
            FROM stage.cnb_exchange_rate_counter_currency_czk_i AS cnb_exchange_rate
            JOIN core.c_currency_g AS czk_currency ON czk_currency.alphabetical_code = 'CZK'
            JOIN core.c_currency_g AS usd_currency ON usd_currency.alphabetical_code = 'USD'
            )
        ,usd_to_eur_missing_holidays AS (
            SELECT
                eur_currency.currency_id AS fk_currency_id_counter_currency
                ,usd_currency.currency_id AS fk_currency_id_base_currency
                ,REPLACE(cnb_exchange_rate.usd_1, ',', '.')::DOUBLE PRECISION / REPLACE(eur_1, ',', '.')::DOUBLE PRECISION AS exchange_rate
                ,(TO_CHAR(TO_DATE(cnb_exchange_rate.datum, 'DD.MM.YYYY'), 'YYYYMMDD'::TEXT))::INTEGER AS fk_date_id
                ,cnb_exchange_rate.tech_data_load_utc_timestamp
                ,cnb_exchange_rate.tech_data_load_uuid
            FROM stage.cnb_exchange_rate_counter_currency_czk_i AS cnb_exchange_rate
            JOIN core.c_currency_g AS eur_currency ON eur_currency.alphabetical_code = 'EUR'
            JOIN core.c_currency_g AS usd_currency ON usd_currency.alphabetical_code = 'USD'
        )
        ,czk_to_usd_missing_holidays AS (
            SELECT
                usd_currency.currency_id AS fk_currency_id_counter_currency
                ,czk_currency.currency_id AS fk_currency_id_base_currency
                ,1 /(REPLACE(cnb_exchange_rate.usd_1, ',', '.')::DOUBLE PRECISION) AS exchange_rate
                ,(TO_CHAR(TO_DATE(cnb_exchange_rate.datum, 'DD.MM.YYYY'), 'YYYYMMDD'::TEXT))::INTEGER AS fk_date_id
                ,cnb_exchange_rate.tech_data_load_utc_timestamp
                ,cnb_exchange_rate.tech_data_load_uuid
            FROM stage.cnb_exchange_rate_counter_currency_czk_i AS cnb_exchange_rate
            JOIN core.c_currency_g AS czk_currency ON czk_currency.alphabetical_code = 'CZK'
            JOIN core.c_currency_g AS usd_currency ON usd_currency.alphabetical_code = 'USD'
        )
        ,czk_to_eur_missing_holidays AS (
            SELECT
                eur_currency.currency_id AS fk_currency_id_counter_currency
                ,czk_currency.currency_id AS fk_currency_id_base_currency
                ,1 /(REPLACE(cnb_exchange_rate.eur_1, ',', '.')::DOUBLE PRECISION) AS exchange_rate
                ,(TO_CHAR(TO_DATE(cnb_exchange_rate.datum, 'DD.MM.YYYY'), 'YYYYMMDD'::TEXT))::INTEGER AS fk_date_id
                ,cnb_exchange_rate.tech_data_load_utc_timestamp
                ,cnb_exchange_rate.tech_data_load_uuid
            FROM stage.cnb_exchange_rate_counter_currency_czk_i AS cnb_exchange_rate
            JOIN core.c_currency_g AS czk_currency ON czk_currency.alphabetical_code = 'CZK'
            JOIN core.c_currency_g AS eur_currency ON eur_currency.alphabetical_code = 'EUR'
        )
        ,eur_to_usd_missing_holidays AS (
            SELECT
                usd_currency.currency_id AS fk_currency_id_counter_currency
                ,eur_currency.currency_id AS fk_currency_id_base_currency
                ,REPLACE(cnb_exchange_rate.eur_1, ',', '.')::DOUBLE PRECISION / REPLACE(usd_1, ',', '.')::DOUBLE PRECISION AS exchange_rate
                ,(TO_CHAR(TO_DATE(cnb_exchange_rate.datum, 'DD.MM.YYYY'), 'YYYYMMDD'::TEXT))::INTEGER AS fk_date_id
                ,cnb_exchange_rate.tech_data_load_utc_timestamp
                ,cnb_exchange_rate.tech_data_load_uuid
            FROM stage.cnb_exchange_rate_counter_currency_czk_i AS cnb_exchange_rate
            JOIN core.c_currency_g AS eur_currency ON eur_currency.alphabetical_code = 'EUR'
            JOIN core.c_currency_g AS usd_currency ON usd_currency.alphabetical_code = 'USD'
        )
        ,eur_to_czk_missing_holidays AS (
            SELECT
                czk_currency.currency_id AS fk_currency_id_counter_currency
                ,eur_currency.currency_id AS fk_currency_id_base_currency
                ,REPLACE(cnb_exchange_rate.eur_1, ',', '.')::DOUBLE PRECISION AS exchange_rate
                ,(TO_CHAR(TO_DATE(cnb_exchange_rate.datum, 'DD.MM.YYYY'), 'YYYYMMDD'::TEXT))::INTEGER AS fk_date_id
                ,cnb_exchange_rate.tech_data_load_utc_timestamp
                ,cnb_exchange_rate.tech_data_load_uuid
            FROM stage.cnb_exchange_rate_counter_currency_czk_i AS cnb_exchange_rate
            JOIN core.c_currency_g AS czk_currency ON czk_currency.alphabetical_code = 'CZK'
            JOIN core.c_currency_g AS eur_currency ON eur_currency.alphabetical_code = 'EUR'
        )
        ,usd_to_czk_added_missing_dates_without_exchange_rates AS (
            SELECT
                c_date.date_id
                ,usd_to_czk_missing_holidays.exchange_rate
               ,SUM(CASE WHEN fk_date_id IS NOT NULL THEN 1 ELSE 0 END) OVER (
                    ORDER BY date_id ASC
                    ) AS by_date_partition
                ,usd_to_czk_missing_holidays.tech_data_load_utc_timestamp
                ,usd_to_czk_missing_holidays.tech_data_load_uuid
                ,usd_to_czk_missing_holidays.fk_currency_id_counter_currency
                ,usd_to_czk_missing_holidays.fk_currency_id_base_currency
            FROM core.c_date_g AS c_date
            LEFT JOIN usd_to_czk_missing_holidays ON usd_to_czk_missing_holidays.fk_date_id = c_date.date_id
            WHERE c_date.date_id > 20100101
                AND c_date.date_id <= (
                    SELECT date_as_integer
                    FROM latest_exchange_rate_date
                    )
        )
        ,usd_to_eur_added_missing_dates_without_exchange_rates AS (
            SELECT
                c_date.date_id
                ,usd_to_eur_missing_holidays.exchange_rate
               ,SUM(CASE WHEN fk_date_id IS NOT NULL THEN 1 ELSE 0 END) OVER (
                    ORDER BY date_id ASC
                    ) AS by_date_partition
                ,usd_to_eur_missing_holidays.tech_data_load_utc_timestamp
                ,usd_to_eur_missing_holidays.tech_data_load_uuid
                ,usd_to_eur_missing_holidays.fk_currency_id_counter_currency
                ,usd_to_eur_missing_holidays.fk_currency_id_base_currency
            FROM core.c_date_g AS c_date
            LEFT JOIN usd_to_eur_missing_holidays ON usd_to_eur_missing_holidays.fk_date_id = c_date.date_id
            WHERE c_date.date_id > 20100101
                AND c_date.date_id <= (
                    SELECT date_as_integer
                    FROM latest_exchange_rate_date
                    )
        )
        ,czk_to_usd_added_missing_dates_without_exchange_rates AS (
            SELECT
                c_date.date_id
                ,czk_to_usd_missing_holidays.exchange_rate
               ,SUM(CASE WHEN fk_date_id IS NOT NULL THEN 1 ELSE 0 END) OVER (
                    ORDER BY date_id ASC
                    ) AS by_date_partition
                ,czk_to_usd_missing_holidays.tech_data_load_utc_timestamp
                ,czk_to_usd_missing_holidays.tech_data_load_uuid
                ,czk_to_usd_missing_holidays.fk_currency_id_counter_currency
                ,czk_to_usd_missing_holidays.fk_currency_id_base_currency
            FROM core.c_date_g AS c_date
            LEFT JOIN czk_to_usd_missing_holidays ON czk_to_usd_missing_holidays.fk_date_id = c_date.date_id
            WHERE c_date.date_id > 20100101
                AND c_date.date_id <= (
                    SELECT date_as_integer
                    FROM latest_exchange_rate_date
                    )
        )
        ,czk_to_eur_added_missing_dates_without_exchange_rates AS (
            SELECT
                c_date.date_id
                ,czk_to_eur_missing_holidays.exchange_rate
               ,SUM(CASE WHEN fk_date_id IS NOT NULL THEN 1 ELSE 0 END) OVER (
                    ORDER BY date_id ASC
                    ) AS by_date_partition
                ,czk_to_eur_missing_holidays.tech_data_load_utc_timestamp
                ,czk_to_eur_missing_holidays.tech_data_load_uuid
                ,czk_to_eur_missing_holidays.fk_currency_id_counter_currency
                ,czk_to_eur_missing_holidays.fk_currency_id_base_currency
            FROM core.c_date_g AS c_date
            LEFT JOIN czk_to_eur_missing_holidays ON czk_to_eur_missing_holidays.fk_date_id = c_date.date_id
            WHERE c_date.date_id > 20100101
                AND c_date.date_id <= (
                    SELECT date_as_integer
                    FROM latest_exchange_rate_date
                    )
        )
        ,eur_to_usd_added_missing_dates_without_exchange_rates AS (
            SELECT
                c_date.date_id
                ,eur_to_usd_missing_holidays.exchange_rate
               ,SUM(CASE WHEN fk_date_id IS NOT NULL THEN 1 ELSE 0 END) OVER (
                    ORDER BY date_id ASC
                    ) AS by_date_partition
                ,eur_to_usd_missing_holidays.tech_data_load_utc_timestamp
                ,eur_to_usd_missing_holidays.tech_data_load_uuid
                ,eur_to_usd_missing_holidays.fk_currency_id_counter_currency
                ,eur_to_usd_missing_holidays.fk_currency_id_base_currency
            FROM core.c_date_g AS c_date
            LEFT JOIN eur_to_usd_missing_holidays ON eur_to_usd_missing_holidays.fk_date_id = c_date.date_id
            WHERE c_date.date_id > 20100101
                AND c_date.date_id <= (
                    SELECT date_as_integer
                    FROM latest_exchange_rate_date
                    )
        )
        ,eur_to_czk_added_missing_dates_without_exchange_rates AS (
            SELECT
                c_date.date_id
                ,eur_to_czk_missing_holidays.exchange_rate
               ,SUM(CASE WHEN fk_date_id IS NOT NULL THEN 1 ELSE 0 END) OVER (
                    ORDER BY date_id ASC
                    ) AS by_date_partition
                ,eur_to_czk_missing_holidays.tech_data_load_utc_timestamp
                ,eur_to_czk_missing_holidays.tech_data_load_uuid
                ,eur_to_czk_missing_holidays.fk_currency_id_counter_currency
                ,eur_to_czk_missing_holidays.fk_currency_id_base_currency
            FROM core.c_date_g AS c_date
            LEFT JOIN eur_to_czk_missing_holidays ON eur_to_czk_missing_holidays.fk_date_id = c_date.date_id
            WHERE c_date.date_id > 20100101
                AND c_date.date_id <= (
                    SELECT date_as_integer
                    FROM latest_exchange_rate_date
                    )
        )
        ,usd_to_czk_added_missing_exchange_rates AS (
            SELECT
                FIRST_VALUE(fk_currency_id_counter_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_counter_currency
                ,FIRST_VALUE(fk_currency_id_base_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_base_currency
                ,FIRST_VALUE(exchange_rate) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS exchange_rate
                ,date_id
                ,FIRST_VALUE(tech_data_load_utc_timestamp) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_utc_timestamp
                ,FIRST_VALUE(tech_data_load_uuid) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_uuid
            FROM usd_to_czk_added_missing_dates_without_exchange_rates
        )
        ,usd_to_eur_added_missing_exchange_rates AS (
            SELECT
                FIRST_VALUE(fk_currency_id_counter_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_counter_currency
                ,FIRST_VALUE(fk_currency_id_base_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_base_currency
                ,FIRST_VALUE(exchange_rate) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS exchange_rate
                ,date_id
                ,FIRST_VALUE(tech_data_load_utc_timestamp) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_utc_timestamp
                ,FIRST_VALUE(tech_data_load_uuid) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_uuid
            FROM usd_to_eur_added_missing_dates_without_exchange_rates
        )
        ,czk_to_usd_added_missing_exchange_rates AS (
            SELECT
                FIRST_VALUE(fk_currency_id_counter_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_counter_currency
                ,FIRST_VALUE(fk_currency_id_base_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_base_currency
                ,FIRST_VALUE(exchange_rate) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS exchange_rate
                ,date_id
                ,FIRST_VALUE(tech_data_load_utc_timestamp) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_utc_timestamp
                ,FIRST_VALUE(tech_data_load_uuid) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_uuid
            FROM czk_to_usd_added_missing_dates_without_exchange_rates
        )
        ,czk_to_eur_added_missing_exchange_rates AS (
            SELECT
                FIRST_VALUE(fk_currency_id_counter_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_counter_currency
                ,FIRST_VALUE(fk_currency_id_base_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_base_currency
                ,FIRST_VALUE(exchange_rate) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS exchange_rate
                ,date_id
                ,FIRST_VALUE(tech_data_load_utc_timestamp) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_utc_timestamp
                ,FIRST_VALUE(tech_data_load_uuid) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_uuid
            FROM czk_to_eur_added_missing_dates_without_exchange_rates
        )
        ,eur_to_usd_added_missing_exchange_rates AS (
            SELECT
                FIRST_VALUE(fk_currency_id_counter_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_counter_currency
                ,FIRST_VALUE(fk_currency_id_base_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_base_currency
                ,FIRST_VALUE(exchange_rate) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS exchange_rate
                ,date_id
                ,FIRST_VALUE(tech_data_load_utc_timestamp) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_utc_timestamp
                ,FIRST_VALUE(tech_data_load_uuid) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_uuid
            FROM eur_to_usd_added_missing_dates_without_exchange_rates
        )
        ,eur_to_czk_added_missing_exchange_rates AS (
            SELECT
                FIRST_VALUE(fk_currency_id_counter_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_counter_currency
                ,FIRST_VALUE(fk_currency_id_base_currency) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS fk_currency_id_base_currency
                ,FIRST_VALUE(exchange_rate) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS exchange_rate
                ,date_id
                ,FIRST_VALUE(tech_data_load_utc_timestamp) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_utc_timestamp
                ,FIRST_VALUE(tech_data_load_uuid) OVER (
                    PARTITION BY by_date_partition ORDER BY date_id ASC
                    ) AS tech_data_load_uuid
            FROM eur_to_czk_added_missing_dates_without_exchange_rates
        )
        ,all_exchange_rates AS (
            SELECT
                fk_currency_id_counter_currency
                ,fk_currency_id_base_currency
                ,exchange_rate
                ,date_id
                ,tech_data_load_utc_timestamp
                ,tech_data_load_uuid
            FROM usd_to_czk_added_missing_exchange_rates
            WHERE exchange_rate IS NOT NULL

            UNION ALL

            SELECT
                fk_currency_id_counter_currency
                ,fk_currency_id_base_currency
                ,exchange_rate
                ,date_id
                ,tech_data_load_utc_timestamp
                ,tech_data_load_uuid
            FROM usd_to_eur_added_missing_exchange_rates
            WHERE exchange_rate IS NOT NULL

            UNION ALL

            SELECT
                fk_currency_id_counter_currency
                ,fk_currency_id_base_currency
                ,exchange_rate
                ,date_id
                ,tech_data_load_utc_timestamp
                ,tech_data_load_uuid
            FROM czk_to_usd_added_missing_exchange_rates
            WHERE exchange_rate IS NOT NULL

            UNION ALL

            SELECT
                fk_currency_id_counter_currency
                ,fk_currency_id_base_currency
                ,exchange_rate
                ,date_id
                ,tech_data_load_utc_timestamp
                ,tech_data_load_uuid
            FROM czk_to_eur_added_missing_exchange_rates
            WHERE exchange_rate IS NOT NULL

            UNION ALL

            SELECT
                fk_currency_id_counter_currency
                ,fk_currency_id_base_currency
                ,exchange_rate
                ,date_id
                ,tech_data_load_utc_timestamp
                ,tech_data_load_uuid
            FROM eur_to_usd_added_missing_exchange_rates
            WHERE exchange_rate IS NOT NULL

            UNION ALL

            SELECT
                fk_currency_id_counter_currency
                ,fk_currency_id_base_currency
                ,exchange_rate
                ,date_id
                ,tech_data_load_utc_timestamp
                ,tech_data_load_uuid
            FROM eur_to_czk_added_missing_exchange_rates
            WHERE exchange_rate IS NOT NULL
        )

    INSERT INTO tmp_c_exchange_rate_g (
        fk_currency_id_counter_currency
        ,fk_currency_id_base_currency
        ,exchange_rate
        ,fk_date_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        all_exchange_rates.fk_currency_id_counter_currency
        ,all_exchange_rates.fk_currency_id_base_currency
        ,all_exchange_rates.exchange_rate
        ,all_exchange_rates.date_id AS fk_date_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,all_exchange_rates.tech_data_load_utc_timestamp
        ,all_exchange_rates.tech_data_load_uuid
    FROM all_exchange_rates;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO CORE TABLE --
    -----------------------------------------

    INSERT INTO core.c_exchange_rate_g (
        fk_currency_id_counter_currency
        ,fk_currency_id_base_currency
        ,exchange_rate
        ,fk_date_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        tmp_c_exchange_rate_g.fk_currency_id_counter_currency
        ,tmp_c_exchange_rate_g.fk_currency_id_base_currency
        ,tmp_c_exchange_rate_g.exchange_rate
        ,tmp_c_exchange_rate_g.fk_date_id
        ,tmp_c_exchange_rate_g.tech_insert_function
        ,tmp_c_exchange_rate_g.tech_insert_utc_timestamp
        ,tmp_c_exchange_rate_g.tech_data_load_utc_timestamp
        ,tmp_c_exchange_rate_g.tech_data_load_uuid
    FROM tmp_c_exchange_rate_g
    ON CONFLICT DO NOTHING; -- ADD ONLY NEW RECORDS

    RETURN 0;

END;$$

LANGUAGE plpgsql
