param name string
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ServerSubnet'
        properties: {
          addressPrefix: '172.16.0.0/24'
        }
      }
    ]
  }  
}

output vnet object = vnet
output vnetName string = vnet.name
