#!/bin/bash

LOG_DIR="/var/log/shell-roboshop"

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/common.sh"

CHECK_ROOT

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copy MongoDB Repo"

dnf install mongodb-org -y
VALIDATE $? "Install MongoDB"

systemctl enable mongod
VALIDATE $? "Enable MongoDB"

systemctl start mongod
VALIDATE $? "Start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
VALIDATE $? "Update MongoDB Config"

systemctl restart mongod
VALIDATE $? "Restart MongoDB Service"

COMPLETE