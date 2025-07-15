targetScope = 'subscription'

import { environmentType, locationType, subnetType, imageDefinitionType } from '../types.bicep'
import { getResourceName, getModuleFullName } from '../functions.bicep'

param env environmentType
param location locationType
param vnetIpRange string
param subnets subnetType[]
param imageDefinitions imageDefinitionType[]

var rgName = getResourceName('ResourceGroup', env, location, null, null)

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: rgName
  location: location
}

module networkModule '../modules/network.bicep' = {
  name: getModuleFullName('network', env, location, null)
  scope: rg
  params: {
    env: env
    location: location
    vnetIpRange: vnetIpRange
    subnets: subnets
  }
}

module galleryModule '../modules/gallery.bicep' = {
  name: getModuleFullName('gallery', env, location, null)
  scope: rg
  params: {
    env: env
    location: location
    imageDefinitions: imageDefinitions
  }
}

module identityModule '../modules/identity.bicep' = {
  name: getModuleFullName('identity', env, location, null)
  scope: rg
  params: {
    env: env
    location: location
  }
}
