$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

. (Join-Path $toolsDir 'helpers.ps1')

Stop-CodeGraphProcess
