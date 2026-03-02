#!/bin/bash
# complete-task-waas.sh - Completes a task by its jobKey.
# (Tenant ID is not required for completion as the jobKey is unique).
#
# Usage: ./waasscripts/complete-task-waas.sh <jobKey>

if [ -z "$1" ]; then
  echo "Usage: ./complete-task-waas.sh <jobKey>"
  exit 1
fi

JOB_KEY=$1

echo "Completing task ${JOB_KEY}..."

curl -i -X POST "http://localhost:8080/v2/jobs/${JOB_KEY}/completion" \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{"variables": {}}'
