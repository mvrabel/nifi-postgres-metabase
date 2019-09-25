CREATE OR REPLACE FUNCTION stage.tf_u_gen_inserts_into_stage_d_tables() RETURNS SETOF text AS
$BODY$

DECLARE

BEGIN

  RETURN QUERY
    SELECT
    ('INSERT INTO '
    || foo.table_schema
    || '.'
    || foo.table_name
    || ' ( '
    || foo.table_columns
    || ' ) '
    || 'SELECT '
    || '(TO_CHAR(current_timestamp AT TIME ZONE ''UTC''  , ''YYYYMMddHH24MISS''))::BIGINT, '
    || replace(foo.table_columns, 'tech_snapshot_utc_timestamp,','')
    || ' FROM '
    || table_info.table_schema
    || '.'
    || table_info.table_name) as insert_statement_into_d_tables
FROM information_schema.columns AS table_info
LEFT JOIN (
    SELECT
    table_schema
        ,table_name
        ,string_agg(table_info.column_name, ', '::TEXT ORDER BY array_position(array ['tech_snapshot_utc_timestamp','tech_data_load_uuid','tech_data_load_utc_timestamp'] , table_info.column_name::TEXT)) AS table_columns
    FROM information_schema.columns AS table_info
    WHERE table_name LIKE '%_d'
        AND table_schema = 'stage'
    GROUP BY table_schema
        ,table_name
    ) AS foo ON substring(foo.table_name for length(foo.table_name) - 2) = substring(table_info.table_name for length(table_info.table_name) - 2)
WHERE table_info.table_name LIKE '%_i'
    AND table_info.table_schema = 'stage'
GROUP BY 
    table_info.table_schema
    ,table_info.table_name
    ,foo.table_schema
    ,foo.table_name
    ,foo.table_columns;

 END
   $BODY$
   LANGUAGE plpgsql;
