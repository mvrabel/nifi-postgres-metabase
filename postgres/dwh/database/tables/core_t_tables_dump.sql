--
-- Name: activity_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.activity_t (
    activity_id integer NOT NULL,
    activity_key text NOT NULL,
    fk_employee_id_created_by integer NOT NULL,
    fk_organization_id integer NOT NULL,
    fk_contact_id integer NOT NULL,
    fk_deal_id integer NOT NULL,
    fk_date_id_due_date integer NOT NULL,
    due_timestamp timestamp with time zone NOT NULL,
    marked_as_done boolean NOT NULL,
    fk_date_id_marked_as_done integer NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    marked_as_done_timestamp timestamp with time zone NOT NULL,
    subject text NOT NULL,
    fk_employee_id_assigned_to integer NOT NULL,
    note text NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);




--
-- Name: c_partner_list_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.c_partner_list_t (
    partner_list_id integer NOT NULL,
    partner_name text NOT NULL,
    is_tracked boolean NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);



--
-- Name: c_revenue_type_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.c_revenue_type_t (
    revenue_type_id integer NOT NULL,
    revenue_type_name text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);



--
-- Name: contact_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.contact_t (
    contact_id integer NOT NULL,
    contact_key text NOT NULL,
    phone_number text NOT NULL,
    email_address text NOT NULL,
    location_full text NOT NULL,
    location_city text NOT NULL,
    location_country text NOT NULL,
    pipedrive_label text NOT NULL,
    fk_organization_id integer,
    fk_party_id integer,
    fk_employee_id_owner integer NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    last_updated_timestamp timestamp with time zone NOT NULL,
    pipedrive_id text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    fk_date_id_last_updated_date integer NOT NULL,
    location_region text NOT NULL
);




--
-- Name: deal_change_log_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.deal_change_log_t (
    deal_change_log_id integer NOT NULL,
    deal_change_log_key text NOT NULL,
    field text NOT NULL,
    old_value text NOT NULL,
    new_value text NOT NULL,
    fk_deal_id integer NOT NULL,
    fk_employee_id integer NOT NULL,
    log_timestamp timestamp with time zone NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_log_date integer NOT NULL
);




--
-- Name: deal_contact_map_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.deal_contact_map_t (
    deal_contact_map_id integer NOT NULL,
    deal_key text NOT NULL,
    contact_key text NOT NULL,
    fk_deal_id integer NOT NULL,
    fk_contact_id integer NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);




--
-- Name: deal_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.deal_t (
    deal_id integer NOT NULL,
    deal_key text NOT NULL,
    title text NOT NULL,
    stage text NOT NULL,
    fk_issue_id integer NOT NULL,
    fk_contact_id integer NOT NULL,
    fk_organization_id integer NOT NULL,
    fk_employee_id_owner integer NOT NULL,
    usd_value integer NOT NULL,
    fk_currency_id_deal_currency integer NOT NULL,
    local_currency_value integer NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    last_updated_timestamp timestamp with time zone NOT NULL,
    closed_timestamp timestamp with time zone NOT NULL,
    pipedrive_id text NOT NULL,
    status text NOT NULL,
    pipeline text NOT NULL,
    won_timestamp timestamp with time zone NOT NULL,
    lost_timestamp timestamp with time zone NOT NULL,
    fk_date_id_expected_close_date integer NOT NULL,
    industry text NOT NULL,
    deal_source text NOT NULL,
    deal_source_detail text NOT NULL,
    region text NOT NULL,
    reason_lost text NOT NULL,
    resulting_state text NOT NULL,
    category text NOT NULL,
    country text NOT NULL,
    vtiger_key text NOT NULL,
    partner_identified_by text NOT NULL,
    partner_qualified_by text NOT NULL,
    partner_poc_done_by text NOT NULL,
    partner_closed_by text NOT NULL,
    partner_resold_by text NOT NULL,
    partner_supported_by text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    partner_owned_by text NOT NULL,
    expected_close_date date NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    fk_date_id_last_updated_date integer NOT NULL,
    fk_date_id_closed_date integer NOT NULL,
    fk_date_id_won_date integer NOT NULL,
    fk_date_id_lost_date integer NOT NULL
);




--
-- Name: COLUMN deal_t.industry; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.deal_t.industry IS 'pipedrive field id - 0b8f4c916653fca572a26ee0d8a65b73a9a3d6c2';


--
-- Name: COLUMN deal_t.deal_source; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.deal_t.deal_source IS '64896c7962fd27b8b0c719c3bbc3c9d77a2060cb';


--
-- Name: COLUMN deal_t.deal_source_detail; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.deal_t.deal_source_detail IS '5f987ab7b72ef1083f09ed8f3011951419a6f450';


--
-- Name: COLUMN deal_t.region; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.deal_t.region IS 'e3a01ee1cb7171c2984c563024d6de5db252d945';


--
-- Name: COLUMN deal_t.reason_lost; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.deal_t.reason_lost IS 'cab2c98910b32f44caa20f84bec2db658ad2669e';


--
-- Name: COLUMN deal_t.resulting_state; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.deal_t.resulting_state IS 'f6ab0c86f427fcb5d4119fc98b39805b76aea254';


--
-- Name: COLUMN deal_t.country; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.deal_t.country IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: email_campaign_bounced_email_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.email_campaign_bounced_email_t (
    email_campaign_bounced_email_id integer NOT NULL,
    email_campaign_bounced_email_key text NOT NULL,
    fk_email_campaign_report_id integer NOT NULL,
    bounce_type text NOT NULL,
    email_address text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);



--
-- Name: email_campaign_clicked_url_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.email_campaign_clicked_url_t (
    email_campaign_clicked_url_id integer NOT NULL,
    email_campaign_clicked_url_key text NOT NULL,
    fk_email_campaign_report_id integer NOT NULL,
    url text NOT NULL,
    clicks integer NOT NULL,
    unique_clicks integer NOT NULL,
    percentage_ot_total_clicks real NOT NULL,
    percentage_ot_unique_clicks real NOT NULL,
    last_click_timestamp timestamp with time zone,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);



--
-- Name: email_campaign_opened_by_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.email_campaign_opened_by_t (
    email_campaign_opened_by_id integer NOT NULL,
    email_campaign_opened_by_key text NOT NULL,
    fk_email_campaign_report_id integer NOT NULL,
    email_address text NOT NULL,
    opens_count integer NOT NULL,
    open_timestamps timestamp with time zone[] NOT NULL,
    first_name text,
    last_name text,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);



--
-- Name: email_campaign_recipient_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.email_campaign_recipient_t (
    email_campaign_recipient_id integer NOT NULL,
    email_campaign_recipient_key text NOT NULL,
    fk_email_campaign_report_id integer NOT NULL,
    email_address text NOT NULL,
    first_name text,
    last_name text,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);



--
-- Name: email_campaign_report_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.email_campaign_report_t (
    email_campaign_report_id integer NOT NULL,
    email_campaign_report_key text NOT NULL,
    mailchimp_id text NOT NULL,
    mailchimp_web_id integer NOT NULL,
    emails_sent_total integer NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    send_timestamp timestamp with time zone NOT NULL,
    sent_to_mailing_list text,
    sent_to_mailing_list_segment_filter text,
    campaign_title text NOT NULL,
    campaign_type text NOT NULL,
    abuse_reports_total integer NOT NULL,
    unsubscribed_total integer NOT NULL,
    hard_bounces_total integer NOT NULL,
    soft_bounces_total integer NOT NULL,
    syntax_error_bounce_total integer,
    forwards_total integer NOT NULL,
    forwards_opens_total integer NOT NULL,
    opens_total integer NOT NULL,
    unique_opens_total integer,
    total_open_to_unique_open_rate real,
    last_open_timestamp timestamp with time zone,
    clicks_total integer NOT NULL,
    unique_clicks_total integer,
    total_clicks_to_unique_clicks_rate real,
    unique_subscriiber_clicks_total integer,
    last_click_timestamp timestamp with time zone,
    industry_type text,
    industry_open_to_unique_open_rate real,
    industry_click_to_unique_click_rate real,
    industry_bounce_rate real,
    industry_unopen_rate real,
    industry_unsub_rate real,
    industry_abuse_rate real,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    was_timewarp_used boolean NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    fk_date_id_send_date integer NOT NULL,
    fk_date_id_last_open_date integer NOT NULL,
    fk_date_id_last_click_date integer NOT NULL
);



--
-- Name: employee_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.employee_t (
    employee_id integer NOT NULL,
    employee_key text NOT NULL,
    full_name text NOT NULL,
    email text NOT NULL,
    secondary_email text NOT NULL,
    phone text NOT NULL,
    mobile_phone text NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_created_date integer NOT NULL
);



--
-- Name: iso_3166_country_list_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.iso_3166_country_list_t (
    iso_3166_country_list_id integer NOT NULL,
    iso_3166_country_list_key text NOT NULL,
    country_name text NOT NULL,
    alpha2code text NOT NULL,
    alpha3code text NOT NULL,
    capital text NOT NULL,
    region text NOT NULL,
    subregion text NOT NULL,
    numericcode text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);



--
-- Name: issue_comment_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.issue_comment_t (
    issue_comment_id integer NOT NULL,
    issue_comment_key text NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    last_updated_timestamp timestamp with time zone NOT NULL,
    body text NOT NULL,
    fk_employee_id_created_by integer NOT NULL,
    fk_employee_id_updated_by integer NOT NULL,
    is_public boolean NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_issue_id integer NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    fk_date_id_last_updated_date integer NOT NULL
);




--
-- Name: issue_relation_map_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.issue_relation_map_t (
    issue_relation_map_id integer NOT NULL,
    issue_key text NOT NULL,
    issue_key_related_issue text NOT NULL,
    fk_issue_id integer NOT NULL,
    fk_issue_id_related_issue integer NOT NULL,
    relation text NOT NULL,
    relation_direction text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);



--
-- Name: issue_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.issue_t (
    issue_id integer NOT NULL,
    jira_key text NOT NULL,
    jira_id integer NOT NULL,
    issue_key text NOT NULL,
    account text NOT NULL,
    status text NOT NULL,
    summary text NOT NULL,
    priority text NOT NULL,
    sla_priority text NOT NULL,
    description text NOT NULL,
    issue_type text NOT NULL,
    resolution text NOT NULL,
    deployment text NOT NULL,
    epic_name text NOT NULL,
    epic_jira_key text NOT NULL,
    original_estimate interval NOT NULL,
    remaining_estimate interval NOT NULL,
    aggregate_original_estimate interval NOT NULL,
    aggregate_remaining_estimate interval NOT NULL,
    labels text[] NOT NULL,
    components text[] NOT NULL,
    fix_versions text[] NOT NULL,
    affected_versions text[] NOT NULL,
    first_response_timestamp timestamp with time zone NOT NULL,
    resolution_timestamp timestamp with time zone NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    fk_date_id_pilot_date integer NOT NULL,
    fk_date_id_sales_date integer NOT NULL,
    fk_project_id integer NOT NULL,
    fk_party_id_created_by integer NOT NULL,
    fk_party_id_reported_by integer NOT NULL,
    fk_employee_id_assigned_to integer NOT NULL,
    fk_date_id_inception_date integer NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_deployment_date integer NOT NULL,
    customer text NOT NULL,
    activation_timestamp timestamp with time zone NOT NULL,
    fk_date_id_activation_date integer NOT NULL,
    inception_to_first_response_days integer NOT NULL,
    inception_to_pilot_days integer NOT NULL,
    inception_to_sales_days integer NOT NULL,
    inception_to_deployment_days integer NOT NULL,
    inception_to_now_days integer NOT NULL,
    activation_to_pilot_days integer NOT NULL,
    activation_to_sales_days integer NOT NULL,
    activation_to_deployment_days integer NOT NULL,
    activation_to_now_days integer NOT NULL,
    pilot_to_sales_days integer NOT NULL,
    pilot_to_deployment_days integer NOT NULL,
    pilot_to_now_days integer NOT NULL,
    sales_to_deployment_days integer NOT NULL,
    sales_to_now_days integer NOT NULL,
    deployment_to_now_days integer NOT NULL,
    inception_to_resolution_days integer NOT NULL,
    first_response_to_resolution_days integer NOT NULL,
    pilot_date date NOT NULL,
    sales_date date NOT NULL,
    inception_date date NOT NULL,
    deployment_date date NOT NULL,
    fk_date_id_first_response_date integer NOT NULL,
    fk_date_id_resolution_date integer NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    hours_logged_total numeric(10,5) NOT NULL,
    days_logged_total numeric(10,5) NOT NULL,
    pilot_finished_date date NOT NULL,
    fk_date_id_pilot_finished_date integer NOT NULL,
    pilot_to_pilot_finished_days integer NOT NULL,
    pilot_finished_to_sales_days integer NOT NULL,
    pilot_finished_to_now_days integer NOT NULL
);



