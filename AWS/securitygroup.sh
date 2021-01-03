aws ec2 describe-security-groups --query "SecurityGroups[*].{Description:Description,VpcId:VpcId}" --output table

# Array ist eine einfache Liste [foo,green]
# Object ist eine Sammlung von Key-Value Pairs {name:foo, color:green}

# Von allen SecurityGroups möchte ich die Description haben als Array
aws ec2 describe-security-groups --query "SecurityGroups[*].[Description]"


# Von allen SecurityGroups möchte ich die Description und GroupName haben als Array
aws ec2 describe-security-groups --query "SecurityGroups[*].[Description,GroupName]"
az group list                    --query "[].[name,location]"

# Jetzt nicht als Array, sondern als Object
aws ec2 describe-security-groups --query "SecurityGroups[*].{}"          # doesn't work
aws ec2 describe-security-groups --query "SecurityGroups[*].{Description:Description,GroupName:GroupName}"


# Bedingung GroupName=default
aws ec2 describe-security-groups --query "SecurityGroups[?GroupName=='default']"

aws ec2 describe-security-groups > temp.json




aws ec2 describe-vpcs --query "Vpcs[*].{VpcId:VpcId,IsDefault:IsDefault}" --output table
