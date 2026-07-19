#!/bin/bash

LOG_DIR="/var/log/shell-roboshop"

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/common.sh"

CHECK_ROOT

MONGODB_HOST="mongodb.ayri.fun"

curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -

dnf install -y nodejs

if ! id roboshop &>/dev/null; then
    useradd --system \
        --home /app \
        --shell /sbin/nologin \
        --comment "roboshop system user" \
        roboshop
else
    echo "Roboshop User Already Exists"
fi

mkdir -p /app

curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip

cd /app

unzip -o /tmp/catalogue.zip

npm install

cp "$SCRIPT_DIR/catalogue.service" /etc/systemd/system/catalogue.service

systemctl daemon-reload

systemctl enable catalogue

systemctl start catalogue

cp "$SCRIPT_DIR/mongo.repo" /etc/yum.repos.d/mongo.repo

dnf install -y mongodb-mongosh

mongosh --host "$MONGODB_HOST" </app/db/master-data.js

systemctl restart catalogue

echo "Catalogue Setup Completed"

COMPLETE