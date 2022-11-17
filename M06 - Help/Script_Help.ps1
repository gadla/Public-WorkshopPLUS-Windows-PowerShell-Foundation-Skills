<#
 .SYNOPSIS
   Function that returns the most recent system event log entries
 .DESCRIPTION
   Function that returns the most recent system event log entries.
   The number of items returned is determined by the parameter.
 .PARAMETER NumberOfEvents
   Number of recent events to return
 .EXAMPLE
   PS C:\> Get-SysLogNN –Log System –NumberOfEvents 10
 .EXAMPLE
   PS C:\> Get-SysLogNN –Log Application –NumberOfEvents 20
#>
Param ($Log, $NumberOfEvents)
Get-EventLog –LogName $Log –Newest $NumberOfEvents
