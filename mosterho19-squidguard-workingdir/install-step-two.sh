#!/bin/bash

echo "This program will perform the second step to install mosterho19/squidguard."
export $(cat mosterho19-docker-path.env)
echo "Environment variable for path is: $MOSTERHO19SQUIDGUARDPATH"
#echo "You are currently in: $(pwd)"
cd "${MOSTERHO19SQUIDGUARDPATH}"

while true; do
    # Ask the question
    read -p "Are you ready? (y/n): " y_n

    # Check the answer
    case "$y_n" in
        [Yy]* ) 
            echo "Starting step two..."
            echo "You will see squidguard start, stop, and restart a couple times while building the blacklists"
            sudo bash ./start-squidguard.sh
            sudo bash ./update-blacklist.sh  # update-blacklist will restart the squid service.
            DOWNLOADRESULT=$?
            if [ $DOWNLOADRESULT -ne 0 ]; then
                echo "The download of the blacklists failed. Attempting last resort download from Azure Blob storage..."
                sudo bash last-resort-download.sh
                sudo bash update-blacklist-part2.sh  # module within update-blacklist.sh that will rebuild the blacklists and whitelist.
            fi
            break
            ;;
        [Nn]* ) 
            echo "Exiting script."
            # Place your "No" code here
            exit 0
            ;;
        * ) 
            echo "Please answer yes or no."
            ;;
    esac
done
