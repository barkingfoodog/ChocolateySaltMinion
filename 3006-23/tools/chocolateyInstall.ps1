$ErrorActionPreference = 'Stop';

# Python 3
$url64_py3      = 'https://packages.broadcom.com/artifactory/saltproject-generic/windows/3006.23/Salt-Minion-3006.23-Py3-AMD64-Setup.exe'
$checksum64_py3 = '82aaa0bf33328434eaa1fb67166cf0649802dc19d2e94a4a3c53ff1484dc45d4'
$url_py3        = 'https://packages.broadcom.com/artifactory/saltproject-generic/windows/3006.23/Salt-Minion-3006.23-Py3-x86-Setup.exe'
$checksum_py3   = '8dea5901853437218cdcd93e96a0ed5c646c2dde22a8157368163f3aaacb5e11'

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
