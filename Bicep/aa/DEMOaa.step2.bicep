param location string = resourceGroup().location
param aaName string = 'DSC-pull'
param aaModuleName string = 'ActiveDirectoryDsc'
param aaModuleContentLink string = 'https://psg-prod-eastus.azureedge.net/packages/activedirectorydsc.6.0.1.nupkg'

resource aa 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: aaName
  location: location
  properties: {
    sku: {
      name: 'Free'
    }
  }
}
resource aaModule 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${aa.name}/${aaModuleName}'
  properties: {
    contentLink: {
      uri: aaModuleContentLink
    }
  }
}

output aaId string = aa.id