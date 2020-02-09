FROM postgres:11
# dwh
COPY dwh/database dwh/database
COPY dwh/transformations dwh/transformations
COPY dwh/utility_functions dwh/utility_functions
COPY dwh/.dwh_admin_password dwh/.dwh_admin_password
COPY dwh/init_dwh.sh docker-entrypoint-initdb.d/init_dwh.sh
	
# metabase
COPY metabase/create_db.sql metabase/
COPY metabase/metabase_admin.sql metabase/
COPY metabase/.metabase_admin_password metabase/
COPY metabase/init_metabase.sh docker-entrypoint-initdb.d/init_metabase.sh

RUN chmod 777 docker-entrypoint-initdb.d/init_dwh.sh
RUN chmod 777 docker-entrypoint-initdb.d/init_metabase.sh