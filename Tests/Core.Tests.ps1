#region Test Setup ------------------------------------------------------------------------------------------------

$ModuleRoot = Resolve-Path "$PSScriptRoot\.." 
$ModuleName = Split-Path $ModuleRoot -Leaf 


function Test-Module { 
    $null -ne (Get-Module $ModuleName) 
} 


# If the module is loaded, remove it so the current source can be reloaded. 
$IsLoaded = Test-Module 
if ($IsLoaded) { 
    Remove-Module $ModuleName 
} 


#endregion
#region Test Helpers ----------------------------------------------------------------------------------------------


function pi { [Math]::PI }  # unit -> double
function halfPi { (pi)/2 }  # unit -> double
function UnaryOpTest ($Method, $Given) {
    # string -> 'a[] -> unit

    $Expected = $Given.Foreach{ [Math]::$Method.Invoke($_) }

    It 'Handles Single Argument' {
        & $Method $Given[0] | Should Be $Expected[0]
    }

    It 'Handles Manifold Argument' {
        & $Method $Given[0] $Given[1] | Should be $Expected
    }

    It 'Handles Array Argument' {
        & $Method $Given | Should Be $Expected
    }

    It 'Handles Piped Argument' {
        $Given | & $Method | Should Be $Expected
    }
}

function BinaryOpTest ($Method, $Given) {
    # string -> array[] -> unit

    # Each element of Given is an array consisting of key value pairs: { 'key', 'value', 'key', 'value' ... }
    # Consume this array into a jagged array of size 2 arrays and a hashtable for splatting.
    $Values = New-Object System.Collections.ArrayList
    $Properties = New-Object System.Collections.ArrayList

    $Consume = { 
        $ls = $_ 
        $ht = @{}
        $a = @()

        # Recursively split the array to generate hashtables and values
        while ($ls) {
            $k, $v, $ls = $ls
            $ht[$k] = $v
            $a += $v 
        }

        [void] $Values.Add($a)
        [void] $Properties.Add($ht) 
    }
    
    $Given.ForEach($Consume)
    
    $Pipe = $Properties.ForEach{ [PSCustomObject] $_ }  # hashtable[] -> PSCustomObject[]
    $Single = $Properties[0]
    $Array = @{
        $Properties.Keys[0] = $Properties.ForEach($Properties.Keys[0])
        $Properties.Keys[1] = $Properties.ForEach($Properties.Keys[1]) 
    }
    # Create a 'bad' array hashtable that doesn't have equal array lengths.
    $BadArray = $Array.Clone()
    $BadArray[$Properties.Keys[1]] = $Properties[1][$Properties.Keys[1]]

    # DivRem is a special case of BinaryOps as it has an output reference.
    # It is easier to inject this if-else than copying BinaryOpTest for one method.
    if ($Method -eq 'DivRem') {
        $ExpectedOut = 0
        $Xeq = { [Math]::$Method.Invoke($_[0], $_[1], [ref] $ExpectedOut) }  # 'a[] -> string -> 'a
        $Expected = $Values.ForEach($Xeq) 
        $Out = 0
        $Ref = [ref] $Out

        It 'Passes the Remainder to Output Reference' {
            & $Method @Array -Result $Ref 
            $Out | Should Be $ExpectedOut
        }
    }
    else {
        $Xeq = { [Math]::$Method.Invoke($_[0], $_[1]) }  # 'a[] -> string -> 'a
        $Expected = $Values.ForEach($Xeq) 
    } 

    It 'Handles Single Argument' {
        & $Method @Single | Should Be $Expected[0]
    } 

    It 'Handles Array Argument' {
        & $Method @Array | Should Be $Expected
    }
    
    It 'Handles Piped Argument' {
        $Pipe | & $Method | Should Be $Expected
    } 

    It 'Throws Unmatched Arrays' {
        { & $Method @BadArray } | Should Throw
        { & $Method @Array } | Should Not Throw
    } 
}

function TypeTest ($Method, $Given, $Types) {
    # string -> 'a -> type[] -> unit
    
    $Cases = 
        $Types | 
            ForEach-Object {
                @{ 
                    Type = $_
                    Value = $Given 
                }
            }

    It 'When Given <Type>, returns <Type>' -TestCases $Cases {
        param ($Value, $Type)

        & $Method ($Value -as $Type) | Should BeOfType $Type
    }
}

function BinaryTypeTest ($Method, $Given, $Types) {
    # string -> 'a[] -> type[] -> unit

    $Cases = 
        $Types | 
            ForEach-Object {
                @{ 
                    Type = $_
                    Value = $Given 
                }
            }

    It 'When Given <Type>, returns <Type>' -TestCases $Cases {
        param ($Value, $Type)

        & $Method ($Value[0] -as $Type) ($Value[1] -as $Type) | Should BeOfType $Type
    }
}

