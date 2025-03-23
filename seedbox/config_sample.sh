
# Seedbox informaiton
SEEDBOX_HOSTNAME="<seedbox.hostname>"
SSH_USERNAME="<seedbox.username>"
SSH_PASSWORD="<seedbox.password>"
SSH_PORT="22"
SEEDBOX_SOURCE_DIR="downloads/qbittorrent/"

# Add as many excludes here as you like, but you will need to 
# update the lftp options to include each one.
EXCLUDE_1="temp/"
EXCLUDE_2="freeleech/"

# Where would you like lftp to place the downloads and maintain
# syncronization?
TARGET_DIR="${HOME}/seedbox_test/downloads/"

# Where do you want the log file placed
LOG_DIR="${HOME}/scripts/seedbox/logs"
LOG_FILENAME="seedbox_lftp.log"

# Where would you like the lock file?
LOCK_DIR="${HOME}/lock"