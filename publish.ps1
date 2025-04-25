param(
    [Parameter(Mandatory = $true)]
    [string]$ApiKey
)

Install-PSResource -Name Microsoft.PowerShell.PSResourceGet

$modulePath = Join-Path $PSScriptRoot 'ReflectCmdlet'

Write-Host "Publishing module at $modulePath to PSGallery"

$publishOptions = @{
    Path       = $modulePath
    ApiKey     = $ApiKey
    Repository = 'PSGallery'
    Verbose    = $true
}

Publish-PSResource $publishOptions