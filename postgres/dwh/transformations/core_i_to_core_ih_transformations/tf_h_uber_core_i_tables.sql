CREATE OR REPLACE FUNCTION core.tf_h_uber_core_i_tables()
RETURNS INTEGER AS $$

BEGIN

    PERFORM core.tf_h_employee_ih();
    PERFORM core.tf_h_party_ih();
    PERFORM core.tf_h_organization_ih();
    PERFORM core.tf_h_contact_ih();
    PERFORM core.tf_h_project_ih();
    PERFORM core.tf_h_issue_ih();
    PERFORM core.tf_h_deal_ih();

    RETURN 0;

END;$$

LANGUAGE plpgsql