--
-- Name: TABLE issue_t; Type: COMMENT; Schema: core;
--

COMMENT ON TABLE core.issue_t IS 'BI-88';


--
-- Name: COLUMN issue_t.fk_date_id_sales_date; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.issue_t.fk_date_id_sales_date IS 'it is should be the same as core.lopp_t "close date". Both represent thesame thing but both are written manualy into separate system. So its possbile for them to be different. \nThe Correct is which one is ealier';


--
-- Name: list_segment_list_member_map_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.list_segment_list_member_map_t (
    list_segment_list_member_map_id integer NOT NULL,
    list_segment_key text NOT NULL,
    list_member_key text NOT NULL,
    fk_mailing_list_segment_id integer NOT NULL,
    fk_mailing_list_member_id integer NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);



--
-- Name: mail_message_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.mail_message_t (
    mail_message_id integer NOT NULL,
    fk_deal_id integer NOT NULL,
    mail_message_key text NOT NULL,
    sent_timestamp timestamp with time zone NOT NULL,
    from_email_address text NOT NULL,
    fk_contact_id_from integer NOT NULL,
    to_email_address text,
    fk_contact_id_to integer,
    cc_email_address text NOT NULL,
    fk_contact_id_cc integer NOT NULL,
    bcc_email_address text NOT NULL,
    fk_contact_id_bcc integer NOT NULL,
    body_url text NOT NULL,
    fk_employee_id integer NOT NULL,
    subject text NOT NULL,
    body_snippet text NOT NULL,
    read_flag boolean NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    pipedrive_mail_message_id integer NOT NULL,
    pipedrive_mail_thread_id integer NOT NULL,
    fk_date_id_sent_date integer NOT NULL
);




--
-- Name: mailing_list_member_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.mailing_list_member_t (
    mailing_list_member_id integer NOT NULL,
    mailing_list_member_key text NOT NULL,
    mailchimp_id text NOT NULL,
    email_address text NOT NULL,
    mailchimp_unique_email_id text NOT NULL,
    status text NOT NULL,
    fk_party_id integer NOT NULL,
    avg_open_rate real NOT NULL,
    avg_click_rate real NOT NULL,
    ip_address_signup text,
    timestamp_signup timestamp with time zone,
    ip_address_opt_in text,
    timestamp_opt_in timestamp with time zone,
    last_changed_timestamp timestamp with time zone,
    email_client text,
    location_latitude real,
    location_longitude real,
    location_country_code text,
    fk_mailing_list_id integer NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_signup_date integer NOT NULL,
    fk_date_id_opt_in_date integer NOT NULL,
    fk_date_id_last_changed_date integer NOT NULL
);



--
-- Name: COLUMN mailing_list_member_t.mailchimp_id; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.mailchimp_id IS 'The MD5 hash of the lowercase version of the list memberĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Âs email address.';


--
-- Name: COLUMN mailing_list_member_t.email_address; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.email_address IS 'Email address for a subscriber.';


--
-- Name: COLUMN mailing_list_member_t.mailchimp_unique_email_id; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.mailchimp_unique_email_id IS 'An identifier for the address across all of MailChimp.';


--
-- Name: COLUMN mailing_list_member_t.status; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.status IS 'SubscriberĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Âs current status.\nPossible Values:\nsubscribed, unsubscribed, cleaned, pending, transactional';


--
-- Name: COLUMN mailing_list_member_t.avg_open_rate; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.avg_open_rate IS 'A subscriberĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Âs average open rate.';


--
-- Name: COLUMN mailing_list_member_t.avg_click_rate; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.avg_click_rate IS 'A subscriberĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Âs average clickthrough rate.';


--
-- Name: COLUMN mailing_list_member_t.ip_address_signup; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.ip_address_signup IS 'IP address the subscriber signed up from.';


--
-- Name: COLUMN mailing_list_member_t.timestamp_signup; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.timestamp_signup IS 'The date and time the subscriber signed up for the list.';


--
-- Name: COLUMN mailing_list_member_t.ip_address_opt_in; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.ip_address_opt_in IS 'The IP address the subscriber used to confirm their opt-in status.';


--
-- Name: COLUMN mailing_list_member_t.timestamp_opt_in; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.timestamp_opt_in IS 'The date and time the subscribe confirmed their opt-in status.';


--
-- Name: COLUMN mailing_list_member_t.last_changed_timestamp; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.last_changed_timestamp IS 'The date and time the memberĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Âs info was last changed.';


--
-- Name: COLUMN mailing_list_member_t.email_client; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.email_client IS 'The list memberĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Âs email client.';


--
-- Name: COLUMN mailing_list_member_t.location_country_code; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_member_t.location_country_code IS 'The unique code for the location country.';


--
-- Name: mailing_list_segment_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.mailing_list_segment_t (
    mailing_list_segment_id integer NOT NULL,
    mailing_list_segment_key text NOT NULL,
    segment_name text NOT NULL,
    mailchimp_id integer,
    segment_type text,
    created_timestamp timestamp with time zone NOT NULL,
    last_updated_timestamp timestamp with time zone NOT NULL,
    segment_filter_options jsonb,
    fk_mailing_list_id integer NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    fk_date_id_last_updated_date integer NOT NULL
);



--
-- Name: mailing_list_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.mailing_list_t (
    mailing_list_id integer NOT NULL,
    mailing_list_key text NOT NULL,
    mailchimp_id text NOT NULL,
    mailchimp_id_web_id integer NOT NULL,
    mailing_list_name text NOT NULL,
    notify_on_subscribe_email text NOT NULL,
    notify_on_unsubscribe_email text NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    subscribe_url_short text NOT NULL,
    subscribe_url_long text NOT NULL,
    visibility text,
    double_optin boolean,
    marketing_permissions boolean,
    member_count integer NOT NULL,
    unsubscribe_count integer NOT NULL,
    cleaned_count integer,
    member_count_since_last_campaign integer,
    unsubscribe_count_last_campaign integer,
    cleaned_count_last_campaign integer,
    campaign_count integer,
    campaign_last_sent_timestamp timestamp with time zone,
    merge_field_count integer,
    avg_sub_rate real NOT NULL,
    avg_unsub_rate real NOT NULL,
    target_sub_rate real,
    open_rate real NOT NULL,
    click_rate real NOT NULL,
    last_sub_timestamp timestamp with time zone,
    last_unsub_timestamp timestamp with time zone,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    fk_date_id_last_sent_date integer NOT NULL,
    fk_date_id_last_sub_date integer NOT NULL,
    fk_date_id_last_unsub_date integer NOT NULL
);



--
-- Name: TABLE mailing_list_t; Type: COMMENT; Schema: core;
--

COMMENT ON TABLE core.mailing_list_t IS 'Column description is copied from mailchimp ducomentation\nhttp://developer.mailchimp.com/documentation/mailchimp/reference/lists\nsome column names were renamed to be more descriptive';


--
-- Name: COLUMN mailing_list_t.mailchimp_id; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.mailchimp_id IS 'original column name - id\nA string that uniquely identifies this list.';


--
-- Name: COLUMN mailing_list_t.mailchimp_id_web_id; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.mailchimp_id_web_id IS 'original column name -\nThe ID used in the MailChimp web application. View this list in your MailChimp account at https://{dc}.admin.mailchimp.com/lists/members/?id={web_id}.';


--
-- Name: COLUMN mailing_list_t.mailing_list_name; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.mailing_list_name IS 'original column name -\nThe name of the list.';


--
-- Name: COLUMN mailing_list_t.notify_on_subscribe_email; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.notify_on_subscribe_email IS 'The email address to send subscribe notifications to.';


--
-- Name: COLUMN mailing_list_t.notify_on_unsubscribe_email; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.notify_on_unsubscribe_email IS 'The email address to send unsubscribe notifications to.';


--
-- Name: COLUMN mailing_list_t.created_timestamp; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.created_timestamp IS 'The date and time that this list was created.';


--
-- Name: COLUMN mailing_list_t.subscribe_url_short; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.subscribe_url_short IS 'Our EepURL shortened version of this listĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Âs subscribe form.';


--
-- Name: COLUMN mailing_list_t.subscribe_url_long; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.subscribe_url_long IS 'The full version of this listĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Âs subscribe form (host will vary).';


--
-- Name: COLUMN mailing_list_t.visibility; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.visibility IS 'Whether this list is public or private.\nPossible Values:\npub, prv';


--
-- Name: COLUMN mailing_list_t.member_count; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.member_count IS 'The number of active members in the list.';


--
-- Name: COLUMN mailing_list_t.unsubscribe_count; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.unsubscribe_count IS 'The number of members who have unsubscribed from the list.';


--
-- Name: COLUMN mailing_list_t.cleaned_count; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.cleaned_count IS 'The number of members cleaned from the list.';


--
-- Name: COLUMN mailing_list_t.member_count_since_last_campaign; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.member_count_since_last_campaign IS 'The number of active members in the list since the last campaign was sent.';


--
-- Name: COLUMN mailing_list_t.unsubscribe_count_last_campaign; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.unsubscribe_count_last_campaign IS 'The number of members who have unsubscribed since the last campaign was sent.';


--
-- Name: COLUMN mailing_list_t.cleaned_count_last_campaign; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.cleaned_count_last_campaign IS 'The number of members cleaned from the list since the last campaign was sent.';


--
-- Name: COLUMN mailing_list_t.campaign_count; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.campaign_count IS 'The number of campaigns in any status that use this list.';


--
-- Name: COLUMN mailing_list_t.campaign_last_sent_timestamp; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.campaign_last_sent_timestamp IS 'The date and time the last campaign was sent to this list. This is updated when a campaign is sent to 10 or more recipients.';


--
-- Name: COLUMN mailing_list_t.merge_field_count; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.merge_field_count IS 'The number of merge vars for this list (not EMAIL, which is required).';


--
-- Name: COLUMN mailing_list_t.avg_sub_rate; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.avg_sub_rate IS 'The average number of subscriptions per month for the list (not returned if we havenĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Ât calculated it yet).';


--
-- Name: COLUMN mailing_list_t.avg_unsub_rate; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.avg_unsub_rate IS 'The average number of unsubscriptions per month for the list (not returned if we havenĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Ât calculated it yet).';


--
-- Name: COLUMN mailing_list_t.target_sub_rate; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.target_sub_rate IS 'The target number of subscriptions per month for the list to keep it growing (not returned if we havenĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Ât calculated it yet).';


--
-- Name: COLUMN mailing_list_t.open_rate; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.open_rate IS 'The average open rate (a percentage represented as a number between 0 and 100) per campaign for the list (not returned if we havenĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Ât calculated it yet).';


--
-- Name: COLUMN mailing_list_t.click_rate; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.click_rate IS 'The average click rate (a percentage represented as a number between 0 and 100) per campaign for the list (not returned if we havenĂ„â€šĂ‹ÂÄ‚ËĂ˘â‚¬ĹˇĂ‚Â¬Ä‚ËĂ˘â‚¬ĹľĂ‹Ât calculated it yet).';


--
-- Name: COLUMN mailing_list_t.last_sub_timestamp; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.last_sub_timestamp IS 'The date and time of the last time someone subscribed to this list.';


--
-- Name: COLUMN mailing_list_t.last_unsub_timestamp; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.mailing_list_t.last_unsub_timestamp IS 'The date and time of the last time someone unsubscribed from this list.';


--
-- Name: note_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.note_t (
    note_id integer NOT NULL,
    note_key text NOT NULL,
    fk_deal_id integer NOT NULL,
    fk_contact_id integer NOT NULL,
    fk_organization_id integer NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    last_modified_timestamp timestamp with time zone NOT NULL,
    pinned_to_deal_flag boolean NOT NULL,
    pinned_to_person_flag boolean NOT NULL,
    pinned_to_organization_flag boolean NOT NULL,
    content text NOT NULL,
    fk_employee_id integer NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    fk_date_id_last_modified_date integer NOT NULL
);




--
-- Name: organization_relation_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.organization_relation_t (
    organization_relation_id integer NOT NULL,
    organization_key text NOT NULL,
    organization_key_related_organization text NOT NULL,
    fk_organization_id integer NOT NULL,
    fk_organization_id_related_organization integer NOT NULL,
    related_organization_is text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);




