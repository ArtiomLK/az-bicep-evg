param location string = resourceGroup().location
param nsg_n string = 'nsg-rdp-${location}'

resource nsgRDP 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsg_n
  location: location
  properties: {
    securityRules: [
      {
        name: 'DenyRDP'
        properties: {
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '3389'
            sourceAddressPrefix: 'Internet'
            destinationAddressPrefix: '*'
            access: 'Deny'
            priority: 200
            direction: 'Inbound'
            sourcePortRanges: []
            destinationPortRanges: []
            sourceAddressPrefixes: []
            destinationAddressPrefixes: []
        }
      }
    ]
  }
}

output id string = nsgRDP.id
