#!/bin/bash
# complete-task.sh - Complete a user task by its job key
#
# In Camunda 8.9 REST API (v2), user tasks are often handled as jobs
# when using the RDBMS/H2 exporter.
#
# Usage: ./complete-task.sh <jobKey>
#
# Example:
#   ./scripts/complete-task.sh 2251799813685398

if [ -z "$1" ]; then
  echo "Usage: ./complete-task.sh <jobKey>"
  exit 1
fi

JOB_KEY=$1

echo "Completing task with jobKey: ${JOB_KEY}..."

curl -i -X POST "http://localhost:8080/v2/jobs/${JOB_KEY}/completion" \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{"variables": {}}'
