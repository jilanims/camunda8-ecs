#!/bin/bash
# complete-task.sh - Complete a user task by job key
# Usage: ./complete-task.sh <jobKey>
if [ -z "$1" ]; then
  echo "Usage: ./complete-task.sh <jobKey>"
  exit 1
fi
JOB_KEY=$1
curl -i -X POST "http://localhost:8080/v2/jobs/${JOB_KEY}/completion" \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{"variables": {}}'
