#!/usr/bin/env sh

SSH_KEY_FILE=${SSH_KEY_FILE:=/id_ed25519}
SSH_HOSTUSER=${SSH_HOSTUSER:=root}
SSH_HOSTNAME=${SSH_HOSTNAME:=localhost}
SSH_HOSTPORT=${SSH_HOSTPORT:=22}

touch $SSH_KEY_FILE
chmod 0400 $SSH_KEY_FILE

STRICT_HOSTS_KEY_CHECKING=no
KNOWN_HOSTS=${SSH_KNOWN_HOSTS:=/known_hosts}
if [ -f "${KNOWN_HOSTS}" ]; then
  chmod 0400 ${KNOWN_HOSTS}
  KNOWN_HOSTS_ARG="-o UserKnownHostsFile=${KNOWN_HOSTS}"
  STRICT_HOSTS_KEY_CHECKING=yes
fi

# Pick a random port above 32768
DEFAULT_PORT=$RANDOM
let "DEFAULT_PORT += 32768"
SSH_TUNNEL_MODE=${SSH_TUNNEL_MODE:=-R}
SSH_TUNNEL_FROM_PORT=${SSH_TUNNEL_FROM_PORT:=22}
SSH_TUNNEL_TO_PORT=${SSH_TUNNEL_TO_PORT:=${DEFAULT_PORT}}

echo [INFO] Hook ${SSH_TUNNEL_FROM_HOST}:${SSH_TUNNEL_FROM_PORT} To ${SSH_HOSTUSER}@${SSH_HOSTNAME}:${SSH_TUNNEL_TO_PORT}

eval $(ssh-agent)
cat ${SSH_KEY_FILE} | ssh-add -k -
cmd="autossh"
cmd="$cmd -M 0"
cmd="$cmd -o StrictHostKeyChecking=${STRICT_HOSTS_KEY_CHECKING} ${KNOWN_HOSTS_ARG:=}"
cmd="$cmd -o ServerAliveInterval=30"
cmd="$cmd -o ServerAliveCountMax=1"
cmd="$cmd -o ExitOnForwardFailure=yes"
cmd="$cmd -t -t"
cmd="$cmd ${SSH_TUNNEL_MODE} ${SSH_TUNNEL_TO_PORT}:${SSH_TUNNEL_FROM_HOST}:${SSH_TUNNEL_FROM_PORT}"
cmd="$cmd -p ${SSH_HOSTPORT}"
cmd="$cmd ${SSH_HOSTUSER}@${SSH_HOSTNAME}"
echo $cmd

AUTOSSH_PIDFILE=/autossh.pid \
  AUTOSSH_POLL=10 \
  AUTOSSH_LOGLEVEL=0 \
  AUTOSSH_LOGFILE=/dev/stdout \
  sh -c "$cmd"
