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

@secure()
param vm_username string
@secure()
param vm_password string

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

var vm_n = 'vm-evg-t'

var snet_vm = {
    name: 'snet-vnet-t'
    subnetPrefix: '192.167.0.0/28'
    nsgId: nsgDefault.outputs.id
    privateEndpointNetworkPolicies: 'Enabled'
    delegations: []
  }

module nsgDefault '../module/nsg/nsgDefault.bicep' = {
  name: 'nsg-default'
  params: {
    location: location
  }
}

module vnet '../module/vnet/vnet.bicep' = {
  name: 'vnet-t'
  params: {
    location: location
    subnets: [
      snet_vm
    ]
    vnet_addr: '192.167.0.0/24'
    vnet_n: 'vnet-evg'
    tags: tags
  }
}

resource pip 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: 'pip-vm-t'
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

resource nic 'Microsoft.Network/networkInterfaces@2020-08-01' = {
  name: 'nic-vm-t'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddress: {
            id: pip.id
          }
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${vnet.outputs.id}/subnets/${snet_vm.name}'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource VirtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vm_n
  location: location
  properties:{
    hardwareProfile: {
      vmSize:'Standard_D2s_v3'
      }
      storageProfile: {
        osDisk: {
          name: 'os-disk'
          createOption: 'FromImage'
          osType: 'Windows'
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }
        }
        imageReference: {
          publisher: 'MicrosoftWindowsDesktop'
          offer: 'Windows-10'
          sku: '19H1-ent'
          version: '18362.1198.2011031735'
        }
      }
      osProfile: {
        computerName: vm_n
        adminUsername: vm_username
        adminPassword: vm_password
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: nic.id
          }
        ]
      }
  }
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
