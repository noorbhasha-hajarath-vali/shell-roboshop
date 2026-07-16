#!/bin/bash

AMI_ID=ami-002192a70217ac181
SG_ID=sg-014ee579326daf5b9
DOMAIN="ayri.fun"

ZONE_ID=$(aws route53 list-hosted-zones-by-name \
    --dns-name "$DOMAIN" \
    --query "HostedZones[?Name=='$DOMAIN.'].Id | [0]" \
    --output text)

echo "$ZONE_ID"