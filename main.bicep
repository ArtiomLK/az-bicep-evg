// ------------------------------------------------------------------------------------------------
// Deployment parameters
// ------------------------------------------------------------------------------------------------
@description('Az Resources tags')
param tags object = {}

@description('Az Resources deployment location')
param location string = resourceGroup().location

// ------------------------------------------------------------------------------------------------
// FD Configuration parameters
// ------------------------------------------------------------------------------------------------
@description('Event Grid Topic Name')
@maxLength(64)
param evgt_n string

// ------------------------------------------------------------------------------------------------
// Deploy EVG
// ------------------------------------------------------------------------------------------------
resource evgTopic 'Microsoft.EventGrid/topics@2021-12-01' = {
  name: evgt_n
  location: location
  tags: tags
}

output id string = evgTopic.id
