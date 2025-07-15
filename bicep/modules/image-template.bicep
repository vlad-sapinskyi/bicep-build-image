import { environmentType, locationType, imageDefinitionType, imageActionType } from '../types.bicep'
import { getResourceName, combineScript } from '../functions.bicep'

param env environmentType
param location locationType
param rgStageId string
param vmSubnetName string
param containerSubnetName string
param sourceImageDefinition imageDefinitionType
param targetImageDefinitionName string
param imageActions imageActionType[]

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
    name: targetImageDefinitionName
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
      publisher: sourceImageDefinition.publisher
      offer: sourceImageDefinition.offer
      sku: sourceImageDefinition.sku
      version: sourceImageDefinition.version!
    }
    stagingResourceGroup: rgStageId
    customize: [
      for action in imageActions: action.type == 'RunScript'
        ? sourceImageDefinition.os == 'Windows'
            ? {
                type: 'PowerShell'
                name: action.name
                inline: [combineScript(action.script!)]
                runAsSystem: true
                runElevated: true
              }
            : {
                type: 'Shell'
                name: action.name
                inline: [combineScript(action.script!)]
              }
        : {
            type: 'WindowsRestart'
            name: action.name
          }
    ]
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: gallery::image.id
        runOutputName: targetImageDefinitionName
        replicationRegions: [
          location
        ]
      }
    ]
  }
}
