#!/bin/bash
# deploy-dmn.sh
# Deploy a DMN decision file to Camunda
# Usage: ./deploy-dmn.sh [path-to-dmn-file]

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DMN_FILE=${1:-"${SCRIPT_DIR}/../loan-decision.dmn"}

echo "Deploying DMN: ${DMN_FILE}"
echo ""

curl -s -X POST http://localhost:8080/v2/deployments \
  -u demo:demo \
  -F "resources=@${DMN_FILE}" | python3 -m json.tool
