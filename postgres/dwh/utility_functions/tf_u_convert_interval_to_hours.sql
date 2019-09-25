CREATE OR REPLACE FUNCTION tf_u_convert_interval_to_hours(IN interval_to_convert INTERVAL, OUT hours_in_interval NUMERIC(10,5))
RETURNS NUMERIC(10,5) AS $$
    
    ------------------------------------------------------------------------------------------------------------------------------------------------
    -- Description  : Converts Interval to hours
    -- Author       : Martin Vrabel (https://github.com/mvrabel)
    -- Created On   : 2018-12-16
    ------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE

SECONDS_IN_A_HOUR INTEGER := 3600;

BEGIN
       
    hours_in_interval := (
        SELECT
            CASE
                WHEN interval_to_convert IS NULL THEN NULL
                ELSE (EXTRACT(epoch FROM interval_to_convert)/ SECONDS_IN_A_HOUR)::NUMERIC(10, 5)
            END AS hours
    );

END;
$$ LANGUAGE plpgsql;
