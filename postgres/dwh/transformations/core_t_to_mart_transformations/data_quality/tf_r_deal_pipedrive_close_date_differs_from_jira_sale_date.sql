CREATE OR REPLACE FUNCTION mart.tf_r_deal_pipedrive_close_date_differs_from_jira_sale_date()
RETURNS INTEGER AS $$

BEGIN

    INSERT INTO mart.deal_pipedrive_close_date_differs_from_jira_sale_date (
        title
        ,pipedrive_link
        ,jira_link
        ,organization_name
        ,contact_full_name
        ,deal_status
        ,jira_status
        ,deal_stage
        ,deal_owner
        ,closed_date
        ,sale_date
        )
    SELECT
        title
        ,pipedrive_link
        ,jira_link
        ,organization_name
        ,contact_full_name
        ,deal_status
        ,jira_status
        ,deal_stage
        ,deal_owner
        ,closed_date
        ,sale_date
    FROM mart.deal
    WHERE closed_date != sale_date;

    RETURN 0;

END;$$

LANGUAGE plpgsql;
