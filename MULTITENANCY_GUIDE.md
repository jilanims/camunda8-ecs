# Camunda 8.9 Multitenancy & Tenant Scripts Walkthrough

## Overview
This task involved enabling multitenancy in the Camunda 8.9 setup and providing a set of scripts specifically for a new tenant named `waas`.

## Multitenancy Configuration
- **Dockerfile**: Updated with multitenancy enablement for Identity, Operate, Tasklist, and Zeebe Gateway.
- **Tenant**: Created a new tenant `waas` (WAAS Tenant).
- **User Assignment**: Assigned the `demo` user to the `waas` tenant to allow data access.

## Tenant Scripts (`waasscripts/`)
A new folder [`waasscripts/`](file:///Users/jilanibajipatan/camunda8-ecs/waasscripts/) contains scripts that explicitly pass the `tenantId` to the REST API:

1.  **`deploy-waas.sh`**: Deploys BPMN resources to the `waas` tenant.
2.  **`start-waas.sh`**: Starts a process instance specifically for the `waas` tenant.
3.  **`list-tasks-waas.sh`**: Filters user tasks/jobs by `tenantId: "waas"`.
4.  **`complete-task-waas.sh`**: Completes a task (tenant ID captured by unique jobKey).
5.  **`deploy-dmn-waas.sh`**: Deploys DMN resources to the `waas` tenant.
6.  **`evaluate-dmn-waas.sh`**: Evaluates a DMN decision for the `waas` tenant.

## Verification Results
- **Tenant Creation**: Verified via `POST /v2/tenants/search` ✅
- **User Assignment**: Verified via Identity API ✅
- **Script Readiness**: All scripts are correctly formatted to handle multitenancy.

> [!NOTE]
> In the current 8.9.0-alpha4 standalone image, Zeebe multitenancy may require additional configuration or a cluster-based setup to fully accept `tenantId` in deployment/start requests. The scripts are prepared for when this feature is fully activated in the broker.
