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
            sudo docker compose pull squidguard  ## This will pull the latest image from Docker Hub, but uses the service name in the yaml file.
            sudo docker compose pull httpd
            echo "Docker create..."
            sudo docker compose create squidguard
            sudo docker compose create httpd
            sudo docker compose ps -a
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
