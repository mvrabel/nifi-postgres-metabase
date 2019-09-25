--
-- Name: booking_by_time_report; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.booking_by_time_report (
    revenue_type text NOT NULL,
    "01 2016" numeric(10,2) NOT NULL,
    "02 2016" numeric(10,2) NOT NULL,
    "03 2016" numeric(10,2) NOT NULL,
    "Q1 2016" numeric(10,2) NOT NULL,
    "04 2016" numeric(10,2) NOT NULL,
    "05 2016" numeric(10,2) NOT NULL,
    "06 2016" numeric(10,2) NOT NULL,
    "Q2 2016" numeric(10,2) NOT NULL,
    "07 2016" numeric(10,2) NOT NULL,
    "08 2016" numeric(10,2) NOT NULL,
    "09 2016" numeric(10,2) NOT NULL,
    "Q3 2016" numeric(10,2) NOT NULL,
    "10 2016" numeric(10,2) NOT NULL,
    "11 2016" numeric(10,2) NOT NULL,
    "12 2016" numeric(10,2) NOT NULL,
    "Q4 2016" numeric(10,2) NOT NULL,
    "2016 Total" numeric(10,2) NOT NULL,
    "01 2017" numeric(10,2) NOT NULL,
    "02 2017" numeric(10,2) NOT NULL,
    "03 2017" numeric(10,2) NOT NULL,
    "Q1 2017" numeric(10,2) NOT NULL,
    "04 2017" numeric(10,2) NOT NULL,
    "05 2017" numeric(10,2) NOT NULL,
    "06 2017" numeric(10,2) NOT NULL,
    "Q2 2017" numeric(10,2) NOT NULL,
    "07 2017" numeric(10,2) NOT NULL,
    "08 2017" numeric(10,2) NOT NULL,
    "09 2017" numeric(10,2) NOT NULL,
    "Q3 2017" numeric(10,2) NOT NULL,
    "10 2017" numeric(10,2) NOT NULL,
    "11 2017" numeric(10,2) NOT NULL,
    "12 2017" numeric(10,2) NOT NULL,
    "Q4 2017" numeric(10,2) NOT NULL,
    "2017 Total" numeric(10,2) NOT NULL,
    "01 2018" numeric(10,2) NOT NULL,
    "02 2018" numeric(10,2) NOT NULL,
    "03 2018" numeric(10,2) NOT NULL,
    "Q1 2018" numeric(10,2) NOT NULL,
    "04 2018" numeric(10,2) NOT NULL,
    "05 2018" numeric(10,2) NOT NULL,
    "06 2018" numeric(10,2) NOT NULL,
    "Q2 2018" numeric(10,2) NOT NULL,
    "07 2018" numeric(10,2) NOT NULL,
    "08 2018" numeric(10,2) NOT NULL,
    "09 2018" numeric(10,2) NOT NULL,
    "Q3 2018" numeric(10,2) NOT NULL,
    "10 2018" numeric(10,2) NOT NULL,
    "11 2018" numeric(10,2) NOT NULL,
    "12 2018" numeric(10,2) NOT NULL,
    "Q4 2018" numeric(10,2) NOT NULL,
    "2018 Total" numeric(10,2) NOT NULL,
    "01 2019" numeric(10,2) NOT NULL,
    "02 2019" numeric(10,2) NOT NULL,
    "03 2019" numeric(10,2) NOT NULL,
    "04 2019" numeric(10,2) NOT NULL,
    "05 2019" numeric(10,2) NOT NULL,
    "06 2019" numeric(10,2) NOT NULL,
    "07 2019" numeric(10,2) NOT NULL,
    "08 2019" numeric(10,2) NOT NULL,
    "09 2019" numeric(10,2) NOT NULL,
    "10 2019" numeric(10,2) NOT NULL,
    "11 2019" numeric(10,2) NOT NULL,
    "12 2019" numeric(10,2) NOT NULL,
    "Q1 2019" numeric(10,2) NOT NULL,
    "Q2 2019" numeric(10,2) NOT NULL,
    "Q3 2019" numeric(10,2) NOT NULL,
    "Q4 2019" numeric(10,2) NOT NULL,
    "2019 Total" numeric(10,2) NOT NULL,
    "01 2020" numeric(10,2) NOT NULL,
    "02 2020" numeric(10,2) NOT NULL,
    "03 2020" numeric(10,2) NOT NULL,
    "04 2020" numeric(10,2) NOT NULL,
    "05 2020" numeric(10,2) NOT NULL,
    "06 2020" numeric(10,2) NOT NULL,
    "07 2020" numeric(10,2) NOT NULL,
    "08 2020" numeric(10,2) NOT NULL,
    "09 2020" numeric(10,2) NOT NULL,
    "10 2020" numeric(10,2) NOT NULL,
    "11 2020" numeric(10,2) NOT NULL,
    "12 2020" numeric(10,2) NOT NULL,
    "Q1 2020" numeric(10,2) NOT NULL,
    "Q2 2020" numeric(10,2) NOT NULL,
    "Q3 2020" numeric(10,2) NOT NULL,
    "Q4 2020" numeric(10,2) NOT NULL,
    "2020 Total" numeric(10,2) NOT NULL
);



--
-- Name: booking_per_revenue_type_per_month; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.booking_per_revenue_type_per_month (
    booking_month_year text NOT NULL,
    revenue_type text NOT NULL,
    booked_usd_amount numeric(10,2) NOT NULL,
    booking_month integer NOT NULL,
    booking_quarter integer NOT NULL,
    booking_year integer NOT NULL
);



--
-- Name: booking_per_revenue_type_per_quarter; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.booking_per_revenue_type_per_quarter (
    booking_quarter_year text NOT NULL,
    revenue_type text NOT NULL,
    booked_usd_amount numeric(10,2) NOT NULL,
    booking_quarter integer NOT NULL,
    booking_year integer NOT NULL
);



--
-- Name: booking_per_revenue_type_per_year; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.booking_per_revenue_type_per_year (
    booking_year integer NOT NULL,
    revenue_type text NOT NULL,
    booked_usd_amount numeric(10,2)
);



--
-- Name: bugs_created_after_affected_version_release; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.bugs_created_after_affected_version_release (
    affected_version_name text NOT NULL,
    affected_version_number integer NOT NULL,
    bug_key text NOT NULL,
    bug_summary text,
    bug_creation_date timestamp with time zone NOT NULL,
    affected_version_release_date timestamp with time zone NOT NULL
);



--
-- Name: bugs_created_after_fix_version_release; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.bugs_created_after_fix_version_release (
    fix_version_name text NOT NULL,
    fix_version_number integer NOT NULL,
    bug_key text NOT NULL,
    bug_summary text,
    bug_creation_date timestamp with time zone NOT NULL,
    fix_version_release_date timestamp with time zone NOT NULL
);



