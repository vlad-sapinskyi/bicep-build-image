param name string
param location string

var nsgName = 'nsg-${name}'
var vnetName = 'vnet-${name}'

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
        '172.17.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'vm-build'
        properties: {
          addressPrefix: '172.17.0.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
      {
        name: 'container-build'
        properties: {
          addressPrefix: '172.17.1.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
          privateLinkServiceNetworkPolicies: 'Disabled'
          delegations: [
            {
              name: 'container-build'
              properties: {
                serviceName: 'Microsoft.ContainerInstance/containerGroups'
              }
            }
          ]
        }
      }
    ]
  }
}
