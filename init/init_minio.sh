#!/bin/bash

# Ensure mc is installed
if ! command -v mc &> /dev/null; then
  echo "📦 Installing mc (MinIO client)..."
  curl -s https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
  chmod +x /usr/local/bin/mc
fi

# Environment variables fallback
MINIO_URL=${MINIO_URL:-"http://localhost:9000"}
MINIO_USER=${MINIO_ROOT_USER:-"minioadmin"}
MINIO_PASS=${MINIO_ROOT_PASSWORD:-"minioadmin"}
BUCKET_NAME="airbyte-landing"

export MC_HOST_local="${MINIO_URL}/${MINIO_USER}:${MINIO_PASS}"

echo "⏳ Waiting for MinIO to be ready..."
until curl -s "$MINIO_URL/minio/health/live" > /dev/null; do sleep 2; done

echo "✅ Creating MinIO bucket: $BUCKET_NAME"
mc alias set local "$MINIO_URL" "$MINIO_USER" "$MINIO_PASS"
mc mb -p "local/$BUCKET_NAME" || echo "⚠️ Bucket already exists"
mc policy set download "local/$BUCKET_NAME" || echo "⚠️ Policy set may have failed or already set"

echo "✅ MinIO bucket initialized."


