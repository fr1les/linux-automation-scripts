#!/bin/bash

# ==============================================================================
# Script Name: db_backup_alert.sh
# Description: Automates PostgreSQL database backup, compresses the dump, 
#              and sends a Telegram alert via webhook if the process fails.
# Author: IT Infrastructure Engineer
# ==============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# --- Configuration ---
DB_NAME="production_db"
DB_USER="postgres"
BACKUP_DIR="/var/backups/postgresql"
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_${DATE}.sql.gz"
RETENTION_DAYS=7

# Telegram Alert Configuration
TELEGRAM_BOT_TOKEN="YOUR_BOT_TOKEN_HERE"
TELEGRAM_CHAT_ID="YOUR_CHAT_ID_HERE"

# --- Functions ---
send_telegram_alert() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="🚨 [ALARM] Database Backup Failed!
Server: $(hostname)
Database: ${DB_NAME}
Error: ${message}" > /dev/null
}

# --- Main Execution ---
echo "Starting backup for database: $DB_NAME at $(date)"

# 1. Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# 2. Execute pg_dump and compress. If it fails, catch the error.
if ! pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"; then
    echo "Error: pg_dump failed!"
    send_telegram_alert "pg_dump command execution failed for $DB_NAME."
    exit 1
fi

echo "Backup successfully created: $BACKUP_FILE"

# 3. Clean up old backups (older than RETENTION_DAYS)
echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -type f -name "${DB_NAME}_backup_*.sql.gz" -mtime +$RETENTION_DAYS -exec rm {} \;

echo "Backup process completed successfully."
exit 0
