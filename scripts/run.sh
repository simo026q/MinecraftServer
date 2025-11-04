#!/bin/bash

# Configuration
IMAGE_NAME="simo026q/minecraft-vanilla-server" # IMPORTANT: Must match the image name used in build.sh
IMAGE_TAG="v1.0.0" # Use 'latest' or a specific version you've built/pulled
CONTAINER_NAME="minecraft-server"
HOST_PORT="25565"
CONTAINER_PORT="25565"
DATA_DIR_HOST="${HOME}/minecraft-data" # Adjust if you want data elsewhere on your host
DATA_DIR_CONTAINER="/app/world"

# Ensure the data directory exists on the host
mkdir -p "${DATA_DIR_HOST}"

echo "Attempting to run Docker container '${CONTAINER_NAME}' from image '${IMAGE_NAME}:${IMAGE_TAG}'..."

# Check if container already exists
if docker ps -a --format '{{.Names}}' | grep -q "${CONTAINER_NAME}"; then
    echo "Container '${CONTAINER_NAME}' already exists. Attempting to start it..."
    docker start "${CONTAINER_NAME}"
    if [ $? -eq 0 ]; then
        echo "Container '${CONTAINER_NAME}' started successfully."
    else
        echo "Error: Failed to start existing container '${CONTAINER_NAME}'. It might be in a bad state. Consider 'docker rm ${CONTAINER_NAME}' if issues persist."
        exit 1
    fi
else
    echo "Container '${CONTAINER_NAME}' does not exist. Creating and starting new container..."
    docker run -d \
               --restart unless-stopped \
               -p "${HOST_PORT}":"${CONTAINER_PORT}" \
               --name "${CONTAINER_NAME}" \
               -v "${DATA_DIR_HOST}":"${DATA_DIR_CONTAINER}" \
               "${IMAGE_NAME}":"${IMAGE_TAG}"

    if [ $? -eq 0 ]; then
        echo "New container '${CONTAINER_NAME}' created and started successfully."
        echo "Minecraft data will be stored in: ${DATA_DIR_HOST}"
        echo "Logs can be viewed with: ./scripts/logs.sh"
    else
        echo "Error: Failed to create and start container '${CONTAINER_NAME}'."
        exit 1
    fi
fi