FROM alpine

ENTRYPOINT ["/entrypoint.sh"]
COPY ./entrypoint.sh /entrypoint.sh

ENV \
    TERM=xterm \
    AUTOSSH_LOGFILE=/dev/stdout \
    AUTOSSH_GATETIME=30         \
    AUTOSSH_POLL=10             \
    AUTOSSH_FIRST_POLL=30       \
    AUTOSSH_LOGLEVEL=1

RUN apk update && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    apk add \ 
      autossh \
      openssh-client

RUN rm -rf /var/cache/apk 
