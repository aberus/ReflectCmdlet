# ReflectCmdlet

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/ReflectCmdlet)](https://www.powershellgallery.com/packages/ReflectCmdlet/)

Sometime you want to understand how exactly PowerShell cmdlets work.
The ```Get-CommandSource``` cmdlet or ```gcmso``` alias finds the source code/implementation for a cmdlet.

This module is for Windows PowerShell 3.0 or above.

## How To Use

``` PowerShell
 Get-CommandSource 
     [-Name] <String>
     [-Decompiler {CodemerxDecompile | dotPeek | dnSpy | GitHub | ILSpy | JustDecompile | Reflector}]
 ```

It can be used in a many ways:

``` PowerShell
Get-CommandSource "Write-Host"

Get-CommandSource Write-Host

gcmso Write-Host
 
"Write-Host" | Get-CommandSource

Get-Command Write-Host | Get-CommandSource
```

## Install

To install the module you can run in a PowerShell following command:

```PowerShell
Install-Module -Name ReflectCmdlet
```

To install the module using the PowerShellGet v3:

```powershell
Install-PSResource -Name ReflectCmdlet
```

Or download this module from PowerShell Gallery:
https://www.powershellgallery.com/packages/ReflectCmdlet/


## License

Inspired by the this script from [Oisin Grehan](https://github.com/oising):
http://www.nivot.org/post/2008/10/30/ATrickToJumpDirectlyToACmdletsImplementationInReflector

The source code is available under [The MIT License (MIT)](LICENSE)
