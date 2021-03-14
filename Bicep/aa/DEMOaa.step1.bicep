param location string = resourceGroup().location
param aaName string = 'DSC-pull'

resource aa 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: aaName
  location: location
  properties: {
    sku: {
      name: 'Free'
    }
  }
}

output aaId string = aa.id