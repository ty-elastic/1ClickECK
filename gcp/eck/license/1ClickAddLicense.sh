#!/bin/bash
set -e
echo "1ClickAddLicense.sh: appling enterprise trial license"
# initialize terraform configuration
terraform init -upgrade

# validate terraform configuration
terraform validate

# create terraform plan
terraform plan -out state.tfplan

# apply terraform plan
terraform apply state.tfplan

echo "1ClickAddLicense.sh: finished appling enterprise trial license"

echo Checking if license file is exists
echo ...
echo ...
if test -f ./es-license.json; then
  echo license file found
  kubectl delete secret eck-license -n elastic-system --ignore-not-found
  kubectl create secret generic eck-license --from-file=./es-license.json -n elastic-system
  kubectl label secret eck-license "license.k8s.elastic.co/scope"=operator -n elastic-system
else
  echo no license file found. Make sure it is named es-license.json
fi
