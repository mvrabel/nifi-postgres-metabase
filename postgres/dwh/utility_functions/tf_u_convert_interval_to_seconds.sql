CREATE OR REPLACE FUNCTION tf_u_convert_interval_to_seconds(IN interval_to_convert INTERVAL, OUT seconds_in_interval INTEGER)
RETURNS INTEGER AS $$
    
    ------------------------------------------------------------------------------------------------------------------------------------------------
    -- Description  : Converts Interval to seconds
    -- Author       : Martin Vrabel (https://github.com/mvrabel)
    -- Created On   : 2018-12-16
    ------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE

BEGIN
       
    seconds_in_interval := (
        SELECT
            CASE
                WHEN interval_to_convert IS NULL THEN NULL
                ELSE EXTRACT(epoch FROM interval_to_convert)
            END AS seconds
    );

END;
$$ LANGUAGE plpgsql;
