$names = 'Yossi','Moshe','Haim','Galit','Shir','Shalom','david','Aharon'

if ($names){
    if($names.Count -lt 3){
        Write-Output "The variable names has less than 3 names in it"
    }
    elseif ($names.Count -lt 7) {
        Write-Output "The variable names has more than 3 names but less than 7 names"
    }
    else {
        Write-Output "The variable names has more than 7 names"
    }
}