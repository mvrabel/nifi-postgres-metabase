CREATE OR REPLACE FUNCTION mart.tf_r_duplicate_emails_in_contacts()
RETURNS INTEGER AS $$

DECLARE

TEXT_NULL TEXT := (SELECT text_null FROM core.c_null_replacement_g);

BEGIN

    WITH duplicate_contacts
    AS (
        SELECT
            contact.email_address
            ,unnest(array_agg(contact.contact_id)) AS contact_id
        FROM core.contact_t AS contact
        WHERE contact.email_address != TEXT_NULL
        GROUP BY contact.email_address
        HAVING count(contact.email_address) > 1
        )
    INSERT INTO mart.duplicate_emails_in_contacts (
        email
        ,contact_name
        ,organization_name
        ,pipedrive_link
    )
    SELECT
        duplicate_contacts.email_address
        ,contact_party.full_name AS contact_name
        ,organization_party.full_name AS organization_name
        ,'https://PIPEDRIVE/person/' || contact.pipedrive_id AS pipedrive_link
    FROM duplicate_contacts
    JOIN core.contact_t AS contact ON contact.contact_id = duplicate_contacts.contact_id
    JOIN core.party_t AS contact_party ON contact_party.party_id = contact.fk_party_id
    LEFT JOIN core.organization_t AS organization ON organization.organization_id = contact.fk_organization_id
    LEFT JOIN core.party_t AS organization_party ON organization_party.party_id = organization.fk_party_id;

    RETURN 0;

END;$$

LANGUAGE plpgsql;
