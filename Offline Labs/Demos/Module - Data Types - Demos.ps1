# NOTE - Paths need to be altered - this is just for testing at this point.
$DemoPath = 'C:\PShell\Demos'
Set-Location -Path $DemoPath
break

###################################################
###### SUGGESTED PPT Layout based on Demo's below
#
#    Two Parts:
#
#    1)  Explaining Types/Class Syntax
#        - Class 
#        - Namespace
#        - Assembly
#        - Alias for Class/Type using Accelerators
#        
#    2)  Explain Type Conversion (aka Casting)
#        - What happens when Casting Sytnax is used
#        - How Variables by default do not have a type (are assigned the object referenced) - Weakly typed
#        - How operations can cause conversion (implict conversion)
#        - Explict conversion/casting using -as, [Type] 
#        - Implicit conversion by assigning a variable a type (strongly typed)


# TODO Needs to be put in LabSetup.ps1
if($SetupDemoLabs)
{
    New-Item -Path C:\PShell\Demos -ItemType Directory -Force
    New-Item -Path $DemoPath -Name DemoFile.txt -ItemType File -Value 'Some unimportant content just for demo sake.'
}
break

#region PART1 CLASS/TYPE Review 


# Show the Type or Class PowerShell syntax
# [Namespace.ClassName] or [NameSpace.TypeName]  
#
[System.DateTime] 


# Show that Type is synomous with Class
# Everything in PowerShell is an Object. All Objects are of a specific class
# Looking at the FileInfo Type which is returned from Filesystem provider
$FileInfobject = Get-Item -Path $DemoPath\DemoFile.txt
[System.IO.FileInfo]


# Grouping of classes/Types into Namespaces for discoverability and also loading
# related classes together as they are often associated.

# Show that Types are defined in assemblies in hiearchical structure using namespace(s) as containers
[System.IO.FileInfo].Namespace

# Look at the assembly object and note that it points to a file.
[System.IO.FileInfo].Assembly


# In .NET invocation of code is done in protected spaces called application domain. This is simply said a process providing the .NET infrastucture.
[System.AppDomain]::CurrentDomain

# PowerShell itself requires an infrastructure in order to invoke PowerShell commands both locally and remotely. This infrastructure is called a runspace.
# when in a Powershell Host (i.e. ISE) the process has a AppDomain and the AppDomain itself can host one of many Runspaces. 
# A runspace also provides a security boundries for PowerShell code to run in.
[System.AppDomain]::CurrentDomain

# AppDomains can load assemblies. We can also see which assemblies are currently loaded
[System.AppDomain]::CurrentDomain.GetAssemblies()

# Asemblies are implicity loaded through modules but can also be explicitly loaded
# Look at Assembly count before and after loading of a Module
[System.AppDomain]::CurrentDomain.GetAssemblies().count
Import-Module -Name PrintManagement

# Look at the last 3 assemblies that wereloaded
[System.AppDomain]::CurrentDomain.GetAssemblies()[-3..-1]


# TODO - think of a Type that is not commonly loaded but can be usefull and load and use
# We can also explicity load an Assembly
Add-Type -AssemblyName 

Add-Type -Path 



### Accelerators

# Define Helper Function for listing defined Accelerators
function Get-Accelerator
{
    param([String]$Name = '*')

    $PSObjectType = [System.Management.Automation.PSObject]
    # As this is not a Type that is exported we have to Get it Forcefully.
    $AcceleratorType = $PSObjectType.Assembly.GetType('System.Management.Automation.TypeAccelerators')
    # Call the Types Static method Get
    $AcceleratorType::Get.GetEnumerator() |
        Where-Object {$_.Key -like $Name} -PipelineVariable 'Accelerator' |
            ForEach-Object {
                [PSCustomObject]@{Accelerator=$Accelerator.Key;ReferenceType=$Accelerator.value}
            }

}

Get-Accelerator -Name ad*



# Add Accelerators
# Show that the method Add takes a Accelerator String (Alias) for a Type
function Add-Accelerator
{
    param
    (
        [String]$AcceleratorName,
        [String]$Type = '[System.io.FileInfo]'

    )

    $PSObjectType = [System.Management.Automation.PSObject]
    # As this is not a Type that is exported we have to Get it explicitly using the fullname.
    $AcceleratorType = $PSObjectType.Assembly.GetType('System.Management.Automation.TypeAccelerators')


    # Check if type exists by trying access
    try 
    {
        # Convert String into Type using Hack if it fails an exception will be thrown
        $TypeObject = Invoke-Expression -Command $Type

        # Add New Accelerator
        $AcceleratorType::Add($AcceleratorName,$TypeObject)

    }
    catch
    {
        Write-Warning "Type '$Type' is not available (check that assembly is loaded)"
    }

}



[String]$Type = [System.IO.FileInfo]

# 
[File]::Create("$DemoPath\NewFile.txt")

# Look at the assembly that the type is defined in
[File].Assembly

# Look at the Namespace
[File].Namespace

# Look at Fullname of an accelerator
[File].FullName


### Load new Example showing the 'using namespace' keywords.
$psISE.CurrentPowerShellTab.Files.Add("$DemoPath\UsingNamespace.ps1")

New-Item -Path C:\PShell\Demos -ItemType Directory -Force
New-Item -Path $DemoPath -Name DemoFile.txt -ItemType File -Value 'Some unimportant content just for demo sake.'
#endregion


#region PART2 CASTING/CONVERSION
# Casting

# Type Conversion - Creation of an object of one type using data from an object of another type
[System.DateTime]'20 jun 2020'

# Look under the covers at Type Converion
Trace-Command -Expression {[System.DateTime]'20 jun 2020'} -Name TypeConversion -PSHost -Option All

# Explicit creation using one object as argument to create another
[System.DateTime]::Parse('20 jun 2020')

# 
[PSCustomObject].FullName
[PSCustomObject]::new(@{foo='bar'})
[PSObject]::new(@{foo='bar'})
Trace-Command -Expression {[PSCustomObject]@{foo='bar'}} -Name TypeConversion -PSHost -Option All
Trace-Command -Expression {[PSObject]@{foo='bar'}} -Name TypeConversion -PSHost -Option All


##### Implicit Type conversion

# Variables by default can be reference any type of object (i.e. their Value property)
# This means they are weakly typed

# Variables can however be assigned a type meaning that 
# objects references (Assigned to them) will have to be able to 
# to convert to that type
$Money = 100

# Look at the Type of the Value Object of the variable. 
$MoneyVariable = Get-Variable -Name Money
$MoneyVariable.Value.GetType().FullName

# We do not need to do this as PowerShell allows us to reference the
# object that the variable reference directly via the variable
$Money.GetType().FullName


# We can assign a differnt type of objec to this variable as it is 
# weakly typed
$Money = 'One Million'

# Now it is a string Object assigned to Money
$Money.GetType().FullName

# If we however declare that they variable is strongly typed
# meaning that object that the variable reference must be able to be 
# converted to a specific type.
[Int32]$Money = 100
$Money.GetType().FullName

# If we now try to assign an object that cannot be converted it will fail
$Money = 'One Million'

# Some object can however be converted
$Money = '0xF4240' # Here a string that represents as hexadecimal value
$Money
$Money.GetType().FullName

#endregion
