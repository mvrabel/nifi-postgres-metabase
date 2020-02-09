CREATE USER dwh_nifi_user;
ALTER USER dwh_nifi_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS ENCRYPTED PASSWORD 'secret123';

        -----------------------------
        -- GRANT SCHEMA PRIVILEGES --
        -----------------------------

GRANT USAGE ON SCHEMA public       TO dwh_nifi_user;
GRANT USAGE ON SCHEMA etl_metadata TO dwh_nifi_user;
GRANT USAGE ON SCHEMA stage        TO dwh_nifi_user;
GRANT USAGE ON SCHEMA core         TO dwh_nifi_user;
GRANT USAGE ON SCHEMA mart         TO dwh_nifi_user;

        ----------------------------
        -- GRANT TABLE PRIVILEGES --
        ----------------------------

GRANT SELECT, DELETE, INSERT         ON ALL TABLES IN SCHEMA public       TO dwh_nifi_user;
GRANT SELECT, DELETE, INSERT         ON ALL TABLES IN SCHEMA etl_metadata TO dwh_nifi_user;
GRANT SELECT, DELETE, INSERT, UPDATE ON ALL TABLES IN SCHEMA stage        TO dwh_nifi_user;
GRANT SELECT, DELETE, INSERT, UPDATE ON ALL TABLES IN SCHEMA core         TO dwh_nifi_user;
GRANT SELECT, DELETE, INSERT         ON ALL TABLES IN SCHEMA mart         TO dwh_nifi_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public       GRANT  SELECT, INSERT, DELETE         ON TABLES TO dwh_nifi_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA etl_metadata GRANT  SELECT, INSERT, DELETE         ON TABLES TO dwh_nifi_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA stage        GRANT  SELECT, INSERT, DELETE, UPDATE ON TABLES TO dwh_nifi_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA core         GRANT  SELECT, INSERT, DELETE, UPDATE ON TABLES TO dwh_nifi_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA mart         GRANT  SELECT, INSERT, DELETE         ON TABLES TO dwh_nifi_user;

        -------------------------------
        -- GRANT SEQUENCE PRIVILEGES --
        -------------------------------

GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA etl_metadata TO dwh_nifi_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA core         TO dwh_nifi_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA etl_metadata GRANT  USAGE, SELECT, UPDATE ON SEQUENCES TO dwh_nifi_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA core         GRANT  USAGE, SELECT, UPDATE ON SEQUENCES TO dwh_nifi_user;

        -------------------------------
        -- GRANT FUNCTION PRIVILEGES --
        -------------------------------

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public       TO dwh_nifi_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA etl_metadata TO dwh_nifi_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA stage        TO dwh_nifi_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA core         TO dwh_nifi_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA mart         TO dwh_nifi_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public       GRANT EXECUTE ON FUNCTIONS TO dwh_nifi_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA etl_metadata GRANT EXECUTE ON FUNCTIONS TO dwh_nifi_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA stage        GRANT EXECUTE ON FUNCTIONS TO dwh_nifi_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA core         GRANT EXECUTE ON FUNCTIONS TO dwh_nifi_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA mart         GRANT EXECUTE ON FUNCTIONS TO dwh_nifi_user;
