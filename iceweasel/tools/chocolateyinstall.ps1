﻿$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  file64         = Join-Path $toolsDir 'iceweasel-99.0a1.en-US.win64.installer_x64.exe'
  silentArgs     = '-ms'
  validExitCodes = @(0)
  softwareName   = 'Debian Iceweasel*'
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
