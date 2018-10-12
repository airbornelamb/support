@echo off
set LOGFILE=policycheck.txt
call :LOG > %LOGFILE%
exit /B

:LOG
nslookup -type=txt debug.dnsfilter.com.
nslookup -type=txt debug.dnsfilter.com. 103.247.36.36
nslookup -type=txt debug.dnsfilter.com. 103.247.37.37
nslookup youtube.com.
nslookup youtube.com. 103.247.36.36
nslookup youtube.com. 103.247.37.37
