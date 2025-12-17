#!/bin/sh
set -e

BASE_ID=1
SOCKET_PATH=/tmp/envoy-restart.sock

exec envoy \
  --config-path /etc/envoy/envoy.yaml \
  --restart-epoch ${RESTART_EPOCH:-0} \
  --base-id $BASE_ID \
  --parent-shutdown-time-s 5 \
  --drain-time-s 5 \
  --log-level info

