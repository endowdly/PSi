

function ConvertTo-Radians {
    [CmdletBinding()]
    [Alias('deg2rad')]

    param (
        # The degrees to convert to radians.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $InputObject
    )

    begin {
        $ToRads = {
            ($_ * [Math]::PI) / 180
        } 
    }

    process {
        $InputObject.ForEach($ToRads)
    }
}


function ConvertTo-Degrees {
    [CmdletBinding()]
    [Alias('rad2deg')]

    param (
        # The radians to convert to degrees.
        [Parameter(ValueFromPipeline, ValueFromRemainingArguments)]
        [double[]] $InputObject
    )

    begin {
        $ToDeg = {
            ($_ * 180) / [Math]::PI
        } 
    }

    process {
        $InputObject.ForEach($ToDeg)
    }
}


# Todo: Add validated SI and US Standard Unit List
function ConvertTo-EngineeringString {    
    [CmdletBinding()]

    param (
        # The numeric value to convert.
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [double[]] $Value,

        # The unit descriptor. This is not checked against a valid list of units; can be any string.
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $Unit
    )

    begin {
        $toEngNot = {
            $object = [Psi.EngineeringNumeric]::new($_) 
            $object.ToString() + $Unit
        }
    }

    process {
        $Value.ForEach($toEngNot)
    }
}


function ConvertFrom-CurrencyString {
    [CmdletBinding()]

    param(
        # The string to convert
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ValueFromRemainingArguments)]
        [string[]] $InputObject
    )

    begin {
        $f = { 
            $n = 0.0

            if ([double]::TryParse(
                $_,
                [System.Globalization.NumberStyles]::Currency,
                [cultureinfo]::CurrentCulture,
                [ref] $n)) {
                $n
            }
            else {
                0.0
            }
        }
    }

    process { $InputObject.ForEach($f) } 
}

