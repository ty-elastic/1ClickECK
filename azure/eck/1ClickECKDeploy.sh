#!/bin/bash

#add license file
echo "1ClickECKDeploy.sh: set kubectl"
(cd ../aks/ ; bash ./setkubectl.sh) 

export KUBE_CONFIG_PATH=~/.kube/config
##Name Gen Util for AKS Kibana Load Balancer

echo "1ClickECKDeploy.sh: generating name"
(cd ./namegen; bash ./1ClickNameGen.sh)

set -e
#copy variables to operator directory
echo "1ClickECKDeploy.sh: coping variable files"
cp -f ../variables.tf .
cp -f ../terraform.tfvars .

echo "1ClickECKDeploy.sh: Creating Loadbalancers"
(cd ./loadbalancers/; bash ./KonductorDeploy.sh)

echo "1ClickECKDeploy.sh: Creating Elastic CRDS and Operator"
(cd ./helm-deployment/eck-operator/; bash ./KonductorDeploy.sh)


echo "1ClickECKDeploy.sh: Creating Elasticsearch"
(cd ./helm-deployment/eck-elasticsearch/; bash ./KonductorDeploy.sh)

SLEEP_INTERVAL=20 # in seconds
RETRIES=20

# Function to check if Elasticsearch is ready
check_es() {
  RESPONSE=$(curl --insecure -s -u elastic:$(kubectl get secret eck-elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode) https://$(kubectl get service eck-ingest-es-http-endpoint | tail -n -1 | awk {'print $4"" '}):9200)
  if echo "$RESPONSE" | grep -q "You Know, for Search"; then
    echo "$RESPONSE" # If the desired string is found, print the entire payload
    return 0
  else
    return 1
  fi
}

# Retry mechanism
count=0
until check_es; do
  count=$((count + 1))
  if [ $count -ge $RETRIES ]; then
    echo "Failed to get the expected response from Elasticsearch after $RETRIES attempts."
    exit 1
  fi
  echo "Elasticsearch not ready, retrying in $SLEEP_INTERVAL seconds..."
  sleep $SLEEP_INTERVAL
done

echo "1ClickECKDeploy.sh: Creating Kibana"
(cd ./helm-deployment/eck-kibana/; bash ./KonductorDeploy.sh)

echo "1ClickECKDeploy.sh: Creating Elastic Agent"
(cd ./helm-deployment/eck-agent/; bash ./KonductorDeploy.sh)

echo "1ClickECKDeploy.sh: Creating Fleet Server"
(cd ./helm-deployment/eck-fleet-server/; bash ./KonductorDeploy.sh)


#add license file
echo "1ClickECKDeploy.sh: Adding trial license"
(cd ./license ; bash ./1ClickAddLicense.sh) 

echo "1ClickECKDeploy.sh: Calling eck/getClusterInfo.sh"
./getClusterInfo.sh
