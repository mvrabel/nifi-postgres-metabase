CREATE OR REPLACE FUNCTION mart.tf_r_jira_account_dates()
RETURNS integer AS $$

DECLARE

DEVELOPMENT_PROJECT_KEY TEXT := 'DEV';
SUPPORT_ISSUE_FLAG TEXT := 'Support';

TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);

BEGIN

    INSERT INTO mart.jira_account_dates (
        jira_issue_key
        ,account
        ,customer
        ,summary
        ,issue_status
        ,priority
        ,inception_date
        ,activation_date
        ,pilot_date
        ,sales_date
        ,deployment_date
        ,pilot_date_exists
        ,pilot_finished_date_exists
        ,sales_date_exists
        ,deployment_date_exists
        ,inception_to_first_response_days
        ,inception_to_pilot_days
        ,inception_to_sales_days
        ,inception_to_deployment_days
        ,inception_to_resolution_days
        ,inception_to_now_days
        ,first_response_to_resolution_days
        ,activation_to_pilot_days
        ,activation_to_sales_days
        ,activation_to_deployment_days
        ,activation_to_now_days
        ,pilot_to_pilot_finished_days
        ,pilot_to_sales_days
        ,pilot_to_deployment_days
        ,pilot_to_now_days
        ,pilot_finished_to_sales_days
        ,pilot_finished_to_now_days
        ,sales_to_deployment_days
        ,deployment_to_now_days
        ,sales_to_now_days
        ,hours_logged
        ,deal_source
        ,deal_status
        ,stage
        ,usd_value
        ,industry
        ,partner_identified_by
        ,partner_qualified_by
        ,partner_poc_done_by
        ,partner_closed_by
        ,partner_resold_by
        ,partner_supported_by
    )
    SELECT 
        issue.jira_key AS jira_issue_key
        ,issue.account
        ,issue.customer
        ,issue.summary
        ,issue.status AS issue_status
        ,issue.priority
        ,CASE WHEN issue.fk_date_id_inception_date = -1 THEN NULL ELSE issue.inception_date END AS inception_date
        ,CASE WHEN issue.fk_date_id_activation_date = -1 THEN NULL ELSE issue.activation_timestamp::DATE END AS activation_date
        ,CASE WHEN issue.fk_date_id_pilot_date = -1 THEN NULL ELSE issue.pilot_date END AS pilot_date
        ,CASE WHEN issue.fk_date_id_sales_date = -1 THEN NULL ELSE issue.sales_date END AS sales_date
        ,CASE WHEN issue.fk_date_id_deployment_date = -1 THEN NULL ELSE issue.deployment_date END AS deployment_date
        ,CASE WHEN issue.fk_date_id_pilot_date = -1 THEN 0 ELSE 1 END AS pilot_date_exists
        ,CASE WHEN issue.fk_date_id_pilot_finished_date = -1 THEN 0 ELSE 1 END AS pilot_finished_date_exists
        ,CASE WHEN issue.fk_date_id_sales_date = -1 THEN 0 ELSE 1 END AS sales_date_exists
        ,CASE WHEN issue.fk_date_id_deployment_date = -1 THEN 0 ELSE 1 END AS deployment_date_exists
        
        ,CASE WHEN issue.inception_to_first_response_days   = -1 THEN NULL ELSE issue.inception_to_first_response_days  END AS inception_to_first_response_days
        ,CASE WHEN issue.inception_to_pilot_days            = -1 THEN NULL ELSE issue.inception_to_pilot_days           END AS inception_to_pilot_days
        ,CASE WHEN issue.inception_to_sales_days            = -1 THEN NULL ELSE issue.inception_to_sales_days           END AS inception_to_sales_days
        ,CASE WHEN issue.inception_to_deployment_days       = -1 THEN NULL ELSE issue.inception_to_deployment_days      END AS inception_to_deployment_days
        ,CASE WHEN issue.inception_to_resolution_days       = -1 THEN NULL ELSE issue.inception_to_resolution_days      END AS inception_to_resolution_days
        ,CASE WHEN issue.inception_to_now_days              = -1 THEN NULL ELSE issue.inception_to_now_days             END AS inception_to_now_days
        ,CASE WHEN issue.first_response_to_resolution_days  = -1 THEN NULL ELSE issue.first_response_to_resolution_days END AS first_response_to_resolution_days
        ,CASE WHEN issue.activation_to_pilot_days           = -1 THEN NULL ELSE issue.activation_to_pilot_days          END AS activation_to_pilot_days
        ,CASE WHEN issue.activation_to_sales_days           = -1 THEN NULL ELSE issue.activation_to_sales_days          END AS activation_to_sales_days
        ,CASE WHEN issue.activation_to_deployment_days      = -1 THEN NULL ELSE issue.activation_to_deployment_days     END AS activation_to_deployment_days
        ,CASE WHEN issue.activation_to_now_days             = -1 THEN NULL ELSE issue.activation_to_now_days            END AS activation_to_now_days
        ,CASE WHEN issue.pilot_to_pilot_finished_days       = -1 THEN NULL ELSE issue.pilot_to_pilot_finished_days      END AS pilot_to_pilot_finished_days
        ,CASE WHEN issue.pilot_to_sales_days                = -1 THEN NULL ELSE issue.pilot_to_sales_days               END AS pilot_to_sales_days
        ,CASE WHEN issue.pilot_to_deployment_days           = -1 THEN NULL ELSE issue.pilot_to_deployment_days          END AS pilot_to_deployment_days
        ,CASE WHEN issue.pilot_to_now_days                  = -1 THEN NULL ELSE issue.pilot_to_now_days                 END AS pilot_to_now_days
        ,CASE WHEN issue.pilot_finished_to_sales_days       = -1 THEN NULL ELSE issue.pilot_finished_to_sales_days      END AS pilot_finished_to_sales_days
        ,CASE WHEN issue.pilot_finished_to_now_days         = -1 THEN NULL ELSE issue.pilot_finished_to_now_days        END AS pilot_finished_to_now_days
        ,CASE WHEN issue.sales_to_deployment_days           = -1 THEN NULL ELSE issue.sales_to_deployment_days          END AS sales_to_deployment_days
        ,CASE WHEN issue.sales_to_now_days                  = -1 THEN NULL ELSE issue.sales_to_now_days                 END AS sales_to_now_days
        ,CASE WHEN issue.deployment_to_now_days             = -1 THEN NULL ELSE issue.deployment_to_now_days            END AS deployment_to_now_days
        ,CASE WHEN issue.hours_logged_total                 = -1 THEN 0    ELSE issue.hours_logged_total    END AS hours_logged
        ,COALESCE(deal.deal_source, TEXT_NULL) AS deal_source
        ,COALESCE(deal.status, TEXT_NULL) AS deal_status
        ,COALESCE(deal.stage,TEXT_NULL) AS stage
        ,COALESCE(deal.usd_value, 0) AS usd_value
        ,COALESCE(deal.industry, TEXT_NULL) AS industry
        ,COALESCE(deal.partner_identified_by, TEXT_NULL) AS partner_identified_by
        ,COALESCE(deal.partner_qualified_by, TEXT_NULL) AS partner_qualified_by
        ,COALESCE(deal.partner_poc_done_by, TEXT_NULL) AS partner_poc_done_by
        ,COALESCE(deal.partner_closed_by, TEXT_NULL) AS partner_closed_by
        ,COALESCE(deal.partner_resold_by, TEXT_NULL) AS partner_resold_by
        ,COALESCE(deal.partner_supported_by, TEXT_NULL) AS partner_supported_by
    FROM core.issue_t AS issue
    JOIN core.project_t AS project ON project.project_id = issue.fk_project_id
    LEFT JOIN core.deal_t AS deal ON deal.fk_issue_id = issue.issue_id
    WHERE project.jira_key = DEVELOPMENT_PROJECT_KEY
        AND issue.issue_type = SUPPORT_ISSUE_FLAG
        AND issue.issue_id != -1;

    RETURN 0;

END;$$

LANGUAGE plpgsql