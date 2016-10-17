@ECHO OFF
:: Beginning of Script
:: Start of Configurable Section
set ORACLE_HOME=C:\oracle\product\12.1\db_1
set ORACLE_SID=MOBDB10
set TOOLHOME=C:\TOOLS
set BACKUP_MEDIA=DISK
set BACKUP_TYPE=FULL_DB_BKUP
set MAXPIECESIZE=16G
set BACKUP_MOUNTPOINT=c:\oracle\flash
set DBAEMAIL="dbas@proligence.com"
set DBAPAGER="dba.ops@proligence.com"
set CATALOG_CONN=%ORACLE_SID%/%ORACLE_SID%@catalog
set MS=mail.proligence.com
::
:: end of Configurable Section
::
set BACKUP_LOC_PREFIX=%BACKUP_MOUNTPOINT%\loc
set TMPDIR=C:\temp
set NLS_DATE_FORMAT="MM/DD/YY HH24:MI:SS"
realdate /d /s="set curdate=" > %TOOLHOME%\tmp_dt.bat
realdate /t /s="set curtime=" > %TOOLHOME%\tmp_tm.bat
call %TOOLHOME%\tmp_dt.bat
call %TOOLHOME%\tmp_tm.bat
::
::
set LOG=%TOOLHOME%\%ORACLE_SID%_%BACKUP_TYPE%_%BACKUP_MEDIA%_%CURDATE%_%CURTIME%.log
set TMPLOG=%TOOLHOME%\tmplog.$$
::
:: Build the Command File
set FORMATSTRING=%BACKUP_LOC_PREFIX%1\%ORACLE_SID%_%%u_%%p.rman
set CMDFILE=%TOOLHOME%\%ORACLE_SID%.rman
echo run { > %CMDFILE%
echo  allocate channel c1 type disk >> %CMDFILE%
echo    format '%FORMATSTRING%' >> %CMDFILE%
echo    maxpiecesize %MAXPIECESIZE%; >> %CMDFILE%
echo  backup >> %CMDFILE%
echo    tablespace users; >> %CMDFILE%
echo  release channel c1; >> %CMDFILE%
echo } >> %CMDFILE%
:: End of Command File Generation
::
echo Starting the script > %LOG%
%ORACLE_HOME%\bin\rman target=/ catalog=%CATALOG_CONN% @%CMDFILE% log=%TMPLOG%
::
:: Merge the Logfiles
type %TMPLOG% >> %LOG%
:: Check for errors
::
echo THE OUTPUT WAS %ERRORLEVEL% >> %LOG%
findstr /i "error" %LOG%
if errorlevel 0 if not errorlevel 1 bmail -s %MS%  -t %DBAPAGER% "Database" -m %LOG%
@echo on