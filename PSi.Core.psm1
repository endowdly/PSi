<#
    .Synopsis
        Math calls for PowerShell.
    .Description
        This is a general module that simplifies math calls.
        This module covers the static Math class, System.Math for .NET Framework 3.5 

        The name PSi is generated from the greek letter Psi (Ψ), which is heavily used in math and science.
        It is commonly used in physics to represent wave function in quantum mechanics.
        And it is used to represent the states of a qubit in quantum computers.
        Ψ is used as the symbold for the polygamma function and numerous other functions in science and math. 
    .Notes 
        <endowdly@gmail.com> -- Jul 2019
#>

#region Setup -----------------------------------------------------------------------------------------------------
$ModuleRoot = Resolve-Path $PSScriptRoot | Split-Path -Leaf
$Import = @{ 
    BindingVariable = 'Resources'
    BaseDirectory = $PSScriptRoot
    FileName = $ModuleRoot + '.Resources.psd1'
}

try {
  Import-LocalizedData @Import -ErrorAction Stop
}
catch {
  Import-LocalizedData @Import -UICulture en-US -ErrorAction Stop 
} 

#endregion
#region Shared ----------------------------------------------------------------------------------------------------

# I typically write the scriptblocks below as filters.
# Writting these anonymous functions this way allows them to be used in PowerShell's magic ForEach method.
# This method typically executes faster than the PowerShell pipeline, which filters require.
<#  This
    
        $d.ForEach($Flatten).ForEach($InvokeUnary, 'Method')
    
    Versus This
        
        $d |
            Flatten |
            InvokeUnary 'Method'
            
#>

# Invokes the called Math method on the current object.
$InvokeUnary = { [Math]::$args[0].Invoke($_) }  # 'a -> string -> 'a 
# Invokes the called Math method on the current object with a static argument.
$InvokeUnary2 = {  # 'a -> string * 'b -> 'a
    $method, $arg = $args
    [Math]::$method.Invoke($_, $arg)
} 
# Invokes the called Math method on the current object with two static arguments.
$InvokeUnary3 = {  # a' -> string * 'b * 'c -> a' 
    $method, $a, $b = $args
    [Math]::$method.Invoke($_, $a, $b)
} 
# Flatten nested arrays and lists
#  Untyped or object type parameters allow multiple types; they are generic.
#  An object can be ANYTHING, including a nested array.
#  Because a nested array is possible, PowerShell will assume any object array is nested.
#  If a double array is an argument to an object array parameter, it becomes the first index.
#  Flattening will force PowerShell to consume an object array index by index without casting the incoming type.
$Flatten = {  # array[] -> array
    if ($_.Count -gt 1) {
        $_.ForEach($Flatten)
    }
    else {
        $_
    } 
}


# unit -> ErrorRecord
function ThrowArrayLengthError {
    <#
    .Synopsis
      Throws a standard array length error.
    #>

    $Msg = $Resources.ArrayLengthError
    $Rec = $Resources.ArrayLengthRecommendation
    $Ex = [System.ArgumentException]::new($Msg)

    Write-Error -Exception $Ex -Category InvalidArgument -RecommendedAction $Rec -ErrorAction Stop
}


# string -> 'a[] -> 'a[] -> 'a
function InvokeBinary ($s, $a, $b) {
    <#
    .Synopsis
      Invokes the called Math method on two parameters (curry).
s
    .Description
      Invokes the called Math method on two parameters (curry).
      Allows arrays and ensures they are equal in length before calculating.
    #>

    begin {
        if ($a.Count -ne $b.Count) {
            ThrowArrayLengthError
        }
    }

    end {
        foreach ($i in 0..($a.Count - 1)) {
            [Math]::$s.Invoke($a[$i], $b[$i])
        }
    }
}


# string -> 'a[] -> 'a[] -> ref -> 'a
function InvokeBinaryWithOutRef ($s, $a, $b, $out) {
    <#
    .Synopsis
      Invokes the called Math method on two parameters (curry) with an output reference.
    .Description
      Invokes the called Math method on two parameters (curry) with an output reference.
      Allows arrays and ensures they are equal in length before calculating.
    #>

    begin {
        if ($a.Count -ne $b.Count) {
            ThrowArrayLengthError
        }
    }

    end {
        foreach ($i in 0..($a.Count - 1)) {
            [Math]::$s.Invoke($a[$i], $b[$i], $out)
        }
    }
}


