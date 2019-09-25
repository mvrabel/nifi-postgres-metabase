CREATE OR REPLACE FUNCTION core.tf_u_generate_vacuum_statements_core_input_tables()
RETURNS TABLE (
vacuum_statement TEXT
) AS $$

BEGIN

    RETURN QUERY SELECT tf_u_generate_vacuum_statements('core','_i');

END;$$

LANGUAGE plpgsql;
