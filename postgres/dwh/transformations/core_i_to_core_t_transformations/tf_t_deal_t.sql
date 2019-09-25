CREATE OR REPLACE FUNCTION core.tf_t_deal_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:    Insert data from core deal_i input table into core 'today' table deal_t
    AUTHOR:         Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:     2018-11-06 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
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

    INSERT INTO core.deal_t (
        deal_id
        ,deal_key
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
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_deal.deal_id
        ,input_deal.deal_key
        ,input_deal.title
        ,input_deal.stage
        ,input_deal.usd_value
        ,input_deal.fk_currency_id_deal_currency
        ,input_deal.local_currency_value
        ,input_deal.fk_date_id_created_date
        ,input_deal.created_timestamp
        ,input_deal.fk_date_id_last_updated_date
        ,input_deal.last_updated_timestamp
        ,input_deal.fk_date_id_closed_date
        ,input_deal.closed_timestamp
        ,input_deal.pipedrive_id
        ,input_deal.status
        ,input_deal.pipeline
        ,input_deal.fk_date_id_won_date
        ,input_deal.won_timestamp
        ,input_deal.fk_date_id_lost_date
        ,input_deal.lost_timestamp
        ,input_deal.fk_date_id_expected_close_date
        ,input_deal.expected_close_date
        ,input_deal.industry
        ,input_deal.deal_source
        ,input_deal.deal_source_detail
        ,input_deal.region
        ,input_deal.reason_lost
        ,input_deal.resulting_state
        ,input_issue.issue_id AS fk_issue_id
        ,input_contact.contact_id AS fk_contact_id
        ,input_organization.organization_id AS fk_organization_id
        ,input_employee_owner.employee_id AS fk_employee_id_owner
        ,input_deal.category
        ,input_deal.country
        ,input_deal.partner_identified_by
        ,input_deal.partner_qualified_by
        ,input_deal.partner_poc_done_by
        ,input_deal.partner_closed_by
        ,input_deal.partner_resold_by
        ,input_deal.partner_owned_by
        ,input_deal.partner_supported_by
        ,input_deal.vtiger_key
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_deal.tech_row_hash
        ,input_deal.tech_data_load_utc_timestamp
        ,input_deal.tech_data_load_uuid
    FROM core.deal_i AS input_deal
    LEFT JOIN core.issue_i AS input_issue ON input_deal.fk_issue_id = input_issue.issue_id
        AND input_issue.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.contact_i AS input_contact ON input_deal.fk_contact_id = input_contact.contact_id
        AND input_contact.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.organization_i AS input_organization ON input_deal.fk_organization_id = input_organization.organization_id
        AND input_organization.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.employee_i AS input_employee_owner ON input_deal.fk_employee_id_owner = input_employee_owner.employee_id
        AND input_employee_owner.tech_deleted_in_source_system IS FALSE
    WHERE input_deal.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql

