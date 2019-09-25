CREATE OR REPLACE FUNCTION mart.tf_u_generate_vacuum_statements_mart_tables()
RETURNS TABLE (
vacuum_statement TEXT
) AS $$


BEGIN

    RETURN QUERY SELECT tf_u_generate_vacuum_statements('mart');

END;$$

LANGUAGE plpgsql;
