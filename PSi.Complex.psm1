<# 
    .Synopsis
      Complex calls for PowerShell.
    .Description
      This is a general module that simplifies complex number calls.
      This module covers the .NET Complex class, System.Numerics.Complex for .NET Framework 4.6.
#>

#region Setup -----------------------------------------------------------------------------------------------------
$ModuleRoot = Resolve-Path $PSScriptRoot | Split-Path -Leaf
$Import = @{ 
    BindingVariable = 'Resources'
    BaseDirectory = $PSScriptRoot
    FileName = $ModuleRoot + '.Resources.psd1'
}

try {
    Import-LocalizedData @Import -ErrorAction SilentlyContinue 
}
catch {
    Import-LocalizedData @Import -UICulture en-US -ErrorAction Stop 
} 

#region Complex Commands --------------------------------------------------------------------------------------------------


<#
  System.Numerics.Complex supports standard binary operators.
  Since they are supported,  they will not be added in this function.
  
  System.Math methods will not transmute for Numerics.Complex methods.
  So they are included.
  
  This function will focus on easy access to the most common unary operations:
  Conjugate,  Negate,  and Reciprocal.
#> 
function Invoke-ComplexMath { 
    <#
        .Synopsis
            Allows easy access to Numerics.Complex methods. 
        .Description
            Allows easy access to Numerics.Complex methods. 
            System.Numerics.Complex supports standard binary operators ('-', '+', '*', '/').
            Because basic operators are supported,  they are not included here. 
        .Inputs
            System.Numerics.Complex
        .Outputs
            System.Numerics.Complex 
        .Example
            PS> Invoke-ComplexMath -Negate $m
            Real            Imaginary            Magnitude               Phase
            ----            ---------            ---------               -----
              -2                   -3     3.60555127546399   -2.15879893034246
        
        .Example
            PS> $n, $m | Invoke-ComplexMath -Abs
            3.16227766016838
            3.60555127546399
            
            Description
            -----------
            Demonstrating use of the Pipeline for Unary Operations.
            
        .Example
            PS> Invoke-ComplexMath -Log $m 2
            Real            Imaginary            Magnitude               Phase
            ----            ---------            ---------               -----
1.85021985907055     1.41787163074572     2.33102412861226   0.653868149497725

            Description
            -----------
            Demonstrating use of the binary operation 'Log'.
        
        .Link
            Show-ComplexNumber 
        .Link
            New-ComplexNumber
    #>

    [CmdLetBinding(DefaultParameterSetName = 'Conjugate')]
    [Alias('cm')]
    [OutputType('System.Numerics.Complex')]
    
    param (
        # A complex number.
        [Parameter(Mandatory, HelpMessage = 'Enter complex object',
                   ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)] 
        [Numerics.Complex] $Value, 
        
        # Computes the conjugate of a complex number and returns the result.       [Parameter(ParameterSetName = 'Conjugate')]
        [Switch] $Conjugate, 
        
        # Returns the multiplicative inverse of a complex number.
        [Parameter(ParameterSetName = 'Reciprocal')]
        [Switch] $Reciprocal, 
        
        # Returns the additive inverse of a specified complex number.
        [Parameter(ParameterSetName = 'Negate')]
        [Switch] $Negate, 
        
        # Gets the absolute value (or magnitude) of a complex number.
        [Parameter(ParameterSetName = 'Abs')]
        [Switch] $Abs, 
        
        # Returns the angle that is the arc cosine of the specified complex number
        [Parameter(ParameterSetName = 'Acos')]
        [Switch] $Acos, 
        
        # Returns the angle that is the arc sine of the specified complex number.
        [Parameter(ParameterSetName = 'Asin')]
        [Switch] $Asin, 
        
        # Returns the angle that is the arc tangent of the specified complex number.
        [Parameter(ParameterSetName = 'Atan')]
        [Switch] $Atan, 
        
        # Returns the cosine of the specified complex number.
        [Parameter(ParameterSetName = 'Cos')]
        [Switch] $Cos, 
        
        # Returns the hyperbolic cosine of the specified complex number.
        [Parameter(ParameterSetName = 'Cosh')]
        [Switch] $Cosh, 
        
        # Returns e raised to the power specified by a complex number.
        [Parameter(ParameterSetName = 'Exp')]
        [Switch] $Exp, 
        
        # Returns the base-10 logarithm of a specified complex number.
        [Parameter(ParameterSetName = 'Log10')]
        [Switch] $Log10, 
        
        # Returns the sine of the specified complex number.
        [Parameter(ParameterSetName = 'Sin')]
        [Switch] $Sin, 
        
        # Returns the hyperbolic sine of the specified complex number.
        [Parameter(ParameterSetName = 'Sinh')]
        [Switch] $Sinh, 
        
        # Returns the square root of a specified complex number.
        [Parameter(ParameterSetName = 'Sqrt')]
        [Switch] $Sqrt, 
        
        # Returns the tangent of the specified complex number.
        [Parameter(ParameterSetName = 'Tan')]
        [Switch] $Tan, 
        
        # Returns the hyperbolic tangent of the specified complex number.
        [Parameter(ParameterSetName = 'Tanh')]
        [Switch] $Tanh, 
        
        # Returns a specified complex number raised to a power specified by a double-precision floating-point number or complex number.
        [Parameter(ParameterSetName = 'Pow')]
        [Switch] $Pow, 
        
        # Returns the logarithm of a specified complex number in a specified base.
        [Parameter(ParameterSetName = 'Log')]
        [Switch] $Log, 
        
        # A number that is either a double or complex number.
        [Parameter(ParameterSetName = 'Pow', Position = 1, ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName = 'Log', Position = 1, ValueFromPipelineByPropertyName)]
        $Argument = 1 # Can be multiple types
    )
    
    begin {
        $method = $PSCmdlet.ParameterSetName
        
        function UnaryOp {  # string -> Complex -> Complex
            [Numerics.Complex]::$method.Invoke($Value)
        }
        
        function BinaryOp {  # string -> Complex -> 'a -> Complex
            [Numerics.Complex]::$method.Invoke($Value, $Argument)
        }
    }
    
    process { 
        switch ($PSCmdlet.ParameterSetName) {
            
            #     Unary Set   
            # vvvvvvvvvvvvvvvvv
            'Conjugate'  { UnaryOp }
            'Reciprocal' { UnaryOp }
            'Negate'     { UnaryOp }
            'Abs'        { UnaryOp }
            'Acos'       { UnaryOp }
            'Asin'       { UnaryOp }
            'Atan'       { UnaryOp }
            'Cos'        { UnaryOp }
            'Cosh'       { UnaryOp }
            'Exp'        { UnaryOp }
            'Log10'      { UnaryOp }
            'Sin'        { UnaryOp }
            'Sinh'       { UnaryOp }
            'Sqrt'       { UnaryOp }
            'Tan'        { UnaryOp }
            'Tanh'       { UnaryOp }
            #^^^^^^^^^^^^^^^^^
            
            #     Binary Set   
            # vvvvvvvvvvvvvvvvvv
            'Pow'        { BinaryOp }
            'Log'        { BinaryOp }
            #^^^^^^^^^^^^^^^^^
        } 
    }
}


