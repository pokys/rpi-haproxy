#!/bin/bash

#
# start.bash
#

HAPROXY="/etc/haproxy"
OVERRIDE="/haproxy-override"
PIDFILE="/var/run/haproxy.pid"

CONFIG="haproxy.cfg"
ERRORS="errors"

cd "$HAPROXY"

# Symlink errors directory
if [[ -d "$OVERRIDE/$ERRORS" ]]; then
  mkdir -p "$OVERRIDE/$ERRORS"
  rm -fr "$ERRORS"
  ln -s "$OVERRIDE/$ERRORS" "$ERRORS"
fi

# Symlink config file.
if [[ -f "$OVERRIDE/$CONFIG" ]]; then
  rm -f "$CONFIG"
  ln -s "$OVERRIDE/$CONFIG" "$CONFIG"
fi

quitall () {
  kill -TERM $(cat $PIDFILE)
} 

if [ $# -eq 0 ]; then
  trap 'quitall ' TERM INT
  haproxy -f /etc/haproxy/haproxy.cfg -p "$PIDFILE"
else
  haproxy -f /etc/haproxy/haproxy.cfg -p "$PIDFILE" -sf $(cat $PIDFILE)
fi