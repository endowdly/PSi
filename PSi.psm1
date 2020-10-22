# This is a general module that simplifies math calls and can incorporate other math/science modules

# A wrapper function that invokes a passed System.Math method on the current item.
$InvokeMath = { [Math]::$args[0].Invoke($_) }  # a' -> string -> a'
# A wrapper function that invokes a passed System.Math method on the current item and an additional, static argument.
$InvokeMath2 = {  # a' -> string -> a' -> a'
    $method, $arg = $args
    [Math]::$method.Invoke($_, $arg) 
}
# Flatten nested lists and arrays.
#  To prevent PowerShell from overriding the incoming type, the InputObject must be a generic array.
#  Since an object array is amiguous, and could be a nested array; PowerShell will treat it as such.
$Flatten = {  # array[] -> array
    if ($_.Count -gt 1) {
        $_.ForEach($Flatten) 
    }
    else {
        $_
    }
}


function InvokeBinary ($s, $a, $b) {  # string -> 'a[] -> 'a[] -> 'a[]
    <#
    .Synopsis
        Map2 for a Math method.
    #>

    if ($a.Count -ne $b.Count) { 
        $ex = New-Object System.ArgumentException 'Array lengths not equal!'

        Write-Error -Exception $ex -Category InvalidOperation -ErrorAction Stop 
    }

    foreach ($idx in 0..($a.Count - 1)) {
        [Math]::$s.Invoke($a[$idx], $b[$idx])
    } 
}


function InvokeBinaryWithOut ($s, $a, $b, $r) {
    <#
    .Synopsis
        Map2 for a Math method with a return reference.
    #>

    if ($a.Count -ne $b.Count) { 
        $ex = New-Object System.ArgumentException 'Array lengths not equal!'

        Write-Error -Exception $ex -Category InvalidOperation -ErrorAction Stop 
    }

    foreach ($idx in 0..($a.Count - 1)) {
        [Math]::$s.Invoke($a[$idx], $b[$idx], $r)
    } 
}



function Abs {
    <# 
    .Synopsis 
      Returns the absolute Value of a specified number.
    .Description 
      Returns the absolute Value of a specified number.
      Must be of Decimal, Double, Int16, Int32, Int64, SByte, or Single or convertable thereto.
      Can consume pipeline input, singular, and multiple arguments.
    .Example
      PS> Abs -42
      42 
    .Example
      PS> Abs -42 -0.42 -99
      42...
    .Example
      PS> -42, -0.42, 420 | Abs
      42...    
    .Example 
      PS> Abs -42, -0.42, 420
      42... 
    .Notes
      The absolute value of a Single is its numeric value without its sign.
      For example, the absolute value of both 1.2e-03 and -1.2e03 is 1.2e03.
      If value is equal to NegativeInfinity or PositiveInfinity, the return value is PositiveInfinity.
      If value is equal to NaN, the return value is NaN. 
    #>

    param (
        # A number that is >= MinValue of its type, but <= MaxValue of its type.
        [Parameter(ValueFromRemainingArguments, ValueFromPipeline)]
        [object[]] $x
    )

    process { 
        $x.ForEach($Flatten).ForEach($InvokeMath, $MyInvocation.MyCommand.Name)
    }
}


function Acos {
    <#
    .Synopsis
      Returns the angle whose cosine is the specified number.
    .Description
      Returns the angle whose cosine is the specified number in rads.
      Can consume pipeline input, singular, and multiple arguments.
    .Example 
      PS> Acos 0.42
      1.13735100672501
    .Example 
      PS> Acos 0.42 0.33 0.12
      1.13735100672501...
    .Example
      PS> Acos 0.42, 0.33, 0.12
    .Example 
      PS> 0.42, 0.33, 0.12 | Acos
      1.13735100672501... 
    .Inputs 
      System.Double
    .Outputs 
      System.Double

      An angle, θ, measured in radians, such that 0 ≤θ≤π -or- NaN if d < -1 or d > 1 or d == NaN.
    .Notes
      Multiply the return value by 180/Math.PI to convert from radians to degrees.
    #>

    param (
        # A number representing a cosine, where d must be >= to -1, but <= to 1.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process { 
        $d.ForEach($InvokeMath, $MyInvocation.MyCommand.Name)
    }
}


