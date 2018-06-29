@ECHO OFF

REM
REM -----------------------------------------------------------------------------------
REM
REM Main user backup script. This is called via Group Policy on logon and logoff
REM
REM V1.1	03/11/2009	DH, MH		First release of script
REM V1.2	11/11/2009	DH		Update for Windows XP Documents + powershell for sharepoint list
REM
REM -----------------------------------------------------------------------------------
REM

cls
echo Note: This backup script is important!
echo Note: It sends your backups to \\fileserver\UserBackups\Data%username%
echo.  
echo.  
echo.  

REM -- Dont run if the user has loged into a server unless the first parameter is backup --
IF "%1"=="backup" GOTO Continue

systeminfo | find "OS Name:" | find "Server" > nul
if not errorlevel 1 goto exit

:Continue






mkdir \\flea\UserBackups\Data%UserName%

IF EXIST "c:\inetpub\wwwroot" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au wwwroot "c:\inetpub\wwwroot"

IF EXIST "C:\Data%UserName%" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au Data%UserName% "C:\Data%UserName%"
IF EXIST "D:\Data%UserName%" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au Data%UserName% "D:\Data%UserName%"
REM IF EXIST "E:\Data%UserName%" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au Data%UserName% "E:\Data%UserName%"

IF EXIST "%UserProfile%\Desktop" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au Desktop "%UserProfile%\Desktop"

IF EXIST "%UserProfile%\Documents" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au MyDocuments "%UserProfile%\Documents"
IF EXIST "%UserProfile%\My Documents" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au MyDocuments "%UserProfile%\My Documents"

IF EXIST "%UserProfile%\Favorites" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au Favorites "%UserProfile%\Favorites"

IF EXIST "%UserProfile%\Application Data\Microsoft\Outlook" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au OutlookAutocomplete "%UserProfile%\Application Data\Microsoft\Outlook"


REM ---- For Ana only ----
IF EXIST "c:\GeneralFinance" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au GeneralFinance "c:\GeneralFinance"
IF EXIST "D:\DataAnastasiaCogan_Misc" call \\flea\UserBackups\ztBackupScripts\Robocopy.bat \\flea\UserBackups\Data%UserName% %UserName%@ssw.com.au DataAnastasiaCogan_Misc "d:\DataAnastasiaCogan_Misc"




REM ---------- Log Backup Completed -----------------------

REM call \\flea\UserBackups\ztBackupScripts\CreateLog.bat %UserName%
powershell.exe ExecutionPolicy RemoteSigned
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "\\flea\UserBackups\ztBackupScripts\CreateLog2.ps1"
PowerShell "\\flea\UserBackups\ztBackupScripts\invoke-InsertUpdateBackup.ps1 %UserName%"

REM -------------------------------------------------------

echo Backup Done!

call \\flea\UserBackups\ztBackupScripts\beep.bat

:exit
REM pause
