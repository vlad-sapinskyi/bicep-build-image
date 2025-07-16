import { environmentType, locationType } from '../types.bicep'
import { getResourceName } from '../functions.bicep'

param env environmentType
param location locationType

var saName = getResourceName('StorageAccount', env, location, null, null)

resource sa 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: saName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
  }

  resource blob 'blobServices' = {
    name: 'default'
    properties: {
      isVersioningEnabled: true
    }

    resource container 'containers' = {
      name: 'scripts'
      properties: {
        publicAccess: 'Blob'
      }
    }
  }
}
