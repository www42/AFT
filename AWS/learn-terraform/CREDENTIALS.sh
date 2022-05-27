export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="eu-central-1"

aws ec2 describe-instances --query "Reservations[0].Instances[0].ImageId" --output text
aws ec2 describe-images --region $AWS_DEFAULT_REGION

terraform init
terraform fmt
terraform validate
terraform apply
terraform show

terraform destroy