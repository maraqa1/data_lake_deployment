#!/bin/bash

# -------------------------------
# ✅ Ensure MinIO client (mc) is installed
# -------------------------------
if ! command -v mc &> /dev/null; then
  echo "📦 Installing mc (MinIO Client)..."
  curl -s https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
  chmod +x /usr/local/bin/mc
fi

# -------------------------------
# ✅ Setup environment variables
# -------------------------------
MINIO_URL=${MINIO_URL:-"http://localhost:9000"}
MINIO_USER=${MINIO_ROOT_USER:-"minioadmin"}
MINIO_PASS=${MINIO_ROOT_PASSWORD:-"minioadmin"}
BUCKET_NAME="airbyte-landing"

export MC_HOST_local="${MINIO_URL}/${MINIO_USER}:${MINIO_PASS}"

# -------------------------------
# ✅ Wait for MinIO to be alive
# -------------------------------
echo "⏳ Waiting for MinIO to be ready..."
until curl -s "$MINIO_URL/minio/health/live" > /dev/null; do
  sleep 2
done

# -------------------------------
# ✅ Create bucket & set policy
# -------------------------------
echo "✅ Creating MinIO bucket: $BUCKET_NAME"

# Set alias with non-interactive credentials
mc alias set local "$MINIO_URL" "$MINIO_USER" "$MINIO_PASS" >/dev/null

# Create bucket if it doesn't exist
mc ls local/"$BUCKET_NAME" >/dev/null 2>&1 || mc mb -p local/"$BUCKET_NAME"

# Set policy (public download access)
mc policy set download local/"$BUCKET_NAME" || echo "⚠️ Policy already set."

echo "✅ MinIO bucket initialized."