function Asin {
    <#
    .Synopsis
      Returns the angle whose sine is the specified number.
    .Description
      Returns the angle whose sine is the specified number in rads.
      Can consume pipeline input, singular, and multiple arguments.
    .Example 
      PS> Asin 0.42
      1.13735100672501
    .Example 
      PS> Asin 0.42 0.33 0.12
      1.13735100672501...
    .Example 
      PS> Asin 0.42, 0.33, 0.12
      1.13735100672501...
    .Example
      PS> 0.42, 0.33, 0.12 | Asin
      1.13735100672501... 
    .Inputs 
      System.Double
    .Outputs 
      System.Double

      An angle, θ, measured in radians, such that -π/2 ≤θ≤π/2 -or- NaN if d < -1 or d > 1 or d == NaN.
    .Notes
      Multiply the return value by 180/Math.PI to convert from radians to degrees.
    #>

    param (
        # A number representing a sine, where d must be >= to -1, but <= to 1.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeMath, $MyInvocation.MyCommand.Name)
    }
}


function Atan {
    <#
    .Synopsis
      Returns the angle whose tangent is the specified number.
    .Description
      Returns the angle whose tangent is the specified number in rads.
    .Example
      PS> Atan 42
      1.54699130060983
    .Example
      PS> Atan 42 0.42 420
      1.54699130060983...
    .Example
      PS> Atan 42, 0.42, 420
      1.54699130060983...
    .Example
      PS> 42, 0.42, 420 | Atan
      1.54699130060983...
    .Inputs 
      System.Double
    .Outputs
      System.Double

      An angle, θ, measured in radians, such that -π/2 ≤θ≤π/2 -or-
      NaN if d equals NaN -or
      π/2 rounded to double precision (-1.5707963267949) if d equals NegativeInfinity -or
      π/2 rounded to double precision (1.5707963267949) if d equals PositiveInfinity. 
    .Notes
      A positive return value represents a counterclockwise angle from the x-axis.
      A negative return value represents a clockwise angle.
      Multiply the return value by 180/Math.PI to convert from radians to degrees. 
    #>
    
    param (
        # A number representing a tangent.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d)

    process { 
        $d.ForEach($InvokeMath, $MyInvocation.MyCommand.Name)
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
      PS> Atan2 -y 42,12,31 -x 24,21,31
      1.05165021254837...

      Can handle arrays so long as they are of equal length.
    .Example
      PS> $Objs | Atan2
      1.05165021254837...

      Where Obj[0] is PSObject { y = 42; x = 24 } 
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
    

    param ( 
        # The y coordinate of a point.
        [Parameter(ValueFromPipelineByPropertyName, Position=0)]
        [double[]] $y,

        # The x coordinate of a point.
        [Parameter(ValueFromPipelineByPropertyName, Position=1)]
        [double[]] $x
    )    

    begin {
        $Method = $MyInvocation.MyCommand.Name
    }

    process { 
        InvokeBinary $Method $y $x 
    } 
}
 
function BigMul {
    <#
    .Synopsis
      Produces the full product of two 32-bit numbers.
    .Description
      Produces the full product of two 32-bit numbers as a 64-bit number.
    .Example
      PS> BigMul 42 42
      1764 
    .Example
      PS> BigMul -a 42 -b 42
      1764 
    .Example
      PS> BigMul -a 42, 24 -b 42, 24
      1764...

      Can handle arrays so long as they are of equal length.
    .Example
      PS> $Obj | BigMul
      1764...

      Where $Obj[0] is PSObject { a = 42; b = 42 }.
    .Outputs
      System.Int64

      The number containing the product of the specified numbers.
    #>

    param (
        # The first number to multiply.
        [Parameter(ValueFromPipelineByPropertyName, Position=0)]
        [int[]] $a,

        # The second number to multiply.
        [Parameter(ValueFromPipelineByPropertyName, Position=0)]
        [int[]] $b
    )

    begin { 
       $Method = $MyInvocation.MyCommand.Name
    }

    process { 
        InvokeBinary $Method $a $b
    } 
}


function Ceiling {
    <#
    .Synopsis
      Returns the smallest integral value greater than or equal to the specified number.
    .Description
      Returns the smallest integral value greater than or equal to the specified number.
      Accepts decimals and doubles, and returns the type of the incoming value.
    .Example
      PS> Ceiling 41.8 0.42 420.1
      42...
    .Notes
      The behavior of this method follows IEEE Standard 754, section 4.
      This kind of rounding is sometimes called rounding toward positive infinity.
    #>

    param (
        # A number that is >= MinValue of its type, but <= MaxValue of its type.
        [Parameter(ValueFromRemainingArguments, ValueFromPipeline)]
        [object[]] $x
    )

    process { 
        $x.ForEach($Flatten).ForEach($InvokeMath, $MyInvocation.MyCommand.Name)
    }
}


function Cos {
    <#
    .Synopsis
      Returns the cosine of the specified angle.
    .Description
      Returns the cosine of the specified angle.
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
    .Outputs
      System.Double

      The cosine of d.
      If d is equal to NaN, NegativeInfinity, or PositiveInfinity, this method returns NaN.
    .Notes
      The angle, d, must be in radians.
      Multiply by Math.PI/180 to convert degrees to radians. 
      Acceptable values of d range from approximately -9223372036854775295 to approximately 9223372036854775295. For values outside this range, the Cos method returns d unchanged rather than throwing an exception.
    #>

    param (
        # An angle, measured in radians.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process { 
        $d.ForEach($InvokeMath, $MyInvocation.MyCommand.Name)
    } 
}


function Cosh {
    <#
    .Synopsis
      Returns the hyperbolic cosine of the specified angle.
    .Description
      Returns the hyperbolic cosine of the specified angle.
    .Example
      PS> Cosh 0.42
      1.08950418771685
    .Example
      PS> Cosh 0.42 0.24
      1.08950418771685...
    .Example
      PS> Cosh 0.42, 0.24 
      1.08950418771685...
    .Example
      PS> 0.42, 0.24 | Cosh 
      1.08950418771685...
    .Outputs
      Sytem.Double

      The hyperbolic cosine of value.
      If value is equal to NegativeInfinity or PositiveInfinity, PositiveInfinity is returned.
      If value is equal to NaN, NaN is returned.
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
        $d.ForEach($InvokeMath, $MyInvocation.MyCommand.Name)
    } 
}


function DivRem {
    <#
    .Synopsis
      Calculates the quotient of two numbers and also returns the remainder in an output parameter.
    .Description
      Calculates the quotient of two numbers and also returns the remainder in an output parameter.
      Parameters can be integers or longs (Int32 or Int64).
    .Example
      PS> DivRem 13 3
      4
    .Example
      PS> DivRem -a 13 -b 3
      4
    .Example
      PS> DivRem -a 13, 42 -b 3, 10
      4...

      Can handle arrays of same length.
    .Example
      PS> $Obj | DivRem 
      4...

      Where $Obj[0] is PSObject { a = 13; b = 3 }
    .Example
      PS> DivRem 13 3 -Result ([ref] $remainder)
      4...

      Sets the variable remainder to a value of the remainder (1).
    .Notes
      The remainder value equals the result of the remainder operator.
      See also IEEERemainder(Double, Double).
    .Link
      IEEERemainder
    #>

    param (
        # The dividend.
        [Parameter(ValueFromPipelineByPropertyName, Position=0)]
        [object[]] $a,

        # The divisor.
        [Parameter(ValueFromPipelineByPropertyName, Position=1)]
        [object[]] $b,  

        # The result.
        # If multiple arguments are passed, only the last pair will return a result.
        [Parameter()]
        [ref] $Result = [ref] $null
    )

    begin {
        $Method = $MyInvocation.MyCommand.Name
    }

    process {
        InvokeBinaryWithOut $Method $a $b $result
    } 
}


function Exp {
    <#
    .Synopsis
      Returns e raised to the specified power.
    .Description
      Returns e raised to the specified power.
    .Example
      PS> Exp 42
      1.52196155561863...
    .Example
      PS> Exp 42 24
      1.52196155561863...
    .Example
      PS> Exp 42, 24
      1.52196155561863...
    .Example
      PS> 42, 24 | Exp 
      1.52196155561863...
    .Outputs
      System.Double

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
        $d.ForEach($InvokeMath, $MyInvocation.MyCommand.Name)
    } 
}


