@ECHO OFF

REM
REM The following table defines the command-line options that you can use with Robocopy.
REM Switch	Function Performed
REM
REM /S	Copies subdirectories (excluding empty ones).
REM /E	Copies all subdirectories (including empty ones).
REM /LEV:n	Copies only the top n levels of the source directory tree.
REM /Z	Copies files in restartable mode (that is, restarts the copy process from the point of failure).
REM /SEC	Copies NTFS security information. (Source and destination volumes must both be NTFS.)
REM /SECFIX	Applies the NTFS permissions set for source files and directories to existing destination files and directories.
REM /TIMFIX	Applies a time stamp to all destination files (including skipped files).
REM /MOV	Moves files (that is, deletes source files after copying).
REM /MOVE	Moves files and directories (that is, deletes source files and directories after copying).
REM /PURGE	Deletes destination files and directories that no longer exist in the source.
REM /MIR	Mirrors a directory tree (equivalent to running both /E and /PURGE).
REM /A+:[R][A][S][H	Sets the specified attributes in copied files.
REM /A-:[R][A][S][H]	Turns off the specified attributes in copied files.
REM /CREATE	Creates a directory tree structure containing zero-length files only (that is, no file data is copied).
REM /FAT 	Creates destination files using only 8.3 FAT file names.
REM /IA:[R][A][S][H]	Includes files with the specified attributes.
REM /XA:[R][A][S][H]	Excludes files with the specified attributes.
REM /A	Copies only files with the archive attribute set.
REM /M	Copies only files with the archive attribute set and then resets (turns off) the archive attribute in the source files.
REM /XF file [file]	Excludes files with the specified names, paths, or wildcard characters.
REM /XD dir [dir]	Excludes directories with the specified names, paths, or wildcard characters.
REM /XC 	Excludes files tagged as "Changed".
REM /XN 	Excludes files tagged as "Newer".
REM /XO 	Excludes files tagged as "Older"..
REM /XX 	Excludes files and directories tagged as "Extra".
REM /XL 	Excludes files and directories tagged as "Lonely".
REM /IS 	Includes files tagged as "Same".
REM /MAX:n	Excludes files larger than n bytes.
REM /MIN:n	Excludes files smaller than n bytes.
REM /MAXAGE:n	Excludes files older than n days or specified date. If n is less than 1900, then n is expressed in days. Otherwise, n is a date expressed as YYYYMMDD.
REM /MINAGE:n	Excludes files newer than n days or specified date. If n is less than 1900, then n is expressed in days. Otherwise, n is a date expressed as YYYYMMDD.
REM /R:n	Specifies the number of retries on failed copies. (The default is 1 million.)
REM /W:n	Specifies the wait time between retries. (The default is 30 seconds.)
REM /REG	Saves /R:n and /W:n in the registry as default settings.
REM /TBD	Waits for share names to be defined on a "Network Name Not Found" error. 
REM /L 	Lists files without copying, deleting, or applying a time stamp to any files.
REM /X 	Reports all files tagged as "Extra"(including files not selected).
REM /V 	Produces verbose output (including skipped files).
REM /NP 	Turns off copy progress indicator (% copied).
REM /ETA 	Shows estimated time of completion for copied files.
REM /LOG:file	Redirects output to the specified file, overwriting the file if it already exists.
REM /LOG+:file	Redirects output to the specified file, appending it to the file if it already exists.
REM
REM -----------------------------------------------------------------------------------
REM
REM %1 = \\sloth\e$\sswbackup\DataDanielHyles
REM %2 = danielhyles@ssw.com.au
REM %3 = Desktop 
REM %4 = "C:\Documents and Settings\danielhyles\Desktop"
REM

\\flea\UserBackups\ztBackupScripts\Robocopy\robocopy.exe %4 %1\%3 /MIR /R:5 /W:3 /LOG:%1\%3.txt /XD ProjectTFS ProjectsVss ProjectsTfs ProjectsWebVss ProjectsWinVss ProjectsWebTfs ProjectsWinTfs Downloads "Azureus Downloads" "My Music" "My Pictures" "My Videos" AppData zz* yy* "msmq" /XF zz* yy*
REM /XF *.m4v *.wmv *.avi *.mov *.mp3 *.mp4 *.m4a *.mpeg *.mpg


if errorlevel 16 echo ***FATAL ERROR***  & \\flea\UserBackups\ztBackupScripts\BackupAlert.vbs %2 "***FATAL ERROR***" %1 %3	& color c0 & goto end
if errorlevel 8  echo **FAILED COPIES**  & \\flea\UserBackups\ztBackupScripts\BackupAlert.vbs %2 "**FAILED COPIES**" %1 %3	& color c0 & goto end
if errorlevel 4  echo *MISMATCHES*       & \\flea\UserBackups\ztBackupScripts\BackupAlert.vbs %2 "*MISMATCHES*" %1 %3	& color c0 & goto end
if errorlevel 2  echo EXTRA FILES        & goto end
if errorlevel 1  echo Copy successful    & goto end
if errorlevel 0  echo --no change--      & goto end
:end