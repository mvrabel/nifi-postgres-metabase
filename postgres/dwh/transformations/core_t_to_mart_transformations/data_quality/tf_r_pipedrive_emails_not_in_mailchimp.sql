CREATE OR REPLACE FUNCTION mart.tf_r_pipedrive_emails_not_in_mailchimp()
RETURNS INTEGER AS $$

DECLARE

TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g); 

BEGIN

    INSERT INTO mart.pipedrive_emails_not_in_mailchimp (
        contact_name
        ,contact_email
        ,pipedrive_link
        ,contact_owner
    )
    SELECT
        contact_party.full_name
        ,contact.email_address
        ,'https://PIPEDRIVE/person/'::TEXT || contact.pipedrive_id AS pipedrive_link
        ,employee_owner.full_name AS contact_owner
    FROM core.contact_t AS contact
    JOIN core.party_t AS contact_party ON contact_party.party_id = contact.fk_party_id 
    JOIN core.employee_t AS employee_owner ON employee_owner.employee_id = contact.fk_employee_id_owner
    WHERE contact.email_address NOT IN (
        SELECT DISTINCT email_address FROM core.mailing_list_member_t
    )
    AND contact.email_address != TEXT_NULL
    AND contact.contact_id != -1;

    RETURN 0;

END;$$

LANGUAGE plpgsql
