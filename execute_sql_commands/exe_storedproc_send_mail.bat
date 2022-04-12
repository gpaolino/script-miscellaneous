@echo off

for /f %%a in ('powershell -Command "Get-Date -format yyyyMMdd"') do set datetime=%%a

SQLCMD -b -S HOST,PORT -U User -P Password -i "C:\mypath\storedproc_script.sql"

SQLCMD -b -S HOST,PORT -U User -P Password -i "C:\mypath\storedproc_script.sql" -o "C:\mypath\log_file.txt"

findstr /i /c:"Messagio - OK" "C:\mypath\log_file.txt"
if %errorlevel% equ 0 (set esito=OK) else (set esito=ERR)

powershell -Command "Send-MailMessage -To pippo@mydomain.it -from noreply@mydomain.it -Subject $env:computername' - OGGETTO - DATA %datetime% - %esito%' -Body 'Vedi report di dettaglio allegato (C:\mypath\)' -Attachments C:\mypath\log_file.txt -SmtpServer myhost.mydomain.it"

EXIT 0