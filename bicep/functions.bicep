import * as const from './constants.bicep'
import { environmentType, locationType, resourceType } from './types.bicep'

@export()
func getResourceName(res resourceType, env environmentType, location locationType, prefix string?, postfix string?) string =>
  trimResourceName(res, join(
      filter(
        [
          getResourceShortName(res)!
          prefix!
          const.appName
          env
          getLocationShortName(location)!
          postfix!
        ],
        value => value != null
      ), '-'
    )
  )

@export()
func getModuleFullName(name string, env environmentType, location locationType, postfix string?) string =>
  join(
    filter(
      [
        'module'
        replace(name, '-', '')
        const.appName
        env
        getLocationShortName(location)!
        postfix!
      ],
      value => value != null
    ), '-'
  )

@export()
func combineScript(scriptContent string) string =>
  join(
    filter(
      split(scriptContent, [
        '\r\n'
      ]),
      value => !empty(value)
    ), '; '
  )

func trimResourceName(res resourceType, name string) string =>
  (res == 'Gallery') ? replace(name, '-', '_') : name

func getLocationShortName(location locationType) string? =>
    (location == 'westeurope') ? 'we'
  : (location == 'swedencentral') ? 'sdc'
  : null

func getResourceShortName(res resourceType) string? =>
    (res == 'ResourceGroup') ? 'rg'
  :(res == 'NetworkSecurityGroup') ? 'nsg'
  : (res == 'VirtualNetwork') ? 'vnet'
  : (res == 'ManagedIdentity') ? 'id'
  : (res == 'Gallery') ? 'gal'
  : (res == 'ImageTemplate') ? 'it'
  : null