function New-ComplexNumber {
    <#
    .Synopsis
      Creates a new System.Numerics.Complex object. 
    .Description
      Creates a Numerics.Complex object using either Real and Imaginary inputs or Magnitude and Phase inputs.
      Can also create a complex object from Real One,  Imaginary One,  or Zero constants.
       
      When no arguments are passed,  creates a Complex object with real and imaginary components of zero. 
    .Outputs
      System.Numerics.Complex 
    .Example
        PS> New-ComplexNumber -Real 2 -Imaginary -3
       
        Real                        Imaginary                       Magnitude                           Phase
        ----                        ---------                       ---------                           -----
           2                               -3                3.60555127546399              -0.982793723247329  
    .Example
        PS> $m = New-ComplexNumber 3 1
        PS> $a
       
         Real                        Imaginary                       Magnitude                           Phase
         ----                        ---------                       ---------                           -----
            3                                1                3.16227766016838               0.321750554396642 
    .Example
        PS> New-ComplexNumber -ImaginaryOne
       
         Real                        Imaginary                       Magnitude                           Phase
         ----                        ---------                       ---------                           -----
            0                                1                               1                 1.5707963267949 
    .Example
        PS> New-ComplexNumber -Magnitude 3.5 -Phase 0.25
       
            Real                        Imaginary                       Magnitude                           Phase
            ----                        ---------                       ---------                           -----
3.39119347598726                 0.86591385739083                             3.5                            0.25 
    .Link
      Show-ComplexNumber 
    .Link
      Invoke-ComplexMath 
    .Notes
      Requires PowerShell 2.0
      Requires the System.Numerics.dll

      Because there are multiple representations of a point on a complex plane, the return value of the FromPolarCoordinates method is normalized.
      The magnitude is normalized to a positive number, and the phase is normalized to a value in the range of -PI to PI.
      As a result, the values of the Phase and Magnitude properties of the resulting complex number may not equal the original values of the magnitude and phase parameters.
      To convert a value from degrees to radians for the phase parameter, multiply it by Math.PI/180.
    #>
 
    [CmdLetBinding(DefaultParameterSetName = 'Cartesian')]
    [Alias('i')]
    [OutputType('System.Numerics.Complex')]
   
    param (
        # The real part of the complex number.
        [Parameter(Position = 0, ParameterSetName = 'Cartesian')]
        [Double] $Real,
       
        # The imaginary part of the complex number.
        [Parameter(Position = 1, ParameterSetName = 'Cartesian')]
        [Double] $Imaginary,
       
        # The magnitude, which is the distance from the origin (the intersection of the x-axis and the y-axis) to the number.
        [Parameter(Position = 0, ParameterSetName = 'Polar')]
        [Double] $Magnitude,
       
        # The phase, which is the angle from the line to the horizontal axis, measured in radians.
        [Parameter(Position = 1, ParameterSetName ='Polar')]
        [Double] $Phase,
       
        # Returns a new Complex instance with a real number equal to zero and an imaginary number equal to one.
        [Parameter(ParameterSetName = 'ImaginaryOne')]
        [Alias('i1')]
        [Switch] $ImaginaryOne,
       
        # Returns a new Complex instance with a real number equal to one and an imaginary number equal to zero.
        [Parameter(ParameterSetname = 'One')]
        [Alias('1')]
        [Switch] $One,
       
        # Returns a new Complex instance with a real number equal to zero and an imaginary number equal to zero.
        [Parameter(ParameterSetname = 'Zero')]
        [Alias('0')]
        [Switch] $Zero
    )
   
    begin {
       
        function NewComplexNumber {
            # New-Object System.Numerics.Complex $Real, $Imaginary
            [System.Numerics.Complex]::new($Real, $Imaginary)
        }

        function NewComplexNumberFromPolar {
            [System.Numerics.Complex]::FromPolarCoordinates($Magnitude, $Phase)
        }
       
        function NewComplexNumberFromConstant ($constantMethod) {
            [System.Numerics.Complex]::$constantMethod
        }
    }
   
    process { 
        switch ($PsCmdlet.ParameterSetName) {
            'Cartesian'    { NewComplexNumber                }
            'Polar'        { NewComplexNumberFromPolar       }
            'ImaginaryOne' { NewComplexNumberFromConstant $_ }
            'One'          { NewComplexNumberFromConstant $_ }
            'Zero'         { NewComplexNumberFromConstant $_ }
        }
    }
}


