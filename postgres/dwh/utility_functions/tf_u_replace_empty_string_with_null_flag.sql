CREATE OR REPLACE FUNCTION tf_u_replace_empty_string_with_null_flag(IN input_string TEXT, OUT return_text TEXT)
AS $$

DECLARE

NULL_FLAG TEXT := (SELECT text_null FROM core.c_null_replacement_g);

BEGIN

    
    return_text := (
        SELECT 
            CASE
                WHEN regexp_replace(COALESCE(input_string,''), '\s', '', 'g') = '' THEN NULL_FLAG
                ELSE input_string
            END AS return_text
        );

END;$$

LANGUAGE plpgsql;
