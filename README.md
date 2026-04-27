# Linux Automation & Monitoring Scripts

A collection of Bash scripts for routine IT infrastructure automation, server monitoring, and backup management. 
Created to simplify daily operations and reduce manual toil in enterprise environments.

## 🛠 Tech Stack
* **OS:** Linux (Ubuntu / Debian / Oracle)
* **Language:** Bash
* **Tools:** PostgreSQL, cURL, CRON

## 📜 Included Scripts

### 1. Database Backup & Alerting (`db_backup_alert.sh`)
Automates PostgreSQL database dumps, compresses the output, and sends an alert to a Telegram channel via webhook if the process fails.

## 🚀 How to Use
Make the script executable:
`chmod +x db_backup_alert.sh`

Run via CRON or manually.
