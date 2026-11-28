#!/bin/bash
## If using the "update-blacklist.sh" program's wget failed while running install-step-two, then
## open the website with a browser, download the blacklists.tar.gz file,
## move the tar.gz file to squidguard/db, then run this script.

receivedvalue=$1
if [ -z "$receivedvalue" ]; then
    echo "Parameter/argument variable is empty, changing the received value to '0' (OK to rebuild blacklist and whitelist)"
    receivedvalue=0
fi

# Dynamically resolve the directory where this script lives
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

# Safely load .env if present
if [ -f "$PROJECT_DIR/.env" ]; then
    set -a
    source "$PROJECT_DIR/.env"
    set +a
fi

cd "$PROJECT_DIR/squidguard/db" || { echo "Error: Directory $PROJECT_DIR/squidguard/db not found."; exit 1; }

## If tar file was manually pulled from website, it should have been copied from a Download folder to the squidguard/db folder
if [ "$receivedvalue" -eq 0 ]; then
    if [ ! -f blacklists.tar.gz ]; then
        echo "Error: blacklists.tar.gz not found in $PROJECT_DIR/squidguard/db."
        exit 1
    fi
    sudo tar -xvzf blacklists.tar.gz
    echo "Extraction of blacklist successful..."
else
    echo "Error during download of blacklists... running the rebuild using existing blacklist and whitelist only"
fi

cd "$PROJECT_DIR" || exit 1

## squidGuard needs the db folder to have proxy (UID 13) as owner in order to run.
sudo chown -R 13:13 "$PROJECT_DIR/squidguard"
echo "Performing rebuild of blacklists and whitelist in $PROJECT_DIR/squidguard..."
sudo docker compose exec -T squidguard squidGuard -d -C all

## Ensure newly generated .db files created as root are owned by proxy (UID 13)
sudo chown -R 13:13 "$PROJECT_DIR/squidguard"

## Reconfigure Squid to load the updated databases without dropping active connections
sudo docker compose exec -T squidguard squid -k reconfigure

echo "End of process of update-blacklist-part2.sh -- updating blacklists and whitelist..."
