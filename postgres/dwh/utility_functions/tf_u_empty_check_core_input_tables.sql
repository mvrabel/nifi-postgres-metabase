CREATE OR REPLACE FUNCTION core.tf_u_empty_check_core_input_tables(OUT is_empty TEXT)
AS $$

BEGIN

    is_empty := (SELECT * FROM tf_u_empty_check('core','_i'));

END;$$
LANGUAGE plpgsql;
