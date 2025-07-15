@export()
type environmentType = 
  | 'prod'
  | 'test'
  | 'dev'

@export()
type locationType = 
  | 'swedencentral'
  | 'westeurope'

@export()
type resourceType =
  | 'ResourceGroup'
  | 'NetworkSecurityGroup'
  | 'VirtualNetwork'
  | 'ManagedIdentity'
  | 'Gallery'
  | 'ImageTemplate'

@export()
type subnetType = {
  name: string
  ipRange: string
  serviceName: string?
}

@export()
type imageDefinitionType = {
  os: 'Windows' | 'Linux'
  publisher: string
  offer: string
  sku: string
  version: string?
}

@export()
type imageActionType = {
  type: 'RunScript' | 'Restart'
  name: string
  script: string?
}
