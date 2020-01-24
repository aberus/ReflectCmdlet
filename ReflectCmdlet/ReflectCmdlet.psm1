function Get-CommandSource {
    <#
        .SYNOPSIS
         Gets command source code.
         
        .DESCRIPTION
         The Get-CommandSource cmdlet finds the source code/implementation for a cmdlet.
             
        .PARAMETER Name
         Specifies the path or name of the command to retrieve the source code.

        .PARAMETER Decompiler
	     Specifies which decompiler or source will be used for browsing the source code.

        .LINK
         https://www.github.com/aberus/ReflectCmdlet
    #>

    [CmdletBinding()]
    [OutputType([string],[PSObject])]
    [Alias('gcmso')]
    param(
        [Parameter(Position = 0, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Decompiler]$Decompiler
    )

    $commandInfo = if ($_ -is [System.Management.Automation.CommandInfo]) {$_} else {Get-Command -Name $Name}

    if($commandInfo -is [System.Management.Automation.AliasInfo]) {
        $commandInfo = $commandInfo.ResolvedCommand
    }

    if($commandInfo -is [System.Management.Automation.FunctionInfo]) {
        $modulePath = Split-Path -Path $commandInfo.Module.Path
        Invoke-Item $modulePath

        $object = New-Object PSObject -Property @{
            Name = $commandInfo.Name
            #Type       = $type
            ModulePath   = $modulePath
        }
        return $object
    }

    if($commandInfo -is [System.Management.Automation.CmdletInfo]) {
        $assembly = $commandInfo.ImplementingType.Assembly.Location
        if(!$assembly) {
            $assembly = $commandInfo.DLL
        }

        $type = $commandInfo.ImplementingType.FullName
        if (($Decompiler -eq [Decompiler]::dnSpy -or !$Decompiler) -and (Get-Command dnSpy -ErrorAction SilentlyContinue)) {
            Start-Process -FilePath dnSpy -ArgumentList "$assembly --select T:$type"
        } elseif (($Decompiler -eq [Decompiler]::ILSpy -or !$Decompiler) -and (Get-Command ILSpy -ErrorAction SilentlyContinue)) {
            Start-Process -FilePath ILSpy -ArgumentList "$assembly /navigateTo:T:$type"
        } elseif (($Decompiler -eq [Decompiler]::dotPeek -or !$Decompiler) -and (Get-Command dotPeek32 -ErrorAction SilentlyContinue)) {
            dotPeek32 /select=$assembly!$type
        } elseif (($Decompiler -eq [Decompiler]::JustDecompile -or !$Decompiler) -and (Get-Command JustDecompile -ErrorAction SilentlyContinue)) {
            Start-Process -FilePath JustDecompile -ArgumentList "/target:$assembly"
        } elseif (($Decompiler -eq [Decompiler]::Reflector -or !$Decompiler) -and (Get-Command reflector -ErrorAction SilentlyContinue)) {
            Start-Process -FilePath reflector -ArgumentList "/select:$type $assembly"
        } elseif ($Decompiler -eq [Decompiler]::GitHub -or !$Decompiler) {
            $class = $commandInfo.ImplementingType.Name
            $uri = "https://api.github.com/search/code?q=`"class+${class}`"+in:file+repo:powershell/powershell"
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $result = Invoke-RestMethod -Uri $uri -Method Get
            if ($result) {
                $url = $result.items | Select-Object -ExpandProperty html_url
                Start-Process -FilePath $url
            }       
        } else {
            throw 'No decompiler is present in your path'
        }

        $object = New-Object PSObject -Property @{
            Name = $commandInfo.Name
            Type       = $type
            Assembly   = $assembly
        }

       return $object
    }
}

enum Decompiler {
    dnSpy
    ILSpy
    dotPeek
    JustDecompile
    Reflector
    GitHub
}