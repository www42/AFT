param network string = 'vNet1'
param location string = resourceGroup().location
param bastionPrefix string = '10.0.255.32/27'

var name = '${network}-Bastion'
var pipname = '${network}-Ip'

resource bastion 'Microsoft.Network/bastionHosts@2020-06-01' = {
  name: name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfiguration'
        properties: {
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  name: '${network}/AzureBastionSubnet'
  properties: {
    addressPrefix: bastionPrefix
  }
}

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: pipname
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

output id string = bastion.id
