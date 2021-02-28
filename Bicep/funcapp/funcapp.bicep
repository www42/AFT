param functionAppName string
param serverFarmName string = 'ASP-FunctionsRG-8ee9'
param storageAccountName string = 'storageaccountfunct8525'
param location string = resourceGroup().location
param applicationInsightsName string = 'plural69118'

var storageAccountID = resourceId('Microsoft.Storage/storageAccounts', storageAccountName)
var serverFarmID = resourceId('Microsoft.Web/serverfarms', serverFarmName)

resource funcapp 'Microsoft.Web/sites@2018-11-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: serverFarmID
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsDashboard'
          value: concat('DefaultEndpointsProtocol=https;AccountName=', storageAccountName, ';AccountKey=', listKeys(storageAccountID,'2015-05-01-preview').key1)
        }
        {
          name: 'AzureWebJobsStorage'
          value: concat('DefaultEndpointsProtocol=https;AccountName=', storageAccountName, ';AccountKey=', listKeys(storageAccountID,'2015-05-01-preview').key1)
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: concat('DefaultEndpointsProtocol=https;AccountName=', storageAccountName, ';AccountKey=', listKeys(storageAccountID,'2015-05-01-preview').key1)
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower('funcapp1399')
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference(resourceId('microsoft.insights/components/', applicationInsightsName), '2015-05-01').InstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
}

output Name string = functionAppName