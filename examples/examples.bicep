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
resource st 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: take('stevg${replace(guid(subscription().id, resourceGroup().id), '-', '')}', 24)
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

resource systemTopic 'Microsoft.EventGrid/systemTopics@2021-12-01' = {
  name: 'evgt-st'
  location: location
  properties: {
    source: st.id
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}

module viewerApp 'viewer.bicep' = {
  name: 'viewerApp'
  params: {
    siteName: 'evg-viewer-lk'
    tags: tags
    location: location
  }
}

resource eventSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2021-12-01' = {
  parent: systemTopic
  name: 'evgs-blob'
  properties: {
    destination: {
      properties: {
        endpointUrl: viewerApp.outputs.siteEventUri
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
