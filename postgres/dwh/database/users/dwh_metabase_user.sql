CREATE ROLE dwh_metabase_user;
ALTER ROLE dwh_metabase_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md55D7845AC6EE7CFFFAFC5FE5F35CF666D';

        -----------------------------
        -- GRANT SCHEMA PRIVILEGES --
        -----------------------------

GRANT USAGE ON SCHEMA public       TO dwh_metabase_user;
GRANT USAGE ON SCHEMA etl_metadata TO dwh_metabase_user;
GRANT USAGE ON SCHEMA stage        TO dwh_metabase_user;
GRANT USAGE ON SCHEMA core         TO dwh_metabase_user;
GRANT USAGE ON SCHEMA mart         TO dwh_metabase_user;

        ----------------------------
        -- GRANT TABLE PRIVILEGES --
        ----------------------------

GRANT SELECT ON ALL TABLES IN SCHEMA public       TO dwh_metabase_user;
GRANT SELECT ON ALL TABLES IN SCHEMA etl_metadata TO dwh_metabase_user;
GRANT SELECT ON ALL TABLES IN SCHEMA stage        TO dwh_metabase_user;
GRANT SELECT ON ALL TABLES IN SCHEMA core         TO dwh_metabase_user;
GRANT SELECT ON ALL TABLES IN SCHEMA mart         TO dwh_metabase_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public       GRANT SELECT ON TABLES TO dwh_metabase_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA etl_metadata GRANT SELECT ON TABLES TO dwh_metabase_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA stage        GRANT SELECT ON TABLES TO dwh_metabase_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA core         GRANT SELECT ON TABLES TO dwh_metabase_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA mart         GRANT SELECT ON TABLES TO dwh_metabase_user;

        -------------------------------
        -- GRANT SEQUENCE PRIVILEGES --
        -------------------------------

GRANT SELECT ON ALL SEQUENCES IN SCHEMA public       TO dwh_metabase_user;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA core         TO dwh_metabase_user;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA mart         TO dwh_metabase_user;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA stage        TO dwh_metabase_user;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA etl_metadata TO dwh_metabase_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public       GRANT USAGE, SELECT ON SEQUENCES TO dwh_metabase_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA etl_metadata GRANT USAGE, SELECT ON SEQUENCES TO dwh_metabase_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA stage        GRANT USAGE, SELECT ON SEQUENCES TO dwh_metabase_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA core         GRANT USAGE, SELECT ON SEQUENCES TO dwh_metabase_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA mart         GRANT USAGE, SELECT ON SEQUENCES TO dwh_metabase_user;