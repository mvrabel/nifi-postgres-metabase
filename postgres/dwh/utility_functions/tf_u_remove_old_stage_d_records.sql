CREATE OR REPLACE FUNCTION public.tf_u_remove_old_stage_d_records(days integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    tables CURSOR FOR
        SELECT tablename
        FROM pg_tables
        WHERE tablename NOT LIKE 'pg_%' and schemaname = 'stage' and tablename like '%_d';
BEGIN
    FOR table_record IN tables LOOP        
        EXECUTE
			'DELETE FROM stage.'
			|| table_record.tablename
			|| ' '
			|| 'WHERE tech_snapshot_utc_timestamp < to_char((now() AT TIME ZONE ''UTC'' - interval'''
			|| ' '
			|| days::text
			|| ' '
			|| 'day''), ''YYYYMMDDHH24MISS'')::bigint;';
    END LOOP;
RETURN 0;
END;$function$

