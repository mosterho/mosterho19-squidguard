#!/bin/bash

echo "This program will perform the second step to install mosterho19/squidguard."
export $(cat mosterho19-docker-path.env)
#echo "You are currently in: $(pwd)"

while true; do
    # Ask the question
    read -p "Are you ready? (y/n): " y_n

    # Check the answer
    case "$y_n" in
        [Yy]* ) 
            echo "Starting step two..."
            echo "Environment variable for path is: $MOSTERHO19SQUIDGUARDPATH"
            sudo bash ./start-squidguard.sh
            sudo bash ./update-blacklist.sh
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