--
-- Name: deal; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.deal (
    activity text,
    pipedrive_link text NOT NULL,
    account text,
    customer text,
    title text NOT NULL,
    category text NOT NULL,
    deal_source text,
    deal_source_detail text,
    sale_stage text NOT NULL,
    deal_stage text NOT NULL,
    deal_status text,
    pipeline text NOT NULL,
    sla_priority text,
    usd_value bigint,
    reason_lost text,
    resulting_state text,
    jira_description text,
    jira_priority text,
    jira_status text,
    jira_summary text,
    next_step text,
    next_step_timestamp timestamp with time zone,
    last_step text,
    last_step_timestamp timestamp with time zone,
    contact_full_name text,
    contact_email text,
    contact_phone text,
    contact_country text,
    contact_full_address text,
    deal_country text,
    deal_region text,
    organization_name text,
    organization_country text,
    organization_full_address text,
    deal_owner text NOT NULL,
    email_count integer,
    partner_identified_by text NOT NULL,
    partner_qualified_by text,
    partner_poc_done_by text,
    partner_closed_by text,
    partner_resold_by text,
    partner_owned_by text,
    partner_supported_by text,
    creation_date date NOT NULL,
    creation_to_now_days integer,
    creation_to_pilot_days integer,
    creation_to_sale_days integer,
    creation_to_deployment_days integer,
    activation_date date,
    activation_to_now_days integer,
    activation_to_pilot_days integer,
    activation_to_sale_days integer,
    activation_to_deployment_days integer,
    pilot_date date,
    pilot_to_now_days integer,
    pilot_to_sale_days integer,
    pilot_to_deployment_days integer,
    sale_date date,
    sale_to_now_days integer,
    sale_to_deployment_days integer,
    deployment_date date,
    deployment_to_now_days integer,
    closed_date date,
    jira_link text,
    text_search_vector tsvector,
    text_search_include_emails_and_notes_vector tsvector
);



--
-- Name: deal_activity; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.deal_activity (
    source_system_link text NOT NULL,
    activity_type text NOT NULL,
    new_value text,
    previous_value text,
    activity_timestamp timestamp with time zone NOT NULL,
    done_by text NOT NULL,
    source_system text NOT NULL,
    activity_detail text,
    pipedrive_deal_id text NOT NULL,
    from_email text,
    to_email text
);



--
-- Name: deal_pipedrive_close_date_differs_from_jira_sale_date; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.deal_pipedrive_close_date_differs_from_jira_sale_date (
    title text NOT NULL,
    pipedrive_link text NOT NULL,
    jira_link text NOT NULL,
    organization_name text,
    contact_full_name text,
    deal_status text,
    jira_status text NOT NULL,
    deal_stage text,
    deal_owner text NOT NULL,
    closed_date date NOT NULL,
    sale_date date NOT NULL
);



--
-- Name: deal_reconnecting; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.deal_reconnecting (
    previous_stage text,
    stage text,
    organization text,
    deal_owner text,
    deal_link text,
    changed_to_reconnecting_stage_timestamp timestamp with time zone,
    days_in_reconnecting_stage integer,
    email_sent_timestamp timestamp with time zone,
    days_since_last_reconnecting_email integer,
    from_email text,
    to_email text,
    cc_email text,
    email_subject text,
    email_body_snippet text,
    emal_body_url text,
    email_exists integer,
    status text
);



--
-- Name: deal_to_be_closed_soon; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.deal_to_be_closed_soon (
    activity text,
    pipedrive_link text NOT NULL,
    account text,
    customer text,
    title text NOT NULL,
    category text,
    deal_source text,
    deal_source_detail text,
    sale_stage text NOT NULL,
    deal_stage text NOT NULL,
    deal_status text,
    pipeline text NOT NULL,
    sla_priority text,
    usd_value bigint,
    reason_lost text,
    resulting_state text,
    jira_description text,
    jira_priority text,
    jira_status text,
    jira_summary text,
    next_step text,
    next_step_timestamp timestamp with time zone,
    last_step text,
    last_step_timestamp timestamp with time zone,
    contact_full_name text,
    contact_email text,
    contact_phone text,
    contact_country text,
    contact_full_address text,
    deal_country text,
    deal_region text,
    organization_name text,
    organization_country text,
    organization_full_address text,
    deal_owner text NOT NULL,
    partner_identified_by text,
    partner_qualified_by text,
    partner_poc_done_by text,
    partner_closed_by text,
    partner_resold_by text,
    partner_owned_by text,
    partner_supported_by text,
    creation_date date NOT NULL,
    creation_to_now_days integer,
    creation_to_pilot_days integer,
    creation_to_sale_days integer,
    creation_to_deployment_days integer,
    activation_date date,
    activation_to_now_days integer,
    activation_to_pilot_days integer,
    activation_to_sale_days integer,
    activation_to_deployment_days integer,
    pilot_date date,
    pilot_to_now_days integer,
    pilot_to_sale_days integer,
    pilot_to_deployment_days integer,
    sale_date date,
    sale_to_now_days integer,
    sale_to_deployment_days integer,
    deployment_date date,
    deployment_to_now_days integer,
    closed_date date,
    jira_link text
);



--
-- Name: duplicate_emails_in_contacts; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.duplicate_emails_in_contacts (
    email text NOT NULL,
    contact_name text NOT NULL,
    organization_name text,
    pipedrive_link text NOT NULL
);



--
-- Name: emails_in_mailchimp_and_crm; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.emails_in_mailchimp_and_crm (
    contact_name text,
    contact_email text NOT NULL,
    pipedrive_link text NOT NULL,
    contact_owner text NOT NULL,
    mailchimp_link text NOT NULL
);



--
-- Name: jira_account_dates; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.jira_account_dates (
    account text NOT NULL,
    inception_date timestamp with time zone NOT NULL,
    pilot_date date,
    sales_date date,
    inception_to_pilot_days integer,
    inception_to_sales_days integer,
    pilot_to_sales_days integer,
    summary text NOT NULL,
    pilot_date_exists integer DEFAULT 0 NOT NULL,
    sales_date_exists integer DEFAULT 0 NOT NULL,
    activation_date date NOT NULL,
    issue_status text NOT NULL,
    activation_to_pilot_days integer,
    activation_to_sales_days integer,
    priority text,
    jira_issue_key text,
    inception_to_now_days integer,
    activation_to_now_days integer,
    pilot_to_now_days integer,
    sales_to_now_days integer,
    hours_logged numeric(10,2) DEFAULT 0 NOT NULL,
    deployment_date date,
    deployment_date_exists integer NOT NULL,
    pilot_to_deployment_days integer,
    sales_to_deployment_days integer,
    customer text,
    stage text,
    deal_source text,
    partner_identified_by text,
    partner_qualified_by text,
    partner_poc_done_by text,
    partner_closed_by text,
    partner_resold_by text,
    partner_supported_by text,
    usd_value integer,
    industry text,
    deal_status text,
    pilot_finished_date_exists integer,
    inception_to_first_response_days integer,
    inception_to_deployment_days integer,
    inception_to_resolution_days integer,
    first_response_to_resolution_days integer,
    activation_to_deployment_days integer,
    deployment_to_now_days integer,
    pilot_finished_to_now_days integer,
    pilot_finished_to_sales_days integer,
    pilot_to_pilot_finished_days integer
);



