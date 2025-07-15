# DEPENDENCY: Enable-NestedVirtualization.ps1

$ErrorActionPreference = 'Stop'

Write-Host 'Enable Hyper-V Windows Server feature'
Install-WindowsFeature -Name 'Hyper-V'
