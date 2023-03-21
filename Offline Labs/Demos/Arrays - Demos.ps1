#region
# Three ways to create arrays
$array = "apple","banana","pear","pineapple","grapes"
$array2 = Get-ChildItem
$array3 = @("alpha","beta")

#endregino

#region working with arrays
$array[1]
$array[-1]
$array[1,3]

$i = 2
$array[$i]

$array.Count
$array | sort
($array[0]).GetType()

$array += "orange"
$array[1] = "peach"
##

$array2 = Get-ChildItem
$array2[3].Name
$array2[3] | Select-Object name,length
$array2.count
##

$array3 = @("alpha","beta")
$array3[0] = @("gamma","delta")
$array3[0][0]

##

$array4 = 1,2,"alpha","beta"
$array4 | Get-Member
Get-Member -InputObject $array4

##

$array.Length
$array.count

##

#endregion

#region Operators

1..10
2..5
5..-5

$array2[0..4]
$array2[2..5]
$array2[4..-2]

##

$Array = “Doe”, “John”, .35, 1234567.89123
"{1} {0}" –f $Array
"{2:p} ; {3:n} ; {3:n0}" –f $Array

'{1:p}' -f (1/4),(1/2)

##

$Array = 1, 2, 4, 6, 8, 10
$array -contains 4
4 -in $array

##

-split "a b 3"
"a,b,3" -split ","
"a b c,d,e,f" -split {$_ -eq "," -or $_ -eq " "}
$a = -split "a b c"

##

-join ("a","b","3")
"a","b","3" -join ","
$a -join ","

#endregion

#region ArrayLists
$List = New-Object -TypeName System.Collections.ArrayList
$List.Add("element1")
$List.Add("element2")
$List.Add("element3")
$List[1]
$List[1].ToUpper()

#endregion
