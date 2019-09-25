CREATE OR REPLACE FUNCTION mart.tf_r_partner_name_not_recognised()
RETURNS INTEGER AS $$

DECLARE

TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g); 

BEGIN

    INSERT INTO mart.partner_name_not_recognised (
        deal_title
        ,deal_stage
        ,partner_name
        ,partner_type
        ,pipedrive_link
    )
    -- Partner - Identified By 
    SELECT
        deal.title AS deal_title
        ,deal.stage AS deal_stage
        ,deal.partner_identified_by AS partner_name
        ,'Identified By'::TEXT AS partner_type
        ,'https://PIPEDRIVE/deal/' || deal.pipedrive_id AS pipedrive_link
    FROM core.deal_t AS deal
    WHERE (SELECT CASE
        WHEN position(' - ' IN deal.partner_identified_by) != 0
            THEN SUBSTRING(deal.partner_identified_by FROM 0 FOR position(' - ' IN deal.partner_identified_by))
        ELSE deal.partner_identified_by
    END AS referring_partner) NOT IN (SELECT partner_name FROM core.c_partner_list_t)

    UNION ALL
    -- Partner - Qualified By
    SELECT
        deal.title AS deal_title
        ,deal.stage AS deal_stage
        ,deal.partner_qualified_by AS partner_name
        ,'Qualified By'::TEXT AS partner_type
        ,'https://PIPEDRIVE/deal/' || deal.pipedrive_id AS pipedrive_link
    FROM core.deal_t AS deal
    WHERE (SELECT CASE
        WHEN position(' - ' IN deal.partner_qualified_by) != 0
            THEN SUBSTRING(deal.partner_qualified_by FROM 0 FOR position(' - ' IN deal.partner_qualified_by))
        ELSE deal.partner_qualified_by
    END AS referring_partner) NOT IN (SELECT partner_name FROM core.c_partner_list_t)

    UNION ALL
    -- Partner - Poc Done By
    SELECT
        deal.title AS deal_title
        ,deal.stage AS deal_stage
        ,deal.partner_poc_done_by AS partner_name
        ,'Poc Done By'::TEXT AS partner_type
        ,'https://PIPEDRIVE/deal/' || deal.pipedrive_id AS pipedrive_link
    FROM core.deal_t AS deal
    WHERE (SELECT CASE
        WHEN position(' - ' IN deal.partner_poc_done_by) != 0
            THEN SUBSTRING(deal.partner_poc_done_by FROM 0 FOR position(' - ' IN deal.partner_poc_done_by))
        ELSE deal.partner_poc_done_by
    END AS referring_partner) NOT IN (SELECT partner_name FROM core.c_partner_list_t)

    UNION ALL
    -- Partner - Closed By
    SELECT
        deal.title AS deal_title
        ,deal.stage AS deal_stage
        ,deal.partner_closed_by AS partner_name
        ,'Closed By'::TEXT AS partner_type
        ,'https://PIPEDRIVE/deal/' || deal.pipedrive_id AS pipedrive_link
    FROM core.deal_t AS deal
    WHERE (SELECT CASE
        WHEN position(' - ' IN deal.partner_closed_by) != 0
            THEN SUBSTRING(deal.partner_closed_by FROM 0 FOR position(' - ' IN deal.partner_closed_by))
        ELSE deal.partner_closed_by
    END AS referring_partner) NOT IN (SELECT partner_name FROM core.c_partner_list_t)

    UNION ALL
    -- Partner - Resold By
    SELECT
        deal.title AS deal_title
        ,deal.stage AS deal_stage
        ,deal.partner_resold_by AS partner_name
        ,'Resold By'::TEXT AS partner_type
        ,'https://PIPEDRIVE/deal/' || deal.pipedrive_id AS pipedrive_link
    FROM core.deal_t AS deal
    WHERE (SELECT CASE
        WHEN position(' - ' IN deal.partner_resold_by) != 0
            THEN SUBSTRING(deal.partner_resold_by FROM 0 FOR position(' - ' IN deal.partner_resold_by))
        ELSE deal.partner_resold_by
    END AS referring_partner) NOT IN (SELECT partner_name FROM core.c_partner_list_t)

    UNION ALL
    -- Partner - Owned By
    SELECT
        deal.title AS deal_title
        ,deal.stage AS deal_stage
        ,deal.partner_owned_by AS partner_name
        ,'Owned By'::TEXT AS partner_type
        ,'https://PIPEDRIVE/deal/' || deal.pipedrive_id AS pipedrive_link
    FROM core.deal_t AS deal
    WHERE (SELECT CASE
        WHEN position(' - ' IN deal.partner_owned_by) != 0
            THEN SUBSTRING(deal.partner_owned_by FROM 0 FOR position(' - ' IN deal.partner_owned_by))
        ELSE deal.partner_owned_by
    END AS referring_partner) NOT IN (SELECT partner_name FROM core.c_partner_list_t)

    UNION ALL
    -- Partner - Supported By
    SELECT
        deal.title AS deal_title
        ,deal.stage AS deal_stage
        ,deal.partner_supported_by AS partner_name
        ,'Supported By'::TEXT AS partner_type
        ,'https://PIPEDRIVE/deal/' || deal.pipedrive_id AS pipedrive_link
    FROM core.deal_t AS deal
    WHERE (SELECT CASE
        WHEN position(' - ' IN deal.partner_supported_by) != 0
            THEN SUBSTRING(deal.partner_supported_by FROM 0 FOR position(' - ' IN deal.partner_supported_by))
        ELSE deal.partner_supported_by
    END AS referring_partner) NOT IN (SELECT partner_name FROM core.c_partner_list_t);

    RETURN 0;

END;$$

LANGUAGE plpgsql;
