@echo off

for /f %%a in ('powershell -Command "Get-Date -format yyyy-MM-dd_HH-mm-ss"') do set datetime=%%a

xcopy C:\mypath\logfile.csv C:\mypath\old_logs\%datetime%.csv*
if %errorlevel% equ 1 goto errore

EXIT 0

:errore
echo Il file %datetime%.log non è stato storicizzato correttamente in "C:\mypath\old_logs\"
rem pause
EXIT 1