CREATE OR REPLACE FUNCTION tf_u_convert_interval_to_minutes(IN interval_to_convert INTERVAL, OUT minutes_in_interval NUMERIC(10,5))
RETURNS NUMERIC(10,5) AS $$
    
    ------------------------------------------------------------------------------------------------------------------------------------------------
    -- Description  : Converts Interval to minutes
    -- Author       : Martin Vrabel (https://github.com/mvrabel)
    -- Created On   : 2018-12-16
    ------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE

SECONDS_IN_A_MINUTE INTEGER := 60;

BEGIN
       
    minutes_in_interval := (
        SELECT
            CASE
                WHEN interval_to_convert IS NULL THEN NULL
                ELSE (EXTRACT(epoch FROM interval_to_convert)/ SECONDS_IN_A_MINUTE)::NUMERIC(10, 5)
            END AS minutes
    );

END;
$$ LANGUAGE plpgsql;
