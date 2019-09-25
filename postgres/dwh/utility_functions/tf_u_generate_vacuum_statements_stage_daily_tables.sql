CREATE OR REPLACE FUNCTION stage.tf_u_generate_vacuum_statements_stage_daily_tables()
RETURNS TABLE (
vacuum_statement TEXT
) AS $$

BEGIN

    RETURN QUERY SELECT tf_u_generate_vacuum_statements('stage', '_d');

END;$$

LANGUAGE plpgsql;