--
-- Name: organization_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.organization_t (
    organization_id integer NOT NULL,
    organization_key text NOT NULL,
    address_full text NOT NULL,
    address_city text NOT NULL,
    address_country text NOT NULL,
    pipedrive_label text NOT NULL,
    fk_party_id integer NOT NULL,
    fk_employee_id_owner integer NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    last_updated_timestamp timestamp with time zone NOT NULL,
    pipedrive_id text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    fk_date_id_last_updated_date integer NOT NULL,
    address_region text NOT NULL
);




--
-- Name: party_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.party_t (
    party_id integer NOT NULL,
    party_key text NOT NULL,
    full_name text NOT NULL,
    short_name text NOT NULL,
    fk_employee_id_last_modified_by integer NOT NULL,
    fk_employee_id_created_by integer NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    last_modified_timestamp timestamp with time zone NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_created_date integer NOT NULL,
    fk_date_id_last_modified_date integer NOT NULL
);



--
-- Name: COLUMN party_t.full_name; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.party_t.full_name IS 'lead - vtiger_crm_entity.label ( or leaddetail.first_name + leaddetail.last_name) | 
organization - vtiger_account.accountname';


--
-- Name: COLUMN party_t.created_timestamp; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.party_t.created_timestamp IS 'CRM users - vtiger_users.date_entered | 
CRM entity - vtiger_crmentity.createdtime';


--
-- Name: project_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.project_t (
    project_id integer NOT NULL,
    project_key text NOT NULL,
    jira_id integer NOT NULL,
    jira_key text NOT NULL,
    project_name text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);



--
-- Name: release_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.release_t (
    release_id integer NOT NULL,
    release_key text NOT NULL,
    jira_id integer NOT NULL,
    fk_date_id_release_date integer NOT NULL,
    release_name text NOT NULL,
    fk_date_id_start_date integer NOT NULL,
    fk_project_id integer NOT NULL,
    description text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    release_number integer NOT NULL,
    release_date date NOT NULL,
    start_date date NOT NULL
);



--
-- Name: sale_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.sale_t (
    sale_id integer NOT NULL,
    sale_key text NOT NULL,
    fk_organization_id_customer integer NOT NULL,
    fk_organization_id_reseller integer NOT NULL,
    fk_date_id_booking_date integer NOT NULL,
    fk_revenue_type_id integer NOT NULL,
    usd_amount numeric(10,2) NOT NULL,
    local_currency_amount numeric(10,2) NOT NULL,
    fk_currency_id_local_currency integer NOT NULL,
    sale_comment text NOT NULL,
    fk_organization_id_seller integer NOT NULL,
    invoice text NOT NULL,
    fk_date_id_revenue_start integer NOT NULL,
    fk_date_id_revenue_end integer NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    payment_received boolean NOT NULL,
    fk_party_id_sales_representative integer NOT NULL,
    revenue_start_date date NOT NULL,
    revenue_end_date date NOT NULL,
    booking_date date NOT NULL,
    czk_amount numeric(10,2) NOT NULL,
    eur_amount numeric(10,2) NOT NULL
);



--
-- Name: seq_activity_t_activity_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_activity_t_activity_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_activity_t_activity_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_activity_t_activity_id OWNED BY core.activity_t.activity_id;


--
-- Name: seq_c_partner_list_t_partner_list_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_c_partner_list_t_partner_list_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_c_partner_list_t_partner_list_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_c_partner_list_t_partner_list_id OWNED BY core.c_partner_list_t.partner_list_id;


--
-- Name: seq_c_revenue_type_t_revenue_type_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_c_revenue_type_t_revenue_type_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_c_revenue_type_t_revenue_type_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_c_revenue_type_t_revenue_type_id OWNED BY core.c_revenue_type_t.revenue_type_id;


--
-- Name: seq_contact_t_contact_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_contact_t_contact_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_contact_t_contact_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_contact_t_contact_id OWNED BY core.contact_t.contact_id;


--
-- Name: seq_deal_change_log_t_deal_change_log_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_deal_change_log_t_deal_change_log_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_deal_change_log_t_deal_change_log_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_deal_change_log_t_deal_change_log_id OWNED BY core.deal_change_log_t.deal_change_log_id;


--
-- Name: seq_deal_contact_map_t_deal_contact_map_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_deal_contact_map_t_deal_contact_map_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_deal_contact_map_t_deal_contact_map_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_deal_contact_map_t_deal_contact_map_id OWNED BY core.deal_contact_map_t.deal_contact_map_id;


--
-- Name: seq_deal_t_deal_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_deal_t_deal_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_deal_t_deal_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_deal_t_deal_id OWNED BY core.deal_t.deal_id;


--
-- Name: seq_email_campaign_bounced_email_t; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_email_campaign_bounced_email_t
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_email_campaign_bounced_email_t; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_email_campaign_bounced_email_t OWNED BY core.email_campaign_bounced_email_t.email_campaign_bounced_email_id;


--
-- Name: seq_email_campaign_clicked_url_t; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_email_campaign_clicked_url_t
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_email_campaign_clicked_url_t; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_email_campaign_clicked_url_t OWNED BY core.email_campaign_clicked_url_t.email_campaign_clicked_url_id;


--
-- Name: seq_email_campaign_opened_by_t; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_email_campaign_opened_by_t
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_email_campaign_opened_by_t; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_email_campaign_opened_by_t OWNED BY core.email_campaign_opened_by_t.email_campaign_opened_by_id;


--
-- Name: seq_email_campaign_recipient_t; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_email_campaign_recipient_t
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_email_campaign_recipient_t; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_email_campaign_recipient_t OWNED BY core.email_campaign_recipient_t.email_campaign_recipient_id;


--
-- Name: seq_email_campaign_report_t; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_email_campaign_report_t
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_email_campaign_report_t; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_email_campaign_report_t OWNED BY core.email_campaign_report_t.email_campaign_report_id;


--
-- Name: seq_employee_t_employee_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_employee_t_employee_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_employee_t_employee_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_employee_t_employee_id OWNED BY core.employee_t.employee_id;


--
-- Name: seq_iso_3166_country_list_t_iso_3166_country_list_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_iso_3166_country_list_t_iso_3166_country_list_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_iso_3166_country_list_t_iso_3166_country_list_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_iso_3166_country_list_t_iso_3166_country_list_id OWNED BY core.iso_3166_country_list_t.iso_3166_country_list_id;


--
-- Name: seq_issue_comment_t_issue_comment_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_issue_comment_t_issue_comment_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_issue_comment_t_issue_comment_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_issue_comment_t_issue_comment_id OWNED BY core.issue_comment_t.issue_comment_id;


--
-- Name: seq_issue_relation_map_t_issue_relation_map_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_issue_relation_map_t_issue_relation_map_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_issue_relation_map_t_issue_relation_map_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_issue_relation_map_t_issue_relation_map_id OWNED BY core.issue_relation_map_t.issue_relation_map_id;


--
-- Name: seq_issue_t_issue_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_issue_t_issue_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_issue_t_issue_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_issue_t_issue_id OWNED BY core.issue_t.issue_id;


--
-- Name: seq_list_segment_list_member_map_t; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_list_segment_list_member_map_t
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_list_segment_list_member_map_t; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_list_segment_list_member_map_t OWNED BY core.list_segment_list_member_map_t.list_segment_list_member_map_id;


--
-- Name: seq_mail_message_t_mail_message_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_mail_message_t_mail_message_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_mail_message_t_mail_message_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_mail_message_t_mail_message_id OWNED BY core.mail_message_t.mail_message_id;


--
-- Name: seq_mailing_list_member_t; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_mailing_list_member_t
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_mailing_list_member_t; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_mailing_list_member_t OWNED BY core.mailing_list_member_t.mailing_list_member_id;


--
-- Name: seq_mailing_list_segment_t; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_mailing_list_segment_t
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_mailing_list_segment_t; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_mailing_list_segment_t OWNED BY core.mailing_list_segment_t.mailing_list_segment_id;


--
-- Name: seq_mailing_list_t; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_mailing_list_t
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_mailing_list_t; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_mailing_list_t OWNED BY core.mailing_list_t.mailing_list_id;


--
-- Name: seq_note_t_note_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_note_t_note_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_note_t_note_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_note_t_note_id OWNED BY core.note_t.note_id;


--
-- Name: seq_organization_relation_t_organization_relation_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_organization_relation_t_organization_relation_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_organization_relation_t_organization_relation_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_organization_relation_t_organization_relation_id OWNED BY core.organization_relation_t.organization_relation_id;


--
-- Name: seq_organization_t_organization_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_organization_t_organization_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_organization_t_organization_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_organization_t_organization_id OWNED BY core.organization_t.organization_id;


--
-- Name: seq_party_t_party_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_party_t_party_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_party_t_party_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_party_t_party_id OWNED BY core.party_t.party_id;


--
-- Name: seq_project_t_project_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_project_t_project_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_project_t_project_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_project_t_project_id OWNED BY core.project_t.project_id;


--
-- Name: seq_release_t_release_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_release_t_release_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_release_t_release_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_release_t_release_id OWNED BY core.release_t.release_id;


--
-- Name: seq_sale_t_fk_revenue_type_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_sale_t_fk_revenue_type_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_sale_t_fk_revenue_type_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_sale_t_fk_revenue_type_id OWNED BY core.sale_t.fk_revenue_type_id;


--
-- Name: seq_sale_t_sale_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_sale_t_sale_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_sale_t_sale_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_sale_t_sale_id OWNED BY core.sale_t.sale_id;


--
-- Name: worklog_t; Type: TABLE; Schema: core;
--

CREATE TABLE core.worklog_t (
    worklog_id integer NOT NULL,
    worklog_key text NOT NULL,
    fk_issue_id integer NOT NULL,
    fk_employee_id_created_by integer NOT NULL,
    time_logged interval NOT NULL,
    worklog_comment text NOT NULL,
    work_started_at_timestamp timestamp with time zone NOT NULL,
    tempo_id integer NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_work_started_date integer NOT NULL,
    hours_logged numeric(10,5) NOT NULL,
    days_logged numeric(10,5) NOT NULL
);



--
-- Name: seq_worklog_t_worklog_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_worklog_t_worklog_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: seq_worklog_t_worklog_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_worklog_t_worklog_id OWNED BY core.worklog_t.worklog_id;


--
-- Name: activity_t activity_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.activity_t ALTER COLUMN activity_id SET DEFAULT nextval('core.seq_activity_t_activity_id'::regclass);


--
-- Name: c_partner_list_t partner_list_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.c_partner_list_t ALTER COLUMN partner_list_id SET DEFAULT nextval('core.seq_c_partner_list_t_partner_list_id'::regclass);


--
-- Name: c_revenue_type_t revenue_type_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.c_revenue_type_t ALTER COLUMN revenue_type_id SET DEFAULT nextval('core.seq_c_revenue_type_t_revenue_type_id'::regclass);


--
-- Name: contact_t contact_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.contact_t ALTER COLUMN contact_id SET DEFAULT nextval('core.seq_contact_t_contact_id'::regclass);


--
-- Name: deal_change_log_t deal_change_log_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.deal_change_log_t ALTER COLUMN deal_change_log_id SET DEFAULT nextval('core.seq_deal_change_log_t_deal_change_log_id'::regclass);


--
-- Name: deal_contact_map_t deal_contact_map_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.deal_contact_map_t ALTER COLUMN deal_contact_map_id SET DEFAULT nextval('core.seq_deal_contact_map_t_deal_contact_map_id'::regclass);


--
-- Name: deal_t deal_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.deal_t ALTER COLUMN deal_id SET DEFAULT nextval('core.seq_deal_t_deal_id'::regclass);


--
-- Name: email_campaign_bounced_email_t email_campaign_bounced_email_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_bounced_email_t ALTER COLUMN email_campaign_bounced_email_id SET DEFAULT nextval('core.seq_email_campaign_bounced_email_t'::regclass);


--
-- Name: email_campaign_clicked_url_t email_campaign_clicked_url_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_clicked_url_t ALTER COLUMN email_campaign_clicked_url_id SET DEFAULT nextval('core.seq_email_campaign_clicked_url_t'::regclass);


--
-- Name: email_campaign_opened_by_t email_campaign_opened_by_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_opened_by_t ALTER COLUMN email_campaign_opened_by_id SET DEFAULT nextval('core.seq_email_campaign_opened_by_t'::regclass);


--
-- Name: email_campaign_recipient_t email_campaign_recipient_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_recipient_t ALTER COLUMN email_campaign_recipient_id SET DEFAULT nextval('core.seq_email_campaign_recipient_t'::regclass);


--
-- Name: email_campaign_report_t email_campaign_report_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_report_t ALTER COLUMN email_campaign_report_id SET DEFAULT nextval('core.seq_email_campaign_report_t'::regclass);


