CREATE OR REPLACE FUNCTION stage.tf_e_stage_data_quality_uber_check ()
RETURNS INTEGER LANGUAGE plpgsql AS $FUNCTION$

BEGIN

    ------------------------
    -- NextClooud / Ocean --
    ------------------------

    PERFORM stage.tf_e_ocean_organziation_to_crm_map_i();
    PERFORM stage.tf_e_ocean_sales_report_i();

    RETURN 0;

END;$FUNCTION$
