#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to the config file in the same directory as the script
CONFIG_FILE="$SCRIPT_DIR/config.sh"

# Check if the config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file '$CONFIG_FILE' not found!"
    exit 1
fi

# Source the config file to load variables
source "$CONFIG_FILE"  # or use: . "$CONFIG_FILE"

# Attempt to create a lock file, if we can't then the process is running already, so exit
mkdir -p $LOCK_DIR
exec {lock_fd}>$LOCK_DIR/lftpLock || exit 1

flock -n "$lock_fd" || { echo "ERROR: flock() failed - existing lftp command already running." >&2; exit 1; }

lftp -u $SSH_USERNAME,$SSH_PASSWORD \
     -e "mirror --continue --verbose --delete --parallel=5 --use-pget-n=5 --exclude $EXCLUDE_1 --exclude $EXCLUDE_2 $SEEDBOX_SOURCE_DIR $TARGET_DIR; quit" \
     sftp://$SEEDBOX_HOSTNAME:$SSH_PORT #\
     #| ts '[%Y-%m-%d %H:%M:%S]' >> $SCRIPT_DIR/$LOG_FILENAME

flock -u "$lock_fd"


