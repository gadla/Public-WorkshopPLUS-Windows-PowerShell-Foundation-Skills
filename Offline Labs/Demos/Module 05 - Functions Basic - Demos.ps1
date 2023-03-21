
#region Functions

# Simple Function - Demo from slide
Function Write-Statement
{
    Write-Host “Hello world!” -ForegroundColor Green  
}

Write-Statement

# Similar demo
Function Get-SomeService {
    Get-Service -Name WinRM
}

Get-SomeService

# Slightly more complex demo (from slide)
Function Write-ServiceStatus
{
    $SVC = Get-Service -Name WinRM
    $Name = $SVC.DisplayName
    $Status = $SVC.Status
    Write-Host "The Service $Name is currently $Status" -ForegroundColor Green
}

Write-ServiceStatus

#endregion

#region Parameters

# Simple Function - Demo from slide
Function Write-Statement
{
    Param($Statement)
    Write-Host $Statement -ForegroundColor Green  
}

Write-Statement -Statement "Hello world!"

# Similar demo
Function Get-SomeService {
    Param ($SVC)
    Get-Service -Name $SVC
}

# Function with multiple parameters - Default value for one
Function Write-ServiceStatus
{
  Param ($Service,
         $Color = “Blue”)
  $SVC = Get-Service -Name $Service
  $Name = $SVC.DisplayName
  $Status = $SVC.Status
  Write-Host "The Service $Name is currently $Status" –ForegroundColor $Color
}

Write-ServiceStatus  -Service WinRM -Color Green

#endregion

#region Script Blocks

# Using the measure command
Measure-Command -Expression {Get-Process}

# Saving Script Blocks in Variables...
$ScriptBlock = {Get-Service –Name WinRM}
$ScriptBlock

# And how to properly invoke them...
Invoke-Command -ScriptBlock $ScriptBlock
# Or...
$ScriptBlock.Invoke()

#endregion


#region Scopes

# Show the relationship between a parent / child scope
# Create a variable
$MyVariable = "Outside"

# Create a function which calls the variable, sets it to a new value, then displays the new value 
Function MyFunction {
    $MyVariable
    $MyVariable = "Inside"
    $MyVariable
}

# Call the function
MyFunction

# Show that the variable in the parent scope didn't change values
$MyVariable

####

# Use the same example but call the function with Dot Sourcing.
# Create a variable
$MyVariable = "Outside"

# Create a function which calls the variable, sets it to a new value, then displays the new value 
Function MyFunction {
    $MyVariable
    $MyVariable = "Inside"
    $MyVariable
}

# Call the function
. MyFunction

# Show that the variable in the parent scope changed values
$MyVariable

#endregion
