CREATE OR REPLACE FUNCTION stage.tf_e_ocean_organziation_to_crm_map_i()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$

    /*
    ===========================================================================================================
    DESCRIPTION:        Marks rows which have invalid data in stage input table sales_report_i
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:         2018-05-15 (YYYY-MM-DD)
    NOTE:
    ===========================================================================================================
    */

BEGIN

    UPDATE stage.ocean_organziation_to_crm_map_i
    SET error = True
    WHERE organization_name IN (
            SELECT organization_name
            FROM stage.ocean_organziation_to_crm_map_i
            GROUP BY organization_name
            HAVING count(organization_name) > 1
            );

    UPDATE stage.ocean_organziation_to_crm_map_i
    SET error = True
    WHERE crm_id IN (
            SELECT crm_id
            FROM stage.ocean_organziation_to_crm_map_i
            GROUP BY crm_id
            HAVING count(crm_id) > 1
            );

    UPDATE stage.ocean_organziation_to_crm_map_i
    SET error = True
    WHERE (organization_name <> '') IS NOT TRUE
        OR (crm_id <> 0) IS NOT TRUE;

    RETURN 0;

END;$function$
