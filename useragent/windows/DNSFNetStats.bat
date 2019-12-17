<# : batch portion
@echo off & setlocal
@ECHO OFF
REM Version 0.3
REM Created by Josh Lamb on 7NOV18
Revisioned by Jon Cohen on 11DEC19
SETLOCAL EnableDelayedExpansion
TITLE DNSFILTER DEBUGGER
SET workdir=C:\temp
IF not exist %workdir% mkdir %workdir%
SET adapterlist="Local Area Connection" "Ethernet" "Wireless Network Connection" "Wi-Fi"
CLS
GOTO CHECK_PERMISSIONS
:CHECK_PERMISSIONS
ECHO Administrative permissions required. Detecting permissions...
net session >nul 2>&1
IF %errorLevel% == 0 (
    ECHO Success: Administrative permissions confirmed.
    GOTO MENU
) ELSE (
    ECHO Failure: Current permissions inadequate. Launch CMD as Admin.
    PAUSE >nul
    GOTO :EOF
)
:MENU
CLS
Echo:
ECHO ................................................
ECHO DNSFILTER.COM DEBUGGER v0.3
ECHO ................................................
Echo:
Echo:
PAUSE
GOTO DEBUG
:DEBUG
CLS
SET debugfile=%workdir%\debugfile.txt
IF exist %debugfile% del %debugfile%
Echo:
ECHO ...............................................
ECHO DEBUGGING DUMP
ECHO ...............................................
Echo:
Echo:
ECHO This will run a series of network commands
ECHO so that the output can be evaluated.
Echo:
Echo:
ECHO The results will be written to %debugfile%
Echo:
Echo:
ECHO Checking User Agent registry values
ECHO ----------------------------------- > %debugfile%
ECHO Checking User Agent registry values >> %debugfile%
ECHO ----------------------------------- >> %debugfile%
Echo:
Echo:
REG QUERY HKLM\SOFTWARE\DNSFilter\Agent >> %debugfile%
REG QUERY HKLM\SOFTWARE\DNSAgent\Agent >> %debugfile%
ECHO Checking for HyperV
ECHO --------------------------- >> %debugfile%
SC QUERY vmms >nul
IF %errorlevel%==0 ECHO HYPERV INSTALLED >> %debugfile%
IF %errorlevel%==1060 ECHO hyperv not installed >> %debugfile%
IF %errorlevel%==1722 ECHO hyperv test inconclusive >> %debugfile%
ECHO --------------------------- >> %debugfile%
Echo:
Echo:
ECHO Querying the agent service
ECHO --------------------------- >> %debugfile%
ECHO QUERYING THE AGENT SERVICE  >> %debugfile%
ECHO --------------------------- >> %debugfile%
Echo:
Echo:
SC QUERY "DNS Agent" >> %debugfile%
SC QUERY "DNSFilter Agent" >> %debugfile%
ECHO Getting adapter information
ECHO --------------------------- >> %debugfile%
ECHO GETTING ADAPTER INFORMATION >> %debugfile%
ECHO --------------------------- >> %debugfile%
Echo:
Echo:
ipconfig /all >> %debugfile%
REM (FOR %%a in (%adapterlist%) DO (
REM    netsh interface ip show config %%a >> %debugfile%
REM ))
ECHO Attempting ping to 8.8.8.8
ECHO -------------------------- >> %debugfile%
ECHO ATTEMPTING PING TO 8.8.8.8 >> %debugfile%
ECHO -------------------------- >> %debugfile%
Echo:
Echo:
ping -n 4 8.8.8.8 >> %debugfile%
ECHO Attempting nslookups
ECHO -------------------- >> %debugfile%
ECHO ATTEMPTING NSLOOKUPS >> %debugfile%
ECHO -------------------- >> %debugfile%
ECHO nslookup -type=txt debug.dnsfilter.com >> %debugfile%
ECHO -------------------------------------- >> %debugfile%
nslookup -type=txt debug.dnsfilter.com >> %debugfile%
ECHO ---------------------------------------------------- >> %debugfile%
ECHO nslookup -type=txt debug.dnsfilter.com 103.247.36.36 >> %debugfile%
ECHO ---------------------------------------------------- >> %debugfile%
nslookup -type=txt debug.dnsfilter.com 103.247.36.36 >> %debugfile%
ECHO ---------------------------------------------------- >> %debugfile%
ECHO nslookup -type=txt debug.dnsfilter.com 103.247.37.37 >> %debugfile%
ECHO ---------------------------------------------------- >> %debugfile%
nslookup -type=txt debug.dnsfilter.com 103.247.37.37 >> %debugfile%
ECHO ---------------------------------------------------- >> %debugfile%
Echo:
Echo:
ECHO Checking for conflicting local resolvers
ECHO ---------------------------------------- >> %debugfile%
ECHO CHECKING FOR CONFLICTING LOCAL RESOLVERS >> %debugfile%
ECHO ---------------------------------------- >> %debugfile%
Echo:
Echo:
netstat -an | findstr 53 >> %debugfile%
ECHO FINISHED!!
ECHO THE RESULTS HAVE BEEN WRITTEN TO %debugfile%
(for %%I in ("%~f0";%*) do @echo(%%~I) | ^
powershell -noprofile "$argv = $input | ?{$_}; iex (${%~f0} | out-string)"
goto :EOF
: end batch / begin powershell #>
$S = -join ((65..90) + (97..122) | Get-Random -Count 40 | % {[char]$_})
($S | Set-Clipboard)
$variable = Get-Clipboard
# Build the URI (Universal Resource Identifier), also known as the Resource or Endpoint
$uri = "https://$variable.ipleak.net/json/"
# Submit the request to the RESTful Resource using the GET method
try
{
    $r = Invoke-WebRequest -Uri $uri -Headers $global -Method Get
    $result = ConvertFrom-Json -InputObject $r.Content
}
catch
{
    throw $_
}

Write-host $S

#Output result and format
$result | Select-Object -Property country_code,country_name,region_code,region_name,continent_code,continent_name,city_name,postal_code,postal_confidence,latitude,longitude,accuracy_radius,time_zone,metro_code,level,cache,ip,reverse,tor,query_text,query_type,query_date |
 Format-Custom country_code,country_name,region_code,region_name,continent_code,continent_name,city_name,postal_code,postal_confidence,latitude,longitude,accuracy_radius,time_zone,metro_code,level,cache,ip,reverse,tor,query_text,query_type,query_date
 $part1= $result | Select-Object -index 1,2
$part2= $result | Select-Object -last 2
echo $null | clip.exe
write-output  "..............................................." | out-file c:\temp\debugfile.txt -Encoding "UTF8" -Append
write-output "DNSLeak.net results:" $part1 `n $part2 | out-file c:\temp\debugfile.txt -Encoding "UTF8" -Append
write-output  "..............................................." | out-file c:\temp\debugfile.txt -Encoding "UTF8" -Append
write-output "Unique string:" $S | out-file c:\temp\debugfile.txt -Encoding "UTF8" -Append
write-output  "..............................................." | out-file c:\temp\debugfile.txt -Encoding "UTF8" -Append
$content = Get-Content c:\temp\debugfile.txt
$content | Foreach {$_.Trim()} | Set-Content c:\temp\debugfile.txt