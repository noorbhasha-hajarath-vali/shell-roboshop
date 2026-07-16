#!/bin/bash

AMI_ID=ami-002192a70217ac181
SG_ID=sg-014ee579326daf5b9
DOMAIN="ayri.fun"

ZONE_ID=$(aws route53 list-hosted-zones-by-name \
    --dns-name "$DOMAIN" \
    --query "HostedZones[?Name=='$DOMAIN.'].Id | [0]" \
    --output text)

if [ "$ZONE_ID" = "None" ]; then
    echo "Hosted zone does not exist. Creating..."

    ZONE_ID=$(aws route53 create-hosted-zone \
        --name "$DOMAIN" \
        --caller-reference "$(date +%s)" \
        --query "HostedZone.Id" \
        --output text)

    echo "Hosted zone created successfully."
    echo "Hosted Zone ID: ${ZONE_ID#/hostedzone/}"
else
    echo "Hosted zone already exists."
    echo "Hosted Zone ID: ${ZONE_ID#/hostedzone/}"
fi


