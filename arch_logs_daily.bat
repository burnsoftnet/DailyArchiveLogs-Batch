@echo off
SET LOGPATH=C:\SomeApps\SomApps\Logs
SET APPPATH=%CD%
SET APPLOGPATH=%APPPATH%\log
SET APPLOGFILE=%APPLOGPATH%\arch_logs_daily.log
SET ARCH_PATH_PATH=%LOGPATH%\Archived
SET ARCH_PATH_PATH_SF=
SET DAYSBACK=-2

if not exist "%APPLOGPATH%" mkdir %APPLOGPATH%
if not exist "%ARCH_PATH_PATH%" mkdir %ARCH_PATH_PATH%

echo ---Starting Daily Archive----  >> %APPLOGFILE%
now >> %APPLOGFILE%

FOR /f "tokens=2-4 skip=1 delims=(-)" %%G IN ('echo.^|date') DO (
	FOR /f "tokens=2 delims= " %%A IN ('date /t') DO (
		SET v_first=%%G
		SET v_second=%%H
		SET v_third=%%I
		SET v_all=%%A
		)
	)

SET %v_first%=%v_all:~0,2%
SET %v_second%=%v_all:~3,2%
SET %v_third%=%v_all:~6,4%
SET DATE2=%MM%_%DD%_%YY%

SET ARCH_PATH_PATH_SF=%ARCH_PATH_PATH%\%DATE2%

mkdir %ARCH_PATH_PATH_SF% >> %APPLOGFILE%

forfiles -p "%LOGPATH%" -m *.* -d %DAYSBACK% -c "cmd /c makecab @path @path.cab"
forfiles -p "%LOGPATH%" -m *.cab -c "cmd /c move /Y @path %ARCH_PATH_PATH_SF%\"
forfiles -p "%LOGPATH%" -m *.* -d %DAYSBACK% -c "cmd /c del /Q @path"

echo ---Ending Daily Archive----  >> %APPLOGFILE%
now >> %APPLOGFILE%
exit 0