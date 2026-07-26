#!/bin/bash

PROXY_HOST="${PROXY_HOST:-}"
TARGET_HOST="${TARGET_HOST:-172.19.78.76}"
LOCAL_PORT="${LOCAL_PORT:-40001}"
REMOTE_PORT="${REMOTE_PORT:-4000}"
CONTROL_SOCKET="${NX_TUNNEL_SOCKET:-${XDG_RUNTIME_DIR:-/tmp}/nomachine_tunnel.${UID}.sock}"

require_proxy_host() {
  if [ -z "$PROXY_HOST" ]; then
    echo "PROXY_HOST is not set." >&2
    echo "Example: PROXY_HOST=user@proxy $0 start" >&2
    return 1
  fi
}

start_tunnel() {
  require_proxy_host || return 1

  if [ -S "$CONTROL_SOCKET" ] &&
     ssh -S "$CONTROL_SOCKET" -O check "$PROXY_HOST" >/dev/null 2>&1; then
    echo "Tunnel is already running."
    return 0
  fi

  if [ -S "$CONTROL_SOCKET" ]; then
    rm -f "$CONTROL_SOCKET"
  elif [ -e "$CONTROL_SOCKET" ]; then
    echo "Control socket path exists and is not a socket: $CONTROL_SOCKET" >&2
    return 1
  fi
  echo "Starting SSH tunnel to $TARGET_HOST via $PROXY_HOST ..."
  ssh -f -M -S "$CONTROL_SOCKET" \
    -o ExitOnForwardFailure=yes \
    -N -L "${LOCAL_PORT}:${TARGET_HOST}:${REMOTE_PORT}" \
    "$PROXY_HOST"
  echo "Tunnel started: localhost:${LOCAL_PORT} → ${TARGET_HOST}:${REMOTE_PORT}"
  echo "Use NoMachine to connect to localhost:${LOCAL_PORT}"
}

stop_tunnel() {
  require_proxy_host || return 1

  if [ -S "$CONTROL_SOCKET" ]; then
    echo "Stopping SSH tunnel..."
    ssh -S "$CONTROL_SOCKET" -O exit "$PROXY_HOST"
    rm -f "$CONTROL_SOCKET"
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
    exit 2
    ;;
esac
