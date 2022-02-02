# Time to execute 10e3 iterations: 5.65 min.
# function Get-Gcd ($x, $y) {
#     if ($y -eq 0) {
#         $x
#     } 
#     else {
#         Gcd $y ($x % $y)
#     }
# }


# Time to execute 10e3 iteration: 1.922 min.
function Get-Gcd ($x, $y) {
    [Psi.Mathematics]::Gcd($x, $y)
}


function Get-Lcm ($x, $y) {
    [Psi.Mathematics]::Lcm($x, $y)
}
