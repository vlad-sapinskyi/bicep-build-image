# DEPENDENCY: Enable-Containers.ps1
# DEPENDENCY: Enable-HyperV.ps1

$ErrorActionPreference = 'Stop'

$Version = '28.3.0'
$TmpPath = 'C:\tmp'

if (!(Test-Path -Path $TmpPath)) {
    New-Item -ItemType Directory -Path $TmpPath
}

$scriptName = 'install-docker-ce.ps1'
$scriptUri = "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/$scriptName"
$scriptPath = Join-Path -Path $TmpPath -ChildPath $scriptName

Write-Host 'Install Docker Community Edition (Moby)'
Invoke-WebRequest -UseBasicParsing $scriptUri -OutFile $scriptPath
. $scriptPath -DockerVersion $Version -HyperV

# Update daemon config to use Hyper-V isolation by default
$daemonConfigPath = 'C:\ProgramData\docker\config\daemon.json'
$json = Get-Content -Path $daemonConfigPath -Raw | ConvertFrom-Json
$arr = New-Object System.Collections.ArrayList
$arr.Add('isolation=hyperv')
$json | Add-Member -Name 'exec-opts' -Value $arr -MemberType NoteProperty
$json | ConvertTo-Json -Depth 32 | Set-Content -Path $daemonConfigPath
Stop-Service -Name 'Docker'
Start-Service -Name 'Docker'
