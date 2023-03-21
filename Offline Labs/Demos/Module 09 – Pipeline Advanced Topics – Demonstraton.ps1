
#region Do not run entire file
#This is to stop F5 from being run in ISE or running the file as a ps1 script.
Write-host "When using this file in ISE, only run lines using F8." -ForegroundColor Yellow
Write-Host "Do not run this entire file in PowerShell and/or hit F5 when using ISE." -ForegroundColor Yellow
Break
#endregion

<#
.DESCRIPTION
    Workshop demo files for Foundation Skills - Pipeline Advanced Topics module

LEGAL DISCLAIMER:

This Sample Code is provided for the purpose of illustration only and is not
intended to be used in a production environment.  THIS SAMPLE CODE AND ANY
RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant You a
nonexclusive, royalty-free right to use and modify the Sample Code and to
reproduce and distribute the object code form of the Sample Code, provided
that You agree: (i) to not use Our name, logo, or trademarks to market Your
software product in which the Sample Code is embedded; (ii) to include a valid
copyright notice on Your software product in which the Sample Code is embedded;
and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and
against any claims or lawsuits, including attorneys' fees, that arise or result
from the use or distribution of the Sample Code.
#>

#Creates temp location for demos if you don't have one
New-Item -Path c:\temp -ItemType Directory 
Set-Location c:\temp


#region Pipeline Advanced Topics - Pipeline Variable
Get-Process | Where-Object {$_PriorityBoostEnabled}
Get-Process | measure
Get-Process | Where-Object {$_PriorityBoostEnabled} | measure
#endregion Pipeline Advanced Topics - Pipeline Variable

#region Pipeline Advanced Topics - Operators
$service = Get-Service alg
$service.StartType -eq "Manual"
$service.StartType -eq "Automatic"

$service.StartType -eq "M*"
$service.StartType -like "M*"

$service.Status -eq "Stopped" -and $service.StartType -like "M*"
$service.Status -eq "Running" -and $service.StartType -like "M*"
$service.Status -eq "Running" -or $service.StartType -like "M*"

#endregion Pipeline Advanced Topics - Operators

#Region Pipeline Advanced Topics - Where-Object
Get-Process | Get-Member #Shows the methods and properties available to obtain

#The three lines below have the exact same output, but look significatinly different.
Get-Process | Where-Object {$psitem.workingset64 -gt 100MB} 
Get-Process | ? {$_.ws -gt 100MB} 
Get-Process -pipelinevariable CurrentProcess | Where {$CurrentProcess.ws -gt 100Mb}

$currentprocess #notice the pipeline variable is no longer available, only within the pipeling process.

#endregion Pipeline Advanced Topics - Where-Object

#region Pipeline Advanced Topics -Foreach-Object
#This shows the basics
Get-Service net* | ForEach {"Hello $($_.Name) how are you today?"}

#This will show a longer scriptblock with line breaks
Get-Service | ForEach-Object {
    Write-Host "$($_.DisplayName) -- " -ForegroundColor Green -NoNewline
    Write-Host "$($_.Status) -- " -ForegroundColor Cyan -NoNewline
    Write-Host "$($_.StartType)" -ForegroundColor Yellow
}
#This shows you can save the scriptblock off for readability
$sb = {
    Write-Host "$($_.DisplayName) -- " -ForegroundColor Green -NoNewline
    Write-Host "$($_.Status) -- " -ForegroundColor Cyan -NoNewline
    Write-Host "$($_.StartType)" -ForegroundColor Yellow
}
Get-Service | ForEach-Object $sb
#remind them to use the full cmdlet name in a script
#aliases
Get-Service | where {$_.CanPauseAndContinue} | ForEach $sb
Get-Service | ? {$_.CanPauseAndContinue} | % $sb 

#automatic enumeration
(Get-Service).DisplayName
(Get-Service).DisplayName.ToUpper()
(Get-Process).pagedmemorysize
(Get-Process).processname
(Get-EventLog –Log System).TimeWritten.DayOfWeek | Group-Object

#This can be run on the lab environment as of the time this demo was created
0..100 | ForEach-Object { 
    New-ADUser  -Name User$_ `
      -Organization "contoso.com/Accounts" `
      -UserPrincipalName "User$_@contoso.com"  `
      -emailaddress "User$_@contoso.com"  `
      -ChangePasswordAtLogon $true `
      #-whatif
}
#endregion Pipeline Advanced Topics -Foreach-Object

#region Pipeline Advanced Topics - Pipeline Processing

#Notice c:\temp\ is used, so if running this demo make sure to have that

# This is one long line of code
Get-EventLog -LogName System -Newest 5 | ForEach-Object -Begin {Remove-Item c:\temp\Events.txt; Write-Host "Start" -ForegroundColor Yellow} -Process {$_.Message | Out-File -Filepath c:\temp\Events.txt -Append} -End  {Write-Host "End" -ForegroundColor Green; notepad.exe c:\temp\Events.txt}

# This is the same as above, but uses semi-colons for readability
Get-EventLog -LogName System -Newest 200 | ForEach-Object `
-Begin {
    Remove-Item c:\temp\Events.txt
    Write-Host "Starting the process of collection" -ForegroundColor Yellow} `
-Process {
    $_.Message | Out-File -Filepath c:\temp\Events.txt -Append} `
-End {
    Write-Host "Process now complete" -ForegroundColor Green
    notepad.exe c:\temp\Events.txt}

#this is another way to organize it without using semi-colons (since they can cause a bunch of issues)
    Get-EventLog -LogName System -Newest 200 | ForEach-Object -Begin {
        Remove-Item c:\temp\Events.txt
        Write-Host "Starting the process of collection" -ForegroundColor Yellow
    } -Process {
        $_.Message | Out-File -Filepath c:\temp\Events.txt -Append
    } -End {
        Write-Host "Process now complete" -ForegroundColor Green
        notepad.exe c:\temp\Events.txt
    }
# This line of code calls to the function defined below. 
Get-EventLog -LogName system -Newest 300 | Create-FileOfEvents
function Create-FileOfEvents {
    Begin
    {
        Remove-Item $FileNeededForThisLoop -ErrorAction SilentlyContinue
        Write-Host "Start" -ForegroundColor Yellow
    }
    Process
    {
        $_.Message | Out-File -Filepath c:\temp\Events.txt -Append
    }
    End
    {
        Write-Host "Process is now complete" -ForegroundColor Green
        notepad.exe c:\temp\Events.txt
    }
}
#endregion Pipeline Advanced Topics - Pipeline Processing

#region Pipeline Advanced Topics - Input
Get-Help Restart-Computer -full # Displays the entire cmdlet options of Restart-Computer
Get-Help Restart-Computer -Parameter ComputerName # Displays only the computer parameter. Show the input options of ByValue or ByPropertyName
Get-Help Get-Timezone -Parameter name 
"Eastern Standard Time", "Mountain Standard Time"| Get-TimeZone 
"Eastern Standard Time", "Mountain Standard Time" | ForEach-Object {Get-TimeZone -name $_} 

#Consider making a file to reflect what the slides show
Get-Help New-Alias -ShowWindow
import-csv M:\Temp\Aliases.csv | GM
import-csv M:\Temp\Aliases.csv | New-Alias
Get-Alias P,S,ping
import-csv M:\Temp\Aliases.csv | ForEach-Object {New-Alias -Name $_.Name -Value $_.Value}

#endregion Pipeline Advanced Topics - Input
