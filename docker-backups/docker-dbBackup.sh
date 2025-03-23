#!/bin/bash
#########################################################################
# Name: backup-docker-databases.sh
#
# License:
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your option)
# any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.
#########################################################################

# Timestamp definition for the backupfiles (example: $(date +"%Y%m%d_%H%M%S") = 20270704-203415)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Path to the config file (adjust if needed)
CONFIG_FILE="config.sh"

# Check if the config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file '$CONFIG_FILE' not found!"
    exit 1
fi

# Source the config file to load variables
source "$CONFIG_FILE"  # or use: . "$CONFIG_FILE"

# Build the final backdir path
BACKUP_DIR="$BACKUP_ROOT_DIR/$DB_BACKUP_FOLDER_PREFIX/$DB_BACKUP_FOLDER_PREFIX-$TIMESTAMP"

echo -e "Start $TIMESTAMP Database Dumps\n"
if [ ! -d $BACKUP_DIR ]; then
        mkdir -p $BACKUP_DIR
fi

# ******************************** CUSTOMIZE BACKUP COMMANDS ******************************

# MySQL dumps
echo "Backing up: MySQL databases"
docker exec piwigo-mysql /usr/bin/mysqldump -u root -pXPk3#f%rfeEhNc piwigo > $BACKUP_DIR/piwigo-mysql_dump.sql

# PostgreSQL dumps
echo "Backing up: PostgreSQL databases"
docker exec -t wikijs-db pg_dumpall -c -U wikijs > $BACKUP_DIR/wikijs-db_dump.sql

# ******************************************************************************************

# Determine the number backups tht need removed
BACKUP_COUNT=$(ls -1 "$BACKUP_ROOT_DIR" | grep -c "^$DB_BACKUP_FOLDER_PREFIX")
DELETE_COUNT=$((BACKUP_COUNT - NUM_BACKUP_COPIES))

if [ $DELETE_COUNT -gt 0 ]; then
  echo -e "\n$DELETE_COUNT backup(s) to be removed:"

# Create a list of folders to delete by timestamp
  DELETE_LIST=$(ls -1 "$BACKUP_ROOT_DIR" | grep "^$DB_BACKUP_FOLDER_PREFIX" | sort | head -n $DELETE_COUNT)

  for DELETE in $DELETE_LIST; do
    echo " - $BACKUP_ROOT_DIR/$DELETE";
    rm -rf "$BACKUP_ROOT_DIR/$DELETE"
  done
fi

echo -e "\nBackup process completed\n"