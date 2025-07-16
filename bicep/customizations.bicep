@export()
var windows = [
  {
    type: 'PowerShell'
    name: 'enable-containers'
    scriptUri: 'https://sabuildimagetestsdc.blob.core.windows.net/scripts/windows-image/Enable-Containers.ps1'
    runAsSystem: true
    runElevated: true
  }
  {
    type: 'PowerShell'
    name: 'enable-nested-virtualization'
    scriptUri: 'https://sabuildimagetestsdc.blob.core.windows.net/scripts/windows-image/Enable-NestedVirtualization.ps1'
    runAsSystem: true
    runElevated: true
  }
  {
    type: 'WindowsRestart'
    name: 'windows-restart-01'
  }
  {
    type: 'PowerShell'
    name: 'enable-hyper-v-ce'
    scriptUri: 'https://sabuildimagetestsdc.blob.core.windows.net/scripts/windows-image/Enable-HyperV.ps1'
    runAsSystem: true
    runElevated: true
  }
  {
    type: 'WindowsRestart'
    name: 'windows-restart-02'
  }
  {
    type: 'PowerShell'
    name: 'install-docker-ce'
    scriptUri: 'https://sabuildimagetestsdc.blob.core.windows.net/scripts/windows-image/Install-DockerCE.ps1'
    runAsSystem: true
    runElevated: true
  }
]

@export()
var linux = []
