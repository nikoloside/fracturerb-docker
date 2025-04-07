FROM ubuntu:20.04

RUN apt update && apt install -y \
    git curl wget jq build-essential cmake python3

COPY entrypoint.sh /entrypoint.sh
COPY config.json /config.json

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]