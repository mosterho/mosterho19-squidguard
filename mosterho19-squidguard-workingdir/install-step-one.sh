#!/bin/bash

echo "This program will perform the first step to install mosterho19/squidguard."

while true; do
    # Ask the question
    read -p "Are you ready? (y/n): " y_n

    # Check the answer
    case "$y_n" in
        [Yy]* ) 
            echo "Creating mosterho19-docker-path.env to create temporary environment variable..." 
            echo "MOSTERHO19SQUIDGUARDPATH=$PWD" > mosterho19-docker-path.env
            export $(cat mosterho19-docker-path.env)
            echo "Docker pull..."
            sudo docker pull mosterho19/squidguard
            sudo docker pull httpd
            echo "Docker create..."
            sudo docker create --name squidguard  mosterho19/squidguard
            sudo docker create --name httpd  httpd
            sudo docker ps -a
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
