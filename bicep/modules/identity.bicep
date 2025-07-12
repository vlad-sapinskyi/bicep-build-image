import * as const from '../constants.bicep'
import { environmentType, locationType } from '../types.bicep'
import { getResourceName } from '../functions.bicep'

param env environmentType
param location locationType

var identityName = getResourceName('ManagedIdentity', env, location, null, null)

resource networkRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: const.networkRole
}

resource galleryRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: const.galleryRole
}

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: identityName
  location: location
}

resource networkRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: resourceGroup()
  name: guid(resourceGroup().id, networkRoleDefinition.id, identity.id)
  properties: {
    roleDefinitionId: networkRoleDefinition.id
    principalId: identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource galleryRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: resourceGroup()
  name: guid(resourceGroup().id, galleryRoleDefinition.id, identity.id)
  properties: {
    roleDefinitionId: galleryRoleDefinition.id
    principalId: identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}