--
-- Name: employee_t employee_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.employee_t ALTER COLUMN employee_id SET DEFAULT nextval('core.seq_employee_t_employee_id'::regclass);


--
-- Name: iso_3166_country_list_t iso_3166_country_list_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.iso_3166_country_list_t ALTER COLUMN iso_3166_country_list_id SET DEFAULT nextval('core.seq_iso_3166_country_list_t_iso_3166_country_list_id'::regclass);


--
-- Name: issue_comment_t issue_comment_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.issue_comment_t ALTER COLUMN issue_comment_id SET DEFAULT nextval('core.seq_issue_comment_t_issue_comment_id'::regclass);


--
-- Name: issue_relation_map_t issue_relation_map_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.issue_relation_map_t ALTER COLUMN issue_relation_map_id SET DEFAULT nextval('core.seq_issue_relation_map_t_issue_relation_map_id'::regclass);


--
-- Name: issue_t issue_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.issue_t ALTER COLUMN issue_id SET DEFAULT nextval('core.seq_issue_t_issue_id'::regclass);


--
-- Name: list_segment_list_member_map_t list_segment_list_member_map_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.list_segment_list_member_map_t ALTER COLUMN list_segment_list_member_map_id SET DEFAULT nextval('core.seq_list_segment_list_member_map_t'::regclass);


--
-- Name: mail_message_t mail_message_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.mail_message_t ALTER COLUMN mail_message_id SET DEFAULT nextval('core.seq_mail_message_t_mail_message_id'::regclass);


--
-- Name: mailing_list_member_t mailing_list_member_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_member_t ALTER COLUMN mailing_list_member_id SET DEFAULT nextval('core.seq_mailing_list_member_t'::regclass);


--
-- Name: mailing_list_segment_t mailing_list_segment_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_segment_t ALTER COLUMN mailing_list_segment_id SET DEFAULT nextval('core.seq_mailing_list_segment_t'::regclass);


--
-- Name: mailing_list_t mailing_list_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_t ALTER COLUMN mailing_list_id SET DEFAULT nextval('core.seq_mailing_list_t'::regclass);


--
-- Name: note_t note_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.note_t ALTER COLUMN note_id SET DEFAULT nextval('core.seq_note_t_note_id'::regclass);


--
-- Name: organization_relation_t organization_relation_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.organization_relation_t ALTER COLUMN organization_relation_id SET DEFAULT nextval('core.seq_organization_relation_t_organization_relation_id'::regclass);


--
-- Name: organization_t organization_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.organization_t ALTER COLUMN organization_id SET DEFAULT nextval('core.seq_organization_t_organization_id'::regclass);


--
-- Name: party_t party_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.party_t ALTER COLUMN party_id SET DEFAULT nextval('core.seq_party_t_party_id'::regclass);


--
-- Name: project_t project_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.project_t ALTER COLUMN project_id SET DEFAULT nextval('core.seq_project_t_project_id'::regclass);


--
-- Name: release_t release_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.release_t ALTER COLUMN release_id SET DEFAULT nextval('core.seq_release_t_release_id'::regclass);


--
-- Name: sale_t sale_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.sale_t ALTER COLUMN sale_id SET DEFAULT nextval('core.seq_sale_t_sale_id'::regclass);


--
-- Name: sale_t fk_revenue_type_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.sale_t ALTER COLUMN fk_revenue_type_id SET DEFAULT nextval('core.seq_sale_t_fk_revenue_type_id'::regclass);


--
-- Name: worklog_t worklog_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.worklog_t ALTER COLUMN worklog_id SET DEFAULT nextval('core.seq_worklog_t_worklog_id'::regclass);


--
-- Name: activity_t pk_activity_t_activity_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.activity_t
    ADD CONSTRAINT pk_activity_t_activity_id PRIMARY KEY (activity_id);


--
-- Name: c_partner_list_t pk_c_partner_list_t_partner_list_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_partner_list_t
    ADD CONSTRAINT pk_c_partner_list_t_partner_list_id PRIMARY KEY (partner_list_id);


--
-- Name: c_revenue_type_t pk_c_revenue_type_t_revenue_type_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_revenue_type_t
    ADD CONSTRAINT pk_c_revenue_type_t_revenue_type_id PRIMARY KEY (revenue_type_id);


--
-- Name: contact_t pk_contact_t_contact_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_t
    ADD CONSTRAINT pk_contact_t_contact_id PRIMARY KEY (contact_id);


--
-- Name: deal_change_log_t pk_deal_change_log_t_deal_change_log_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_change_log_t
    ADD CONSTRAINT pk_deal_change_log_t_deal_change_log_id PRIMARY KEY (deal_change_log_id);


--
-- Name: deal_contact_map_t pk_deal_contact_map_t_deal_contact_map_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_contact_map_t
    ADD CONSTRAINT pk_deal_contact_map_t_deal_contact_map_id PRIMARY KEY (deal_contact_map_id);


--
-- Name: deal_t pk_deal_t_deal_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT pk_deal_t_deal_id PRIMARY KEY (deal_id);


--
-- Name: email_campaign_bounced_email_t pk_email_campaign_bounced_email_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_bounced_email_t
    ADD CONSTRAINT pk_email_campaign_bounced_email_t PRIMARY KEY (email_campaign_bounced_email_id);


--
-- Name: email_campaign_clicked_url_t pk_email_campaign_clicked_url_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_clicked_url_t
    ADD CONSTRAINT pk_email_campaign_clicked_url_t PRIMARY KEY (email_campaign_clicked_url_id);


--
-- Name: email_campaign_opened_by_t pk_email_campaign_opened_by_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_opened_by_t
    ADD CONSTRAINT pk_email_campaign_opened_by_t PRIMARY KEY (email_campaign_opened_by_id);


--
-- Name: email_campaign_recipient_t pk_email_campaign_recipient_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_recipient_t
    ADD CONSTRAINT pk_email_campaign_recipient_t PRIMARY KEY (email_campaign_recipient_id);


--
-- Name: email_campaign_report_t pk_email_campaign_report_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_report_t
    ADD CONSTRAINT pk_email_campaign_report_t PRIMARY KEY (email_campaign_report_id);


--
-- Name: employee_t pk_employee_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.employee_t
    ADD CONSTRAINT pk_employee_t PRIMARY KEY (employee_id);


--
-- Name: iso_3166_country_list_t pk_iso_3166_country_list_t_iso_3166_country_list_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.iso_3166_country_list_t
    ADD CONSTRAINT pk_iso_3166_country_list_t_iso_3166_country_list_id PRIMARY KEY (iso_3166_country_list_id);


--
-- Name: issue_comment_t pk_issue_comment_t_issue_comment_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_comment_t
    ADD CONSTRAINT pk_issue_comment_t_issue_comment_id PRIMARY KEY (issue_comment_id);


--
-- Name: issue_relation_map_t pk_issue_relation_map_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_relation_map_t
    ADD CONSTRAINT pk_issue_relation_map_t PRIMARY KEY (issue_relation_map_id);


--
-- Name: issue_t pk_issue_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT pk_issue_t PRIMARY KEY (issue_id);


--
-- Name: list_segment_list_member_map_t pk_list_segment_list_member_map_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.list_segment_list_member_map_t
    ADD CONSTRAINT pk_list_segment_list_member_map_t PRIMARY KEY (list_segment_list_member_map_id);


--
-- Name: mail_message_t pk_mail_message_t_mail_message_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mail_message_t
    ADD CONSTRAINT pk_mail_message_t_mail_message_id PRIMARY KEY (mail_message_id);


--
-- Name: mailing_list_member_t pk_mailing_list_member_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_member_t
    ADD CONSTRAINT pk_mailing_list_member_t PRIMARY KEY (mailing_list_member_id);


--
-- Name: mailing_list_segment_t pk_mailing_list_segment_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_segment_t
    ADD CONSTRAINT pk_mailing_list_segment_t PRIMARY KEY (mailing_list_segment_id);


--
-- Name: mailing_list_t pk_mailing_list_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_t
    ADD CONSTRAINT pk_mailing_list_t PRIMARY KEY (mailing_list_id);
    

--
-- Name: note_t pk_note_t_note_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.note_t
    ADD CONSTRAINT pk_note_t_note_id PRIMARY KEY (note_id);


--
-- Name: organization_relation_t pk_organization_relation_t_organization_relation_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_relation_t
    ADD CONSTRAINT pk_organization_relation_t_organization_relation_id PRIMARY KEY (organization_relation_id);


--
-- Name: organization_t pk_organization_t_organization_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_t
    ADD CONSTRAINT pk_organization_t_organization_id PRIMARY KEY (organization_id);


--
-- Name: party_t pk_party_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.party_t
    ADD CONSTRAINT pk_party_t PRIMARY KEY (party_id);


--
-- Name: project_t pk_project_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.project_t
    ADD CONSTRAINT pk_project_t PRIMARY KEY (project_id);


--
-- Name: release_t pk_release_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.release_t
    ADD CONSTRAINT pk_release_t PRIMARY KEY (release_id);


--
-- Name: sale_t pk_sale_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT pk_sale_t PRIMARY KEY (sale_id);


--
-- Name: worklog_t pk_worklog_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.worklog_t
    ADD CONSTRAINT pk_worklog_t PRIMARY KEY (worklog_id);


--
-- Name: activity_t ux_activity_t_activity_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.activity_t
    ADD CONSTRAINT ux_activity_t_activity_key UNIQUE (activity_key);


--
-- Name: contact_t ux_contact_t_contact_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_t
    ADD CONSTRAINT ux_contact_t_contact_key UNIQUE (contact_key);


--
-- Name: deal_change_log_t ux_deal_change_log_t_deal_change_log_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_change_log_t
    ADD CONSTRAINT ux_deal_change_log_t_deal_change_log_key UNIQUE (deal_change_log_key);


--
-- Name: deal_contact_map_t ux_deal_contact_map_t_deal_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_contact_map_t
    ADD CONSTRAINT ux_deal_contact_map_t_deal_key UNIQUE (deal_key, contact_key);


--
-- Name: deal_t ux_deal_t_deal_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT ux_deal_t_deal_key UNIQUE (deal_key);


--
-- Name: email_campaign_bounced_email_t ux_email_campaign_bounced_email_t_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_bounced_email_t
    ADD CONSTRAINT ux_email_campaign_bounced_email_t_key UNIQUE (email_campaign_bounced_email_key);


--
-- Name: email_campaign_clicked_url_t ux_email_campaign_clicked_url_t_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_clicked_url_t
    ADD CONSTRAINT ux_email_campaign_clicked_url_t_key UNIQUE (email_campaign_clicked_url_key);


--
-- Name: email_campaign_opened_by_t ux_email_campaign_opened_by_t_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_opened_by_t
    ADD CONSTRAINT ux_email_campaign_opened_by_t_key UNIQUE (email_campaign_opened_by_key);


--
-- Name: email_campaign_recipient_t ux_email_campaign_recipient_t_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_recipient_t
    ADD CONSTRAINT ux_email_campaign_recipient_t_key UNIQUE (email_campaign_recipient_key);


--
-- Name: email_campaign_report_t ux_email_campaign_report_t_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_report_t
    ADD CONSTRAINT ux_email_campaign_report_t_key UNIQUE (email_campaign_report_key);


--
-- Name: employee_t ux_employee_t_employee_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.employee_t
    ADD CONSTRAINT ux_employee_t_employee_key UNIQUE (employee_key);


--
-- Name: iso_3166_country_list_t ux_iso_3166_country_list_t_iso_3166_country_list_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.iso_3166_country_list_t
    ADD CONSTRAINT ux_iso_3166_country_list_t_iso_3166_country_list_key UNIQUE (iso_3166_country_list_key);


--
-- Name: issue_comment_t ux_issue_comment_t_issue_comment_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_comment_t
    ADD CONSTRAINT ux_issue_comment_t_issue_comment_key UNIQUE (issue_comment_key);


--
-- Name: issue_relation_map_t ux_issue_relation_map_t; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_relation_map_t
    ADD CONSTRAINT ux_issue_relation_map_t UNIQUE (issue_key, issue_key_related_issue, relation, relation_direction);


--
-- Name: issue_t ux_issue_t_issue_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT ux_issue_t_issue_key UNIQUE (issue_key);


--
-- Name: issue_t ux_issue_t_jira_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT ux_issue_t_jira_id UNIQUE (jira_id);


--
-- Name: issue_t ux_issue_t_jira_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT ux_issue_t_jira_key UNIQUE (jira_key);


