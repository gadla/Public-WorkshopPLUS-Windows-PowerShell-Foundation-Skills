$foo = "Script Scope"
function myFunction {
    $foo = "Function (Local) Scope"
    Write-Host $Global:foo
    Write-Host $local:foo
    Write-Host $foo
}

myFunction
Write-Host $local:foo
Write-Host $foo