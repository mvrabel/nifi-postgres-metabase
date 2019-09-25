CREATE OR REPLACE FUNCTION core.tf_i_src_pipedrive_trg_deal_change_log_i()
RETURNS INTEGER 
AS $$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert data from stage 'pipedrive_*' tables into core input table deal_change_log_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-10-26 (YYYY-MM-DD)
    NOTE:
    ==============================================================================================
    */

DECLARE 

PIPEDRIVE_PREFIX TEXT := 'PIPEDRIVE_';
ORGANIZATION_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'ORGANIZATION_';
PERSON_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'PERSON_';
CONTACT_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'CONTACT_';
EMPLOYEE_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'EMPLOYEE_';
DEAL_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'DEAL_';
DEAL_CHANGE_KEY_PREFIX TEXT := PIPEDRIVE_PREFIX || 'DEAL_CHANGE_';
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

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.deal_change_log_i (
        deal_change_log_id
        ,deal_change_log_key
        ,field
        ,old_value
        ,new_value
        ,fk_deal_id
        ,fk_employee_id
        ,fk_date_id_log_date
        ,log_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    VALUES (
        -1 -- deal_change_log_id
        ,TEXT_NULL -- deal_change_log_key
        ,TEXT_NULL -- field
        ,TEXT_NULL -- old_value
        ,TEXT_NULL -- new_value
        ,-1 -- fk_deal_id
        ,-1 -- fk_employee_id
        ,-1 -- fk_date_id_log_date
        ,TIMESTAMP_NEVER -- log_timestamp
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,TEXT_NULL -- tech_row_hash
        ,-1 -- tech_data_load_utc_timestamp
        ,TEXT_NULL -- tech_data_load_uuid
    ) ON CONFLICT DO NOTHING;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_deal_change_log_i cascade;

    CREATE TEMPORARY TABLE tmp_deal_change_log_i (
        deal_change_log_key             TEXT NOT NULL,
        field                           TEXT NOT NULL,
        old_value                       TEXT NOT NULL,
        new_value                       TEXT NOT NULL,
        fk_deal_id                      INTEGER NOT NULL,
        fk_employee_id                  INTEGER NOT NULL,
        fk_date_id_log_date             INTEGER NOT NULL,
        log_timestamp                   TIMESTAMP WITH TIME ZONE NOT NULL,
        tech_insert_function            TEXT NOT NULL,
        tech_insert_utc_timestamp       BIGINT NOT NULL,
        tech_row_hash                   TEXT NOT NULL,
        tech_data_load_utc_timestamp    BIGINT NOT NULL,
        tech_data_load_uuid             TEXT NOT NULL,
        tech_deleted_in_source_system   BOOL NOT NULL
     );

    INSERT INTO tmp_deal_change_log_i (
        deal_change_log_key
        ,field
        ,old_value
        ,new_value
        ,fk_deal_id
        ,fk_employee_id
        ,fk_date_id_log_date
        ,log_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        DEAL_CHANGE_KEY_PREFIX || pipedrive_change_log.id AS deal_change_log_key
        ,pipedrive_change_log.field_key AS field
        ,COALESCE(pipedrive_change_log.additional_data_old_value_formatted, tf_u_replace_empty_string_with_null_flag(pipedrive_change_log.old_value)) AS old_value
        ,COALESCE(pipedrive_change_log.additional_data_new_value_formatted, tf_u_replace_empty_string_with_null_flag(pipedrive_change_log.new_value)) AS new_value        
        ,core_deal.deal_id AS fk_deal_id
        ,core_employee.employee_id AS fk_employee_id
        ,tf_u_convert_iso_8601_to_yyyymmdd_integer(pipedrive_change_log.timestamp) AS fk_date_id_log_date
        ,(pipedrive_change_log.timestamp || '+00')::TIMESTAMP WITH TIME ZONE AS log_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
            COALESCE(pipedrive_change_log.field_key::TEXT, '')
            || COALESCE(pipedrive_change_log.additional_data_old_value_formatted::TEXT, '')
            || COALESCE(pipedrive_change_log.old_value::TEXT, '')
            || COALESCE(pipedrive_change_log.additional_data_new_value_formatted::TEXT, '')
            || COALESCE(pipedrive_change_log.new_value::TEXT, '')
            || COALESCE(pipedrive_change_log.timestamp::TEXT, '')
        ) AS tech_row_hash
        ,pipedrive_change_log.tech_data_load_utc_timestamp
        ,pipedrive_change_log.tech_data_load_uuid
    FROM stage.pipedrive_deal_deal_change_i AS pipedrive_change_log
    LEFT JOIN core.deal_i AS core_deal ON core_deal.deal_key = DEAL_KEY_PREFIX || pipedrive_change_log.item_id
    LEFT JOIN core.employee_i AS core_employee ON core_employee.employee_key = EMPLOYEE_KEY_PREFIX || pipedrive_change_log.user_id;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.deal_change_log_i (
        deal_change_log_key
        ,field
        ,old_value
        ,new_value
        ,fk_deal_id
        ,fk_employee_id
        ,fk_date_id_log_date
        ,log_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT 
        tmp_deal_change_log_i.deal_change_log_key
        ,tmp_deal_change_log_i.field
        ,tmp_deal_change_log_i.old_value
        ,tmp_deal_change_log_i.new_value
        ,tmp_deal_change_log_i.fk_deal_id
        ,tmp_deal_change_log_i.fk_employee_id
        ,tmp_deal_change_log_i.fk_date_id_log_date
        ,tmp_deal_change_log_i.log_timestamp
        ,tmp_deal_change_log_i.tech_insert_function
        ,tmp_deal_change_log_i.tech_insert_utc_timestamp
        ,tmp_deal_change_log_i.tech_deleted_in_source_system
        ,tmp_deal_change_log_i.tech_row_hash
        ,tmp_deal_change_log_i.tech_data_load_utc_timestamp
        ,tmp_deal_change_log_i.tech_data_load_uuid
    FROM tmp_deal_change_log_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
