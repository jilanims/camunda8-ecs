#!/bin/bash
# get-latest-instance-key.sh
# Get the most recently started process instance key for a given processDefinitionId
# Usage: ./get-latest-instance-key.sh [processDefinitionId]

PROCESS_DEF_ID=${1:-"feel-test-process"}

echo "Latest process instance for '${PROCESS_DEF_ID}':"
echo ""

curl -s -X POST http://localhost:8080/v2/process-instances/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "{
    \"filter\": {
      \"processDefinitionId\": \"${PROCESS_DEF_ID}\"
    },
    \"sort\": [{ \"field\": \"startDate\", \"order\": \"DESC\" }],
    \"page\": { \"limit\": 1 }
  }" | python3 -c "
import sys, json
data = json.load(sys.stdin)
items = data.get('items', [])
if not items:
    print('No process instances found.')
    sys.exit(1)
inst = items[0]
print(f'processInstanceKey : {inst[\"processInstanceKey\"]}')
print(f'processDefinitionId: {inst[\"processDefinitionId\"]}')
print(f'state              : {inst[\"state\"]}')
print(f'startDate          : {inst[\"startDate\"]}')
print(f'endDate            : {inst.get(\"endDate\", \"N/A\")}')
"
