$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://packages.broadcom.com/artifactory/saltproject-generic/windows/3006.22/Salt-Minion-3006.22-Py3-AMD64-Setup.exe'
$checksum64_py3 = '780301f7ce7e5b76c2ca7f3c58637d036075c4b40a67576e14db8ab6e5624fc2'
$url_py3        = 'https://packages.broadcom.com/artifactory/saltproject-generic/windows/3006.22/Salt-Minion-3006.22-Py3-x86-Setup.exe'
$checksum_py3   = '6554ebc97808f4f3c45b2c9314f58ab80f62615898c8949fef1b9352ed1a4800'

$packageArgs = @{
  packageName     = 'salt-minion'
  unzipLocation   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  fileType        = 'EXE'

  softwareName    = 'Salt*'

  url             = $url_py3
  checksum        = $checksum_py3
  checksumType    = 'sha256'

  url64bit        = $url64_py3
  checksum64      = $checksum64_py3
  checksumType64  = 'sha256'

  silentArgs    = "/S"
  validExitCodes= @(0, 3010, 1641)
}


$packageParameters = Get-PackageParameters

if ($packageParameters['Master']) {
  $Master = $packageParameters['Master']
  $packageArgs['silentArgs'] += " /master=$Master"
}

if ($packageParameters['MinionName']) {
  $MinionName = $packageParameters['MinionName']
  $packageArgs['silentArgs'] += " /minion-name=$MinionName"
}

if ($packageParameters['MinionStart']) {
  $MinionStart = $packageParameters['MinionStart']
  $packageArgs['silentArgs'] += " /start-minion=$MinionStart"
}

if ($packageParameters['MinionStartDelayed'] -eq 'true') {
  $packageArgs['silentArgs'] += " /start-minion-delayed"
}

if ($packageParameters['DefaultConfig'] -eq 'true') {
  $packageArgs['silentArgs'] += " /default-config"
}

if ($packageParameters['CustomConfig']) {
  $CustomConfig = $packageParameters['CustomConfig']
  $packageArgs['silentArgs'] += " /custom-config=$CustomConfig"
}

Install-ChocolateyPackage @packageArgs
