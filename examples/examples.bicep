targetScope = 'resourceGroup'
// ------------------------------------------------------------------------------------------------
// Deployment parameters
// ------------------------------------------------------------------------------------------------
// Sample tags parameters
var tags = {
  project: 'bicephub'
  env: 'dev'
}

param location string = 'eastus2'

// ------------------------------------------------------------------------------------------------
// REPLACE
// '../main.bicep' by the ref with your version, for example:
// 'br:bicephubdev.azurecr.io/bicep/modules/plan:v1'
// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// Set Up Additional Resources to Test Event Grid
// ------------------------------------------------------------------------------------------------
// // Logic App
// resource logic 'Microsoft.Logic/workflows@2016-06-01' = {
//   name: 'logicworkflow'
//   location: location
//   properties: {
//     state: 'Enabled'
//   }
//   tags: tags
// }
var subnet =   [
  {
    name: 'snet-vnet-t'
    subnetPrefix: '192.167.0.0/28'
    nsgId: nsgDefault.outputs.id
    privateEndpointNetworkPolicies: 'Enabled'
    delegations: []
  }
]

module nsgDefault '../module/nsg/nsgDefault.bicep' = {
  name: 'nsg-default'
  params: {
    location: location
  }
}

module vnet '../module/vnet/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    subnets: subnet
    vnet_addr: '192.167.0.0/24'
    vnet_n: 'vnet-evg'
    tags: tags
  }
}

resource pip 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: 'pip-vnet'
  tags: tags
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
  zones: []
}

// ------------------------------------------------------------------------------------------------
// Event Grid Topic Deployment Examples
// ------------------------------------------------------------------------------------------------

module evgtA '../main.bicep' = {
  name: 'evgtA'
  params: {
    evgt_n: 'evgtA'
    tags: tags
    location: location
  }
}

module evgtB '../main.bicep' = {
  name: 'evgtB'
  params: {
    evgt_n: 'evgtB'
    tags: tags
    location: location
  }
}
