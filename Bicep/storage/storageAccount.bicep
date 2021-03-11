param name string
param location string = resourceGroup().location

var sku = 'Standard_LRS'

resource sa1 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: name
  location: location
  kind: 'StorageV2'
  sku: {
    name: sku
    tier:'Standard'
  }
  properties: {
    accessTier : 'Hot'
    allowBlobPublicAccess: true
  }
}

output storageId string = sa1.id