param vnetName string
param bastionPrefix string = '10.0.255.32/27'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  name: '${vnet.name}/AzureBastionSubnet'
  properties:{
    addressPrefix: bastionPrefix
  }
}

output subnetId string = subnet.id