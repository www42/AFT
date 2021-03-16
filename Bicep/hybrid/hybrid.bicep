param location string = resourceGroup().location

// Hub
param vnetHubName string = 'Hub'
param vnetHubAddressSpace string = '172.16.0.0/16'
param vnetHubSubnet0Name string = 'Subnet0'
param vnetHubSubnet0AddressPrefix string = '172.16.0.0/24'
param vnetHubSubnet1Name string = 'AzureBastionSubnet'
param vnetHubSubnet1AddressPrefix string = '172.16.255.32/27'
param vnetHubSubnet2Name string = 'GatewaySubnet'
param vnetHubSubnet2AddressPrefix string = '172.16.255.64/29'

// Spoke1
param vnetSpoke1Name string = 'Spoke1'
param vnetSpoke1AddressSpace string = '172.17.0.0/16'
param vnetSpoke1Subnet0Name string = 'Subnet0'
param vnetSpoke1Subnet0AddressPrefix string = '172.17.0.0/24'

// Spoke2
param vnetSpoke2Name string = 'Spoke2'
param vnetSpoke2AddressSpace string = '172.18.0.0/16'
param vnetSpoke2Subnet0Name string = 'Subnet0'
param vnetSpoke2Subnet0AddressPrefix string = '172.18.0.0/24'

// All virtual machines
param vmAdminUserName string = 'Student'
param vmAdminPassword string = 'Pa55w.rd1234'

// DC
param vmDcName string = 'DC'
param vmDcSize string = 'Standard_DS2_v2'
param vmDcIp string = '172.16.0.200'
param vmDcNodeConfigurationName string = 'ADDomain_NewForest.localhost'

// Automation account
param aaName string = 'Contoso-Automation'
param aaModuleName string = 'ActiveDirectoryDsc'
param aaModuleContentLink string = 'https://psg-prod-eastus.azureedge.net/packages/activedirectorydsc.6.0.1.nupkg'
param aaConfigurationName string = 'ADDomain_NewForest'
param aaConfigurationSourceUri string = 'https://raw.githubusercontent.com/www42/arm/master/dscConfigs/ADDomain_NewForest_paramCredentials.ps1'

var bastionName = '${vnetHubName}-Bastion'
var bastionPipName = '${vnetHubName}-Bastion-Pip'
var aaJobName = '${aaConfigurationName}-Compile'

resource hub 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetHubName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetHubAddressSpace
      ]
    }
    subnets: [
      {
        name: vnetHubSubnet0Name
        properties: {
          addressPrefix: vnetHubSubnet0AddressPrefix
        }
      }
      {
        name: vnetHubSubnet1Name
        properties: {
          addressPrefix: vnetHubSubnet1AddressPrefix
        }
      }
      {
        name: vnetHubSubnet2Name
        properties: {
          addressPrefix: vnetHubSubnet2AddressPrefix
        }
      }
    ]
  }
}
resource spoke1 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetSpoke1Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetSpoke1AddressSpace
      ]
    }
    subnets: [
      {
        name: vnetSpoke1Subnet0Name
        properties: {
          addressPrefix: vnetSpoke1Subnet0AddressPrefix
        }
      }
    ]
  }
}
resource spoke2 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetSpoke2Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetSpoke2AddressSpace
      ]
    }
    subnets: [
      {
        name: vnetSpoke2Subnet0Name
        properties: {
          addressPrefix: vnetSpoke2Subnet0AddressPrefix
        }
      }
    ]
  }
}
resource bastion 'Microsoft.Network/bastionHosts@2020-06-01' = {
  name: bastionName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          publicIPAddress: {
            id: bastionPip.id
          }
          subnet: {
            id: hub.properties.subnets[1].id
          }
        }
      }
    ]
  }
}
resource bastionPip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: bastionPipName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
resource dc 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmDcName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmDcSize
    }
    storageProfile: {
      imageReference:{
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: '${vmDcName}-Disk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: '${vmDcName}'
      adminUsername: vmAdminUserName
      adminPassword: vmAdminPassword
      windowsConfiguration: {
        timeZone: 'W. Europe Standard Time'
      }
    }
    networkProfile:{
      networkInterfaces: [
        {
          id: nic_dc.id
        }
      ]
    }
  }
}
resource nic_dc 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: '${vmDcName}-Nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: vmDcIp
          subnet: {
            id: hub.properties.subnets[0].id
          }
        }
      }
    ]
  }
}
resource extension_dc 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  name: '${dc.name}/Dsc'
  location: location
  dependsOn: [
    aaJob
  ]
  properties: {
    type: 'DSC'
    publisher: 'Microsoft.Powershell'
    typeHandlerVersion: '2.77'
    autoUpgradeMinorVersion: true
    protectedSettings: {
      Items: {
        registrationKeyPrivate: listKeys(aaName, '2020-01-13-preview').keys[0].value
      }
    }
    settings: {
      Properties: [
        {
          Name: 'RegistrationKey'
          Value: {
            UserName: 'PLACEHOLDER_DONOTUSE'
            Password: 'PrivateSettingsRef:registrationKeyPrivate'
          }
          TypeName: 'System.Management.Automation.PSCredential'
        }
        {
          Name: 'RegistrationUrl'
          Value: reference(aaName, '2020-01-13-preview').registrationUrl
          TypeName: 'System.String'
        }
        {
          Name: 'NodeConfigurationName'
          Value: vmDcNodeConfigurationName
          TypeName: 'System.String'
        }
        {
          Name: 'ConfigurationMode'
          Value: 'ApplyandAutoCorrect'
          TypeName: 'System.String'
        }
        {
          Name: 'RebootNodeIfNeeded'
          Value: true
          TypeName: 'System.Boolean'
        }
        {
          Name: 'ActionAfterReboot'
          Value: 'ContinueConfiguration'
          TypeName: 'System.String'
        }
      ]
    }
  }
}
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
  // name: '${aaName}/${aaModuleName}'
  // Does not work 
  //   "The Resource 'Microsoft.Automation/automationAccounts/DSC-pull'
  //    under resource group 'Oauth-RG' was not found."

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

output hubId string = hub.id
output bastionId string = bastion.id
output dcId string = dc.id
output aaId string = aa.id