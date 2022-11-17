# Show the relationship between a parent / child scope
# Create a variable
$MyVariable = "Outside"

# Create a function which calls the variable, sets it to a new value, then displays the new value 
Function MyFunction {
    $MyVariable
    $MyVariable = "Inside"
    $MyVariable
}

# Call the function
. MyFunction
