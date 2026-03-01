#!/bin/bash
# start-instance-with-key.sh
# Usage: ./start-instance-with-key.sh <businessKey>
# Note: In Camunda 8 v2 API, business keys are passed as process variables.
BUSINESS_KEY=${1:-"test0001"}

curl -i -X POST http://localhost:8080/v2/process-instances \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "{
    \"processDefinitionId\": \"feel-test-process\",
    \"variables\": {
      \"businessKey\": \"${BUSINESS_KEY}\"
    }
  }"
