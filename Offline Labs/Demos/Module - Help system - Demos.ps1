$DemoPath = 'C:\PShell\Demos'
Set-Location -Path $DemoPath
break

#region Understanding the Help System
# Help system is built up from data that comes from several locations.

<# Where does the Help come from.
    1) Native command defintion will autogenerate Syntax portion of help
    2) Comment based Help for the native command.
    3) External XML based help files for the command (XML MAML file reference same as for module)
    4) Text file based help that is shipped with Module (i.e. About_xxx topics)
    5) Online help for the Native command. This uri can be set for a command.
    6) Updatable help for the module in which the command is defined. Location for download
    is set in the HelpInfoUri property of the Module object (i.e. Get-Module)
    7) static help files that are shipped with module (XML - MAML files).
#>

# Some or all of the above can be present. There will always be a redimentary help system
# available for commands based on their definition. 


# Most new modules implement updatabale help however this is not easily generated therefore the
# online help and the downloadable help still fluctuate from one another. Online will be the 
# most up to date.
Get-Help

# Problem is that often machines (i.e. Servers are not online - no internet connectivity)

# Updateable help is pulled from the internet by default using Update-Help 
# for a specific Module. The offline help is then stored either for a user of machine using scope

Update-Help -Module Microsoft.PowerShell.Management -Scope CurrentUser

# Calling Get-Help
# Use the Help to read Syntax

# Look at a specific parameter
Get-Help Get-Process -Parameter id

# Looking only at Parameters (i.e. * is wildcard for all)
Get-Help Get-Process -Parameter *

# Looking at only the Examples
Get-Help Get-Process -Examples

# Searching for conceptual help
Get-Help about_*

# Having Help appear in GUI window 
# NOTE : Demo Settings and Find
Get-Help -ShowWindow

# Looking at how Help system is built on different files 

# The MAML (Microsoft Assistance Markup Language) is XML with a special Schema 
# XML can contain help for several commands and can also be specific for a locality (i.e. en,en-us,de-de,etc)
$MAMLHelpFileContent = @"
<?xml version="1.0" encoding="utf-8"?>
<helpItems schema="maml" xmlns="http://msh">
  <command:command xmlns:maml="http://schemas.microsoft.com/maml/2004/10" xmlns:command="http://schemas.microsoft.com/maml/dev/command/2004/10" xmlns:dev="http://schemas.microsoft.com/maml/dev/2004/10" xmlns:MSHelp="http://msdn.microsoft.com/mshelp">
    <command:details>
      <command:name>Demo-Help</command:name>
      <command:verb>Demo</command:verb>
      <command:noun>Help</command:noun>
      <maml:description>
        <maml:para>Simply demos external XML based help for a module and commands.</maml:para>
      </maml:description>
    </command:details>
    <maml:description>
      <maml:para>`Demo-Help` Demos the Help system.</maml:para>
    </maml:description>
    <command:syntax>
      <command:syntaxItem>
        <maml:name>Demo-Help</maml:name>
        <command:parameter required="false" variableLength="true" globbing="false" pipelineInput="False" position="named" aliases="none">
          <maml:name>Topic</maml:name>
          <maml:Description>
            <maml:para>Specifies the topic to display.</maml:para>
          </maml:Description>
          <command:parameterValue required="true" variableLength="false">System.String</command:parameterValue>
          <dev:type>
            <maml:name>System.String</maml:name>
            <maml:uri />
          </dev:type>
          <dev:defaultValue>None</dev:defaultValue>
        </command:parameter>
      </command:syntaxItem>
    </command:syntax>
    <command:parameters>
      <command:parameter required="false" variableLength="true" globbing="false" pipelineInput="False" position="named" aliases="none">
        <maml:name>Command</maml:name>
        <maml:Description>
          <maml:para>Specifies an array of commands searched by `Find-Package`.</maml:para>
        </maml:Description>
        <command:parameterValue required="true" variableLength="false">System.String[]</command:parameterValue>
        <dev:type>
          <maml:name>System.String</maml:name>
          <maml:uri />
        </dev:type>
        <dev:defaultValue>None</dev:defaultValue>
      </command:parameter>
    </command:parameters>
    <command:inputTypes>
      <command:inputType>
        <dev:type>
          <maml:name>None</maml:name>
        </dev:type>
      </command:inputType>
    </command:inputTypes>
    <command:returnValues>
      <command:returnValue>
        <dev:type>
          <maml:name>None</maml:name>
        </dev:type>
      </command:returnValue>
    </command:returnValues>
    <maml:alertSet>
      <maml:alert>
        <maml:para></maml:para>
      </maml:alert>
    </maml:alertSet>
    <command:examples>
      <command:example>
        <maml:title>Example 1: Simply call the command Demo-Help specifying a topic.</maml:title>
        <dev:code>Demo-Help -Topic PowerShell

        </dev:code>
        <dev:remarks>
          <maml:para>Demo-Help simply outputs a string with the supplied Topic (PowerShell).</maml:para>
        </dev:remarks>
      </command:example>
    </command:examples>
    <command:relatedLinks>
      <maml:navigationLink>
        <maml:linkText>Online Version:</maml:linkText>
        <maml:uri>https://ps-gethelp</maml:uri>
      </maml:navigationLink>
      <maml:navigationLink>
        <maml:linkText>about_comment_based_help</maml:linkText>
        <maml:uri></maml:uri>
      </maml:navigationLink>
      <maml:navigationLink>
        <maml:linkText>Get-Help</maml:linkText>
        <maml:uri></maml:uri>
      </maml:navigationLink>
      <maml:navigationLink>
        <maml:linkText>Help</maml:linkText>
        <maml:uri></maml:uri>
      </maml:navigationLink>
    </command:relatedLinks>
  </command:command>
