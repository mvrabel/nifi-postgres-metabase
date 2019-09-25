#!/bin/bash

logfile=/tmp/initdb.log

function log() {
  echo $1 >> $logfile
}

LOG "INFO: Start $(date +%Y%m%d_%H%M%S)" > $logfile 


# Add users
log "INFO: Running dwh_admin.sql"
psql -U postgres -f /dwh/database/users/dwh_admin.sql &>> $logfile

# Get password for dwh_admin
export PGPASSWORD=$(cat /dwh/.dwh_admin_password)

# Add db schema
log "INFO: Running create_db_with_schemas.sql"
psql -U dwh_admin -d postgres -f /dwh/database/create_db_with_schemas.sql &>> $logfile

# Add basic table like: date, currency, exchange rate
log "INFO: Running core_g_tables_dump.sql "
psql -U dwh_admin -d dwh -f /dwh/database/tables/core_g_tables_dump.sql &>> $logfile

# Add all other tables
log "INFO: Running scripts from tables directory"
find /dwh/database/tables  \( -iname "*.sql" ! -iname "core_g_tables_dump.sql" \) -exec psql -U dwh_admin -d dwh -f {} \; &>> $logfile

# Add transformations for tables between schemas
log "INFO: Running cripts from transformations directory"
find /dwh/transformations -name "*.sql" -exec psql -U dwh_admin -d dwh -f {} \; &>> $logfile

# Add utility_functions
log "INFO: Running cripts from utility_functions directory"
find /dwh/utility_functions -name "*.sql" -exec psql -U dwh_admin -d dwh -f {} \; &>> $logfile

log "INFO: Running dwh_metabase_user.sql"
psql  -U postgres -d dwh -f /dwh/database/users/dwh_metabase_user.sql &>> $logfile

log "INFO: Running dwh_nifi_user.sql"
psql  -U postgres -d dwh -f /dwh/database/users/dwh_nifi_user.sql &>> $logfile

# Add db extensions
log "INFO: Running create_extensions.sql"
psql -U postgres -d dwh -f /dwh/database/create_extensions.sql &>> $logfile

log "INFO: ######### Important #########"
log "INFO: Log ${logfile} contains $(grep -c NOTICE $logfile) occurrences of NOTICE word"
log "INFO: Log ${logfile} contains $(grep -c HINT $logfile) occurrences of HINT word"
log "INFO: Log ${logfile} contains $(grep -c FATAL $logfile) occurrences of FATAL word"
log "INFO: Log ${logfile} contains $(grep -c ERROR $logfile) occurrences of ERROR word"
log "INFO: Log ${logfile} contains $(grep -c WARN $logfile) occurrences of WARN word"
log "INFO: Check log " ${logfile} "!"