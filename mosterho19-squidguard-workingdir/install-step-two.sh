#!/bin/bash

echo "This program will perform the second step to install mosterho19/squidguard."

# Dynamically resolve the directory where this script lives
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
echo "Project directory is: $PROJECT_DIR"
cd "$PROJECT_DIR" || { echo "Error: Could not change to $PROJECT_DIR"; exit 1; }

# Safely load .env if present
if [ -f "$PROJECT_DIR/.env" ]; then
    set -a
    source "$PROJECT_DIR/.env"
    set +a
fi

while true; do
    read -p "Are you ready? (y/n): " y_n

    case "$y_n" in
    [Yy]*)
        echo "Starting step two..."
        echo "You will see squidguard start, stop, and restart a couple times while building the blacklists."
        
        sudo docker compose up -d
        
        sudo bash "$PROJECT_DIR/update-blacklist.sh"
        DOWNLOADRESULT=$?
        
        if [ $DOWNLOADRESULT -ne 0 ]; then
            echo "The download of the blacklists failed. Attempting last resort download from Azure Blob storage..."
            sudo bash "$PROJECT_DIR/last-resort-download.sh"
            DOWNLOADRESULT2=$?
            
            if [ $DOWNLOADRESULT2 -ne 0 ]; then
                echo "The last resort download also failed. Please check your internet connection and try again."
                exit 1
            fi
            
            # Rebuild the blacklists and whitelist using the last-resort archive
            sudo bash "$PROJECT_DIR/update-blacklist-part2.sh" "$DOWNLOADRESULT2"
        fi
        
        echo "Step two complete! SquidGuard and WPAD are up and running."
        break
        ;;
    [Nn]*)
        echo "Exiting script."
        exit 0
        ;;
    *)
        echo "Please answer yes or no."
        ;;
    esac
done
