CREATE OR REPLACE FUNCTION tf_u_convert_iso_8601_to_date(IN in_text_date text, OUT out_date DATE)
RETURNS DATE AS $$
    
    ------------------------------------------------------------------------------------------------------------------------------------------------
    -- Description  : Parses TEXT DATE in formats 'YYYY-MM-DD HH:MI:SS+TT' AND 'YYYY-MM-DDTHH:MI:SS+TT'. 
    --                Returns:
    --                  NULL - if in_text_date is not in valid format
    --                  NULL - if in_text_date is NULL
    --                  Date - date
    -- Author       : Martin Vrabel (https://github.com/mvrabel)
    -- Created On   : 2018-12-16
    ------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE

    ISO_8601_DATE_FORMAT_REGEX TEXT                         := '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';
    ISO_8601_DATE_AND_TIME_FORMAT_REGEX TEXT                := '^[0-9]{4}-[0-9]{2}-[0-9]{2}[T,\ ]{1}[0-9]{2}:[0-9]{2}:[0-9]{2}$';
    ISO_8601_DATE_AND_TIME_AND_TIMEZONE_FORMAT_REGEX TEXT   := '^[0-9]{4}-[0-9]{2}-[0-9]{2}[T,\ ]{1}[0-9]{2}:[0-9]{2}:[0-9]{2}\+[0-9]{2}:[0-9]{2}$';
    
    IS_DATE_EXTRACT BOOLEAN:= (SELECT EXISTS (SELECT regexp_matches(in_text_date, ISO_8601_DATE_FORMAT_REGEX)));
    IS_DATE_TIME_EXTRACT BOOLEAN:= (SELECT EXISTS (SELECT regexp_matches(in_text_date, ISO_8601_DATE_AND_TIME_FORMAT_REGEX)));
    IS_DATE_TIME_TIMEZONE_EXTRACT BOOLEAN:= (SELECT EXISTS (SELECT regexp_matches(in_text_date, ISO_8601_DATE_AND_TIME_AND_TIMEZONE_FORMAT_REGEX)));
    

BEGIN
       
    out_date := (
    SELECT
        CASE
            WHEN 
                IS_DATE_EXTRACT
                OR IS_DATE_TIME_EXTRACT 
                OR IS_DATE_TIME_TIMEZONE_EXTRACT 
                THEN SUBSTRING(in_text_date FROM 1 FOR 10)::DATE
            ELSE NULL            
        END AS extracted_date
    );

END;
$$ LANGUAGE plpgsql;