#endregion
#region Core Tests ------------------------------------------------------------------------------------------------

Describe 'Commands' {
    BeforeAll {
        Import-Module $ModuleRoot -Force
    }

    Context 'Abs' {
        UnaryOpTest Abs -Given -42, -24
        TypeTest Abs -Given -42 -Types @(
            'System.Decimal'
            'System.Double'
            'System.Int16'
            'System.Int32'
            'System.Int64'
            'System.SByte'
            'System.Single'
        )
    } 

    Context 'Acos' {
        UnaryOpTest Acos -Given -1, 1
    }

    Context 'Asin' {
        UnaryOpTest Asin -Given -1, 1
    }

    Context 'Atan' {
        UnaryOpTest Atan -Given (-(halfpi), (halfpi))
    }

    Context 'Atan2' {
        $Given = ('y', 42, 'x', 24), ('y', 4, 'x', 2)
        BinaryOpTest Atan2 -Given $Given
    }

    Context 'BigMul' {
        $Given = ('a', 42, 'b', 24), ('a', 4, 'b', 2)
        BinaryOpTest BigMul -Given $Given
    }

    Context 'Ceiling' {
        UnaryOpTest Ceiling -Given 0.42, -0.42
        TypeTest Ceiling -Given 0.42 -Types @(
            'System.Double'
            'System.Decimal'
        )
    }

    Context 'Cos' {
        UnaryOpTest Cos -Given 1, -1
    }

    Context 'Cosh' {
        UnaryOpTest Cosh -Given 1, -1
    }

    Context 'DivRem' {
        $Given = ('a', 42, 'b', 24), ('a', 4, 'b', 2) 
        BinaryOpTest DivRem -Given $Given
    }

    Context 'Exp' {
        UnaryOpTest Exp -Given 4, 2
    }

    Context 'Floor' {
        UnaryOpTest Floor -Given 0.42, -0.42
        TypeTest Floor -Given 0.42 -Types @(
            'System.Double'
            'System.Decimal'
        )
    }

    Context 'IEEERemainder' {
        $Given = ('x', 42, 'y', 24), ('x', 4, 'y', 2)
        BinaryOpTest IEEERemainder -Given $Given
    }

    Context 'Log' {
        UnaryOpTest Log -Given 42, 24
        
        It 'Handles a Base Argument' {
            $Given = 2, 4
            $Base = 2
            $Expected = [Math]::Log($Given[0], $Base), [Math]::Log($Given[1], $Base)

            Log $Given -Base $Base | Should Be $Expected
        }
    }

    Context 'Log10' {
        UnaryOpTest Log10 -Given 42, 24 
    }

    Context 'Max' {
        $Given = ('Value1', 42, 'Value2', 24), ('Value1', 4, 'Value2', 2)
        BinaryOpTest Max -Given $Given
        BinaryTypeTest Max -Given 42, 24 -Types @(
            'System.UInt64'
            'System.UInt32'
            'System.UInt16'
            'System.Single'
            'System.SByte'
            'System.Byte'
            'System.Int64'
            'System.Int32'
            'System.Int16'
            'System.Double'
            'System.Decimal'
        )
    }

    Context 'Min' {
        $Given = ('Value1', 42, 'Value2', 24), ('Value1', 4, 'Value2', 2)
        BinaryOpTest Min -Given $Given
        BinaryTypeTest Min -Given 42, 24 -Types @(
            'System.UInt64'
            'System.UInt32'
            'System.UInt16'
            'System.Single'
            'System.SByte'
            'System.Byte'
            'System.Int64'
            'System.Int32'
            'System.Int16'
            'System.Double'
            'System.Decimal'
        )
    }

    Context 'Pow' { 
        $Given = ('x', 42, 'y', 24), ('x', 4, 'y', 2)
        BinaryOpTest Pow -Given $Given
    }

    Context 'Round' {
        UnaryOpTest Round -Given 0.42, -0.42
    }

    Context 'Sign' {
        UnaryOpTest Sign -Given 0.42, -0.42
        # Sign accepts multiple types but only returns an int indicating the sign.
    }

    Context 'Sin' {
        UnaryOpTest Sin -Given 42, -42
    }

    Context 'Sinh' {
        UnaryOpTest Sinh -Given 0.42, -0.42
    }

    Context 'Sqrt' {
        UnaryOpTest Sqrt -Given 42, 24
    }

    Context 'Tan' {
        UnaryOpTest Tan -Given 42, 24
    }

    Context 'Tanh' {
        UnaryOpTest Tanh -Given 0.42, 0.24
    }

    Context 'Truncate' {
        UnaryOpTest Truncate -Given 42.24, -42.24
    }
}

#endregion
