
#region Do not run entire file
#This is to stop F5 from being run in ISE or running the file as a ps1 script.
Write-host "When using this file in ISE, only run lines using F8." -ForegroundColor Yellow
Write-Host "Do not run this entire file in PowerShell and/or hit F5 when using ISE." -ForegroundColor Yellow
Break
#endregion

<#
.DESCRIPTION
    Workshop demo files for Foundation Skills - Pipeline Basics module

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

#region Pipeline Basics

#region Pipeline Basics - Pipeline Introduction

#If c:\temp does not exist, this will create it for the demos.
New-Item -Path c:\temp -ItemType Directory 

Set-Location c:\temp
Get-Service | Out-File c:\temp\servcies.txt

Get-Content .\services.txt

#endregion Pipeline Basics - Pipeline Introduction

#region Pipeline Basics - Pipeline Object Manipulation

Get-Process | Sort-Object -Property Handles | Select-Object -last 2

Get-EventLog -LogName Security | Group-Object EntryType 

Get-ChildItem C:\Scripts | Measure-Object -Property Length -Sum 

#Creates files for comparison example. 
New-Item c:\temp\Servers1.txt
Set-Content c:\temp\Servers1.txt 'Server1','Server2','Server3'
notepad.exe c:\temp\Servers1.txt

New-Item c:\temp\Servers2.txt
Set-Content c:\temp\Servers2.txt 'Server3','Server4','Server5'
notepad.exe c:\temp\Servers2.txt


Set-Location c:\temp
Get-Content -Path .\servers1.txt -OutVariable ref 
Get-Content -Path .\servers2.txt -OutVariable diff 
Compare-Object -ReferenceObject $ref -DifferenceObject $diff 
Compare-Object -ReferenceObject $ref -DifferenceObject $diff -IncludeEqual #Can demo the equal viewable content.


$groupedEvents = Get-EventLog -LogName Security | Group-Object EntryType 
$groupedEvents  | Format-Table -AutoSize 

#additional Outputting demos

#View process and output on screen
Get-Process | Sort-Object ws | Select-Object -last 5

Get-EventLog -LogName Application | Group-Object EntryType

Get-ChildItem C:\Temp | Measure-Object -Property IsReadOnly -Sum

#endregion Pipeline Basics - Pipeline Object Manipulation

#region Pipeline Basics - Pipeline Output

#Format-List (FL)
Get-Process -Name powershell | Format-List *

Get-Process -Name powershell | FL -Property Name, BasePriority, PriorityClass

#Format-Table (FT)
Get-Process | Format-Table –Property name,workingset,handles

Get-Process | FT -Property Name,Path,WorkingSet -AutoSize -Wrap


#Format-Wide (FW)
Get-ChildItem | Format-Wide -Column 3

Get-Alias | FW -AutoSize

#endregion Pipeline Basics - Pipeline Output

#region Pipeline Basics - Import/Export cmdlets

#Create file for demo: Import cmdlets slide

New-Item c:\temp\userNames.csv
Set-Content c:\temp\userNames.csv @(
  '"FirstName";"LastName";"UPN"'
  '"Dan";"Park";"dpark"'
  '"Kim";"Akers";"kakers"'
)

notepad.exe c:\temp\userNames.csv

$UPNs = Import-Csv –Path .\usernames.csv –Delimiter “;” 
$UPNs

#Import-CSV slide, create file for demo

New-Item c:\temp\userMailboxes.csv
Set-Content c:\temp\userMailboxes.csv @(
  '"UserName","Mailbox","Quota"'
  '"Administrator","administrator@contoso.com","1GB"'
  '"DanPark","dpark@contoso.com","5GB"'
  '"KimAkers","kakers@contoso.com","500MB"'
)

notepad.exe c:\temp\userMailboxes.csv

$Mailbox = Import-Csv –Path .\userMailboxes.csv | Select-Object mailbox
$Mailbox

#Export-CSV slide

Get-Service | Export-Csv "c:\temp\services.csv" -NoTypeInformation
notepad.exe C:\temp\services.csv

Get-Service | Export-Csv "c:\temp\services.csv"
notepad.exe C:\temp\services.csv


Get-Process | Out-GridView -PassThru

$Processes = Get-Process
$Processes | Out-GridView -PassThru | Export-Csv c:\temp\File.csv -NoTypeInformation 
notepad.exe c:\temp\File.csv


#ConvertTo-Json slide

Get-Service | ConvertTo-Json | Out-File c:\temp\services.json
notepad.exe C:\temp\services.json 
code . C:\temp\services.json #This requires Visual Studio Code on the machine demonstrating this. 

#endregion Pipeline Basics - Import/Export cmdlets

#endregion Pipeline Basics module
