param location string = resourceGroup().location
param aaName string = 'DSC-pull'
param aaModuleName string = 'ActiveDirectoryDsc'
param aaModuleContentLink string = 'https://psg-prod-eastus.azureedge.net/packages/activedirectorydsc.6.0.1.nupkg'
param aaConfigurationName string = 'ADDomain_NewForest'
param aaConfigurationSourceUri string = 'https://raw.githubusercontent.com/www42/arm/master/dscConfigs/ADDomain_NewForest_paramCredentials.ps1'

var aaJobName = '${aaConfigurationName}-Compile'

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
resource aaConfiguration 'Microsoft.Automation/automationAccounts/configurations@2019-06-01' = {
  name: '${aa.name}/${aaConfigurationName}'
  location: location
  properties: {
    source: {
      type: 'uri'
      value: aaConfigurationSourceUri
    }
    logProgress: true
    logVerbose: true
  }
}
resource aaJob 'Microsoft.Automation/automationAccounts/compilationjobs@2020-01-13-preview' = {
  name: '${aa.name}/${aaJobName}'
  dependsOn: [
    aaModule
    aaConfiguration
  ]
  properties: {
    configuration: {
      name: '${aaConfigurationName}'
    }
    parameters: {
      DomainName: 'contoso.com'
      DomainAdminName: 'Student'
      DomainAdminPassword: 'Pa55w.rd1234'      
    }
  }
}

output aaId string = aa.id
output aaConfigurationId string = aaConfiguration.id