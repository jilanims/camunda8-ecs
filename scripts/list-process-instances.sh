#!/bin/bash
# list-process-instances.sh
# Get all process instances (optionally filter by state: ACTIVE, COMPLETED, CANCELED)
STATE=${1:-""}

if [ -n "$STATE" ]; then
  FILTER="{\"filter\": {\"state\": \"${STATE}\"}}"
else
  FILTER="{}"
fi

curl -s -X POST http://localhost:8080/v2/process-instances/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "$FILTER" | python3 -m json.tool
