$ErrorActionPreference = 'Stop'

Write-Host 'Enable Containers Windows Server feature'
Install-WindowsFeature -Name 'Containers'
