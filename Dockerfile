ARG VERSION=${VERSION:-[VERSION]}

FROM alpine:3.17

ARG VERSION

# apk
COPY ./install-packages.sh /usr/local/bin/install-packages
RUN apk update \
  && INSTALL_VERSION=$VERSION install-packages \
  && rm /usr/local/bin/install-packages;

# https://linux.die.net/man/1/autossh
ENV \
    AUTOSSH_PIDFILE=/autossh.pid \
    AUTOSSH_LOGFILE=/dev/stdout  \
    AUTOSSH_GATETIME=0           \
    AUTOSSH_POLL=120             \
    AUTOSSH_FIRST_POLL=30        \
    AUTOSSH_LOGLEVEL=7
COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
