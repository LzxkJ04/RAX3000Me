@echo off
setlocal

:: 提示用户输入 SN
set /p SN=Please enter the SN: 
if "%SN%"=="" (
    echo SN cannot be empty!
    pause
    exit /b 1
)
echo SN: %SN%

:: 调用 PowerShell 生成密码
for /f "delims=" %%a in ('powershell -Command "& { . '%~dp0generate_config.ps1'; Generate-Password -SN '%SN%' }"') do set mypassword=%%a
echo Your password: %mypassword%

:: 调用 PowerShell 生成配置文件
powershell -Command "& { . '%~dp0generate_config.ps1'; Generate-Config -Password '%mypassword%' -SN '%SN%' }"

:: 暂停，等待用户按任意键
pause

endlocal