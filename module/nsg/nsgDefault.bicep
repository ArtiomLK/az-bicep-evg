param location string = resourceGroup().location
param nsg_n string = 'nsg-default-${location}'

resource nsgDefault 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsg_n
  location: location
  properties: {}
}

output id string = nsgDefault.id
