#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backup all the movie folders to the external 10TB drive
rsync -a --delete /mnt/hdd2/tv_shows /mnt/hdd6/tv_shows_backup/ > $SCRIPT_DIR/local_tv_show_backups.log 2>&1