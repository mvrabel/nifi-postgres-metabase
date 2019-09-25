CREATE OR REPLACE FUNCTION tf_u_convert_date_to_yyyymmdd_integer(IN in_date_to_convert DATE, OUT date_as_integer INTEGER)
RETURNS INTEGER AS $$
    
    ------------------------------------------------------------------------------------------------------------------------------------------------
    -- Description  : Parses DATE in formats into integer in format YYYYMM
    --                Returns:
                            -- NULL - if in_date_to_convert is NULL
                            -- Date - intger in format YYYYMMDD if in_date_to_convert is not null
    -- Author       : Martin Vrabel (https://github.com/mvrabel)
    -- Created On   : 2018-12-19
    ------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE    

BEGIN
       
    date_as_integer := (SELECT TO_CHAR(in_date_to_convert, 'YYYYMMDD')::INTEGER);

END;
$$ LANGUAGE plpgsql;
