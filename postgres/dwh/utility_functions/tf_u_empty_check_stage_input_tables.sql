CREATE OR REPLACE FUNCTION stage.tf_u_empty_check_stage_input_tables(OUT is_empty TEXT)
AS $$

BEGIN

    is_empty := (SELECT * FROM tf_u_empty_check('stage','_i'));

END;$$
LANGUAGE plpgsql;
