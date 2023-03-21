# Demo script for "Scripts" module
break

#region Powershell Scripts

# copy/paste this code into new script and save script to disk as TestScript.ps1

<#
Write-Host ‘Start of script’ -BackgroundColor Green
Write-Host ‘Display the % CPU Time utilization by the ISE’ -BackgroundColor Green
Get-Counter ‘\Process(powershell_ise)\% Processor Time’ 
#>

#endregion

#region Running Scripts

## Use previous demo script code for first part of demo
# run using full path to script
C:\Temp\TestScript.ps1

# navigate to script path
cd c:\temp

# start script dot notation from current path
.\TestScript.ps1

# launch Explorer to show running from GUI
explorer c:\temp
# right-click TestScript.ps1 --> Run with Powershell


########
# Parameters in Scripts
########

# copy/paste this code into new script and save script to disk as c:\Temp\ScriptParamExample.ps1
<#
param ($computername)

$result = Test-Connection -ComputerName $computername -Quiet -Count 1
Write-Host $result 
#>

# navigate to script path
cd c:\temp

# start script dot notation from current path
.\ScriptParamExample.ps1 -computername localhost

# start script dot notation from current path
.\ScriptParamExample.ps1 -computername DoesNotExist

#endregion

#region Execution Policy

<# Consider demoing the following:
- Change execution policy to restricted, fail to turn script
- Change back to something else, successfully run script
- Show precedence by setting multiple different levels
#>

# Display current policy:
Get-ExecutionPolicy

# Change current policy:
Set-ExecutionPolicy Restricted

# Display current policy:
Get-ExecutionPolicy

# Try to run the script from the previous demo
C:\Temp\TestScript.ps1
# this should error

#Change current policy:
Set-ExecutionPolicy RemoteSigned

# Display current policy again
Get-ExecutionPolicy

# Try to run the script from the previous demo
C:\Temp\TestScript.ps1

# Display all current policies:
Get-ExecutionPolicy –List

# Set policy to restricted
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted

# Try to run the script from the previous demo
C:\Temp\TestScript.ps1

# Set policy to unrestricted:
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted

# Try to run the script from the previous demo 
C:\Temp\TestScript.ps1

#endregion

#region Block comments

 # single line comment 
   
 <# multi line
      comment
 #>

#endregion

#region Param Statement and Requires Statement

# You can use the script from the previous demo

# Add the "#requires" statement --> #requires –RunAsAdministrator
# --> Rerun the script

# Add the “#requires” statement --> #requires –version 5.1
# --> Rerun the script

# Change the requires statement for version --> #requires –version 10
# --> Rerun the script

#endregion

#region Command Precedence
# *OPTIONAL - code alread on slides

# run normal cmdlet
Get-Process system

# Create function with same name as cmdlet
Function Get-Process {"This isn’t the Get-Process cmdlet"} 

# run command again
Get-Process 

# run normal cmdlet with full path
Microsoft.PowerShell.Management\Get-Process -Name System

# remove function name (Providers explained in another module)
Remove-Item function:\Get-Process

# verify cmdlet now runs without full path
Get-Process 

#endregion 
