#!/bin/bash

LOG_DIR="/var/log/roboshop"
mkdir -p "$LOG_DIR"

FILE_NAME=$(basename "$0" .sh)
LOG_FILE="$LOG_DIR/$FILE_NAME.log"

exec &> >(tee -a "$LOG_FILE")

echo "====================================================================="
echo "Process Started At : $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "Script Name        : $FILE_NAME.sh"
echo "Log File           : $LOG_FILE"
echo "====================================================================="