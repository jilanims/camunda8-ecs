#!/bin/bash
# create-tenant.sh - Creates the 'waas' tenant and assigns the 'demo' user to it.
#
# This script uses the Camunda 8.9 REST API (v2) to manage tenants.

TENANT_ID="waas"
TENANT_NAME="WAAS Tenant"
TENANT_DESC="Tenant for WAAS environment"
USERNAME="demo"

echo "Creating tenant: ${TENANT_ID}..."
curl -s -X POST "http://localhost:8080/v2/tenants" \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "{
    \"tenantId\": \"${TENANT_ID}\",
    \"name\": \"${TENANT_NAME}\",
    \"description\": \"${TENANT_DESC}\"
  }" | python3 -m json.tool

echo ""
echo "Assigning user '${USERNAME}' to tenant '${TENANT_ID}'..."
curl -s -X POST "http://localhost:8080/v2/tenants/${TENANT_ID}/users" \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d "{
    \"username\": \"${USERNAME}\"
  }" | python3 -m json.tool

echo ""
echo "Tenant 'waas' setup complete."
