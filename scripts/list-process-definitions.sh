#!/bin/bash
# list-process-definitions.sh
# Get all deployed process definitions from Camunda
curl -s -X POST http://localhost:8080/v2/process-definitions/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{}' | python3 -m json.tool
