#!/bin/bash
echo "This script will start the full ubuntu update process, including a \"full upgrade\""
echo -n "Are you sure you want to continue? (y/N): "

read answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get full-upgrade -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y
else
    echo "You chose no (or invalid input). Aborting..."
    exit 1
fi
