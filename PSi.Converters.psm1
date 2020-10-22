

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


function ConvertTo-EngineeringNotation {    
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
            $object = [PSi.Converters.EngineeringNumeric]::new($_) 
            $object.ToString() + $Unit
        }
    }

    process {
        $Value.ForEach($toEngNot)
    }
}

