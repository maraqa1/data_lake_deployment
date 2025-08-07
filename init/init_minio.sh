#!/bin/bash

# -------------------------------
# ✅ Ensure mc is installed
# -------------------------------
if ! command -v mc &> /dev/null; then
  echo "📦 Installing mc (MinIO Client)..."
  curl -s https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
  chmod +x /usr/local/bin/mc
fi

# -------------------------------
# ✅ Use MinIO credentials from .env
# -------------------------------
MINIO_URL=${MINIO_URL:-"http://localhost:9000"}
MINIO_USER=${MINIO_ROOT_USER:-"minioadmin"}
MINIO_PASS=${MINIO_ROOT_PASSWORD:-"minioadmin"}
BUCKET_NAME="airbyte-landing"

echo "⏳ Waiting for MinIO to be ready..."
until curl -s "$MINIO_URL/minio/health/live" > /dev/null; do
  sleep 2
done

# -------------------------------
# ✅ Set mc alias (non-interactive)
# -------------------------------
mc alias set local "$MINIO_URL" "$MINIO_USER" "$MINIO_PASS" >/dev/null 2>&1

# -------------------------------
# ✅ Create bucket (if not exists)
# -------------------------------
echo "✅ Creating MinIO bucket: $BUCKET_NAME"

if ! mc ls local/"$BUCKET_NAME" > /dev/null 2>&1; then
  mc mb -p local/"$BUCKET_NAME"
  mc policy set download local/"$BUCKET_NAME"
else
  echo "ℹ️ Bucket $BUCKET_NAME already exists. Skipping creation."
fi

echo "✅ MinIO bucket initialized."




