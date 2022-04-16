# Azure

[![DEV - Deploy Azure Resource](https://github.com/ArtiomLK/azure-bicep-event-grid/actions/workflows/dev.orchestrator.yml/badge.svg?branch=main&event=push)](https://github.com/ArtiomLK/azure-bicep-event-grid/actions/workflows/dev.orchestrator.yml)

Event Grid aggregates all your events and provides routing from any source to any destination. Event Grid is a service that manages event routing and delivery from many sources and subscribers. This process eliminates the need for polling and results in minimized cost and latency.

## Capabilities

- It can filter events. Thus, handlers receive only relevant events
- It supports multiple subscribers. Attach multiple handlers to a single event from a single source
- It's reliable, 24-hour retries to ensure events are delivered
- It's throughput is high. Handle a high volume of event, in the range of millions per second
- It has built-in events. Use build-in events to get started quickly
- It supports custom Events. Use Event Grid to reliably deliver events for your custom components

## Producers

Sources can be configured from anywhere, and include on-premises custom applications or virtual machines within your Azure account. A source allows a single mechanism for event management through all your systems, whether they're in an on-premises datacenter or with other cloud providers.

## [Azure services that support system topics][3]

## Deployment Parameter Values

| Name            | Description                                                                                  | Value                         | Examples                                                             |
| --------------- | -------------------------------------------------------------------------------------------- | ----------------------------- | -------------------------------------------------------------------- |
| tags            | Az Resources tags                                                                            | object                        | `{ key: value }`                                                     |
| location        | Az Resources deployment location. To get Az regions run `az account list-locations -o table` | string [default: rg location] | `eastus` \| `centralus` \| `westus` \| `westus2` \| `southcentralus` |
| deploy_evgt     | Enable Event Grid Topic deployment                                                           | string [default: false]       | `true` \| `false`                                                    |
| evgt_n          | Event Grid Topic Name                                                                        | string                        |                                                                      |
| deploy_evgt     | Enable Event Grid System Topic deployment                                                    | string [default: false]       | `true` \| `false`                                                    |
| deploy_sys_evgt | System Event Grid Topic Name                                                                 | string                        |                                                                      |

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

- Event Grid Topics
- Event Grid Partner Topic
- Event Grid System Topic
- Event Grid Domain
- Event Grid Input Output
- Event Grid Subscriptions
- Event Grid Namespaces

## Additional Resources

- [MS | Learn | React to state changes in your Azure services by using Event Grid][2]
- [MS | Learn | Azure services that support system topics][3]

[1]: ./examples/examples.bicep
[2]: https://docs.microsoft.com/en-us/learn/modules/react-to-state-changes-using-event-grid/
[3]: https://docs.microsoft.com/en-us/azure/event-grid/system-topics#azure-services-that-support-system-topics
