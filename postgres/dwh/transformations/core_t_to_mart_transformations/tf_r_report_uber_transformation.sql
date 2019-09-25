CREATE OR REPLACE FUNCTION mart.tf_r_report_uber_transformation()
RETURNS INTEGER AS $$

DECLARE

stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    --  *** Clear all tables ***
    PERFORM mart.tf_u_clear_mart_tables();

    --  *** Sales ***
    PERFORM mart.tf_r_deal();
    PERFORM mart.tf_r_deal_to_be_closed_soon();
    PERFORM mart.tf_r_deal_activity();

    --  *** Development_And_Support ***
    PERFORM mart.tf_r_jira_account_dates();
    PERFORM mart.tf_r_bugs_per_account();
    PERFORM mart.tf_r_bugs_per_release(); 
    PERFORM mart.tf_r_hours_logged_per_account();
    PERFORM mart.tf_r_hours_logged_per_component();
    PERFORM mart.tf_r_hours_logged_per_issue();
    PERFORM mart.tf_r_bugs_per_component_per_release();	
    PERFORM mart.tf_r_bugs_created_after_affected_version_release();
    PERFORM mart.tf_r_bugs_created_after_fix_version_release();

    --  *** Finance ***
    PERFORM mart.tf_r_sales_report();
    PERFORM mart.tf_r_revenue_per_month_per_sale();
    PERFORM mart.tf_r_sales_report_extended();
    PERFORM mart.tf_r_sales_report_usd_revenue_broken_down_by_time();
    PERFORM mart.tf_r_sales_report_czk_revenue_broken_down_by_time();
    PERFORM mart.tf_r_sales_report_eur_revenue_broken_down_by_time();
    PERFORM mart.tf_r_revenue_by_time_report();
    PERFORM mart.tf_r_revenue_per_customer_by_time();
    PERFORM mart.tf_r_booking_per_revenue_type_per_month();
    PERFORM mart.tf_r_booking_per_revenue_type_per_quarter();
    PERFORM mart.tf_r_booking_per_revenue_type_per_year();
    PERFORM mart.tf_r_booking_by_time_report();

    --  *** Marketing ***
    PERFORM mart.tf_r_deal_reconnecting();
    PERFORM mart.tf_r_mailchimp_campaign_success_rate();

    --  *** Data Quality ***
    PERFORM mart.tf_r_partner_name_not_recognised();
    PERFORM mart.tf_r_duplicate_emails_in_contacts();
    PERFORM mart.tf_r_pipedrive_emails_not_in_mailchimp();
    PERFORM mart.tf_r_mailchimp_emails_not_in_pipedrive();
    PERFORM mart.tf_r_jira_support_issues_not_linked_with_pipedrive();
    PERFORM mart.tf_r_deal_pipedrive_close_date_differs_from_jira_sale_date();
    
    INSERT INTO etl_metadata.uber_transformation_call (
        transformation_name
        ,transformation_call_timestamp
        )
    VALUES (
        FUNCTION_NAME
        ,NOW()
	);

    RETURN 0;

END;$$

LANGUAGE plpgsql
