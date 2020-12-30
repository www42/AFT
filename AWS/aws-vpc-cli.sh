
# VPCs
aws ec2 describe-vpcs --query "Vpcs[*].{VpcId:VpcId,CidrBlock:CidrBlock,State:State}" --output table
aws ec2 delete-vpc --vpc-id vpc-099a157de9fc1d4a4

aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 --amazon-provided-ipv6-cidr-block

aws ec2 describe-vpcs --query "Vpcs[*].{VpcId:VpcId,CidrBlock:CidrBlock,State:State,Ipv6CidrBlock:Ipv6CidrBlockAssociationSet[0].Ipv6CidrBlock}" --output table