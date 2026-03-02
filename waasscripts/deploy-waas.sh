#!/bin/bash
# deploy-waas.sh - Deploys a BPMN process to the 'waas' tenant.
#
# Usage: ./waasscripts/deploy-waas.sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BPMN_FILE="${SCRIPT_DIR}/../feel-test.bpmn"
TENANT_ID="waas"

echo "Deploying to tenant: ${TENANT_ID}..."

curl -i -X POST "http://localhost:8080/v2/deployments" \
  -u demo:demo \
  -F "resources=@${BPMN_FILE}" \
  -F "tenantId=${TENANT_ID}"
