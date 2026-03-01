#!/bin/bash
# list-tasks-by-instance.sh - Get all waiting user tasks for a given process instance key
# This script searches specifically for jobs of type 'io.camunda.zeebe:userTask' in 'CREATED' state.
# Usage: ./list-tasks-by-instance.sh <processInstanceKey>

INSTANCE_KEY=${1:-"2251799813685392"}

echo "Waiting user tasks for instance '${INSTANCE_KEY}':"
echo ""

# Search for the job associated with the user task
curl -s -X POST http://localhost:8080/v2/jobs/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "{
    \"filter\": {
      \"processInstanceKey\": \"${INSTANCE_KEY}\",
      \"type\": \"io.camunda.zeebe:userTask\",
      \"state\": \"CREATED\"
    }
  }" | python3 -c "
import sys, json
data = json.load(sys.stdin)
items = data.get('items', [])
total = data.get('page', {}).get('totalItems', 0)
if not items:
    print('No waiting tasks found.')
    sys.exit(0)
print(f'Total waiting tasks: {total}')
print('')
for i, task in enumerate(items, 1):
    assignee = task.get('customHeaders', {}).get('io.camunda.zeebe:assignee', 'Unassigned')
    print(f'Task #{i}')
    print(f'  jobKey            : {task[\"jobKey\"]}')
    print(f'  elementId         : {task[\"elementId\"]}')
    print(f'  state             : {task[\"state\"]}')
    print(f'  assignee          : {assignee}')
    print(f'  processInstanceKey: {task[\"processInstanceKey\"]}')
    print(f'  creationTime      : {task[\"creationTime\"]}')
    print('')
"
