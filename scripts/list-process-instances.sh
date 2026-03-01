#!/bin/bash
# list-process-instances.sh - Lists process instances with optional state filtering
#
# This script queries the /v2/process-instances/search endpoint.
# You can filter by state (ACTIVE, COMPLETED, CANCELED, INCIDENT).
#
# Usage: ./scripts/list-process-instances.sh [STATE]
# Example: ./scripts/list-process-instances.sh ACTIVE

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
