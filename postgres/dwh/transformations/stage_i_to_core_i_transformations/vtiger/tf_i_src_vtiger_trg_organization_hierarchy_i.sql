CREATE OR REPLACE FUNCTION core.tf_i_src_vtiger_trg_organization_hierarchy_i()
RETURNS INTEGER AS $$

    /*
    =====================================================================================================================
    DESCRIPTION:		Insert data from stage 'vtiger_*' tables into core input table organization_hierarchy_i
    AUTHOR:				Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:			2018-05-14 (YYYY-MM-DD)
    NOTE:				
    =====================================================================================================================
    */

DECLARE

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
	 
	DROP TABLE IF EXISTS tmp_organization_hierarchy_i_helper_table;
	
	CREATE TEMPORARY TABLE tmp_organization_hierarchy_i_helper_table (
		organization_key   				TEXT NOT NULL
		,organization_key_parent		TEXT
		,fk_organization_id				INTEGER NOT NULL
		,fk_organization_id_parent		INTEGER
		,organization_deleted			BOOL NOT NULL
		,organization_parent_deleted	BOOL
		,tech_data_load_utc_timestamp 	BIGINT NOT NULL
		,tech_data_load_uuid			TEXT NOT NULL
	 );
	 
	 INSERT INTO tmp_organization_hierarchy_i_helper_table (
		organization_key
		,organization_key_parent
		,fk_organization_id
		,fk_organization_id_parent
		,organization_deleted
		,organization_parent_deleted
		,tech_data_load_utc_timestamp
		,tech_data_load_uuid
	 )
	SELECT
		vt_account.account_no AS organization_key
		,vt_parent_account.account_no AS organization_key_parent
		,organization.organization_id AS fk_organization_id
		,organization_parent.organization_id AS fk_organization_id_parent
		,organization.tech_deleted_in_source_system AS organization_deleted
		,organization_parent.tech_deleted_in_source_system AS organization_parent_deleted
		,vt_account.tech_data_load_utc_timestamp
		,vt_account.tech_data_load_uuid
	FROM stage.vtiger_account_i AS vt_account
	LEFT JOIN stage.vtiger_account_i AS vt_parent_account ON vt_account.parentid = vt_parent_account.accountid
	JOIN core.organization_i AS organization ON organization.crm_id = vt_account.accountid
	LEFT JOIN core.organization_i AS organization_parent ON organization_parent.crm_id = vt_account.parentid;
	
	-----------------------------------------
	-- NEWLY LOADED ORGANIZATION RELATIONS --
	-----------------------------------------
	
	DROP TABLE IF EXISTS tmp_organization_hierarchy_i;
	
	CREATE TEMPORARY TABLE tmp_organization_hierarchy_i (
		fk_organization_id 					INTEGER NOT NULL
		,fk_organization_id_parent 			INTEGER NOT NULL
		,lowest_child_flag 					BOOL NOT NULL
		,highest_parent_flag 				BOOL NOT NULL
		,depth_from_highest_parent 			INTEGER NOT NULL
		,hierarchy_path 					INTEGER [] NOT NULL
		,organization_key_parent 			TEXT
		,organization_key 					TEXT NOT NULL
		,tech_insert_function				TEXT NOT NULL
		,tech_insert_utc_timestamp			BIGINT NOT NULL
		,tech_deleted_in_source_system		BOOL NOT NULL DEFAULT FALSE
		,tech_row_hash						TEXT NOT NULL
		,tech_data_load_utc_timestamp 		BIGINT NOT NULL
		,tech_data_load_uuid				TEXT NOT NULL
	);

	
	WITH recursive rel_tree
	AS (
		SELECT helper_table.fk_organization_id
			,helper_table.fk_organization_id_parent
			,0 AS level
			,array [helper_table.fk_organization_id] AS path_info
			,helper_table.organization_key
			,helper_table.organization_key_parent
			,helper_table.organization_deleted
			,helper_table.organization_parent_deleted
			,helper_table.tech_data_load_utc_timestamp
			,helper_table.tech_data_load_uuid
		FROM tmp_organization_hierarchy_i_helper_table AS helper_table
		WHERE fk_organization_id_parent IS NULL
		
		UNION ALL
		
		SELECT helper_table.fk_organization_id
			,helper_table.fk_organization_id_parent
			,rel_tree.level + 1
			,array_append(rel_tree.path_info, helper_table.fk_organization_id)
			,helper_table.organization_key
			,helper_table.organization_key_parent
			,helper_table.organization_deleted
			,helper_table.organization_parent_deleted
			,helper_table.tech_data_load_utc_timestamp
			,helper_table.tech_data_load_uuid
		FROM tmp_organization_hierarchy_i_helper_table AS helper_table
		JOIN rel_tree AS rel_tree ON helper_table.fk_organization_id_parent = rel_tree.fk_organization_id
		)
	INSERT INTO tmp_organization_hierarchy_i (
			fk_organization_id
			,fk_organization_id_parent
			,lowest_child_flag
			,highest_parent_flag
			,depth_from_highest_parent
			,organization_key_parent
			,organization_key
			,hierarchy_path
			,tech_insert_function
			,tech_insert_utc_timestamp
			,tech_deleted_in_source_system
			,tech_row_hash
			,tech_data_load_utc_timestamp
			,tech_data_load_uuid
		)
	 SELECT
		src.fk_organization_id
		 ,CASE WHEN src.fk_organization_id_parent IS NULL THEN -1 
			   ELSE src.fk_organization_id_parent
		 END AS fk_organization_id_parent
		 ,CASE WHEN joined_rel_tree.fk_organization_id_parent IS NULL THEN TRUE 
			 ELSE FALSE 
		 END AS lowest_child_flag
		 ,CASE WHEN src.fk_organization_id_parent IS NULL THEN TRUE 
			 ELSE FALSE
		 END AS highest_parent_flag
		 ,src.level AS depth_from_highest_parent
		 ,CASE WHEN src.organization_key_parent IS NULL THEN '-1'::text 
			ELSE src.organization_key_parent
		 END AS organization_key_parent
		 ,src.organization_key
		 ,src.path_info AS hierarchy_path
		 ,FUNCTION_NAME AS tech_insert_function
		 ,CURRENT_UTC_TIMESTAMP_AS_BIGINT AS tech_insert_function
		 ,src.organization_deleted OR COALESCE(joined_rel_tree.organization_deleted, FALSE) AS tech_deleted_in_source_system		
		 ,md5(
		 array_to_string(src.path_info, ',')
		 || COALESCE(src.organization_key, '')
		 || COALESCE(src.organization_key_parent, '')
		 || COALESCE(joined_rel_tree.organization_key_parent, '')
		 ) AS tech_row_hash
		 ,src.tech_data_load_utc_timestamp
		 ,src.tech_data_load_uuid
	FROM rel_tree AS src
	LEFT OUTER JOIN rel_tree AS joined_rel_tree ON src.fk_organization_id = joined_rel_tree.fk_organization_id_parent
	-- this GROUP BY is only to exclude duplicate rows that arise from above ^^ LEFT OUTHER JOIN. 
	GROUP BY
		src.fk_organization_id
		,src.fk_organization_id_parent
		,joined_rel_tree.fk_organization_id_parent
		,joined_rel_tree.organization_key_parent
		,src.level
		,src.organization_key_parent
		,src.organization_key
		,src.path_info
		,src.organization_deleted
		,joined_rel_tree.organization_deleted
		,src.tech_data_load_utc_timestamp
		,src.tech_data_load_uuid
	ORDER BY src.fk_organization_id;

	-----------------------------------------
	-- INSERT NEW RECORDS INTO INPUT TABLE --
	-----------------------------------------
	
	INSERT INTO core.organization_hierarchy_i (
		organization_key
		,organization_key_parent
		,fk_organization_id
		,fk_organization_id_parent
		,lowest_child_flag
		,highest_parent_flag
		,depth_from_highest_parent
		,hierarchy_path
		,tech_insert_function
		,tech_insert_utc_timestamp
		,tech_deleted_in_source_system
		,tech_row_hash
		,tech_data_load_utc_timestamp
		,tech_data_load_uuid
		)
	SELECT
		tmp_organization_hierarchy_i.organization_key
		,tmp_organization_hierarchy_i.organization_key_parent
		,tmp_organization_hierarchy_i.fk_organization_id
		,tmp_organization_hierarchy_i.fk_organization_id_parent
		,tmp_organization_hierarchy_i.lowest_child_flag
		,tmp_organization_hierarchy_i.highest_parent_flag
		,tmp_organization_hierarchy_i.depth_from_highest_parent
		,tmp_organization_hierarchy_i.hierarchy_path
		,tmp_organization_hierarchy_i.tech_insert_function
		,tmp_organization_hierarchy_i.tech_insert_utc_timestamp
		,tmp_organization_hierarchy_i.tech_deleted_in_source_system
		,tmp_organization_hierarchy_i.tech_row_hash
		,tmp_organization_hierarchy_i.tech_data_load_utc_timestamp
		,tmp_organization_hierarchy_i.tech_data_load_uuid
	FROM tmp_organization_hierarchy_i;
	
	RETURN 0;
	
END;$$

LANGUAGE plpgsql
