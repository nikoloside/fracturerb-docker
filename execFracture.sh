#!/bin/bash

echo "Running fracture process..."
# 这里是你真正跑 fracture 的命令，比如：
cd /app
./fracture-cli --input /app/bullet --output /app/results

rclone copy /app/results gdrive:SharedResults/$(hostname) --create-empty-src-dirs