--
-- Name: list_segment_list_member_map_t ux_list_segment_list_member_map_t_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.list_segment_list_member_map_t
    ADD CONSTRAINT ux_list_segment_list_member_map_t_key UNIQUE (list_segment_key, list_member_key);


--
-- Name: mailing_list_member_t ux_mailing_list_member_t_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_member_t
    ADD CONSTRAINT ux_mailing_list_member_t_key UNIQUE (mailing_list_member_key);


--
-- Name: mailing_list_segment_t ux_mailing_list_segment_t_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_segment_t
    ADD CONSTRAINT ux_mailing_list_segment_t_key UNIQUE (mailing_list_segment_key);


--
-- Name: mailing_list_t ux_mailing_list_t_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_t
    ADD CONSTRAINT ux_mailing_list_t_key UNIQUE (mailing_list_key);

--
-- Name: note_t ux_note_t_note_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.note_t
    ADD CONSTRAINT ux_note_t_note_key UNIQUE (note_key);


--
-- Name: organization_relation_t ux_organization_relation_t_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_relation_t
    ADD CONSTRAINT ux_organization_relation_t_key UNIQUE (organization_key, organization_key_related_organization, related_organization_is);


--
-- Name: organization_t ux_organization_t_organization_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_t
    ADD CONSTRAINT ux_organization_t_organization_key UNIQUE (organization_key);


--
-- Name: c_partner_list_t ux_partner_list_t_partner_name; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_partner_list_t
    ADD CONSTRAINT ux_partner_list_t_partner_name UNIQUE (partner_name);


--
-- Name: party_t ux_party_t_party_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.party_t
    ADD CONSTRAINT ux_party_t_party_key UNIQUE (party_key);


--
-- Name: project_t ux_project_t_jira_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.project_t
    ADD CONSTRAINT ux_project_t_jira_id UNIQUE (jira_id);


--
-- Name: project_t ux_project_t_jira_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.project_t
    ADD CONSTRAINT ux_project_t_jira_key UNIQUE (jira_key);


--
-- Name: project_t ux_project_t_project_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.project_t
    ADD CONSTRAINT ux_project_t_project_key UNIQUE (project_key);


--
-- Name: release_t ux_release_t_jira_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.release_t
    ADD CONSTRAINT ux_release_t_jira_id UNIQUE (jira_id);


--
-- Name: release_t ux_release_t_release_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.release_t
    ADD CONSTRAINT ux_release_t_release_key UNIQUE (release_key);


--
-- Name: release_t ux_release_t_release_name; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.release_t
    ADD CONSTRAINT ux_release_t_release_name UNIQUE (release_name);


--
-- Name: c_revenue_type_t ux_revenue_type_t_revenue_type_name; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_revenue_type_t
    ADD CONSTRAINT ux_revenue_type_t_revenue_type_name UNIQUE (revenue_type_name);


--
-- Name: sale_t ux_sale_t_fk_organization_id_reseller; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT ux_sale_t_fk_organization_id_reseller UNIQUE (sale_key);


--
-- Name: sale_t ux_sale_t_sale_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT ux_sale_t_sale_key UNIQUE (sale_key);


--
-- Name: worklog_t ux_worklog_t_fk_tempo_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.worklog_t
    ADD CONSTRAINT ux_worklog_t_fk_tempo_id UNIQUE (tempo_id);


--
-- Name: worklog_t ux_worklog_t_worklog_key; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.worklog_t
    ADD CONSTRAINT ux_worklog_t_worklog_key UNIQUE (worklog_key);


--
-- Name: ix_activity_t_fk_contact_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_activity_t_fk_contact_id ON core.activity_t USING btree (fk_contact_id);


--
-- Name: ix_activity_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_activity_t_fk_date_id_created_date ON core.activity_t USING btree (fk_date_id_created_date);


--
-- Name: ix_activity_t_fk_date_id_due_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_activity_t_fk_date_id_due_date ON core.activity_t USING btree (fk_date_id_due_date);


--
-- Name: ix_activity_t_fk_date_id_marked_as_done; Type: INDEX; Schema: core;
--

CREATE INDEX ix_activity_t_fk_date_id_marked_as_done ON core.activity_t USING btree (fk_date_id_marked_as_done);


--
-- Name: ix_activity_t_fk_deal_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_activity_t_fk_deal_id ON core.activity_t USING btree (fk_deal_id);


--
-- Name: ix_activity_t_fk_employee_id_assigned_to; Type: INDEX; Schema: core;
--

CREATE INDEX ix_activity_t_fk_employee_id_assigned_to ON core.activity_t USING btree (fk_employee_id_assigned_to);


--
-- Name: ix_activity_t_fk_employee_id_created_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_activity_t_fk_employee_id_created_by ON core.activity_t USING btree (fk_employee_id_created_by);


--
-- Name: ix_activity_t_fk_organization_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_activity_t_fk_organization_id ON core.activity_t USING btree (fk_organization_id);


--
-- Name: ix_contact_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_contact_t_fk_date_id_created_date ON core.contact_t USING btree (fk_date_id_created_date);


--
-- Name: ix_contact_t_fk_date_id_last_updated_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_contact_t_fk_date_id_last_updated_date ON core.contact_t USING btree (fk_date_id_last_updated_date);


--
-- Name: ix_contact_t_fk_employee_id_owner; Type: INDEX; Schema: core;
--

CREATE INDEX ix_contact_t_fk_employee_id_owner ON core.contact_t USING btree (fk_employee_id_owner);


--
-- Name: ix_contact_t_fk_organization_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_contact_t_fk_organization_id ON core.contact_t USING btree (fk_organization_id);


--
-- Name: ix_contact_t_fk_party_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_contact_t_fk_party_id ON core.contact_t USING btree (fk_party_id);


--
-- Name: ix_deal_change_log_t_fk_date_id_log_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_change_log_t_fk_date_id_log_date ON core.deal_change_log_t USING btree (fk_date_id_log_date);


--
-- Name: ix_deal_change_log_t_fk_deal_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_change_log_t_fk_deal_id ON core.deal_change_log_t USING btree (fk_deal_id);


--
-- Name: ix_deal_change_log_t_fk_employee_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_change_log_t_fk_employee_id ON core.deal_change_log_t USING btree (fk_employee_id);


--
-- Name: ix_deal_contact_map_t_fk_contact_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_contact_map_t_fk_contact_id ON core.deal_contact_map_t USING btree (fk_contact_id);


--
-- Name: ix_deal_contact_map_t_fk_deal_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_contact_map_t_fk_deal_id ON core.deal_contact_map_t USING btree (fk_deal_id);


--
-- Name: ix_deal_t_fk_contact_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_contact_id ON core.deal_t USING btree (fk_contact_id);


--
-- Name: ix_deal_t_fk_currency_id_deal_currency; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_currency_id_deal_currency ON core.deal_t USING btree (fk_currency_id_deal_currency);


--
-- Name: ix_deal_t_fk_date_id_closed_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_date_id_closed_date ON core.deal_t USING btree (fk_date_id_closed_date);


--
-- Name: ix_deal_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_date_id_created_date ON core.deal_t USING btree (fk_date_id_created_date);


--
-- Name: ix_deal_t_fk_date_id_expected_close_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_date_id_expected_close_date ON core.deal_t USING btree (fk_date_id_expected_close_date);


--
-- Name: ix_deal_t_fk_date_id_last_updated_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_date_id_last_updated_date ON core.deal_t USING btree (fk_date_id_last_updated_date);


--
-- Name: ix_deal_t_fk_date_id_lost_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_date_id_lost_date ON core.deal_t USING btree (fk_date_id_lost_date);


--
-- Name: ix_deal_t_fk_date_id_won_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_date_id_won_date ON core.deal_t USING btree (fk_date_id_won_date);


--
-- Name: ix_deal_t_fk_employee_id_owner; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_employee_id_owner ON core.deal_t USING btree (fk_employee_id_owner);


--
-- Name: ix_deal_t_fk_issue_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_issue_id ON core.deal_t USING btree (fk_issue_id);


--
-- Name: ix_deal_t_fk_organization_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_t_fk_organization_id ON core.deal_t USING btree (fk_organization_id);


--
-- Name: ix_email_campaign_bounced_email_t_fk_email_campaign_report_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_email_campaign_bounced_email_t_fk_email_campaign_report_id ON core.email_campaign_bounced_email_t USING btree (fk_email_campaign_report_id);


--
-- Name: ix_email_campaign_clicked_url_t_fk_email_campaign_report_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_email_campaign_clicked_url_t_fk_email_campaign_report_id ON core.email_campaign_clicked_url_t USING btree (fk_email_campaign_report_id);


--
-- Name: ix_email_campaign_opened_by_t_fk_email_campaign_report_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_email_campaign_opened_by_t_fk_email_campaign_report_id ON core.email_campaign_opened_by_t USING btree (fk_email_campaign_report_id);


--
-- Name: ix_email_campaign_recipient_t_email_address; Type: INDEX; Schema: core;
--

CREATE INDEX ix_email_campaign_recipient_t_email_address ON core.email_campaign_recipient_t USING btree (email_address);


--
-- Name: ix_email_campaign_recipient_t_fk_email_campaign_report_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_email_campaign_recipient_t_fk_email_campaign_report_id ON core.email_campaign_recipient_t USING btree (fk_email_campaign_report_id);


--
-- Name: ix_email_campaign_report_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_email_campaign_report_t_fk_date_id_created_date ON core.email_campaign_report_t USING btree (fk_date_id_created_date);


--
-- Name: ix_email_campaign_report_t_fk_date_id_last_click_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_email_campaign_report_t_fk_date_id_last_click_date ON core.email_campaign_report_t USING btree (fk_date_id_last_click_date);


--
-- Name: ix_email_campaign_report_t_fk_date_id_last_open_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_email_campaign_report_t_fk_date_id_last_open_date ON core.email_campaign_report_t USING btree (fk_date_id_last_open_date);


--
-- Name: ix_email_campaign_report_t_fk_date_id_send_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_email_campaign_report_t_fk_date_id_send_date ON core.email_campaign_report_t USING btree (fk_date_id_send_date);


--
-- Name: ix_employee_t_email; Type: INDEX; Schema: core;
--

CREATE INDEX ix_employee_t_email ON core.employee_t USING btree (email);


--
-- Name: ix_employee_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_employee_t_fk_date_id_created_date ON core.employee_t USING btree (fk_date_id_created_date);


--
-- Name: ix_fk_sale_t_fk_party_id_sales_representative; Type: INDEX; Schema: core;
--

CREATE INDEX ix_fk_sale_t_fk_party_id_sales_representative ON core.sale_t USING btree (fk_party_id_sales_representative);


--
-- Name: ix_issue_comment_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_comment_t_fk_date_id_created_date ON core.issue_comment_t USING btree (fk_date_id_created_date);


--
-- Name: ix_issue_comment_t_fk_date_id_last_updated_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_comment_t_fk_date_id_last_updated_date ON core.issue_comment_t USING btree (fk_date_id_last_updated_date);


--
-- Name: ix_issue_comment_t_fk_employee_id_created_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_comment_t_fk_employee_id_created_by ON core.issue_comment_t USING btree (fk_employee_id_created_by);


--
-- Name: ix_issue_comment_t_fk_employee_id_updated_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_comment_t_fk_employee_id_updated_by ON core.issue_comment_t USING btree (fk_employee_id_updated_by);


--
-- Name: ix_issue_comment_t_fk_issue_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_comment_t_fk_issue_id ON core.issue_comment_t USING btree (fk_issue_id);


--
-- Name: ix_issue_relation_map_t_fk_issue_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_relation_map_t_fk_issue_id ON core.issue_relation_map_t USING btree (fk_issue_id);


--
-- Name: ix_issue_relation_map_t_fk_issue_id_related_issue; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_relation_map_t_fk_issue_id_related_issue ON core.issue_relation_map_t USING btree (fk_issue_id_related_issue);


--
-- Name: ix_issue_relation_map_t_relation; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_relation_map_t_relation ON core.issue_relation_map_t USING btree (relation);


--
-- Name: ix_issue_relation_map_t_relation_direction; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_relation_map_t_relation_direction ON core.issue_relation_map_t USING btree (relation_direction);


--
-- Name: ix_issue_t_account; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_account ON core.issue_t USING btree (account);


--
-- Name: ix_issue_t_deployment; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_deployment ON core.issue_t USING btree (deployment);


--
-- Name: ix_issue_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_date_id_created_date ON core.issue_t USING btree (fk_date_id_created_date);


--
-- Name: ix_issue_t_fk_date_id_deployment_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_date_id_deployment_date ON core.issue_t USING btree (fk_date_id_deployment_date);


