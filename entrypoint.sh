#!/bin/sh

SSH_KEY_FILE=${SSH_KEY_FILE:=/id_ed25519}

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
echo [INFO] Tunneling ${SSH_HOSTUSER:=root}@${SSH_HOSTNAME:=localhost}:${SSH_TUNNEL_REMOTE:=${DEFAULT_PORT}} to ${SSH_TUNNEL_HOST=localhost}:${SSH_TUNNEL_LOCAL:=22}
eval $(ssh-agent)
cat ${SSH_KEY_FILE} | ssh-add -k -
cmd="autossh"
cmd="$cmd -M 0"
cmd="$cmd -o StrictHostKeyChecking=${STRICT_HOSTS_KEY_CHECKING} ${KNOWN_HOSTS_ARG:=}"
cmd="$cmd -o ServerAliveInterval=5"
cmd="$cmd -o ServerAliveCountMax=1"
cmd="$cmd -o ExitOnForwardFailure=yes"
cmd="$cmd -t -t"
cmd="$cmd ${SSH_MODE:=-R} ${SSH_TUNNEL_REMOTE}:${SSH_TUNNEL_HOST}:${SSH_TUNNEL_LOCAL}"
cmd="$cmd -p ${SSH_HOSTPORT:=22}"
cmd="$cmd ${SSH_HOSTUSER}@${SSH_HOSTNAME}"
echo $cmd

AUTOSSH_PIDFILE=/autossh.pid \
AUTOSSH_POLL=10 \
AUTOSSH_LOGLEVEL=0 \
AUTOSSH_LOGFILE=/dev/stdout \
sh -c "$cmd"
