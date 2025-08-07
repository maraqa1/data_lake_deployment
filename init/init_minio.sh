#!/bin/bash

export MC_HOST_local="http://${MINIO_ROOT_USER}:${MINIO_ROOT_PASSWORD}@localhost:9000"

echo "⏳ Waiting for MinIO to be ready..."
until curl -s http://localhost:9000/minio/health/live; do sleep 2; done

echo "✅ Creating MinIO bucket: airbyte-landing"
mc alias set local http://localhost:9000 ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}
mc mb -p local/airbyte-landing
mc policy set download local/airbyte-landing

echo "✅ MinIO bucket initialized."
