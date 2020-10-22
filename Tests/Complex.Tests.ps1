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
#region Complex Tests ---------------------------------------------------------------------------------------------

Describe 'Invoke-ComplexMath' {

    $m = [System.Numerics.Complex]::new(4, 2)
    $a = 42
    $s = '4 + 2i'
   
    Context 'UnaryOps' {
        $Methods = @(
            'Conjugate'
            'Reciprocal'
            'Negate'
            'Abs'
            'Acos'
            'Asin'
            'Atan'
            'Cos'
            'Cosh'
            'Exp'
            'Log10'
            'Sin'
            'Sinh'
            'Sqrt'
            'Tan'
            'Tanh'
        ) 
        $Cases = $Methods | ForEach-Object {
            @{
                Name = $_
                Value = $m
                String = $s
            } 
        }

        It 'Calculates the <Name> of <String> correctly' -TestCases $Cases {
            param ($Name, $Value)

            $Given = @{
                Name = $true
                Value = $Value
            } 
            $Expected = [System.Numerics.Complex]::$Name.Invoke($Value)

            Invoke-ComplexMath @Given | Should Be $Expected
        } 
    } 

    Context 'BinaryOps' {
        $Methods = @(
            'Pow'
            'Log'
        ) 
        $Cases = $Methods | ForEach-Object {
            @{
                Name = $_
                Value = $m
                String = $s
                Argument = $a
            }
        }

        It 'Calculates <Name>(<String>, <Argument>) correctly' -TestCases $Cases {
            param ($Name, $Value, $Argument)

            $Given = @{
                $Name = $true
                Value = $Value
                Argument = $Argument
            } 
            $Expected = [System.Numerics.Complex]::$Name.Invoke($Value, $Argument)

            Invoke-ComplexMath @Given | Should Be $Expected
        } 
    }
}

Describe 'New-ComplexNumber' {
    It 'Creates a Complex Number from Cartesisan Coordinates' {
        $Given = @{
            Real = 4
            Imaginary = 2
        }
        $Expected = [System.Numerics.Complex]::new($Given.Real, $Given.Imaginary)

        New-ComplexNumber @Given | Should Be $Expected
    }

    It 'Creates a Complex Number from Polar Coordinates' {
        $Given = @{
            Magnitude = 42
            Phase = 0.42
        }
        $Expected = [System.Numerics.Complex]::FromPolarCoordinates($Given.Magnitude, $Given.Phase)

        New-ComplexNumber @Given | Should Be $Expected
    } 
}

Describe 'Show-ComplexNumber' {
    $ComplexNumbers = @(
        New-ComplexNumber 4 2
        New-ComplexNumber 4 -2 
    )
    $Cases = $ComplexNumbers | ForEach-Object {
        @{ 
            Value = $_
            String = $_.ToString()
        }
    }

    It 'Formats <String>' -TestCases $Cases -Skip {
        param ($Value) 
    }
}

#endregion