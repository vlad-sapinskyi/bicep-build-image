import { environmentType, locationType, networkType } from '../types.bicep'
import { getResourceName } from '../functions.bicep'

param env environmentType
param location locationType
param network networkType

var nsgName = getResourceName('NetworkSecurityGroup', env, location, null, null)
var vnetName = getResourceName('VirtualNetwork', env, location, null, null)

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowInBoundPort-60000-60001'
        properties: {
          priority: 400
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '60000-60001'
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        network.ipRange
      ]
    }
    subnets: [
      {
        name: network.vmSubnet.name
        properties: {
          addressPrefix: network.vmSubnet.ipRange
          networkSecurityGroup: {
            id: nsg.id
          }
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
      {
        name: network.containerSubnet.name
        properties: {
          addressPrefix: network.containerSubnet.ipRange
          networkSecurityGroup: {
            id: nsg.id
          }
          privateLinkServiceNetworkPolicies: 'Disabled'
          delegations: [
            {
              name: network.containerSubnet.name
              properties: {
                serviceName: network.containerSubnet.serviceName!
              }
            }
          ]
        }
      }
    ]
  }

  resource vmSubnet 'subnets' existing = {
    name: network.vmSubnet.name
  }

  resource containerSubnet 'subnets' existing = {
    name: network.containerSubnet.name
  }
}

output vmSubnetId string = vnet::vmSubnet.id
output containerSubnetId string = vnet::containerSubnet.id
