import { environmentType, locationType, imageDefinitionType } from '../types.bicep'
import { getResourceName } from '../functions.bicep'

param env environmentType
param location locationType
param imageDefinitions imageDefinitionType[]

var galleryName = getResourceName('Gallery', env, location, null, null)

resource gallery 'Microsoft.Compute/galleries@2024-03-03' = {
  name: galleryName
  location: location

  resource images 'images@2024-03-03' = [for imageDefinition in imageDefinitions: {
    name: imageDefinition.sku
    location: location
    properties: {
      hyperVGeneration: 'V2'
      architecture: 'x64'
      features: [
        {
          name: 'SecurityType'
          value: 'TrustedLaunchSupported'
        }
        {
          name: 'IsAcceleratedNetworkSupported'
          value: 'True'
        }
      ]
      osType: imageDefinition.os
      osState: 'Generalized'
      identifier: {
        publisher: imageDefinition.publisher
        offer: imageDefinition.offer
        sku: imageDefinition.sku
      }
      recommended: {
        vCPUs: {
          min: 2
          max: 16
        }
        memory: {
          min: 8
          max: 32
        }
      }
    }
  }]
}
