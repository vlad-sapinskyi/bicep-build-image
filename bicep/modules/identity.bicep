param name string
param location string

var identityName = 'id-${name}'

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: identityName
  location: location
}

resource networkRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '4d97b98b-1d4f-4787-a291-c67834d212e7'
}

resource galleryRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '85a2d0d9-2eba-4c9c-b355-11c2cc0788ab'
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
