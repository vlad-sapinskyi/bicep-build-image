using 'image-builder.bicep'

param env = 'test'
param location = 'swedencentral'
param vmSubnetName = 'vm-build'
param containerSubnetName = 'container-build'
param sourceImage = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2022-datacenter-azure-edition'
  version: 'latest'
}
param targetImageName = 'custom-image-windows'
