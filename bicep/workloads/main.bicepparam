using 'main.bicep'

param env = 'test'
param location = 'swedencentral'
param vnetIpRange = '172.17.0.0/16'
param subnets = [
  {
    name: 'vm-build'
    ipRange: '172.17.1.0/16'
  }
  {
    name: 'container-build'
    ipRange: '172.17.2.0/16'
    serviceName: 'Microsoft.ContainerInstance/containerGroups'
  }
]
param targetImage = {
  publisher: 'github'
  offer: 'vlad-sapinskyi'
  sku: 'custom-image-windows'
}
