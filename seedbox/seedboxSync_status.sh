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

lftp -u $SSH_USERNAME,$SSH_PASSWORD \
     -e "set cmd:show-status true; mirror --continue --verbose $SEEDBOX_SOURCE_DIR $TARGET_DIR; quit" \
     sftp://$SEEDBOX_HOSTNAME:$SSH_PORT #\
