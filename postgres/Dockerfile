FROM postgres:11
COPY dwh/database dwh/database
COPY dwh/transformations dwh/transformations
COPY dwh/utility_functions dwh/utility_functions
COPY dwh/.dwh_admin_password dwh/.dwh_admin_password
COPY dwh/initdb.sh docker-entrypoint-initdb.d/initdb.sh
RUN chmod 777 docker-entrypoint-initdb.d/initdb.sh