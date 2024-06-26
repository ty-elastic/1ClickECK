#!/bin/bash
set -e
##terraform logs
nowtime=`date +"%m_%d_%Y_%s"`
(mkdir -p ./tflogs)
export TF_LOG="INFO"
export TF_LOG_PATH="./tflogs/terraform-$nowtime.log"

export KUBE_CONFIG_PATH=~/.kube/config

echo "openebs/1ClickAddonsDestroy.sh: coping variable files"
cp -f ../../../variables.tf .
cp -f ../../../terraform.tfvars .

terraform init
terraform refresh

export KUBE_CONFIG_PATH=~/.kube/config
echo "openebs/1ClickAddonsDestroy.sh Terraform Destroy"
terraform destroy -auto-approve

echo "openebs/1ClickAddonsDestroy.sh remove openebs block devices"
(bash ./delete_openebs_bds.sh)


