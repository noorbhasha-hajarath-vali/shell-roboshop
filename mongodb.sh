#!/bin/bash

USER_ID=$(id -u)

LOG_DIR=/var/log/shell-roboshop
LOG_FILE=$(basename $? .txt)

echo $LOG_FILE