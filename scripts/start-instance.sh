#!/bin/bash
# start-instance.sh
curl -i -X POST http://localhost:8080/v2/process-instances \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{"processDefinitionId": "feel-test-process"}'
