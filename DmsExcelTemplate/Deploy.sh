stack_name="init-dmsexcel-stk"

SCRIPT_DIR=$(dirname "$0")
template_file="$SCRIPT_DIR/Template1.yml"

parameters="$SCRIPT_DIR/parameters.json"

region=$(aws configure get region)

aws cloudformation create-stack --stack-name "$stack_name" --template-body file://"$template_file" --parameters file://"$parameters" --region "$region" --capabilities CAPABILITY_IAM

sleep 120

account_id=$(aws sts get-caller-identity --query "Account" --output text)

bucket="bucket-dms-excel-$account_id"

aws s3api put-object --bucket "$bucket" --key cf_file_in/

aws s3api put-object --bucket "$bucket" --key cf_file_out/

sleep 60

aws s3 cp python.zip s3://"$bucket" --output json

template_file="$SCRIPT_DIR/Template2.yml"
stack_name="dmsexcel-stk"

aws cloudformation create-stack --stack-name "$stack_name" --template-body file://"$template_file" --parameters file://"$parameters" --region "$region" --capabilities CAPABILITY_IAM
