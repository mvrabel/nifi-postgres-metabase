CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_lopp_contact_map_i()
RETURNS INTEGER AS $$

    /*
    =====================================================================================================================
    DESCRIPTION:        Insert data from stage 'vtiger_*' tables into core input table lopp__contact_map_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-14 (YYYY-MM-DD)
    NOTE:
    =====================================================================================================================
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

    -----------------------------------------------
    -- CREATE TEMPORARY 1:1 TABLE OF INPUT TABLE --
    -----------------------------------------------

    DROP TABLE IF EXISTS tmp_lopp_contact_map_i;

    CREATE TEMPORARY TABLE tmp_lopp_contact_map_i (
        contact_key                         TEXT NOT NULL
        ,lopp_key                           TEXT NOT NULL
        ,fk_contact_id                      INTEGER NOT NULL
        ,fk_lopp_id                         INTEGER NOT NULL
        ,tech_insert_function               TEXT NOT NULL
        ,tech_insert_utc_timestamp          BIGINT NOT NULL
        ,tech_deleted_in_source_system      BOOL NOT NULL
        ,tech_row_hash                      TEXT NOT NULL
        ,tech_data_load_utc_timestamp       BIGINT NOT NULL
        ,tech_data_load_uuid                TEXT NOT NULL
     );

    /* not all contacts related to a lopp are in 'vtiger_contpotentialrel' table so we need to union it with column 'contact_no' from table 'vtiger_potential'.
        One issue arises when we union the results.
        Sure we could UNION only relations and join LOAD_TIMESTAMP later but I choose a different approach.
        I rank (DESC) the results by LOAD_TIMESTAMP and then filter only those with rank 1.

        Example:

        LOADED ROWS

        lopp_uid_in_source_system | contact_uid_in_source_system | tech_load_timestamp
            POT102                |     CON166                   |  201 709 201 229
            POT102                |     CON166                   |  201 709 201 233

        RANKED ROWS

        lopp_uid_in_source_system | contact_uid_in_source_system | tech_load_timestamp | Rank
            POT102                |     CON166                   |  201 709 201 229     |   1
            POT102                |     CON166                   |  201 709 201 233     |   2

        RESULT ROWS

        lopp_uid_in_source_system | contact_uid_in_source_system | tech_load_timestamp
            POT102                |     CON166                   |  201 709 201 233
    */
    WITH contact_map AS (
        -- contacts from contact potential bridge table
        SELECT
            stage_potential.potential_no AS lopp_key
            ,stage_contact.contact_no AS contact_key
            ,core_contact.contact_id AS fk_contact_id
            ,lopp.lopp_id AS fk_lopp_id
            ,contact_potential_map.tech_data_load_utc_timestamp
            ,contact_potential_map.tech_data_load_uuid
            ,lopp.tech_deleted_in_source_system OR core_contact.tech_deleted_in_source_system AS tech_deleted_in_source_system
        FROM stage.vtiger_contpotentialrel_i AS contact_potential_map
        JOIN stage.vtiger_potential_i AS stage_potential ON stage_potential.potentialid = contact_potential_map.potentialid
        JOIN stage.vtiger_contactdetails_i AS stage_contact ON stage_contact.contactid = contact_potential_map.contactid
        JOIN core.lopp_i AS lopp ON lopp.lopp_key = stage_potential.potential_no
        JOIN core.contact_i AS core_contact ON core_contact.contact_key = stage_contact.contact_no

        UNION ALL
        -- contacts from potentials
        SELECT
            stage_potential.potential_no AS lopp_key
            ,stage_contact.contact_no AS contact_key
            ,core_contact.contact_id AS fk_contact_id
            ,lopp.lopp_id AS fk_lopp_id
            ,stage_potential.tech_data_load_utc_timestamp -- we use potential timestamp because we are interested in potential contact i.e. vtiger_potential.contact_id
            ,stage_potential.tech_data_load_uuid -- we use potential tech_data_load_uuid because we are interested in potential contact i.e. vtiger_potential.contact_id
            ,lopp.tech_deleted_in_source_system OR core_contact.tech_deleted_in_source_system AS tech_deleted_in_source_system
        FROM stage.vtiger_potential_i AS stage_potential
        JOIN stage.vtiger_contactdetails_i AS stage_contact ON stage_contact.contactid = stage_potential.contact_id
        JOIN core.lopp_i AS lopp ON lopp.lopp_key = stage_potential.potential_no
        JOIN core.contact_i AS core_contact ON core_contact.contact_key = stage_contact.contact_no

        UNION ALL
        -- contacts from leads
        SELECT
            lopp.lopp_key AS lopp_key
            ,contact.contact_key AS contact_key
            ,contact.contact_id AS fk_contact_id
            ,lopp.lopp_id AS fk_lopp_id
            ,lopp.tech_data_load_utc_timestamp AS tech_data_load_utc_timestamp -- this is the same for contact and lopp because they come from the same stage table
            ,lopp.tech_data_load_uuid AS tech_data_load_uuid -- this is the same for contact and lopp because they come from the same stage table
            ,lopp.tech_deleted_in_source_system OR contact.tech_deleted_in_source_system AS tech_deleted_in_source_system
        FROM core.lopp_i AS lopp
        JOIN core.contact_i AS contact ON contact.contact_id = lopp.fk_contact_id_main_contact
            AND substring(contact.contact_key FROM 1 FOR 3) = 'LEA' -- filter out contacts created from leads
        WHERE substring(lopp.lopp_key FROM 1 FOR 3) = 'LEA' -- filter out lopps created from leads
    )
    ,ranked_contact_map AS (
        SELECT
            contact_map.lopp_key
            ,contact_map.contact_key
            ,contact_map.fk_contact_id
            ,contact_map.fk_lopp_id
            ,contact_map.tech_data_load_utc_timestamp
            ,contact_map.tech_data_load_uuid
            ,RANK() OVER (
                PARTITION BY (
                    lopp_key
                    ,contact_key
                    ) ORDER BY tech_data_load_utc_timestamp DESC
                ) AS tech_data_load_timestamp_rank
            ,contact_map.tech_deleted_in_source_system
        FROM contact_map
    )
    INSERT INTO tmp_lopp_contact_map_i (
        contact_key
        ,lopp_key
        ,fk_contact_id
        ,fk_lopp_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
         ranked_contact_map.contact_key
        ,ranked_contact_map.lopp_key
        ,ranked_contact_map.fk_contact_id
        ,ranked_contact_map.fk_lopp_id
        ,FUNCTION_NAME AS tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_utc_timestamp
        ,ranked_contact_map.tech_deleted_in_source_system AS tech_deleted_in_source_system
        ,md5(
        ranked_contact_map.contact_key::TEXT
        || ranked_contact_map.lopp_key::TEXT
        ) AS tech_row_hash
        ,ranked_contact_map.tech_data_load_utc_timestamp
        ,ranked_contact_map.tech_data_load_uuid
    FROM ranked_contact_map
    WHERE tech_data_load_timestamp_rank = 1;

    -----------------------------------------
    -- INSERT NEW RECORDS INTO INPUT TABLE --
    -----------------------------------------

    INSERT INTO core.lopp__contact_map_i (
        contact_key
        ,lopp_key
        ,fk_contact_id
        ,fk_lopp_id
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_deleted_in_source_system
        ,tech_row_hash
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    SELECT
        tmp_lopp_contact_map_i.contact_key
        ,tmp_lopp_contact_map_i.lopp_key
        ,tmp_lopp_contact_map_i.fk_contact_id
        ,tmp_lopp_contact_map_i.fk_lopp_id
        ,tmp_lopp_contact_map_i.tech_insert_function
        ,tmp_lopp_contact_map_i.tech_insert_utc_timestamp
        ,tmp_lopp_contact_map_i.tech_deleted_in_source_system
        ,tmp_lopp_contact_map_i.tech_row_hash
        ,tmp_lopp_contact_map_i.tech_data_load_utc_timestamp
        ,tmp_lopp_contact_map_i.tech_data_load_uuid
    FROM tmp_lopp_contact_map_i;

    RETURN 0;

END;$$

LANGUAGE plpgsql
