#!/bin/bash
export KUBE_CONFIG_PATH=~/.kube/config

echo "Copying variable files"
cp -f ../variables.tf .
cp -f ../terraform.tfvars .

# initialize terraform configuration
terraform init

# validate terraform configuration
terraform validate

# create terraform plan
terraform plan -out state.tfplan

# apply terraform plan
terraform apply state.tfplan

Echo "Running addons"
(cd addons; bash ./1ClickAddons.sh)

# cleanup
#terraform destroy -auto-approve
