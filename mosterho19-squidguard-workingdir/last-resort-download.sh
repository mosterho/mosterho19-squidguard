#!/bin/bash

export $(cat mosterho19-docker-path.env)
my_pwd=$MOSTERHO19SQUIDGUARDPATH
cd "$my_pwd/squidguard/db"

# Define variables
URL="https://blacklistdownload.blob.core.windows.net/blacklist-copy-dsi-ut-capitole/blacklists.tar.gz"

OUTPUT_NAME="blacklists.tar.gz"

echo "Starting Last Resort Download of blacklist from Azure Blob..."

# Download the file
wget -q --show-progress "$URL" -O "$OUTPUT_NAME"

# Check if the download succeeded
if [ $? -eq 0 ]; then
    echo "Last Resort Download of blacklist is complete: $OUTPUT_NAME"
else
    echo "Error: Last Resort Download of blacklist failed."
    exit 1
fi
