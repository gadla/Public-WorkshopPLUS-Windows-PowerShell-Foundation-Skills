#region implicit conversions
#Bonus is converted to string
$Salary = '1000'
$Bonus = 100
$NewSalary = $Salary + $Bonus
$NewSalary

#Salary is converted to int
$Salary = '1000'
$Bonus = 100
$NewSalary = $Bonus + $Salary
$NewSalary
#endregion Implicit conversions

#region TypeCasting

#Salary is typecast to an int, then used for the addition
$Salary = '1000'
$Bonus = 100
$NewSalary = [int]$Salary + $Bonus

$Salary.GetType().FullName #salary is still a string

$NewSalary

#Type casting
$Number = "5"
$Number
$Number.GetType()

$Number = [int]"5"
$Number
$Number.GetType()

$r = Read-Host "Give me a number"
$r.GetType().Fullname

#Try this with both a number and word to see the error
$r = [int](Read-Host "Give me a number")
$r.GetType().Fullname

#using full names
([System.ServiceProcess.ServiceControllerStatus]"running").GetType().FullName


#endregion TypeCasting


#region Strong Typing
$Number = "Five"
[string]$MyVar1 = "String"
$MyVar1.GetType()
$MyVar1 = 5
$MyVar1.GetType()

[int]$MyVar2 = 3
$MyVar2.GetType()
[int]$MyVar3 = "Green"

#using full names
[System.ServiceProcess.ServiceControllerStatus]$status = "running"
$status = “fake”


function Text-ParamsTypes
{
    param ($Anything,
           [Int]$Number,
           [string]$Text)
    Write-Host "Anything has a value of: $Anything" -ForegroundColor Green
    Write-Host "Anything has a type of: $($ANything.GetType().FullName)" -ForegroundColor Green

    Write-Host "Number has a value of: $Number" -ForegroundColor Yellow
    write-host "Number has a type of: $($Number.GetType().FullName)" -ForegroundColor Yellow

    Write-Host "Text has a value of: $Text" -ForegroundColor Cyan
    Write-Host "Text has a type of: $($Text.GetType().FullName)" -ForegroundColor Cyan
}

Text-ParamsTypes -Anything "123" -Number "123" -Text "123"
Text-ParamsTypes -Anything 123 -Number 123 -Text 123
Text-ParamsTypes -Anything "One" -Number "Two" -Text "Three"



#endregion Strong Typing

#region Static Members
[math] | Get-Member -Static

[math]::PI
[math]::Round(3.14159265358979, 3)
[math]::Round([math]::PI, 3)


[datetime] | Get-Member -Static

[datetime]::DaysInMonth(2000, 2)
[datetime]::DaysInMonth([datetime]::Now.Year, [datetime]::now.Month)

#endregion Static Members

#region Enums
[consolecolor]::Black
[dayofweek]::Friday

[System.DayOfWeek]

[System.ConsoleColor] | Format-List
#endregion Enums

#region -IS & -ISNOT
$Num = 123
$Str = "ABC"

$Num -is [int]
$Num -is $Str.GetType()

##

$Num = 123
$Str = "ABC"

$Num -isnot [int]
$Num -isnot $Str.GetType()

#endregion

#region escape character
Write-Host "`$Home is $Home"
Write-Host "Hello `nWorld!"
Write-Host "Hello`n`tWorld!"

Write-Host "Hello`tWorld" `
-ForegroundColor Green

Write-Host "Hello$("`t"*2)World" -ForegroundColor Yellow

Get-Service -Name WinDefend | Format-Table `
Name,Status,CanStop
#endregion escape character

#region Parsing Modes
#expression mode does the expected work
2+2

#Argument mode, treats everything as strings
Write-Host 2+2 -ForegroundColor Green

#Expression mode forced on 2+2
Write-Host (2+2) -ForegroundColor Green

#expression mode needs quotes for strings
Test
"Test"
#endregion Parsing Moves