FROM alpine:3.23
RUN apk add --no-cache fish inotify-tools py3-pip nmap-ncat && \
    pip3 install jinja2-cli --break-system-packages
ADD files /
ENTRYPOINT [ "/entrypoint" ]
