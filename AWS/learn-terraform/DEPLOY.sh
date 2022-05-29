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

aws iam get-user
aws iam list-users

aws ec2 describe-images \
--owners amazon \
--region eu-central-1 \
--filters "Name=name,Values=amzn2-ami-hvm-2.0.????????.?-x86_64-gp2" "Name=state,Values=available" \
--query "reverse(sort_by(Images, &CreationDate))[:1].ImageId" \
--output text

# How many images?
# -----------------
#
# function length() zählt nur die Länge einer Liste, es zählt nicht die Objecte in einer Liste
#
# This works fine
aws ec2 describe-images \
    --owners amazon \
    --region eu-central-1 \
    --filters "Name=name,Values=amzn2-ami-hvm-2.0.????????.?-x86_64-gp2" "Name=state,Values=available" \
    --query "Images[*].ImageId | length(@)"

# This does not work! Unknown function length()
aws ec2 describe-images \
    --owners amazon \
    --region eu-central-1 \
    --filters "Name=name,Values=amzn2-ami-hvm-2.0.????????.?-x86_64-gp2" "Name=state,Values=available" \
    --query "Images[].{Name:Name,Description:Description} | lenght(@)"
