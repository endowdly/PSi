

function Compress-Object {
    <#
    .Example
        PS> $Sum = { param($x, $y) $x + $y }
        PS> 1..10 | Compress-Object $Sum 
    .Example 
        PS> $Product = { param($a, $b) $a * $b }
        PS> Fold $Product (1..10) 
    #>

    [Alias('Fold')]

    param (
        [Parameter(Mandatory)]
        [ValidateScript({ $_.Ast.ParamBlock.Parameters.Count -eq 2 })]
        [scriptblock] $Expression,

        [Parameter(ValueFromPipeline)]
        [array] $InputObject,

        [switch] $Right 
    )

    $a = @($input)  # IList -> Array
    
    if ($a.Length -gt 0) {
        $InputObject = $a  # Collect all pipeline values
    }

    if ($Right) {
        [array]::Reverse($a)
    }

    $acc, $rest = $InputObject 

    if ($InputObject.Length -gt 1) {
        foreach ($o in $rest) {
            $acc = & $Expression $acc $o 
        }
    }

    $acc 
}