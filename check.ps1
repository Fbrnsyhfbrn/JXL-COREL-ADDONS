$ErrorActionPreference='Continue'
$log=Join-Path $env:TEMP 'JXLNovorius-diagnostics.txt'
Start-Transcript -Path $log -Force
try {
 $base=Join-Path $env:ProgramFiles 'Corel'
 $exes=Get-ChildItem $base -Filter CorelDRW.exe -Recurse -File -ErrorAction SilentlyContinue | Where-Object {$_.VersionInfo.FileMajorPart -eq 27}
 foreach($exe in $exes){
  $dest=Join-Path $exe.DirectoryName 'Addons\JXLNovorius'
  Write-Host "Expected addon: $dest"
  foreach($name in @('JXLNovorius.cpg','Coreldrw.addon','AppUI.xslt','UserUI.xslt','JXLNovorius.Addon.dll','engine\novorius.exe')){
   $path=Join-Path $dest $name
   if(Test-Path $path){Get-Item $path | Select-Object FullName,Length,LastWriteTime | Format-List}else{Write-Host "MISSING: $path"}
  }
 }
 $root=Join-Path $env:APPDATA 'Corel'
 Get-ChildItem $root -Recurse -File -Filter '*.xml' -ErrorAction SilentlyContinue | ForEach-Object {
  $raw=Get-Content $_.FullName -Raw
  Write-Host ('Workspace: '+$_.FullName+' | Docker menu GUID: '+$raw.Contains('3eaa9bbe-28fd-4672-9128-02974ee96332')+' | Deck GUID: '+$raw.Contains('5fc642e6-edef-4046-9736-53108abce563'))
 }
 $startup=Join-Path $env:LOCALAPPDATA 'JXLNovorius\startup.log'
 if(Test-Path $startup){Get-Content $startup -Tail 30}else{Write-Host 'No native startup log yet.'}
 $hostlog=Join-Path $env:LOCALAPPDATA 'JXLNovorius\addon.log'
 if(Test-Path $hostlog){Get-Content $hostlog -Tail 30}else{Write-Host 'No docker constructor/import log yet.'}
 $conversion=Join-Path $env:LOCALAPPDATA 'JXLNovorius\conversion.log'
 if(Test-Path $conversion){Get-Content $conversion -Tail 60}else{Write-Host 'No conversion log yet.'}
}finally{Stop-Transcript; Write-Host "Send this report: $log"}
