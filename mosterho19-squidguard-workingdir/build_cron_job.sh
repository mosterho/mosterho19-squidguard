#!/bin/bash

# Define the absolute path to your blacklist script
# (Change this path if your script lives somewhere else)
export $(cat mosterho19-docker-path.env)
my_pwd=$MOSTERHO19SQUIDGUARDPATH
cd "$my_pwd"

SCRIPT_PATH="${MOSTERHO19SQUIDGUARDPATH}/update-blacklist.sh"
LOG_PATH="/var/log/update-blacklist.log"

# Verify the script actually exists before adding it to cron
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "ERROR: Could not find $SCRIPT_PATH"
    echo "Please make sure your blacklist script is in the correct location first."
    exit 1
fi

# Make sure the target script is executable
##sudo chmod +x "$SCRIPT_PATH"
sudo chmod 777 ${LOG_PATH}

# Define the cron line (runs every 5 minutes, redirects stdout and stderr to the log)
CRON_LINE="*/5 * * * * sudo bash $SCRIPT_PATH >> $LOG_PATH 2>&1"

# Check if the cron job is already installed to prevent duplicates
if sudo crontab -l 2>/dev/null | grep -Fq "$SCRIPT_PATH"; then
    echo "The cron job for $SCRIPT_PATH is already installed."
else
    echo "Installing 5-minute cron job for $SCRIPT_PATH..."
    # Export current crontab, append the new line, and reload it into root
    (sudo crontab -l 2>/dev/null; echo "$CRON_LINE") | sudo crontab -
    echo "SUCCESS: Cron job installed successfully."
fi

echo "Current root crontab active jobs:"
sudo crontab -l
