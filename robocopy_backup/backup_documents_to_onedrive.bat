@echo off
setlocal

:: --- Source and destination configuration ---
:: User Documents Folder
set "SRC=%USERPROFILE%\Documents"

:: First test: OneDrive environment variable (typically for personal accounts)
if defined OneDrive (
    set "DEST=%OneDrive%\DocumentsBackup"
) else (
    :: Fallback: Try using %USERPROFILE%\OneDrive if the variable is not defined.
    set "DEST=%USERPROFILE%\OneDrive\DocumentsBackup"
)

:: --- Robocopy Options ---
:: /MIR   => mirror (Warning: Delete files in DEST that do not exist in SRC)
:: /Z     => copy in restartable mode
:: /COPY:DAT /DCOPY:T => copy data, attributes, timestamps
:: /R:3 /W:5 => retry 3 times, wait 5s
:: /NFL /NDL => no file list / no dir list
:: /NP    => no progress percent
:: /V     => verbose
:: /LOG:  => save log
set "ROBO_FLAGS=/MIR /Z /COPY:DAT /DCOPY:T /R:3 /W:5 /NFL /NDL /NP /V /XJ"

:: Log files in user's Temp folder with timestamp
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set D=%%c-%%b-%%a
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set T=%%a%%b
set "LOG=%TEMP%\backup_docs_%D%_%T%.log"

echo Source: "%SRC%"
echo Destination: "%DEST%"
echo Log: "%LOG%"
echo.

:: Create the destination if it does not exist
if not exist "%DEST%" md "%DEST%"

:: Run robocopy
robocopy "%SRC%" "%DEST%" %ROBO_FLAGS% /LOG:"%LOG%"

set "RC=%ERRORLEVEL%"

:: Robocopy return code check (0-7 are considered partial successes/ok)
if %RC% LEQ 7 (
    echo Backup completed with code robocopy %RC%.
    exit /b 0
) else (
    echo Error robocopy, code %RC%. Check the log: "%LOG%"
    exit /b %RC%
)

endlocal
