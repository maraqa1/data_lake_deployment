#!/bin/bash

set -e

echo "🔧 Starting containers..."
docker compose --env-file .env up -d

echo "⏳ Waiting for services..."
sleep 20

echo "⚙️ Running MinIO init..."
chmod +x init/init_minio.sh
./init/init_minio.sh

echo "✅ All services running."
