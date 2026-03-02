#!/bin/bash
# start-waas.sh - Starts a process instance in the 'waas' tenant.
#
# Usage: ./waasscripts/start-waas.sh [processDefinitionId]

PROCESS_DEF_ID=${1:-"feel-test-process"}
TENANT_ID="waas"

echo "Starting instance for '${PROCESS_DEF_ID}' in tenant '${TENANT_ID}'..."

curl -i -X POST "http://localhost:8080/v2/process-instances" \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "{
    \"processDefinitionId\": \"${PROCESS_DEF_ID}\",
    \"tenantId\": \"${TENANT_ID}\"
  }"
