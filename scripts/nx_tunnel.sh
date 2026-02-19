#!/bin/bash

PROXY_HOST=""
TARGET_HOST="172.19.78.76"
LOCAL_PORT=40001
REMOTE_PORT=4000
PIDFILE="/tmp/nomachine_tunnel.pid"

start_tunnel() {
  echo "Starting SSH tunnel to $TARGET_HOST via $PROXY_HOST ..."
  ssh -f -N -L ${LOCAL_PORT}:${TARGET_HOST}:${REMOTE_PORT} ${PROXY_HOST}
  echo $! > "$PIDFILE"
  echo "Tunnel started: localhost:${LOCAL_PORT} → ${TARGET_HOST}:${REMOTE_PORT}"
  echo "Use NoMachine to connect to localhost:${LOCAL_PORT}"
}

stop_tunnel() {
  if [ -f "$PIDFILE" ]; then
    PID=$(cat "$PIDFILE")
    echo "Stopping SSH tunnel (PID $PID)..."
    kill "$PID" && rm "$PIDFILE"
    echo "Tunnel stopped."
  else
    echo "No tunnel is currently running."
  fi
}

case "$1" in
  start)
    start_tunnel
    ;;
  stop)
    stop_tunnel
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    ;;
esac
