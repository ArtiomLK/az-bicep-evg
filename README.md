# Azure

[![DEV - Deploy Azure Resource](https://github.com/ArtiomLK/azure-bicep-event-grid/actions/workflows/dev.orchestrator.yml/badge.svg?branch=main&event=push)](https://github.com/ArtiomLK/azure-bicep-event-grid/actions/workflows/dev.orchestrator.yml)

- Event Grid Topics
- Event Grid Partner Topic
- Event Grid System Topic
- Event Grid Domain
- Event Grid Input Output
- Event Grid Subscriptions
- Event Grid Namespaces

## Instructions

## Parameter Values

| Name     | Description                                                                                  | Value                         | Examples                                                             |
| -------- | -------------------------------------------------------------------------------------------- | ----------------------------- | -------------------------------------------------------------------- |
| tags     | Az Resources tags                                                                            | object                        | `{ key: value }`                                                     |
| location | Az Resources deployment location. To get Az regions run `az account list-locations -o table` | string [default: rg location] | `eastus` \| `centralus` \| `westus` \| `westus2` \| `southcentralus` |
| evgt_n   | Event Grid Topic Name                                                                        | string [required]             |                                                                      |

### [Reference Examples][1]

## Locally test Azure Bicep Modules

```bash
# Create an Azure Resource Group
az group create \
--name 'rg-azure-bicep-resource' \
--location 'eastus2' \
--tags project=bicephub env=dev

# Deploy Sample Modules
az deployment group create \
--resource-group 'rg-azure-bicep-resource' \
--mode Complete \
--template-file examples/examples.bicep
```

[1]: ./examples/examples.bicep
