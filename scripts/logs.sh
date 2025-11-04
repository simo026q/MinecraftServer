#!/bin/bash

# Configuration
CONTAINER_NAME="minecraft-server"

echo "Attaching to logs of Docker container '${CONTAINER_NAME}'. Press Ctrl+C to exit."

# Follow logs of the Docker container
docker logs -f "${CONTAINER_NAME}"

if [ $? -eq 0 ]; then
    echo "Exited logs for '${CONTAINER_NAME}'."
else
    echo "Error: Failed to retrieve logs for container '${CONTAINER_NAME}'. It might not be running or does not exist."
    exit 1
fi