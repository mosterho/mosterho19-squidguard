#!/bin/bash
TARGET_NAME="squidguard"

# Capture the running container ID
CONTAINER_ID=$(docker ps -q -f "name=${TARGET_NAME}")

# Verify that a container was actually found
if [ -z "$CONTAINER_ID" ]; then
    echo "Error: No running container found with the name '${TARGET_NAME}'."
    exit 1
fi

echo "$CONTAINER_ID"