#endregion
#region Core Commands ----------------------------------------------------------------------------------------------


function Abs {
    <# 
    .Synopsis 
      Returns the absolute Value of a specified number.
    .Description 
      Returns the absolute Value of a specified number.
      Accepts Decimal, Double, Short, Int, Long, SByte, and Single types.
    .Example
      PS> Abs -42
      42 
    .Example
      PS> Abs -42 -24
      42...
    .Example
      PS> Abs -42, -24
      42...
    .Example
      PS> -42, -24 | Abs
      42... 
    #>

    param (
        # A number that is greater than or equal to MinValue, but less than or equal to MaxValue of its type.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [object[]] $n
    )

    process { 
        $n.ForEach($Flatten).ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Acos {
    <#
    .Synopsis
      Returns the angle whose cosine is the specified number.
    .Description
      Returns the angle whose cosine is the specified number in radians.
    .Example 
      PS> Acos 0.42
      1.13735100672501
    .Example 
      PS> Acos 0.42 0.24
      1.13735100672501...
    .Example 
      PS> Acos 0.42, 0.24
      1.13735100672501...
    .Example
      PS> 0.42, 0.24 | Acos
      1.13735100672501... 
    .Inputs
      System.Double
    .Outputs 
      System.Double

      An angle, θ, measured in radians, such that 0 ≤θ≤π -or- NaN if d < -1 or d > 1 or d equals NaN.
    .Notes
      Multiply the return value by 180/Math.PI to convert from radians to degrees.
    #>

    param (
        # A number representing a cosine, where d must be greater than or equal to -1, but less than or equal to 1.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Asin {
    <#
    .Synopsis
      Returns the angle whose sine is the specified number.
    .Description
      Returns the angle whose sine is the specified number in radians.
    .Example 
      PS> Asin 0.42
      1.13735100672501
    .Example 
      PS> Asin 0.42 0.24
      1.13735100672501...
    .Example 
      PS> Asin 0.42, 0.24
      1.13735100672501...
    .Example
      PS> 0.42, 0.24 | Asin
      1.13735100672501... 
    .Inputs
      System.Double
    .Outputs 
      System.Double

      An angle, θ, measured in radians, such that 0 ≤θ≤π -or- NaN if d < -1 or d > 1 or d equals NaN.
    .Notes
      Multiply the return value by 180/Math.PI to convert from radians to degrees.
    #>

    param (
        # A number representing a sine, where d must be greater than or equal to -1, but less than or equal to 1.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Atan {
    <#
    .Synopsis
      Returns the angle whose tangent is the specified number.
    .Description
      Returns the angle whose tangent is the specified number in radians.
    .Example
      PS> Atan 42
      1.54699130060983
    .Example
      PS> Atan 42 24
      1.54699130060983...
    .Example
      PS> Atan 42, 24
      1.54699130060983...
    .Example
      PS> 42, 24 | Atan 
      1.54699130060983...
    .Inputs
      System.Double
    .Outputs
      System.Double

      An angle, θ, measured in radians, such that -π/2 ≤θ≤π/2 -or-
      NaN if d equals NaN -or-
      -π/2 rounded to double precision (-1.5707963267949) if d equals NegativeInfinity -or-
       π/2 rounded to double precision (1.5707963267949) if d equals PositiveInfinity.
    .Notes
      A positive return value represents a counterclockwise angle from the x-axis; a negative return value represents a clockwise angle.
      Multiply the return value by 180/Math.PI to convert from radians to degrees. 
    #>

    param (
        # A number representing a tangent.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Atan2 {
    <#
    .Synopsis
      Returns the angle whose tangent is the quotient of two specified numbers.
    .Description
      Returns the angle whose tangent is the quotient of two specified numbers in radians.
    .Example
      PS> Atan2 42 24
      1.05165021254837
    .Example
      PS> Atan2 -y 42 -x 24
      1.05165021254837
    .Example
      PS> Atan2 -y 42, 4 -x 24, 2
      1.05165021254837...

      Arrays must be of equal length.
    .Example
      PS> $Obj | Atan2
      1.05165021254837

      When $Obj is PSObject { y = 42; x = 24 }.
    .Outputs
      System.Double

      An angle, θ, measured in radians, such that -π≤θ≤π, and tan(θ) = y / x, where (x, y) is a point in the Cartesian plane.
      Observe the following: 
        For (x, y) in quadrant 1, 0 < θ < π/2. 
        For (x, y) in quadrant 2, π/2 < θ≤π. 
        For (x, y) in quadrant 3, -π < θ < -π/2. 
        For (x, y) in quadrant 4, -π/2 < θ < 0. 
    
      For points on the boundaries of the quadrants, the return value is the following: 
        If y is 0 and x is not negative, θ = 0. 
        If y is 0 and x is negative, θ = π. 
        If y is positive and x is 0, θ = π/2. 
        If y is negative and x is 0, θ = -π/2. 
        If y is 0 and x is 0, θ = 0. 

      If x or y is NaN, or if x and y are either PositiveInfinity or NegativeInfinity, the method returns NaN. 
    .Notes
      The return value is the angle in the Cartesian plane formed by the x-axis, and a vector starting from the origin, (0,0), and terminating at the point, (x,y). 
    #>

    # param (
    #     # The y and x coordinate of a point.
    #     [Parameter(ValueFromRemainingArguments)]
    #     [double[][]] $a
    # )
    param (
        # The y coordinate of a point.
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [double[]]
        $y,

        # The x coordinate of a point.
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [double[]]
        $x 
    )

    process {
        # $a.ForEach($InvokeBinary, $MyInvocation.MyCommand.Name)

        InvokeBinary $MyInvocation.MyCommand.Name $y $x 
    }
}


function BigMul {
    <#
    .Synopsis
        Produces the full product of two 32-bit numbers.
    .Description
        Produces the full product of two 32-bit numbers. 
        BigMul is kind of useless... 
    .Example
        PS> BigMul 42 24
        1008
    .Example
        PS> BigMul -a 42 -b 24
        1008
    .Example
        PS> BigMul -a 42, 4 -b 24, 2
        1008...

        Arrays must be of equal length. 
    .Example
        PS> $Obj | BigMul
        1008...

        When $Obj is PSObject { a = 42; b = 24 }.
    .Outputs
        System.Int64 
    .Notes
        BigMul is kind of useless...
        A better method is to force two numbers to System.Int64 and multiply them.
        You can do this by:

        [long] 291823 * [long] 9851 -or- 
        [int64] 291823 * [int64] 109871 
    #>

    param (
        # The first number to multiply.
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [int[]] $a,

        # The second number to multiply.
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [int[]] $b
    )

    process {
        InvokeBinary $MyInvocation.MyCommand.Name $a $b
    }
}


function Ceiling {
    <#
    .Synopsis
      Returns the smallest integral value greater than or equal to the specified number.
    .Description
      Returns the smallest integral value greater than or equal to the specified number.
      Accepts Double and Decimal types.
    .Example
      PS> Ceiling 0.42
      1
    .Example
      PS> Ceiling 0.42 -0.42
      1...
    .Example
      PS> Ceiling 0.42, -0.42
      1...
    .Example
      PS> 0.42, -0.42 | Ceiling 
      1...
    .Notes
      The behavior of this method follows IEEE Standard 754, section 4.
      This kind of rounding is sometimes called rounding toward positive infinity. 
    #>

    param (
        # A number.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [object[]] $n
    )

    process {
        $n.ForEach($Flatten).ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Cos {
    <#
    .Synopsis
      Returns the cosine of the specified angle.
    .Description
      Returns the cosine of the specified angle in radians.
    .Example
      PS> Cos 42
      -0.399985314988351
    .Example
      PS> Cos 42 24
      -0.399985314988351... 
    .Example
      PS> Cos 42, 24
      -0.399985314988351... 
    .Example
      PS> 42, 24 | Cos
      -0.399985314988351... 
    .Inputs
      System.Double
    .Outputs
      System.Double

      The cosine of d.
      If d is equal to NaN, NegativeInfinity, or PositiveInfinity, this method returns NaN.
    .Notes
      The angle, d, must be in radians.
      Multiply by Math.PI/180 to convert degrees to radians.

      Acceptable values of d range from approximately -9223372036854775295 to approximately 9223372036854775295.
      For values outside this range, the Cos method returns d unchanged rather than throwing an exception. 
    #>

    param (
        # An angle, measured in radians.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    } 
}


function Cosh {
    <#
    .Synopsis
      Returns the hyperbolic cosine of the specified angle.
    .Description
      Returns the hyperbolic cosine of the specified angle in radians.
    .Example
      PS> Cosh 0.42
      1.08950418771685 
    .Example
      PS> Cosh 0.42 0.24
      1.08950418771685 ...
    .Example
      PS> Cosh 0.42, 0.24
      1.08950418771685...
    .Example
      PS> 0.42, 0.24 | Cosh 
      1.08950418771685...
    .Inputs
      System.Double
    .Outputs
      System.Double

      The hyperbolic cosine of value.
      If value is equal to NegativeInfinity or PositiveInfinity, PositiveInfinity is returned.
      If value is equal to NaN, NaN is returned.
    .Notes
      The angle, d, must be in radians.
      Multiply by Math.PI/180 to convert degrees to radians. 
    #>

    param (
        # An angle, measured in radians.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function DivRem {
    <#
    .Synopsis
      Calculates the quotient of two numbers and also returns the remainder in an output parameter.
    .Description
      Calculates the quotient of two numbers and also returns the remainder in an output parameter.
      Accepts Integer and long types.

      If arrays are passed as the dividend and divisor, and a result reference is passed, only the final result will be sent.
    .Example
      PS> DivRem 42 24
      1
    .Example
      PS> DivRem -a 42 -b 24
      1
    .Example
      PS> DivRem -a 42, 4 -b 24, 2
      1...

      Array lengths must be equal. 
    .Example
      PS> $Obj | DivRem 
      1...

      When $Obj is PSObject { a = 42; b = 24 }
    .Example
      PS> DivRem -a 42 -b 24 -Result ([ref] $Rem)
      1

      The value of $Rem will become 18, the remainder of 42 / 24. 
    .Example
      PS> DivRem -a 42 -b 24 -Result $Out
      1

      $Out must be a reference to a variable.
      The value of that variable will become 18, the remainder of 42 / 24. 
    .Notes
      The remainder value equals the result of the remainder operator.

      See also: IEEERemainder(Double, Double) 
    #>

    param (
        # The dividend.
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [object[]] $a,

        # The dividend.
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [object[]] $b,

        # The remainder. Must be a reference value.
        [Parameter(Position = 3)]
        [ref] $Result = [ref] $null
    )

    process  { 
        InvokeBinaryWithOutRef $MyInvocation.MyCommand.Name $a $b $Result 
    }
}

function Exp {
    <#
    .Synopsis
      Returns e raised to the specified power.
    .Description
      Returns e raised to the specified power.
    .Example
      PS> Exp .42
      1.52196155561863
    .Example
      PS> Exp .42 .24
      1.52196155561863...
    .Example
      PS> Exp .42, 0.24
      1.52196155561863...
    .Example
      PS> .42, 0.24 | Exp 
      1.52196155561863...
    .Inputs
      Sytem.Double
    .Outputs
      Sytem.Double

      The number e raised to the power d.
      If d equals NaN or PositiveInfinity, that value is returned.
      If d equals NegativeInfinity, 0 is returned.
    .Notes
      e is a mathematical constant whose value is approximately 2.71828. 
      Use the Pow method to calculate powers of other bases. 
      Exp is the inverse of Log. 
    #>

    param (
        # A number specifying a power.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Floor {
    <#
    .Synopsis
      Returns the largest integral value less than or equal to the specified number.
    .Description
      Returns the largest integral value less than or equal to the specified number.
      Accepts Double and Decimal types. 
    .Example
      PS> Floor .42
      0 
    .Example
      PS> Floor .42 -0.42
      0...
    .Example
      PS> Floor .42, -0.42
      0...
    .Example
      PS> .42, -0.42 | Floor 
      0...
    .Notes
      The behavior of this method follows IEEE Standard 754, section 4.
      This kind of rounding is sometimes called rounding toward negative infinity.    
    #>

    param (
        # A number.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [object[]] $n
    )

    process {
        $n.ForEach($Flatten).ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function IEEERemainder {
    <#
    .Synopsis
      Returns the remainder resulting from the division of a specified number by another specified number.
    .Description
      Returns the remainder resulting from the division of a specified number by another specified number.
    .Example
      PS> Rem 42 24
      -6
    .Example
      PS> Rem -x 42 -y 24
      -6
    .Example
      PS> Rem -x 42, 4 -y 24, 2
      -6...

      Array lengths must be equal.
    .Example
      PS> $Obj | Rem
      -6...

      When $Obj is PSObject { x = 42; y = 24 }.
    .Notes
      This operation complies with the remainder operation defined in Section 5.1 of ANSI/IEEE Std 754-1985; IEEE Standard for Binary Floating-Point Arithmetic; Institute of Electrical and Electronics Engineers, Inc; 1985.
      The IEEERemainder method is not the same as the remainder operator. 
      Although both return the remainder after division, the formulas they use are different.
      The formula for the IEEERemainder method is: 

        IEEERemainder = dividend - (divisor * Math.Round(dividend / divisor))

      In contrast, the formula for the remainder operator is: 

        Remainder = (Math.Abs(dividend) - (Math.Abs(divisor) *   
            (Math.Floor(Math.Abs(dividend) / Math.Abs(divisor))))) *   
            Math.Sign(dividend)
    #>

    [Alias('Rem')]

    param (
        # A dividend.
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [double[]] $x, 

        # A divisor.
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [double[]] $y 
    )

    process {
        InvokeBinary $MyInvocation.MyCommand.Name $x $y
    }
}


function Log {
    <#
    .Synopsis
      Returns the logarithm of a specified number.
    .Description 
      Returns the natural (base e) logarithm of a specified number by default.
      When a base is provided, returns the logarithm of a specified number in the specified base.
      If a base argument is provided and d is an array, the base argument will be applied to every number in d.
    .Example
      PS> Log 42
      3.73766961828337 
    .Example
      PS> Log 42 -Base 2
      5.39231742277876

      Demonstrating Log can be used to find the logarithm of any base.
    .Example
      PS> Log 42 24
      3.73766961828337...
    .Example
      PS> Log 42 24 -Base 2
      5.39231742277876
      4.58496250072116

      Demonstrating Log can be used to find the logarithm of any base.
      It will return a value in the specified base.
    .Example
      PS> Log 42, 24
      3.73766961828337...
    .Example
      PS> 42, 24 | Log
      3.73766961828337...
    .Inputs
      System.Double
    .Outputs
      System.Double

      Returns the values explained in the following table:

      d                 base                            return value
      d > 0             (0 < base < 1) -or (base > 1)   log_base(a)
      d < 0             -any-                           NaN
      -any-             base < 0                        NaN
      d != 1            base = 0                        NaN
      d != 1            base = +Infinity                NaN
      d = NaN           -any-                           NaN
      -any-             base = NaN                      NaN
      -any-             base = 1                        NaN
      d = 0             0 < base < 1                    PositiveInfinity
      d = 0             base > 1                        NegativeInfinity
      a = +Infinity     0 < base < 1                    NegativeInfinity
      a = +Infinity     base > 1                        PositiveInfinity
      a = 1             base = 0                        0
      a = 1             base = +Infinity                0
    #>

    param (
        # The number whose logarithm is to be found.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments, Position = 0)]
        [double[]]
        $d,

        # The base of the logarithm. Default: Math.E
        [Parameter(ValueFromPipelineByPropertyName)]
        [double]
        $Base = [Math]::E 
    )

    process {
        $d.ForEach($InvokeUnary2, $MyInvocation.MyCommand.Name, $Base)
    }
}


function Log10 {
    <#
    .Synopsis
      Returns the base 10 logarithm of a specified number.
    .Description
      Returns the base 10 logarithm of a specified number.
    .Example
      PS> Log10 42
      1.6232492903979
    .Example
      PS> Log10 42 24
      1.6232492903979... 
    .Example
      PS> Log10 42, 24
      1.6232492903979... 
    .Example
      PS> 42, 24 | Log10 
      1.6232492903979... 
    .Inputs
      System.Double
    .Outputs
      System.Double

      One of the values in the following table:
      d                 return value 
      d > 0             The log_10(d)
      d = 0             NegativeInfinity
      d < 0             NaN
      d = NaN           NaN
      d = +Infinity     PositiveInfinity
    .Notes
      Parameter d is specified as a base 10 number. 
    #>
    param (
        # A number whose logarithm is to be found.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Max {
    <#
    .Synopsis
      Returns the larger of two specified numbers.
    .Description
      Returns the larger of two specified numbers.
      Accepts any numerical type.
    .Example
      PS> Max 42 24
      42
    .Example
      PS> Max -Value1 42 -Value2 24
      42
    .Example
      PS> Max -Value1 42, 4 -Value2 24, 2
      42...

      Arrays must be of equal length.
    .Example
      PS> $Obj | Max
      42...

      When $Obj is PSObject { Value1 = 42; Value2 = 24 }.
    .Notes
      The core method is not CLS compliant. 
    #>
    param (
        # The first number to compare.
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [object[]] $Value1,

        # The second number to compare.
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [object[]] $Value2 
    )

    process {
        InvokeBinary $MyInvocation.MyCommand.Name $Value1 $Value2
    }
}


function Min {
    <#
    .Synopsis
      Returns the smaller of two numbers.
    .Description
      Returns the smaller of two numbers.
      Accepts any numerical type.
    .Example
      PS> Min 42 24
      24
    .Example
      PS> Min -Value1 42 -Value2 24
      24
    .Example
      PS> Min -Value1 42, 4 -Value2 24, 2
      24...
    .Example
      PS> $Obj | Min
      24...

      When $Obj is PSObject { Value1 = 42; Value2 = 24 }.
    .Notes
      The core method is not CLS compliant. 
    #>
    param (
        # The first number to compare.
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [object[]] $Value1,

        # The second number to compare.
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [object[]] $Value2 
    )

    process {
        InvokeBinary $MyInvocation.MyCommand.Name $Value1 $Value2
    }
}


function Pow {
    <#
    .Synopsis
      Returns a specified number raised to the specified power.
    .Description
      Returns a specified number raised to the specified power.
    .Example
      PS> Pow 2 4
      16
    .Example
      PS> Pow -x 2 -y 4
      16
    .Example
      PS> Pow -x 2, 16 -y 4, .25
      16...

      Arrays must be of equal length.
    .Example
      PS> $Obj | Pow
      16...

      When $Obj is PSObject { x = 2; y = 4 }.
    .Outputs 
      System.Double

      The number x raised to the power y.
    .Notes
      The following table indicates the return value when various values or ranges of values are specified for the x and y parameters:
      Parameters                                                                                    Return value
      x or y = NaN                                                                                  NaN
      x = Any value except NaN; y = 0                                                               1
      x = NegativeInfinity; y < 0                                                                   0
      x = NegativeInfinity; y is a positive odd integer                                             NegativeInfinity
      x = NegativeInfinity; y is positive even integer                                              PositiveInfinity
      x < 0 but not NegativeInfinity; y is not an integer, NegativeInfinity, or PositiveInfinity    NaN
      x = -1; y = NegativeInfinity or PositiveInfinity                                              NaN
      -1 < x < 1; y = NegativeInfinity                                                              PositiveInfinity
      -1 < x < 1; y = PositiveInfinity                                                              0
      x < -1 or x > 1; y = NegativeInfinity                                                         0
      x < -1 or x > 1; y = PositiveInfinity                                                         PositiveInfinity
      x = 0; y < 0                                                                                  PositiveInfinity
      x = 0; y > 0                                                                                  0
      x = 1; y is any value except NaN                                                              1
      x = PositiveInfinity; y < 0                                                                   0
      x = PositiveInfinity; y > 0                                                                   PositiveInfinity 
    #>

    param (
        # A double-precision floating-point number to be raised to a power.
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [double[]] $x,

        # A double-precision floating-point number that specifies a power.
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [double[]] $y 
    )

    process {
        InvokeBinary $MyInvocation.MyCommand.Name $x $y
    }
}


function Round {
    <#
    .Synopsis
      Rounds a value to the nearest integer or to the specified number of fractional digits.
    .Description
      Rounds a double-precision floating-point value to a specified number of fractional digits, and uses the specified rounding convention for midpoint values.
      By default, this function will round a number to an integer by using the rounding to nearest convention.
      By including a digits argument greater than 0, will round a number to a specified number of digits.
      By including the AwayFromZero switch, will round a number to the value closest from zero.

      If the digits parameter or if AwayFromZero rounding is used, those parameters will apply to every item in Values.
      Value can be either a Double or a Decimal type. 
    .Example
      PS> Round 42.4
      42
    .Example
      PS> Round 42.4 42.9
      42...
    .Example
      PS> Round 42.4, 42.9
      42...
    .Example
      PS> 42.4, 42.9 | Round 
      42...
    .Example
      PS> Round 42.42 -Digits 1 
      42.4
    .Example
      PS> Round 42.52 -AwayFromZero
      43
    .Example
      PS> Round 42.55 Digits 1 -AwayFromZero
      42.6
    .
    .Notes
      There is a lot of information on the Round method and how to understand the rounding methods available ->
        https://docs.microsoft.com/en-us/dotnet/api/system.math.round
      In addition to explaining the utility and method behind System.Round, the article provides use cases for when to use it.          
    #>
    param (
        # The number to be rounded.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments, Position = 0)]
        [object[]] $Value,

        # The number of fractional digits in the return value. Default: 0.
        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $Digits = 0,

        # Use AwayFromZero rounding mode instead of banker's rounding or ToEven rounding.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $AwayFromZero
    )

    begin {
        $Mode = @{
            $True = [System.MidpointRounding]::AwayFromZero
            $False = [System.MidpointRounding]::ToEven
        }
    }

    process {
        $Value.
            ForEach($Flatten).
            ForEach($InvokeUnary3, $MyInvocation.MyCommand.Name, $Digits, $Mode[$AwayFromZero.IsPresent])
    }
}


function Sign {
    <#
    .Synopsis
      Returns an integer that indicates the sign of a number.
    .Description
      Returns an integer that indicates the sign of a number.
      Value can be Single, SByte, Integer, Long, Double, Decimal, or Short types.
    .Example
      PS> Sign -42
      -1
    .Example
      PS> Sign -42 24
      -1...
    .Example
      PS> Sign -42, 24
      -1...
    .Example
      PS> -42, 24 | Sign 
      -1...
    .Outputs
      System.Int32

      A number that indicates the sign of value, as shown in the following table.
      Return Value      Meaning
      -1                value is less than zero
      0                 value is zero
      1                 value is greater than zero 
    #>
    param (
        # A signed number.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [object[]] $Value
    )

    process {
        $Value.ForEach($Flatten).ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Sin {
    <#
    .Synopsis
      Returns the sine of the specified angle.
    .Description
      Returns the sine of the specified angle.
    .Example
      PS> Sin 42
      -0.916521547915634
    .Example
      PS> Sin 42 24
      -0.916521547915634...
    .Example
      PS> Sin 42, 24
      -0.916521547915634...
    .Example
      PS> 42, 24 | Sin
      -0.916521547915634...
    .Inputs
      System.Double
    .Outputs
      System.Double

      The sine of d.
      If d is equal to NaN, NegativeInfinity, or PositiveInfinity, this method returns NaN.
    .Notes
     The angle, d, must be in radians.
     Multiply by Math.PI/180 to convert degrees to radians.  
     Acceptable values of a range from approximately -9223372036854775295 to approximately 9223372036854775295.
     For values outside of this range, the Sin method returns a unchanged rather than throwing an exception. 
    #>
    param (
        # An angle, measured in radians.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Sinh {
    <#
    .Synopsis
      Returns the hyperbolic sine of the specified angle.
    .Description
      Returns the hyperbolic sine of the specified angle.
    .Example
      PS> Sinh 0.42
      0.432457367901789
    .Example
      PS> Sinh 0.42 0.24
      0.432457367901789...
    .Example
      PS> Sinh 0.42, 0.24
      0.432457367901789...
    .Example
      PS> 0.42, 0.24 | Sinh 
      0.432457367901789...
    .Inputs
      System.Double
    .Outputs
      System.Double

      The hyperbolic sine of value.
      If value is equal to NegativeInfinity, PositiveInfinity, or NaN, this method returns a Double equal to value.
    .Notes
      The angle, value, must be in radians.
      Multiply by Math.PI/180 to convert degrees to radians. 
    #>
    param (
        # An angle, measured in radians.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Sqrt {
    <#
    .Synopsis
      Returns the square root of a specified number.
    .Description
      Returns the square root of a specified number.
    .Example
      PS> Sqrt 42
      6.48074069840786 
    .Example
      PS> Sqrt 42 24
      6.48074069840786...
    .Example
      PS> Sqrt 42, 24
      6.48074069840786...
    .Example
      PS> 42, 24 | Sqrt 
      6.48074069840786...
    .Inputs
      System.Double
    .Outputs
      System.Double

      One of the values in the following table:
      d parameter               return value
      d >= 0                    sqrt(0)
      d < 0                     NaN
      d = NaN                   NaN
      d = +Infinity             PositiveInfinity
    #>

    param (
        # The number whose square root is to be found.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Tan {
    <#
    .Synopsis
      Returns the tangent of the specified angle.
    .Description
      Returns the tangent of the specified angle.
    .Example
      PS> Tan 42
      2.29138799243749
    .Example
      PS> Tan 42 24
      2.29138799243749...
    .Example
      PS> Tan 42, 24
      2.29138799243749...
    .Example
      PS> 42, 24 | Tan 
      2.29138799243749...
    .Inputs
      System.Double  
    .Outputs
      System.Double  

      The tangent of a.
      If a is equal to NaN, NegativeInfinity, or PositiveInfinity, this method returns NaN.
    #>
    param (
        # An angle, measured in radians.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Tanh {
    <#
    .Synopsis
      Returns the hyperbolic tangent of the specified angle.
    .Description
      Returns the hyperbolic tangent of the specified angle.
    .Example
      PS> Tanh 1
      0.761594155955765
    .Example
      PS> Tanh 1 0.42
      0.761594155955765...
    .Example
      PS> Tanh 1, 0.42
      0.761594155955765...
    .Example
      PS> 1, 0.42 | Tanh 
      0.761594155955765... 
    .Inputs
      System.Double
    .Outputs
      System.Double

      The hyperbolic tangent of value.
      If value is equal to NegativeInfinity, this method returns -1.
      If value is equal to PositiveInfinity, this method returns 1.
      If value is equal to NaN, this method returns NaN. 
    #>
    param (
        # An angle, measured in radians.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function Truncate {
    <#
    .Synopsis
      Calculates the integral part of a number.
    .Description
      Calculates the integral part of a number.
      Accepts either Double or Decimal types.
    .Example
      PS> Truncate 42.4
      42
    .Example
      PS> Truncate 42.4 24.4
      42...
    .Example
      PS> Truncate 42.4, 24.4
      42...
    .Example
      PS> 42.4, 24.4 | Truncate 
      42...
    .Notes
      The number is rounded to the nearest integer towards zero. 
    #>
    param (
        # A number to truncate.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [object[]] $d
    )

    process {
        $d.ForEach($Flatten).ForEach($InvokeUnary, $MyInvocation.MyCommand.Name)
    }
}


function pi { [Math]::PI }
function tau { (pi) * 2 }

#endregion

# Exporting 
[System.Math] |
    Get-Member -Static |
    ForEach-Object Name |
    Export-ModuleMember

Export-ModuleMember -Function Tau
