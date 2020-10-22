# Changelog

<!-- markdownlint-disable no-duplicate-header -->

<endowdly@gmail.com>

## [1.3.0] - 2019-10-29

### Added

- src/EngineeringNumerics.cs: a source file for EngineeringNumerics.dll.
- lib/EningeeringNumerics.dll: a simple class of PSi.Converters.EngineeringNumeric that has properties displaying a number in engineering notation.
    This could/should have been a IFormatProvider for any number, but I'm abusing PowerShell's casting system to write a simple solution.
- PSi.Functional.ps1: a WIP for an upcoming release. Currently has the `Compress-Object` function which is functionally a fold.

### Changed

- PSi.Converters: added function `ConvertTo-EngineeringNotation` that takes a number and returns a string representing the number in readable E-notation.
    I did not add pure E-notation (3e6) as that is a format available to all strings (use `'e0'`).
    For future releases, I may add bake this into the function so the user won't have to.

## [1.2.1] - 2019-09-23

### Changed

- Cleanup
- Removed manifest files from source; staging modularity.

### Removed

- PSi.Complex.psd1
- PSi.Core.psd1

## [1.2.0] - 2019-08-26

### Added

- PSi.Converters: a module that adds common convertions.

## [1.1.0] - 2019-07-29

### Added

- PSi.Complex: derived directly from [ComplexNumbers](https://github.com/endowdly/ComplexNumbers).

## [1.0.0]

- Intial
