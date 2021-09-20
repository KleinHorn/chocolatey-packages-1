﻿$ErrorActionPreference = 'Stop'
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pp                    = Get-PackageParameters
$file                  = Join-Path $toolsDir 'wsusoffline120.zip'

$packageArgs = @{
  FileFullPath = $file
  Destination  = $toolsDir
  PackageName  = $env:ChocolateyPackageName
}

Get-ChocolateyUnzip @packageArgs

if (!$pp['nostart']) {
	$fileNameGen  = "UpdateGenerator.exe"
	$fileNameInst = "UpdateInstaller.exe"
	$linkNameGen  = "UpdateGenerator.lnk"
	$linkNameInst = "UpdateInstaller.lnk"
	$programs     = [System.Environment]::GetFolderPath('Programs')
	$shortcutFilePathGen  = Join-Path $programs $linkNameGen
	$shortcutFilePathInst = Join-Path $programs $linkNameInst
	$targetPathGen        = [System.IO.Path]::Combine("$toolsDir", "wsusoffline", $fileNameGen)
	$targetPathInst       = [System.IO.Path]::Combine("$toolsDir", "wsusoffline", "client", $fileNameInst)
	Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePathGen -targetPath $targetPathGen
	Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePathInst -targetPath $targetPathInst
}

Remove-Item $file -ea 0
