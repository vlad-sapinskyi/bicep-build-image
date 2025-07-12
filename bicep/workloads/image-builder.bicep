targetScope = 'subscription'

import { environmentType, locationType, imageType } from '../types.bicep'
import { getResourceName, getModuleFullName } from '../functions.bicep'

param env environmentType
param location locationType
param vmSubnetName string
param containerSubnetName string
param sourceImage imageType
param targetImageName string

var rgName = getResourceName('ResourceGroup', env, location, null, null)

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: rgName
}

module imageTemplateModule '../modules/image-template.bicep' = {
  name: getModuleFullName('image-template', env, location, null)
  scope: rg
  params: {
    env: env
    location: location
    vmSubnetName: vmSubnetName
    containerSubnetName: containerSubnetName
    sourceImage: sourceImage
    targetImageName: targetImageName
  }
}
