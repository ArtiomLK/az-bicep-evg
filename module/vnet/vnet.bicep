// ------------------------------------------------------------------------------------------------
// Deployment parameters
// ------------------------------------------------------------------------------------------------
@description('Az Resources tags')
param tags object = {}

@description('Az Resources deployment location. E.G. eastus2 | eastus2,centralus | eastus,westus,centralus')
param location string

// ------------------------------------------------------------------------------------------------
// Virtual Network parameters
// ------------------------------------------------------------------------------------------------
param vnet_n string
param vnet_addr string

param subnets array

// ------------------------------------------------------------------------------------------------
// Deploy Topology Virtual Network & Network Security Groups
// ------------------------------------------------------------------------------------------------

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnet_n
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet_addr
      ]
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
        networkSecurityGroup: {
          id: subnet.nsgId
        }
        delegations: subnet.delegations
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
      }
    }]
  }
}

output id string = vnet.id
