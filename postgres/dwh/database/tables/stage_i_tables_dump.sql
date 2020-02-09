--
-- Name: cnb_exchange_rate_counter_currency_czk_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.cnb_exchange_rate_counter_currency_czk_i (
    datum text NOT NULL,
    usd_1 text NOT NULL,
    eur_1 text NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);

--
-- Name: jira_issue_comment_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.jira_issue_comment_i (
    id integer NOT NULL,
    author_key text NOT NULL,
    body text NOT NULL,
    update_author_key text NOT NULL,
    created text NOT NULL,
    updated text,
    jsdpublic boolean,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    issue_key text NOT NULL,
    author_account_id text,
    update_author_account_id text
);



--
-- Name: jira_issue_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.jira_issue_i (
    issue_id integer NOT NULL,
    issue_key text NOT NULL,
    status text,
    summary text,
    priority text,
    sla_priority text,
    description text,
    issue_type text,
    resolution text,
    deployment text,
    epic text,
    original_estimate_seconds text,
    remaining_estimate_seconds text,
    aggregate_original_estimate_seconds text,
    aggregate_remaining_estimate_seconds text,
    labels text,
    components text,
    fix_versions text,
    affected_versions text,
    project_key text NOT NULL,
    creator_key text NOT NULL,
    reporter_key text,
    assignee_key text,
    account_name text,
    pilot_date text,
    sales_date text,
    first_response_timestamp text,
    created_timestamp text NOT NULL,
    resolution_timestamp text,
    inception_date text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    deployment_date text,
    account_id integer,
    pilot_finished_date text,
    assignee_account_id text,
    creator_account_id text,
    reporter_account_id text
);



