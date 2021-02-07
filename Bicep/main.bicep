resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'storage1939042519'
  location: 'westeurope'
  kind: 'StorageV2'
  sku:{
    name: 'Standard_LRS'
  }
}