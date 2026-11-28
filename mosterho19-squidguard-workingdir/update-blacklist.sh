#!/bin/bash
## Script to download the blacklists.tar.gz file from the ftp site and then run the update-blacklist-part2.sh script to extract and rebuild the blacklists and whitelist.
echo
echo "$(date): *** Begin of update-blacklist.sh script ***"

# Dynamically resolve the directory where this script lives
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional: Load standard .env if present (ignores comments and blank lines safely)
if [ -f "$PROJECT_DIR/.env" ]; then
    set -a
    source "$PROJECT_DIR/.env"
    set +a
fi

cd "$PROJECT_DIR/squidguard/db" || { echo "Error: Directory $PROJECT_DIR/squidguard/db not found."; exit 1; }

## The following wget is a bit fussy and doesn't always work. Please see "update-blacklist-part2.sh".
if [ -f blacklists.tar.gz ]; then
    sudo mv blacklists.tar.gz blacklists-backup.tar.gz
fi

sudo wget -dv --user anonymous --password anonymous@example.com ftp://ftp.ut-capitole.fr/pub/reseau/cache/squidguard_contrib/blacklists.tar.gz
exitcode=$?

if [ $exitcode -ne 0 ]; then
    echo "Error code ${exitcode}: wget failed to download the file."
    echo "*** See readme.md documentation to use an alternate method of downloading the blacklists using update-blacklist-part2.sh."
    if [ -f blacklists-backup.tar.gz ]; then
        sudo mv blacklists-backup.tar.gz blacklists.tar.gz
    fi
    exit 1
else
    echo "Download of blacklists.tar.gz successful!"
fi

cd "$PROJECT_DIR" || exit 1
sudo bash update-blacklist-part2.sh "$exitcode"
echo "$(date): *** End of update-blacklist.sh script ***"
