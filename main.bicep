// ------------------------------------------------------------------------------------------------
// Deployment parameters
// ------------------------------------------------------------------------------------------------
@description('Az Resources tags')
param tags object = {}

@description('Az Resources deployment location')
param location string = resourceGroup().location

// ------------------------------------------------------------------------------------------------
// System EVGT Configuration parameters
// ------------------------------------------------------------------------------------------------
// @description('Append PostFix to Az Event Grid Topic related resources')
// param evgt_post_fix string = take(guid(resourceGroup().id, evgt_n), 4)

@description('Enable Event Grid Topic deployment')
param deploy_evgt bool = false

@description('Event Grid Topic Name')
@maxLength(64)
param evgt_n string = 'evgt'

// ------------------------------------------------------------------------------------------------
// System EVGT Configuration parameters
// ------------------------------------------------------------------------------------------------
@description('Enable Event Grid System Topic deployment')
param deploy_sys_evgt bool = false

@description('System Event Grid Topic Name')
@maxLength(64)
param sys_evgt_n string = 'sys-evgt'

var viewer_app_n = 'viewer-app-${sys_evgt_n}'
var st_n = take('st${replace(sys_evgt_n, '-', '')}${take(guid(resourceGroup().id, sys_evgt_n), 4)}', 24)
// ------------------------------------------------------------------------------------------------
// Deploy EVGT
// ------------------------------------------------------------------------------------------------
resource evgTopic 'Microsoft.EventGrid/topics@2021-12-01' = if (deploy_evgt) {
  name: evgt_n
  location: location
  tags: tags
}

// ------------------------------------------------------------------------------------------------
// Deploy EVGT (System Topic)
// ------------------------------------------------------------------------------------------------
resource st 'Microsoft.Storage/storageAccounts@2021-02-01' = if(deploy_sys_evgt) {
  name: st_n
  tags: tags
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
}

resource sysEvgt 'Microsoft.EventGrid/systemTopics@2021-12-01' = if(deploy_sys_evgt) {
  name: sys_evgt_n
  location: location
  properties: {
    source: st.id
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}

module viewerApp './module/viewer/viewer.bicep' = if(deploy_sys_evgt) {
  name: viewer_app_n
  params: {
    siteName: deploy_sys_evgt ? viewer_app_n : ''
    tags: tags
    location: location
  }
}

resource viewerEvgs 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2021-12-01' = if(deploy_sys_evgt) {
  parent: sysEvgt
  name: 'evgs-blob-${sys_evgt_n}'
  properties: {
    destination: {
      properties: {
        endpointUrl: deploy_sys_evgt ? viewerApp.outputs.siteEventUri : ''
      }
      endpointType: 'WebHook'
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Storage.BlobCreated'
        'Microsoft.Storage.BlobDeleted'
      ]
    }
  }
}

output evgt_id string = evgTopic.id
output sys_evgt_id string = viewerEvgs.id
