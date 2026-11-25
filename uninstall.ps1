$ErrorActionPreference='Stop'
if(Get-Process CorelDRW -ErrorAction SilentlyContinue){throw 'Close CorelDRAW first.'}
$base=Join-Path $env:ProgramFiles 'Corel'
$dirs=if(Test-Path $base){Get-ChildItem $base -Recurse -Directory -Filter JXLNovorius -ErrorAction SilentlyContinue | Where-Object {$_.Parent.Name -eq 'Addons' -and (Test-Path (Join-Path $_.FullName 'JXLNovorius.Addon.dll'))}}
foreach($d in $dirs){if((Read-Host "Remove $($d.FullName)? [y/N]") -eq 'y'){Remove-Item -LiteralPath $d.FullName -Recurse -Force}}
Write-Host 'For custom install locations remove only Programs64\Addons\JXLNovorius manually. Existing macro/engine files are retained.'
Read-Host 'Press Enter'
