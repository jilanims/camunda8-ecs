#!/bin/bash
# list-process-definitions.sh - Lists all deployed process definitions
#
# This script queries the /v2/process-definitions/search endpoint.
# It returns details like name, version, tenantId, and processDefinitionId.
#
# Usage: ./scripts/list-process-definitions.sh

curl -s -X POST http://localhost:8080/v2/process-definitions/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{}' | python3 -m json.tool
