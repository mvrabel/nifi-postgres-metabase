CREATE OR REPLACE FUNCTION core.tf_t_organization_relation_t()

RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Insert data from core organization_relation_i input table into core 'today' table organization_relation_t
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =============================================================================================================
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

   INSERT INTO core.organization_relation_t (
        organization_relation_id
        ,organization_key
        ,organization_key_related_organization
        ,fk_organization_id
        ,fk_organization_id_related_organization
        ,related_organization_is
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
    )
    SELECT
        input_organization_relation.organization_relation_id
        ,input_organization_relation.organization_key
        ,input_organization_relation.organization_key_related_organization
        ,input_organization_relation.fk_organization_id
        ,input_organization_relation.fk_organization_id_related_organization
        ,input_organization_relation.related_organization_is
        ,input_organization_relation.tech_insert_function
        ,input_organization_relation.tech_insert_utc_timestamp
        ,input_organization_relation.tech_row_hash
        ,input_organization_relation.tech_data_load_utc_timestamp
        ,input_organization_relation.tech_data_load_uuid
    FROM core.organization_relation_i AS input_organization_relation
    LEFT JOIN core.organization_i AS input_organization ON input_organization_relation.fk_organization_id = input_organization.organization_id
        AND input_organization.tech_deleted_in_source_system IS FALSE
    LEFT JOIN core.organization_i AS input_organization_related_org ON input_organization_relation.fk_organization_id = input_organization_related_org.organization_id
        AND input_organization_related_org.tech_deleted_in_source_system IS FALSE
    WHERE input_organization_relation.tech_deleted_in_source_system IS FALSE;

    RETURN 0;

END;$$

LANGUAGE plpgsql
