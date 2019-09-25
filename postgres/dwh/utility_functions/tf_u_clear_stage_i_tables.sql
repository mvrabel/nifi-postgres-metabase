CREATE OR REPLACE FUNCTION stage.tf_u_clear_stage_i_tables() 
RETURNS INTEGER AS $$
DECLARE
tables CURSOR
FOR
SELECT tablename
FROM pg_tables
WHERE tablename NOT LIKE 'pg_%'
    AND schemaname = 'stage'
    AND tablename LIKE '%_i';

BEGIN
    FOR table_record IN tables LOOP        
        EXECUTE
            'DELETE FROM stage.' || table_record.tablename;
    END LOOP;
RETURN 0;

END;$$

LANGUAGE plpgsql
