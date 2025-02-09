﻿$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'mozillabuild*'
  file          = Join-Path $toolsDir 'MozillaBuildSetup-3.3.exe'
  fileType      = 'exe'
  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item -Force -Ea 0 -Path $toolsDir\*.exe