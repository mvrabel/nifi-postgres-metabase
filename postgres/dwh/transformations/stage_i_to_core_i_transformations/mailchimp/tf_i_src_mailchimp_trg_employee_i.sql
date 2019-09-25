CREATE OR REPLACE FUNCTION core.tf_i_src_mailchimp_trg_employee_i()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$

    /*
    ==============================================================================================
    DESCRIPTION:        Insert Null Employee, if not already in DWH
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:               There are 2 reasons why I included this transformation
                        1. Null employee (with id -1) is needed for transformation into 'mailchimp' party.
                        2. To keep all mailchimp transformations independent from other transformations, like JIRA or Vtiger CRM
    ==============================================================================================
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

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.employee_i (
        employee_id
        ,employee_key
        ,full_name
        ,email
        ,secondary_email
        ,phone
        ,mobile_phone
        ,fk_date_id_created_date
        ,created_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
        -1 -- employee_id
        ,TEXT_NULL -- employee_key
        ,TEXT_NULL-- full_name
        ,TEXT_NULL -- email
        ,TEXT_NULL -- secondary_email
        ,TEXT_NULL -- phone
        ,TEXT_NULL -- mobile_phone
        ,-1 -- fk_date_id_created_date
        ,TIMESTAMP_NEVER -- created_timestamp
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,FALSE -- tech_deleted_in_source_system
        ,TEXT_NULL -- tech_row_hash
        ,-1 -- tech_data_load_utc_timestamp
        ,TEXT_NULL -- tech_data_load_uuid
    ) ON CONFLICT DO NOTHING;

    RETURN 0;

END;$function$
