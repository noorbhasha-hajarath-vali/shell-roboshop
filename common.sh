#!/bin/bash

# ==========================================================
# Strict Mode
# ==========================================================

set -Eeuo pipefail

ERROR_HANDLER() {
    echo >&3
    echo "ERROR: Command Failed" >&3
    echo "Line    : $1" >&3
    echo "Command : $2" >&3
    echo "Log File: $LOG_FILE" >&3

    echo
    echo "ERROR: Command Failed"
    echo "Line    : $1"
    echo "Command : $2"
}

trap 'ERROR_HANDLER $LINENO "$BASH_COMMAND"' ERR

# ==========================================================
# Logging
# ==========================================================

LOG_DIR=${LOG_DIR:-"$HOME/shell-roboshop/logs"}

FILE_NAME=$(basename "$0" .sh)
LOG_FILE="$LOG_DIR/$FILE_NAME.log"

mkdir -p "$LOG_DIR"

# Save original stdout/stderr
exec 3>&1 4>&2

# Redirect everything else to log file
exec >>"$LOG_FILE" 2>&1

echo "=================================================================="
echo "Process Started At : $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "Script Name        : $FILE_NAME.sh"
echo "Log File           : $LOG_FILE"
echo "=================================================================="

# ==========================================================
# Root Check
# ==========================================================

CHECK_ROOT() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "ERROR: Please run this script as root." >&3
        echo "ERROR: Please run this script as root."
        exit 1
    fi
}

# ==========================================================
# Complete
# ==========================================================

COMPLETE() {
    echo "=================================================================="
    echo "Process Completed At : $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo "=================================================================="

    echo >&3
    echo "Process Completed Successfully." >&3
    echo "Log File : $LOG_FILE" >&3
}