--
-- Name: jira_issue_relation_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.jira_issue_relation_i (
    issue_key text NOT NULL,
    issue_key_related_issue text NOT NULL,
    relation text NOT NULL,
    relation_direction text NOT NULL,
    issue_id integer NOT NULL,
    full_issue_json_response text,
    issue_id_related_issue integer NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: jira_project_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.jira_project_i (
    project_id integer NOT NULL,
    project_key text NOT NULL,
    name text NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);  



--
-- Name: jira_release_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.jira_release_i (
    release_id integer NOT NULL,
    name text NOT NULL,
    description text,
    start_date text,
    release_date text,
    project_id integer NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: jira_tempo_account_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.jira_tempo_account_i (
    id integer,
    key text,
    name text,
    status text,
    customer_id integer,
    customer_key text,
    customer_name text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    lead_account_id text,
    lead_display_name text,
    global text
);



--
-- Name: jira_tempo_customer_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.jira_tempo_customer_i (
    id integer,
    key text,
    name text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: jira_user_employee_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.jira_user_employee_i (
    user_key text NOT NULL,
    name text NOT NULL,
    email text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    account_id text,
    account_type text,
    display_name text,
    active boolean
);



--
-- Name: jira_user_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.jira_user_i (
    user_key text NOT NULL,
    name text NOT NULL,
    email text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    account_id text,
    account_type text,
    display_name text,
    active boolean
);



--
-- Name: jira_worklog_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.jira_worklog_i (
    issue_id integer,
    tempo_worklog_id integer NOT NULL,
    jira_worklog_id integer,
    issue_key text,
    worklog_comment text,
    time_logged_seconds integer NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    author_account_id text,
    work_started_at_date text,
    work_started_at_time text,
    created_at_timestamp text,
    updated_at_timestamp text
);



--
-- Name: mailchimp_campaign_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_campaign_i (
    id text NOT NULL,
    web_id integer NOT NULL,
    type text NOT NULL,
    create_time text NOT NULL,
    archive_url text,
    long_archive_url text,
    status text,
    emails_sent integer,
    content_type text,
    needs_block_refresh boolean,
    recipients_list_id text,
    recipients_list_is_active text,
    recipients_list_name text,
    recipients_segment_text text,
    recipients_recipient_count integer,
    settings_subject_line text,
    settings_title text,
    settings_from_name text,
    settings_reply_to text,
    settings_use_conversation boolean,
    settings_to_name text,
    settings_folder_id text,
    settings_authenticate boolean,
    settings_auto_footer boolean,
    settings_inline_css boolean,
    settings_auto_tweet boolean,
    settings_fb_comments boolean,
    settings_timewarp boolean,
    settings_template_id integer,
    settings_drag_and_drop boolean,
    tracking_opens boolean,
    tracking_html_clicks boolean,
    tracking_text_clicks boolean,
    tracking_goal_tracking boolean,
    tracking_ecomm360 boolean,
    tracking_google_analytics text,
    tracking_clicktale text,
    report_summary_opens integer,
    report_summary_unique_opens integer,
    report_summary_open_rate real,
    report_summary_clicks integer,
    report_summary_subscriber_clicks integer,
    report_summary_click_rate real,
    report_summary_ecommerce_total_orders integer,
    report_summary_ecommerce_total_spent integer,
    report_summary_ecommerce_total_revenue integer,
    delivery_status_enabled boolean,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: mailchimp_list_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_list_i (
    id text NOT NULL,
    web_id integer NOT NULL,
    name text NOT NULL,
    contact_company text,
    contact_address1 text,
    contact_address2 text,
    contact_city text,
    contact_state text,
    contact_zip text,
    contact_country text,
    contact_phone text,
    permission_reminder text,
    use_archive_bar text,
    campaign_defaults_from_name text,
    campaign_defaults_from_email text,
    campaign_defaults_subject text,
    campaign_defaults_language text,
    notify_on_subscribe text,
    notify_on_unsubscribe text,
    date_created text,
    list_rating integer,
    email_type_option boolean,
    subscribe_url_short text,
    subscribe_url_long text,
    beamer_address text,
    visibility text,
    double_optin boolean,
    marketing_permissions boolean,
    modules text,
    stats_member_count integer,
    stats_unsubscribe_count integer,
    stats_cleaned_count integer,
    stats_member_count_since_send integer,
    stats_unsubscribe_count_since_send integer,
    stats_cleaned_count_since_send integer,
    stats_campaign_count integer,
    stats_campaign_last_sent text,
    stats_merge_field_count integer,
    stats_avg_sub_rate real,
    stats_avg_unsub_rate real,
    stats_target_sub_rate real,
    stats_open_rate real,
    stats_click_rate real,
    stats_last_sub_date text,
    stats_last_unsub_date text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: mailchimp_list_member_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_list_member_i (
    id text NOT NULL,
    email_address text NOT NULL,
    unique_email_id text NOT NULL,
    email_type text NOT NULL,
    status text NOT NULL,
    merge_fields_fname text,
    merge_fields_lname text,
    merge_fields text,
    stats_avg_open_rate real,
    stats_avg_click_rate real,
    ip_signup text,
    timestamp_signup text,
    ip_opt text,
    timestamp_opt text,
    member_rating integer,
    last_changed text,
    language text,
    vip boolean,
    email_client text,
    location_latitude integer,
    location_longitude integer,
    location_gmtoff integer,
    location_dstoff integer,
    location_country_code text,
    location_timezone text,
    list_id text NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: mailchimp_list_segment_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_list_segment_i (
    id integer NOT NULL,
    name text NOT NULL,
    member_count integer NOT NULL,
    type text NOT NULL,
    created_at text NOT NULL,
    updated_at text NOT NULL,
    options text NOT NULL,
    list_id text NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: mailchimp_list_segment_member_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_list_segment_member_i (
    id text NOT NULL,
    email_address text NOT NULL,
    unique_email_id text NOT NULL,
    list_id text NOT NULL,
    list_segment_id integer NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: mailchimp_report_click_report_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_report_click_report_i (
    id text NOT NULL,
    url text NOT NULL,
    total_clicks integer NOT NULL,
    click_percentage real,
    unique_clicks integer,
    unique_click_percentage real,
    last_click text,
    campaign_id text NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: mailchimp_report_click_report_member_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_report_click_report_member_i (
    email_id text NOT NULL,
    email_address text NOT NULL,
    clicks integer NOT NULL,
    campaign_id text NOT NULL,
    url_id text NOT NULL,
    list_id text NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    merge_fields_fname text,
    merge_fields_lname text
);



--
-- Name: mailchimp_report_email_activity_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_report_email_activity_i (
    campaign_id text NOT NULL,
    list_id text NOT NULL,
    email_id text NOT NULL,
    email_address text NOT NULL,
    activity_action text NOT NULL,
    activity_type text,
    activity_timestamp text,
    activity_url text,
    activity_ip text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: mailchimp_report_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_report_i (
    id text NOT NULL,
    campaign_title text NOT NULL,
    type text NOT NULL,
    list_id text NOT NULL,
    list_is_active boolean,
    list_name text NOT NULL,
    subject_line text NOT NULL,
    preview_text text,
    emails_sent integer,
    abuse_reports integer,
    unsubscribed integer,
    send_time text,
    bounces_hard_bounces integer,
    bounces_soft_bounces integer,
    bounces_syntax_errors integer,
    forwards_forwards_count integer,
    forwards_forwards_opens integer,
    opens_opens_total integer,
    opens_unique_opens integer,
    opens_open_rate real,
    opens_last_open text,
    clicks_clicks_total integer,
    clicks_unique_clicks integer,
    clicks_unique_subscriber_clicks integer,
    clicks_click_rate real,
    clicks_last_click text,
    facebook_likes_recipient_likes integer,
    facebook_likes_unique_likes integer,
    facebook_likes_facebook_likes integer,
    industry_stats_type text,
    industry_stats_open_rate real,
    industry_stats_click_rate real,
    industry_stats_bounce_rate real,
    industry_stats_unopen_rate real,
    industry_stats_unsub_rate real,
    industry_stats_abuse_rate real,
    list_stats_sub_rate real,
    list_stats_unsub_rate real,
    list_stats_open_rate real,
    list_stats_click_rate real,
    ecommerce_total_orders integer,
    ecommerce_total_spent integer,
    ecommerce_total_revenue integer,
    delivery_status_enabled boolean,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: mailchimp_report_open_report_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_report_open_report_i (
    campaign_id text NOT NULL,
    list_id text NOT NULL,
    email_id text NOT NULL,
    email_address text NOT NULL,
    vip text,
    opens_count integer,
    opens_timestamp text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    merge_fields_fname text,
    merge_fields_lname text
);



--
-- Name: mailchimp_report_sent_to_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_report_sent_to_i (
    campaign_id text NOT NULL,
    email_id text NOT NULL,
    email_address text NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    list_id text NOT NULL,
    merge_fields_fname text,
    merge_fields_lname text
);



--
-- Name: mailchimp_template_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.mailchimp_template_i (
    id integer NOT NULL,
    type text,
    name text,
    drag_and_drop boolean,
    responsive boolean,
    category text,
    date_created text NOT NULL,
    date_edited text,
    created_by text,
    edited_by text,
    active boolean,
    thumbnail text,
    share_url text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: ocean_currency_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.ocean_currency_i (
    currency text NOT NULL,
    error boolean DEFAULT false NOT NULL,
    error_description text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: ocean_organziation_to_crm_map_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.ocean_organziation_to_crm_map_i (
    organization_name text NOT NULL,
    crm_id integer,
    error boolean DEFAULT false NOT NULL,
    error_description text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: ocean_partner_list_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.ocean_partner_list_i (
    partner_name text NOT NULL,
    is_tracked boolean NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: ocean_payment_received_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.ocean_payment_received_i (
    payment_received text NOT NULL,
    error boolean DEFAULT false NOT NULL,
    error_description text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);


--
-- Name: ocean_removed_jira_user_i; Type: TABLE; Schema: stage; Owner: -
--

CREATE TABLE stage.ocean_removed_jira_user_i (
    removed_user_accountid text,
    name text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);


--
-- Name: ocean_revenue_type_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.ocean_revenue_type_i (
    revenue_type text NOT NULL,
    error boolean DEFAULT false NOT NULL,
    error_description text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: ocean_sales_report_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.ocean_sales_report_i (
    sale_key text NOT NULL,
    customer text,
    reseller text,
    seller text,
    revenue_type text,
    invoice text,
    booking_date text,
    amount numeric(10,2),
    currency text,
    revenue_start text,
    revenue_end text,
    trade_comment text,
    error boolean DEFAULT false NOT NULL,
    error_description text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    sales_rep text,
    paid text
);



--
-- Name: ocean_sales_representative_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.ocean_sales_representative_i (
    sales_rep_code text NOT NULL,
    crm_id integer NOT NULL,
    error boolean DEFAULT false NOT NULL,
    error_description text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: ocean_seller_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.ocean_seller_i (
    seller_code text NOT NULL,
    error boolean DEFAULT false NOT NULL,
    error_description text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    crm_id integer
);



--
-- Name: pipedrive_activity_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_activity_i (
    id integer NOT NULL,
    user_id integer,
    done boolean,
    type text,
    reference_type text,
    reference_id integer,
    due_date text,
    due_time text,
    duration text,
    add_time text,
    marked_as_done_time text,
    last_notification_time text,
    last_notification_user_id integer,
    subject text,
    org_id integer,
    person_id integer,
    deal_id integer,
    active_flag boolean,
    update_time text,
    update_user_id integer,
    gcal_event_id integer,
    google_calendar_id integer,
    google_calendar_etag text,
    note text,
    created_by_user_id integer,
    org_name text,
    person_name text,
    deal_title text,
    owner_name text,
    assigned_to_user_id integer,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: pipedrive_currency_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_currency_i (
    id integer,
    code text,
    name text,
    decimal_points integer,
    symbol text,
    active_flag boolean,
    is_custom_flag boolean,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_deal_category_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_category_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_deal_deal_change_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_deal_change_i (
    id integer,
    item_id integer,
    user_id integer,
    field_key text,
    old_value text,
    new_value text,
    is_bulk_update_flag boolean,
    log_time text,
    change_source text,
    "timestamp" text,
    additional_data_old_value_formatted text,
    additional_data_new_value_formatted text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_deal_deal_source_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_deal_source_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_deal_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_i (
    id integer,
    creator_user_id integer,
    user_id integer,
    person_id integer,
    org_id integer,
    stage_id integer,
    title text,
    value integer,
    currency text,
    add_time text,
    update_time text,
    stage_change_time text,
    active boolean,
    deleted boolean,
    status text,
    probability integer,
    visible_to integer,
    close_time text,
    pipeline_id integer,
    won_time text,
    first_won_time text,
    lost_time text,
    expected_close_date text,
    industry integer,
    deal_source integer,
    deal_source_detail text,
    region integer,
    reason_lost integer,
    resulting_state integer,
    jira_issue_key text,
    category integer,
    country text,
    country_subpremise text,
    country_street_number text,
    country_route text,
    country_sublocality text,
    country_locality text,
    country_admin_area_level_1 text,
    country_admin_area_level_2 text,
    country_country text,
    country_postal_code text,
    country_formatted_address text,
    vtiger_id text,
    partner_identified_by text,
    partner_qualified_by text,
    partner_poc_done_by text,
    partner_closed_by text,
    partner_resold_by text,
    partner_owned_by text,
    partner_supported_by text,
    stage_order_nr integer,
    rotten_time text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    lost_reason text
);




--
-- Name: COLUMN pipedrive_deal_i.industry; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.industry IS 'pipedrive field id - 0b8f4c916653fca572a26ee0d8a65b73a9a3d6c2';


--
-- Name: COLUMN pipedrive_deal_i.deal_source; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.deal_source IS '64896c7962fd27b8b0c719c3bbc3c9d77a2060cb';


--
-- Name: COLUMN pipedrive_deal_i.deal_source_detail; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.deal_source_detail IS '5f987ab7b72ef1083f09ed8f3011951419a6f450';


--
-- Name: COLUMN pipedrive_deal_i.region; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.region IS 'e3a01ee1cb7171c2984c563024d6de5db252d945';


--
-- Name: COLUMN pipedrive_deal_i.reason_lost; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.reason_lost IS 'cab2c98910b32f44caa20f84bec2db658ad2669e';


--
-- Name: COLUMN pipedrive_deal_i.resulting_state; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.resulting_state IS 'f6ab0c86f427fcb5d4119fc98b39805b76aea254';


--
-- Name: COLUMN pipedrive_deal_i.jira_issue_key; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.jira_issue_key IS '904ff11676a2106c5537ea5925fc5b580049693a';


--
-- Name: COLUMN pipedrive_deal_i.country; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: COLUMN pipedrive_deal_i.country_subpremise; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country_subpremise IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: COLUMN pipedrive_deal_i.country_street_number; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country_street_number IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: COLUMN pipedrive_deal_i.country_route; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country_route IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: COLUMN pipedrive_deal_i.country_sublocality; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country_sublocality IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: COLUMN pipedrive_deal_i.country_locality; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country_locality IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: COLUMN pipedrive_deal_i.country_admin_area_level_1; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country_admin_area_level_1 IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: COLUMN pipedrive_deal_i.country_admin_area_level_2; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country_admin_area_level_2 IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: COLUMN pipedrive_deal_i.country_country; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country_country IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: COLUMN pipedrive_deal_i.country_postal_code; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country_postal_code IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: COLUMN pipedrive_deal_i.country_formatted_address; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.pipedrive_deal_i.country_formatted_address IS 'pipedrive field id - 23a057766a74fd80cee4fbee8fd88312b4f12173';


--
-- Name: pipedrive_deal_industry_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_industry_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_deal_mail_message_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_mail_message_i (
    "timestamp" text,
    id integer,
    from_id integer,
    from_email_address text,
    from_name text,
    from_linked_person_id integer,
    from_linked_person_name text,
    from_mail_message_party_id integer,
    to_id integer,
    to_email_address text,
    to_name text,
    to_linked_person_id integer,
    to_linked_person_name text,
    to_mail_message_party_id integer,
    cc_id integer,
    cc_email_address text,
    cc_name text,
    cc_linked_person_id integer,
    cc_linked_person_name text,
    cc_mail_message_party_id integer,
    bcc_id integer,
    bcc_email_address text,
    bcc_name text,
    bcc_linked_person_id integer,
    bcc_linked_person_name text,
    bcc_mail_message_party_id integer,
    body_url text,
    nylas_id text,
    account_id text,
    user_id integer,
    mail_thread_id integer,
    subject text,
    snippet text,
    mail_tracking_status text,
    mail_link_tracking_enabled_flag integer,
    read_flag integer,
    draft_flag integer,
    synced_flag integer,
    deleted_flag integer,
    has_body_flag integer,
    sent_flag integer,
    sent_from_pipedrive_flag integer,
    smart_bcc_flag integer,
    message_time text,
    add_time text,
    update_time text,
    has_attachments_flag integer,
    has_inline_attachments_flag integer,
    has_real_attachments_flag integer,
    mua_message_id text,
    write_flag boolean,
    item_type text,
    company_id integer,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    deal_id integer
);




--
-- Name: pipedrive_deal_participants_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_participants_i (
    deal_id integer NOT NULL,
    participant_person_id integer NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_deal_reason_lost_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_reason_lost_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_deal_region_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_region_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_deal_resulting_state_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_resulting_state_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_deal_visible_to_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_deal_visible_to_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_note_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_note_i (
    id integer,
    user_id integer,
    deal_id integer,
    person_id integer,
    org_id integer,
    content text,
    add_time text,
    update_time text,
    active_flag boolean,
    pinned_to_deal_flag boolean,
    pinned_to_person_flag boolean,
    pinned_to_organization_flag boolean,
    last_update_user_id integer,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_organization_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_organization_i (
    id integer,
    company_id integer,
    owner_id integer,
    name text,
    active_flag boolean,
    update_time text,
    add_time text,
    visible_to integer,
    next_activity_date text,
    next_activity_time text,
    next_activity_id integer,
    last_activity_id integer,
    last_activity_date text,
    address text,
    address_subpremise text,
    address_street_number text,
    address_route text,
    address_sublocality text,
    address_locality text,
    address_admin_area_level_1 text,
    address_admin_area_level_2 text,
    address_country text,
    address_postal_code text,
    address_formatted_address text,
    label integer,
    owner_name text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_organization_label_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_organization_label_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_organization_relation_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_organization_relation_i (
    id integer,
    type text,
    rel_linked_org_id_value integer,
    add_time text,
    update_time text,
    active_flag boolean,
    calculated_type text,
    calculated_related_org_id integer,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: pipedrive_organization_visible_to_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_organization_visible_to_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_person_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_person_i (
    id integer,
    company_id integer,
    owner_id integer,
    org_id integer,
    name text,
    first_name text,
    last_name text,
    active_flag boolean,
    phone_1_label text,
    phone_1_value text,
    phone_2_label text,
    phone_2_value text,
    email_1_label text,
    email_1_value text,
    email_2_label text,
    email_2_value text,
    update_time text,
    add_time text,
    visible_to integer,
    label integer,
    location text,
    location_subpremise text,
    location_street_number text,
    location_route text,
    location_sublocality text,
    location_locality text,
    location_admin_area_level_1 text,
    location_admin_area_level_2 text,
    location_country text,
    location_postal_code text,
    location_formatted_address text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_person_label_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_person_label_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_person_visible_to_options_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_person_visible_to_options_i (
    id integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_pipeline_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_pipeline_i (
    id integer,
    name text,
    url_title text,
    order_nr integer,
    active boolean,
    deal_probability boolean,
    add_time text,
    update_time text,
    selected boolean,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_stage_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_stage_i (
    id integer,
    order_nr integer,
    name text,
    active_flag boolean,
    deal_probability integer,
    pipeline_id integer,
    add_time text,
    update_time text,
    pipeline_name text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: pipedrive_user_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.pipedrive_user_i (
    id integer,
    name text,
    default_currency text,
    locale text,
    lang integer,
    email text,
    activated boolean,
    last_login text,
    created text,
    modified text,
    signup_flow_variation text,
    has_created_company boolean,
    is_admin integer,
    timezone_name text,
    timezone_offset text,
    role_id integer,
    icon_url text,
    active_flag boolean,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);




--
-- Name: restcountries_country_list_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.restcountries_country_list_i (
    name text NOT NULL,
    alpha2code text NOT NULL,
    alpha3code text NOT NULL,
    capital text NOT NULL,
    region text NOT NULL,
    subregion text NOT NULL,
    numericcode text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_account_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_account_i (
    accountid integer NOT NULL,
    account_no character varying(100),
    accountname character varying(100),
    parentid integer,
    account_type character varying(200),
    industry character varying(200),
    annualrevenue numeric(33,8),
    rating character varying(200),
    ownership character varying(50),
    siccode character varying(50),
    tickersymbol character varying(30),
    phone character varying(30),
    otherphone character varying(30),
    email1 character varying(100),
    email2 character varying(100),
    website character varying(100),
    fax character varying(30),
    employees integer,
    emailoptout character varying(3),
    notify_owner character varying(3),
    isconvertedfromlead character varying(3),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: COLUMN vtiger_account_i.otherphone; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_account_i.otherphone IS 'not used in CRM';


--
-- Name: vtiger_accountbillads_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_accountbillads_i (
    accountaddressid integer NOT NULL,
    bill_city character varying(30),
    bill_code character varying(30),
    bill_country character varying(30),
    bill_state character varying(30),
    bill_street character varying(250),
    bill_pobox character varying(30),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_accountscf_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_accountscf_i (
    accountid integer NOT NULL,
    cf_751 character varying(255),
    cf_753 character varying(10),
    cf_755 character varying(200),
    cf_803 integer,
    cf_813 character varying(3),
    cf_815 character varying(3),
    cf_817 character varying(21845),
    cf_835 character varying(255),
    cf_839 character varying(255),
    cf_841 character varying(255),
    cf_868 integer,
    cf_886 character varying(255),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: COLUMN vtiger_accountscf_i.cf_751; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_accountscf_i.cf_751 IS 'Region';


--
-- Name: COLUMN vtiger_accountscf_i.cf_755; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_accountscf_i.cf_755 IS 'Partner - string of company name i.e. Agile Solutions';


--
-- Name: COLUMN vtiger_accountscf_i.cf_813; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_accountscf_i.cf_813 IS 'NDA  0 or 1 ';


--
-- Name: COLUMN vtiger_accountscf_i.cf_839; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_accountscf_i.cf_839 IS 'external_inteligence - usually www.discovery.com link';


--
-- Name: vtiger_accountshipads_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_accountshipads_i (
    accountaddressid integer NOT NULL,
    ship_city character varying(30) DEFAULT NULL::character varying,
    ship_code character varying(30) DEFAULT NULL::character varying,
    ship_country character varying(30) DEFAULT NULL::character varying,
    ship_state character varying(30) DEFAULT NULL::character varying,
    ship_pobox character varying(30) DEFAULT NULL::character varying,
    ship_street character varying(250) DEFAULT NULL::character varying,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_activity_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_activity_i (
    activityid integer NOT NULL,
    subject character varying(100),
    semodule character varying(20),
    activitytype character varying(200),
    date_start character varying(10),
    due_date character varying(10),
    time_start character varying(50),
    time_end character varying(50),
    sendnotification character varying(3),
    duration_hours character varying(200),
    duration_minutes character varying(200),
    status character varying(200),
    eventstatus character varying(200),
    priority character varying(200),
    location character varying(150),
    notime character varying(3),
    visibility character varying(50),
    recurringtype character varying(200),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_campaign_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_campaign_i (
    campaign_no character varying(100) NOT NULL,
    campaignname character varying(255),
    campaigntype character varying(200),
    campaignstatus character varying(200),
    expectedrevenue numeric(33,8),
    budgetcost numeric(33,8),
    actualcost numeric(33,8),
    expectedresponse character varying(200),
    numsent bigint,
    product_id integer,
    sponsor character varying(255),
    targetaudience character varying(255),
    targetsize integer,
    expectedresponsecount integer,
    expectedsalescount integer,
    expectedroi numeric(33,8),
    actualresponsecount integer,
    actualsalescount integer,
    actualroi numeric(33,8),
    campaignid integer,
    closingdate character varying(10),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_campaignaccountrel_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_campaignaccountrel_i (
    campaignid integer NOT NULL,
    accountid integer NOT NULL,
    campaignrelstatusid integer,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_campaigncontrel_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_campaigncontrel_i (
    campaignid integer DEFAULT 0 NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
    campaignrelstatusid integer DEFAULT 0 NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_campaignleadrel_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_campaignleadrel_i (
    campaignid integer DEFAULT 0 NOT NULL,
    leadid integer DEFAULT 0 NOT NULL,
    campaignrelstatusid integer DEFAULT 0 NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_campaignrelstatus_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_campaignrelstatus_i (
    campaignrelstatusid integer,
    campaignrelstatus character varying(256) DEFAULT NULL::character varying,
    sortorderid integer,
    presence integer,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_campaignscf_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_campaignscf_i (
    campaignid integer NOT NULL,
    cf_779 character varying(10),
    cf_781 character varying(3),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_cf_874_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_cf_874_i (
    cf_874id integer NOT NULL,
    cf_874 text NOT NULL,
    sortorderid integer,
    presence integer DEFAULT 1 NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_cntactivityrel_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_cntactivityrel_i (
    contactid integer NOT NULL,
    activityid integer NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_contactaddress_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_contactaddress_i (
    contactaddressid integer NOT NULL,
    mailingcity character varying(40) DEFAULT NULL::character varying,
    mailingstreet character varying(250) DEFAULT NULL::character varying,
    mailingcountry character varying(40) DEFAULT NULL::character varying,
    othercountry character varying(30) DEFAULT NULL::character varying,
    mailingstate character varying(30) DEFAULT NULL::character varying,
    mailingpobox character varying(30) DEFAULT NULL::character varying,
    othercity character varying(40) DEFAULT NULL::character varying,
    otherstate character varying(50) DEFAULT NULL::character varying,
    mailingzip character varying(30) DEFAULT NULL::character varying,
    otherzip character varying(30) DEFAULT NULL::character varying,
    otherstreet character varying(250) DEFAULT NULL::character varying,
    otherpobox character varying(30) DEFAULT NULL::character varying,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_contactdetails_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_contactdetails_i (
    contactid integer NOT NULL,
    contact_no character varying(100),
    accountid integer,
    salutation character varying(200),
    firstname character varying(40),
    lastname character varying(80),
    email character varying(100),
    phone character varying(50),
    mobile character varying(50),
    title character varying(50),
    department character varying(30),
    fax character varying(50),
    reportsto character varying(30),
    training character varying(50),
    usertype character varying(50),
    contacttype character varying(50),
    otheremail character varying(100),
    secondaryemail character varying(100),
    donotcall character varying(3),
    emailoptout character varying(3),
    imagename character varying(150),
    reference character varying(3),
    notify_owner character varying(3),
    isconvertedfromlead character varying(3),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: COLUMN vtiger_contactdetails_i.contacttype; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_contactdetails_i.contacttype IS 'null - not used in CRM';


--
-- Name: vtiger_contactscf_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_contactscf_i (
    contactid integer NOT NULL,
    cf_773 character varying(255),
    cf_787 character varying(200),
    cf_811 character varying(255),
    cf_843 character varying(255),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: COLUMN vtiger_contactscf_i.cf_773; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_contactscf_i.cf_773 IS 'profesional_profile';


--
-- Name: COLUMN vtiger_contactscf_i.cf_787; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_contactscf_i.cf_787 IS 'lead_source_details';


--
-- Name: COLUMN vtiger_contactscf_i.cf_843; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_contactscf_i.cf_843 IS 'external_inteligence - usually discovery link';


--
-- Name: vtiger_contactsubdetails_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_contactsubdetails_i (
    contactsubscriptionid integer DEFAULT 0 NOT NULL,
    homephone character varying(50) DEFAULT NULL::character varying,
    otherphone character varying(50) DEFAULT NULL::character varying,
    assistant character varying(30) DEFAULT NULL::character varying,
    assistantphone character varying(50) DEFAULT NULL::character varying,
    birthday character varying(30) DEFAULT NULL::character varying,
    laststayintouchrequest bigint DEFAULT 0,
    laststayintouchsavedate integer DEFAULT 0,
    leadsource character varying(200) DEFAULT NULL::character varying,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_contpotentialrel_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_contpotentialrel_i (
    contactid integer NOT NULL,
    potentialid integer NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_crmentity_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_crmentity_i (
    crmid integer NOT NULL,
    smcreatorid integer,
    smownerid integer,
    modifiedby integer,
    setype text,
    description text,
    createdtime text,
    modifiedtime text,
    viewedtime text,
    status text,
    version integer,
    presence integer,
    deleted integer,
    label text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_crmentityrel_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_crmentityrel_i (
    crmid integer NOT NULL,
    relcrmid integer NOT NULL,
    relmodule character varying(100) NOT NULL,
    module character varying(100) NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_emaildetails_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_emaildetails_i (
    emailid integer NOT NULL,
    from_email character varying(50),
    to_email character varying(21845),
    cc_email character varying(21845),
    bcc_email character varying(21845),
    assigned_user_email character varying(50),
    idlists character varying(21845),
    email_flag character varying(50),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_entityname_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_entityname_i (
    tabid integer NOT NULL,
    modulename text NOT NULL,
    tablename text NOT NULL,
    fieldname text NOT NULL,
    entityidfield text NOT NULL,
    entityidcolumn text NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_field_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_field_i (
    tabid integer NOT NULL,
    fieldid integer NOT NULL,
    columnname text NOT NULL,
    tablename text NOT NULL,
    generatedtype integer NOT NULL,
    uitype text NOT NULL,
    fieldname text NOT NULL,
    fieldlabel text NOT NULL,
    readonly integer NOT NULL,
    presence integer NOT NULL,
    defaultvalue text,
    maximumlength integer,
    sequence integer,
    block integer,
    displaytype integer,
    typeofdata text,
    quickcreate integer NOT NULL,
    quickcreatesequence integer,
    info_type text,
    masseditable integer NOT NULL,
    helpinfo text,
    summaryfield integer NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_leadaddress_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_leadaddress_i (
    leadaddressid integer NOT NULL,
    city character varying(30),
    code character varying(30),
    state character varying(30),
    pobox character varying(30),
    country character varying(30),
    phone character varying(50),
    mobile character varying(50),
    fax character varying(50),
    lane character varying(250),
    leadaddresstype character varying(30),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_leaddetails_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_leaddetails_i (
    leadid integer NOT NULL,
    lead_no character varying(100),
    email character varying(100),
    interest character varying(50),
    firstname character varying(40),
    salutation character varying(200),
    lastname character varying(80),
    company character varying(100),
    annualrevenue numeric(33,8),
    industry character varying(200),
    campaign character varying(30),
    rating character varying(200),
    leadstatus character varying(50),
    leadsource character varying(200),
    converted integer,
    designation character varying(50),
    licencekeystatus character varying(50),
    space character varying(250),
    comments character varying(21845),
    priority character varying(50),
    demorequest character varying(50),
    partnercontact character varying(50),
    productversion character varying(20),
    product character varying(50),
    maildate character varying(10),
    nextstepdate character varying(10),
    fundingsituation character varying(50),
    purpose character varying(50),
    evaluationstatus character varying(50),
    transferdate character varying(10),
    revenuetype character varying(50),
    noofemployees integer,
    secondaryemail character varying(100),
    assignleadchk integer,
    emailoptout character varying(3),
    cf_863 integer,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_leadscf_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_leadscf_i (
    leadid integer NOT NULL,
    cf_757 character varying(200) DEFAULT ''::character varying,
    cf_771 character varying(255) DEFAULT ''::character varying,
    cf_775 character varying(10) DEFAULT NULL::character varying,
    cf_777 character varying(200) DEFAULT ''::character varying,
    cf_791 character varying(200) DEFAULT ''::character varying,
    cf_795 character varying(255) DEFAULT ''::character varying,
    cf_797 character varying(10) DEFAULT NULL::character varying,
    cf_799 character varying(255) DEFAULT ''::character varying,
    cf_807 integer,
    cf_845 character varying(255) DEFAULT ''::character varying,
    cf_847 character varying(255) DEFAULT ''::character varying,
    cf_857 character varying(200) DEFAULT ''::character varying,
    cf_864 character varying(255),
    cf_866 integer,
    cf_884 character varying(10) DEFAULT ''::character varying,
    cf_892 character varying(16),
    cf_894 character varying(255),
    cf_896 character varying(255),
    cf_898 character varying(255),
    cf_900 character varying(255),
    cf_902 character varying(255),
    cf_904 character varying(255),
    cf_920 character varying(255),
    cf_922 character varying(255),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: COLUMN vtiger_leadscf_i.cf_757; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_757 IS 'reference';


--
-- Name: COLUMN vtiger_leadscf_i.cf_771; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_771 IS 'profesional_profile';


--
-- Name: COLUMN vtiger_leadscf_i.cf_775; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_775 IS 'last_action_date';


--
-- Name: COLUMN vtiger_leadscf_i.cf_777; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_777 IS 'next_step';


--
-- Name: COLUMN vtiger_leadscf_i.cf_791; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_791 IS 'lead_source_details';


--
-- Name: COLUMN vtiger_leadscf_i.cf_797; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_797 IS 'manual_inception_date';


--
-- Name: COLUMN vtiger_leadscf_i.cf_799; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_799 IS 'organization_type';


--
-- Name: COLUMN vtiger_leadscf_i.cf_845; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_845 IS 'presales_thread';


--
-- Name: COLUMN vtiger_leadscf_i.cf_847; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_847 IS 'sales_thread';


--
-- Name: COLUMN vtiger_leadscf_i.cf_857; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_857 IS 'subject';


--
-- Name: COLUMN vtiger_leadscf_i.cf_864; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_864 IS 'external_inteligence - usually discovery link';


--
-- Name: COLUMN vtiger_leadscf_i.cf_884; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_leadscf_i.cf_884 IS 'next_step_date';


--
-- Name: vtiger_leadsource_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_leadsource_i (
    leadsourceid integer NOT NULL,
    leadsource character varying(200),
    presence integer,
    picklist_valueid integer,
    sortorderid integer,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_leadstatus_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_leadstatus_i (
    leadstatusid integer NOT NULL,
    leadstatus character varying(200),
    presence integer,
    picklist_valueid integer,
    sortorderid integer,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_leadsubdetails_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_leadsubdetails_i (
    leadsubscriptionid integer NOT NULL,
    website character varying(255) DEFAULT NULL::character varying,
    callornot integer DEFAULT 0,
    readornot integer DEFAULT 0,
    empct integer DEFAULT 0,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_modcomments_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_modcomments_i (
    modcommentsid integer NOT NULL,
    commentcontent character varying(21845),
    related_to integer,
    parent_comments character varying(100),
    customer character varying(100),
    userid character varying(100),
    reasontoedit character varying(100),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_modtracker_basic_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_modtracker_basic_i (
    id integer NOT NULL,
    crmid integer,
    module character varying(50) DEFAULT NULL::character varying,
    whodid integer,
    changedon text,
    status integer DEFAULT 0,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_modtracker_detail_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_modtracker_detail_i (
    id integer NOT NULL,
    fieldname character varying(100) DEFAULT NULL::character varying,
    prevalue text,
    postvalue text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_modtracker_relations_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_modtracker_relations_i (
    id integer NOT NULL,
    targetmodule character varying(100) NOT NULL,
    targetid integer NOT NULL,
    changedon text,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_potential_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_potential_i (
    potentialid integer NOT NULL,
    potential_no character varying(100),
    related_to integer,
    potentialname character varying(120),
    amount numeric(33,8),
    currency character varying(20),
    closingdate character varying(10),
    typeofrevenue character varying(50),
    nextstep character varying(100),
    private integer,
    probability numeric(10,3),
    campaignid integer,
    sales_stage character varying(200),
    potentialtype character varying(200),
    leadsource character varying(200),
    productid integer,
    productversion character varying(50),
    quotationref character varying(50),
    partnercontact character varying(50),
    remarks character varying(50),
    runtimefee integer,
    followupdate character varying(10),
    evaluationstatus character varying(50),
    description character varying(21845),
    forecastcategory integer,
    outcomeanalysis integer,
    forecast_amount numeric(33,8),
    isconvertedfromlead character varying(3),
    contact_id integer,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: COLUMN vtiger_potential_i.partnercontact; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potential_i.partnercontact IS 'null not used in CRM';


--
-- Name: COLUMN vtiger_potential_i.description; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potential_i.description IS 'null - crm_entiry.description is used instead
';


--
-- Name: vtiger_potentialscf_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_potentialscf_i (
    potentialid integer NOT NULL,
    cf_759 character varying(200),
    cf_761 character varying(200),
    cf_763 character varying(200),
    cf_765 character varying(10),
    cf_769 character varying(10),
    cf_789 character varying(200),
    cf_809 character varying(255),
    cf_831 character varying(255),
    cf_833 character varying(255),
    cf_870 character varying(255),
    cf_872 character varying(255),
    cf_874 character varying(255),
    cf_876 character varying(255),
    cf_880 character varying(255),
    cf_882 character varying(10),
    cf_888 character varying(10),
    cf_890 character varying(16),
    cf_906 character varying(255),
    cf_908 character varying(255),
    cf_910 character varying(255),
    cf_912 character varying(255),
    cf_914 character varying(255),
    cf_916 character varying(255),
    cf_918 character varying(255),
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: COLUMN vtiger_potentialscf_i.cf_759; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potentialscf_i.cf_759 IS 'referring_partner';


--
-- Name: COLUMN vtiger_potentialscf_i.cf_761; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potentialscf_i.cf_761 IS 'reselling_partner';


--
-- Name: COLUMN vtiger_potentialscf_i.cf_765; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potentialscf_i.cf_765 IS 'manual_inception_date';


--
-- Name: COLUMN vtiger_potentialscf_i.cf_789; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potentialscf_i.cf_789 IS 'source_detail';


--
-- Name: COLUMN vtiger_potentialscf_i.cf_809; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potentialscf_i.cf_809 IS 'reason_lost';


--
-- Name: COLUMN vtiger_potentialscf_i.cf_831; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potentialscf_i.cf_831 IS 'sales_thread';


--
-- Name: COLUMN vtiger_potentialscf_i.cf_833; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potentialscf_i.cf_833 IS 'presales_thread';


--
-- Name: COLUMN vtiger_potentialscf_i.cf_872; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potentialscf_i.cf_872 IS 'postsales_thread';


--
-- Name: COLUMN vtiger_potentialscf_i.cf_874; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potentialscf_i.cf_874 IS 'category';


--
-- Name: COLUMN vtiger_potentialscf_i.cf_880; Type: COMMENT; Schema: stage;
--

COMMENT ON COLUMN stage.vtiger_potentialscf_i.cf_880 IS 'case_study';


--
-- Name: vtiger_servicecontracts_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_servicecontracts_i (
    servicecontractsid integer NOT NULL,
    start_date character varying(10) DEFAULT NULL::character varying,
    end_date character varying(10) DEFAULT NULL::character varying,
    sc_related_to integer,
    tracking_unit character varying(100) DEFAULT NULL::character varying,
    total_units numeric(5,2) DEFAULT NULL::numeric,
    used_units numeric(5,2) DEFAULT NULL::numeric,
    subject character varying(100) DEFAULT NULL::character varying,
    due_date character varying(10) DEFAULT NULL::character varying,
    planned_duration character varying(256) DEFAULT NULL::character varying,
    actual_duration character varying(256) DEFAULT NULL::character varying,
    contract_status character varying(200) DEFAULT NULL::character varying,
    priority character varying(200) DEFAULT NULL::character varying,
    contract_type character varying(200) DEFAULT NULL::character varying,
    progress numeric(5,2) DEFAULT NULL::numeric,
    contract_no character varying(100) DEFAULT NULL::character varying,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_servicecontractscf_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_servicecontractscf_i (
    servicecontractsid integer NOT NULL,
    cf_801 character varying(100) DEFAULT ''::character varying,
    cf_849 character varying(255) DEFAULT ''::character varying,
    cf_878 character varying(10) DEFAULT NULL::character varying,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: vtiger_users_i; Type: TABLE; Schema: stage;
--

CREATE TABLE stage.vtiger_users_i (
    id integer NOT NULL,
    user_name character varying(255) DEFAULT NULL::character varying,
    user_password character varying(200) DEFAULT NULL::character varying,
    user_hash character varying(32) DEFAULT NULL::character varying,
    cal_color character varying(25) DEFAULT '#E6FAD8'::character varying,
    first_name character varying(30) DEFAULT NULL::character varying,
    last_name character varying(30) DEFAULT NULL::character varying,
    reports_to_id character varying(36) DEFAULT NULL::character varying,
    is_admin character varying(3) DEFAULT '0'::character varying,
    currency_id integer DEFAULT 1 NOT NULL,
    description character varying(21845),
    date_entered character varying(21) NOT NULL,
    date_modified character varying(19) DEFAULT '0000-00-00 00:00:00'::character varying,
    modified_user_id character varying(36) DEFAULT NULL::character varying,
    title character varying(50) DEFAULT NULL::character varying,
    department character varying(50) DEFAULT NULL::character varying,
    phone_home character varying(50) DEFAULT NULL::character varying,
    phone_mobile character varying(50) DEFAULT NULL::character varying,
    phone_work character varying(50) DEFAULT NULL::character varying,
    phone_other character varying(50) DEFAULT NULL::character varying,
    phone_fax character varying(50) DEFAULT NULL::character varying,
    email1 character varying(100) DEFAULT NULL::character varying,
    email2 character varying(100) DEFAULT NULL::character varying,
    secondaryemail character varying(100) DEFAULT NULL::character varying,
    status character varying(25) DEFAULT NULL::character varying,
    signature character varying(21845),
    address_street character varying(150) DEFAULT NULL::character varying,
    address_city character varying(100) DEFAULT NULL::character varying,
    address_state character varying(100) DEFAULT NULL::character varying,
    address_country character varying(25) DEFAULT NULL::character varying,
    address_postalcode character varying(9) DEFAULT NULL::character varying,
    user_preferences character varying(21845),
    tz character varying(30) DEFAULT NULL::character varying,
    holidays character varying(60) DEFAULT NULL::character varying,
    namedays character varying(60) DEFAULT NULL::character varying,
    workdays character varying(30) DEFAULT NULL::character varying,
    weekstart integer,
    date_format character varying(200) DEFAULT NULL::character varying,
    hour_format character varying(30) DEFAULT 'am/pm'::character varying,
    start_hour character varying(30) DEFAULT '10:00'::character varying,
    end_hour character varying(30) DEFAULT '23:00'::character varying,
    activity_view character varying(200) DEFAULT 'Today'::character varying,
    lead_view character varying(200) DEFAULT 'Today'::character varying,
    imagename character varying(250) DEFAULT NULL::character varying,
    deleted integer DEFAULT 0 NOT NULL,
    confirm_password character varying(300) DEFAULT NULL::character varying,
    internal_mailer character varying(3) DEFAULT '1'::character varying NOT NULL,
    reminder_interval character varying(100) DEFAULT NULL::character varying,
    reminder_next_time character varying(100) DEFAULT NULL::character varying,
    crypt_type character varying(20) DEFAULT 'MD5'::character varying NOT NULL,
    accesskey character varying(36) DEFAULT NULL::character varying,
    theme character varying(100) DEFAULT NULL::character varying,
    language character varying(36) DEFAULT NULL::character varying,
    time_zone character varying(200) DEFAULT NULL::character varying,
    currency_grouping_pattern character varying(100) DEFAULT NULL::character varying,
    currency_decimal_separator character varying(2) DEFAULT NULL::character varying,
    currency_grouping_separator character varying(2) DEFAULT NULL::character varying,
    currency_symbol_placement character varying(20) DEFAULT NULL::character varying,
    phone_crm_extension character varying(100) DEFAULT NULL::character varying,
    no_of_currency_decimals character varying(2) DEFAULT NULL::character varying,
    truncate_trailing_zeros character varying(3) DEFAULT NULL::character varying,
    dayoftheweek character varying(100) DEFAULT NULL::character varying,
    callduration character varying(100) DEFAULT NULL::character varying,
    othereventduration character varying(100) DEFAULT NULL::character varying,
    calendarsharedtype character varying(100) DEFAULT NULL::character varying,
    default_record_view character varying(10) DEFAULT NULL::character varying,
    leftpanelhide character varying(3) DEFAULT NULL::character varying,
    rowheight character varying(10) DEFAULT NULL::character varying,
    defaulteventstatus character varying(50) DEFAULT NULL::character varying,
    defaultactivitytype character varying(50) DEFAULT NULL::character varying,
    hidecompletedevents integer,
    is_owner character varying(5) DEFAULT NULL::character varying,
    tech_data_load_uuid text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL
);



--
-- Name: cnb_exchange_rate_counter_currency_czk_i pk_czech_national_bank__exchange_rate_counter_currency_czk_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.cnb_exchange_rate_counter_currency_czk_i
    ADD CONSTRAINT pk_czech_national_bank__exchange_rate_counter_currency_czk_i PRIMARY KEY (datum, usd_1, eur_1);


--
-- Name: jira_issue_comment_i pk_jira_issue_comment_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.jira_issue_comment_i
    ADD CONSTRAINT pk_jira_issue_comment_i PRIMARY KEY (id);


--
-- Name: jira_issue_relation_i pk_jira_issue_relation_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.jira_issue_relation_i
    ADD CONSTRAINT pk_jira_issue_relation_i PRIMARY KEY (issue_key, issue_key_related_issue, relation, relation_direction);


--
-- Name: jira_project_i pk_jira_project_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.jira_project_i
    ADD CONSTRAINT pk_jira_project_i PRIMARY KEY (project_key);


--
-- Name: jira_release_i pk_jira_release_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.jira_release_i
    ADD CONSTRAINT pk_jira_release_i PRIMARY KEY (release_id);


--
-- Name: mailchimp_campaign_i pk_mailchimp_campaign_i_id; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.mailchimp_campaign_i
    ADD CONSTRAINT pk_mailchimp_campaign_i_id PRIMARY KEY (id);


--
-- Name: mailchimp_list_i pk_mailchimp_mailing_list_i_id; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.mailchimp_list_i
    ADD CONSTRAINT pk_mailchimp_mailing_list_i_id PRIMARY KEY (id);


--
-- Name: mailchimp_report_i pk_mailchimp_report_i_id; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.mailchimp_report_i
    ADD CONSTRAINT pk_mailchimp_report_i_id PRIMARY KEY (id);


--
-- Name: mailchimp_list_segment_i pk_mailchimp_segment_i_id; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.mailchimp_list_segment_i
    ADD CONSTRAINT pk_mailchimp_segment_i_id PRIMARY KEY (id);


--
-- Name: ocean_currency_i pk_ocean_currency_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.ocean_currency_i
    ADD CONSTRAINT pk_ocean_currency_i PRIMARY KEY (currency);


--
-- Name: ocean_organziation_to_crm_map_i pk_ocean_organziation_to_crm_map_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.ocean_organziation_to_crm_map_i
    ADD CONSTRAINT pk_ocean_organziation_to_crm_map_i PRIMARY KEY (organization_name);


--
-- Name: ocean_partner_list_i pk_ocean_partner_list_i_partner_name; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.ocean_partner_list_i
    ADD CONSTRAINT pk_ocean_partner_list_i_partner_name PRIMARY KEY (partner_name);


--
-- Name: ocean_payment_received_i pk_ocean_payment_received_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.ocean_payment_received_i
    ADD CONSTRAINT pk_ocean_payment_received_i PRIMARY KEY (payment_received);


--
-- Name: ocean_revenue_type_i pk_ocean_revenue_type_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.ocean_revenue_type_i
    ADD CONSTRAINT pk_ocean_revenue_type_i PRIMARY KEY (revenue_type);


--
-- Name: ocean_sales_report_i pk_ocean_sales_report_i_sale_key; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.ocean_sales_report_i
    ADD CONSTRAINT pk_ocean_sales_report_i_sale_key PRIMARY KEY (sale_key);


--
-- Name: ocean_sales_representative_i pk_ocean_sales_representative_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.ocean_sales_representative_i
    ADD CONSTRAINT pk_ocean_sales_representative_i PRIMARY KEY (sales_rep_code);


--
-- Name: ocean_seller_i pk_ocean_seller_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.ocean_seller_i
    ADD CONSTRAINT pk_ocean_seller_i PRIMARY KEY (seller_code);


--
-- Name: vtiger_account_i pk_vtiger_account_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_account_i
    ADD CONSTRAINT pk_vtiger_account_i PRIMARY KEY (accountid);


--
-- Name: vtiger_accountbillads_i pk_vtiger_accountbillads_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_accountbillads_i
    ADD CONSTRAINT pk_vtiger_accountbillads_i PRIMARY KEY (accountaddressid);


--
-- Name: vtiger_accountscf_i pk_vtiger_accountscf_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_accountscf_i
    ADD CONSTRAINT pk_vtiger_accountscf_i PRIMARY KEY (accountid);


--
-- Name: vtiger_accountshipads_i pk_vtiger_accountshipads_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_accountshipads_i
    ADD CONSTRAINT pk_vtiger_accountshipads_i PRIMARY KEY (accountaddressid);


--
-- Name: vtiger_activity_i pk_vtiger_activity_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_activity_i
    ADD CONSTRAINT pk_vtiger_activity_i PRIMARY KEY (activityid);


--
-- Name: vtiger_campaign_i pk_vtiger_campaign_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_campaign_i
    ADD CONSTRAINT pk_vtiger_campaign_i PRIMARY KEY (campaign_no);


--
-- Name: vtiger_campaigncontrel_i pk_vtiger_campaigncontrel_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_campaigncontrel_i
    ADD CONSTRAINT pk_vtiger_campaigncontrel_i PRIMARY KEY (campaignid, contactid, campaignrelstatusid);


--
-- Name: vtiger_campaignleadrel_i pk_vtiger_campaignleadrel_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_campaignleadrel_i
    ADD CONSTRAINT pk_vtiger_campaignleadrel_i PRIMARY KEY (campaignid, leadid, campaignrelstatusid);


--
-- Name: vtiger_campaignscf_i pk_vtiger_campaignscf_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_campaignscf_i
    ADD CONSTRAINT pk_vtiger_campaignscf_i PRIMARY KEY (campaignid);


--
-- Name: vtiger_cntactivityrel_i pk_vtiger_cntactivityrel_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_cntactivityrel_i
    ADD CONSTRAINT pk_vtiger_cntactivityrel_i PRIMARY KEY (contactid, activityid);


--
-- Name: vtiger_contactaddress_i pk_vtiger_contactaddress_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_contactaddress_i
    ADD CONSTRAINT pk_vtiger_contactaddress_i PRIMARY KEY (contactaddressid);


--
-- Name: vtiger_contactdetails_i pk_vtiger_contactdetails_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_contactdetails_i
    ADD CONSTRAINT pk_vtiger_contactdetails_i PRIMARY KEY (contactid);


--
-- Name: vtiger_contactscf_i pk_vtiger_contactscf_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_contactscf_i
    ADD CONSTRAINT pk_vtiger_contactscf_i PRIMARY KEY (contactid);


--
-- Name: vtiger_contactsubdetails_i pk_vtiger_contactsubdetails_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_contactsubdetails_i
    ADD CONSTRAINT pk_vtiger_contactsubdetails_i PRIMARY KEY (contactsubscriptionid);


--
-- Name: vtiger_contpotentialrel_i pk_vtiger_contpotentialrel_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_contpotentialrel_i
    ADD CONSTRAINT pk_vtiger_contpotentialrel_i PRIMARY KEY (contactid, potentialid);


--
-- Name: vtiger_crmentity_i pk_vtiger_crmentity_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_crmentity_i
    ADD CONSTRAINT pk_vtiger_crmentity_i PRIMARY KEY (crmid);


--
-- Name: vtiger_crmentityrel_i pk_vtiger_crmentityrel_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_crmentityrel_i
    ADD CONSTRAINT pk_vtiger_crmentityrel_i PRIMARY KEY (crmid, relcrmid, relmodule, module);


--
-- Name: vtiger_emaildetails_i pk_vtiger_emaildetails_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_emaildetails_i
    ADD CONSTRAINT pk_vtiger_emaildetails_i PRIMARY KEY (emailid);


--
-- Name: vtiger_entityname_i pk_vtiger_entityname_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_entityname_i
    ADD CONSTRAINT pk_vtiger_entityname_i PRIMARY KEY (tabid);


--
-- Name: vtiger_field_i pk_vtiger_field_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_field_i
    ADD CONSTRAINT pk_vtiger_field_i PRIMARY KEY (fieldid);


--
-- Name: vtiger_leadaddress_i pk_vtiger_leadaddress_i_leadaddressid; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_leadaddress_i
    ADD CONSTRAINT pk_vtiger_leadaddress_i_leadaddressid PRIMARY KEY (leadaddressid);


--
-- Name: vtiger_leaddetails_i pk_vtiger_leaddetails_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_leaddetails_i
    ADD CONSTRAINT pk_vtiger_leaddetails_i PRIMARY KEY (leadid);


--
-- Name: vtiger_leadscf_i pk_vtiger_leadscf_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_leadscf_i
    ADD CONSTRAINT pk_vtiger_leadscf_i PRIMARY KEY (leadid);


--
-- Name: vtiger_leadsource_i pk_vtiger_leadsource_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_leadsource_i
    ADD CONSTRAINT pk_vtiger_leadsource_i PRIMARY KEY (leadsourceid);


--
-- Name: vtiger_leadstatus_i pk_vtiger_leadstatus_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_leadstatus_i
    ADD CONSTRAINT pk_vtiger_leadstatus_i PRIMARY KEY (leadstatusid);


--
-- Name: vtiger_leadsubdetails_i pk_vtiger_leadsubdetails_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_leadsubdetails_i
    ADD CONSTRAINT pk_vtiger_leadsubdetails_i PRIMARY KEY (leadsubscriptionid);


--
-- Name: vtiger_modcomments_i pk_vtiger_modcomments_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_modcomments_i
    ADD CONSTRAINT pk_vtiger_modcomments_i PRIMARY KEY (modcommentsid);


--
-- Name: vtiger_potential_i pk_vtiger_potential_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_potential_i
    ADD CONSTRAINT pk_vtiger_potential_i PRIMARY KEY (potentialid);


--
-- Name: vtiger_potentialscf_i pk_vtiger_potentialscf_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_potentialscf_i
    ADD CONSTRAINT pk_vtiger_potentialscf_i PRIMARY KEY (potentialid);


--
-- Name: vtiger_servicecontracts_i pk_vtiger_servicecontracts_i_servicecontractsid; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_servicecontracts_i
    ADD CONSTRAINT pk_vtiger_servicecontracts_i_servicecontractsid PRIMARY KEY (servicecontractsid);


--
-- Name: vtiger_servicecontractscf_i pk_vtiger_servicecontractscf_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_servicecontractscf_i
    ADD CONSTRAINT pk_vtiger_servicecontractscf_i PRIMARY KEY (servicecontractsid);


--
-- Name: vtiger_users_i pk_vtiger_users_i; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_users_i
    ADD CONSTRAINT pk_vtiger_users_i PRIMARY KEY (id);


--
-- Name: ocean_removed_jira_user_i ux_ocean_removed_jira_user_i_accountid; Type: CONSTRAINT; Schema: stage; Owner: -
--

ALTER TABLE ONLY stage.ocean_removed_jira_user_i
    ADD CONSTRAINT ux_ocean_removed_jira_user_i_accountid UNIQUE (removed_user_accountid);


--
-- Name: vtiger_modtracker_basic_i vtiger_modtracker_basic_i_pkey; Type: CONSTRAINT; Schema: stage; Owner: -
--

ALTER TABLE ONLY stage.vtiger_modtracker_basic_i
    ADD CONSTRAINT vtiger_modtracker_basic_i_pkey PRIMARY KEY (id);


--
-- Name: vtiger_modtracker_relations_i vtiger_modtracker_relations_i_pkey; Type: CONSTRAINT; Schema: stage;
--

ALTER TABLE ONLY stage.vtiger_modtracker_relations_i
    ADD CONSTRAINT vtiger_modtracker_relations_i_pkey PRIMARY KEY (id);


--
-- Name: ix_vtiger_modtracker_basic_i_crmid; Type: INDEX; Schema: stage;
--

CREATE INDEX ix_vtiger_modtracker_basic_i_crmid ON stage.vtiger_modtracker_basic_i USING btree (crmid);


--
-- Name: ix_vtiger_modtracker_detail_i_id; Type: INDEX; Schema: stage;
--

CREATE INDEX ix_vtiger_modtracker_detail_i_id ON stage.vtiger_modtracker_detail_i USING btree (id);


--
-- Name: ix_vtiger_modtracker_relations_i_targetid; Type: INDEX; Schema: stage;
--

CREATE INDEX ix_vtiger_modtracker_relations_i_targetid ON stage.vtiger_modtracker_relations_i USING btree (targetid);
