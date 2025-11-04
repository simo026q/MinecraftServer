#!/bin/bash

# Configuration
IMAGE_NAME="simo026q/minecraft-vanilla-server" # IMPORTANT: Update with your Docker Hub username or desired image name
IMAGE_TAG="v1.0.0"
DEFAULT_MIN_MEM="2G"
DEFAULT_MAX_MEM="4G"

# Parse command line arguments
MIN_MEM_ARG=${1:-$DEFAULT_MIN_MEM}
MAX_MEM_ARG=${2:-$DEFAULT_MAX_MEM}

echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
echo "Memory allocated: MIN_MEM=${MIN_MEM_ARG}, MAX_MEM=${MAX_MEM_ARG}"
echo "Building from Dockerfile in current directory..."

# Build the Docker image
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" \
    --build-arg MIN_MEM="${MIN_MEM_ARG}" \
    --build-arg MAX_MEM="${MAX_MEM_ARG}" .

if [ $? -eq 0 ]; then
    echo "Docker image built successfully: ${IMAGE_NAME}:${IMAGE_TAG}"
else
    echo "Error: Docker image build failed."
    exit 1
fi

echo "To push to Docker Hub (or other registry), run: "
echo "  docker push ${IMAGE_NAME}:${IMAGE_TAG}"