@ECHO OFF
FOR %%F IN (%0) DO SET DIRNAME=%%~DPF
DEL CMP.LOG MASTER.DAT DUMP.DAT
"%DIRNAME%SCOPE" -p %1 -d %2 -h %3 > MASTER.DAT
IF %ERRORLEVEL% NEQ 0 EXIT
ECHO MEMORY DUMPED
ECHO CHECKING LFSR DATA
"%DIRNAME%CHECK" -d %2 < MASTER.DAT
IF %ERRORLEVEL% NEQ 0 (
	ECHO UNSUCCESSFUL CHECK
	EXIT /B 1
)
REM ECHO MASTER DUMP OK
SET I=1
:NEXT
  	"%DIRNAME%SCOPE" -p %1 -d %2 -h %3 > DUMP.DAT 2> NUL
	IF %ERRORLEVEL% NEQ 0 EXIT
 	CMP MASTER.DAT DUMP.DAT> CMP.LOG
	IF %ERRORLEVEL% EQU 0 (
		ECHO DUMP %I% OK
		SET /A I=%I%+1
		GOTO NEXT
	)
	FOR /F "DELIMS=" %%I IN ('AWK "{print $7}" CMP.LOG') DO SET LINE=%%I
ECHO LINE %LINE% IS DIFFERENT
ECHO "--------------" 
ECHO "- MASTER.DAT -" 
ECHO "--------------" 
TAIL -n +%LINE% MASTER.DAT 2>NUL|HEAD
ECHO "------------" 
ECHO "- DUMP.DAT -"
ECHO "------------" 
TAIL -n +%LINE% DUMP.DAT 2>NUL|HEAD