</helpItems>
"@

# Create the XML file and place in DemoPath 
# NOTE this can also be shipped with a Module and placed in Module dir. This is simply for demos
New-Item -Path "$DemoPath\DemoHelpModule\en-us\DemoHelpModule-Help.xml" -ItemType File -Value $MAMLHelpFileContent -Force

# Using PlatyPS helper Module we can preview the 
Install-Module -Name PlatyPS -Scope CurrentUser -Force
Import-Module -Name PlatyPS
Get-Command -Module PlatyPS

# Preview XML
Get-HelpPreview -Path "$DemoPath\DemoHelpModule\en-us\DemoHelpModule-Help.xml" 


# Just Function declaration
function Demo-Help
{
    [CmdletBinding()]
    param 
    (
        [String]$Topic
    )
}

Get-Help Demo-Help -Full

# Comment based help added
function Demo-Help
{
    <#
    .SYNOPSIS 
        This is the minimum label (.SYNOPSIS) for the comment based help to be generated.
    .DESCRIPTION
        A more detailed description of what the command does.
    #>
    [CmdletBinding()]
    param 
    (
        # Topic parameters description
        [String]$Topic
    )

    Write-Host "The topic is '$Topic'." -ForegroundColor Green
}

# Demo comment based help
Get-Help Demo-Help -Full 

# External XML file for command. This overrides the comment based help
function Demo-Help
{
    #.SYNOPSIS 
    #  Notice that this synopsis is not used when an External Help file is supplied
    #.EXTERNALHELP C:\PShell\Demos\DemoHelpModule\en-us\DemoHelpModule-Help.xml
    [CmdletBinding()]
    param 
    (
        # Topic parameters description
        [String]$Topic
    )

    Write-Host "The topic is '$Topic'." -ForegroundColor Green
}

# Demo comment externalhelp file based help
Get-Help Demo-Help -Full

# Module based Help files
$ModuleName = 'DemoHelpModule'
# Create directory structure with local dir for Help files
New-Item -Path "$DemoPath\$ModuleName\en-us" -ItemType Directory -Force

# Create a simple empty module just for demoing help files
New-ModuleManifest -Path "$DemoPath\$ModuleName\$ModuleName.psd1" -HelpInfoUri 'http://URIWhereXMLFileresides/'
Get-Module -Name $ModuleName -ListAvailable
Get-Command New-Module
Get-Help New-Module -ShowWindow

# about files (Plain text) reside in Module directory.
# Extend the PSModulePath in order to add $DemoPath for search
$ProcEnv = [System.EnvironmentVariableTarget]::Process
$PSMPath = [System.Environment]::GetEnvironmentVariable('PSModulePath',$ProcEnv)
$PSMPath += ";$DemoPath"
[System.Environment]::SetEnvironmentVariable('PSModulePath',$PSMPath,$ProcEnv)

# Create about.help.txt file in Module directory
$AboutHelpContent = @"
This is the about help for Demo-Help
"@

