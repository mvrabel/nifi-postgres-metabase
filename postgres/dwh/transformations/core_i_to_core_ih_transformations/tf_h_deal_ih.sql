CREATE OR REPLACE FUNCTION core.tf_h_deal_ih()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        SCD2 historization of table deal_i.
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-29 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
INFINITY_TIMESTAMP bigint := 300001010000;
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -------------------------------------------
    -------------------------------------------
    --                                       --
    --              NEW RECORDS              --
    --                                       --
    -------------------------------------------
    -------------------------------------------

    ------------------------
    -- INSERT NEW RECORDS --
    ------------------------

    INSERT INTO core.deal_ih (
        deal_key
        ,title
        ,previous_stage
        ,stage
        ,fk_issue_id
        ,fk_contact_id
        ,fk_organization_id
        ,fk_employee_id_owner
        ,usd_value
        ,fk_currency_id_deal_currency
        ,local_currency_value
        ,created_timestamp
        ,last_updated_timestamp
        ,closed_timestamp
        ,pipedrive_id
        ,status
        ,pipeline
        ,won_timestamp
        ,lost_timestamp
        ,fk_date_id_expected_close_date
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
        ,partner_supported_by
        ,partner_owned_by
        ,tech_insert_function
        ,tech_begin_effective_utc_timestamp
        ,tech_end_effective_utc_timestamp
        ,tech_is_current
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_deal.deal_key
        ,input_deal.title
        ,NULL::TEXT AS previous_stage
        ,input_deal.stage
        ,hist_issue.issue_id AS fk_issue_id
        ,hist_contact.contact_id AS fk_contact_id
        ,hist_organization.organization_id AS fk_organization_id
        ,hist_employee_owner.employee_id AS fk_employee_id_owner
        ,input_deal.usd_value
        ,input_deal.fk_currency_id_deal_currency
        ,input_deal.local_currency_value
        ,input_deal.created_timestamp
        ,input_deal.last_updated_timestamp
        ,input_deal.closed_timestamp
        ,input_deal.pipedrive_id
        ,input_deal.status
        ,input_deal.pipeline
        ,input_deal.won_timestamp
        ,input_deal.lost_timestamp
        ,input_deal.fk_date_id_expected_close_date
        ,input_deal.industry
        ,input_deal.deal_source
        ,input_deal.deal_source_detail
        ,input_deal.region
        ,input_deal.reason_lost
        ,input_deal.resulting_state
        ,input_deal.category
        ,input_deal.country
        ,input_deal.vtiger_key
        ,input_deal.partner_identified_by
        ,input_deal.partner_qualified_by
        ,input_deal.partner_poc_done_by
        ,input_deal.partner_closed_by
        ,input_deal.partner_resold_by
        ,input_deal.partner_supported_by
        ,input_deal.partner_owned_by
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_deal.tech_deleted_in_source_system
        ,input_deal.tech_row_hash
        ,input_deal.tech_data_load_utc_timestamp
        ,input_deal.tech_data_load_uuid
    FROM core.deal_i AS input_deal
    JOIN core.employee_i AS input_employee_owner ON input_deal.fk_employee_id_owner = input_employee_owner.employee_id
    JOIN core.organization_i AS input_organization ON input_deal.fk_organization_id = input_organization.organization_id    
    JOIN core.issue_i AS input_issue ON input_deal.fk_issue_id = input_issue.issue_id    
    JOIN core.contact_i AS input_contact ON input_deal.fk_contact_id = input_contact.contact_id    
    JOIN core.organization_ih AS hist_organization ON hist_organization.organization_key = input_organization.organization_key
        AND hist_organization.tech_is_current = TRUE
    JOIN core.employee_ih AS hist_employee_owner ON hist_employee_owner.employee_key = input_employee_owner.employee_key
        AND hist_employee_owner.tech_is_current = TRUE
    JOIN core.issue_ih AS hist_issue ON hist_issue.issue_key = input_issue.issue_key
        AND hist_issue.tech_is_current = TRUE
    JOIN core.contact_ih AS hist_contact ON hist_contact.contact_key = input_contact.contact_key
        AND hist_contact.tech_is_current = TRUE
    LEFT JOIN core.deal_ih AS hist_deal ON hist_deal.deal_key = input_deal.deal_key
    WHERE hist_deal.deal_key IS NULL;

    -----------------------------------------------
    -----------------------------------------------
    --                                           --
    --              UPDATED RECORDS              --
    --                                           --
    -----------------------------------------------
    -----------------------------------------------

    ------------------------------------------------
    -- GET KEYS OF RECORDS THAT HAVE BEEN UPDATED --
    ------------------------------------------------

    DROP TABLE IF EXISTS updated_deal;
    
    CREATE TEMPORARY TABLE updated_deal (
        deal_key TEXT NOT NULL
        ,deal_id INTEGER NOT NULL
    );
    
    INSERT INTO updated_deal (
        deal_key
        ,deal_id
    )
    SELECT
        hist_deal.deal_key
        ,hist_deal.deal_id
    FROM core.deal_i AS input_deal
    JOIN core.deal_ih AS hist_deal ON hist_deal.deal_key = input_deal.deal_key
        AND hist_deal.tech_is_current = TRUE
    WHERE input_deal.tech_row_hash != hist_deal.tech_row_hash
        -- This "OR" is maybe unnecessary but let's keep it just to be sure.
        OR (
            input_deal.tech_row_hash = hist_deal.tech_row_hash
            AND hist_deal.tech_deleted_in_source_system = TRUE
            AND input_deal.tech_deleted_in_source_system = FALSE
            );

    ----------------------------------------------------------
    -- SET tech_is_current FLAG ON UPDATED RECORDS TO FALSE --
    -- AND                                                  --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP     --
    ----------------------------------------------------------

    UPDATE core.deal_ih AS hist_deal
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM updated_deal
    WHERE updated_deal.deal_key = hist_deal.deal_key
        AND hist_deal.tech_is_current = TRUE;

    ----------------------------
    -- INSERT UPDATED RECORDS --
    ----------------------------

    INSERT INTO core.deal_ih (
        deal_key
        ,title
        ,previous_stage
        ,stage
        ,fk_issue_id
        ,fk_contact_id
        ,fk_organization_id
        ,fk_employee_id_owner
        ,usd_value
        ,fk_currency_id_deal_currency
        ,local_currency_value
        ,created_timestamp
        ,last_updated_timestamp
        ,closed_timestamp
        ,pipedrive_id
        ,status
        ,pipeline
        ,won_timestamp
        ,lost_timestamp
        ,fk_date_id_expected_close_date
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
        ,partner_supported_by
        ,partner_owned_by
        ,tech_insert_function
        ,tech_begin_effective_utc_timestamp
        ,tech_end_effective_utc_timestamp
        ,tech_is_current
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
       input_deal.deal_key
        ,input_deal.title
        ,hist_deal.stage AS previous_stage
        ,input_deal.stage
        ,hist_issue.issue_id AS fk_issue_id
        ,hist_contact.contact_id AS fk_contact_id
        ,hist_organization.organization_id AS fk_organization_id
        ,hist_employee_owner.employee_id AS fk_employee_id_owner
        ,input_deal.usd_value
        ,input_deal.fk_currency_id_deal_currency
        ,input_deal.local_currency_value
        ,input_deal.created_timestamp
        ,input_deal.last_updated_timestamp
        ,input_deal.closed_timestamp
        ,input_deal.pipedrive_id
        ,input_deal.status
        ,input_deal.pipeline
        ,input_deal.won_timestamp
        ,input_deal.lost_timestamp
        ,input_deal.fk_date_id_expected_close_date
        ,input_deal.industry
        ,input_deal.deal_source
        ,input_deal.deal_source_detail
        ,input_deal.region
        ,input_deal.reason_lost
        ,input_deal.resulting_state
        ,input_deal.category
        ,input_deal.country
        ,input_deal.vtiger_key
        ,input_deal.partner_identified_by
        ,input_deal.partner_qualified_by
        ,input_deal.partner_poc_done_by
        ,input_deal.partner_closed_by
        ,input_deal.partner_resold_by
        ,input_deal.partner_supported_by
        ,input_deal.partner_owned_by
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,input_deal.tech_deleted_in_source_system
        ,input_deal.tech_row_hash
        ,input_deal.tech_data_load_utc_timestamp
        ,input_deal.tech_data_load_uuid
    FROM core.deal_i AS input_deal
    JOIN core.deal_ih AS hist_deal ON hist_deal.deal_key = input_deal.deal_key AND hist_deal.deal_id IN (SELECT deal_id FROM updated_deal)
    JOIN core.employee_i AS input_employee_owner ON input_deal.fk_employee_id_owner = input_employee_owner.employee_id
    JOIN core.organization_i AS input_organization ON input_deal.fk_organization_id = input_organization.organization_id    
    JOIN core.issue_i AS input_issue ON input_deal.fk_issue_id = input_issue.issue_id    
    JOIN core.contact_i AS input_contact ON input_deal.fk_contact_id = input_contact.contact_id    
    JOIN core.organization_ih AS hist_organization ON hist_organization.organization_key = input_organization.organization_key
        AND hist_organization.tech_is_current = TRUE
    JOIN core.employee_ih AS hist_employee_owner ON hist_employee_owner.employee_key = input_employee_owner.employee_key
        AND hist_employee_owner.tech_is_current = TRUE
    JOIN core.issue_ih AS hist_issue ON hist_issue.issue_key = input_issue.issue_key
        AND hist_issue.tech_is_current = TRUE
    JOIN core.contact_ih AS hist_contact ON hist_contact.contact_key = input_contact.contact_key
        AND hist_contact.tech_is_current = TRUE
    WHERE input_deal.deal_key IN (SELECT deal_key FROM updated_deal);

    -----------------------------------------------
    -----------------------------------------------
    --                                           --
    --              DELETED RECORDS              --
    --                                           --
    -----------------------------------------------
    -----------------------------------------------

    ------------------------------------------------
    -- GET KEYS OF RECORDS THAT HAVE BEEN DELETED --
    ------------------------------------------------

    DROP TABLE IF EXISTS deleted_deal;

    CREATE TEMPORARY TABLE deleted_deal (
        deal_id INTEGER NOT NULL
    );
    
    INSERT INTO deleted_deal (
        deal_id
    )
    SELECT
        hist_deal.deal_id
    FROM core.deal_ih AS hist_deal
    LEFT JOIN core.deal_i AS input_deal ON input_deal.deal_key = hist_deal.deal_key
    WHERE input_deal.deal_key IS NULL 
        AND hist_deal.tech_is_current = TRUE
        AND hist_deal.tech_deleted_in_source_system = FALSE;

    ---------------------------------------------------------------
    -- SET tech_is_current FLAG ON DELETED RECORDS TO FALSE      --
    -- AND                                                       --
    -- SET tech_end_effective_utc_timestamp To CURRENT TIMESTAMP --
    ---------------------------------------------------------------

    UPDATE core.deal_ih AS hist_deal
    SET tech_is_current = FALSE
        ,tech_end_effective_utc_timestamp = CURRENT_UTC_TIMESTAMP_AS_BIGINT - 1
    FROM deleted_deal
    WHERE deleted_deal.deal_id = hist_deal.deal_id
        AND hist_deal.tech_is_current = TRUE;

    ----------------------------
    -- INSERT DELETED RECORDS --
    ----------------------------

    INSERT INTO core.deal_ih (
        deal_key
        ,title
        ,previous_stage
        ,stage
        ,fk_issue_id
        ,fk_contact_id
        ,fk_organization_id
        ,fk_employee_id_owner
        ,usd_value
        ,fk_currency_id_deal_currency
        ,local_currency_value
        ,created_timestamp
        ,last_updated_timestamp
        ,closed_timestamp
        ,pipedrive_id
        ,status
        ,pipeline
        ,won_timestamp
        ,lost_timestamp
        ,fk_date_id_expected_close_date
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
        ,partner_supported_by
        ,partner_owned_by
        ,tech_insert_function
        ,tech_begin_effective_utc_timestamp
        ,tech_end_effective_utc_timestamp
        ,tech_is_current
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        hist_deal.deal_key
        ,hist_deal.title
        ,hist_deal.stage AS previous_stage
        ,hist_deal.stage
        ,hist_deal.fk_issue_id
        ,hist_deal.fk_contact_id
        ,hist_deal.fk_organization_id
        ,hist_deal.fk_employee_id_owner
        ,hist_deal.usd_value
        ,hist_deal.fk_currency_id_deal_currency
        ,hist_deal.local_currency_value
        ,hist_deal.created_timestamp
        ,hist_deal.last_updated_timestamp
        ,hist_deal.closed_timestamp
        ,hist_deal.pipedrive_id
        ,hist_deal.status
        ,hist_deal.pipeline
        ,hist_deal.won_timestamp
        ,hist_deal.lost_timestamp
        ,hist_deal.fk_date_id_expected_close_date
        ,hist_deal.industry
        ,hist_deal.deal_source
        ,hist_deal.deal_source_detail
        ,hist_deal.region
        ,hist_deal.reason_lost
        ,hist_deal.resulting_state
        ,hist_deal.category
        ,hist_deal.country
        ,hist_deal.vtiger_key
        ,hist_deal.partner_identified_by
        ,hist_deal.partner_qualified_by
        ,hist_deal.partner_poc_done_by
        ,hist_deal.partner_closed_by
        ,hist_deal.partner_resold_by
        ,hist_deal.partner_supported_by
        ,hist_deal.partner_owned_by
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_begin_effective_utc_timestamp
        ,INFINITY_TIMESTAMP AS tech_end_effective_utc_timestamp
        ,TRUE AS tech_is_current
        ,TRUE AS tech_deleted_in_source_system
        ,hist_deal.tech_row_hash
        ,hist_deal.tech_data_load_utc_timestamp
        ,hist_deal.tech_data_load_uuid
    FROM core.deal_ih AS hist_deal
    WHERE hist_deal.deal_id IN (SELECT deal_id FROM deleted_deal);

    RETURN 0;

END;$$

LANGUAGE plpgsql