function Floor {
    <#
    .Synopsis
      Returns the largest integral value less than or equal to the specified number.
    .Description
      Returns the largest integral value less than or equal to the specified number.
      Accepts types decimal and double.
    .Example
      PS> Floor 42.42
      42
    .Example
      PS> Floor 42.42 24.24
      42...
    .Example
      PS> Floor 42.42, 24.24
      42...
    .Example
      PS> 42.42, 24.24 | Floor 
      42...
    .Notes
      The behavior of this method follows IEEE Standard 754, section 4.
      This kind of rounding is sometimes called rounding toward negative infinity.
    #>

    param (
        # A number.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [object[]] $x
    )

    process {
        $x.ForEach($Flatten).ForEach($InvokeMath, $MyInvocation.MyCommand.Name)
    } 
}


function IEEERemainder {
    <#
    .Synopsis
      Returns the remainder resulting from the division of a specified number by another specified number.
    .Description
      Returns the remainder resulting from the division of a specified number by another specified number.
    .Example
      PS> IEEERemainder 42 24
      
    .Outputs
      System.Double

      A number equal to x - (y Q), where Q is the quotient of x / y rounded to the nearest integer (if x / y falls halfway between two integers, the even integer is returned).

      If x - (y Q) is zero, the value +0 is returned if x is positive, or -0 if x is negative.
      If y = 0, NaN is returned.
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
        [Parameter(ValueFromPipelineByPropertyName, Position=0)]
        [double[]] $x, 

        # A divisor.
        [Parameter(ValueFromPipelineByPropertyName, Position=1)]
        [double[]] $y
    )

    begin {
        $Method = $MyInvocation.MyCommand.Name
    }

    process {
        InvokeBinary $Method $x $y
    }
}


