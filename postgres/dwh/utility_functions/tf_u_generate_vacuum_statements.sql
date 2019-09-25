CREATE OR REPLACE FUNCTION tf_u_generate_vacuum_statements(IN schema_name TEXT, IN table_postfix TEXT DEFAULT NULL)
RETURNS TABLE (
vacuum_statement TEXT
) AS $$

BEGIN

    IF table_postfix IS NOT NULL THEN
        RETURN QUERY SELECT 
                         'VACUUM ANALYZE ' 
                         || pg_stat_user_tables.schemaname
                         || '.'
                         || pg_stat_user_tables.relname
                         || ';'
                     FROM pg_stat_user_tables
                     WHERE pg_stat_user_tables.schemaname = schema_name
                     AND pg_stat_user_tables.relname LIKE '%' || table_postfix;
    ELSE
        RETURN QUERY SELECT 
                         'VACUUM ANALYZE ' 
                         || pg_stat_user_tables.schemaname
                         || '.'
                         || pg_stat_user_tables.relname
                         || ';'
                     FROM pg_stat_user_tables
                     WHERE pg_stat_user_tables.schemaname = schema_name;
    END IF;

END;$$

LANGUAGE plpgsql;
