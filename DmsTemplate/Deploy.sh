#!/bin/bash
current_branch=$(git branch --show-current)

account_id=$(aws sts get-caller-identity --query "Account" --output text)

bucket="s3://bucket-dms-excel-$account_id/cf_file_out/params.json"

aws s3 cp "$bucket" .

SCRIPT_DIR=$(dirname "$0")
template_file="$SCRIPT_DIR/template.yml"

pDBSourceEngine=$(jq -r '.[] | select(.ParameterKey=="pDBSourceEngine") | .ParameterValue' "$SCRIPT_DIR/params.json")

stack_name="STK-$current_branch-Dms-$pDBSourceName"

parameters="$SCRIPT_DIR/params.json"

region=$(aws configure get region)

aws cloudformation create-stack --stack-name "$stack_name" --template-body file://"$template_file" --parameters file://"$parameters" --region "$region" --capabilities CAPABILITY_IAM

rm params.json