# Create file in en-us 
New-Item -Path $DemoPath\$ModuleName\en-us -Name about_demohelp.help.txt -value $AboutHelpContent -ItemType File 

# Query about help
Get-Help about_demohelp


# MAML (XML) based Module help files (Modulename.psm1-Help.xml)
# Placed in same folder as Module with same name as module


#endregion


#region Updating Help Files

# Look at where the default Help files come from - Grab ModuleInfo Object
$ModuleInfo = Get-Module -Name Microsoft.PowerShell.Management -ListAvailable


# Look at url
$ModuleInfo.HelpInfoUri

# See that we can access this data via a webrequest
Invoke-WebRequest -Uri $ModuleInfo.HelpInfoUri -Method Get 

Update-Help -Module Microsoft.powerShell.Management -Verbose -Force 


# What update-Help does in a nutshell
$WebClient = [System.Net.WebClient]::new()
$WebClient.DownloadFile($, $ModuleCabFileName)
$Handler = [System.Net.Http.HttpClientHandler]::new()
$Handler.AllowAutoRedirect = $true #$false
$Handler.UseDefaultCredentials = $true

$DestinationPath = Join-Path -Path $demopath -ChildPath $ModuleCabFileName
$FileStream = [System.IO.FileStream]::new($DestinationPath ,[System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
#endregion



#region Creating comment based help
# using the help system to look at help about comment based help
Get-Help about_comment_based_help -Full

# Comment based help can be created for commands of type function, script or Cmdlet.

# Comment base help for a function (embedded in function declaration)

function Demo-Help
{
    <#
    .SYNOPSIS 
        Demo-Help is just a function with portions of Comment based help utilized. 
    .DESCRIPTION 
        Demo-Help has it's comment based help written within the function declaration. On can also have the 
        Comments written above the function definition with a max of one line seperation else the comment will
        not be associated tot he function.
    .PARAMETER Subtopic
        Better to simply have a comment for the parameter within the param section. If multiple lines are needed
        this might be the better alternative.
    .NOTES 
        You can put all kinds of information here. Often used for developent history when a source control system like
        git is not being used. Ideally you should develop using git and then the history is stored when changes are committed.
    .EXAMPLE
        Example 1 - Show useful use case scenario and explain in details what happens.
    .EXAMPLE
        As commands often can be used in different ways (i.e. parametersets) it is good to highlight these ways
        with different samples.

    #>
    [CmdletBinding(
        # We can also have external html based help. This is assigned using the CmdletBinding HelpRui parameter.
        # Using URI for Get-Process for demo purposes.
        HelpUri =  'https://go.microsoft.com/fwlink/?LinkID=113324'
    )]
    param
    (
        # Instead of using .PARAMETER Topic in Comment block.
        [String]$Topic,
        [String]$Subtopic
    )

}

# Define the above function and then use Get-Help to visualize specific sets of the Help that
# is generated both through the definition of the function as well as through structured comments.

# If in VSCode with PowerShell Extension or PS v 7 or PS ISE we can see in GUI window using -ShowWindow Switch parameter
Get-Help Demo-Help -ShowWindow

# look at the full help output to the console.
Get-Help Demo-Help -Full

# show html based help which was set using HelpUri in parameter CmdletBinding attribute definition.
Get-Help Demo-Help -Online



$ScriptBlock = 
{
#.SYNOPSIS 
# Script for showing how comment based help is implemented for a script.
#.DESCRIPTION 
# This script just writes a given subject in the console output.
#.NOTES 
# This is a script that has comment based help.
#.EXAMPLE 
# ScriptWithHelp.ps1 -Subject 'DSC' 
# This will output the subject DSC.
#
[CmdletBinding()]    
param
(
    # Description of parameter. Note best to put parameter description as comment with parameter. Can also use .PARAMETER <ParameterName>
    [String]$Subject='PowerShell'
)

Write-Host "This script simply writes out a subject on the screen. Your subject is '$subject'"

}

# Create or Overwrite a Script with Demo Comment based help
New-Item -Path $DemoPath -Name ScriptWithHelp.ps1 -ItemType File -Value $ScriptBlock -Force

# Show the full help
Get-Help .\ScriptWithHelp.ps1 -Full
# Only show help for a specific parameter
Get-Help .\ScriptWithHelp.ps1 -Parameter Subject
#endregion

#region Demo for downloading updatable help for Modules on offline machines.
# Helper functions for downloading Help online and then moving to offline internal help repository
<# Steps needed to be preformed
1. Collect Names of Modules and HelpInfoUri for those modules Updatable help needs to be downloaded. Helper Function Save-ModuleInfo
2. Take collected Module Info and copy to online machine for downloading using Save-Help
3. Copy downloaded Help system data (i.e. XML and CAB files) to internal offline repository
4. Use update-help using internal respository as source. This can be also changed from default being Internet to intranet using GPO.
#>
<#
.SYNOPSIS
 This will collect the metadata needed from the specified Modules

.DESCRIPTION
 When specifying ComputerName that is not the localhost access via
 Microsoft.PowerShell Endpoint is needed for Remoting
#>
function Save-ModuleInfo
{
   [CmdletBinding(DefaultParameterSetName='File')]
   param
   (
       # List of one or more computers to gather Module informtion from
       [String[]]$ComputerName = 'localhost',
       # Name of the Modules
       [String[]]$ModuleName = '*',
       [switch]$Passthru,
       [Parameter(ParameterSetName='File')]
       [String]$OutputXMLFilePath = (Join-Path -path $pwd -ChildPath 'ModuleInfo.xml')
   )

   $ScriptBlock =
   {
       param
       (
          [String[]]$ModuleName
       )
 
       # Only the Name and HelpInfoUri are needed for Save-Help - Warn if HelpInfoUri is empty
       # Implies that there is no updatable help
        $ModuleInfo =    Get-Module -Name $modulename -ListAvailable -PipelineVariable Module |
             ForEach-Object {
                 if($null -eq $Module.HelpInfoUri -or $Module.HelpInfoUri -eq [String]::Empty)
                 {
                     Write-Warning "Module '$($Module.Name)' has no updatable help."
                 }
                 else
                 {
                   Write-Output $Module
                 }
             } |
                 Select-Object -Property Name,HelpInfoUri,Version
 
       return $ModuleInfo
   }
 
   # Don't require remoting for just localhost (default)
   if($ComputerName.count -eq 1 -and $ComputerName -eq 'localhost')
   {   
       $ModuleInfo = $ScriptBlock.Invoke($ModuleName)
   }
   else
   {
       # Only want unique modules
       $ModuleInfo = Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock  -ArgumentList (,$ModuleName)  
   }
   $ModuleInfo = $ModuleInfo | Select-Object -Unique -Property Name,Version

   if($Passthru.IsPresent)
   {
     $ModuleInfo
   }
   else
   {
     $ModuleInfo | Export-Clixml -Path $OutputXMLFilePath
   }
}

# 1. Collect Names of Modules and HelpInfoUri for those modules Updatable help needs to be downloaded. Helper Function Save-ModuleInfo
# Decide Which Modules and Computer for which Module Help Files will be needed
$ComputerName =  $Env:COMPUTERNAME
$ModuleName = 'Microsoft.PowerShell.Utility', 'Microsoft.Powershell.Management'

# Sample Call To Helper Function wil create ModuleInfo.xml in current Directory (i.e. $pwd)
Save-ModuleInfo -ComputerName $ComputerName -ModuleName $ModuleName

# Get all the Module MetaData for Modules with updateable help on the Localhost
Save-ModuleInfo

# Check the ModuleInfo
Import-Clixml .\ModuleInfo.xml

# 2. Take collected Module Info and copy to online machine for downloading using Save-Help
# Copy ModuleInfo.xml to Internet facing machine
$OfflineHelpFilesPath = 'C:\PShell\Demos\HELPFILES'
if(-Not(Test-Path -Path $OfflineHelpFilesPath))
{
   New-Item -Path $OfflineHelpFilesPath -ItemType Directory -Force | Out-Null
}
Import-Clixml .\ModuleInfo.xml |
 Save-Help -DestinationPath $OfflineHelpFilesPath

# 3. Copy downloaded Help system data (i.e. XML and CAB files) to internal offline repository

# 4. Use update-help using internal respository as source. This can be also changed from default being Internet to intranet using GPO.
Update-Help -Module Microsoft.PowerShell.Management -SourcePath $OfflineHelpFilesPath -Force
#endregion

#region Reference links for creating Help

# Creating Help
Install-Module -Name Platyps -Force
Import-Module platyps

# Great reference for building updatable help -Updating Help for older versions of PowerShell
Start 'https://devblogs.microsoft.com/powershell/updating-help-for-older-versions-of-powershell/'
#endregion
