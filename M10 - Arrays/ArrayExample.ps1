<#
.SYNOPSIS
    This is a script that demonstrates the issues of using the System.Array in PowerShell.
.DESCRIPTION
    This script demonstrates the issues of using the System.Array in PowerShell.
    It creates an empty array and adds items to it.
    The execution time increases as the array size increases.
.NOTES
    File Name: ArrayExample.ps1
    Author   : Gadi Lev-Ari
#>
Write-Host -Object "Starting the script..." -BackgroundColor black -ForegroundColor Yellow

# Create an empty array
$array = @()

# Initialize a counter
$counter = 0

# Initialize a stopwatch
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Add items to the array
for ($i = 0; $i -lt 100000; $i++) {
    $array += $i
    $counter++

    # Every 10000 items, display the elapsed time
    if ($counter -eq 10000) {
        $counter = 0
        $elapsedTime = $stopwatch.Elapsed
        Write-Output "Total array size is $($array.count). 10000 items added to the array. Elapsed time: $elapsedTime"
        $stopwatch.Restart()
    }
}

$stopwatch.Stop()
