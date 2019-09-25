CREATE OR REPLACE FUNCTION mart.tf_r_deal_reconnecting()
RETURNS integer AS $$

BEGIN

    WITH
    deal_switched_to_reconnecting AS (
        SELECT
            today_deal.deal_id
            ,today_deal.pipedrive_id
            ,today_deal.title
            ,today_deal.fk_organization_id
            ,today_deal.fk_employee_id_owner
            ,hist_deal.previous_stage
            ,hist_deal.stage
            ,hist_deal.status
            ,hist_deal.last_updated_timestamp AS changed_to_reconnecting_stage_timestamp
            ,rank() OVER (
                PARTITION BY hist_deal.deal_key ORDER BY hist_deal.last_updated_timestamp DESC
                )
        FROM core.deal_t AS today_deal
        JOIN core.deal_ih AS hist_deal ON today_deal.deal_key = hist_deal.deal_key
        WHERE today_deal.stage = 'Reconnecting'
            AND COALESCE(hist_deal.previous_stage, '') != hist_deal.stage
        ORDER BY hist_deal.pipedrive_id
            ,hist_deal.last_updated_timestamp
        )
    ,aggregated_emails AS (
        SELECT
            fk_deal_id
            ,subject
            ,sent_timestamp
            ,string_agg(DISTINCT from_email_address, ', ') AS from_email
            ,string_agg(DISTINCT to_email_address, ', ') AS to_email
            ,string_agg(DISTINCT cc_email_address, ', ') AS cc_email
            ,body_snippet
            ,body_url
            ,pipedrive_mail_message_id
            ,pipedrive_mail_thread_id
            ,read_flag
        FROM core.mail_message_t
        WHERE fk_deal_id != - 1
        GROUP BY fk_deal_id
            ,subject
            ,sent_timestamp
            ,body_snippet
            ,body_url
            ,pipedrive_mail_message_id
            ,pipedrive_mail_thread_id
            ,read_flag
        )
    INSERT INTO mart.deal_reconnecting (
        previous_stage
        ,stage
        ,status
        ,organization
        ,deal_owner
        ,deal_link
        ,changed_to_reconnecting_stage_timestamp
        ,days_in_reconnecting_stage
        ,email_sent_timestamp
        ,days_since_last_reconnecting_email
        ,from_email
        ,to_email
        ,cc_email
        ,email_subject
        ,email_body_snippet
        ,emal_body_url
        ,email_exists
        )
    SELECT
        deal_switched_to_reconnecting.previous_stage
        ,deal_switched_to_reconnecting.stage
        ,deal_switched_to_reconnecting.status
        ,deal_organization_party.full_name AS organziation
        ,deal_owner.full_name AS deal_owner
        ,'https://YOUR_PIPEDRIVEHOST/deal/' || deal_switched_to_reconnecting.pipedrive_id AS deal_link
        ,deal_switched_to_reconnecting.changed_to_reconnecting_stage_timestamp
        ,tf_u_days_diff_between_dates(now()::DATE, deal_switched_to_reconnecting.changed_to_reconnecting_stage_timestamp::DATE) AS days_in_reconnecting_stage
        ,aggregated_emails.sent_timestamp AS email_sent_timestamp
        ,tf_u_days_diff_between_dates(now()::DATE, aggregated_emails.sent_timestamp::DATE) AS days_since_last_reconnecting_email
        ,aggregated_emails.from_email
        ,aggregated_emails.to_email
        ,aggregated_emails.cc_email
        ,aggregated_emails.subject AS email_subject
        ,aggregated_emails.body_snippet AS email_body_snippet
        ,aggregated_emails.body_url AS emal_body_url
        ,CASE 
            WHEN aggregated_emails.subject IS NULL
                THEN 0
            ELSE 1
        END AS email_exists
    FROM deal_switched_to_reconnecting
    JOIN core.employee_t AS deal_owner ON deal_owner.employee_id = deal_switched_to_reconnecting.fk_employee_id_owner
    LEFT JOIN core.organization_t AS deal_organization ON deal_organization.organization_id = deal_switched_to_reconnecting.fk_organization_id
        AND organization_id != - 1
    LEFT JOIN core.party_t AS deal_organization_party ON deal_organization_party.party_id = deal_organization.fk_party_id
    LEFT JOIN aggregated_emails ON deal_switched_to_reconnecting.deal_id = aggregated_emails.fk_deal_id
        AND aggregated_emails.sent_timestamp >= deal_switched_to_reconnecting.changed_to_reconnecting_stage_timestamp
    WHERE rank = 1;

    RETURN 0;

END;$$

LANGUAGE plpgsql

