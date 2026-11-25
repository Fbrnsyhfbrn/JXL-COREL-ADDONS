param([string]$CorelPrograms = '', [string]$EngineExe = '', [switch]$Deploy, [string]$Payload = '')
$ErrorActionPreference='Stop'
function Find-Corel {
 if ($CorelPrograms) { return (Resolve-Path -LiteralPath $CorelPrograms).Path }
 $paths = @()
 foreach($key in @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\CorelDRW.exe','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\CorelDRW.exe')) {
  if(Test-Path $key){ $v=(Get-Item $key).GetValue(''); if($v){$paths += $v.Trim('"')} }
 }
 $base=Join-Path $env:ProgramFiles 'Corel'
 if(Test-Path $base){ $paths += @(Get-ChildItem $base -Filter CorelDRW.exe -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object FullName) }
 foreach($p in ($paths | Select-Object -Unique)) {
  if((Test-Path -LiteralPath $p) -and ((Get-Item -LiteralPath $p).VersionInfo.FileMajorPart -eq 27)){ return (Split-Path -Parent $p) }
 }
 throw 'CorelDRAW 2026 (v27) not found. Run install.ps1 -CorelPrograms "C:\...\Programs64".'
}
$programs=Find-Corel
$exe=Join-Path $programs 'CorelDRW.exe'
if(!(Test-Path $exe) -or (Get-Item $exe).VersionInfo.FileMajorPart -ne 27){throw 'This preview targets CorelDRAW 2026 v27 only.'}
if(Get-Process CorelDRW -ErrorAction SilentlyContinue){throw 'Close CorelDRAW completely and run installer again.'}
$dest=Join-Path $programs 'Addons\JXLNovorius'
if($Deploy){
 if(!(Test-Path (Join-Path $Payload 'JXLNovorius.cpg')) -or !(Test-Path (Join-Path $Payload 'JXLNovorius.Addon.dll')) -or !(Test-Path (Join-Path $Payload 'engine\novorius.exe'))){throw 'Incomplete payload.'}
 $backup=$null
 if(Test-Path $dest){
  if(!(Test-Path (Join-Path $dest 'Coreldrw.addon')) -or !(Test-Path (Join-Path $dest 'JXLNovorius.Addon.dll'))){throw 'Existing folder is not a recognized JXL Novorius installation.'}
  $backup=Join-Path $env:LOCALAPPDATA ('JXLNovorius\backup-'+[guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path (Split-Path $backup -Parent) -Force | Out-Null
  Move-Item -LiteralPath $dest -Destination $backup
 }
 try {
  New-Item -ItemType Directory -Path $dest -Force | Out-Null
  Copy-Item -Path (Join-Path $Payload '*') -Destination $dest -Recurse -Force
  Get-ChildItem $dest -Recurse -File | Unblock-File
  Write-Host "Installed: $dest"
  if($backup){Write-Host "Previous installation backed up: $backup"}
 } catch {
  if(Test-Path $dest){Remove-Item -LiteralPath $dest -Recurse -Force}
  if($backup){Move-Item -LiteralPath $backup -Destination $dest}
  throw
 }
 exit 0
}
Write-Host "Detected: $programs"
$interop=Get-ChildItem $programs -Recurse -File -Filter Corel.Interop.VGCore.dll | Select-Object -First 1
if(!$interop){throw 'Corel.Interop.VGCore.dll missing from Programs64.'}
$framework=Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319'
$csc=Join-Path $framework 'csc.exe'
if(!(Test-Path $csc)){throw '.NET Framework C# compiler missing.'}
$build=Join-Path $env:LOCALAPPDATA ('JXLNovorius\addon-build-'+[guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path (Join-Path $build 'engine') -Force | Out-Null
$references=@($interop.FullName,(Join-Path $framework 'System.Xaml.dll'),(Join-Path $framework 'WPF\WindowsBase.dll'),(Join-Path $framework 'WPF\PresentationCore.dll'),(Join-Path $framework 'WPF\PresentationFramework.dll'))
foreach($r in $references){if(!(Test-Path $r)){throw "Missing assembly: $r"}}
$compilerArgs=@('/nologo','/target:library','/platform:x64','/optimize+','/langversion:5',('/out:'+(Join-Path $build 'JXLNovorius.Addon.dll')))+@($references | ForEach-Object { '/reference:'+$_ })+@(Join-Path $PSScriptRoot 'host\DockerUI.cs')
& $csc @compilerArgs
if($LASTEXITCODE -ne 0){throw 'Add-on compilation failed. Send compiler output.'}
# Build native startup host against the installed Corel type library.
$vswhere=Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
$vc=$null
if(Test-Path $vswhere){
 $vs=& $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath | Select-Object -First 1
 if($vs){$vc=Join-Path $vs 'VC\Auxiliary\Build\vcvars64.bat'}
}
if(!$vc -or !(Test-Path $vc)){throw 'Native auto-start requires MSVC x64. Open Visual Studio Installer > Modify > Desktop development with C++ and Windows SDK. No files deployed.'}
$tlb=Get-ChildItem (Split-Path $programs -Parent) -Recurse -File -Filter VGCoreAuto.tlb -ErrorAction SilentlyContinue | Select-Object -First 1
if(!$tlb){throw 'Matching VGCoreAuto.tlb not found.'}
Copy-Item $tlb.FullName (Join-Path $build 'VGCoreAuto.tlb')
Copy-Item (Join-Path $PSScriptRoot 'host\startup.cpp') $build
@"
@echo off
call "$vc" || exit /b 1
cd /d "$build"
cl /nologo /std:c++17 /EHsc /O2 /MT /DUNICODE /D_UNICODE /LD startup.cpp /link /OUT:JXLNovorius.cpg ole32.lib oleaut32.lib comsuppw.lib uuid.lib
exit /b %errorlevel%
"@ | Set-Content (Join-Path $build 'build-native.cmd') -Encoding Default
& cmd.exe /c ('"'+(Join-Path $build 'build-native.cmd')+'"') 2>&1 | Tee-Object -FilePath (Join-Path $build 'native-build.log')
$nativeExit=$LASTEXITCODE
if($nativeExit -ne 0 -or !(Test-Path (Join-Path $build 'JXLNovorius.cpg'))){throw "Native startup compilation failed. Full log: $build\native-build.log"}
Copy-Item (Join-Path $PSScriptRoot 'host\*.xslt') $build
Copy-Item (Join-Path $PSScriptRoot 'host\Coreldrw.addon') $build
if(!$EngineExe){
 if(!(Get-Command py -ErrorAction SilentlyContinue)){throw 'Install Python 3.12 x64 on this build PC.'}
 & py -3.12 -m venv (Join-Path $build 'venv'); if($LASTEXITCODE -ne 0){throw 'Python venv failed.'}
 $python=Join-Path $build 'venv\Scripts\python.exe'
 & $python -m pip install -r (Join-Path $PSScriptRoot 'engine\requirements.txt') pyinstaller
 if($LASTEXITCODE -ne 0){throw 'Decoder dependency installation failed.'}
 Push-Location (Join-Path $PSScriptRoot 'engine')
 try { & $python -m PyInstaller --noconfirm --clean --onefile --name novorius --collect-all pillow_jxl --distpath (Join-Path $build 'dist') --workpath (Join-Path $build 'work') --specpath $build deck.py; if($LASTEXITCODE -ne 0){throw 'Engine build failed.'} } finally {Pop-Location}
 $EngineExe=Join-Path $build 'dist\novorius.exe'
}
$engineTarget=Join-Path $build 'engine\novorius.exe'
Copy-Item -LiteralPath $EngineExe -Destination $engineTarget
& $engineTarget doctor
if($LASTEXITCODE -ne 0){throw 'Engine doctor failed.'}
$job=Join-Path $build 'test-job'; New-Item -ItemType Directory -Path $job | Out-Null
[IO.File]::WriteAllText((Join-Path $job 'input.txt'),(Join-Path $PSScriptRoot 'tests\fixtures\alpha_lossless.jxl'),[Text.Encoding]::Unicode)
& $engineTarget job $job
if($LASTEXITCODE -ne 0 -or !(Test-Path (Join-Path $job 'image.png'))){throw 'Engine fixture failed.'}
foreach($format in @('png','gif','jpg','webp','tiff','bmp')){
 $out=Join-Path $job ('export.'+$format)
 & $engineTarget export (Join-Path $PSScriptRoot 'tests\fixtures\alpha_lossless.jxl') $out --format $format --quality 95
 if($LASTEXITCODE -ne 0 -or !(Test-Path $out)){throw "Novorius export smoke test failed: $format"}
}
# Deploy only the runtime files, not build tools/venv.
$payloadDir=Join-Path $build 'payload'; New-Item -ItemType Directory -Path $payloadDir | Out-Null
foreach($name in @('JXLNovorius.Addon.dll','JXLNovorius.cpg','Coreldrw.addon','AppUI.xslt','UserUI.xslt','engine')){Copy-Item -LiteralPath (Join-Path $build $name) -Destination $payloadDir -Recurse}
$argsLine='-NoProfile -ExecutionPolicy Bypass -File "'+$PSCommandPath+'" -Deploy -CorelPrograms "'+$programs+'" -Payload "'+$payloadDir+'"'
$p=Start-Process powershell.exe -ArgumentList $argsLine -Verb RunAs -Wait -PassThru
if($p.ExitCode -ne 0){throw 'Elevated installation failed.'}
Write-Host 'Installed. Restart CorelDRAW. Check startup log and Window > Dockers > JXL Novorius.' -ForegroundColor Green
