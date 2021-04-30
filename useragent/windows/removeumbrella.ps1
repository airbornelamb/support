#!ps
#timeout=10000000
#### This Script is checking to see if Cisco Umbrella is still installed and then taking the appropriate action ####
Start-Transcript -path C:\Windows\Logs\Generic-UninstallUmbrella_Log.txt -append
function UninstallProgram
{
    #### Use wmic to uninstall Umbrella (Cisco Support website preferred command line uninstall method 1) ####
   wmic Product where “name=‘Umbrella Roaming Client’” call uninstall /NoInteractive
}
function Check_Program_Installed
{  
#### Get the current status for Umbrella as an installed service ####
   Write-Host “Checking Current Status of Umbrella Roaming Client”
    $Installed = [boolean] (Get-WmiObject Win32_Service | Where {$_.name -eq “Umbrella_RC”})
    if ($Installed -ceq $True) {
       Write-Host “Uninstalling Cisco Umbrella Roaming Client”
       UninstallProgram
   }
    else
   {
       Write-Host “Cisco Umbrella Roaming Client is not Installed, taking no action”
   }
   }
#### Call Function to determine boolean installed status ####
Check_Program_Installed
#### Write out the Boolean Is Installed answer one more time for logging ####
write-host “Current Status of Umbrella is - $Installed”
Stop-Transcript
