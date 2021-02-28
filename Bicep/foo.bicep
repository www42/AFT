param virtualNetworkName string = 'Vnet1'
param bastionHostName string = '${virtualNetworkName}-Bastion'
// ganz falsch param bastionHostName string = 'concat(virtualNetworkName), -Bastion'
