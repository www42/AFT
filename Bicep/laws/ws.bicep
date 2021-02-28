param wsName string
param location string = resourceGroup().location

resource ws 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: wsName
  location: location
  properties: {
    sku: {
      name: 'Free'
    }
    retentionInDays: 7
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output workspaceID string = ws.id
output retentionInDays int = ws.properties.retentionInDays