import { environmentType, locationType } from '../../types.bicep'
import { getResourceName } from '../../functions.bicep'

param env environmentType
param location locationType

var saName = getResourceName('StorageAccount', env, location, null, null)

output customization object[] = []