function Log {
    <#
    .Synopsis
      Returns the logarithm of a specified number in a specified base.
    .Description
      Returns the logarithm of a specified number in a specified base.
      Base defaults to Math.E
    .Example
      PS> Log 42
      3.73766961828337
    .Example
      PS> Log 42, 24
      3.73766961828337...
    .Example
      PS> Log 42, 24 -Base 3
      3.40217350273288...
    .Example
      PS> Log 42, 24 | Log -Base 3
      3.40217350273288... 
    .Outputs
      System.Double
    #>

    param (
        # The number whose logarithm is to be found.
        [Parameter(ValueFromPipeline)]
        [double[]] $d,

        # The base of the logarithm.
        # Default: Math.E 
        [Parameter()]
        [double] $Base = [Math]::E
    )

    process {
        $d.ForEach($InvokeMath2, $MyInvocation.MyCommand.Name, $Base)
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
    .Outputs
      System.Double
    .Notes
      Parameter d is specified as a base 10 number.
    #>

    param (
        # A number whose logarithm is to be found.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $d
    )

    process {
        $d.ForEach($InvokeMath, $MyInvocation.MyCommand.Name)
    }
}


function Max {
    <#
    .Synopsis
      Returns the larger of two specified numbers.
    .Description
      Returns the larger of two specified numbers.
      Can be any numerical type.
    .Example
      PS> Max 42 24
      42
    .Example
      PS> Max -Value1 42 -Value2 24
      42
    .Example
      PS> Max -Value1 42, 24 -Value2 24, 32
      42...

      Can use arrays when argument arrays are the same length.
    .Example
      PS> $Obj | Max 
      42...

      Where $Obj[0] is PSObject { Value1 = 42; Value2 = 24 }
    .Notes
    #>

    param (
        # The first number to compare.
        [Parameter(ValueFromPipelineByPropertyName, Position=0)]
        [object[]] $Value1,

        # The second number to compare.
        [Parameter(ValueFromPipelineByPropertyName, Position=1)]
        [object[]] $Value2 
    )

    begin { 
        $Method = $MyInvocation.MyCommand.Name
    }

    process {
        InvokeBinary $Method $Value1 $Value2
    }
}


function Min {
    <#
    .Synopsis
      Returns the smaller of two specified numbers.
    .Description
      Returns the smaller of two specified numbers.
      Can be any numerical type.
    .Example
      PS> Min 42 24
      24
    .Example
      PS> Min -Value1 42 -Value2 24
      24
    .Example
      PS> Min -Value1 42, 24 -Value2 24, 32
      24...

      Can use arrays when argument arrays are the same length.
    .Example
      PS> $Obj | Min 
      24...

      Where $Obj[0] is PSObject { Value1 = 42; Value2 = 24 }
    .Notes
    #>

    param (
        # The first number to compare.
        [Parameter(ValueFromPipelineByPropertyName, Position=0)]
        [object[]] $Value1,

        # The second number to compare.
        [Parameter(ValueFromPipelineByPropertyName, Position=1)]
        [object[]] $Value2 
    )

    begin { 
        $Method = $MyInvocation.MyCommand.Name
    }

    process {
        InvokeBinary $Method $Value1 $Value2
    }
}


function Pow {
    <#
    .Synopsis
      Returns a specified number raised to the specified power.
    .Description
      Returns a specified number raised to the specified power.
    .Example
      PS> Pow 42 2
      1764 
    .Example
      PS> Pow -Value1 42 -Value2 2
      1764
    .Example
      PS> Pow -Value1 42, 24 -Value2 2, 3
      1764...
    .Example
      PS> $Pow | Pow
      1764...

      When $Pow[0] is PSObject { Value1 = 42; Value2 = 2 }
    .Outputs
      System.Double

      The number x raised to the power y.
    #>

    param (
        # A double-precision floating-point number to be raised to a power.
        [Parameter(ValueFromPipelineByPropertyName, Position=0)]
        [double[]]
        $x,

        # A double-precision floating-point number that specifies a power.
        [Parameter(ValueFromPipelineByPropertyName, Position=1)]
        [double[]]
        $y
    )

    begin {
        $Method = $MyInvocation.MyCommand.Name
    }

    process {
        InvokeBinary $Method $x $y
    }
}


function Round {
    
}



<#
Round           Method     static double Round(double a), static double Round(double value, int digits), static double Round(double value, System.Midpoin...
Sign            Method     static int Sign(sbyte value), static int Sign(int16 value), static int Sign(int value), static int Sign(long value), static in...
Sin             Method     static double Sin(double a)                                                                                                      
Sinh            Method     static double Sinh(double value)                                                                                                 
Sqrt            Method     static double Sqrt(double d)                                                                                                     
Tan             Method     static double Tan(double a)                                                                                                      
Tanh            Method     static double Tanh(double value)                                                                                                 
Truncate        Method     static decimal Truncate(decimal d), static double Truncate(double d)                                                             
E               Property   static double E {get;}                                                                                                           
PI              Property   static double PI {get;}                                                                                                          


#>