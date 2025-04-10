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

# 读取路径
RCLONE_REMOTE=$(jq -r .gdrive_name $CONFIG)
BULLET_REMOTE=$(jq -r .gdrive_bullet_path $CONFIG)
RESULT_REMOTE=$(jq -r .gdrive_result_path $CONFIG)
BULLET_LOCAL=$(jq -r .local_bullet_path $CONFIG)
RESULT_LOCAL=$(jq -r .local_result_path $CONFIG)

# 创建挂载目录
mkdir -p $BULLET_LOCAL $RESULT_LOCAL

# 判断是否已经挂载，避免重复
mountpoint -q $BULLET_LOCAL || \
  rclone mount $RCLONE_REMOTE:$BULLET_REMOTE $BULLET_LOCAL --daemon --vfs-cache-mode writes

mountpoint -q $RESULT_LOCAL || \
  rclone mount $RCLONE_REMOTE:$RESULT_REMOTE $RESULT_LOCAL --daemon --vfs-cache-mode writes

touch "$BULLET_LOCAL/generated_file.txt"
echo "This is a generated file." > "$BULLET_LOCAL/generated_file.txt"
