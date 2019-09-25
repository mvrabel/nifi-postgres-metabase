CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_lopp_i()
RETURNS INTEGER AS $$

    /*
    =====================================================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table lopp_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =====================================================================================================================
    */

DECLARE

LEAD_CONTACT_FLAG TEXT := 'CONTACT';
LEAD_ORGANIZATION_FLAG TEXT:= 'ORGANIZATION';
CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
NULL_UTC_TIMESTAMP TIMESTAMP := to_timestamp(0)::TIMESTAMP AT TIME ZONE 'UTC';
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
    DROP TABLE IF EXISTS converted_leads;

    CREATE TEMPORARY TABLE converted_leads (
        modifiedby INTEGER NOT NULL
        -- Timestap without time zone is used because of BI-190. Time Data in Vtiger is stored as Datetime.
        -- This means no timezone info.
        ,createdtime TIMESTAMP NOT NULL
        ,modifiedtime TIMESTAMP NOT NULL
        ,first_contact_date_manual DATE
    );

    INSERT INTO converted_leads (
        modifiedby
        ,createdtime
        ,modifiedtime
        ,first_contact_date_manual
    )
    SELECT
        crm.modifiedby
        ,crm.createdtime::TIMESTAMP AS createdtime
        ,crm.modifiedtime::TIMESTAMP AS modifiedtime
        ,lead_custom_field.cf_797::DATE AS first_contact_date_manual
    FROM stage.vtiger_leaddetails_i lead
    JOIN stage.vtiger_crmentity_i AS crm ON crm.crmid = lead.leadid
    JOIN stage.vtiger_leadscf_i AS lead_custom_field ON lead_custom_field.leadid = lead.leadid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm.modifiedby
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm.smcreatorid
    WHERE lead.converted = 1;

    ----------------------------------------------------
    -- CRMID - POTENTIAL_NO TEMPORARY HELPER TABLE --
    ----------------------------------------------------

    DROP TABLE IF EXISTS term_extention_potential_id_key_map;

    CREATE TEMPORARY TABLE term_extention_potential_id_key_map(
        potentialid INTEGER NOT NULL
        ,potential_no TEXT NOT NULL
        ,term_extention_of_potentialid TEXT NOT NULL
        ,term_extention_of_potential_no TEXT NOT NULL
    );

    INSERT INTO term_extention_potential_id_key_map(
        potentialid
        ,potential_no
        ,term_extention_of_potentialid
        ,term_extention_of_potential_no
    )
    WITH foo AS (
        SELECT
            potential.potentialid
            ,potential.potential_no
            ,tf_u_convert_text_to_integer(((regexp_matches(potential_custom_field.cf_876, '[0-9]*$'))[1])::text) AS term_extention_of_potentialid
        FROM stage.vtiger_potential_i AS potential
        JOIN stage.vtiger_potentialscf_i AS potential_custom_field ON potential.potentialid = potential_custom_field.potentialid
        WHERE potential_custom_field.cf_876 <> ''
    )
    SELECT
         foo.potentialid
        ,foo.potential_no
        ,foo.term_extention_of_potentialid
        ,vt_term_extention_potential.potential_no AS term_extention_of_potential_no
    FROM foo
    JOIN stage.vtiger_potential_i AS vt_term_extention_potential ON vt_term_extention_potential.potentialid = foo.term_extention_of_potentialid;

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_lopp_i;

    CREATE TEMPORARY TABLE tmp_lopp_i (
        lopp_key                                    TEXT NOT NULL
        ,crm_id                                     INTEGER
        ,jira_issue_key                             TEXT
        ,subject                                    TEXT NOT NULL
        ,relationship_type                          TEXT
        ,category                                   TEXT
        ,description                                TEXT
        ,STATUS                                     TEXT NOT NULL
        ,lead_source                                TEXT NOT NULL
        ,lead_source_detail                         TEXT
        ,budget                                     TEXT
        ,cost_of_sales                              TEXT
        ,amount                                     BIGINT
        ,reason_lost                                TEXT
        ,resulting_state                            TEXT
        ,fk_contact_id_main_contact                 INTEGER NOT NULL
        ,probability                                INTEGER
        ,fk_date_id_inception_date                  INTEGER NOT NULL
        ,inception_timestamp                        TIMESTAMP WITH TIME ZONE NOT NULL
        ,next_step                                  TEXT
        ,fk_date_id_next_step_date                  INTEGER NOT NULL
        ,fk_date_id_last_action_date_manual_entry   INTEGER NOT NULL
        ,fk_date_id_close_date                      INTEGER NOT NULL
        ,term_extention_of_lopp_key                 TEXT
        ,reselling_partner                          TEXT
        ,reselling_partner_note                     TEXT
        ,referring_partner                          TEXT
        ,referring_partner_note                     TEXT
        ,identified_by_partner                      TEXT
        ,identified_by_partner_note                 TEXT
        ,qualified_by_partner                       TEXT
        ,qualified_by_partner_note                  TEXT
        ,proof_of_concept_by_partner                TEXT
        ,proof_of_concept_by_partner_note           TEXT
        ,closed_by_partner                          TEXT
        ,closed_by_partner_note                     TEXT
        ,resold_by_partner                          TEXT
        ,resold_by_partner_note                     TEXT
        ,owned_by_partner                           TEXT
        ,owned_by_partner_note                      TEXT
        ,fk_organization_id                         INTEGER NOT NULL
        ,presales_thread                            TEXT
        ,sales_thread                               TEXT
        ,postsales_thread                           TEXT
        ,case_study                                 TEXT
        ,fk_employee_id_assigned_to                 INTEGER NOT NULL
        ,fk_employee_id_created_by                  INTEGER NOT NULL
        ,fk_employee_id_last_modified_by            INTEGER NOT NULL
        ,last_modified_timestamp                    TIMESTAMP WITH TIME ZONE NOT NULL
        ,tech_insert_function                       TEXT NOT NULL
        ,tech_insert_utc_timestamp                  BIGINT NOT NULL
        ,tech_deleted_in_source_system              BOOL NOT NULL
        ,tech_row_hash                              TEXT NOT NULL
        ,tech_data_load_utc_timestamp               BIGINT NOT NULL
        ,tech_data_load_uuid                        TEXT NOT NULL
     );

    INSERT INTO tmp_lopp_i (
        lopp_key
        ,crm_id
        ,jira_issue_key
        ,subject
        ,relationship_type
        ,category
        ,description
        ,status
        ,lead_source
        ,lead_source_detail
        ,budget
        ,cost_of_sales
        ,amount
        ,reason_lost
        ,resulting_state
        ,fk_contact_id_main_contact
        ,probability
        ,fk_date_id_inception_date
        ,inception_timestamp
        ,next_step
        ,fk_date_id_next_step_date
        ,fk_date_id_last_action_date_manual_entry
        ,fk_date_id_close_date
        ,term_extention_of_lopp_key
        ,reselling_partner
        ,reselling_partner_note
        ,referring_partner
        ,referring_partner_note
        ,identified_by_partner
        ,identified_by_partner_note
        ,qualified_by_partner
        ,qualified_by_partner_note
        ,proof_of_concept_by_partner
        ,proof_of_concept_by_partner_note
        ,closed_by_partner
        ,closed_by_partner_note
        ,resold_by_partner
        ,resold_by_partner_note
        ,owned_by_partner
        ,owned_by_partner_note
        ,fk_organization_id
        ,presales_thread
        ,sales_thread
        ,postsales_thread
        ,case_study
        ,fk_employee_id_assigned_to
        ,fk_employee_id_created_by
        ,fk_employee_id_last_modified_by
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    --From leads
    SELECT
        lead.lead_no AS lopp_key
        ,crm_entity.crmid AS crm_id
        ,lead_custom_field.cf_892 AS jira_issue_key
        ,lead_custom_field.cf_857 AS subject
        ,lead_custom_field.cf_799 AS relationship_type
        ,NULL::text AS category
        ,crm_entity.description
        ,lead.leadstatus AS status -- CASE WHEN (leadstatus IS NULL OR leadstatus = '') THEN undetermined_status END AS STATUS
        ,lead.leadsource AS lead_source
        ,lead_custom_field.cf_791 AS lead_source_detail
        ,NULL::TEXT AS budget
        ,NULL::text AS cost_of_sales
        ,NULL AS amount
        ,lead_custom_field.cf_920 AS reason_lost
        ,lead_custom_field.cf_922 AS resulting_state
        ,CASE
            WHEN contact.contact_id IS NULL THEN -1
            ELSE contact.contact_id
        END AS fk_contact_id_main_contact
        ,NULL AS probability -- LEAD_HAS_NO_PROBABILITY
        ,LEAST(
        to_char((crm_entity.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE, 'YYYYMMDD')::INTEGER
        ,to_char(lead_custom_field.cf_797::DATE, 'YYYYMMDD')::INTEGER
        ) AS fk_date_id_inception_date
        ,LEAST(
        (crm_entity.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE
        ,(lead_custom_field.cf_797 || ' ' || 'UTC')::TIMESTAMP WITH TIME ZONE --I added UTC time zone because
        -- the result has to be a timestamp with time zone. A it's better to speficy (not precise)atrificial timezone than rely on default
        ) AS inception_timestamp
        ,lead_custom_field.cf_777 AS next_step
        ,CASE
            WHEN lead_custom_field.cf_884 = '' OR lead_custom_field.cf_884 IS NULL THEN -1
            ELSE to_char(lead_custom_field.cf_884::DATE, 'YYYYMMDD')::INTEGER
        END AS fk_date_id_next_step_date
        ,CASE
            WHEN lead_custom_field.cf_775 = '' OR lead_custom_field.cf_775 IS NULL THEN -1
            ELSE to_char(lead_custom_field.cf_775::DATE, 'YYYYMMDD')::INTEGER
        END AS fk_date_id_last_action_date_manual_entry
        ,-1 AS fk_date_id_close_date
        ,NULL AS term_extention_of_lopp_key -- LEADS DONT EXTEND OTHER LEADS
        ,NULL::text AS reselling_partner
        ,NULL::text AS reselling_partner_note
        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_757) != 0
                THEN SUBSTRING(lead_custom_field.cf_757 FROM 0 FOR position(' - ' IN lead_custom_field.cf_757))
            ELSE lead_custom_field.cf_757
        END AS referring_partner
        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_757) != 0
                THEN SUBSTRING(lead_custom_field.cf_757 FROM position(' - ' IN lead_custom_field.cf_757) + 3)
            ELSE NULL
        END AS referring_partner_note

        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_894) != 0
                THEN SUBSTRING(lead_custom_field.cf_894 FROM 0 FOR position(' - ' IN lead_custom_field.cf_894))
            ELSE lead_custom_field.cf_894
        END AS identified_by_partner
        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_894) != 0
                THEN SUBSTRING(lead_custom_field.cf_894 FROM position(' - ' IN lead_custom_field.cf_894) + 3)
            ELSE NULL
        END AS identified_by_partner_note

        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_896) != 0
                THEN SUBSTRING(lead_custom_field.cf_896 FROM 0 FOR position(' - ' IN lead_custom_field.cf_896))
            ELSE lead_custom_field.cf_896
        END AS qualified_by_partner
        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_896) != 0
                THEN SUBSTRING(lead_custom_field.cf_896 FROM position(' - ' IN lead_custom_field.cf_896) + 3)
            ELSE NULL
        END AS qualified_by_partner_note
        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_898) != 0
                THEN SUBSTRING(lead_custom_field.cf_898 FROM 0 FOR position(' - ' IN lead_custom_field.cf_898))
            ELSE lead_custom_field.cf_898
        END AS proof_of_concept_by_partner
        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_898) != 0
                THEN SUBSTRING(lead_custom_field.cf_898 FROM position(' - ' IN lead_custom_field.cf_898) + 3)
            ELSE NULL
        END AS proof_of_concept_by_partner_note

        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_900) != 0
                THEN SUBSTRING(lead_custom_field.cf_900 FROM 0 FOR position(' - ' IN lead_custom_field.cf_900))
            ELSE lead_custom_field.cf_900
        END AS closed_by_partner
        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_900) != 0
                THEN SUBSTRING(lead_custom_field.cf_900 FROM position(' - ' IN lead_custom_field.cf_900) + 3)
            ELSE NULL
        END AS closed_by_partner_note

        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_902) != 0
                THEN SUBSTRING(lead_custom_field.cf_902 FROM 0 FOR position(' - ' IN lead_custom_field.cf_902))
            ELSE lead_custom_field.cf_902
        END AS resold_by_partner
        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_902) != 0
                THEN SUBSTRING(lead_custom_field.cf_902 FROM position(' - ' IN lead_custom_field.cf_902) + 3)
            ELSE NULL
        END AS resold_by_partner_note
        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_904) != 0
                THEN SUBSTRING(lead_custom_field.cf_904 FROM 0 FOR position(' - ' IN lead_custom_field.cf_904))
            ELSE lead_custom_field.cf_904
        END AS owned_by_partner
        ,CASE
            WHEN position(' - ' IN lead_custom_field.cf_904) != 0
                THEN SUBSTRING(lead_custom_field.cf_904 FROM position(' - ' IN lead_custom_field.cf_904) + 3)
            ELSE NULL
        END AS owned_by_partner_note
        ,CASE
            WHEN organization.organization_id IS NULL THEN -1
            ELSE organization.organization_id
        END AS fk_organization_id
        ,lead_custom_field.cf_845 AS presales_thread
        ,lead_custom_field.cf_847 AS sales_thread
        ,NULL::text AS postsales_thread
        ,NULL::text AS case_study
        ,employee_assigned.employee_id AS fk_employee_id_assigned_to
        ,employee_created.employee_id AS fk_employee_id_created_by
        ,employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,(crm_entity.modifiedtime || ' ' || user_modified.time_zone)::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm_entity.deleted::bool OR lead.converted::bool AS tech_deleted_in_source_system
        ,md5(
           COALESCE(lead_custom_field.cf_892, '')
        || COALESCE(lead_custom_field.cf_857, '')
        || COALESCE(lead_custom_field.cf_799, '')
        || COALESCE(crm_entity.description, '')
        || COALESCE(lead.leadstatus, '')
        || COALESCE(lead.leadsource, '')
        || COALESCE(lead_custom_field.cf_920, '')
        || COALESCE(lead_custom_field.cf_922, '')
        || COALESCE(lead_custom_field.cf_791, '')
        || COALESCE(lead_custom_field.cf_797, '')
        || COALESCE(contact.contact_key, '')
        || COALESCE(lead_custom_field.cf_777, '')
        || COALESCE(lead_custom_field.cf_884, '')
        || COALESCE(lead_custom_field.cf_757, '')
        || COALESCE(lead_custom_field.cf_775, '')
        || COALESCE(organization.organization_key, '')
        || COALESCE(lead_custom_field.cf_845, '')
        || COALESCE(lead_custom_field.cf_847, '')
        || COALESCE(lead_custom_field.cf_894, '')
        || COALESCE(lead_custom_field.cf_896, '')
        || COALESCE(lead_custom_field.cf_898, '')
        || COALESCE(lead_custom_field.cf_900, '')
        || COALESCE(lead_custom_field.cf_902, '')
        || COALESCE(lead_custom_field.cf_904, '')
        || employee_assigned.employee_key
        || crm_entity.modifiedtime
        || crm_entity.deleted
        || lead.converted::bool
        ) AS tech_row_hash
        ,lead.tech_data_load_utc_timestamp
        ,lead.tech_data_load_uuid
    FROM stage.vtiger_leaddetails_i AS lead
    JOIN stage.vtiger_leadscf_i AS lead_custom_field ON lead.leadid = lead_custom_field.leadid
    JOIN stage.vtiger_crmentity_i AS crm_entity ON crm_entity.crmid = lead.leadid
    JOIN stage.vtiger_users_i AS user_assigned ON user_assigned.id = crm_entity.smownerid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm_entity.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm_entity.modifiedby
    JOIN core.employee_i AS employee_assigned ON employee_assigned.employee_key = user_assigned.user_name
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name
    LEFT JOIN core.organization_i AS organization ON organization.organization_key = lead.lead_no || LEAD_ORGANIZATION_FLAG
    LEFT JOIN core.contact_i AS contact ON contact.contact_key = lead.lead_no || LEAD_CONTACT_FLAG

    UNION
    --From potentials
    SELECT
        potential.potential_no AS lopp_key
        ,crm_entity.crmid AS crm_id
        ,potential_custom_field.cf_890 AS jira_issue_key
        ,potential.potentialname AS subject
        ,potential.potentialtype AS relationship_type
        ,potential_custom_field.cf_874 AS category
        ,crm_entity.description
        ,potential.sales_stage AS status
        ,potential.leadsource AS lead_source
        ,potential_custom_field.cf_789 AS lead_source_detail
        ,potential_custom_field.cf_870 AS budget
        ,NULL::text AS cost_of_sales
        ,COALESCE(potential.amount::BIGINT, 0) AS amount
        ,potential_custom_field.cf_809 AS reason_lost
        ,potential_custom_field.cf_918 AS resulting_state
        ,CASE WHEN contact.contact_id IS NULL THEN -1
            ELSE contact.contact_id
        END AS fk_contact_id_main_contact
        ,potential.probability AS probability
        ,LEAST(
        to_char((crm_entity.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE, 'YYYYMMDD')::INTEGER
        ,to_char(potential_custom_field.cf_765::DATE, 'YYYYMMDD')::INTEGER
        ,to_char(converted_leads.createdtime, 'YYYYMMDD')::INTEGER
        ,to_char(converted_leads.first_contact_date_manual::DATE, 'YYYYMMDD')::INTEGER
        ) AS fk_date_id_inception_date
        ,LEAST(
        (crm_entity.createdtime || ' ' || user_created.time_zone)::TIMESTAMP WITH TIME ZONE
        ,(potential_custom_field.cf_765 || ' ' || 'UTC')::TIMESTAMP WITH TIME ZONE
        ,(converted_leads.createdtime || ' ' || 'UTC')::TIMESTAMP WITH TIME ZONE
        ,(converted_leads.first_contact_date_manual || ' ' || 'UTC')::TIMESTAMP WITH TIME ZONE
        ) AS inception_timestamp
        ,potential.nextstep AS next_step
        ,CASE
            WHEN cf_882 = '' OR cf_882 IS NULL THEN -1
            ELSE replace(cf_882,'-','')::INTEGER
        END AS fk_date_id_next_step_date
        ,CASE
            WHEN cf_769 = '' OR cf_769 IS NULL THEN -1
            ELSE replace(cf_769,'-','')::INTEGER
        END AS fk_date_id_last_action_date_manual_entry
        ,CASE
            WHEN potential.closingdate IS NULL THEN -1
            ELSE replace(potential.closingdate,'-','')::integer
        END AS fk_date_id_close_date
        ,term_extention_potential_id_key_map.term_extention_of_potential_no AS term_extention_of_lopp_key
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_761) != 0
                THEN SUBSTRING(potential_custom_field.cf_761 FROM 0 FOR position(' - ' IN potential_custom_field.cf_761))
            ELSE potential_custom_field.cf_761
        END AS reselling_partner
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_761) != 0
                THEN SUBSTRING(potential_custom_field.cf_761 FROM position(' - ' IN potential_custom_field.cf_761) + 3)
            ELSE NULL
        END AS reselling_partner_note
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_759) != 0
                THEN SUBSTRING(potential_custom_field.cf_759 FROM 0 FOR position(' - ' IN potential_custom_field.cf_759))
            ELSE potential_custom_field.cf_759
        END AS referring_partner
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_759) != 0
                THEN SUBSTRING(potential_custom_field.cf_759 FROM position(' - ' IN potential_custom_field.cf_759) + 3)
            ELSE NULL
        END AS referring_partner_note
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_906) != 0
                THEN SUBSTRING(potential_custom_field.cf_906 FROM 0 FOR position(' - ' IN potential_custom_field.cf_906))
            ELSE potential_custom_field.cf_906
        END AS identified_by_partner
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_906) != 0
                THEN SUBSTRING(potential_custom_field.cf_906 FROM position(' - ' IN potential_custom_field.cf_906) + 3)
            ELSE NULL
        END AS identified_by_partner_note

        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_908) != 0
                THEN SUBSTRING(potential_custom_field.cf_908 FROM 0 FOR position(' - ' IN potential_custom_field.cf_908))
            ELSE potential_custom_field.cf_908
        END AS qualified_by_partner
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_908) != 0
                THEN SUBSTRING(potential_custom_field.cf_908 FROM position(' - ' IN potential_custom_field.cf_908) + 3)
            ELSE NULL
        END AS qualified_by_partner_note

        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_910) != 0
                THEN SUBSTRING(potential_custom_field.cf_910 FROM 0 FOR position(' - ' IN potential_custom_field.cf_910))
            ELSE potential_custom_field.cf_910
        END AS proof_of_concept_by_partner
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_910) != 0
                THEN SUBSTRING(potential_custom_field.cf_910 FROM position(' - ' IN potential_custom_field.cf_910) + 3)
            ELSE NULL
        END AS proof_of_concept_by_partner_note
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_912) != 0
                THEN SUBSTRING(potential_custom_field.cf_912 FROM 0 FOR position(' - ' IN potential_custom_field.cf_912))
            ELSE potential_custom_field.cf_912
        END AS closed_by_partner
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_912) != 0
                THEN SUBSTRING(potential_custom_field.cf_912 FROM position(' - ' IN potential_custom_field.cf_912) + 3)
            ELSE NULL
        END AS closed_by_partner_note
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_914) != 0
                THEN SUBSTRING(potential_custom_field.cf_914 FROM 0 FOR position(' - ' IN potential_custom_field.cf_914))
            ELSE potential_custom_field.cf_914
        END AS resold_by_partner
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_914) != 0
                THEN SUBSTRING(potential_custom_field.cf_914 FROM position(' - ' IN potential_custom_field.cf_914) + 3)
            ELSE NULL
        END AS resold_by_partner_note
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_916) != 0
                THEN SUBSTRING(potential_custom_field.cf_916 FROM 0 FOR position(' - ' IN potential_custom_field.cf_916))
            ELSE potential_custom_field.cf_916
        END AS owned_by_partner
        ,CASE
            WHEN position(' - ' IN potential_custom_field.cf_916) != 0
                THEN SUBSTRING(potential_custom_field.cf_916 FROM position(' - ' IN potential_custom_field.cf_916) + 3)
            ELSE NULL
        END AS owned_by_partner_note
        ,CASE WHEN organization.organization_id IS NULL THEN -1
            ELSE organization.organization_id
        END AS fk_organization_id
        ,potential_custom_field.cf_833 AS presales_thread
        ,potential_custom_field.cf_831 AS sales_thread
        ,potential_custom_field.cf_872 AS postsales_thread
        ,potential_custom_field.cf_880 AS case_study
        ,employee_assigned.employee_id AS fk_employee_id_assigned_to
        ,employee_created.employee_id AS fk_employee_id_created_by
        ,employee_modified.employee_id AS fk_employee_id_last_modified_by
        ,(crm_entity.modifiedtime || ' ' || user_modified.time_zone)::TIMESTAMP WITH TIME ZONE AS last_modified_timestamp
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,crm_entity.deleted::bool AS tech_deleted_in_source_system
        ,md5(
           COALESCE(potential_custom_field.cf_890, '')
        || COALESCE(potential.potentialname, '')
        || COALESCE(potential.potentialtype, '')
        || COALESCE(potential_custom_field.cf_874, '')
        || COALESCE(crm_entity.description, '')
        || COALESCE(potential.sales_stage, '')
        || COALESCE(potential.leadsource, '')
        || COALESCE(potential_custom_field.cf_789, '')
        || COALESCE(potential_custom_field.cf_870, '')
        || COALESCE(potential.amount, 0)
        || COALESCE(potential_custom_field.cf_809, '')
        || COALESCE(potential_custom_field.cf_918, '')
        || COALESCE(contact.contact_key, '')
        || COALESCE(potential.probability, 0)
        || COALESCE(potential.nextstep, '')
        || COALESCE(potential_custom_field.cf_882, '')
        || COALESCE(potential.closingdate, '')
        || COALESCE(potential_custom_field.cf_765, '')
        || COALESCE(potential_custom_field.cf_876, '')
        || COALESCE(potential_custom_field.cf_761, '')
        || COALESCE(potential_custom_field.cf_759, '')
        || COALESCE(potential_custom_field.cf_769, '')
        || COALESCE(organization.organization_key, '')
        || COALESCE(potential_custom_field.cf_833, '')
        || COALESCE(potential_custom_field.cf_831, '')
        || COALESCE(potential_custom_field.cf_872, '')
        || COALESCE(potential_custom_field.cf_880, '')
        || COALESCE(potential_custom_field.cf_906, '')
        || COALESCE(potential_custom_field.cf_908, '')
        || COALESCE(potential_custom_field.cf_910, '')
        || COALESCE(potential_custom_field.cf_912, '')
        || COALESCE(potential_custom_field.cf_914, '')
        || COALESCE(potential_custom_field.cf_916, '')
        || employee_assigned.employee_key
        || crm_entity.deleted
        ) AS tech_row_hash
        ,potential.tech_data_load_utc_timestamp
        ,potential.tech_data_load_uuid
    FROM stage.vtiger_potential_i AS potential
    JOIN stage.vtiger_potentialscf_i AS potential_custom_field ON potential.potentialid = potential_custom_field.potentialid
    JOIN stage.vtiger_crmentity_i AS crm_entity ON crm_entity.crmid = potential.potentialid
    LEFT JOIN term_extention_potential_id_key_map ON term_extention_potential_id_key_map.potentialid = potential.potentialid
    JOIN stage.vtiger_users_i AS user_assigned ON user_assigned.id = crm_entity.smownerid
    JOIN stage.vtiger_users_i AS user_created ON user_created.id = crm_entity.smcreatorid
    JOIN stage.vtiger_users_i AS user_modified ON user_modified.id = crm_entity.modifiedby
    JOIN core.employee_i AS employee_assigned ON employee_assigned.employee_key = user_assigned.user_name
    JOIN core.employee_i AS employee_created ON employee_created.employee_key = user_created.user_name
    JOIN core.employee_i AS employee_modified ON employee_modified.employee_key = user_modified.user_name
    LEFT JOIN core.contact_i AS contact ON contact.crm_id = potential.contact_id
    LEFT JOIN core.organization_i AS organization ON organization.crm_id = potential.related_to
    LEFT JOIN converted_leads as converted_leads ON potential.isconvertedfromlead = '1'
        AND crm_entity.smcreatorid = converted_leads.modifiedby
        AND (
            crm_entity.createdtime::TIMESTAMP = converted_leads.modifiedtime
            OR crm_entity.createdtime::TIMESTAMP + INTERVAL '1 second' = converted_leads.modifiedtime
            );

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.lopp_i (
        lopp_key
        ,crm_id
        ,jira_issue_key
        ,subject
        ,relationship_type
        ,category
        ,description
        ,STATUS
        ,lead_source
        ,lead_source_detail
        ,budget
        ,cost_of_sales
        ,amount
        ,reason_lost
        ,resulting_state
        ,fk_contact_id_main_contact
        ,probability
        ,fk_date_id_inception_date
        ,inception_timestamp
        ,next_step
        ,fk_date_id_next_step_date
        ,fk_date_id_last_action_date_manual_entry
        ,fk_date_id_close_date
        ,term_extention_of_lopp_key
        ,reselling_partner
        ,reselling_partner_note
        ,referring_partner
        ,referring_partner_note
        ,identified_by_partner
        ,identified_by_partner_note
        ,qualified_by_partner
        ,qualified_by_partner_note
        ,proof_of_concept_by_partner
        ,proof_of_concept_by_partner_note
        ,closed_by_partner
        ,closed_by_partner_note
        ,resold_by_partner
        ,resold_by_partner_note
        ,owned_by_partner
        ,owned_by_partner_note
        ,fk_organization_id
        ,presales_thread
        ,sales_thread
        ,postsales_thread
        ,case_study
        ,fk_employee_id_assigned_to
        ,fk_employee_id_created_by
        ,fk_employee_id_last_modified_by
        ,last_modified_timestamp
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
         tmp_lopp_i.lopp_key
        ,tmp_lopp_i.crm_id
        ,tmp_lopp_i.jira_issue_key
        ,tmp_lopp_i.subject
        ,tmp_lopp_i.relationship_type
        ,tmp_lopp_i.category
        ,tmp_lopp_i.description
        ,tmp_lopp_i.STATUS
        ,tmp_lopp_i.lead_source
        ,tmp_lopp_i.lead_source_detail
        ,tmp_lopp_i.budget
        ,tmp_lopp_i.cost_of_sales
        ,tmp_lopp_i.amount
        ,tmp_lopp_i.reason_lost
        ,tmp_lopp_i.resulting_state
        ,tmp_lopp_i.fk_contact_id_main_contact
        ,tmp_lopp_i.probability
        ,tmp_lopp_i.fk_date_id_inception_date
        ,tmp_lopp_i.inception_timestamp
        ,tmp_lopp_i.next_step
        ,tmp_lopp_i.fk_date_id_next_step_date
        ,tmp_lopp_i.fk_date_id_last_action_date_manual_entry
        ,tmp_lopp_i.fk_date_id_close_date
        ,tmp_lopp_i.term_extention_of_lopp_key
        ,tmp_lopp_i.reselling_partner
        ,tmp_lopp_i.reselling_partner_note
        ,tmp_lopp_i.referring_partner
        ,tmp_lopp_i.referring_partner_note
        ,tmp_lopp_i.identified_by_partner
        ,tmp_lopp_i.identified_by_partner_note
        ,tmp_lopp_i.qualified_by_partner
        ,tmp_lopp_i.qualified_by_partner_note
        ,tmp_lopp_i.proof_of_concept_by_partner
        ,tmp_lopp_i.proof_of_concept_by_partner_note
        ,tmp_lopp_i.closed_by_partner
        ,tmp_lopp_i.closed_by_partner_note
        ,tmp_lopp_i.resold_by_partner
        ,tmp_lopp_i.resold_by_partner_note
        ,tmp_lopp_i.owned_by_partner
        ,tmp_lopp_i.owned_by_partner_note
        ,tmp_lopp_i.fk_organization_id
        ,tmp_lopp_i.presales_thread
        ,tmp_lopp_i.sales_thread
        ,tmp_lopp_i.postsales_thread
        ,tmp_lopp_i.case_study
        ,tmp_lopp_i.fk_employee_id_assigned_to
        ,tmp_lopp_i.fk_employee_id_created_by
        ,tmp_lopp_i.fk_employee_id_last_modified_by
        ,tmp_lopp_i.last_modified_timestamp
        ,tmp_lopp_i.tech_insert_function
        ,tmp_lopp_i.tech_insert_utc_timestamp
        ,tmp_lopp_i.tech_deleted_in_source_system
        ,tmp_lopp_i.tech_row_hash
        ,tmp_lopp_i.tech_data_load_utc_timestamp
        ,tmp_lopp_i.tech_data_load_uuid
    FROM tmp_lopp_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
