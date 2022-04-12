@echo off

forfiles /p "C:\mypath\old_logs" /s /m *.* /D -15 /C "cmd /c del @path"
if %errorlevel% equ 1 goto nessunlog

echo Pulizia vecchi query log effettuata
EXIT 0

:nessunlog
echo Nessun query log eliminato
EXIT 1