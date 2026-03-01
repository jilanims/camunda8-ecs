# Camunda 8.9 REST API — Step-by-Step Guide

**Base URL**: `http://localhost:8080`  
**Auth**: HTTP Basic — `demo:demo`  
**Content-Type**: `application/json`

---

## Step 1 — Deploy Process

Deploy a BPMN file to Camunda.

```bash
curl -X POST http://localhost:8080/v2/deployments \
  -u demo:demo \
  -F "resources=@/Users/jilanibajipatan/camunda8-ecs/feel-test.bpmn"
```

**Expected Response (200 OK):**
```json
{
  "deploymentKey": "2251799813685349",
  "tenantId": "<default>",
  "deployments": [{
    "processDefinition": {
      "processDefinitionId": "feel-test-process",
      "processDefinitionVersion": 2,
      "processDefinitionKey": "2251799813685350"
    }
  }]
}
```

> Note the `processDefinitionId` (e.g. `feel-test-process`) for the next step.

---

## Step 2 — List Process Definitions

Verify the process was deployed successfully by listing all registered process definitions.

```bash
curl -X POST http://localhost:8080/v2/process-definitions/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{}'
```

**Expected Response (200 OK):**
```json
{
  "page": { "totalItems": 2 },
  "items": [
    {
      "name": "FEEL Test Process",
      "version": 1,
      "processDefinitionId": "feel-test-process",
      "processDefinitionKey": "2251799813685325"
    },
    {
      "name": "FEEL Test Process",
      "version": 2,
      "processDefinitionId": "feel-test-process",
      "processDefinitionKey": "2251799813685350"
    }
  ]
}
```

> Use the `processDefinitionId` from here to start a workflow in the next step.

---

## Step 3 — Start Workflow (Create Process Instance)

```bash
curl -X POST http://localhost:8080/v2/process-instances \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{"processDefinitionId": "feel-test-process"}'
```

**Expected Response (200 OK):**
```json
{
  "processDefinitionId": "feel-test-process",
  "processDefinitionVersion": 2,
  "processDefinitionKey": "2251799813685350",
  "processInstanceKey": "2251799813685351"
}
```

> Note the `processInstanceKey` for later steps.

---

## Step 4 — Get List of All Tasks

Search for all active user task jobs.

```bash
curl -X POST http://localhost:8080/v2/jobs/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{}'
```

**Expected Response (200 OK):**
```json
{
  "page": { "totalItems": 1 },
  "items": [{
    "jobKey": "2251799813685356",
    "type": "io.camunda.zeebe:userTask",
    "state": "CREATED",
    "elementId": "UserTask_1",
    "processInstanceKey": "2251799813685351",
    "processDefinitionId": "feel-test-process",
    "customHeaders": { "io.camunda.zeebe:assignee": "demo" }
  }]
}
```

---

## Step 5 — Get Tasks Assigned to a Specific User

Filter by process instance and assignee using custom headers.

```bash
curl -X POST http://localhost:8080/v2/jobs/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "processInstanceKey": "2251799813685351",
      "state": "CREATED",
      "type": "io.camunda.zeebe:userTask"
    }
  }'
```

> Replace `processInstanceKey` with your instance key from Step 2.

**Expected Response:** Returns task(s) where `customHeaders["io.camunda.zeebe:assignee"]` matches the user (e.g., `"demo"`).

---

## Step 6 — Complete the Task

Use the `jobKey` from Step 3/4.

```bash
curl -X POST http://localhost:8080/v2/jobs/2251799813685356/completion \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{"variables": {}}'
```

**Expected Response: `HTTP 204 No Content`** — Task completed successfully.

> You can pass output variables: `-d '{"variables": {"approved": true}}'`

---

## Step 7 — Check Process Instance Status

### Check if Active
```bash
curl -X POST http://localhost:8080/v2/process-instances/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "processInstanceKey": "2251799813685351",
      "state": "ACTIVE"
    }
  }'
```

### Check if Completed
```bash
curl -X POST http://localhost:8080/v2/process-instances/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "processInstanceKey": "2251799813685351",
      "state": "COMPLETED"
    }
  }'
```

**State values:** `ACTIVE` | `COMPLETED` | `CANCELED` | `INCIDENT`

---

## Shell Scripts (Quick Reference)

All scripts are in `/Users/jilanibajipatan/camunda8-ecs/scripts/`:

| Script | Command |
|--------|---------|
| Deploy | `./deploy.sh` |
| List process definitions | `./list-process-definitions.sh` |
| Start instance | `./start-instance.sh` |
| List tasks | `./list-tasks.sh` |
| Complete task | `./complete-task.sh <jobKey>` |

---

---

## Step 8 — Deploy DMN Decision

Deploy a DMN file to Camunda.

```bash
curl -X POST http://localhost:8080/v2/deployments \
  -u demo:demo \
  -F "resources=@/Users/jilanibajipatan/camunda8-ecs/loan-decision.dmn"
```

---

## Step 9 — Evaluate DMN Decision

Evaluate a decision by its ID (the latest version will be used) and provide input variables.

```bash
curl -i -X POST "http://localhost:8080/v2/decision-definitions/evaluation" \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{
    "decisionDefinitionId": "loan-approval",
    "variables": {
      "creditScore": 750,
      "loanAmount": 25000
    }
  }'
```

---

## DMN Shell Scripts

| Script | Command |
|--------|---------|
| Deploy DMN | `./scripts/deploy-dmn.sh` |
| Evaluate DMN | `./scripts/evaluate-dmn.sh <key> <score> <amount>` |

---

## Full Flow Summary

```
1. Deploy BPMN         →  POST /v2/deployments                      →  200 + deploymentKey
2. List Definitions    →  POST /v2/process-definitions/search       →  200 + processDefinitionId
3. Start Instance      →  POST /v2/process-instances                →  200 + processInstanceKey
4. List All Tasks      →  POST /v2/jobs/search                      →  200 + items[] with jobKey
5. Tasks by User       →  POST /v2/jobs/search (filter)             →  200 + filtered items
6. Complete Task       →  POST /v2/jobs/{jobKey}/completion         →  204 No Content
7. Check Status        →  POST /v2/process-instances/search         →  state: COMPLETED
8. Deploy DMN          →  POST /v2/deployments                      →  200 + deploymentKey
9. Evaluate DMN        →  POST /v2/decision-definitions/evaluation   →  200 + output
```
