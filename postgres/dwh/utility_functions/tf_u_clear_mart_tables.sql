CREATE OR REPLACE FUNCTION mart.tf_u_clear_mart_tables() 
RETURNS INTEGER AS $$
DECLARE

SCHEMA_NAME text := 'mart';

tables CURSOR
FOR
SELECT tablename
FROM pg_tables
WHERE tablename NOT LIKE 'pg_%'
    AND schemaname = SCHEMA_NAME;

BEGIN
    FOR table_record IN tables LOOP        
        EXECUTE
            'DELETE FROM' || ' ' || SCHEMA_NAME || '.' || table_record.tablename;
    END LOOP;
RETURN 0;

END;$$

LANGUAGE plpgsql
