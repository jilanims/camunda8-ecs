#!/bin/bash
# evaluate-dmn.sh - Evaluates a DMN decision with given inputs via REST API
# Usage: ./evaluate-dmn.sh <decisionDefinitionId> <creditScore> <loanAmount>
#
# This script sends a POST request to the /v2/decision-definitions/evaluation endpoint
# and parses the JSON response to show the summary of the decision result.
#
# Example:
#   ./evaluate-dmn.sh loan-approval 720 25000

DECISION_ID=${1:-"loan-approval"}
CREDIT_SCORE=${2:-720}
LOAN_AMOUNT=${3:-25000}

echo "Evaluating decision: '${DECISION_ID}'"
echo "  creditScore = ${CREDIT_SCORE}"
echo "  loanAmount  = ${LOAN_AMOUNT}"
echo ""

curl -s -X POST "http://localhost:8080/v2/decision-definitions/evaluation" \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "{
    \"decisionDefinitionId\": \"${DECISION_ID}\",
    \"variables\": {
      \"creditScore\": ${CREDIT_SCORE},
      \"loanAmount\": ${LOAN_AMOUNT}
    }
  }" | python3 -c "
import sys, json
data = json.load(sys.stdin)

# Handle error response
if 'status' in data and data['status'] != 200:
    print(f'Error: {data.get(\"detail\", data)}')
    sys.exit(1)

print(f'decisionEvaluationKey: {data.get(\"decisionEvaluationKey\", \"N/A\")}')
print(f'decisionDefinitionId: {data.get(\"decisionDefinitionId\", \"N/A\")}')
print(f'decisionDefinitionVersion: {data.get(\"decisionDefinitionVersion\", \"N/A\")}')
print('')
print('Result Summary:')
print(f'  Output JSON: {data.get(\"output\", \"N/A\")}')

# Parse the inner output JSON which is often a string in the v2 response
try:
    output_obj = json.loads(data.get(\"output\", \"{}\"))
    for k, v in output_obj.items():
        print(f'    {k}: {v}')
except Exception:
    pass
"
