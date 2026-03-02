#!/bin/bash
# deploy-dmn-waas.sh - Deploys a DMN file to the 'waas' tenant.
#
# Usage: ./waasscripts/deploy-dmn-waas.sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DMN_FILE="${SCRIPT_DIR}/../loan-decision.dmn"
TENANT_ID="waas"

echo "Deploying DMN to tenant: ${TENANT_ID}..."

curl -i -X POST "http://localhost:8080/v2/deployments" \
  -u demo:demo \
  -F "resources=@${DMN_FILE}" \
  -F "tenantId=${TENANT_ID}"
