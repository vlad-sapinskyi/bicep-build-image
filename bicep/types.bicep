@export()
type environmentType = 
  | 'prod'
  | 'dev'

@export()
type locationType = 
  | 'westeurope'
  | 'swedencentral'

@export()
type resourceType =
  | 'ResourceGroup'
  | 'NetworkSecurityGroup'
  | 'VirtualNetwork'
  | 'ManagedIdentity'
  | 'Gallery'
  | 'ImageTemplate'