--
-- Name: jira_support_issues_not_linked_with_pipedrive; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.jira_support_issues_not_linked_with_pipedrive (
    jira_key text NOT NULL,
    summary text NOT NULL,
    status text NOT NULL,
    account text,
    link_to_issue text NOT NULL,
    customer text
);



--
-- Name: mailchimp_campaign_success_rate; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.mailchimp_campaign_success_rate (
    campaign_title text,
    campaign_type text,
    used_timewarp boolean,
    total_open_to_unique_open_rate real,
    unique_opens_total integer,
    opens_total integer,
    send_timestamp timestamp with time zone,
    sent_to_mailing_list text,
    optional_mailing_list_segment_filter text,
    avg_list_open_rate real
);



--
-- Name: mailchimp_emails_not_in_pipedrive; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.mailchimp_emails_not_in_pipedrive (
    contact_name text,
    contact_email text NOT NULL,
    mailing_list_name text NOT NULL,
    mailing_list_link text NOT NULL
);


--
-- Name: partner_name_not_recognised; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.partner_name_not_recognised (
    deal_title text NOT NULL,
    deal_stage text NOT NULL,
    partner_name text NOT NULL,
    partner_type text NOT NULL,
    pipedrive_link text NOT NULL
);



--
-- Name: pipedrive_emails_not_in_mailchimp; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.pipedrive_emails_not_in_mailchimp (
    contact_name text,
    contact_email text NOT NULL,
    pipedrive_link text NOT NULL,
    contact_owner text NOT NULL
);



--
-- Name: report_bugs_per_account; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.report_bugs_per_account (
    account text NOT NULL,
    priority text,
    sla_priority text,
    first_response_to_resolution_hours numeric(10,2),
    created_to_resoluion_hours numeric(10,2),
    created_to_first_response_hours numeric(10,2),
    deployment text,
    created_bugs_number integer NOT NULL,
    resolved_bugs_number integer NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    resolution_timestamp timestamp with time zone,
    first_response_timestamp timestamp with time zone,
    customer text
);



--
-- Name: report_bugs_per_component_pre_release; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.report_bugs_per_component_pre_release (
    release_name text NOT NULL,
    component text NOT NULL,
    bugs_number integer NOT NULL,
    bug_created_at timestamp with time zone NOT NULL,
    bug_resolved_at timestamp with time zone,
    project_key text NOT NULL,
    release_number integer NOT NULL
);



--
-- Name: report_bugs_per_release; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.report_bugs_per_release (
    release_name text NOT NULL,
    project_key text NOT NULL,
    bug_number integer NOT NULL,
    bug_key text NOT NULL,
    bug_summary text NOT NULL,
    release_number integer NOT NULL
);



--
-- Name: report_hours_logged_per_account; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.report_hours_logged_per_account (
    account text,
    employee text NOT NULL,
    hours_logged numeric(10,2) NOT NULL,
    work_started_at_timestamp timestamp with time zone NOT NULL,
    customer text
);



--
-- Name: report_hours_logged_per_component; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.report_hours_logged_per_component (
    component text,
    employee text NOT NULL,
    hours_logged numeric(10,2) NOT NULL,
    work_started_at_timestamp timestamp with time zone NOT NULL,
    project_key text NOT NULL,
    project_name text NOT NULL,
    release_name text,
    release_number integer
);



--
-- Name: report_hours_logged_per_issue; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.report_hours_logged_per_issue (
    issue_key text NOT NULL,
    project_key text NOT NULL,
    employee text NOT NULL,
    hours_logged numeric(10,2) NOT NULL,
    work_started_at_timestamp timestamp with time zone NOT NULL,
    issue_summary text
);



--
-- Name: revenue_by_time_report; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.revenue_by_time_report (
    revenue_type text NOT NULL,
    "01 2016" numeric(10,2) NOT NULL,
    "02 2016" numeric(10,2) NOT NULL,
    "03 2016" numeric(10,2) NOT NULL,
    "Q1 2016" numeric(10,2) NOT NULL,
    "04 2016" numeric(10,2) NOT NULL,
    "05 2016" numeric(10,2) NOT NULL,
    "06 2016" numeric(10,2) NOT NULL,
    "Q2 2016" numeric(10,2) NOT NULL,
    "07 2016" numeric(10,2) NOT NULL,
    "08 2016" numeric(10,2) NOT NULL,
    "09 2016" numeric(10,2) NOT NULL,
    "Q3 2016" numeric(10,2) NOT NULL,
    "10 2016" numeric(10,2) NOT NULL,
    "11 2016" numeric(10,2) NOT NULL,
    "12 2016" numeric(10,2) NOT NULL,
    "Q4 2016" numeric(10,2) NOT NULL,
    "2016 Total" numeric(10,2) NOT NULL,
    "01 2017" numeric(10,2) NOT NULL,
    "02 2017" numeric(10,2) NOT NULL,
    "03 2017" numeric(10,2) NOT NULL,
    "Q1 2017" numeric(10,2) NOT NULL,
    "04 2017" numeric(10,2) NOT NULL,
    "05 2017" numeric(10,2) NOT NULL,
    "06 2017" numeric(10,2) NOT NULL,
    "Q2 2017" numeric(10,2) NOT NULL,
    "07 2017" numeric(10,2) NOT NULL,
    "08 2017" numeric(10,2) NOT NULL,
    "09 2017" numeric(10,2) NOT NULL,
    "Q3 2017" numeric(10,2) NOT NULL,
    "10 2017" numeric(10,2) NOT NULL,
    "11 2017" numeric(10,2) NOT NULL,
    "12 2017" numeric(10,2) NOT NULL,
    "Q4 2017" numeric(10,2) NOT NULL,
    "2017 Total" numeric(10,2) NOT NULL,
    "01 2018" numeric(10,2) NOT NULL,
    "02 2018" numeric(10,2) NOT NULL,
    "03 2018" numeric(10,2) NOT NULL,
    "Q1 2018" numeric(10,2) NOT NULL,
    "04 2018" numeric(10,2) NOT NULL,
    "05 2018" numeric(10,2) NOT NULL,
    "06 2018" numeric(10,2) NOT NULL,
    "Q2 2018" numeric(10,2) NOT NULL,
    "07 2018" numeric(10,2) NOT NULL,
    "08 2018" numeric(10,2) NOT NULL,
    "09 2018" numeric(10,2) NOT NULL,
    "Q3 2018" numeric(10,2) NOT NULL,
    "10 2018" numeric(10,2) NOT NULL,
    "11 2018" numeric(10,2) NOT NULL,
    "12 2018" numeric(10,2) NOT NULL,
    "Q4 2018" numeric(10,2) NOT NULL,
    "2018 Total" numeric(10,2) NOT NULL,
    seller text NOT NULL,
    "01 2019" numeric(10,2) NOT NULL,
    "02 2019" numeric(10,2) NOT NULL,
    "03 2019" numeric(10,2) NOT NULL,
    "04 2019" numeric(10,2) NOT NULL,
    "05 2019" numeric(10,2) NOT NULL,
    "06 2019" numeric(10,2) NOT NULL,
    "07 2019" numeric(10,2) NOT NULL,
    "08 2019" numeric(10,2) NOT NULL,
    "09 2019" numeric(10,2) NOT NULL,
    "10 2019" numeric(10,2) NOT NULL,
    "11 2019" numeric(10,2) NOT NULL,
    "12 2019" numeric(10,2) NOT NULL,
    "Q1 2019" numeric(10,2) NOT NULL,
    "Q2 2019" numeric(10,2) NOT NULL,
    "Q3 2019" numeric(10,2) NOT NULL,
    "Q4 2019" numeric(10,2) NOT NULL,
    "2019 Total" numeric(10,2) NOT NULL,
    "01 2020" numeric(10,2) NOT NULL,
    "02 2020" numeric(10,2) NOT NULL,
    "03 2020" numeric(10,2) NOT NULL,
    "04 2020" numeric(10,2) NOT NULL,
    "05 2020" numeric(10,2) NOT NULL,
    "06 2020" numeric(10,2) NOT NULL,
    "07 2020" numeric(10,2) NOT NULL,
    "08 2020" numeric(10,2) NOT NULL,
    "09 2020" numeric(10,2) NOT NULL,
    "10 2020" numeric(10,2) NOT NULL,
    "11 2020" numeric(10,2) NOT NULL,
    "12 2020" numeric(10,2) NOT NULL,
    "Q1 2020" numeric(10,2) NOT NULL,
    "Q2 2020" numeric(10,2) NOT NULL,
    "Q3 2020" numeric(10,2) NOT NULL,
    "Q4 2020" numeric(10,2) NOT NULL,
    "2020 Total" numeric(10,2) NOT NULL
);