# Todo: Rename to Format
function Write-ComplexNumber { 
    <#
    .Synopsis
      Display a Complex Number Object 
    .Description
      Takes a Numerics.Complex Object and converts it into a human readable string.
      Common complex number syntax in either cartesian or polar formatting.
    .Inputs
      System.Numerics.Complex
    .Outputs
      System.String 
    .Example
      PS> $m = New-ComplexNumber -Real 2 -Imaginary -3
      PS> Write-ComplexNumber $a
      2-3i        
    .Example
      PS> $a = New-ComplexNumber -Real 2 -Imaginary -3
      PS> Write-ComplexNumber -Polar $a
      3.61 ∟ -0.983 
    .Example
      PS> $m,$n | Write-ComplexNumber
      2-3i
      4+2i
        
      Write-ComplexNumber can accept System.Numerics.Complex Objects from the pipeline. 
    .Link
      New-ComplexNumber 
    .Link
      Invoke-ComplexMath 
    .Notes
      Requires PowerShell 2.0
      Requires the System.Numerics.dll
        
      For displaying the polar form, the Unicode character for angle will auto-select depending on which Host is being used.
    #> 
    
    [CmdletBinding()]
    [Alias('wcn')]
    [OutputType('System.String')]
    
    param (
        # A complex number to display.
        [Parameter(Position = 0,
                   Mandatory, HelpMessage = 'Please provide a Complex Number.',
                   ValueFromPipeline)]
        [System.Numerics.Complex[]] $InputObject,
        
        # Display in polar form.
        [Switch] $Polar,

        # Write basic ASCII symbols.
        [Switch] $BasicSymbols
    )
    
    begin {
        [char] $Angle = 
            if ($BasicSymbols) { 
                0x221F  # a right angle
            } 
            else { 
                0x2220  # an acute angle
            }
        $Write = {
            if ($Polar) {
                '{0:g3} {1} {2:g3}' -f $_.Magnitude, $Angle, $_.Phase;
            }
            elseif (0 -ge $_.Imaginary) {
                '{0}{1}i' -f $_.Real, $_.Imaginary;
            }  
            else {
                '{0}+{1}i' -f $_.Real, $_.Imaginary;
            }  
        } 
    }
    
    process {
        $InputObject.ForEach($Write) 
    }
}


#endregion
