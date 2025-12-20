#!/bin/bash
set -e

# Build the image
echo "Building the image..."
docker build -t localhost:5000/az-agent:latest .

# Push the image to the local registry
echo "Pushing the image to localhost:5000/az-agent:latest..."
docker push localhost:5000/az-agent:latest

echo "Done! You can now restart your agent with: docker compose up -d"
