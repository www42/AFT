az login
az account show

# Install / update if necessary
terraform --version

# Init: download provider. Run this only once in the workspace.
terraform init
ls -la .terraform

# Format and validate: formating .tf file for consistency. Validation? Maybe if you start without init
terraform fmt
terraform validate

# Refresh is done implicitly every time you do a `Plan` or `Apply`

# Plan: optional. You can simply say apply, which creates a new plan
# terraform plan

# Apply: creates plan, and after 'yes' plan is deployed. .tfstate file do not edit manually!
terraform apply

# State
terraform state list
terraform show
terraform state show azurerm_virtual_network.vnet

# Referesh 
# terraform refresh - deprecated, use instead
terraform apply -refresh-only
# You shouldn't typically need to use this command, because Terraform automatically performs the same refreshing actions as a part of creating a plan in both the 'terraform plan' and 'terraform apply' commands. 