import { environmentType, locationType } from '../types.bicep'
import { getResourceName } from '../functions.bicep'

param env environmentType
param location locationType

var galleryName = getResourceName('Gallery', env, location, null, null)

resource gallery 'Microsoft.Compute/galleries@2024-03-03' = {
  name: galleryName
  location: location

  resource windowsImage 'images@2024-03-03' = {
    name: 'windows'
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
        publisher: 'SimCorp'
        offer: 'SimCity'
        sku: 'TeamCity-Default-Agent-Windows'
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

output imageId string = gallery::windowsImage.id
