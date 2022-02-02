& {
    data Settings {
        @{
            SourceDir = 'src'
        }
    }

    Join-Path $PSScriptRoot $Settings.SourceDir |
        Get-ChildItem -Filter *.cs | 
        ForEach-Object {
            Add-Type -Path $_.FullName -ErrorAction Stop 
        }
}