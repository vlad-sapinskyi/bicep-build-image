param name string
param location string

var identityName = 'id-${name}'
var vnetName = 'vnet-${name}'
var galleryName = replace('gal-${name}', '-', '_')
var imageTemplateName = 'it-${name}'

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: identityName
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' existing = {
  name: vnetName

  resource vmBuildSubnet 'subnets@2024-07-01' existing = {
    name: 'vm-build'
  }

  resource containerBuildSubnet 'subnets@2024-07-01' existing = {
    name: 'container-build'
  }
}

resource gallery 'Microsoft.Compute/galleries@2024-03-03' existing = {
  name: galleryName

  resource windowsImage 'images@2024-03-03' existing = {
    name: 'windows'
  }
}

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2024-02-01' = {
  name: imageTemplateName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity.id}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 60
    vmProfile: {
      vmSize: 'Standard_D2s_v3'
      osDiskSizeGB: 127
      vnetConfig: {
        subnetId: vnet::vmBuildSubnet.id
        containerInstanceSubnetId: vnet::containerBuildSubnet.id
      }
    }
    source: {
      type: 'PlatformImage'
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    customize: [
      {
        type: 'PowerShell'
        name: 'enable-containers'
        inline: [
          'Install-WindowsFeature -Name \'Containers\''
        ]
        runElevated: true
        runAsSystem: true
      }
      {
        type: 'PowerShell'
        name: 'enable-nested-virtualization'
        inline: [
          'bcdedit /set hypervisorlaunchtype auto'
        ]
        runElevated: true
        runAsSystem: true
      }
      {
        type: 'WindowsRestart'
        name: 'restart-01'
      }
      {
        type: 'PowerShell'
        name: 'enable-hyper-v'
        inline: [
          'Install-WindowsFeature -Name \'Hyper-V\''
        ]
        runElevated: true
        runAsSystem: true
      }
      {
        type: 'WindowsRestart'
        name: 'restart-02'
      }
    ]
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: gallery::windowsImage.id
        runOutputName: 'windows-2022-custom-image'
        replicationRegions: [
          location
        ]
      }
    ]
  }
}
