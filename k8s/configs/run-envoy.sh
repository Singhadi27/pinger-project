#!/bin/sh

ENVOY_BIN=/usr/local/bin/envoy
CONFIG=/etc/envoy/envoy.yaml
BASE_ID=0

exec $ENVOY_BIN \
  -c $CONFIG \
  --restart-epoch 0 \
  --base-id $BASE_ID \
  --log-level info \
  --disable-hot-restart=false

