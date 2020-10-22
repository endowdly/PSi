# PSi

Math in PowerShell!

``` plaintext
PSTOPIC
    about_PSi

SHORT DESCRIPTION
    PSi allows you to easily use Math and Science functions in PowerShell.

LONG DESCRIPTION
    PSi allows you to easily use Math and Science function in PowerShell.
    The core module of PSi allows simple use of System.Math methods.
    Other modules are added that extend core functionality.

    Current Modules:

        Module          Libary                      Help Topic
        ------          ------                      ----------
        Core            System.Math                 about_PSi
        Complex         System.Numerics.Complex     about_Complex
        Converters      PSi.Converters
        Calculator*     None
        Functional*     None

    You can find System.Math documentation here:
    https://docs.microsoft.com/en-us/dotnet/api/system.math

    * WIP

DETAILED DESCRIPTION

    Psi.Core covers all main methods in System.Math and exports the constants Math.PI and Math.E as variables.

    To Use The Core Module
        Every command is designed for ease of use.

        Two general rules apply:

            1. The command is a Unary Operation:
                These command accepts arguments as arrays, curried, or singular entries.

                Example:
                Abs -42
                Abs -42 -99
                Abs -42, -99
                -42, -99 | Abs

                ...are all valid.

                If a command is given an array, it will return an array.

                Some commands, like Log, accept static arguments.
                Static arguments will be applied to every input item.

            2. The command is a Binary Operation:
                The command normally accepts positionaly or parameter arguments ONLY.
                But, all parameter can be sent via pipeline by name, so multiple arguments can be sent.

    Each function will have more detailed information when polled by help.

    See `help about_<Module>` for other modules' info in PSi.
```