--
-- Name: revenue_per_customer_by_time; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.revenue_per_customer_by_time (
    customer text NOT NULL,
    "01 2016" numeric(10,2) NOT NULL,
    "02 2016" numeric(10,2) NOT NULL,
    "03 2016" numeric(10,2) NOT NULL,
    "Q1 2016" numeric(10,2) NOT NULL,
    "04 2016" numeric(10,2) NOT NULL,
    "05 2016" numeric(10,2) NOT NULL,
    "06 2016" numeric(10,2) NOT NULL,
    "Q2 2016" numeric(10,2) NOT NULL,
    "07 2016" numeric(10,2) NOT NULL,
    "08 2016" numeric(10,2) NOT NULL,
    "09 2016" numeric(10,2) NOT NULL,
    "Q3 2016" numeric(10,2) NOT NULL,
    "10 2016" numeric(10,2) NOT NULL,
    "11 2016" numeric(10,2) NOT NULL,
    "12 2016" numeric(10,2) NOT NULL,
    "Q4 2016" numeric(10,2) NOT NULL,
    "2016 Total" numeric(10,2) NOT NULL,
    "01 2017" numeric(10,2) NOT NULL,
    "02 2017" numeric(10,2) NOT NULL,
    "03 2017" numeric(10,2) NOT NULL,
    "Q1 2017" numeric(10,2) NOT NULL,
    "04 2017" numeric(10,2) NOT NULL,
    "05 2017" numeric(10,2) NOT NULL,
    "06 2017" numeric(10,2) NOT NULL,
    "Q2 2017" numeric(10,2) NOT NULL,
    "07 2017" numeric(10,2) NOT NULL,
    "08 2017" numeric(10,2) NOT NULL,
    "09 2017" numeric(10,2) NOT NULL,
    "Q3 2017" numeric(10,2) NOT NULL,
    "10 2017" numeric(10,2) NOT NULL,
    "11 2017" numeric(10,2) NOT NULL,
    "12 2017" numeric(10,2) NOT NULL,
    "Q4 2017" numeric(10,2) NOT NULL,
    "2017 Total" numeric(10,2) NOT NULL,
    "01 2018" numeric(10,2) NOT NULL,
    "02 2018" numeric(10,2) NOT NULL,
    "03 2018" numeric(10,2) NOT NULL,
    "Q1 2018" numeric(10,2) NOT NULL,
    "04 2018" numeric(10,2) NOT NULL,
    "05 2018" numeric(10,2) NOT NULL,
    "06 2018" numeric(10,2) NOT NULL,
    "Q2 2018" numeric(10,2) NOT NULL,
    "07 2018" numeric(10,2) NOT NULL,
    "08 2018" numeric(10,2) NOT NULL,
    "09 2018" numeric(10,2) NOT NULL,
    "Q3 2018" numeric(10,2) NOT NULL,
    "10 2018" numeric(10,2) NOT NULL,
    "11 2018" numeric(10,2) NOT NULL,
    "12 2018" numeric(10,2) NOT NULL,
    "Q4 2018" numeric(10,2) NOT NULL,
    "2018 Total" numeric(10,2) NOT NULL,
    "Total Revenue" numeric(10,2) NOT NULL,
    "01 2019" numeric(10,2) NOT NULL,
    "02 2019" numeric(10,2) NOT NULL,
    "03 2019" numeric(10,2) NOT NULL,
    "04 2019" numeric(10,2) NOT NULL,
    "05 2019" numeric(10,2) NOT NULL,
    "06 2019" numeric(10,2) NOT NULL,
    "07 2019" numeric(10,2) NOT NULL,
    "08 2019" numeric(10,2) NOT NULL,
    "09 2019" numeric(10,2) NOT NULL,
    "10 2019" numeric(10,2) NOT NULL,
    "11 2019" numeric(10,2) NOT NULL,
    "12 2019" numeric(10,2) NOT NULL,
    "Q1 2019" numeric(10,2) NOT NULL,
    "Q2 2019" numeric(10,2) NOT NULL,
    "Q3 2019" numeric(10,2) NOT NULL,
    "Q4 2019" numeric(10,2) NOT NULL,
    "2019 Total" numeric(10,2) NOT NULL,
    "01 2020" numeric(10,2) NOT NULL,
    "02 2020" numeric(10,2) NOT NULL,
    "03 2020" numeric(10,2) NOT NULL,
    "04 2020" numeric(10,2) NOT NULL,
    "05 2020" numeric(10,2) NOT NULL,
    "06 2020" numeric(10,2) NOT NULL,
    "07 2020" numeric(10,2) NOT NULL,
    "08 2020" numeric(10,2) NOT NULL,
    "09 2020" numeric(10,2) NOT NULL,
    "10 2020" numeric(10,2) NOT NULL,
    "11 2020" numeric(10,2) NOT NULL,
    "12 2020" numeric(10,2) NOT NULL,
    "Q1 2020" numeric(10,2) NOT NULL,
    "Q2 2020" numeric(10,2) NOT NULL,
    "Q3 2020" numeric(10,2) NOT NULL,
    "Q4 2020" numeric(10,2) NOT NULL,
    "2020 Total" numeric(10,2) NOT NULL
);



