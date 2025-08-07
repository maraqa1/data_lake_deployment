#!/bin/bash

# -------------------------------
# ✅ Install mc if not available
# -------------------------------
if ! command -v mc &> /dev/null; then
  echo "📦 Installing mc (MinIO Client)..."
  curl -s https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
  chmod +x /usr/local/bin/mc
fi

# -------------------------------
# ✅ Load env or defaults
# -------------------------------
MINIO_URL=${MINIO_URL:-"http://localhost:9000"}
MINIO_USER=${MINIO_ROOT_USER:-"minioadmin"}
MINIO_PASS=${MINIO_ROOT_PASSWORD:-"minioadmin"}
BUCKET_NAME="airbyte-landing"

# -------------------------------
# ✅ Wait until MinIO is healthy
# -------------------------------
echo "⏳ Waiting for MinIO to be ready..."
until curl -s "${MINIO_URL}/minio/health/live" > /dev/null; do
  sleep 2
done

# -------------------------------
# ✅ Create alias without prompt
# -------------------------------
echo "✅ Creating mc alias..."
mc alias set --quiet local "$MINIO_URL" "$MINIO_USER" "$MINIO_PASS"

# -------------------------------
# ✅ Create bucket only if missing
# -------------------------------
echo "✅ Creating bucket: $BUCKET_NAME"
if ! mc ls local/"$BUCKET_NAME" > /dev/null 2>&1; then
  mc mb -p local/"$BUCKET_NAME"
  mc policy set download local/"$BUCKET_NAME"
  echo "✅ Bucket $BUCKET_NAME created and set to public download."
else
  echo "ℹ️ Bucket $BUCKET_NAME already exists. Skipping creation."
fi

echo "✅ MinIO bucket initialized."





