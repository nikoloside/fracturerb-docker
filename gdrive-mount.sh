#!/bin/bash

# Install rclone if not already installed
if ! command -v rclone &> /dev/null; then
  echo "rclone not found. Installing rclone..."
  curl https://rclone.org/install.sh | sudo bash
  echo "rclone installed successfully."
else
  echo "rclone is already installed."
fi

CONFIG=config.json

# Setup the GDrive Path
RCLONE_REMOTE=$(jq -r .gdrive_name $CONFIG)
BULLET_REMOTE=$(jq -r .gdrive_bullet_path $CONFIG)
RESULT_REMOTE=$(jq -r .gdrive_result_path $CONFIG)
BULLET_LOCAL=$(jq -r .local_bullet_path $CONFIG)
RESULT_LOCAL=$(jq -r .local_result_path $CONFIG)

# Create GDrive Path
mkdir -p $BULLET_LOCAL $RESULT_LOCAL

# Check whtere it already exist, if so, unmount
if mountpoint -q $BULLET_LOCAL; then
  fusermount -u $BULLET_LOCAL
fi
if mountpoint -q $RESULT_LOCAL; then
  fusermount -u $RESULT_LOCAL
fi

# Re-mount, make sure bullet folder cached
rclone mount $RCLONE_REMOTE:$BULLET_REMOTE $BULLET_LOCAL --daemon --vfs-cache-mode full --allow-other
rclone mount $RCLONE_REMOTE:$RESULT_REMOTE $RESULT_LOCAL --daemon --vfs-cache-mode writes
