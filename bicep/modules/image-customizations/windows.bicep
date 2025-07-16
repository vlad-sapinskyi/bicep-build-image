import { environmentType, locationType } from '../../types.bicep'
import { getResourceName, createPowerShellAction, createWindowsRestartAction } from '../../functions.bicep'

param env environmentType
param location locationType

var saName = getResourceName('StorageAccount', env, location, null, null)

output customization object[] = [
  createPowerShellAction('Enable-Containers', true, true, saName)
  createPowerShellAction('Enable-NestedVirtualization', true, true, saName)
  createWindowsRestartAction(1)
  createPowerShellAction('Enable-HyperV', true, true, saName)
  createWindowsRestartAction(2)
  createPowerShellAction('Install-DockerCE', true, true, saName)
]
