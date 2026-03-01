#!/bin/bash
# get-instance-by-business-key.sh
# Find a process instance by businessKey (process variable) and processDefinitionId
# Usage: ./get-instance-by-business-key.sh <businessKey> [processDefinitionId]

BUSINESS_KEY=${1:-"test0001"}
PROCESS_DEF_ID=${2:-"feel-test-process"}

echo "Searching for process instance with businessKey='${BUSINESS_KEY}' and processDefinitionId='${PROCESS_DEF_ID}'..."
echo ""

# Step 1: Search variable 'businessKey' to find matching processInstanceKey(s)
VAR_RESULT=$(curl -s -X POST http://localhost:8080/v2/variables/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "{
    \"filter\": {
      \"name\": \"businessKey\",
      \"value\": \"\\\"${BUSINESS_KEY}\\\"\"
    }
  }")

INSTANCE_KEYS=$(echo "$VAR_RESULT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
keys = [item['processInstanceKey'] for item in data.get('items', [])]
print('\n'.join(str(k) for k in keys))
")

if [ -z "$INSTANCE_KEYS" ]; then
  echo "No process instances found with businessKey='${BUSINESS_KEY}'"
  exit 1
fi

echo "Found processInstanceKey(s): ${INSTANCE_KEYS}"
echo ""

# Step 2: Fetch process instance(s) filtered by processDefinitionId and those keys
for KEY in $INSTANCE_KEYS; do
  curl -s -X POST http://localhost:8080/v2/process-instances/search \
    -u demo:demo \
    -H "Content-Type: application/json" \
    -d "{
      \"filter\": {
        \"processInstanceKey\": \"${KEY}\",
        \"processDefinitionId\": \"${PROCESS_DEF_ID}\"
      }
    }" | python3 -m json.tool
done
