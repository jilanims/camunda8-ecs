#!/bin/bash
# list-tasks-waas.sh - Lists waiting user tasks for the 'waas' tenant.
#
# Usage: ./waasscripts/list-tasks-waas.sh [processInstanceKey]

INSTANCE_KEY=${1:-""}
TENANT_ID="waas"

echo "Searching for waiting tasks in tenant '${TENANT_ID}'..."

if [ -n "$INSTANCE_KEY" ]; then
  FILTER="{\"processInstanceKey\": \"${INSTANCE_KEY}\", \"state\": \"CREATED\", \"tenantId\": \"${TENANT_ID}\"}"
else
  FILTER="{\"type\": \"io.camunda.zeebe:userTask\", \"state\": \"CREATED\", \"tenantId\": \"${TENANT_ID}\"}"
fi

curl -s -X POST "http://localhost:8080/v2/jobs/search" \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "{ \"filter\": ${FILTER} }" | python3 -c "
import sys, json
data = json.load(sys.stdin)
items = data.get('items', [])
if not items:
    print('No waiting tasks found in tenant waas.')
    sys.exit(0)
for i, task in enumerate(items, 1):
    print(f'Task #{i}: jobKey={task[\"jobKey\"]}, elementId={task[\"elementId\"]}, tenantId={task[\"tenantId\"]}')
"
