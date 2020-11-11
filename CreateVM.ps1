# Docs
# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-powershell


# Signed in?
Get-AzContext | Format-List *

# Some variables
$location = "westeurope"
$rgName = "Compute-RG"
$vmName = "VM1"
$vnetName = "VNet1"
$subnetName = "Subnet1"
$openPorts = 80,3389
$userName = "student"
$password = Read-Host -Prompt "password" -AsSecureString

$credential = New-Object System.Management.Automation.PSCredential ($username, $password)
$nsgName = "$vmName-NSG"
$pipName = "$vmName-PIP"


# Create

# To be done

# Clean up
Remove-AzResourceGroup -Name $rgName -Force -AsJob
Get-Job