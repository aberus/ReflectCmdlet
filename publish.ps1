param(
    [Parameter(Mandatory = $true)]
    [string]$ApiKey
)

Install-Module -Name Microsoft.PowerShell.PSResourceGet

$modulePath = Join-Path $PSScriptRoot 'ReflectCmdlet'

$publishOptions = @{
    Path       = $modulePath
    ApiKey     = $ApiKey
    Repository = 'PSGallery'
    Verbose    = $true
}

Publish-PSResource $publishOptions