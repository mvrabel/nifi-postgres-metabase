CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_comment_i()
RETURNS INTEGER AS $$

    /*
    =============================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table comment_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =============================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;

LEAD_CONTACT_FLAG TEXT := 'CONTACT';
LEAD_ORGANIZATION_FLAG TEXT:= 'ORGANIZATION';
ORGANIZATION_TABLE TEXT:= 'core.organization';
CONTACT_TABLE TEXT:= 'core.contact';
LOPP_TABLE TEXT:= 'core.lopp';
EMPLOYEE_TABLE TEXT:= 'core.employee';

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

    DROP TABLE IF EXISTS tmp_comment_i;

    CREATE TEMPORARY TABLE tmp_comment_i (
        comment_key                     TEXT NOT NULL
        ,comment_body                   TEXT
        ,table_name_comment_on      TEXT NOT NULL
        ,record_key_comment_on          TEXT NOT NULL
        ,table_name_commenter           TEXT NOT NULL
        ,record_key_commenter           TEXT NOT NULL
        ,created_timestamp              TIMESTAMP WITH TIME ZONE NOT NULL
        ,last_modified_timestamp        TIMESTAMP WITH TIME ZONE NOT NULL
        ,tech_insert_function           TEXT NOT NULL
        ,tech_insert_utc_timestamp      BIGINT NOT NULL
        ,tech_deleted_in_source_system  BOOL NOT NULL DEFAULT FALSE
        ,tech_row_hash                  TEXT NOT NULL
        ,tech_data_load_utc_timestamp   BIGINT NOT NULL
        ,tech_data_load_uuid            TEXT NOT NULL
    );

    INSERT INTO tmp_comment_i (
        comment_key
        ,comment_body
        ,table_name_comment_on
        ,record_key_comment_on
        ,table_name_commenter
        ,record_key_commenter
        ,created_timestamp
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    --vt_comment from Opportunities
    SELECT
        vt_comment.modcommentsid AS comment_key
        ,vt_comment.commentcontent AS comment_body
        ,LOPP_TABLE AS table_name_comment_on
        ,vt_potential.potential_no AS record_key_comment_on
        ,EMPLOYEE_TABLE AS table_name_commenter --becasue only employees can use CRM i can simplyfi this transform by simply put EMPLOYEE
        ,vt_user_created.user_name AS record_key_commenter
        ,vt_crmentity.createdtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_created.time_zone AS created_timestamp
        ,vt_crmentity.modifiedtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_modified.time_zone AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,vt_crmentity.deleted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(vt_comment.commentcontent, '')
        || vt_potential.potential_no
        || vt_crmentity.deleted::TEXT
        || LOPP_TABLE
        || EMPLOYEE_TABLE
        || vt_user_created.user_name
        || vt_user_modified.user_name
        ) AS tech_row_hash
        ,vt_comment.tech_data_load_utc_timestamp
        ,vt_comment.tech_data_load_uuid
    FROM stage.vtiger_modcomments_i AS vt_comment
    JOIN stage.vtiger_crmentity_i AS vt_crmentity ON vt_comment.modcommentsid = vt_crmentity.crmid
    JOIN stage.vtiger_users_i AS vt_user_created ON vt_user_created.id = vt_crmentity.smcreatorid
    JOIN stage.vtiger_users_i AS vt_user_modified ON vt_user_modified.id = vt_crmentity.modifiedby
    JOIN stage.vtiger_crmentity_i AS vt_crmentity_related_to_crm ON vt_comment.related_to = vt_crmentity_related_to_crm.crmid
    JOIN stage.vtiger_potential_i AS vt_potential ON vt_potential.potentialid = vt_crmentity_related_to_crm.crmid
    WHERE vt_crmentity_related_to_crm.setype = 'Potentials'

    UNION ALL

    --Comments from Leads on Lopps
    SELECT
        vt_comment.modcommentsid AS comment_key
        ,vt_comment.commentcontent AS comment_body
        ,LOPP_TABLE AS table_name_comment_on
        ,vt_lead.lead_no AS record_key_comment_on
        ,EMPLOYEE_TABLE AS table_name_commenter --becasue only employees can use CRM i can simplyfi this transform by simply put EMPLOYEE
        ,vt_user_created.user_name AS record_key_commenter
        ,vt_crmentity.createdtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_created.time_zone AS created_timestamp
        ,vt_crmentity.modifiedtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_modified.time_zone AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,vt_crmentity.deleted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(vt_comment.commentcontent, '')
        || vt_lead.lead_no
        || vt_crmentity.deleted::TEXT
        || LOPP_TABLE
        || EMPLOYEE_TABLE
        || vt_user_created.user_name
        || vt_user_modified.user_name
        ) AS tech_row_hash
        ,vt_comment.tech_data_load_utc_timestamp
        ,vt_comment.tech_data_load_uuid
    FROM stage.vtiger_modcomments_i AS vt_comment
    JOIN stage.vtiger_crmentity_i AS vt_crmentity ON vt_comment.modcommentsid = vt_crmentity.crmid
    JOIN stage.vtiger_users_i AS vt_user_created ON vt_user_created.id = vt_crmentity.smcreatorid
    JOIN stage.vtiger_users_i AS vt_user_modified ON vt_user_modified.id = vt_crmentity.modifiedby
    JOIN stage.vtiger_crmentity_i AS vt_crmentity_related_to_crm ON vt_comment.related_to = vt_crmentity_related_to_crm.crmid
    JOIN stage.vtiger_leaddetails_i AS vt_lead ON vt_lead.leadid = vt_crmentity_related_to_crm.crmid
    WHERE vt_crmentity_related_to_crm.setype = 'Leads'

    UNION ALL

    -- Comments from Leads to Organization
    -- NOTE: 'Comments from Leads to Organization' have the same JOINs AS 'Comments from Leads' because during ETL every single lead is split
    -- into an organization and into a contact
    SELECT
        vt_comment.modcommentsid AS comment_key
        ,vt_comment.commentcontent AS comment_body
        ,ORGANIZATION_TABLE AS table_name_comment_on
        ,vt_lead.lead_no || LEAD_ORGANIZATION_FLAG AS record_key_comment_on
        ,EMPLOYEE_TABLE AS table_name_commenter --becasue only employees can use CRM i can simplyfi this transform by simply put EMPLOYEE
        ,vt_user_created.user_name AS record_key_commenter
        ,vt_crmentity.createdtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_created.time_zone AS created_timestamp
        ,vt_crmentity.modifiedtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_modified.time_zone AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,vt_crmentity.deleted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(vt_comment.commentcontent, '')
        || vt_lead.lead_no
        || vt_crmentity.deleted::TEXT
        || ORGANIZATION_TABLE
        || EMPLOYEE_TABLE
        || vt_user_created.user_name
        || vt_user_modified.user_name
        ) AS tech_row_hash
        ,vt_comment.tech_data_load_utc_timestamp
        ,vt_comment.tech_data_load_uuid
    FROM stage.vtiger_modcomments_i AS vt_comment
    JOIN stage.vtiger_crmentity_i AS vt_crmentity ON vt_comment.modcommentsid = vt_crmentity.crmid
    JOIN stage.vtiger_users_i AS vt_user_created ON vt_user_created.id = vt_crmentity.smcreatorid
    JOIN stage.vtiger_users_i AS vt_user_modified ON vt_user_modified.id = vt_crmentity.modifiedby
    JOIN stage.vtiger_crmentity_i AS vt_crmentity_related_to_crm ON vt_comment.related_to = vt_crmentity_related_to_crm.crmid
    JOIN stage.vtiger_leaddetails_i AS vt_lead ON vt_lead.leadid = vt_crmentity_related_to_crm.crmid
    WHERE vt_crmentity_related_to_crm.setype = 'Leads'

    UNION ALL

    -- Comments from Leads to Contact
    -- NOTE: 'Comments from Leads to Contact' have the same JOINs AS 'Comments from Leads to Lopps' because during ETL every single lead is split
    -- into an organization and into a contact
    SELECT
        vt_comment.modcommentsid AS comment_key
        ,vt_comment.commentcontent AS comment_body
        ,CONTACT_TABLE AS table_name_comment_on
        ,vt_lead.lead_no || LEAD_CONTACT_FLAG AS record_key_comment_on
        ,EMPLOYEE_TABLE AS table_name_commenter --becasue only employees can use CRM i can simplyfi this transform by simply put EMPLOYEE
        ,vt_user_created.user_name AS record_key_commenter
        ,vt_crmentity.createdtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_created.time_zone AS created_timestamp
        ,vt_crmentity.modifiedtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_modified.time_zone AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,vt_crmentity.deleted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(vt_comment.commentcontent, '')
        || vt_lead.lead_no
        || vt_crmentity.deleted::TEXT
        || CONTACT_TABLE
        || EMPLOYEE_TABLE
        || vt_user_created.user_name
        || vt_user_modified.user_name
        ) AS tech_row_hash
        ,vt_comment.tech_data_load_utc_timestamp
        ,vt_comment.tech_data_load_uuid
    FROM stage.vtiger_modcomments_i AS vt_comment
    JOIN stage.vtiger_crmentity_i AS vt_crmentity ON vt_comment.modcommentsid = vt_crmentity.crmid
    JOIN stage.vtiger_users_i AS vt_user_created ON vt_user_created.id = vt_crmentity.smcreatorid
    JOIN stage.vtiger_users_i AS vt_user_modified ON vt_user_modified.id = vt_crmentity.modifiedby
    JOIN stage.vtiger_crmentity_i AS vt_crmentity_related_to_crm ON vt_comment.related_to = vt_crmentity_related_to_crm.crmid
    JOIN stage.vtiger_leaddetails_i AS vt_lead ON vt_lead.leadid = vt_crmentity_related_to_crm.crmid
    WHERE vt_crmentity_related_to_crm.setype = 'Leads'

    UNION ALL

    --Comments from Contact to Contact
    SELECT
        vt_comment.modcommentsid AS comment_key
        ,vt_comment.commentcontent AS comment_body
        ,CONTACT_TABLE AS table_name_comment_on
        ,vt_contact.contact_no AS record_key_comment_on
        ,EMPLOYEE_TABLE AS table_name_commenter --becasue only employees can use CRM i can simplyfi this transform by simply put EMPLOYEE
        ,vt_user_created.user_name AS record_key_commenter
        ,vt_crmentity.createdtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_created.time_zone AS created_timestamp
        ,vt_crmentity.modifiedtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_modified.time_zone AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,vt_crmentity.deleted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(vt_comment.commentcontent, '')
        || vt_contact.contact_no
        || vt_crmentity.deleted::TEXT
        || CONTACT_TABLE
        || EMPLOYEE_TABLE
        || vt_user_created.user_name
        || vt_user_modified.user_name
        ) AS tech_row_hash
        ,vt_comment.tech_data_load_utc_timestamp
        ,vt_comment.tech_data_load_uuid
    FROM stage.vtiger_modcomments_i AS vt_comment
    JOIN stage.vtiger_crmentity_i AS vt_crmentity ON vt_comment.modcommentsid = vt_crmentity.crmid
    JOIN stage.vtiger_users_i AS vt_user_created ON vt_user_created.id = vt_crmentity.smcreatorid
    JOIN stage.vtiger_users_i AS vt_user_modified ON vt_user_modified.id = vt_crmentity.modifiedby
    JOIN stage.vtiger_crmentity_i AS vt_crmentity_related_to_crm ON vt_comment.related_to = vt_crmentity_related_to_crm.crmid
    JOIN stage.vtiger_contactdetails_i AS vt_contact ON vt_contact.contactid = vt_crmentity_related_to_crm.crmid
    WHERE vt_crmentity_related_to_crm.setype = 'Contacts'

    UNION ALL

    --Comments from Account to Organization
    SELECT
        vt_comment.modcommentsid AS comment_key
        ,vt_comment.commentcontent AS comment_body
        ,ORGANIZATION_TABLE AS table_name_comment_on
        ,vt_account.account_no AS record_key_comment_on
        ,EMPLOYEE_TABLE AS table_name_commenter --becasue only employees can use CRM i can simplyfi this transform by simply put EMPLOYEE
        ,vt_user_created.user_name AS record_key_commenter
        ,vt_crmentity.createdtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_created.time_zone AS created_timestamp
        ,vt_crmentity.modifiedtime::TIMESTAMP WITH TIME ZONE AT TIME ZONE vt_user_modified.time_zone AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,vt_crmentity.deleted::bool AS tech_deleted_in_source_system
        ,md5(
        COALESCE(vt_comment.commentcontent, '')
        || vt_account.account_no
        || vt_crmentity.deleted::TEXT
        || ORGANIZATION_TABLE
        || EMPLOYEE_TABLE
        || vt_user_created.user_name
        || vt_user_modified.user_name
        ) AS tech_row_hash
        ,vt_comment.tech_data_load_utc_timestamp
        ,vt_comment.tech_data_load_uuid
    FROM stage.vtiger_modcomments_i AS vt_comment
    JOIN stage.vtiger_crmentity_i AS vt_crmentity ON vt_comment.modcommentsid = vt_crmentity.crmid
    JOIN stage.vtiger_users_i AS vt_user_created ON vt_user_created.id = vt_crmentity.smcreatorid
    JOIN stage.vtiger_users_i AS vt_user_modified ON vt_user_modified.id = vt_crmentity.modifiedby
    JOIN stage.vtiger_crmentity_i AS vt_crmentity_related_to_crm ON vt_comment.related_to = vt_crmentity_related_to_crm.crmid
    JOIN stage.vtiger_account_i AS vt_account ON vt_account.accountid = vt_crmentity_related_to_crm.crmid
    WHERE vt_crmentity_related_to_crm.setype = 'Accounts';

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.comment_i (
        comment_key
        ,comment_body
        ,table_name_comment_on
        ,record_key_comment_on
        ,table_name_commenter
        ,record_key_commenter
        ,created_timestamp
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_comment_i.comment_key
        ,tmp_comment_i.comment_body
        ,tmp_comment_i.table_name_comment_on
        ,tmp_comment_i.record_key_comment_on
        ,tmp_comment_i.table_name_commenter
        ,tmp_comment_i.record_key_commenter
        ,tmp_comment_i.created_timestamp
        ,tmp_comment_i.last_modified_timestamp
        ,tmp_comment_i.tech_insert_function
        ,tmp_comment_i.tech_insert_utc_timestamp
        ,tmp_comment_i.tech_deleted_in_source_system
        ,tmp_comment_i.tech_row_hash
        ,tmp_comment_i.tech_data_load_utc_timestamp
        ,tmp_comment_i.tech_data_load_uuid
    FROM tmp_comment_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
