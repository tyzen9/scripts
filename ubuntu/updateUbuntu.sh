#!/bin/bash
echo "This script will start the full ubuntu update process, including a \"full upgrade\""
echo -n "Are you sure you want to continue? (y/N): "

read answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    apt-get update
    apt-get upgrade -y
    apt-get full-upgrade -y
    apt-get autoremove -y
    apt-get autoclean -y
else
    echo "You chose no (or invalid input). Aborting..."
    exit 1
fi
