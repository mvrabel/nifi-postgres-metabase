CREATE OR REPLACE FUNCTION mart.tf_r_deal()
RETURNS INTEGER AS $$

DECLARE

DATE_NEVER DATE := (SELECT date_never FROM core.c_null_replacement_g);
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);

BEGIN

    WITH
    deal_aggregate_duplicate_emails AS (
        SELECT
            deal.deal_id
            ,COUNT(deal_email.mail_message_id) AS email_count
        FROM core.deal_t AS deal
        LEFT JOIN core.mail_message_t AS deal_email ON deal_email.fk_deal_id = deal.deal_id
        GROUP BY deal.deal_id
            ,deal_email.pipedrive_mail_message_id
    )
    ,deal_email_count AS (
        SELECT
            deal_aggregate_duplicate_emails.deal_id
            ,SUM(deal_aggregate_duplicate_emails.email_count) AS email_count
        FROM deal_aggregate_duplicate_emails
        GROUP BY deal_id
    )
    ,aggregated_deal_email_content AS (
      SELECT
        deal.deal_id
        ,string_agg(COALESCE(deal_email.body_snippet, ''), ' ') AS agg_body_snippet
      FROM core.deal_t AS deal
      LEFT JOIN core.mail_message_t AS deal_email ON deal_email.fk_deal_id = deal.deal_id
      GROUP BY deal.deal_id
    )
    ,aggregated_deal_note_content AS (
        SELECT
            deal.deal_id
            ,string_agg(COALESCE(deal_note.content, ''), ' ') AS agg_content
        FROM core.deal_t AS deal
        LEFT JOIN core.note_t AS deal_note ON deal_note.fk_deal_id = deal.deal_id
        GROUP BY deal.deal_id
    )
    ,deal_text_search_include_emails_and_notes_vector AS (
        SELECT
            deal.deal_id
            ,to_tsvector(
                unaccent(
                    deal_issue.account                  ::TEXT
                    || deal_issue.customer              ::TEXT
                    || deal.title                       ::TEXT
                    || deal.category                    ::TEXT
                    || deal.deal_source                 ::TEXT
                    || deal.deal_source_detail          ::TEXT
                    || deal.stage                       ::TEXT
                    || deal.status                      ::TEXT
                    || deal.reason_lost                 ::TEXT
                    || deal.resulting_state             ::TEXT
                    || deal_issue.description           ::TEXT
                    || deal_issue.priority              ::TEXT
                    || deal_issue.status                ::TEXT
                    || deal_issue.summary               ::TEXT
                    || party_contact.full_name          ::TEXT
                    || main_contact.email_address       ::TEXT
                    || main_contact.location_country    ::TEXT
                    || deal.country                     ::TEXT
                    || deal.region                      ::TEXT
                    || party_organization.full_name     ::TEXT
                    || deal.partner_identified_by       ::TEXT
                    || deal.partner_qualified_by        ::TEXT
                    || deal.partner_poc_done_by         ::TEXT
                    || deal.partner_closed_by           ::TEXT
                    || deal.partner_resold_by           ::TEXT
                    || deal.partner_owned_by            ::TEXT
                    || deal_note.agg_content            ::TEXT
                    || deal_email.agg_body_snippet      ::TEXT
                )
            ) AS text_search_vector
    FROM core.deal_t AS deal
    JOIN aggregated_deal_note_content AS deal_note ON deal_note.deal_id = deal.deal_id
    JOIN aggregated_deal_email_content AS deal_email ON deal_email.deal_id = deal.deal_id
    JOIN core.issue_t AS deal_issue ON deal.fk_issue_id = deal_issue.issue_id
    JOIN core.contact_t AS main_contact ON deal.fk_contact_id = main_contact.contact_id
    JOIN core.party_t AS party_contact ON main_contact.fk_party_id = party_contact.party_id
    JOIN core.organization_t AS organization ON deal.fk_organization_id = organization.organization_id
    JOIN core.party_t AS party_organization ON organization.fk_party_id = party_organization.party_id
    WHERE deal.deal_id != -1
    )
    ,deal_text_search_vector AS (
    SELECT
        deal.deal_id
        ,to_tsvector(
            unaccent(
                deal_issue.account                  ::TEXT
                || deal_issue.customer              ::TEXT
                || deal.title                       ::TEXT
                || deal.category                    ::TEXT
                || deal.deal_source                 ::TEXT
                || deal.deal_source_detail          ::TEXT
                || deal.stage                       ::TEXT
                || deal.status                      ::TEXT
                || deal.reason_lost                 ::TEXT
                || deal.resulting_state             ::TEXT
                || deal_issue.description           ::TEXT
                || deal_issue.priority              ::TEXT
                || deal_issue.status                ::TEXT
                || deal_issue.summary               ::TEXT
                || party_contact.full_name          ::TEXT
                || main_contact.email_address       ::TEXT
                || main_contact.location_country    ::TEXT
                || deal.country                     ::TEXT
                || deal.region                      ::TEXT
                || party_organization.full_name     ::TEXT
                || deal.partner_identified_by       ::TEXT
                || deal.partner_qualified_by        ::TEXT
                || deal.partner_poc_done_by         ::TEXT
                || deal.partner_closed_by           ::TEXT
                || deal.partner_resold_by           ::TEXT
                || deal.partner_owned_by            ::TEXT
            )
        ) AS text_search_vector
    FROM core.deal_t AS deal
    JOIN core.issue_t AS deal_issue ON deal.fk_issue_id = deal_issue.issue_id
    JOIN core.contact_t AS main_contact ON deal.fk_contact_id = main_contact.contact_id
    JOIN core.party_t AS party_contact ON main_contact.fk_party_id = party_contact.party_id
    JOIN core.organization_t AS organization ON deal.fk_organization_id = organization.organization_id
    JOIN core.party_t AS party_organization ON organization.fk_party_id = party_organization.party_id
    WHERE deal.deal_id != -1
    )
    INSERT INTO mart.deal (
        activity
        ,pipedrive_link
        ,account
        ,customer
        ,title
        ,category
        ,deal_source
        ,deal_source_detail
        ,sale_stage
        ,deal_stage
        ,deal_status
        ,pipeline
        ,sla_priority
        ,usd_value
        ,reason_lost
        ,resulting_state
        ,jira_description
        ,jira_priority
        ,jira_status
        ,jira_summary
        ,contact_full_name
        ,contact_email
        ,contact_phone
        ,contact_country
        ,contact_full_address
        ,deal_country
        ,deal_region
        ,organization_name
        ,organization_country
        ,organization_full_address
        ,deal_owner
        ,partner_identified_by
        ,partner_qualified_by
        ,partner_poc_done_by
        ,partner_closed_by
        ,partner_resold_by
        ,partner_owned_by
        ,partner_supported_by
        ,creation_date
        ,creation_to_now_days
        ,creation_to_pilot_days
        ,creation_to_sale_days
        ,creation_to_deployment_days
        ,activation_date
        ,activation_to_now_days
        ,activation_to_pilot_days
        ,activation_to_sale_days
        ,activation_to_deployment_days
        ,pilot_date
        ,pilot_to_now_days
        ,pilot_to_sale_days
        ,pilot_to_deployment_days
        ,sale_date
        ,sale_to_now_days
        ,sale_to_deployment_days
        ,deployment_date
        ,deployment_to_now_days
        ,closed_date
        ,jira_link
        ,email_count
        ,text_search_vector
        ,text_search_include_emails_and_notes_vector
    )
    SELECT
        'http://METABASE/question/438' || '?' || 'pipedrive_deal_id' || '=' || deal.pipedrive_id AS activity
        ,'https://YOUR_PIPEDRIVE_HOST/deal/' || deal.pipedrive_id AS pipedrive_link
        ,deal_issue.account
        ,deal_issue.customer
        ,deal.title
        ,deal.category
        ,deal.deal_source
        ,deal.deal_source_detail
        ,CASE
            WHEN deal.lost_timestamp != TIMESTAMP_NEVER THEN 'Lost'
            WHEN deal_issue.sales_date != DATE_NEVER OR deal.won_timestamp != TIMESTAMP_NEVER THEN 'Sold'
            WHEN deal_issue.deployment_date != DATE_NEVER THEN 'Deployed'
            WHEN deal_issue.pilot_finished_date != DATE_NEVER THEN 'Pilot Finished'
            WHEN deal_issue.pilot_date != DATE_NEVER THEN 'Pilot'
            WHEN deal_issue.activation_timestamp != TIMESTAMP_NEVER THEN 'Activated'
            ELSE 'Inception'
        END AS sale_stage
        ,deal.stage deal_stage
        ,deal.status AS deal_status
        ,deal.pipeline
        ,deal_issue.sla_priority
        ,deal.usd_value
        ,deal.reason_lost
        ,deal.resulting_state
        ,deal_issue.description AS jira_description
        ,deal_issue.priority jira_priority
        ,deal_issue.status jira_status
        ,deal_issue.summary AS jira_summary
        ,party_contact.full_name AS contact_full_name
        ,main_contact.email_address AS contact_email
        ,main_contact.phone_number AS contact_phone
        ,main_contact.location_country AS contact_country
        ,main_contact.location_full AS contact_full_address
        ,organization.address_country AS deal_country
        ,organization.address_region AS deal_region
        ,party_organization.full_name AS organization_name
        ,organization.address_country AS organization_country
        ,organization.address_full AS organization_full_address
        ,employee_owner.full_name AS deal_owner
        ,deal.partner_identified_by
        ,deal.partner_qualified_by
        ,deal.partner_poc_done_by
        ,deal.partner_closed_by
        ,deal.partner_resold_by
        ,deal.partner_owned_by
        ,deal.partner_supported_by
        ,deal.created_timestamp::DATE AS creation_date
        ,deal_issue.inception_to_pilot_days
        ,deal_issue.inception_to_sales_days
        ,deal_issue.inception_to_deployment_days
        ,deal_issue.inception_to_now_days
        ,deal_issue.activation_timestamp::DATE AS activation_date
        ,CASE WHEN deal_issue.activation_to_now_days = -1 THEN NULL ELSE deal_issue.activation_to_now_days END AS activation_to_now_days
        ,CASE WHEN deal_issue.activation_to_pilot_days = -1 THEN NULL ELSE deal_issue.activation_to_pilot_days END AS activation_to_pilot_days
        ,CASE WHEN deal_issue.activation_to_sales_days = -1 THEN NULL ELSE deal_issue.activation_to_sales_days END AS activation_to_sales_days
        ,CASE WHEN deal_issue.activation_to_deployment_days = -1 THEN NULL ELSE deal_issue.activation_to_deployment_days END AS activation_to_deployment_days
        ,CASE WHEN deal_issue.pilot_date = DATE_NEVER THEN NULL ELSE deal_issue.pilot_date END AS pilot_date
        ,CASE WHEN deal_issue.pilot_to_now_days = -1 THEN NULL ELSE deal_issue.pilot_to_now_days END AS pilot_to_now_days
        ,CASE WHEN deal_issue.pilot_to_sales_days = -1 THEN NULL ELSE deal_issue.pilot_to_sales_days END AS pilot_to_sales_days
        ,CASE WHEN deal_issue.pilot_to_deployment_days = -1 THEN NULL ELSE deal_issue.pilot_to_deployment_days END AS pilot_to_deployment_days
        ,CASE WHEN deal_issue.sales_date = DATE_NEVER THEN NULL ELSE deal_issue.sales_date END AS sale_date
        ,CASE WHEN deal_issue.sales_to_now_days = -1 THEN NULL ELSE deal_issue.sales_to_now_days END AS sales_to_now_days
        ,CASE WHEN deal_issue.sales_to_deployment_days = -1 THEN NULL ELSE deal_issue.sales_to_deployment_days END AS sales_to_deployment_days
        ,CASE WHEN deal_issue.deployment_date = DATE_NEVER THEN NULL ELSE deal_issue.deployment_date END AS deployment_date
        ,CASE WHEN deal_issue.deployment_to_now_days = -1 THEN NULL ELSE deal_issue.deployment_to_now_days END AS deployment_to_now_days
        ,CASE WHEN deal.closed_timestamp = TIMESTAMP_NEVER THEN NULL ELSE deal.closed_timestamp::DATE END AS closed_date
        ,CASE WHEN deal_issue.jira_key = TEXT_NULL THEN TEXT_NULL
            ELSE 'https://JIRA/'::TEXT || deal_issue.jira_key
        END AS jira_link
        ,deal_email_count.email_count
        ,deal_text_search_vector.text_search_vector AS text_search_vector
        ,deal_text_search_include_emails_and_notes_vector.text_search_vector AS text_search_include_emails_and_notes_vector
    FROM core.deal_t AS deal
    JOIN deal_text_search_include_emails_and_notes_vector ON deal_text_search_include_emails_and_notes_vector.deal_id = deal.deal_id
    JOIN deal_text_search_vector ON deal_text_search_vector.deal_id = deal.deal_id
    JOIN deal_email_count ON deal_email_count.deal_id = deal.deal_id
    JOIN core.issue_t AS deal_issue ON deal.fk_issue_id = deal_issue.issue_id
    JOIN core.contact_t AS main_contact ON deal.fk_contact_id = main_contact.contact_id
    JOIN core.party_t AS party_contact ON main_contact.fk_party_id = party_contact.party_id
    JOIN core.organization_t AS organization ON deal.fk_organization_id = organization.organization_id
    JOIN core.party_t AS party_organization ON organization.fk_party_id = party_organization.party_id
    JOIN core.employee_t AS employee_owner ON deal.fk_employee_id_owner = employee_owner.employee_id
    WHERE deal.deal_id != -1;

    RETURN 0;

END;$$

LANGUAGE plpgsql
