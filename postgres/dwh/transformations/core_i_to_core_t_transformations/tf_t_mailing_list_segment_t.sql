CREATE OR REPLACE FUNCTION core.tf_t_mailing_list_segment_t()

RETURNS INTEGER AS $$

    /*
    =================================================================================================================================
    DESCRIPTION:        Insert data from core mailing_list_segment_i input table into core 'today' table mailing_list_segment_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-21 (YYYY-MM-DD)
    NOTE:
    =================================================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    ----------------------------------------------------
    -- INSERT RECORDS FROM INPUT TABLE TO TODAY TABLE --
    ----------------------------------------------------

    INSERT INTO core.mailing_list_segment_t (
        mailing_list_segment_id
        ,mailing_list_segment_key
        ,segment_name
        ,mailchimp_id
        ,segment_type
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_updated_date
        ,last_updated_timestamp
        ,segment_filter_options
        ,fk_mailing_list_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_mailing_list_segment.mailing_list_segment_id
        ,input_mailing_list_segment.mailing_list_segment_key
        ,input_mailing_list_segment.segment_name
        ,input_mailing_list_segment.mailchimp_id
        ,input_mailing_list_segment.segment_type
        ,input_mailing_list_segment.fk_date_id_created_date
        ,input_mailing_list_segment.created_timestamp
        ,input_mailing_list_segment.fk_date_id_last_updated_date
        ,input_mailing_list_segment.last_updated_timestamp
        ,input_mailing_list_segment.segment_filter_options
        ,input_mailing_list_segment.fk_mailing_list_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,input_mailing_list_segment.tech_row_hash
        ,input_mailing_list_segment.tech_data_load_utc_timestamp
        ,input_mailing_list_segment.tech_data_load_uuid
    FROM core.mailing_list_segment_i AS input_mailing_list_segment
    WHERE input_mailing_list_segment.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
