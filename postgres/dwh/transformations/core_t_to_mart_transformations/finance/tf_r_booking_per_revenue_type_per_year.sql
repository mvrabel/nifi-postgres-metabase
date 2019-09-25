CREATE OR REPLACE FUNCTION mart.tf_r_booking_per_revenue_type_per_year()
RETURNS INTEGER AS $$

BEGIN

    INSERT INTO mart.booking_per_revenue_type_per_year (
        booking_year
        ,revenue_type
        ,booked_usd_amount
    )
    SELECT
        booking_year
        ,revenue_type
        ,sum(booked_usd_amount) AS booked_usd_amount
    FROM mart.booking_per_revenue_type_per_quarter
    GROUP BY booking_year
        ,revenue_type;

    RETURN 0;
END;$$

LANGUAGE plpgsql;