--
-- Name: ix_issue_t_fk_date_id_first_response_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_date_id_first_response_date ON core.issue_t USING btree (fk_date_id_first_response_date);


--
-- Name: ix_issue_t_fk_date_id_inception_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_date_id_inception_date ON core.issue_t USING btree (fk_date_id_inception_date);


--
-- Name: ix_issue_t_fk_date_id_pilot_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_date_id_pilot_date ON core.issue_t USING btree (fk_date_id_pilot_date);


--
-- Name: ix_issue_t_fk_date_id_pilot_finished_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_date_id_pilot_finished_date ON core.issue_t USING btree (fk_date_id_pilot_finished_date);


--
-- Name: ix_issue_t_fk_date_id_resolution_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_date_id_resolution_date ON core.issue_t USING btree (fk_date_id_resolution_date);


--
-- Name: ix_issue_t_fk_date_id_sales_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_date_id_sales_date ON core.issue_t USING btree (fk_date_id_sales_date);


--
-- Name: ix_issue_t_fk_employee_id_assigned_to; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_employee_id_assigned_to ON core.issue_t USING btree (fk_employee_id_assigned_to);


--
-- Name: ix_issue_t_fk_party_id_created_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_party_id_created_by ON core.issue_t USING btree (fk_party_id_created_by);


--
-- Name: ix_issue_t_fk_party_id_reported_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_party_id_reported_by ON core.issue_t USING btree (fk_party_id_reported_by);


--
-- Name: ix_issue_t_fk_project_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_fk_project_id ON core.issue_t USING btree (fk_project_id);


--
-- Name: ix_issue_t_status; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_t_status ON core.issue_t USING btree (status);


--
-- Name: ix_list_segment_list_member_map_t_fk_mailing_list_member_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_list_segment_list_member_map_t_fk_mailing_list_member_id ON core.list_segment_list_member_map_t USING btree (fk_mailing_list_member_id);


--
-- Name: ix_list_segment_list_member_map_t_fk_mailing_list_segment_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_list_segment_list_member_map_t_fk_mailing_list_segment_id ON core.list_segment_list_member_map_t USING btree (fk_mailing_list_segment_id);


--
-- Name: ix_mail_message_t_fk_contact_id_bcc; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mail_message_t_fk_contact_id_bcc ON core.mail_message_t USING btree (fk_contact_id_bcc);


--
-- Name: ix_mail_message_t_fk_contact_id_cc; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mail_message_t_fk_contact_id_cc ON core.mail_message_t USING btree (fk_contact_id_cc);


--
-- Name: ix_mail_message_t_fk_contact_id_from; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mail_message_t_fk_contact_id_from ON core.mail_message_t USING btree (fk_contact_id_from);


--
-- Name: ix_mail_message_t_fk_contact_id_to; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mail_message_t_fk_contact_id_to ON core.mail_message_t USING btree (fk_contact_id_to);


--
-- Name: ix_mail_message_t_fk_date_id_sent_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mail_message_t_fk_date_id_sent_date ON core.mail_message_t USING btree (fk_date_id_sent_date);


--
-- Name: ix_mail_message_t_fk_deal_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mail_message_t_fk_deal_id ON core.mail_message_t USING btree (fk_deal_id);


--
-- Name: ix_mail_message_t_fk_employee_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mail_message_t_fk_employee_id ON core.mail_message_t USING btree (fk_employee_id);


--
-- Name: ix_mailing_list_member_t_email_address; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_member_t_email_address ON core.mailing_list_member_t USING btree (email_address);


--
-- Name: ix_mailing_list_member_t_fk_date_id_last_changed_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_member_t_fk_date_id_last_changed_date ON core.mailing_list_member_t USING btree (fk_date_id_last_changed_date);


--
-- Name: ix_mailing_list_member_t_fk_date_id_opt_in_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_member_t_fk_date_id_opt_in_date ON core.mailing_list_member_t USING btree (fk_date_id_opt_in_date);


--
-- Name: ix_mailing_list_member_t_fk_date_id_signup_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_member_t_fk_date_id_signup_date ON core.mailing_list_member_t USING btree (fk_date_id_signup_date);


--
-- Name: ix_mailing_list_member_t_fk_mailing_list_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_member_t_fk_mailing_list_id ON core.mailing_list_member_t USING btree (fk_mailing_list_id);


--
-- Name: ix_mailing_list_member_t_fk_party_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_member_t_fk_party_id ON core.mailing_list_member_t USING btree (fk_party_id);


--
-- Name: ix_mailing_list_segment_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_segment_t_fk_date_id_created_date ON core.mailing_list_segment_t USING btree (fk_date_id_created_date);


--
-- Name: ix_mailing_list_segment_t_fk_date_id_last_updated_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_segment_t_fk_date_id_last_updated_date ON core.mailing_list_segment_t USING btree (fk_date_id_last_updated_date);


--
-- Name: ix_mailing_list_segment_t_fk_mailing_list_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_segment_t_fk_mailing_list_id ON core.mailing_list_segment_t USING btree (fk_mailing_list_id);


--
-- Name: ix_mailing_list_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_t_fk_date_id_created_date ON core.mailing_list_t USING btree (fk_date_id_created_date);


--
-- Name: ix_mailing_list_t_fk_date_id_last_sent_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_t_fk_date_id_last_sent_date ON core.mailing_list_t USING btree (fk_date_id_last_sent_date);


--
-- Name: ix_mailing_list_t_fk_date_id_last_sub_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_t_fk_date_id_last_sub_date ON core.mailing_list_t USING btree (fk_date_id_last_sub_date);


--
-- Name: ix_mailing_list_t_fk_date_id_last_unsub_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_mailing_list_t_fk_date_id_last_unsub_date ON core.mailing_list_t USING btree (fk_date_id_last_unsub_date);


--
-- Name: ix_note_t_fk_contact_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_note_t_fk_contact_id ON core.note_t USING btree (fk_contact_id);


--
-- Name: ix_note_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_note_t_fk_date_id_created_date ON core.note_t USING btree (fk_date_id_created_date);


--
-- Name: ix_note_t_fk_date_id_last_modified_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_note_t_fk_date_id_last_modified_date ON core.note_t USING btree (fk_date_id_last_modified_date);


--
-- Name: ix_note_t_fk_deal_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_note_t_fk_deal_id ON core.note_t USING btree (fk_deal_id);


--
-- Name: ix_note_t_fk_employee_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_note_t_fk_employee_id ON core.note_t USING btree (fk_employee_id);


--
-- Name: ix_note_t_fk_organization_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_note_t_fk_organization_id ON core.note_t USING btree (fk_organization_id);


--
-- Name: ix_organization_relation_t_fk_organization_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_organization_relation_t_fk_organization_id ON core.organization_relation_t USING btree (fk_organization_id);


--
-- Name: ix_organization_relation_t_fk_organization_id_relate; Type: INDEX; Schema: core;
--

CREATE INDEX ix_organization_relation_t_fk_organization_id_relate ON core.organization_relation_t USING btree (fk_organization_id_related_organization);


--
-- Name: ix_organization_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_organization_t_fk_date_id_created_date ON core.organization_t USING btree (fk_date_id_created_date);


--
-- Name: ix_organization_t_fk_date_id_last_updated_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_organization_t_fk_date_id_last_updated_date ON core.organization_t USING btree (fk_date_id_last_updated_date);


--
-- Name: ix_organization_t_fk_employee_id_owner; Type: INDEX; Schema: core;
--

CREATE INDEX ix_organization_t_fk_employee_id_owner ON core.organization_t USING btree (fk_employee_id_owner);


--
-- Name: ix_organization_t_fk_party_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_organization_t_fk_party_id ON core.organization_t USING btree (fk_party_id);


--
-- Name: ix_party_t_fk_date_id_created_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_party_t_fk_date_id_created_date ON core.party_t USING btree (fk_date_id_created_date);


--
-- Name: ix_party_t_fk_date_id_last_modified_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_party_t_fk_date_id_last_modified_date ON core.party_t USING btree (fk_date_id_last_modified_date);


--
-- Name: ix_party_t_fk_employee_id_created_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_party_t_fk_employee_id_created_by ON core.party_t USING btree (fk_employee_id_created_by);


--
-- Name: ix_party_t_fk_employee_id_last_modified_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_party_t_fk_employee_id_last_modified_by ON core.party_t USING btree (fk_employee_id_last_modified_by);


--
-- Name: ix_party_t_full_name; Type: INDEX; Schema: core;
--

CREATE INDEX ix_party_t_full_name ON core.party_t USING btree (full_name);


--
-- Name: ix_party_t_short_name; Type: INDEX; Schema: core;
--

CREATE INDEX ix_party_t_short_name ON core.party_t USING btree (short_name);


--
-- Name: ix_project_t_project_name; Type: INDEX; Schema: core;
--

CREATE INDEX ix_project_t_project_name ON core.project_t USING btree (project_name);


--
-- Name: ix_release_t_fk_date_id_release_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_release_t_fk_date_id_release_date ON core.release_t USING btree (fk_date_id_release_date);


--
-- Name: ix_release_t_fk_date_id_start_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_release_t_fk_date_id_start_date ON core.release_t USING btree (fk_date_id_start_date);


--
-- Name: ix_release_t_fk_project_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_release_t_fk_project_id ON core.release_t USING btree (fk_project_id);


--
-- Name: ix_sale_t_fk_currency_id_local_currency; Type: INDEX; Schema: core;
--

CREATE INDEX ix_sale_t_fk_currency_id_local_currency ON core.sale_t USING btree (fk_currency_id_local_currency);


--
-- Name: ix_sale_t_fk_date_id_booking_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_sale_t_fk_date_id_booking_date ON core.sale_t USING btree (fk_date_id_booking_date);


--
-- Name: ix_sale_t_fk_date_id_revenue_end; Type: INDEX; Schema: core;
--

CREATE INDEX ix_sale_t_fk_date_id_revenue_end ON core.sale_t USING btree (fk_date_id_revenue_end);


--
-- Name: ix_sale_t_fk_date_id_revenue_start; Type: INDEX; Schema: core;
--

CREATE INDEX ix_sale_t_fk_date_id_revenue_start ON core.sale_t USING btree (fk_date_id_revenue_start);


--
-- Name: ix_sale_t_fk_organization_id_customer; Type: INDEX; Schema: core;
--

CREATE INDEX ix_sale_t_fk_organization_id_customer ON core.sale_t USING btree (fk_organization_id_customer);


--
-- Name: ix_sale_t_fk_organization_id_reseller; Type: INDEX; Schema: core;
--

CREATE INDEX ix_sale_t_fk_organization_id_reseller ON core.sale_t USING btree (fk_organization_id_reseller);


--
-- Name: ix_sale_t_fk_organization_id_seller; Type: INDEX; Schema: core;
--

CREATE INDEX ix_sale_t_fk_organization_id_seller ON core.sale_t USING btree (fk_organization_id_seller);


--
-- Name: ix_sale_t_fk_revenue_type_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_sale_t_fk_revenue_type_id ON core.sale_t USING btree (fk_revenue_type_id);


--
-- Name: ix_worklog_t_fk_date_id_work_started_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_worklog_t_fk_date_id_work_started_date ON core.worklog_t USING btree (fk_date_id_work_started_date);


--
-- Name: ix_worklog_t_fk_employee_id_created_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_worklog_t_fk_employee_id_created_by ON core.worklog_t USING btree (fk_employee_id_created_by);


--
-- Name: ix_worklog_t_fk_issue_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_worklog_t_fk_issue_id ON core.worklog_t USING btree (fk_issue_id);


--
-- Name: ix_worklog_t_fk_work_started_at_timestamp; Type: INDEX; Schema: core;
--

CREATE INDEX ix_worklog_t_fk_work_started_at_timestamp ON core.worklog_t USING btree (work_started_at_timestamp);


--
-- Name: ux_issue_relation_map_t_id; Type: INDEX; Schema: core;
--

CREATE UNIQUE INDEX ux_issue_relation_map_t_id ON core.issue_relation_map_t USING btree (fk_issue_id, fk_issue_id_related_issue, relation, relation_direction);


--
-- Name: activity_t fk_activity_t_fk_contact_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.activity_t
    ADD CONSTRAINT fk_activity_t_fk_contact_id FOREIGN KEY (fk_contact_id) REFERENCES core.contact_t(contact_id);


--
-- Name: activity_t fk_activity_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.activity_t
    ADD CONSTRAINT fk_activity_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: activity_t fk_activity_t_fk_date_id_due_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.activity_t
    ADD CONSTRAINT fk_activity_t_fk_date_id_due_date FOREIGN KEY (fk_date_id_due_date) REFERENCES core.c_date_g(date_id);