--
-- Name: revenue_per_month_per_sale; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.revenue_per_month_per_sale (
    revenue_month_year text NOT NULL,
    trade_key text NOT NULL,
    revenue_type text NOT NULL,
    usd_revenue numeric(10,2) NOT NULL,
    revenue_month integer NOT NULL,
    revenue_quarter integer NOT NULL,
    revenue_year integer NOT NULL,
    revenue_quarter_year text NOT NULL,
    seller text NOT NULL,
    seller_code text NOT NULL,
    eur_revenue numeric(10,2) NOT NULL,
    czk_revenue numeric(10,2) NOT NULL
);



--
-- Name: revenue_per_revenue_type_per_month; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.revenue_per_revenue_type_per_month (
    revenue_month_year text NOT NULL,
    revenue_type text NOT NULL,
    usd_revenue numeric(10,2) NOT NULL,
    revenue_month integer NOT NULL,
    revenue_quarter integer NOT NULL,
    revenue_year integer NOT NULL,
    seller text NOT NULL
);



--
-- Name: revenue_per_revenue_type_per_quarter; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.revenue_per_revenue_type_per_quarter (
    revenue_quarter_year text NOT NULL,
    revenue_type text NOT NULL,
    usd_revenue numeric(10,2) NOT NULL,
    revenue_quarter integer NOT NULL,
    revenue_year integer NOT NULL
);



--
-- Name: revenue_per_revenue_type_per_year; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.revenue_per_revenue_type_per_year (
    revenue_year integer NOT NULL,
    revenue_type text NOT NULL,
    usd_revenue numeric(10,2)
);



--
-- Name: sales_report; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.sales_report (
    sale_key text NOT NULL,
    customer text,
    reseller text,
    sale_type text,
    seller text,
    booking_date date,
    usd_amount numeric(10,2),
    sale_comment text,
    invoice text,
    local_currency_amount numeric(10,2) NOT NULL,
    local_currency_code text NOT NULL,
    revenue_start date NOT NULL,
    revenue_end date,
    sales_representative text,
    paid text NOT NULL
);



--
-- Name: sales_report_czk_revenue_broken_down_by_time; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.sales_report_czk_revenue_broken_down_by_time (
    sale_key text NOT NULL,
    customer text,
    reseller text,
    sale_type text,
    seller text,
    booking_date date,
    czk_amount numeric(10,2),
    revenue_start date,
    revenue_end date,
    sale_comment text,
    invoice text,
    local_currency_amount numeric(10,2),
    local_currency_code text,
    "01 2016" numeric(10,2) NOT NULL,
    "02 2016" numeric(10,2) NOT NULL,
    "03 2016" numeric(10,2) NOT NULL,
    "04 2016" numeric(10,2) NOT NULL,
    "05 2016" numeric(10,2) NOT NULL,
    "06 2016" numeric(10,2) NOT NULL,
    "07 2016" numeric(10,2) NOT NULL,
    "08 2016" numeric(10,2) NOT NULL,
    "09 2016" numeric(10,2) NOT NULL,
    "10 2016" numeric(10,2) NOT NULL,
    "11 2016" numeric(10,2) NOT NULL,
    "12 2016" numeric(10,2) NOT NULL,
    "01 2017" numeric(10,2) NOT NULL,
    "02 2017" numeric(10,2) NOT NULL,
    "03 2017" numeric(10,2) NOT NULL,
    "04 2017" numeric(10,2) NOT NULL,
    "05 2017" numeric(10,2) NOT NULL,
    "06 2017" numeric(10,2) NOT NULL,
    "07 2017" numeric(10,2) NOT NULL,
    "08 2017" numeric(10,2) NOT NULL,
    "09 2017" numeric(10,2) NOT NULL,
    "10 2017" numeric(10,2) NOT NULL,
    "11 2017" numeric(10,2) NOT NULL,
    "12 2017" numeric(10,2) NOT NULL,
    "01 2018" numeric(10,2) NOT NULL,
    "02 2018" numeric(10,2) NOT NULL,
    "03 2018" numeric(10,2) NOT NULL,
    "04 2018" numeric(10,2) NOT NULL,
    "05 2018" numeric(10,2) NOT NULL,
    "06 2018" numeric(10,2) NOT NULL,
    "07 2018" numeric(10,2) NOT NULL,
    "08 2018" numeric(10,2) NOT NULL,
    "09 2018" numeric(10,2) NOT NULL,
    "10 2018" numeric(10,2) NOT NULL,
    "11 2018" numeric(10,2) NOT NULL,
    "12 2018" numeric(10,2) NOT NULL,
    "Q1 2016" numeric(10,2) NOT NULL,
    "Q2 2016" numeric(10,2) NOT NULL,
    "Q3 2016" numeric(10,2) NOT NULL,
    "Q4 2016" numeric(10,2) NOT NULL,
    "2016 Total" numeric(10,2) NOT NULL,
    "Q1 2017" numeric(10,2) NOT NULL,
    "Q2 2017" numeric(10,2) NOT NULL,
    "Q3 2017" numeric(10,2) NOT NULL,
    "Q4 2017" numeric(10,2) NOT NULL,
    "2017 Total" numeric(10,2) NOT NULL,
    "Q1 2018" numeric(10,2) NOT NULL,
    "Q2 2018" numeric(10,2) NOT NULL,
    "Q3 2018" numeric(10,2) NOT NULL,
    "Q4 2018" numeric(10,2) NOT NULL,
    "2018 Total" numeric(10,2) NOT NULL,
    sales_representative text,
    paid text,
    "01 2019" numeric(10,2) NOT NULL,
    "02 2019" numeric(10,2) NOT NULL,
    "03 2019" numeric(10,2) NOT NULL,
    "04 2019" numeric(10,2) NOT NULL,
    "05 2019" numeric(10,2) NOT NULL,
    "06 2019" numeric(10,2) NOT NULL,
    "07 2019" numeric(10,2) NOT NULL,
    "08 2019" numeric(10,2) NOT NULL,
    "09 2019" numeric(10,2) NOT NULL,
    "10 2019" numeric(10,2) NOT NULL,
    "11 2019" numeric(10,2) NOT NULL,
    "12 2019" numeric(10,2) NOT NULL,
    "Q1 2019" numeric(10,2) NOT NULL,
    "Q2 2019" numeric(10,2) NOT NULL,
    "Q3 2019" numeric(10,2) NOT NULL,
    "Q4 2019" numeric(10,2) NOT NULL,
    "01 2020" numeric(10,2) NOT NULL,
    "02 2020" numeric(10,2) NOT NULL,
    "03 2020" numeric(10,2) NOT NULL,
    "04 2020" numeric(10,2) NOT NULL,
    "05 2020" numeric(10,2) NOT NULL,
    "06 2020" numeric(10,2) NOT NULL,
    "07 2020" numeric(10,2) NOT NULL,
    "08 2020" numeric(10,2) NOT NULL,
    "09 2020" numeric(10,2) NOT NULL,
    "10 2020" numeric(10,2) NOT NULL,
    "11 2020" numeric(10,2) NOT NULL,
    "12 2020" numeric(10,2) NOT NULL,
    "Q1 2020" numeric(10,2) NOT NULL,
    "Q2 2020" numeric(10,2) NOT NULL,
    "Q3 2020" numeric(10,2) NOT NULL,
    "Q4 2020" numeric(10,2) NOT NULL,
    "2019 Total" numeric(10,2) NOT NULL,
    "2020 Total" numeric(10,2) NOT NULL
);



