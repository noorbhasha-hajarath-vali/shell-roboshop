#!/bin/bash

LOG_DIR="/var/log/shell-roboshop"
FILE_NAME=$(basename "$0" .sh)
LOG_FILE="$LOG_DIR/$FILE_NAME.log"

mkdir -p "$LOG_DIR"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "=================================================================="
echo "Process Started At : $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "Script Name        : $FILE_NAME.sh"
echo "Log File           : $LOG_FILE"
echo "=================================================================="

CHECK_ROOT() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "ERROR: Please run this script as root."
        exit 1
    fi
}

VALIDATE() {
    if [ "$1" -ne 0 ]; then
        echo "$2 ... FAILED"
        exit 1
    else
        echo "$2 ... SUCCESS"
    fi
}

COMPLETE() {
    echo "=================================================================="
    echo "Process Completed At : $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo "=================================================================="
}