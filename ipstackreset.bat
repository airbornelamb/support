@ECHO OFF
REM Version 0.1
REM Created by Josh Lamb on 10OCT18
SETLOCAL EnableDelayedExpansion
TITLE TCP/IP STACK RESETTER
CLS

GOTO CHECK_PERMISSIONS

:CHECK_PERMISSIONS
ECHO Administrative permissions required. Detecting permissions...
net session >nul 2>&1
IF %errorLevel% == 0 (
    ECHO Success: Administrative permissions confirmed.
    GOTO STACKRESET
) ELSE (
    ECHO Failure: Current permissions inadequate. Launch CMD as Admin.
    PAUSE >nul
    GOTO :EOF
)

:STACKRESET
netsh int ip reset ipresetlog.txt
netsh winsock reset winsockresetlog.txt
ipconfig /release
ipconfig /flushdns
ipconfig /renew
ipconfig /flushdns
