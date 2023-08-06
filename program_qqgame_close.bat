@ECHO OFF

::不显示窗口
if "%1"=="hide" goto CmdBegin
start mshta vbscript:createobject("wscript.shell").run("""%~0"" hide",0)(window.close)&&exit
:CmdBegin

set NOW_HOUR=%time:~0,2%
::10点之前启用该规则
set MIN_CLOSE_HOUR=10
::22点之后启用该规则
set MAX_CLOSE_HOUR=22
if %NOW_HOUR% GEQ %MIN_CLOSE_HOUR% (
	if %NOW_HOUR% LEQ %MAX_CLOSE_HOUR% (
	    exit
	    )
	)

::设置管理员权限
::%SYSTEMROOT%\system32\config\system
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\Configuration"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"

::设定规则名称及程序路径
set Rule_Name="program_qqgame"
set Rule_Dir="C:\Program Files (x86)\Tencent\QQGameTempest"

setlocal enabledelayedexpansion
set /a n=0
for /R %Rule_Dir% %%i in (*.exe) do (
    set /a n+=1
    netsh advfirewall firewall del rule name="%Rule_Name%_!n!">nul 2>nul
    netsh advfirewall firewall add rule name="%Rule_Name%_!n!" program="%%i" action=block dir=out>null
)


