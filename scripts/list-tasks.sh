# list-tasks.sh
curl -i -X POST http://localhost:8080/v2/user-tasks/search \
  -u demo:demo \
  -H "Content-Type: application/json" \
  -d '{"filter": {"processInstanceKey": "2251799813685351", "state": "CREATED"}}'
