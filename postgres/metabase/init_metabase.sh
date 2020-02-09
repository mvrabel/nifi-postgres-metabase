#!/bin/bash

logfile=/tmp/initdb.log

function log() {
  echo $1 >> $logfile
}

log "INFO: Start $(date +%Y%m%d_%H%M%S)" &>> $logfile 


# Add users
log "INFO: Running metabase_admin.sql"
psql -U postgres -f /metabase/metabase_admin.sql &>> $logfile

# Get password for dwh_admin
export PGPASSWORD=$(cat /metabase/.metabase_admin_password)

# Add db schema
log "INFO: Running metabase_create_db.sql"
psql -U metabase_admin -d postgres -f /metabase/create_db.sql &>> $logfile