#!/bin/bash
# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
  echo "Docker not found. Installing Docker..."
  apt-get update -y
  apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
  apt-get update -y
  apt-get install -y docker-ce
  echo "Docker installed successfully."
else
  echo "Docker is already installed."
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "jq not found. Installing jq..."
  apt-get update -y
  apt-get install -y jq
  echo "jq installed successfully."
else
  echo "jq is already installed."
fi

# Pull Docker Image
docker pull nikoloside/fracturerb-ubuntu:latest

# Configuration
CONFIG_PATH=config.json
BULLET_LOCAL=$(jq -r .local_bullet_path $CONFIG_PATH)
RESULT_LOCAL=$(jq -r .local_result_path $CONFIG_PATH)

# Setup GDrive Rclone Mounting
chmod +x gdrive-mount.sh
./gdrive-mount.sh

# Create the container of docker
docker run \
  --name fracturerb \
  --mount "type=bind,src=$BULLET_LOCAL,dst=/app/bullet" \
  --mount "type=bind,src=$RESULT_LOCAL,dst=/app/results" \
  -v "$(pwd)/execFracture.sh:/app/execFracture.sh" \
  -v "$(pwd)/config.json:/app/config.json" \
  --ipc=host \
  -dit \
  nikoloside/fracturerb-ubuntu:latest \
  /bin/bash

docker exec -it fracturerb /bin/bash -c "cd /Workspace/FractureRB-with-hyena/build && make && export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib && cd /app/ && bash /app/execFracture.sh"