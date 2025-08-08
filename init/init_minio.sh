#!/bin/bash
set -euo pipefail

# Install mc if missing
if ! command -v mc &> /dev/null; then
  echo "Installing mc..."
  curl -s https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
  chmod +x /usr/local/bin/mc
fi

MINIO_URL=${MINIO_URL:-"http://localhost:9000"}
MINIO_USER=${MINIO_ROOT_USER:-"minioadmin"}
MINIO_PASS=${MINIO_ROOT_PASSWORD:-"minioadmin"}
BUCKET_NAME="airbyte-landing"

echo "Waiting for MinIO..."
until curl -s "${MINIO_URL}/minio/health/live" > /dev/null; do sleep 2; done

echo "Setting mc alias..."
mc alias set --quiet local "$MINIO_URL" "$MINIO_USER" "$MINIO_PASS"

echo "Ensuring bucket: $BUCKET_NAME"
if ! mc ls "local/$BUCKET_NAME" >/dev/null 2>&1; then
  mc mb -p "local/$BUCKET_NAME"
  mc policy set download "local/$BUCKET_NAME" || true
else
  echo "Bucket already exists."
fi

echo "MinIO init complete."




