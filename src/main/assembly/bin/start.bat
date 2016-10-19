@echo off
set "JAVA_CMD=%JAVA_HOME%/bin/java"
if "%JAVA_HOME%" == "" goto noJavaHome
if exist "%JAVA_HOME%\bin\java.exe" goto mainEntry
:noJavaHome
echo ---------------------------------------------------
echo WARN: JAVA_HOME environment variable is not set. 
echo ---------------------------------------------------
set "JAVA_CMD=java"
:mainEntry
set "argLine="
:loop
if "%1"=="" goto break
set "argLine=%argLine% %1"
shift
goto loop
:break
set "CURR_DIR=%cd%"
cd ..
set "DIST_HOME=%cd%"
cd %CURR_DIR%
@echo on
"%JAVA_CMD%" -DDIST_HOME=%DIST_HOME% -cp "../conf;../lib/*" -jar ..\zk-browser.war %argLine%