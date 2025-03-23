#!/bin/bash
#########################################################################
# Name: backup-docker-volumes.sh
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
TIMESTAMP=$(TZ=America/New_York date +"%Y%m%d_%H%M%S")

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
BACKUP_DIR="$BACKUP_ROOT_DIR/$VOL_BACKUP_FOLDER_PREFIX/$VOL_BACKUP_FOLDER_PREFIX-$TIMESTAMP"

# Which Volumes you want to backup (separated by space)?
# VOLUME=$(docker volume ls  -q) for all volumes
# you can filter all Volumes with grep (include only) or grep -v (exclude) or a combination
# to do a filter for 2 or more arguments separate them with "\|"
# example: $(docker volume ls -q |grep 'project1\|project2' | grep -v 'database')
# to use volumes with name project1 and project2 but not database
# VOLUME=$(docker volume ls -q |grep 'project1\|project2' | grep -v 'database')
# VOLUME=$(docker volume ls -q | grep -v 'mailcowdockerized\|_db')
VOLUME=$(docker volume ls -q | grep -v 'pia\|diun\|wikijs-db\|piwigo-mysql\|npm-letsen\|nginx_postgres')

# if you want to use memory limitation. Must be supported by the kernel.
#MEMORYLIMIT="-m 35m"

echo -e "Start $TIMESTAMP Backup for Volumes:\n"
if [ ! -d $BACKUP_DIR ]; then
        mkdir -p $BACKUP_DIR
fi

echo "Backup up volumes to $BACKUP_DIR:"

COUNTER=0
for i in $VOLUME; do
        echo " - $i";

        docker run --rm \
        -v $BACKUP_DIR:/backup \
        -v $i:/volume:ro \
        -e TIMESTAMP=$TIMESTAMP \
        -e i=$i ${MEMORYLIMIT} \
        --name volume-backup \
        busybox \
        tar -czf /backup/$i.tar.gz -C /volume .

        COUNTER=$((COUNTER+1))
done
echo -e "\nBackup for $COUNTER Docker volumes completed"


# Determine the number backups tht need removed
BACKUP_COUNT=$(ls -1 "$BACKUP_ROOT_DIR" | grep -c "^$VOL_BACKUP_FOLDER_PREFIX")
DELETE_COUNT=$((BACKUP_COUNT - NUM_BACKUP_COPIES))

if [ $DELETE_COUNT -gt 0 ]; then
  echo -e "\n$DELETE_COUNT backup(s) to be removed:"

  # Create a list of folders to delete by timestamp
  DELETE_LIST=$(ls -1 "$BACKUP_ROOT_DIR" | grep "^$VOL_BACKUP_FOLDER_PREFIX" | sort | head -n $DELETE_COUNT)

  for DELETE in $DELETE_LIST; do
    echo " - $BACKUP_ROOT_DIR/$DELETE";
    rm -rf "$BACKUP_ROOT_DIR/$DELETE"
  done
fi

echo -e "\nBackup process completed\n"