import { environmentType, locationType, imageType } from '../types.bicep'
import { getResourceName } from '../functions.bicep'

param env environmentType
param location locationType
param vmSubnetName string
param containerSubnetName string
param sourceImage imageType
param targetImageName string

var vnetName = getResourceName('VirtualNetwork', env, location, null, null)
var galleryName = getResourceName('Gallery', env, location, null, null)
var identityName = getResourceName('ManagedIdentity', env, location, null, null)
var imageTemplateName = getResourceName('ImageTemplate', env, location, null, null)

resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' existing = {
  name: vnetName

  resource vmSubnet 'subnets@2024-07-01' existing = {
    name: vmSubnetName
  }

  resource containerSubnet 'subnets@2024-07-01' existing = {
    name: containerSubnetName
  }
}

resource gallery 'Microsoft.Compute/galleries@2024-03-03' existing = {
  name: galleryName

  resource image 'images@2024-03-03' existing = {
    name: targetImageName
  }
}

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: identityName
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
      vnetConfig: {
        subnetId: vnet::vmSubnet.id
        containerInstanceSubnetId: vnet::containerSubnet.id
      }
    }
    source: {
      type: 'PlatformImage'
      publisher: sourceImage.publisher
      offer: sourceImage.offer
      sku: sourceImage.sku
      version: sourceImage.version!
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
        galleryImageId: gallery::image.id
        runOutputName: targetImageName
        replicationRegions: [
          location
        ]
      }
    ]
  }
}
