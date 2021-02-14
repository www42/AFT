param name string = 'Vnet1'
param location string = resourceGroup().location

resource Vnet1 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet0'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

output vnetId string = Vnet1.id