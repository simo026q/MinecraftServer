#!/bin/bash

# Configuration
CONTAINER_NAME="minecraft-server"

echo "Attempting to stop Docker container '${CONTAINER_NAME}'..."

# Stop the Docker container
docker stop "${CONTAINER_NAME}"

if [ $? -eq 0 ]; then
    echo "Container '${CONTAINER_NAME}' stopped successfully."
else
    echo "Error: Failed to stop container '${CONTAINER_NAME}'. It might not be running or does not exist."
    exit 1
fi