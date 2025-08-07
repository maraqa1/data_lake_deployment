
# 📁 Persistent Volumes and Structure

This repository includes a clear folder structure aligned with deployment principles for a production-grade open-source data lake.

## Key Folders

- `volumes/pgdata/`: Stores PostgreSQL data for Airbyte metadata (persistent)
- `volumes/minio_data/`: Stores MinIO objects (e.g., raw sync files)
- `logs/`: Reserved for log outputs (e.g., Airbyte job logs)
- `backups/`: Future location for scheduled backups of DB and MinIO

All folders are included with `.gitkeep` or placeholders to ensure they're committed and tracked.

Make sure to mount these volumes correctly in your `docker-compose.yaml`.
