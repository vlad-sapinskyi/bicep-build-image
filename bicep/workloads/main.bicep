targetScope = 'subscription'

import { environmentType, locationType, networkType } from '../types.bicep'
import { getResourceName, getModuleFullName } from '../functions.bicep'

param env environmentType
param location locationType
param network networkType

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
    network: network
  }
}

module galleryModule '../modules/gallery.bicep' = {
  name: getModuleFullName('gallery', env, location, null)
  scope: rg
  params: {
    env: env
    location: location
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

module imageTemplateModule '../modules/image-template.bicep' = {
  name: getModuleFullName('image-template', env, location, null)
  scope: rg
  params: {
    env: env
    location: location
    identityId: identityModule.outputs.id
    vmSubnetId: networkModule.outputs.vmSubnetId
    containerSubnetId: networkModule.outputs.containerSubnetId
    imageId: galleryModule.outputs.imageId
  }
}
