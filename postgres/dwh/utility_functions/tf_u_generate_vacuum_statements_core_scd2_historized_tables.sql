CREATE OR REPLACE FUNCTION core.tf_u_generate_vacuum_statements_core_scd2_historized_tables()
RETURNS TABLE (
vacuum_statement TEXT
) AS $$

BEGIN

    RETURN QUERY SELECT tf_u_generate_vacuum_statements('core','_ih');

END;$$

LANGUAGE plpgsql;
