using 'builder.bicep'

param env = 'test'
param location = 'swedencentral'
param vmSubnetName = 'vm-build'
param containerSubnetName = 'container-build'
param sourceImageDefinition = {
  os: 'Windows'
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2025-datacenter-azure-edition-smalldisk'
  version: 'latest'
}
param targetImageDefinitionName = 'custom-image-windows'
