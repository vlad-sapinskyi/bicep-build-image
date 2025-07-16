[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('Windows', 'Linux')]
    [string] $ImageType,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('Dev', 'Test', 'Prod')]
    [string] $Environment,

    [ValidateNotNullOrEmpty()]
    [ValidateSet('SwedenCentral', 'WestEurope')]
    [string] $Location = 'SwedenCentral'
)
process {
    # Set application name
    $appName = 'aib'

    # Set workload name
    $workloadName = 'builder'

    # Set image type
    $imageType = $ImageType.ToLower()

    # Set environment name
    $envName = $Environment.ToLower()

    # Set deployment location name
    $locationName = $Location.ToLower()
    $locationShortName = 'sdc'
    if ('WestEurope' -eq $Location) {
        $locationShortName = 'we'
    }

    # Set subscription ID to 'VLDS Sandbox'
    $subscriptionId = '10923ef3-e036-4918-88a7-e2853ca7b5b4'

    try {
        # Set Azure context
        Write-Host "`nSetting Azure context to '$subscriptionId' subscription...`n" -ForegroundColor Green
        $account = az account show | ConvertFrom-Json
        if ($subscriptionId -ne $account.id) {
            az account set --subscription $subscriptionId
        }
        Write-Host ($account | Format-List | Out-String)

        # Deploy selected workload
        $deploymentName = "$appName-$workloadName-$envName-$locationShortName"
        $deploymentTemplateParameterFile = ".\bicep\workloads\$workloadName-$imageType-$envName.bicepparam"
        $deploymentTemplateFile = ".\bicep\workloads\$workloadName.bicep" 
        Write-Host "`nDeploying '$workloadName' workload ...`n" -ForegroundColor Green
        az deployment sub create --name $deploymentName --location $locationName --template-file $deploymentTemplateFile --parameters $deploymentTemplateParameterFile

        Write-Host "`nDone!`n" -ForegroundColor Green
    }
    catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host $_.ScriptStackTrace
    }
}
