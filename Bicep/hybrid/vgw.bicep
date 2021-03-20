param location string = resourceGroup().location
param vgwName string = 'Contoso-Gateway'

var vgwPipName = '${vgwName}-Pip'

resource hub 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: 'hub' 
}
resource vgw 'Microsoft.Network/virtualNetworkGateways@2020-06-01' = {
  name: vgwName
  location: location
  properties: {
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    vpnGatewayGeneration: 'Generation1'
    sku: {
      name: 'VpnGw1'
      tier:'VpnGw1'
    }
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          publicIPAddress: {
            id: vgwPip.id
          }
          subnet: {
            id: hub.properties.subnets[2].id
          }
        }
      }
    ]
  }
}
resource vgwPip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: vgwPipName
  location: location
  sku: {
    name: 'Basic'    
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}
