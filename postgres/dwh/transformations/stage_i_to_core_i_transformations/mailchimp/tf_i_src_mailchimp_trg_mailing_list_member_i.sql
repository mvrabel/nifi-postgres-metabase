CREATE OR REPLACE FUNCTION core.tf_i_src_mailchimp_trg_mailing_list_member_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'mailchimp_*' tables into core input table mailing_list_member_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-07-03 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER DATE := (SELECT timestamp_never FROM core.c_null_replacement_g);
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_mailing_list_member_i;

    CREATE TEMPORARY TABLE tmp_mailing_list_member_i (
        mailing_list_member_key         text  NOT NULL
        ,mailchimp_id                   text  NOT NULL
        ,email_address                  text  NOT NULL
        ,mailchimp_unique_email_id      text  NOT NULL
        ,status                         text  NOT NULL
        ,fk_party_id                    integer
        ,avg_open_rate                  real  NOT NULL
        ,avg_click_rate                 real  NOT NULL
        ,ip_address_signup              text
        ,fk_date_id_signup_date         integer NOT NULL
        ,timestamp_signup               timestamp with time zone NOT NULL
        ,ip_address_opt_in              text
        ,fk_date_id_opt_in_date         integer NOT NULL
        ,timestamp_opt_in               timestamp with time zone NOT NULL
        ,fk_date_id_last_changed_date   integer NOT NULL
        ,last_changed_timestamp         timestamp with time zone NOT NULL
        ,email_client                   text
        ,location_latitude              integer
        ,location_longitude             integer
        ,location_country_code          text
        ,fk_mailing_list_id             integer  NOT NULL
        ,tech_insert_function           text  NOT NULL
        ,tech_insert_utc_timestamp      bigint  NOT NULL
        ,tech_row_hash                  text  NOT NULL
        ,tech_data_load_utc_timestamp   bigint  NOT NULL
        ,tech_data_load_uuid            text  NOT NULL
        ,tech_deleted_in_source_system  bool NOT NULL
     );

    INSERT INTO tmp_mailing_list_member_i (
        mailing_list_member_key
        ,mailchimp_id
        ,email_address
        ,mailchimp_unique_email_id
        ,status
        ,fk_party_id
        ,avg_open_rate
        ,avg_click_rate
        ,ip_address_signup
        ,fk_date_id_signup_date
        ,timestamp_signup
        ,ip_address_opt_in
        ,fk_date_id_opt_in_date
        ,timestamp_opt_in
        ,fk_date_id_last_changed_date
        ,last_changed_timestamp
        ,email_client
        ,location_latitude
        ,location_longitude
        ,location_country_code
        ,fk_mailing_list_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        list_member.id || list_member.list_id AS mailing_list_member_key
        ,list_member.id AS mailchimp_id
        ,list_member.email_address AS email_address
        ,list_member.unique_email_id AS mailchimp_unique_email_id
        ,list_member.status AS status
        ,core_input_party.party_id AS fk_party_id
        ,list_member.stats_avg_open_rate AS avg_open_rate
        ,list_member.stats_avg_click_rate AS avg_click_rate
        ,list_member.ip_signup As ip_address_signup
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(list_member.timestamp_signup), -1) AS fk_date_id_signup_date
        ,CASE
            WHEN list_member.timestamp_signup <> '' THEN list_member.timestamp_signup::TIMESTAMP WITH TIME ZONE
            ELSE TIMESTAMP_NEVER
        END AS timestamp_signup
        ,list_member.ip_opt AS ip_address_opt_in
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(list_member.timestamp_opt), -1) AS fk_date_id_opt_in_date
        ,CASE
            WHEN list_member.timestamp_opt <> '' THEN list_member.timestamp_opt::TIMESTAMP WITH TIME ZONE
            ELSE TIMESTAMP_NEVER
        END AS timestamp_opt_in
        ,COALESCE(tf_u_convert_iso_8601_to_yyyymmdd_integer(list_member.last_changed), -1) AS fk_date_id_last_changed_date
        ,CASE
            WHEN list_member.last_changed <> '' THEN list_member.last_changed::TIMESTAMP WITH TIME ZONE
            ELSE TIMESTAMP_NEVER
        END AS last_changed_timestamp
        ,list_member.email_client AS email_client
        ,list_member.location_latitude AS location_latitude
        ,list_member.location_longitude AS location_longitude
        ,list_member.location_country_code AS location_country_code
        ,core_input_mailing_list.mailing_list_id AS fk_mailing_list_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(email_address, '')
            || COALESCE(unique_email_id, '')
            || COALESCE(status, '')
            || COALESCE(stats_avg_open_rate::TEXT, '')
            || COALESCE(stats_avg_click_rate::TEXT, '')
            || COALESCE(ip_signup, '')
            || COALESCE(timestamp_signup, '')
            || COALESCE(ip_opt, '')
            || COALESCE(timestamp_opt, '')
            || COALESCE(last_changed, '')
            || COALESCE(email_client, '')
            || COALESCE(location_latitude::TEXT, '')
            || COALESCE(location_longitude::TEXT, '')
            || COALESCE(location_country_code, '')
            || COALESCE(list_id, '')
            || core_input_party.party_key
            || core_input_mailing_list.mailing_list_key
        ) AS tech_row_hash
        ,list_member.tech_data_load_utc_timestamp
        ,list_member.tech_data_load_uuid
    FROM stage.mailchimp_list_member_i AS list_member
    JOIN core.party_i AS core_input_party ON core_input_party.party_key = list_member.id || list_member.list_id
    JOIN core.mailing_list_i AS core_input_mailing_list ON core_input_mailing_list.mailing_list_key = list_member.list_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.mailing_list_member_i (
        mailing_list_member_key
        ,mailchimp_id
        ,email_address
        ,mailchimp_unique_email_id
        ,status
        ,fk_party_id
        ,avg_open_rate
        ,avg_click_rate
        ,ip_address_signup
        ,fk_date_id_signup_date
        ,timestamp_signup
        ,ip_address_opt_in
        ,fk_date_id_opt_in_date
        ,timestamp_opt_in
        ,fk_date_id_last_changed_date
        ,last_changed_timestamp
        ,email_client
        ,location_latitude
        ,location_longitude
        ,location_country_code
        ,fk_mailing_list_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_mailing_list_member_i.mailing_list_member_key
        ,tmp_mailing_list_member_i.mailchimp_id
        ,tmp_mailing_list_member_i.email_address
        ,tmp_mailing_list_member_i.mailchimp_unique_email_id
        ,tmp_mailing_list_member_i.status
        ,tmp_mailing_list_member_i.fk_party_id
        ,tmp_mailing_list_member_i.avg_open_rate
        ,tmp_mailing_list_member_i.avg_click_rate
        ,tmp_mailing_list_member_i.ip_address_signup
        ,tmp_mailing_list_member_i.fk_date_id_signup_date
        ,tmp_mailing_list_member_i.timestamp_signup
        ,tmp_mailing_list_member_i.ip_address_opt_in
        ,tmp_mailing_list_member_i.fk_date_id_opt_in_date
        ,tmp_mailing_list_member_i.timestamp_opt_in
        ,tmp_mailing_list_member_i.fk_date_id_last_changed_date
        ,tmp_mailing_list_member_i.last_changed_timestamp
        ,tmp_mailing_list_member_i.email_client
        ,tmp_mailing_list_member_i.location_latitude
        ,tmp_mailing_list_member_i.location_longitude
        ,tmp_mailing_list_member_i.location_country_code
        ,tmp_mailing_list_member_i.fk_mailing_list_id
        ,tmp_mailing_list_member_i.tech_insert_function
        ,tmp_mailing_list_member_i.tech_insert_utc_timestamp
        ,tmp_mailing_list_member_i.tech_deleted_in_source_system
        ,tmp_mailing_list_member_i.tech_row_hash
        ,tmp_mailing_list_member_i.tech_data_load_utc_timestamp
        ,tmp_mailing_list_member_i.tech_data_load_uuid
    FROM tmp_mailing_list_member_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
