@echo off

SQLCMD -b -S HOST,PORT -U User -P Password -i "C:\mypath\myscript.sql"

EXIT 0