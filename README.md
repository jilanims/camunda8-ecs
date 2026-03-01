# Camunda 8.9 REST API & DMN Lab Walkthrough

## Overview
This project provides a complete environment for testing the Camunda 8.9.0-alpha4 REST API using a Dockerized setup with H2 (RDBMS) as the secondary database. It includes automated shell scripts for BPMN and DMN operations.

## Repository Link
[https://github.com/jilanims/camunda8-ecs.git](https://github.com/jilanims/camunda8-ecs.git)

## Components Built

### 1. Docker Environment
- **Image**: `camunda/camunda:8.9.0-alpha4`
- **Database**: H2 (In-memory for simplicity)
- **Features**: Operate and Tasklist enabled, Zeebe Gateway Security enabled.

### 2. BPMN Process — FEEL Test
- **File**: [`feel-test.bpmn`](file:///Users/jilanibajipatan/camunda8-ecs/feel-test.bpmn)
- **Logic**: User task with a FEEL expression for assignee (`= "demo"`).

### 3. DMN Decision — Loan Approval
- **File**: [`loan-decision.dmn`](file:///Users/jilanibajipatan/camunda8-ecs/loan-decision.dmn)
- **Logic**: Decision table based on `creditScore` and `loanAmount`.
- **Test Scenarios**:
  - `720` score, `25000` amount → **Approved** (Good credit, acceptable amount) ✅
  - `800` score, `10000` amount → **Approved** (Excellent credit, low amount) ✅

### 4. Postman Assets
- **Collection**: `Camunda_8.9_REST_API.postman_collection.json`
- **Environment**: `Camunda_Local.postman_environment.json`
- **Usage**: Import both into Postman, select the "Camunda Local" environment, and start testing!

---

## REST API Test Results ✅

| Feature | Endpoint | Result |
|---------|----------|--------|
| **Deploy BPMN/DMN** | `POST /v2/deployments` | Success (200) |
| **Start Instance** | `POST /v2/process-instances` | Success (200) |
| **List Definitions** | `POST /v2/process-definitions/search` | Success (200) |
| **List Tasks** | `POST /v2/jobs/search` | Found `io.camunda:userTask` |
| **Complete Task** | `POST /v2/jobs/{jobKey}/completion` | Success (204) |
| **Evaluate DMN** | `POST /v2/decision-definitions/evaluation` | Success (200) |

---

## Utility Scripts
All scripts are located in the [`/scripts`](file:///Users/jilanibajipatan/camunda8-ecs/scripts/) folder:

- `deploy.sh`: Deploys the BPMN file.
- `start-instance.sh`: Starts a process instance.
- `list-process-definitions.sh`: Lists all deployed definitions.
- `list-process-instances.sh`: Lists all instances (active/completed).
- `get-instance-by-business-key.sh`: Finds instance using a business key variable.
- `get-latest-instance-key.sh`: Gets the newest instance key.
- `list-tasks-by-instance.sh`: Finds waiting user tasks for a key.
- `complete-task.sh`: Completes a task using its job key.
- `deploy-dmn.sh`: Deploys the DMN file.
- `evaluate-dmn.sh`: Evaluates the loan decision.

## API Documentation
A detailed step-by-step guide is available in [`api_guide.md`](file:///Users/jilanibajipatan/camunda8-ecs/api_guide.md).
