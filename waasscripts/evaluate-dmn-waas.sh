#!/bin/bash
# evaluate-dmn-waas.sh - Evaluates a DMN decision in the 'waas' tenant.
#
# Usage: ./waasscripts/evaluate-dmn-waas.sh <decisionId> <creditScore> <loanAmount>

DECISION_ID=${1:-"loan-approval"}
CREDIT_SCORE=${2:-720}
LOAN_AMOUNT=${3:-25000}
TENANT_ID="waas"

echo "Evaluating decision '${DECISION_ID}' in tenant '${TENANT_ID}'..."
echo "  creditScore = ${CREDIT_SCORE}"
echo "  loanAmount  = ${LOAN_AMOUNT}"
echo ""

curl -s -X POST "http://localhost:8080/v2/decision-definitions/evaluation" \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "{
    \"decisionDefinitionId\": \"${DECISION_ID}\",
    \"tenantId\": \"${TENANT_ID}\",
    \"variables\": {
      \"creditScore\": ${CREDIT_SCORE},
      \"loanAmount\": ${LOAN_AMOUNT}
    }
  }" | python3 -c "
import sys, json
data = json.load(sys.stdin)

if 'status' in data and data['status'] != 200:
    print(f'Error: {data.get(\"detail\", data)}')
    sys.exit(1)

print(f'decisionEvaluationKey: {data.get(\"decisionEvaluationKey\", \"N/A\")}')
print(f'tenantId: {data.get(\"tenantId\", \"N/A\")}')
print('')
print('Result Summary:')
print(f'  Output JSON: {data.get(\"output\", \"N/A\")}')

try:
    output_obj = json.loads(data.get(\"output\", \"{}\"))
    for k, v in output_obj.items():
        print(f'    {k}: {v}')
except Exception:
    pass
"
