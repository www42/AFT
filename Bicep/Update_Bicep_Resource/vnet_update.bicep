param vnet object
param vnetName string
param location string = resourceGroup().location

resource vnet_updated 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.properties.addressSpace.addressPrefixes[0]
      ]
    }
    subnets: [
      {
        name: vnet.properties.subnets[0].name
        properties: {
          addressPrefix: vnet.properties.subnets[0].properties.addressPrefix
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '172.16.1.0/24'
        }
      }
    ]
  }
}
