import { environmentType, locationType, subnetType } from '../types.bicep'
import { getResourceName } from '../functions.bicep'

param env environmentType
param location locationType
param vnetIpRange string
param subnets subnetType[]

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
        vnetIpRange
      ]
    }
    subnets: [
      for subnet in subnets: empty(subnet.serviceName!) ? {
        name: subnet.name
        properties: {
          addressPrefix: subnet.ipRange
          networkSecurityGroup: {
            id: nsg.id
          }
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      } : {
        name: subnet.name
        properties: {
          addressPrefix: subnet.ipRange
          networkSecurityGroup: {
            id: nsg.id
          }
          privateLinkServiceNetworkPolicies: 'Disabled'
          delegations: [
            {
              name: subnet.name
              properties: {
                serviceName: subnet.serviceName!
              }
            }
          ]
        }
      }
    ]
  }
}
