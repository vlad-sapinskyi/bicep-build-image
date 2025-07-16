import { environmentType, locationType } from '../types.bicep'
import { getResourceName } from '../functions.bicep'

param env environmentType
param location locationType
param roleDefinitionIds string[]

var identityName = getResourceName('ManagedIdentity', env, location, null, null)

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: identityName
  location: location
}

resource roleDefinitions 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = [for roleDefinitionId in roleDefinitionIds: {
  name:roleDefinitionId
}]

resource roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for i in range(0, length(roleDefinitionIds)): {
  scope: resourceGroup()
  name: guid(resourceGroup().id, roleDefinitions[i].id, identity.id)
  properties: {
    roleDefinitionId: roleDefinitions[i].id
    principalId: identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}]
