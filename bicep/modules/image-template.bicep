import { environmentType, locationType } from '../types.bicep'
import { getResourceName } from '../functions.bicep'

param env environmentType
param location locationType
param identityId string
param vmSubnetId string
param containerSubnetId string
param imageId string

var imageTemplateName = getResourceName('ImageTemplate', env, location, null, null)

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2024-02-01' = {
  name: imageTemplateName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identityId}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 60
    vmProfile: {
      vnetConfig: {
        subnetId: vmSubnetId
        containerInstanceSubnetId: containerSubnetId
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
        galleryImageId: imageId
        runOutputName: 'windows-2022-custom-image'
        replicationRegions: [
          location
        ]
      }
    ]
  }
}
