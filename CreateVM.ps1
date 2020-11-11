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
New-AzResourceGroup -Name $rgName -Location $location
Get-AzResourceGroup | Format-Table ResourceGroupName,Location,ProvisioningState

New-AzVm `
    -Name $vmName `
    -ResourceGroupName $rgName `
    -Location $location `
    -VirtualNetworkName $vnetName `
    -SubnetName $subnetName `
    -Credential $credential `
    -SecurityGroupName $nsgName `
    -PublicIpAddressName $pipName `
    -OpenPorts 80,3389


Get-AzVM
Get-AzVM -Status | Format-Table Name,ResourceGroupName,Location,PowerState

Get-AzResource -ResourceGroupName $rgName | Format-Table Name,ResourceType

# Clean up
Remove-AzResourceGroup -Name $rgName -Force -AsJob
Get-Job