targetScope = 'subscription'
param rgName string 

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: deployment().location
}

// Create virtual network
module vnet 'vnet.bicep' = {
  name: 'vnetDeployment'
  scope: rg
  params: {
    name: 'VNet1'
  }
}

// Update virtual network
module vnet_update 'vnet_update.bicep' = {
  name: 'vnet_updateDeployment'
  scope: rg
  params: {
    vnet: vnet.outputs.vnet
    vnetName: vnet.outputs.vnetName
  }
}
