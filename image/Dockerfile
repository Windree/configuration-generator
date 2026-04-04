FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y python3-pip && \
    pip3 install jinja2-cli --break-system-packages && \
    apt install -y inotify-tools && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*
ADD files /
ENTRYPOINT [ "./entrypoint.sh" ]
