CREATE OR REPLACE FUNCTION mart.tf_r_booking_per_revenue_type_per_quarter()
RETURNS INTEGER AS $$

BEGIN

    INSERT INTO mart.booking_per_revenue_type_per_quarter (
        booking_quarter_year
        ,revenue_type
        ,booked_usd_amount
        ,booking_quarter
        ,booking_year
        )
    SELECT
        'Q' || booking_quarter::TEXT || ' ' || booking_year AS booking_quarter_year
        ,revenue_type
        ,sum(booked_usd_amount) AS booked_usd_amount
        ,booking_quarter
        ,booking_year
    FROM mart.booking_per_revenue_type_per_month
    GROUP BY revenue_type
        ,booking_quarter
        ,booking_year;

    RETURN 0;

END;$$

LANGUAGE plpgsql;
