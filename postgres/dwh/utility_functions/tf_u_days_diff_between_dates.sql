CREATE OR REPLACE FUNCTION tf_u_days_diff_between_dates(IN start_date DATE, IN end_date DATE, OUT days_diff INTEGER)
RETURNS INTEGER AS $$

DECLARE

SECONDS_IN_A_DAY INTEGER := 86400;

BEGIN

    days_diff := (
    SELECT
        CASE
            WHEN start_date IS NULL OR end_date IS NULL THEN NULL
            ELSE (EXTRACT(epoch FROM age(start_date, end_date)) / SECONDS_IN_A_DAY)::INTEGER
        END AS diff
    );


END;$$

LANGUAGE plpgsql;
