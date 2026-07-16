#!/bin/bash

AMI_ID=ami-002192a70217ac181
SG_ID=sg-014ee579326daf5b9
DOMAIN="ayri.fun"


for INSTANCE in "$@"
do
    aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t3.micro \
    --key-name devops \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE}]" \
    --query 'Instances[0].InstanceId' \
    --output text

    if [ "$INSTANCE" != "frontend" ]; then
        IP=$(aws ec2 describe-instances \
            --instance-ids i-0123456789abcdef0 \
            --query 'Reservations[0].Instances[0].PrivateIpAddress' \
            --output text)
        RECORD_NAME=$INSTANCE.$DOMAIN
            
    else
        IP=$(aws ec2 describe-instances \
            --instance-ids i-0123456789abcdef0 \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text)
        RECORD_NAME=$DOMAIN
    fi

    export DOMAIN
    export RECORD_NAME
    export IP

    sh dns_record.sh
done