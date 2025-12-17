#!/bin/bash
set -e

OLD_SERVICE=$1
NEW_SERVICE=$2
OLD_WEIGHT=$3
NEW_WEIGHT=$4

ENVOY_CONFIG=envoy-sidecar-frontend.yaml
TMP_FILE=/tmp/envoy.yaml.tmp

if [ $# -ne 4 ]; then
  echo "Usage: $0 <old_service> <new_service> <old_weight> <new_weight>"
  exit 1
fi

echo "🔁 Shifting traffic:"
echo "   $OLD_SERVICE -> $OLD_WEIGHT%"
echo "   $NEW_SERVICE -> $NEW_WEIGHT%"

# Replace weights using sed
sed \
  -e "s/name: ${OLD_SERVICE}[[:space:]]*weight: [0-9]*/name: ${OLD_SERVICE}\n            weight: ${OLD_WEIGHT}/" \
  -e "s/name: ${NEW_SERVICE}[[:space:]]*weight: [0-9]*/name: ${NEW_SERVICE}\n            weight: ${NEW_WEIGHT}/" \
  $ENVOY_CONFIG > $TMP_FILE

mv $TMP_FILE $ENVOY_CONFIG

echo "✅ Envoy config updated"

echo "♻️  Applying ConfigMap (hot reload will handle rest)"
kubectl create configmap envoy-frontend-config \
  --from-file=envoy.yaml=$ENVOY_CONFIG \
  --from-file=run-envoy.sh=run-envoy.sh \
  -o yaml --dry-run=client | kubectl apply -f -

echo "🚀 Traffic shift applied successfully"

