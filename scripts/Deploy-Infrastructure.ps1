[CmdletBinding()]
param(
)
process {
    # Set subscription ID to 'VLDS Sandbox'
    $subscriptionId = '10923ef3-e036-4918-88a7-e2853ca7b5b4'

    # Set Azure context
    $account = az account show | ConvertFrom-Json
    if ($subscriptionId -ne $account.id) {
        az account set --subscription $subscriptionId
    }

    # Get Deployment location
    $deploymentLocation = 'swedencentral'

    # Deploy workload
    $deploymentName = "image-build"
    $deploymentTemplateFile = ".\bicep\main.bicep"
    $deploymentTemplateParameterFile = ".\bicep\main.bicepparam"
    az deployment sub create --name $deploymentName --location $deploymentLocation --template-file $deploymentTemplateFile --parameters $deploymentTemplateParameterFile
}
