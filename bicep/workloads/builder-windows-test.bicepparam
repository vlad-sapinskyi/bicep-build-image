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
param imageActions = [
  {
    type: 'RunScript'
    name: 'enable-containers'
    script: loadTextContent('../../scripts/windows-image/Enable-Containers.ps1')
  }
  {
    type: 'RunScript'
    name: 'enable-nested-virtualization'
    script: loadTextContent('../../scripts/windows-image/Enable-NestedVirtualization.ps1')
  }
  {
    type: 'Restart'
    name: 'windows-restart-01'
  }
  {
    type: 'RunScript'
    name: 'enable-hyper-v'
    script: loadTextContent('../../scripts/windows-image/Enable-HyperV.ps1')
  }
  {
    type: 'Restart'
    name: 'windows-restart-02'
  }
  {
    type: 'RunScript'
    name: 'install-docker-ce'
    script: loadTextContent('../../scripts/windows-image/Install-DockerCE.ps1')
  }
]
