$ErrorActionPreference = 'Stop'

Write-Host 'Enable Nested Virtualization Windows feature'
bcdedit /set hypervisorlaunchtype auto
