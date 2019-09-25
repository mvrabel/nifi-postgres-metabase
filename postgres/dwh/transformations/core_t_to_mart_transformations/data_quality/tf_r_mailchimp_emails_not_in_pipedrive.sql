CREATE OR REPLACE FUNCTION mart.tf_r_mailchimp_emails_not_in_pipedrive()
RETURNS INTEGER AS $$

BEGIN

    INSERT INTO mart.mailchimp_emails_not_in_pipedrive (
        contact_name
        ,contact_email
        ,mailing_list_name
        ,mailing_list_link
    )
    SELECT
        contact_party.full_name AS contact_name
        ,mailing_list_member.email_address AS contact_email
        ,mailing_list.mailing_list_name
        ,'https://MAILCHIMP/lists/members/?id='::TEXT || mailing_list.mailchimp_id_web_id AS mailing_list_link
    FROM core.mailing_list_member_t AS mailing_list_member
    JOIN core.party_t AS contact_party ON contact_party.party_id = mailing_list_member.fk_party_id     
    JOIN core.mailing_list_t AS mailing_list ON mailing_list.mailing_list_id = mailing_list_member.fk_mailing_list_id
    WHERE mailing_list_member.email_address NOT IN (
        SELECT DISTINCT email_address FROM core.contact_t
    )
    AND mailing_list_member.mailing_list_member_id != -1;

    RETURN 0;

END;$$

LANGUAGE plpgsql
