CREATE OR REPLACE FUNCTION tf_u_empty_check(IN schema_name TEXT, IN table_postfix TEXT, OUT is_empty TEXT)
AS $$

BEGIN

    is_empty := (
        SELECT CASE 
                WHEN SUM(pg_stat_user_tables.n_live_tup) = 0
                    THEN 'EMPTY'
                ELSE 'NOT_EMPTY'
                END AS not_empty_flag
        FROM pg_stat_user_tables
        WHERE pg_stat_user_tables.schemaname = schema_name
            AND pg_stat_user_tables.relname LIKE '%' || table_postfix
        GROUP BY pg_stat_user_tables.schemaname
        );

END;$$

LANGUAGE plpgsql;
