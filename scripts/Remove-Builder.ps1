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

    # Set image type
    $imageType = $ImageType.ToLower()

    # Set environment name
    $envName = $Environment.ToLower()

    # Set deployment location name
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

        # Run image template
        $rgName = "rg-$appName-$envName-$locationShortName"
        $imageTemplateName = "it-$appName-$envName-$locationShortName"
        Write-Host "`nRemoving '$imageTemplateName' image template ...`n" -ForegroundColor Green
        az image builder delete --name $imageTemplateName --resource-group $rgName

        Write-Host "`nDone!`n" -ForegroundColor Green
    }
    catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host $_.ScriptStackTrace
    }
}
