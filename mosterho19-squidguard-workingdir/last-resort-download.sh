#!/bin/bash
## This script will download the blacklists.tar.gz file from Azure Blob storage.
## This script will be called only from the install-step-two.sh script if the wget command pointing to ftp://ftp.ut-capitole.fr failed.

# Dynamically resolve the directory where this script lives
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

# Safely load .env if present
if [ -f "$PROJECT_DIR/.env" ]; then
    set -a
    source "$PROJECT_DIR/.env"
    set +a
fi

cd "$PROJECT_DIR/squidguard/db" || { echo "Error: Directory $PROJECT_DIR/squidguard/db not found."; exit 1; }

# Define variables
URL="https://blacklistdownload.blob.core.windows.net/blacklist-copy-dsi-ut-capitole/blacklists.tar.gz"
OUTPUT_NAME="blacklists.tar.gz"

echo "Starting Last Resort Download of blacklist from Azure Blob..."

# Download the file
wget -dv --show-progress "$URL" -O "$OUTPUT_NAME"
exitcode=$?

# Check if the download succeeded
if [ $exitcode -eq 0 ]; then
    echo "Last Resort Download of blacklist is complete: $OUTPUT_NAME"
else
    echo "Error: Last Resort Download of blacklist failed."
    exit 1
fi
