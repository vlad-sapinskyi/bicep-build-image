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
type networkType = {
  ipRange: string
  vmSubnet: subnetType
  containerSubnet: subnetType
}

@export()
type subnetType = {
  name: string
  ipRange: string
  serviceName: string?
}
