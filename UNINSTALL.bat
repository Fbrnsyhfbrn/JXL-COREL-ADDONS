@echo off
set "DECK_UNINSTALL=%~dp0uninstall.ps1"
powershell -NoProfile -Command "Start-Process powershell.exe -Verb RunAs -Wait -ArgumentList ('-NoProfile -ExecutionPolicy Bypass -File '+[char]34+$env:DECK_UNINSTALL+[char]34)"
pause