--
-- Name: activity_t fk_activity_t_fk_date_id_marked_as_done; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.activity_t
    ADD CONSTRAINT fk_activity_t_fk_date_id_marked_as_done FOREIGN KEY (fk_date_id_marked_as_done) REFERENCES core.c_date_g(date_id);


--
-- Name: activity_t fk_activity_t_fk_deal_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.activity_t
    ADD CONSTRAINT fk_activity_t_fk_deal_id FOREIGN KEY (fk_deal_id) REFERENCES core.deal_t(deal_id);


--
-- Name: activity_t fk_activity_t_fk_employee_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.activity_t
    ADD CONSTRAINT fk_activity_t_fk_employee_id FOREIGN KEY (fk_employee_id_created_by) REFERENCES core.employee_t(employee_id);


--
-- Name: activity_t fk_activity_t_fk_employee_id_assigned_to; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.activity_t
    ADD CONSTRAINT fk_activity_t_fk_employee_id_assigned_to FOREIGN KEY (fk_employee_id_assigned_to) REFERENCES core.employee_t(employee_id);


--
-- Name: activity_t fk_activity_t_fk_organization_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.activity_t
    ADD CONSTRAINT fk_activity_t_fk_organization_id FOREIGN KEY (fk_organization_id) REFERENCES core.organization_t(organization_id);


--
-- Name: contact_t fk_contact_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_t
    ADD CONSTRAINT fk_contact_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: contact_t fk_contact_t_fk_date_id_last_updated_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_t
    ADD CONSTRAINT fk_contact_t_fk_date_id_last_updated_date FOREIGN KEY (fk_date_id_last_updated_date) REFERENCES core.c_date_g(date_id);


--
-- Name: contact_t fk_contact_t_fk_employee_id_owner; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_t
    ADD CONSTRAINT fk_contact_t_fk_employee_id_owner FOREIGN KEY (fk_employee_id_owner) REFERENCES core.employee_t(employee_id);


--
-- Name: contact_t fk_contact_t_fk_organization_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_t
    ADD CONSTRAINT fk_contact_t_fk_organization_id FOREIGN KEY (fk_organization_id) REFERENCES core.organization_t(organization_id);


--
-- Name: contact_t fk_contact_t_fk_party_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_t
    ADD CONSTRAINT fk_contact_t_fk_party_id FOREIGN KEY (fk_party_id) REFERENCES core.party_t(party_id);


--
-- Name: deal_change_log_t fk_deal_change_log_t_fk_date_id_log_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_change_log_t
    ADD CONSTRAINT fk_deal_change_log_t_fk_date_id_log_date FOREIGN KEY (fk_date_id_log_date) REFERENCES core.c_date_g(date_id);


--
-- Name: deal_change_log_t fk_deal_change_log_t_fk_deal_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_change_log_t
    ADD CONSTRAINT fk_deal_change_log_t_fk_deal_id FOREIGN KEY (fk_deal_id) REFERENCES core.deal_t(deal_id);


--
-- Name: deal_change_log_t fk_deal_change_log_t_fk_employee_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_change_log_t
    ADD CONSTRAINT fk_deal_change_log_t_fk_employee_id FOREIGN KEY (fk_employee_id) REFERENCES core.employee_t(employee_id);


--
-- Name: deal_contact_map_t fk_deal_contact_map_t_fk_contact_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_contact_map_t
    ADD CONSTRAINT fk_deal_contact_map_t_fk_contact_id FOREIGN KEY (fk_contact_id) REFERENCES core.contact_t(contact_id);


--
-- Name: deal_contact_map_t fk_deal_contact_map_t_fk_deal_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_contact_map_t
    ADD CONSTRAINT fk_deal_contact_map_t_fk_deal_id FOREIGN KEY (fk_deal_id) REFERENCES core.deal_t(deal_id);


--
-- Name: deal_t fk_deal_t_fk_contact_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_contact_id FOREIGN KEY (fk_contact_id) REFERENCES core.contact_t(contact_id);


--
-- Name: deal_t fk_deal_t_fk_currency_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_currency_id FOREIGN KEY (fk_currency_id_deal_currency) REFERENCES core.c_currency_g(currency_id);


--
-- Name: deal_t fk_deal_t_fk_date_id_closed_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_date_id_closed_date FOREIGN KEY (fk_date_id_closed_date) REFERENCES core.c_date_g(date_id);


--
-- Name: deal_t fk_deal_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: deal_t fk_deal_t_fk_date_id_expected_close_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_date_id_expected_close_date FOREIGN KEY (fk_date_id_expected_close_date) REFERENCES core.c_date_g(date_id);


--
-- Name: deal_t fk_deal_t_fk_date_id_last_updated_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_date_id_last_updated_date FOREIGN KEY (fk_date_id_last_updated_date) REFERENCES core.c_date_g(date_id);


--
-- Name: deal_t fk_deal_t_fk_date_id_lost_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_date_id_lost_date FOREIGN KEY (fk_date_id_lost_date) REFERENCES core.c_date_g(date_id);


--
-- Name: deal_t fk_deal_t_fk_date_id_won_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_date_id_won_date FOREIGN KEY (fk_date_id_won_date) REFERENCES core.c_date_g(date_id);


--
-- Name: deal_t fk_deal_t_fk_employee_id_owner; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_employee_id_owner FOREIGN KEY (fk_employee_id_owner) REFERENCES core.employee_t(employee_id);


--
-- Name: deal_t fk_deal_t_fk_issue_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_issue_id FOREIGN KEY (fk_issue_id) REFERENCES core.issue_t(issue_id);


--
-- Name: deal_t fk_deal_t_fk_organization_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_t
    ADD CONSTRAINT fk_deal_t_fk_organization_id FOREIGN KEY (fk_organization_id) REFERENCES core.organization_t(organization_id);


--
-- Name: email_campaign_bounced_email_t fk_email_campaign_bounced_email_t_fk_email_campaign_report_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_bounced_email_t
    ADD CONSTRAINT fk_email_campaign_bounced_email_t_fk_email_campaign_report_id FOREIGN KEY (fk_email_campaign_report_id) REFERENCES core.email_campaign_report_t(email_campaign_report_id);


--
-- Name: email_campaign_clicked_url_t fk_email_campaign_clicked_url_t_fk_email_campaign_report_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_clicked_url_t
    ADD CONSTRAINT fk_email_campaign_clicked_url_t_fk_email_campaign_report_id FOREIGN KEY (fk_email_campaign_report_id) REFERENCES core.email_campaign_report_t(email_campaign_report_id);


--
-- Name: email_campaign_opened_by_t fk_email_campaign_opened_by_t_fk_email_campaign_report_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_opened_by_t
    ADD CONSTRAINT fk_email_campaign_opened_by_t_fk_email_campaign_report_id FOREIGN KEY (fk_email_campaign_report_id) REFERENCES core.email_campaign_report_t(email_campaign_report_id);


--
-- Name: email_campaign_recipient_t fk_email_campaign_recipient_t_fk_email_campaign_report_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_recipient_t
    ADD CONSTRAINT fk_email_campaign_recipient_t_fk_email_campaign_report_id FOREIGN KEY (fk_email_campaign_report_id) REFERENCES core.email_campaign_report_t(email_campaign_report_id);


--
-- Name: email_campaign_report_t fk_email_campaign_report_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_report_t
    ADD CONSTRAINT fk_email_campaign_report_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: email_campaign_report_t fk_email_campaign_report_t_fk_date_id_last_click_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_report_t
    ADD CONSTRAINT fk_email_campaign_report_t_fk_date_id_last_click_date FOREIGN KEY (fk_date_id_last_click_date) REFERENCES core.c_date_g(date_id);


--
-- Name: email_campaign_report_t fk_email_campaign_report_t_fk_date_id_last_open_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_report_t
    ADD CONSTRAINT fk_email_campaign_report_t_fk_date_id_last_open_date FOREIGN KEY (fk_date_id_last_open_date) REFERENCES core.c_date_g(date_id);


--
-- Name: email_campaign_report_t fk_email_campaign_report_t_fk_date_id_send_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.email_campaign_report_t
    ADD CONSTRAINT fk_email_campaign_report_t_fk_date_id_send_date FOREIGN KEY (fk_date_id_send_date) REFERENCES core.c_date_g(date_id);


