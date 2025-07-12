import { environmentType, locationType, imageType } from '../types.bicep'
import { getResourceName } from '../functions.bicep'

param env environmentType
param location locationType
param targetImage imageType

var galleryName = getResourceName('Gallery', env, location, null, null)

resource gallery 'Microsoft.Compute/galleries@2024-03-03' = {
  name: galleryName
  location: location

  resource image 'images@2024-03-03' = {
    name: targetImage.sku
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
      osType: 'Windows'
      osState: 'Generalized'
      identifier: {
        publisher: targetImage.publisher
        offer: targetImage.offer
        sku: targetImage.sku
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
  }
}
