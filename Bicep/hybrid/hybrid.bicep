param location string = resourceGroup().location

param vmName string = 'DC1'
param vmSize string = 'Standard_DS2_v2'
param vmIp string = '172.17.0.200'
param vmAdminUserName string = 'Student'
param vmAdminPassword string = 'Pa55w.rd1234'
param vmNodeConfigurationName string = 'ADDomain_NewForest.localhost'

param vnetName string = 'Hybrid-VNet'
param vnetAddressSpace string = '172.17.0.0/16'
param vnetSubnet0Name string = 'Subnet0'
param vnetSubnet0AddressPrefix string = '172.17.0.0/24'
param vnetSubnet1Name string = 'AzureBastionSubnet'
param vnetSubnet1AddressPrefix string = '172.17.255.32/27'

param aaName string = 'Hybrid-Automation'
param aaModuleName string = 'ActiveDirectoryDsc'
param aaModuleContentLink string = 'https://psg-prod-eastus.azureedge.net/packages/activedirectorydsc.6.0.1.nupkg'
param aaConfigurationName string = 'ADDomain_NewForest'
param aaConfigurationSourceUri string = 'https://raw.githubusercontent.com/www42/arm/master/dscConfigs/ADDomain_NewForest_paramCredentials.ps1'

var bastionName = '${vnetName}-Bastion'
var bastionPipName = '${vnetName}-Bastion-Pip'
var vmOsDiskName = '${vmName}-Disk'
var vmComputerName = '${vmName}'
var nicName = '${vmName}-Nic'
var aaJobName = '${aaConfigurationName}-Compile'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [
      {
        name: vnetSubnet0Name
        properties: {
          addressPrefix: vnetSubnet0AddressPrefix
        }
      }
      {
        name: vnetSubnet1Name
        properties: {
          addressPrefix: vnetSubnet1AddressPrefix
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
            id: vnet.properties.subnets[1].id
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
resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference:{
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: vmOsDiskName
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: vmComputerName
      adminUsername: vmAdminUserName
      adminPassword: vmAdminPassword
      windowsConfiguration: {
        timeZone: 'W. Europe Standard Time'
      }
    }
    networkProfile:{
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}
resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: vmIp
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
  }
}
resource extension 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  name: '${vm.name}/Dsc'
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
          Value: vmNodeConfigurationName
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

output vnetId string = vnet.id
output bastionId string = bastion.id
output vmId string = vm.id
output aaId string = aa.id