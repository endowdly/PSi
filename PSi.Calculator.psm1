# Time to execute 10e3 iterations: 5.65 min.
# function Get-Gcd ($x, $y) {
#     if ($y -eq 0) {
#         $x
#     } 
#     else {
#         Gcd $y ($x % $y)
#     }
# }


# Time to execute 10e3 iterations: 1.922 min.
function Get-Gcd ($x, $y) {
    while ($y -ne 0) {
        $x, $y = $y, ($x % $y)
    }
    [Math]::Abs($x) 
}


function Get-Lcm ($x, $y) {
    [Math]::Abs($x * $y) / (Gcd $x $y)
}

