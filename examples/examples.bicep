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
// Event Grid Topic Deployment Examples
// ------------------------------------------------------------------------------------------------

module evgtA '../main.bicep' = {
  name: 'evgtA'
  params: {
    deploy_evgt: true
    evgt_n: 'evgt-a'
    tags: tags
    location: location
  }
}

module evgtB '../main.bicep' = {
  name: 'evgtB'
  params: {
    deploy_evgt: true
    evgt_n: 'evgt-b'
    tags: tags
    location: location
  }
}

module evgtN '../main.bicep' = {
  name: 'evgtN'
  params: {
    deploy_evgt: true
    evgt_n: 'evgt-n'
    tags: tags
    location: location
  }
}

// ------------------------------------------------------------------------------------------------
// System Event Grid Topic Deployment Examples
// ------------------------------------------------------------------------------------------------

module sysEvgtA '../main.bicep' = {
  name: 'sys-evgtA'
  params: {
    deploy_sys_evgt: true
    sys_evgt_n: 'sys-evgt-a'
    tags: tags
    location: location
  }
}

module sysEvgtB '../main.bicep' = {
  name: 'sys-evgtB'
  params: {
    deploy_sys_evgt: true
    sys_evgt_n: 'sys-evgt-b'
    tags: tags
    location: location
  }
}

module sysEvgtN '../main.bicep' = {
  name: 'sys-evgtc'
  params: {
    deploy_sys_evgt: true
    sys_evgt_n: 'sys-evgt-c'
    tags: tags
    location: location
  }
}
