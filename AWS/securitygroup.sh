aws ec2 describe-security-groups --query "SecurityGroups[*].{Description:Description,VpcId:VpcId}" --output table

aws ec2 describe-vpcs --query "Vpcs[*].{IsDefault:IsDefault,VpcId:VpcId}"