--
-- Name: employee_t fk_employee_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.employee_t
    ADD CONSTRAINT fk_employee_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_comment_t fk_issue_comment_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_comment_t
    ADD CONSTRAINT fk_issue_comment_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_comment_t fk_issue_comment_t_fk_date_id_last_updated_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_comment_t
    ADD CONSTRAINT fk_issue_comment_t_fk_date_id_last_updated_date FOREIGN KEY (fk_date_id_last_updated_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_comment_t fk_issue_comment_t_fk_employee_id_created_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_comment_t
    ADD CONSTRAINT fk_issue_comment_t_fk_employee_id_created_by FOREIGN KEY (fk_employee_id_created_by) REFERENCES core.employee_t(employee_id);


--
-- Name: issue_comment_t fk_issue_comment_t_fk_employee_id_updated_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_comment_t
    ADD CONSTRAINT fk_issue_comment_t_fk_employee_id_updated_by FOREIGN KEY (fk_employee_id_updated_by) REFERENCES core.employee_t(employee_id);


--
-- Name: issue_comment_t fk_issue_comment_t_fk_issue_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_comment_t
    ADD CONSTRAINT fk_issue_comment_t_fk_issue_id FOREIGN KEY (fk_issue_id) REFERENCES core.issue_t(issue_id);


--
-- Name: issue_relation_map_t fk_issue_relation_map_t_fk_issue_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_relation_map_t
    ADD CONSTRAINT fk_issue_relation_map_t_fk_issue_id FOREIGN KEY (fk_issue_id) REFERENCES core.issue_t(issue_id);


--
-- Name: issue_relation_map_t fk_issue_relation_map_t_fk_issue_id_related_issue; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_relation_map_t
    ADD CONSTRAINT fk_issue_relation_map_t_fk_issue_id_related_issue FOREIGN KEY (fk_issue_id_related_issue) REFERENCES core.issue_t(issue_id);


--
-- Name: issue_t fk_issue_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_t fk_issue_t_fk_date_id_deployment_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_date_id_deployment_date FOREIGN KEY (fk_date_id_deployment_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_t fk_issue_t_fk_date_id_first_response_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_date_id_first_response_date FOREIGN KEY (fk_date_id_first_response_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_t fk_issue_t_fk_date_id_inception_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_date_id_inception_date FOREIGN KEY (fk_date_id_inception_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_t fk_issue_t_fk_date_id_pilot_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_date_id_pilot_date FOREIGN KEY (fk_date_id_pilot_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_t fk_issue_t_fk_date_id_pilot_finished_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_date_id_pilot_finished_date FOREIGN KEY (fk_date_id_pilot_finished_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_t fk_issue_t_fk_date_id_resolution_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_date_id_resolution_date FOREIGN KEY (fk_date_id_resolution_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_t fk_issue_t_fk_date_id_sales_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_date_id_sales_date FOREIGN KEY (fk_date_id_sales_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_t fk_issue_t_fk_employee_id_assigned_to; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_employee_id_assigned_to FOREIGN KEY (fk_employee_id_assigned_to) REFERENCES core.employee_t(employee_id);


--
-- Name: issue_t fk_issue_t_fk_party_id_created_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_party_id_created_by FOREIGN KEY (fk_party_id_created_by) REFERENCES core.party_t(party_id);


--
-- Name: issue_t fk_issue_t_fk_party_id_reported_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_party_id_reported_by FOREIGN KEY (fk_party_id_reported_by) REFERENCES core.party_t(party_id);


--
-- Name: issue_t fk_issue_t_fk_project_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_t
    ADD CONSTRAINT fk_issue_t_fk_project_id FOREIGN KEY (fk_project_id) REFERENCES core.project_t(project_id);


--
-- Name: list_segment_list_member_map_t fk_list_segment_list_member_map_t_fk_mailing_list_member_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.list_segment_list_member_map_t
    ADD CONSTRAINT fk_list_segment_list_member_map_t_fk_mailing_list_member_id FOREIGN KEY (fk_mailing_list_member_id) REFERENCES core.mailing_list_member_t(mailing_list_member_id);


--
-- Name: list_segment_list_member_map_t fk_list_segment_list_member_map_t_fk_mailing_list_segment_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.list_segment_list_member_map_t
    ADD CONSTRAINT fk_list_segment_list_member_map_t_fk_mailing_list_segment_id FOREIGN KEY (fk_mailing_list_segment_id) REFERENCES core.mailing_list_segment_t(mailing_list_segment_id);


--
-- Name: mail_message_t fk_mail_message_t_fk_contact_id_bcc; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mail_message_t
    ADD CONSTRAINT fk_mail_message_t_fk_contact_id_bcc FOREIGN KEY (fk_contact_id_bcc) REFERENCES core.contact_t(contact_id);


--
-- Name: mail_message_t fk_mail_message_t_fk_contact_id_cc; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mail_message_t
    ADD CONSTRAINT fk_mail_message_t_fk_contact_id_cc FOREIGN KEY (fk_contact_id_cc) REFERENCES core.contact_t(contact_id);


--
-- Name: mail_message_t fk_mail_message_t_fk_contact_id_from; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mail_message_t
    ADD CONSTRAINT fk_mail_message_t_fk_contact_id_from FOREIGN KEY (fk_contact_id_from) REFERENCES core.contact_t(contact_id);


--
-- Name: mail_message_t fk_mail_message_t_fk_contact_id_to; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mail_message_t
    ADD CONSTRAINT fk_mail_message_t_fk_contact_id_to FOREIGN KEY (fk_contact_id_to) REFERENCES core.contact_t(contact_id);


--
-- Name: mail_message_t fk_mail_message_t_fk_date_id_sent_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mail_message_t
    ADD CONSTRAINT fk_mail_message_t_fk_date_id_sent_date FOREIGN KEY (fk_date_id_sent_date) REFERENCES core.c_date_g(date_id);


--
-- Name: mail_message_t fk_mail_message_t_fk_deal_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mail_message_t
    ADD CONSTRAINT fk_mail_message_t_fk_deal_id FOREIGN KEY (fk_deal_id) REFERENCES core.deal_t(deal_id);


--
-- Name: mail_message_t fk_mail_message_t_fk_employee_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mail_message_t
    ADD CONSTRAINT fk_mail_message_t_fk_employee_id FOREIGN KEY (fk_employee_id) REFERENCES core.employee_t(employee_id);


--
-- Name: mailing_list_t fk_mailing_list_i_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_t
    ADD CONSTRAINT fk_mailing_list_i_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: mailing_list_member_t fk_mailing_list_member_t_fk_date_id_last_changed_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_member_t
    ADD CONSTRAINT fk_mailing_list_member_t_fk_date_id_last_changed_date FOREIGN KEY (fk_date_id_last_changed_date) REFERENCES core.c_date_g(date_id);


--
-- Name: mailing_list_member_t fk_mailing_list_member_t_fk_date_id_opt_in_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_member_t
    ADD CONSTRAINT fk_mailing_list_member_t_fk_date_id_opt_in_date FOREIGN KEY (fk_date_id_opt_in_date) REFERENCES core.c_date_g(date_id);


--
-- Name: mailing_list_member_t fk_mailing_list_member_t_fk_date_id_signup_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_member_t
    ADD CONSTRAINT fk_mailing_list_member_t_fk_date_id_signup_date FOREIGN KEY (fk_date_id_signup_date) REFERENCES core.c_date_g(date_id);


--
-- Name: mailing_list_member_t fk_mailing_list_member_t_fk_mailing_list_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_member_t
    ADD CONSTRAINT fk_mailing_list_member_t_fk_mailing_list_id FOREIGN KEY (fk_mailing_list_id) REFERENCES core.mailing_list_t(mailing_list_id);


--
-- Name: mailing_list_member_t fk_mailing_list_member_t_fk_party_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_member_t
    ADD CONSTRAINT fk_mailing_list_member_t_fk_party_id FOREIGN KEY (fk_party_id) REFERENCES core.party_t(party_id);


--
-- Name: mailing_list_segment_t fk_mailing_list_segment_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_segment_t
    ADD CONSTRAINT fk_mailing_list_segment_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: mailing_list_segment_t fk_mailing_list_segment_t_fk_date_id_last_updated_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_segment_t
    ADD CONSTRAINT fk_mailing_list_segment_t_fk_date_id_last_updated_date FOREIGN KEY (fk_date_id_last_updated_date) REFERENCES core.c_date_g(date_id);


--
-- Name: mailing_list_segment_t fk_mailing_list_segment_t_fk_mailing_list_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_segment_t
    ADD CONSTRAINT fk_mailing_list_segment_t_fk_mailing_list_id FOREIGN KEY (fk_mailing_list_id) REFERENCES core.mailing_list_t(mailing_list_id);


--
-- Name: mailing_list_t fk_mailing_list_t_fk_date_id_last_sent_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_t
    ADD CONSTRAINT fk_mailing_list_t_fk_date_id_last_sent_date FOREIGN KEY (fk_date_id_last_sent_date) REFERENCES core.c_date_g(date_id);


--
-- Name: mailing_list_t fk_mailing_list_t_fk_date_id_last_sub_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_t
    ADD CONSTRAINT fk_mailing_list_t_fk_date_id_last_sub_date FOREIGN KEY (fk_date_id_last_sub_date) REFERENCES core.c_date_g(date_id);


--
-- Name: mailing_list_t fk_mailing_list_t_fk_date_id_last_unsub_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.mailing_list_t
    ADD CONSTRAINT fk_mailing_list_t_fk_date_id_last_unsub_date FOREIGN KEY (fk_date_id_last_unsub_date) REFERENCES core.c_date_g(date_id);

--
-- Name: note_t fk_note_t_fk_contact_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.note_t
    ADD CONSTRAINT fk_note_t_fk_contact_id FOREIGN KEY (fk_contact_id) REFERENCES core.contact_t(contact_id);


--
-- Name: note_t fk_note_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.note_t
    ADD CONSTRAINT fk_note_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: note_t fk_note_t_fk_date_id_last_modified_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.note_t
    ADD CONSTRAINT fk_note_t_fk_date_id_last_modified_date FOREIGN KEY (fk_date_id_last_modified_date) REFERENCES core.c_date_g(date_id);


--
-- Name: note_t fk_note_t_fk_deal_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.note_t
    ADD CONSTRAINT fk_note_t_fk_deal_id FOREIGN KEY (fk_deal_id) REFERENCES core.deal_t(deal_id);


--
-- Name: note_t fk_note_t_fk_employee_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.note_t
    ADD CONSTRAINT fk_note_t_fk_employee_id FOREIGN KEY (fk_employee_id) REFERENCES core.employee_t(employee_id);


--
-- Name: note_t fk_note_t_fk_organization_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.note_t
    ADD CONSTRAINT fk_note_t_fk_organization_id FOREIGN KEY (fk_organization_id) REFERENCES core.organization_t(organization_id);


--
-- Name: organization_relation_t fk_organization_relation_t_fk_organization_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_relation_t
    ADD CONSTRAINT fk_organization_relation_t_fk_organization_id FOREIGN KEY (fk_organization_id) REFERENCES core.organization_t(organization_id);


--
-- Name: organization_relation_t fk_organization_relation_t_fk_organization_id_related_org; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_relation_t
    ADD CONSTRAINT fk_organization_relation_t_fk_organization_id_related_org FOREIGN KEY (fk_organization_id_related_organization) REFERENCES core.organization_t(organization_id);


--
-- Name: organization_t fk_organization_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_t
    ADD CONSTRAINT fk_organization_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: organization_t fk_organization_t_fk_date_id_last_updated_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_t
    ADD CONSTRAINT fk_organization_t_fk_date_id_last_updated_date FOREIGN KEY (fk_date_id_last_updated_date) REFERENCES core.c_date_g(date_id);


--
-- Name: organization_t fk_organization_t_fk_employee_id_owner; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_t
    ADD CONSTRAINT fk_organization_t_fk_employee_id_owner FOREIGN KEY (fk_employee_id_owner) REFERENCES core.employee_t(employee_id);


--
-- Name: organization_t fk_organization_t_fk_party_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_t
    ADD CONSTRAINT fk_organization_t_fk_party_id FOREIGN KEY (fk_party_id) REFERENCES core.party_t(party_id);


--
-- Name: party_t fk_party_t_fk_date_id_created_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.party_t
    ADD CONSTRAINT fk_party_t_fk_date_id_created_date FOREIGN KEY (fk_date_id_created_date) REFERENCES core.c_date_g(date_id);


--
-- Name: party_t fk_party_t_fk_date_id_last_modified_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.party_t
    ADD CONSTRAINT fk_party_t_fk_date_id_last_modified_date FOREIGN KEY (fk_date_id_last_modified_date) REFERENCES core.c_date_g(date_id);


--
-- Name: party_t fk_party_t_fk_employee_id_created_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.party_t
    ADD CONSTRAINT fk_party_t_fk_employee_id_created_by FOREIGN KEY (fk_employee_id_created_by) REFERENCES core.employee_t(employee_id);


--
-- Name: party_t fk_party_t_fk_employee_id_last_modified_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.party_t
    ADD CONSTRAINT fk_party_t_fk_employee_id_last_modified_by FOREIGN KEY (fk_employee_id_last_modified_by) REFERENCES core.employee_t(employee_id);


--
-- Name: release_t fk_release_t_fk_date_id_release_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.release_t
    ADD CONSTRAINT fk_release_t_fk_date_id_release_date FOREIGN KEY (fk_date_id_release_date) REFERENCES core.c_date_g(date_id);


--
-- Name: release_t fk_release_t_fk_date_id_start_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.release_t
    ADD CONSTRAINT fk_release_t_fk_date_id_start_date FOREIGN KEY (fk_date_id_start_date) REFERENCES core.c_date_g(date_id);


--
-- Name: release_t fk_release_t_fk_project_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.release_t
    ADD CONSTRAINT fk_release_t_fk_project_id FOREIGN KEY (fk_project_id) REFERENCES core.project_t(project_id);


--
-- Name: sale_t fk_sale_t_c_revenue_type_t; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT fk_sale_t_c_revenue_type_t FOREIGN KEY (fk_revenue_type_id) REFERENCES core.c_revenue_type_t(revenue_type_id);


--
-- Name: sale_t fk_sale_t_fk_currency_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT fk_sale_t_fk_currency_id FOREIGN KEY (fk_currency_id_local_currency) REFERENCES core.c_currency_g(currency_id);


--
-- Name: sale_t fk_sale_t_fk_date_id_booking_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT fk_sale_t_fk_date_id_booking_date FOREIGN KEY (fk_date_id_booking_date) REFERENCES core.c_date_g(date_id);


--
-- Name: sale_t fk_sale_t_fk_date_id_revenue_end; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT fk_sale_t_fk_date_id_revenue_end FOREIGN KEY (fk_date_id_revenue_end) REFERENCES core.c_date_g(date_id);


--
-- Name: sale_t fk_sale_t_fk_date_id_revenue_start; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT fk_sale_t_fk_date_id_revenue_start FOREIGN KEY (fk_date_id_revenue_start) REFERENCES core.c_date_g(date_id);


--
-- Name: sale_t fk_sale_t_fk_organization_id_customer; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT fk_sale_t_fk_organization_id_customer FOREIGN KEY (fk_organization_id_customer) REFERENCES core.organization_t(organization_id);


--
-- Name: sale_t fk_sale_t_fk_organization_id_reseller; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT fk_sale_t_fk_organization_id_reseller FOREIGN KEY (fk_organization_id_reseller) REFERENCES core.organization_t(organization_id);


--
-- Name: sale_t fk_sale_t_fk_organization_id_seller; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT fk_sale_t_fk_organization_id_seller FOREIGN KEY (fk_organization_id_seller) REFERENCES core.organization_t(organization_id);


--
-- Name: sale_t fk_sale_t_fk_party_id_sales_representative; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.sale_t
    ADD CONSTRAINT fk_sale_t_fk_party_id_sales_representative FOREIGN KEY (fk_party_id_sales_representative) REFERENCES core.party_t(party_id);


--
-- Name: worklog_t fk_worklog_t_fk_date_id_work_started_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.worklog_t
    ADD CONSTRAINT fk_worklog_t_fk_date_id_work_started_date FOREIGN KEY (fk_date_id_work_started_date) REFERENCES core.c_date_g(date_id);


--
-- Name: worklog_t fk_worklog_t_fk_employee_id_created_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.worklog_t
    ADD CONSTRAINT fk_worklog_t_fk_employee_id_created_by FOREIGN KEY (fk_employee_id_created_by) REFERENCES core.employee_t(employee_id);


--
-- Name: worklog_t fk_worklog_t_fk_issue_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.worklog_t
    ADD CONSTRAINT fk_worklog_t_fk_issue_id FOREIGN KEY (fk_issue_id) REFERENCES core.issue_t(issue_id);