--
-- Name: sales_report_eur_revenue_broken_down_by_time; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.sales_report_eur_revenue_broken_down_by_time (
    sale_key text NOT NULL,
    customer text,
    reseller text,
    sale_type text,
    seller text,
    booking_date date,
    eur_amount numeric(10,2),
    revenue_start date,
    revenue_end date,
    sale_comment text,
    invoice text,
    local_currency_amount numeric(10,2),
    local_currency_code text,
    "01 2016" numeric(10,2) NOT NULL,
    "02 2016" numeric(10,2) NOT NULL,
    "03 2016" numeric(10,2) NOT NULL,
    "04 2016" numeric(10,2) NOT NULL,
    "05 2016" numeric(10,2) NOT NULL,
    "06 2016" numeric(10,2) NOT NULL,
    "07 2016" numeric(10,2) NOT NULL,
    "08 2016" numeric(10,2) NOT NULL,
    "09 2016" numeric(10,2) NOT NULL,
    "10 2016" numeric(10,2) NOT NULL,
    "11 2016" numeric(10,2) NOT NULL,
    "12 2016" numeric(10,2) NOT NULL,
    "01 2017" numeric(10,2) NOT NULL,
    "02 2017" numeric(10,2) NOT NULL,
    "03 2017" numeric(10,2) NOT NULL,
    "04 2017" numeric(10,2) NOT NULL,
    "05 2017" numeric(10,2) NOT NULL,
    "06 2017" numeric(10,2) NOT NULL,
    "07 2017" numeric(10,2) NOT NULL,
    "08 2017" numeric(10,2) NOT NULL,
    "09 2017" numeric(10,2) NOT NULL,
    "10 2017" numeric(10,2) NOT NULL,
    "11 2017" numeric(10,2) NOT NULL,
    "12 2017" numeric(10,2) NOT NULL,
    "01 2018" numeric(10,2) NOT NULL,
    "02 2018" numeric(10,2) NOT NULL,
    "03 2018" numeric(10,2) NOT NULL,
    "04 2018" numeric(10,2) NOT NULL,
    "05 2018" numeric(10,2) NOT NULL,
    "06 2018" numeric(10,2) NOT NULL,
    "07 2018" numeric(10,2) NOT NULL,
    "08 2018" numeric(10,2) NOT NULL,
    "09 2018" numeric(10,2) NOT NULL,
    "10 2018" numeric(10,2) NOT NULL,
    "11 2018" numeric(10,2) NOT NULL,
    "12 2018" numeric(10,2) NOT NULL,
    "Q1 2016" numeric(10,2) NOT NULL,
    "Q2 2016" numeric(10,2) NOT NULL,
    "Q3 2016" numeric(10,2) NOT NULL,
    "Q4 2016" numeric(10,2) NOT NULL,
    "2016 Total" numeric(10,2) NOT NULL,
    "Q1 2017" numeric(10,2) NOT NULL,
    "Q2 2017" numeric(10,2) NOT NULL,
    "Q3 2017" numeric(10,2) NOT NULL,
    "Q4 2017" numeric(10,2) NOT NULL,
    "2017 Total" numeric(10,2) NOT NULL,
    "Q1 2018" numeric(10,2) NOT NULL,
    "Q2 2018" numeric(10,2) NOT NULL,
    "Q3 2018" numeric(10,2) NOT NULL,
    "Q4 2018" numeric(10,2) NOT NULL,
    "2018 Total" numeric(10,2) NOT NULL,
    sales_representative text,
    paid text,
    "01 2019" numeric(10,2) NOT NULL,
    "02 2019" numeric(10,2) NOT NULL,
    "03 2019" numeric(10,2) NOT NULL,
    "04 2019" numeric(10,2) NOT NULL,
    "05 2019" numeric(10,2) NOT NULL,
    "06 2019" numeric(10,2) NOT NULL,
    "07 2019" numeric(10,2) NOT NULL,
    "08 2019" numeric(10,2) NOT NULL,
    "09 2019" numeric(10,2) NOT NULL,
    "10 2019" numeric(10,2) NOT NULL,
    "11 2019" numeric(10,2) NOT NULL,
    "12 2019" numeric(10,2) NOT NULL,
    "Q1 2019" numeric(10,2) NOT NULL,
    "Q2 2019" numeric(10,2) NOT NULL,
    "Q3 2019" numeric(10,2) NOT NULL,
    "Q4 2019" numeric(10,2) NOT NULL,
    "01 2020" numeric(10,2) NOT NULL,
    "02 2020" numeric(10,2) NOT NULL,
    "03 2020" numeric(10,2) NOT NULL,
    "04 2020" numeric(10,2) NOT NULL,
    "05 2020" numeric(10,2) NOT NULL,
    "06 2020" numeric(10,2) NOT NULL,
    "07 2020" numeric(10,2) NOT NULL,
    "08 2020" numeric(10,2) NOT NULL,
    "09 2020" numeric(10,2) NOT NULL,
    "10 2020" numeric(10,2) NOT NULL,
    "11 2020" numeric(10,2) NOT NULL,
    "12 2020" numeric(10,2) NOT NULL,
    "Q1 2020" numeric(10,2) NOT NULL,
    "Q2 2020" numeric(10,2) NOT NULL,
    "Q3 2020" numeric(10,2) NOT NULL,
    "Q4 2020" numeric(10,2) NOT NULL,
    "2019 Total" numeric(10,2) NOT NULL,
    "2020 Total" numeric(10,2) NOT NULL
);



