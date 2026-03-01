# deploy.sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
curl -i -X POST http://localhost:8080/v2/deployments \
  -u demo:demo \
  -F "resources=@${SCRIPT_DIR}/../feel-test.bpmn"
