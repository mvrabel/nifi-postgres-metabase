CREATE OR REPLACE FUNCTION core.tf_i_src_mailchimp_trg_email_campaign_opened_by_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'mailchimp_*' tables into core input table email_campaign_opened_by_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-08-13 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
TIMESTAMP_ARRAY_NULL TIMESTAMP WITH TIME ZONE[] := (SELECT timestamp_array_null FROM core.c_null_replacement_g);
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.email_campaign_opened_by_i (
        email_campaign_opened_by_id
        ,email_campaign_opened_by_key
        ,fk_email_campaign_report_id
        ,email_address
        ,opens_count
        ,open_timestamps
        ,first_name
        ,last_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    VALUES (
        -1 -- email_campaign_opened_by_id
        ,TEXT_NULL -- email_campaign_opened_by_key
        ,-1 -- fk_email_campaign_report_id
        ,TEXT_NULL -- email_address
        ,-1 -- opens_count
        ,TIMESTAMP_ARRAY_NULL -- open_timestamps
        ,TEXT_NULL -- first_name
        ,TEXT_NULL -- last_name
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,TEXT_NULL -- tech_row_hash
        ,-1 -- tech_data_load_utc_timestamp
        ,TEXT_NULL -- tech_data_load_uuid
    ) ON CONFLICT DO NOTHING;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_email_campaign_open_report;

    CREATE TEMPORARY TABLE tmp_email_campaign_open_report (
        email_campaign_opened_by_key            TEXT NOT NULL
        ,fk_email_campaign_report_id            INTEGER NOT NULL
        ,email_address                          TEXT NOT NULL
        ,open_timestamps                        TIMESTAMP WITH TIME ZONE [] NOT NULL
        ,opens_count                            INTEGER NOT NULL
        ,first_name                             TEXT
        ,last_name                              TEXT
        ,tech_insert_function                   TEXT NOT NULL
        ,tech_insert_utc_timestamp              BIGINT NOT NULL
        ,tech_row_hash                          TEXT NOT NULL
        ,tech_data_load_utc_timestamp           BIGINT NOT NULL
        ,tech_data_load_uuid                    TEXT NOT NULL
        ,tech_deleted_in_source_system          bool NOT NULL
     );

    INSERT INTO tmp_email_campaign_open_report (
        email_campaign_opened_by_key
        ,fk_email_campaign_report_id
        ,email_address
        ,open_timestamps
        ,opens_count
        ,first_name
        ,last_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        mailchimp_open_report.campaign_id || mailchimp_open_report.email_id AS email_campaign_opened_by_key
        ,core_email_campaign_report.email_campaign_report_id AS fk_email_campaign_report_id
        ,mailchimp_open_report.email_address AS email_address
        ,mailchimp_open_report.opens_timestamp::TIMESTAMP WITH TIME ZONE [] AS open_timestamps
        ,mailchimp_open_report.opens_count AS opens_count
        ,mailchimp_open_report.merge_fields_fname AS first_name
        ,mailchimp_open_report.merge_fields_lname AS last_name
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(mailchimp_open_report.campaign_id, '')
            || COALESCE(mailchimp_open_report.email_id, '')
            || COALESCE(mailchimp_open_report.email_address, '')
            || COALESCE(mailchimp_open_report.opens_timestamp, '')
            || COALESCE(mailchimp_open_report.opens_count::TEXT, '')
            || COALESCE(mailchimp_open_report.merge_fields_fname, '')
            || COALESCE(mailchimp_open_report.merge_fields_lname, '')
        ) AS tech_row_hash
        ,mailchimp_open_report.tech_data_load_utc_timestamp
        ,mailchimp_open_report.tech_data_load_uuid
    FROM stage.mailchimp_report_open_report_i AS mailchimp_open_report
    JOIN core.email_campaign_report_i AS core_email_campaign_report ON core_email_campaign_report.email_campaign_report_key = mailchimp_open_report.campaign_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.email_campaign_opened_by_i (
        email_campaign_opened_by_key
        ,fk_email_campaign_report_id
        ,email_address
        ,open_timestamps
        ,opens_count
        ,first_name
        ,last_name
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_email_campaign_open_report.email_campaign_opened_by_key
        ,tmp_email_campaign_open_report.fk_email_campaign_report_id
        ,tmp_email_campaign_open_report.email_address
        ,tmp_email_campaign_open_report.open_timestamps
        ,tmp_email_campaign_open_report.opens_count
        ,tmp_email_campaign_open_report.first_name
        ,tmp_email_campaign_open_report.last_name
        ,tmp_email_campaign_open_report.tech_insert_function
        ,tmp_email_campaign_open_report.tech_insert_utc_timestamp
        ,tmp_email_campaign_open_report.tech_deleted_in_source_system
        ,tmp_email_campaign_open_report.tech_row_hash
        ,tmp_email_campaign_open_report.tech_data_load_utc_timestamp
        ,tmp_email_campaign_open_report.tech_data_load_uuid
    FROM tmp_email_campaign_open_report;

    RETURN 0;

END;$$

LANGUAGE plpgsql