--
-- Name: sales_report_extended; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.sales_report_extended (
    sale_key text NOT NULL,
    customer text,
    reseller text,
    sale_type text,
    seller text,
    booking_date date,
    usd_amount numeric(10,2),
    revenue_start date,
    revenue_end date,
    sale_comment text,
    invoice text,
    local_currency_amount numeric(10,2),
    local_currency_code text,
    "01 2016" numeric(10,2) NOT NULL,
    "02 2016" numeric(10,2) NOT NULL,
    "03 2016" numeric(10,2) NOT NULL,
    "04 2016" numeric(10,2) NOT NULL,
    "05 2016" numeric(10,2) NOT NULL,
    "06 2016" numeric(10,2) NOT NULL,
    "07 2016" numeric(10,2) NOT NULL,
    "08 2016" numeric(10,2) NOT NULL,
    "09 2016" numeric(10,2) NOT NULL,
    "10 2016" numeric(10,2) NOT NULL,
    "11 2016" numeric(10,2) NOT NULL,
    "12 2016" numeric(10,2) NOT NULL,
    "01 2017" numeric(10,2) NOT NULL,
    "02 2017" numeric(10,2) NOT NULL,
    "03 2017" numeric(10,2) NOT NULL,
    "04 2017" numeric(10,2) NOT NULL,
    "05 2017" numeric(10,2) NOT NULL,
    "06 2017" numeric(10,2) NOT NULL,
    "07 2017" numeric(10,2) NOT NULL,
    "08 2017" numeric(10,2) NOT NULL,
    "09 2017" numeric(10,2) NOT NULL,
    "10 2017" numeric(10,2) NOT NULL,
    "11 2017" numeric(10,2) NOT NULL,
    "12 2017" numeric(10,2) NOT NULL,
    "01 2018" numeric(10,2) NOT NULL,
    "02 2018" numeric(10,2) NOT NULL,
    "03 2018" numeric(10,2) NOT NULL,
    "04 2018" numeric(10,2) NOT NULL,
    "05 2018" numeric(10,2) NOT NULL,
    "06 2018" numeric(10,2) NOT NULL,
    "07 2018" numeric(10,2) NOT NULL,
    "08 2018" numeric(10,2) NOT NULL,
    "09 2018" numeric(10,2) NOT NULL,
    "10 2018" numeric(10,2) NOT NULL,
    "11 2018" numeric(10,2) NOT NULL,
    "12 2018" numeric(10,2) NOT NULL,
    "Q1 2016" numeric(10,2) NOT NULL,
    "Q2 2016" numeric(10,2) NOT NULL,
    "Q3 2016" numeric(10,2) NOT NULL,
    "Q4 2016" numeric(10,2) NOT NULL,
    "2016 Total" numeric(10,2) NOT NULL,
    "Q1 2017" numeric(10,2) NOT NULL,
    "Q2 2017" numeric(10,2) NOT NULL,
    "Q3 2017" numeric(10,2) NOT NULL,
    "Q4 2017" numeric(10,2) NOT NULL,
    "2017 Total" numeric(10,2) NOT NULL,
    "Q1 2018" numeric(10,2) NOT NULL,
    "Q2 2018" numeric(10,2) NOT NULL,
    "Q3 2018" numeric(10,2) NOT NULL,
    "Q4 2018" numeric(10,2) NOT NULL,
    "2018 Total" numeric(10,2) NOT NULL,
    sales_representative text,
    paid text,
    "01 2019" numeric(10,2) NOT NULL,
    "02 2019" numeric(10,2) NOT NULL,
    "03 2019" numeric(10,2) NOT NULL,
    "04 2019" numeric(10,2) NOT NULL,
    "05 2019" numeric(10,2) NOT NULL,
    "06 2019" numeric(10,2) NOT NULL,
    "07 2019" numeric(10,2) NOT NULL,
    "08 2019" numeric(10,2) NOT NULL,
    "09 2019" numeric(10,2) NOT NULL,
    "10 2019" numeric(10,2) NOT NULL,
    "11 2019" numeric(10,2) NOT NULL,
    "12 2019" numeric(10,2) NOT NULL,
    "Q1 2019" numeric(10,2) NOT NULL,
    "Q2 2019" numeric(10,2) NOT NULL,
    "Q3 2019" numeric(10,2) NOT NULL,
    "Q4 2019" numeric(10,2) NOT NULL,
    "2019 Total" numeric(10,2) NOT NULL,
    "01 2020" numeric(10,2) NOT NULL,
    "02 2020" numeric(10,2) NOT NULL,
    "03 2020" numeric(10,2) NOT NULL,
    "04 2020" numeric(10,2) NOT NULL,
    "05 2020" numeric(10,2) NOT NULL,
    "06 2020" numeric(10,2) NOT NULL,
    "07 2020" numeric(10,2) NOT NULL,
    "08 2020" numeric(10,2) NOT NULL,
    "09 2020" numeric(10,2) NOT NULL,
    "10 2020" numeric(10,2) NOT NULL,
    "11 2020" numeric(10,2) NOT NULL,
    "12 2020" numeric(10,2) NOT NULL,
    "Q1 2020" numeric(10,2) NOT NULL,
    "Q2 2020" numeric(10,2) NOT NULL,
    "Q3 2020" numeric(10,2) NOT NULL,
    "Q4 2020" numeric(10,2) NOT NULL,
    "2020 Total" numeric(10,2) NOT NULL
);



--
-- Name: TABLE sales_report_extended; Type: COMMENT; Schema: mart;
--

COMMENT ON TABLE mart.sales_report_extended IS 'BI-270';


--
-- Name: sales_report_usd_revenue_broken_down_by_time; Type: TABLE; Schema: mart;
--

