CREATE OR REPLACE FUNCTION core.tf_i_src_mailchimp_trg_mailing_list_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'mailchimp_*' tables into core input table mailing_list_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-07-03 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
TEXT_ARRAY_NULL TEXT[] := (SELECT text_array_null FROM core.c_null_replacement_g);
NULL_DATE DATE := (SELECT date_never FROM core.c_null_replacement_g);
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    ------------------------
    -- INSERT NULL RECORD --
    ------------------------

    INSERT INTO core.mailing_list_i (
        mailing_list_id
        ,mailing_list_key
        ,mailchimp_id
        ,mailchimp_id_web_id
        ,mailing_list_name
        ,notify_on_subscribe_email
        ,notify_on_unsubscribe_email
        ,fk_date_id_created_date
        ,created_timestamp
        ,subscribe_url_short
        ,subscribe_url_long
        ,visibility
        ,double_optin
        ,marketing_permissions
        ,member_count
        ,unsubscribe_count
        ,cleaned_count
        ,member_count_since_last_campaign
        ,unsubscribe_count_last_campaign
        ,cleaned_count_last_campaign
        ,campaign_count
        ,fk_date_id_last_sent_date
        ,campaign_last_sent_timestamp
        ,merge_field_count
        ,avg_sub_rate
        ,avg_unsub_rate
        ,target_sub_rate
        ,open_rate
        ,click_rate
        ,fk_date_id_last_sub_date
        ,last_sub_timestamp
        ,fk_date_id_last_unsub_date
        ,last_unsub_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        ,tech_deleted_in_source_system
        )
    VALUES (
         -1 -- mailing_list_id
        ,TEXT_NULL -- mailing_list_key
        ,TEXT_NULL-- mailchimp_id
        ,-1 -- mailchimp_id_web_id
        ,TEXT_NULL -- mailing_list_name
        ,TEXT_NULL -- notify_on_subscribe_email
        ,TEXT_NULL -- notify_on_unsubscribe_email
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
        ,TEXT_NULL -- subscribe_url_short
        ,TEXT_NULL -- subscribe_url_long
        ,TEXT_NULL -- visibility
        ,FALSE -- double_optin
        ,FALSE-- marketing_permissions
        ,-1 -- member_count
        ,-1 -- unsubscribe_count
        ,-1 -- cleaned_count
        ,-1 -- member_count_since_last_campaign
        ,-1 -- unsubscribe_count_last_campaign
        ,-1 -- cleaned_count_last_campaign
        ,-1 -- campaign_count
        ,-1 -- fk_date_id_last_sent_date
        ,TIMESTAMP_NEVER -- campaign_last_sent_timestamp
        ,-1-- merge_field_count
        ,-1-- avg_sub_rate
        ,-1-- avg_unsub_rate
        ,-1-- target_sub_rate
        ,-1-- open_rate
        ,-1-- click_rate
        ,-1 -- fk_date_id_last_sub_date
        ,TIMESTAMP_NEVER -- last_sub_timestamp
        ,-1 -- fk_date_id_last_unsub_date
        ,TIMESTAMP_NEVER -- last_unsub_timestamp
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,TEXT_NULL -- tech_row_hash
        ,-1 -- tech_data_load_utc_timestamp
        ,TEXT_NULL -- tech_data_load_uuid
        ,FALSE -- tech_deleted_in_source_system
    ) ON CONFLICT DO NOTHING;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_mailing_list_i;

    CREATE TEMPORARY TABLE tmp_mailing_list_i (
        mailing_list_key                    text NOT NULL
        ,mailchimp_id                       text NOT NULL
        ,mailchimp_id_web_id                integer NOT NULL
        ,mailing_list_name                  text NOT NULL
        ,notify_on_subscribe_email          text NOT NULL
        ,notify_on_unsubscribe_email        text NOT NULL
        ,fk_date_id_created_date            INTEGER NOT NULL
        ,created_timestamp                  TIMESTAMP WITH TIME ZONE NOT NULL
        ,subscribe_url_short                text
        ,subscribe_url_long                 text
        ,visibility                         text
        ,double_optin                       bool
        ,marketing_permissions              bool
        ,member_count                       integer NOT NULL
        ,unsubscribe_count                  integer NOT NULL
        ,cleaned_count                      integer
        ,member_count_since_last_campaign   integer
        ,unsubscribe_count_last_campaign    integer
        ,cleaned_count_last_campaign        integer
        ,campaign_count                     integer
        ,fk_date_id_last_sent_date          INTEGER NOT NULL
        ,campaign_last_sent_timestamp       TIMESTAMP WITH TIME ZONE NOT NULL
        ,merge_field_count                  integer
        ,avg_sub_rate                       real
        ,avg_unsub_rate                     real
        ,target_sub_rate                    real
        ,open_rate                          real
        ,click_rate                         real
        ,fk_date_id_last_sub_date           INTEGER NOT NULL
        ,last_sub_timestamp                 TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_last_unsub_date         INTEGER NOT NULL
        ,last_unsub_timestamp               TIMESTAMP WITH TIME ZONE NOT NULL
        ,tech_insert_function               text NOT NULL
        ,tech_insert_utc_timestamp          bigint  NOT NULL
        ,tech_row_hash                      text  NOT NULL
        ,tech_data_load_utc_timestamp       bigint  NOT NULL
        ,tech_data_load_uuid                text  NOT NULL
        ,tech_deleted_in_source_system      bool DEFAULT false NOT NULL
    );

    INSERT INTO tmp_mailing_list_i (
        mailing_list_key
        ,mailchimp_id
        ,mailchimp_id_web_id
        ,mailing_list_name
        ,notify_on_subscribe_email
        ,notify_on_unsubscribe_email
        ,fk_date_id_created_date
        ,created_timestamp
        ,subscribe_url_short
        ,subscribe_url_long
        ,visibility
        ,double_optin
        ,marketing_permissions
        ,member_count
        ,unsubscribe_count
        ,cleaned_count
        ,member_count_since_last_campaign
        ,unsubscribe_count_last_campaign
        ,cleaned_count_last_campaign
        ,campaign_count
        ,fk_date_id_last_sent_date
        ,campaign_last_sent_timestamp
        ,merge_field_count
        ,avg_sub_rate
        ,avg_unsub_rate
        ,target_sub_rate
        ,open_rate
        ,click_rate
        ,fk_date_id_last_sub_date
        ,last_sub_timestamp
        ,fk_date_id_last_unsub_date
        ,last_unsub_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
         mailing_list.id AS mailing_list_key
        ,mailing_list.id AS mailchimp_id
        ,mailing_list.web_id AS mailchimp_id_web_id
        ,mailing_list.name AS mailing_list_name
        ,mailing_list.notify_on_subscribe AS notify_on_subscribe_email
        ,mailing_list.notify_on_unsubscribe AS notify_on_unsubscribe_email
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(mailing_list.date_created), -1) AS fk_date_id_created_date
        ,CASE
            WHEN mailing_list.date_created = '' THEN TIMESTAMP_NEVER
            ELSE mailing_list.date_created::TIMESTAMP WITH TIME ZONE
        END AS created_timestamp
        ,mailing_list.subscribe_url_short AS subscribe_url_short
        ,mailing_list.subscribe_url_long AS subscribe_url_long
        ,mailing_list.visibility AS visibility
        ,mailing_list.double_optin AS double_optin
        ,mailing_list.marketing_permissions AS marketing_permissions
        ,mailing_list.stats_member_count AS member_count
        ,mailing_list.stats_unsubscribe_count AS unsubscribe_count
        ,mailing_list.stats_cleaned_count AS cleaned_count
        ,mailing_list.stats_member_count_since_send AS member_count_since_last_campaign
        ,mailing_list.stats_unsubscribe_count_since_send AS unsubscribe_count_last_campaign
        ,mailing_list.stats_cleaned_count_since_send AS cleaned_count_last_campaign
        ,mailing_list.stats_campaign_count AS campaign_count
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(mailing_list.stats_campaign_last_sent), -1) AS fk_date_id_last_sent_date
        ,CASE
            WHEN mailing_list.stats_campaign_last_sent = '' THEN TIMESTAMP_NEVER
            ELSE mailing_list.stats_campaign_last_sent::TIMESTAMP WITH TIME ZONE
        END AS campaign_last_sent_timestamp
        ,mailing_list.stats_merge_field_count AS merge_field_count
        ,mailing_list.stats_avg_sub_rate AS avg_sub_rate
        ,mailing_list.stats_avg_unsub_rate AS avg_unsub_rate
        ,mailing_list.stats_target_sub_rate AS target_sub_rate
        ,mailing_list.stats_open_rate AS open_rate
        ,mailing_list.stats_click_rate AS click_rate
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(mailing_list.stats_last_sub_date), -1) AS fk_date_id_last_sub_date
        ,CASE
            WHEN mailing_list.stats_last_sub_date = '' THEN TIMESTAMP_NEVER
            ELSE mailing_list.stats_last_sub_date::TIMESTAMP WITH TIME ZONE
        END AS last_sub_timestamp
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(mailing_list.stats_last_unsub_date), -1) AS fk_date_id_last_unsub_date
        ,CASE
            WHEN mailing_list.stats_last_unsub_date = '' THEN TIMESTAMP_NEVER
            ELSE mailing_list.stats_last_unsub_date::TIMESTAMP WITH TIME ZONE
        END AS last_unsub_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(mailing_list.id, '')
            || COALESCE(mailing_list.web_id::TEXT, '')
            || COALESCE(mailing_list.name, '')
            || COALESCE(mailing_list.notify_on_subscribe, '')
            || COALESCE(mailing_list.notify_on_unsubscribe, '')
            || COALESCE(mailing_list.date_created, '')
            || COALESCE(mailing_list.subscribe_url_short, '')
            || COALESCE(mailing_list.subscribe_url_long, '')
            || COALESCE(mailing_list.visibility, '')
            || COALESCE(mailing_list.double_optin::TEXT, '')
            || COALESCE(mailing_list.marketing_permissions::TEXT, '')
            || COALESCE(mailing_list.stats_member_count::TEXT, '')
            || COALESCE(mailing_list.stats_unsubscribe_count::TEXT, '')
            || COALESCE(mailing_list.stats_cleaned_count::TEXT, '')
            || COALESCE(mailing_list.stats_member_count_since_send::TEXT, '')
            || COALESCE(mailing_list.stats_unsubscribe_count_since_send::TEXT, '')
            || COALESCE(mailing_list.stats_cleaned_count_since_send::TEXT, '')
            || COALESCE(mailing_list.stats_campaign_count::TEXT, '')
            || COALESCE(mailing_list.stats_campaign_last_sent, '')
            || COALESCE(mailing_list.stats_merge_field_count::TEXT, '')
            || COALESCE(mailing_list.stats_avg_sub_rate::TEXT, '')
            || COALESCE(mailing_list.stats_avg_unsub_rate::TEXT, '')
            || COALESCE(mailing_list.stats_target_sub_rate::TEXT, '')
            || COALESCE(mailing_list.stats_open_rate::TEXT, '')
            || COALESCE(mailing_list.stats_click_rate::TEXT, '')
            || COALESCE(mailing_list.stats_last_sub_date, '')
            || COALESCE(mailing_list.stats_last_unsub_date, '')
        ) AS tech_row_hash
        ,mailing_list.tech_data_load_utc_timestamp
        ,mailing_list.tech_data_load_uuid
    FROM stage.mailchimp_list_i AS mailing_list;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.mailing_list_i (
        mailing_list_key
        ,mailchimp_id
        ,mailchimp_id_web_id
        ,mailing_list_name
        ,notify_on_subscribe_email
        ,notify_on_unsubscribe_email
        ,fk_date_id_created_date
        ,created_timestamp
        ,subscribe_url_short
        ,subscribe_url_long
        ,visibility
        ,double_optin
        ,marketing_permissions
        ,member_count
        ,unsubscribe_count
        ,cleaned_count
        ,member_count_since_last_campaign
        ,unsubscribe_count_last_campaign
        ,cleaned_count_last_campaign
        ,campaign_count
        ,fk_date_id_last_sent_date
        ,campaign_last_sent_timestamp
        ,merge_field_count
        ,avg_sub_rate
        ,avg_unsub_rate
        ,target_sub_rate
        ,open_rate
        ,click_rate
        ,fk_date_id_last_sub_date
        ,last_sub_timestamp
        ,fk_date_id_last_unsub_date
        ,last_unsub_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_mailing_list_i.mailing_list_key
        ,tmp_mailing_list_i.mailchimp_id
        ,tmp_mailing_list_i.mailchimp_id_web_id
        ,tmp_mailing_list_i.mailing_list_name
        ,tmp_mailing_list_i.notify_on_subscribe_email
        ,tmp_mailing_list_i.notify_on_unsubscribe_email
        ,tmp_mailing_list_i.fk_date_id_created_date
        ,tmp_mailing_list_i.created_timestamp
        ,tmp_mailing_list_i.subscribe_url_short
        ,tmp_mailing_list_i.subscribe_url_long
        ,tmp_mailing_list_i.visibility
        ,tmp_mailing_list_i.double_optin
        ,tmp_mailing_list_i.marketing_permissions
        ,tmp_mailing_list_i.member_count
        ,tmp_mailing_list_i.unsubscribe_count
        ,tmp_mailing_list_i.cleaned_count
        ,tmp_mailing_list_i.member_count_since_last_campaign
        ,tmp_mailing_list_i.unsubscribe_count_last_campaign
        ,tmp_mailing_list_i.cleaned_count_last_campaign
        ,tmp_mailing_list_i.campaign_count
        ,tmp_mailing_list_i.fk_date_id_last_sent_date
        ,tmp_mailing_list_i.campaign_last_sent_timestamp
        ,tmp_mailing_list_i.merge_field_count
        ,tmp_mailing_list_i.avg_sub_rate
        ,tmp_mailing_list_i.avg_unsub_rate
        ,tmp_mailing_list_i.target_sub_rate
        ,tmp_mailing_list_i.open_rate
        ,tmp_mailing_list_i.click_rate
        ,tmp_mailing_list_i.fk_date_id_last_sub_date
        ,tmp_mailing_list_i.last_sub_timestamp
        ,tmp_mailing_list_i.fk_date_id_last_unsub_date
        ,tmp_mailing_list_i.last_unsub_timestamp
        ,tmp_mailing_list_i.tech_insert_function
        ,tmp_mailing_list_i.tech_insert_utc_timestamp
        ,tmp_mailing_list_i.tech_deleted_in_source_system
        ,tmp_mailing_list_i.tech_row_hash
        ,tmp_mailing_list_i.tech_data_load_utc_timestamp
        ,tmp_mailing_list_i.tech_data_load_uuid
    FROM tmp_mailing_list_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
