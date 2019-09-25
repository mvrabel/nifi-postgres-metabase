CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_deal_i()
RETURNS INTEGER 
AS $$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table deal_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-10-26 (YYYY-MM-DD)
    NOTE:
    ==============================================================================================
    */

DECLARE 

PIPEDRIVE_PREFIX TEXT := 'PIPEDRIVE_';
ORGANIZATION_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'ORGANIZATION_';
PERSON_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'PERSON_';
CONTACT_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'CONTACT_';
EMPLOYEE_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'EMPLOYEE_';
DEAL_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'DEAL_';
CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
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

    INSERT INTO core.deal_i (
        deal_id
        ,deal_key
        ,title
        ,stage
        ,fk_issue_id
        ,fk_contact_id
        ,fk_organization_id
        ,fk_employee_id_owner
        ,usd_value
        ,fk_currency_id_deal_currency
        ,local_currency_value
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,fk_date_id_closed_date
        ,closed_timestamp
        ,pipedrive_id
        ,status
        ,pipeline
        ,fk_date_id_won_date
        ,won_timestamp
        ,fk_date_id_lost_date
        ,lost_timestamp
        ,fk_date_id_expected_close_date
        ,expected_close_date
        ,industry
        ,deal_source
        ,deal_source_detail
        ,region
        ,reason_lost
        ,resulting_state
        ,category
        ,country
        ,vtiger_key
        ,partner_identified_by
        ,partner_qualified_by
        ,partner_poc_done_by
        ,partner_closed_by
        ,partner_resold_by
        ,partner_owned_by
        ,partner_supported_by
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
        -1 -- deal_id
        ,TEXT_NULL -- deal_key
        ,TEXT_NULL -- title
        ,TEXT_NULL -- stage
        ,-1 -- fk_issue_id
        ,-1 -- fk_contact_id
        ,-1 -- fk_organization_id
        ,-1 -- fk_employee_id_owner
        ,-1 -- usd_value
        ,-1 -- fk_currency_id_deal_currency
        ,-1 -- local_currency_value
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
        ,-1 -- fk_date_id_last_updated_date
        ,TIMESTAMP_NEVER -- last_updated_timestamp
        ,-1 -- fk_date_id_closed_date
        ,TIMESTAMP_NEVER -- closed_timestamp
        ,TEXT_NULL -- pipedrive_id
        ,TEXT_NULL -- status
        ,TEXT_NULL -- pipeline
        ,-1 -- fk_date_id_won_date
        ,TIMESTAMP_NEVER -- won_timestamp
        ,-1 -- fk_date_id_lost_date
        ,TIMESTAMP_NEVER -- lost_timestamp
        ,-1 -- fk_date_id_expected_close_date
        ,TIMESTAMP_NEVER -- expected_close_date
        ,TEXT_NULL -- industry
        ,TEXT_NULL -- deal_source
        ,TEXT_NULL -- deal_source_detail
        ,TEXT_NULL -- region
        ,TEXT_NULL -- reason_lost
        ,TEXT_NULL -- resulting_state
        ,TEXT_NULL -- category
        ,TEXT_NULL -- country
        ,TEXT_NULL -- vtiger_key
        ,TEXT_NULL -- partner_identified_by
        ,TEXT_NULL -- partner_qualified_by
        ,TEXT_NULL -- partner_poc_done_by
        ,TEXT_NULL -- partner_closed_by
        ,TEXT_NULL -- partner_resold_by
        ,TEXT_NULL -- partner_owned_by
        ,TEXT_NULL -- partner_supported_by
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

    DROP TABLE IF EXISTS tmp_deal_i cascade;

    CREATE TEMPORARY TABLE tmp_deal_i (
        deal_key                             TEXT NOT NULL
        ,title                               TEXT NOT NULL
        ,stage                               TEXT NOT NULL
        ,usd_value                           INTEGER NOT NULL
        ,fk_currency_id_deal_currency        INTEGER NOT NULL
        ,local_currency_value                INTEGER NOT NULL
        ,fk_date_id_created_date             INTEGER  NOT NULL
        ,created_timestamp                   TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_last_updated_date        INTEGER  NOT NULL
        ,last_updated_timestamp              TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_closed_date              INTEGER  NOT NULL
        ,closed_timestamp                    TIMESTAMP WITH TIME ZONE
        ,pipedrive_id                        TEXT NOT NULL
        ,status                              TEXT NOT NULL
        ,pipeline                            TEXT NOT NULL
        ,fk_date_id_won_date                 INTEGER  NOT NULL
        ,won_timestamp                       TIMESTAMP WITH TIME ZONE
        ,fk_date_id_lost_date                INTEGER  NOT NULL
        ,lost_timestamp                      TIMESTAMP WITH TIME ZONE
        ,fk_date_id_expected_close_date      INTEGER  NOT NULL
        ,expected_close_date                 DATE  NOT NULL
        ,industry                            TEXT  NOT NULL
        ,deal_source                         TEXT  NOT NULL
        ,deal_source_detail                  TEXT  NOT NULL
        ,region                              TEXT  NOT NULL
        ,reason_lost                         TEXT  NOT NULL
        ,resulting_state                     TEXT  NOT NULL
        ,fk_issue_id                         INTEGER NOT NULL
        ,fk_contact_id                       INTEGER NOT NULL
        ,fk_organization_id                  INTEGER NOT NULL
        ,fk_employee_id_owner                INTEGER NOT NULL
        ,category                            TEXT  NOT NULL
        ,country                             TEXT  NOT NULL
        ,partner_identified_by               TEXT  NOT NULL
        ,partner_qualified_by                TEXT  NOT NULL
        ,partner_poc_done_by                 TEXT  NOT NULL
        ,partner_closed_by                   TEXT  NOT NULL
        ,partner_resold_by                   TEXT  NOT NULL
        ,partner_owned_by                    TEXT  NOT NULL
        ,partner_supported_by                TEXT  NOT NULL
        ,vtiger_key                          TEXT  NOT NULL
        ,tech_insert_function                TEXT  NOT NULL
        ,tech_insert_utc_timestamp           BIGINT NOT NULL
        ,tech_row_hash                       TEXT NOT NULL
        ,tech_data_load_utc_timestamp        BIGINT NOT NULL
        ,tech_data_load_uuid                 TEXT NOT NULL
        ,tech_deleted_in_source_system       BOOL NOT NULL
     );

    INSERT INTO tmp_deal_i (
        deal_key
        ,title
        ,stage
        ,usd_value
        ,fk_currency_id_deal_currency
        ,local_currency_value
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,fk_date_id_closed_date
        ,closed_timestamp
        ,pipedrive_id
        ,status
        ,pipeline
        ,fk_date_id_won_date
        ,won_timestamp
        ,fk_date_id_lost_date
        ,lost_timestamp
        ,fk_date_id_expected_close_date
        ,expected_close_date
        ,industry
        ,deal_source
        ,deal_source_detail
        ,region
        ,reason_lost
        ,resulting_state
        ,fk_issue_id
        ,fk_contact_id
        ,fk_organization_id
        ,fk_employee_id_owner
        ,category
        ,country
        ,partner_identified_by
        ,partner_qualified_by
        ,partner_poc_done_by
        ,partner_closed_by
        ,partner_resold_by
        ,partner_owned_by
        ,partner_supported_by
        ,vtiger_key
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        DEAL_KEY_PREFIX || pipedrive_deal.id AS deal_key
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.title) AS title
        ,tf_u_replace_empty_string_with_null_flag(deal_stage.name) AS stage
        ,CASE 
            WHEN pipedrive_deal.currency = 'USD' THEN pipedrive_deal."value"
            ELSE local_currency_to_usd_exchange_rate.exchange_rate * pipedrive_deal."value"
        END AS usd_value
        ,base_currency.currency_id AS fk_currency_id_deal_currency
        ,COALESCE(pipedrive_deal."value", 0) AS local_currency_value
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_deal.add_time), -1) AS fk_date_id_created_date
        ,COALESCE((pipedrive_deal.add_time || ' +00')::TIMESTAMP WITH TIME ZONE, TIMESTAMP_NEVER) AS created_timestamp
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_deal.update_time), -1) AS fk_date_id_last_updated_date
        ,COALESCE((pipedrive_deal.update_time || ' +00')::TIMESTAMP WITH TIME ZONE, TIMESTAMP_NEVER) AS last_updated_timestamp
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_deal.close_time), -1) AS fk_date_id_closed_date
        ,COALESCE((pipedrive_deal.close_time || ' +00')::TIMESTAMP WITH TIME ZONE, TIMESTAMP_NEVER) AS closed_timestamp
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.id::TEXT) AS pipedrive_id
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.status) AS status
        ,tf_u_replace_empty_string_with_null_flag(deal_pipeline.name) AS pipeline
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_deal.won_time), -1) AS fk_date_id_won_date
        ,COALESCE((pipedrive_deal.won_time || ' +00')::TIMESTAMP WITH TIME ZONE, TIMESTAMP_NEVER) AS won_timestamp
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_deal.lost_time), -1) AS fk_date_id_lost_date
        ,COALESCE((pipedrive_deal.lost_time || ' +00')::TIMESTAMP WITH TIME ZONE, TIMESTAMP_NEVER) AS lost_timestamp        
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_deal.expected_close_date), -1) AS fk_date_id_expected_close_date
        ,COALESCE((pipedrive_deal.expected_close_date || ' +00')::TIMESTAMP WITH TIME ZONE, TIMESTAMP_NEVER) AS expected_close_date
        ,tf_u_replace_empty_string_with_null_flag(deal_industry.label) AS industry
        ,tf_u_replace_empty_string_with_null_flag(deal_source.label) AS deal_source
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.deal_source_detail) AS deal_source_detail
        ,tf_u_replace_empty_string_with_null_flag(deal_region.label) AS region
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.lost_reason) AS reason_lost
        ,tf_u_replace_empty_string_with_null_flag(deal_resulting_state.label) AS resulting_state
        ,COALESCE(jira_issue.issue_id, -1) AS fk_issue_id
        ,COALESCE(core_contact.contact_id, -1) AS fk_contact_id
        ,COALESCE(core_organization.organization_id, -1) AS fk_organization_id
        ,core_employee.employee_id AS fk_employee_id_owner
        ,tf_u_replace_empty_string_with_null_flag(deal_category.label) AS category
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.country_country) AS country
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.partner_identified_by) AS partner_identified_by
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.partner_qualified_by) AS partner_qualified_by
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.partner_poc_done_by) AS partner_poc_done_by
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.partner_closed_by) AS partner_closed_by
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.partner_resold_by) AS partner_resold_by
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.partner_owned_by) AS partner_owned_by
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.partner_supported_by) AS partner_supported_by
        ,tf_u_replace_empty_string_with_null_flag(pipedrive_deal.vtiger_id) AS vtiger_key
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(pipedrive_deal.title::TEXT, '')
            || COALESCE(pipedrive_deal."value"::TEXT, '')
            || COALESCE(pipedrive_deal.stage_id::TEXT, '')
            || COALESCE(pipedrive_deal.org_id::TEXT, '')
            || COALESCE(pipedrive_deal.person_id::TEXT, '')
            || COALESCE(pipedrive_deal.close_time::TEXT, '')
            || COALESCE(pipedrive_deal.status::TEXT, '')
            || COALESCE(pipedrive_deal.pipeline_id::TEXT, '')
            || COALESCE(pipedrive_deal.won_time::TEXT, '')
            || COALESCE(pipedrive_deal.lost_time::TEXT, '')
            || COALESCE(pipedrive_deal.lost_reason::TEXT, '')
            || COALESCE(pipedrive_deal.expected_close_date::TEXT, '')
            || COALESCE(pipedrive_deal.industry::TEXT, '')
            || COALESCE(pipedrive_deal.deal_source::TEXT, '')
            || COALESCE(pipedrive_deal.deal_source_detail::TEXT, '')
            || COALESCE(pipedrive_deal.region::TEXT, '')
            || COALESCE(pipedrive_deal.reason_lost::TEXT, '')
            || COALESCE(pipedrive_deal.resulting_state::TEXT, '')
            || COALESCE(pipedrive_deal.jira_issue_key::TEXT, '')
            || COALESCE(pipedrive_deal.category::TEXT, '')
            || COALESCE(pipedrive_deal.country_country::TEXT, '')
            || COALESCE(pipedrive_deal.partner_identified_by::TEXT, '')
            || COALESCE(pipedrive_deal.partner_qualified_by::TEXT, '')
            || COALESCE(pipedrive_deal.partner_poc_done_by::TEXT, '')
            || COALESCE(pipedrive_deal.partner_closed_by::TEXT, '')
            || COALESCE(pipedrive_deal.partner_resold_by::TEXT, '')
            || COALESCE(pipedrive_deal.partner_owned_by::TEXT, '')
            || COALESCE(pipedrive_deal.partner_supported_by::TEXT, '')
        ) AS tech_row_hash
        ,pipedrive_deal.tech_data_load_utc_timestamp
        ,pipedrive_deal.tech_data_load_uuid
    FROM stage.pipedrive_deal_i AS pipedrive_deal
    LEFT JOIN core.c_currency_g AS base_currency ON base_currency.alphabetical_code = pipedrive_deal.currency
    LEFT JOIN core.c_exchange_rate_g AS local_currency_to_usd_exchange_rate ON local_currency_to_usd_exchange_rate.fk_currency_id_base_currency = base_currency.currency_id
        AND local_currency_to_usd_exchange_rate.fk_date_id = to_char(NOW() - '1 week'::INTERVAL, 'YYYYMMDD')::INTEGER
        AND local_currency_to_usd_exchange_rate.fk_currency_id_counter_currency = (SELECT currency_id FROM core.c_currency_g WHERE alphabetical_code = 'USD')
    LEFT JOIN stage.pipedrive_stage_i AS deal_stage ON deal_stage.id = pipedrive_deal.stage_id
    LEFT JOIN stage.pipedrive_pipeline_i AS deal_pipeline ON deal_pipeline.id = pipedrive_deal.pipeline_id
    LEFT JOIN stage.pipedrive_deal_industry_options_i AS deal_industry ON deal_industry.id = pipedrive_deal.industry
    LEFT JOIN stage.pipedrive_deal_deal_source_options_i AS deal_source ON deal_source.id = pipedrive_deal.deal_source
    LEFT JOIN stage.pipedrive_deal_region_options_i AS deal_region ON deal_region.id = pipedrive_deal.region
    LEFT JOIN stage.pipedrive_deal_reason_lost_options_i AS deal_reason_lost ON deal_reason_lost.id = pipedrive_deal.reason_lost
    LEFT JOIN stage.pipedrive_deal_resulting_state_options_i AS deal_resulting_state ON deal_resulting_state.id = pipedrive_deal.resulting_state
    LEFT JOIN stage.pipedrive_deal_category_options_i AS deal_category ON deal_category.id = pipedrive_deal.category
    LEFT JOIN core.issue_i AS jira_issue ON jira_issue.jira_key = pipedrive_deal.jira_issue_key
    LEFT JOIN stage.pipedrive_person_i AS pipedrive_person ON pipedrive_person.id = pipedrive_deal.person_id
    LEFT JOIN stage.pipedrive_person_label_options_i AS person_label ON person_label.id = pipedrive_person.label
    LEFT JOIN core.organization_i AS core_organization ON core_organization.organization_key = ORGANIZATION_KEY_PREFIX || pipedrive_deal.org_id
    LEFT JOIN core.contact_i AS core_contact ON core_contact.contact_key = CONTACT_KEY_PREFIX || pipedrive_deal.person_id
    LEFT JOIN core.employee_i AS core_employee ON core_employee.employee_key = EMPLOYEE_KEY_PREFIX || pipedrive_deal.user_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.deal_i (
        deal_key
        ,title
        ,stage
        ,usd_value
        ,fk_currency_id_deal_currency
        ,local_currency_value
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,fk_date_id_closed_date
        ,closed_timestamp
        ,pipedrive_id
        ,status
        ,pipeline
        ,fk_date_id_won_date
        ,won_timestamp
        ,fk_date_id_lost_date
        ,lost_timestamp
        ,fk_date_id_expected_close_date
        ,expected_close_date
        ,industry
        ,deal_source
        ,deal_source_detail
        ,region
        ,reason_lost
        ,resulting_state
        ,fk_issue_id
        ,fk_contact_id
        ,fk_organization_id
        ,fk_employee_id_owner
        ,category
        ,country
        ,partner_identified_by
        ,partner_qualified_by
        ,partner_poc_done_by
        ,partner_closed_by
        ,partner_resold_by
        ,partner_owned_by
        ,partner_supported_by
        ,vtiger_key
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT 
        tmp_deal_i.deal_key
        ,tmp_deal_i.title
        ,tmp_deal_i.stage
        ,tmp_deal_i.usd_value
        ,tmp_deal_i.fk_currency_id_deal_currency
        ,tmp_deal_i.local_currency_value
        ,tmp_deal_i.fk_date_id_created_date
        ,tmp_deal_i.created_timestamp
        ,tmp_deal_i.fk_date_id_last_updated_date
        ,tmp_deal_i.last_updated_timestamp
        ,tmp_deal_i.fk_date_id_closed_date
        ,tmp_deal_i.closed_timestamp
        ,tmp_deal_i.pipedrive_id
        ,tmp_deal_i.status
        ,tmp_deal_i.pipeline
        ,tmp_deal_i.fk_date_id_won_date
        ,tmp_deal_i.won_timestamp
        ,tmp_deal_i.fk_date_id_lost_date
        ,tmp_deal_i.lost_timestamp
        ,tmp_deal_i.fk_date_id_expected_close_date
        ,tmp_deal_i.expected_close_date
        ,tmp_deal_i.industry
        ,tmp_deal_i.deal_source
        ,tmp_deal_i.deal_source_detail
        ,tmp_deal_i.region
        ,tmp_deal_i.reason_lost
        ,tmp_deal_i.resulting_state
        ,tmp_deal_i.fk_issue_id
        ,tmp_deal_i.fk_contact_id
        ,tmp_deal_i.fk_organization_id
        ,tmp_deal_i.fk_employee_id_owner
        ,tmp_deal_i.category
        ,tmp_deal_i.country
        ,tmp_deal_i.partner_identified_by
        ,tmp_deal_i.partner_qualified_by
        ,tmp_deal_i.partner_poc_done_by
        ,tmp_deal_i.partner_closed_by
        ,tmp_deal_i.partner_resold_by
        ,tmp_deal_i.partner_owned_by
        ,tmp_deal_i.partner_supported_by
        ,tmp_deal_i.vtiger_key
        ,tmp_deal_i.tech_insert_function
        ,tmp_deal_i.tech_insert_utc_timestamp
        ,tmp_deal_i.tech_deleted_in_source_system
        ,tmp_deal_i.tech_row_hash
        ,tmp_deal_i.tech_data_load_utc_timestamp
        ,tmp_deal_i.tech_data_load_uuid
    FROM tmp_deal_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