CREATE TABLE mart.sales_report_usd_revenue_broken_down_by_time (
    sale_key text NOT NULL,
    customer text,
    reseller text,
    sale_type text,
    seller text,
    booking_date date,
    usd_amount numeric(10,2),
    revenue_start date,
    revenue_end date,
    sale_comment text,
    invoice text,
    local_currency_amount numeric(10,2),
    local_currency_code text,
    "01 2016" numeric(10,2) NOT NULL,
    "02 2016" numeric(10,2) NOT NULL,
    "03 2016" numeric(10,2) NOT NULL,
    "04 2016" numeric(10,2) NOT NULL,
    "05 2016" numeric(10,2) NOT NULL,
    "06 2016" numeric(10,2) NOT NULL,
    "07 2016" numeric(10,2) NOT NULL,
    "08 2016" numeric(10,2) NOT NULL,
    "09 2016" numeric(10,2) NOT NULL,
    "10 2016" numeric(10,2) NOT NULL,
    "11 2016" numeric(10,2) NOT NULL,
    "12 2016" numeric(10,2) NOT NULL,
    "01 2017" numeric(10,2) NOT NULL,
    "02 2017" numeric(10,2) NOT NULL,
    "03 2017" numeric(10,2) NOT NULL,
    "04 2017" numeric(10,2) NOT NULL,
    "05 2017" numeric(10,2) NOT NULL,
    "06 2017" numeric(10,2) NOT NULL,
    "07 2017" numeric(10,2) NOT NULL,
    "08 2017" numeric(10,2) NOT NULL,
    "09 2017" numeric(10,2) NOT NULL,
    "10 2017" numeric(10,2) NOT NULL,
    "11 2017" numeric(10,2) NOT NULL,
    "12 2017" numeric(10,2) NOT NULL,
    "01 2018" numeric(10,2) NOT NULL,
    "02 2018" numeric(10,2) NOT NULL,
    "03 2018" numeric(10,2) NOT NULL,
    "04 2018" numeric(10,2) NOT NULL,
    "05 2018" numeric(10,2) NOT NULL,
    "06 2018" numeric(10,2) NOT NULL,
    "07 2018" numeric(10,2) NOT NULL,
    "08 2018" numeric(10,2) NOT NULL,
    "09 2018" numeric(10,2) NOT NULL,
    "10 2018" numeric(10,2) NOT NULL,
    "11 2018" numeric(10,2) NOT NULL,
    "12 2018" numeric(10,2) NOT NULL,
    "Q1 2016" numeric(10,2) NOT NULL,
    "Q2 2016" numeric(10,2) NOT NULL,
    "Q3 2016" numeric(10,2) NOT NULL,
    "Q4 2016" numeric(10,2) NOT NULL,
    "2016 Total" numeric(10,2) NOT NULL,
    "Q1 2017" numeric(10,2) NOT NULL,
    "Q2 2017" numeric(10,2) NOT NULL,
    "Q3 2017" numeric(10,2) NOT NULL,
    "Q4 2017" numeric(10,2) NOT NULL,
    "2017 Total" numeric(10,2) NOT NULL,
    "Q1 2018" numeric(10,2) NOT NULL,
    "Q2 2018" numeric(10,2) NOT NULL,
    "Q3 2018" numeric(10,2) NOT NULL,
    "Q4 2018" numeric(10,2) NOT NULL,
    "2018 Total" numeric(10,2) NOT NULL,
    sales_representative text,
    paid text,
    "01 2019" numeric(10,2) NOT NULL,
    "02 2019" numeric(10,2) NOT NULL,
    "03 2019" numeric(10,2) NOT NULL,
    "04 2019" numeric(10,2) NOT NULL,
    "05 2019" numeric(10,2) NOT NULL,
    "06 2019" numeric(10,2) NOT NULL,
    "07 2019" numeric(10,2) NOT NULL,
    "08 2019" numeric(10,2) NOT NULL,
    "09 2019" numeric(10,2) NOT NULL,
    "10 2019" numeric(10,2) NOT NULL,
    "11 2019" numeric(10,2) NOT NULL,
    "12 2019" numeric(10,2) NOT NULL,
    "Q1 2019" numeric(10,2) NOT NULL,
    "Q2 2019" numeric(10,2) NOT NULL,
    "Q3 2019" numeric(10,2) NOT NULL,
    "Q4 2019" numeric(10,2) NOT NULL,
    "01 2020" numeric(10,2) NOT NULL,
    "02 2020" numeric(10,2) NOT NULL,
    "03 2020" numeric(10,2) NOT NULL,
    "04 2020" numeric(10,2) NOT NULL,
    "05 2020" numeric(10,2) NOT NULL,
    "06 2020" numeric(10,2) NOT NULL,
    "07 2020" numeric(10,2) NOT NULL,
    "08 2020" numeric(10,2) NOT NULL,
    "09 2020" numeric(10,2) NOT NULL,
    "10 2020" numeric(10,2) NOT NULL,
    "11 2020" numeric(10,2) NOT NULL,
    "12 2020" numeric(10,2) NOT NULL,
    "Q1 2020" numeric(10,2) NOT NULL,
    "Q2 2020" numeric(10,2) NOT NULL,
    "Q3 2020" numeric(10,2) NOT NULL,
    "Q4 2020" numeric(10,2) NOT NULL,
    "2019 Total" numeric(10,2) NOT NULL,
    "2020 Total" numeric(10,2) NOT NULL
);



--
-- Name: booking_by_time_report pk_booking_by_time_report_revenue_type; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.booking_by_time_report
    ADD CONSTRAINT pk_booking_by_time_report_revenue_type PRIMARY KEY (revenue_type);


--
-- Name: booking_per_revenue_type_per_month pk_booking_per_revenue_type_per_month; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.booking_per_revenue_type_per_month
    ADD CONSTRAINT pk_booking_per_revenue_type_per_month PRIMARY KEY (booking_month_year, revenue_type);


--
-- Name: booking_per_revenue_type_per_quarter pk_booking_per_revenue_type_per_quartal; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.booking_per_revenue_type_per_quarter
    ADD CONSTRAINT pk_booking_per_revenue_type_per_quartal PRIMARY KEY (booking_quarter_year, revenue_type);


--
-- Name: booking_per_revenue_type_per_year pk_booking_per_revenue_type_per_year; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.booking_per_revenue_type_per_year
    ADD CONSTRAINT pk_booking_per_revenue_type_per_year PRIMARY KEY (booking_year, revenue_type);


--
-- Name: revenue_by_time_report pk_revenue_by_time_report_revenue_type; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.revenue_by_time_report
    ADD CONSTRAINT pk_revenue_by_time_report_revenue_type PRIMARY KEY (revenue_type, seller);


--
-- Name: revenue_per_month_per_sale pk_revenue_per_month_per_sale; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.revenue_per_month_per_sale
    ADD CONSTRAINT pk_revenue_per_month_per_sale PRIMARY KEY (trade_key, revenue_month_year, seller);


--
-- Name: revenue_per_revenue_type_per_month pk_revenue_per_revenue_type_per_month; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.revenue_per_revenue_type_per_month
    ADD CONSTRAINT pk_revenue_per_revenue_type_per_month PRIMARY KEY (revenue_month_year, revenue_type, seller);


--
-- Name: revenue_per_revenue_type_per_quarter pk_revenue_per_revenue_type_per_quartal_revenue_quartal_year; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.revenue_per_revenue_type_per_quarter
    ADD CONSTRAINT pk_revenue_per_revenue_type_per_quartal_revenue_quartal_year PRIMARY KEY (revenue_quarter_year, revenue_type);


--
-- Name: revenue_per_revenue_type_per_year pk_revenue_per_revenue_type_per_year; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.revenue_per_revenue_type_per_year
    ADD CONSTRAINT pk_revenue_per_revenue_type_per_year PRIMARY KEY (revenue_year, revenue_type);


--
-- Name: sales_report_czk_revenue_broken_down_by_time pk_sales_report_czk_revenue_broken_down_by_time; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.sales_report_czk_revenue_broken_down_by_time
    ADD CONSTRAINT pk_sales_report_czk_revenue_broken_down_by_time PRIMARY KEY (sale_key);


--
-- Name: sales_report_eur_revenue_broken_down_by_time pk_sales_report_eur_revenue_broken_down_by_time; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.sales_report_eur_revenue_broken_down_by_time
    ADD CONSTRAINT pk_sales_report_eur_revenue_broken_down_by_time PRIMARY KEY (sale_key);


--
-- Name: sales_report_extended pk_sales_report_extended_sale_key; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.sales_report_extended
    ADD CONSTRAINT pk_sales_report_extended_sale_key PRIMARY KEY (sale_key);


--
-- Name: sales_report pk_sales_report_sale_key; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.sales_report
    ADD CONSTRAINT pk_sales_report_sale_key PRIMARY KEY (sale_key);


--
-- Name: sales_report_usd_revenue_broken_down_by_time pk_sales_report_usd_revenue_broken_down_by_time; Type: CONSTRAINT; Schema: mart;
--

ALTER TABLE ONLY mart.sales_report_usd_revenue_broken_down_by_time
    ADD CONSTRAINT pk_sales_report_usd_revenue_broken_down_by_time PRIMARY KEY (sale_key);
