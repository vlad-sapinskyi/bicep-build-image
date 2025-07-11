using 'main.bicep'

param env = 'test'
param location = 'swedencentral'
param network = {
  ipRange: '172.17.0.0/16'
  vmSubnet: {
    name: 'vm-build'
    ipRange: '172.17.1.0/16'
  }
  containerSubnet: {
    name: 'container-build'
    ipRange: '172.17.2.0/16'
    serviceName: 'Microsoft.ContainerInstance/containerGroups'
  }
}
