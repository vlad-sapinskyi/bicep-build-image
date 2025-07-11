targetScope = 'subscription'

param name string
param location string

var rgName = 'rg-${name}'

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: rgName
  location: location
}

module networkModule 'modules/network.bicep' = {
  name: 'module-network-${name}'
  scope: rg
  params: {
    name: name
    location: location
  }
}

module galleryModule 'modules/gallery.bicep' = {
  name: 'module-gallery-${name}'
  scope: rg
  params: {
    name: name
    location: location
  }
}

module identityModule 'modules/identity.bicep' = {
  name: 'module-identity-${name}'
  scope: rg
  params: {
    name: name
    location: location
  }
}

module imageTemplateModule 'modules/image-template.bicep' = {
  name: 'module-image-template-${name}'
  scope: rg
  dependsOn: [
    networkModule
    galleryModule
    identityModule
  ]
  params: {
    name: name
    location: location
  }
}
