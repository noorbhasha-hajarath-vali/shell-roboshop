#!/bin/bash

LOG_DIR="/var/log/shell-roboshop"

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/common.sh"

CHECK_ROOT

cp "$SCRIPT_DIR/mongo.repo" /etc/yum.repos.d/mongo.repo

dnf install -y mongodb-org

systemctl enable mongod

systemctl start mongod

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

systemctl restart mongod

echo "MongoDB Setup Completed"

COMPLETE