#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backup all the movie folders to the external 10TB drive
rsync -a --delete /mnt/hdd1/movies /mnt/hdd1/movies_holiday /mnt/hdd1/movies_kids /mnt/hdd5/movies_backup/ > $SCRIPT_DIR/local_movie_backups.log 2>&1