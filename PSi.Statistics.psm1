
# This works well, but use managed code for speed on big arrays
# function Get-Median ($Min, $Max) {
#     if ($null -ne $Max -and $null -ne $Min) {
#         $d = $Max - $Min

#         [Math]::Floor($d / 2) + $min
#     }
#     else {
    
#         $a = @($input)
#         # return ($input)
#         $a |
#             Sort-Object | 
#             Set-Variable Sort 

#         $n = $Sort.Count / 2
#         $m = $n - 1

#         $Sort[$n], $Sort[$m] | 
#             Measure-Object -Average |
#             Select-Object -ExpandProperty Average
#     }
# }

function Get-Median {
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [double[]] $InputObject
    )

    end {
        [Psi.Statistics]::Median($InputObject)
    }
}


function Get-MedianInRange ($Min = 0, $Max) {
    if ($Max -eq 0 -or $Min -eq $Max) {
        return $null
    }

    $d = $Max - $Min

    ($d / 2) + $Min
}
