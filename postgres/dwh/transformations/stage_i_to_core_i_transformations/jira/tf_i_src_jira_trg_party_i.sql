CREATE OR REPLACE FUNCTION core.tf_i_src_jira_trg_party_i()
RETURNS INTEGER AS $$

    /*
    ===========================================================================================================
    DESCRIPTION:        Insert data from stage 'jira_*' tables into core input table party_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
TIMESTAMP_NEVER TIMESTAMP WITH TIME ZONE := (SELECT timestamp_never FROM core.c_null_replacement_g);
TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);
JIRA_DELETED_USER_DISPLAY_NAME TEXT := 'Former user';
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

    INSERT INTO core.party_i (
        party_id
        ,party_key
        ,full_name
        ,short_name
        ,fk_employee_id_created_by
        ,fk_employee_id_last_modified_by
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_modified_date
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
        -1 -- party_id
        ,TEXT_NULL -- party_key
        ,TEXT_NULL -- full_name
        ,TEXT_NULL -- short_name
        ,-1 -- fk_employee_id_created_by
        ,-1 -- fk_employee_id_last_modified_by
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
        ,-1 -- fk_date_id_last_modified_date
        ,TIMESTAMP_NEVER -- last_modified_timestamp
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

    DROP TABLE IF EXISTS tmp_party_i;

    CREATE TEMPORARY TABLE tmp_party_i (
        party_key                           TEXT NOT NULL
        ,full_name                          TEXT
        ,short_name                         TEXT
        ,fk_employee_id_last_modified_by    INTEGER NOT NULL
        ,fk_employee_id_created_by          INTEGER NOT NULL
        ,fk_date_id_created_date            INTEGER NOT NULL
        ,created_timestamp                  TIMESTAMP WITH TIME ZONE NOT NULL
        ,fk_date_id_last_modified_date      INTEGER NOT NULL
        ,last_modified_timestamp            TIMESTAMP WITH TIME ZONE NOT NULL
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_deleted_in_source_system      BOOL NOT NULL
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
    );

    INSERT INTO tmp_party_i (
        party_key
        ,full_name
        ,short_name
        ,fk_employee_id_created_by
        ,fk_employee_id_last_modified_by
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_modified_date
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        jira_user.account_id AS party_key
        ,CASE
            WHEN jira_user.display_name IS NOT NULL AND jira_user.display_name = JIRA_DELETED_USER_DISPLAY_NAME THEN tf_u_replace_empty_string_with_null_flag(jira_user.name)
            ELSE tf_u_replace_empty_string_with_null_flag(jira_user.display_name)
        END AS full_name
        ,CASE
            WHEN jira_user.display_name IS NOT NULL AND jira_user.display_name = JIRA_DELETED_USER_DISPLAY_NAME THEN tf_u_replace_empty_string_with_null_flag(jira_user.name)
            ELSE tf_u_replace_empty_string_with_null_flag(jira_user.display_name)
        END AS short_name
        ,-1 AS fk_employee_id_created_by
        ,-1 AS fk_employee_id_last_modified_by
        ,-1 AS fk_date_id_created_date
        ,TIMESTAMP_NEVER AS created_timestamp
        ,-1 AS fk_date_id_last_modified_date
        ,TIMESTAMP_NEVER AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,FALSE AS tech_deleted_in_source_system
        ,md5(
        COALESCE(name ,'')
        ) AS tech_row_hash
        ,jira_user.tech_data_load_utc_timestamp
        ,jira_user.tech_data_load_uuid
    FROM stage.jira_user_i AS jira_user;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.party_i (
        party_key
        ,full_name
        ,short_name
        ,fk_employee_id_created_by
        ,fk_employee_id_last_modified_by
        ,fk_date_id_created_date
        ,created_timestamp
        ,fk_date_id_last_modified_date
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_party_i.party_key
        ,tmp_party_i.full_name
        ,tmp_party_i.short_name
        ,tmp_party_i.fk_employee_id_created_by
        ,tmp_party_i.fk_employee_id_last_modified_by
        ,tmp_party_i.fk_date_id_created_date
        ,tmp_party_i.created_timestamp
        ,tmp_party_i.fk_date_id_last_modified_date
        ,tmp_party_i.last_modified_timestamp
        ,tmp_party_i.tech_insert_function
        ,tmp_party_i.tech_insert_utc_timestamp
        ,tmp_party_i.tech_deleted_in_source_system
        ,tmp_party_i.tech_row_hash
        ,tmp_party_i.tech_data_load_utc_timestamp
        ,tmp_party_i.tech_data_load_uuid
    FROM tmp_party_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
