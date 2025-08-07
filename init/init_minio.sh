#!/bin/bash
set -euo pipefail

# Define environment variables if not already set
export MC_HOST_local="http://${MINIO_ROOT_USER}:${MINIO_ROOT_PASSWORD}@localhost:9000"

echo "⏳ Waiting for MinIO to be ready..."
until curl -s http://localhost:9000/minio/health/live; do
  sleep 2
done

# Ensure mc is installed
if ! command -v mc &> /dev/null; then
  echo "📦 Installing mc (MinIO client)..."
  curl -s https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
  chmod +x /usr/local/bin/mc
  echo "✅ mc installed successfully."
fi

# Set alias (safe to re-run)
echo "🔐 Setting up MinIO alias..."
mc alias set local http://localhost:9000 "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}" || true

# Create bucket (skip if exists)
echo "🪣 Creating bucket 'airbyte-landing'..."
if ! mc ls local/airbyte-landing &>/dev/null; then
  mc mb -p local/airbyte-landing
  echo "✅ Bucket created."
else
  echo "ℹ️ Bucket already exists."
fi

# Apply download policy
mc policy set download local/airbyte-landing

echo "✅ MinIO bucket initialized and ready."

