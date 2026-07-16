#!/bin/bash

ZONE_ID=$(aws route53 list-hosted-zones-by-name \
    --dns-name "$DOMAIN" \
    --query "HostedZones[?Name=='$DOMAIN.'].Id | [0]" \
    --output text)

if [ "$ZONE_ID" = "None" ]; then
    ZONE_ID=$(aws route53 create-hosted-zone \
        --name "$DOMAIN" \
        --caller-reference "$(date +%s)" \
        --query "HostedZone.Id" \
        --output text)
fi

ZONE_ID=${ZONE_ID#/hostedzone/}

cat >/tmp/record.json <<EOF
{
  "Comment": "UPSERT A Record",
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "$RECORD_NAME",
      "Type": "A",
      "TTL": 300,
      "ResourceRecords": [{
        "Value": "$IP"
      }]
    }
  }]
}
EOF

aws route53 change-resource-record-sets \
    --hosted-zone-id "$ZONE_ID" \
    --change-batch file:///tmp/record.json \
    >/dev/null

echo "DNS Updated : $RECORD_NAME -> $IP"