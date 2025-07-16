targetScope = 'subscription'

import { environmentType, locationType, imageDefinitionType } from '../types.bicep'
import { getResourceName, getModuleFullName } from '../functions.bicep'

param env environmentType
param location locationType
param vmSubnetName string
param containerSubnetName string
param sourceImageDefinition imageDefinitionType
param targetImageDefinitionName string

var rgName = getResourceName('ResourceGroup', env, location, null, null)

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: rgName
}

module imageCustomizationsWindowsModule '../modules/image-customizations/windows.bicep' = if (sourceImageDefinition.os == 'Windows') {
  name: 'image-customizations-windows'
  scope: rg
  params: {
    location: location
    env: env
  }
}

module imageCustomizationsLinuxModule '../modules/image-customizations/windows.bicep' = if (sourceImageDefinition.os == 'Linux') {
  name: 'image-customizations-windows'
  scope: rg
  params: {
    location: location
    env: env
  }
}

module imageTemplateModule '../modules/image-template.bicep' = {
  name: getModuleFullName('image-template', env, location, null)
  scope: rg
  params: {
    env: env
    location: location
    vmSubnetName: vmSubnetName
    containerSubnetName: containerSubnetName
    targetImageDefinitionName: targetImageDefinitionName
    sourceImageDefinition: sourceImageDefinition
    customization: sourceImageDefinition.os == 'Windows' ? imageCustomizationsWindowsModule.?outputs.customization
      : sourceImageDefinition.os == 'Linux' ? imageCustomizationsLinuxModule.?outputs.customization
      : null
  }
}
