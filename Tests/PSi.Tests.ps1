#region Test Setup ------------------------------------------------------------------------------------------------

$ModuleRoot = Resolve-Path "$PSScriptRoot\.." 
$ModuleName = Split-Path $ModuleRoot -Leaf 
$ModulePath = Join-Path $ModuleRoot ($ModuleName + '.psd1')
$IsLoaded = $null -ne (Get-Module $ModuleName)

if (-not $IsLoaded) {
    Import-Module $ModulePath -Force 
}

#endregion

#region Common Tests ----------------------------------------------------------------------------------------------

Describe "General Module Validation for $ModuleName" { 
    $fileParseTests = 
        Get-ChildItem $ModuleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse | 
        ForEach-Object { 
            $parent = Split-Path $_ -Parent | Split-Path -Leaf 
            @{ 
                FilePath = $_.FullName 
                Name = Join-Path $parent $_.Name 
            } 
        } 

    It "Has valid File <name>" -TestCases $fileParseTests { 
        param ($filePath) 

        $filePath | Should Exist 
        
        $contents = Get-Content -Path $filePath -ErrorAction Stop 
        $errors = $null 

        [void] [System.Management.Automation.PSParser]::Tokenize($contents, [ref] $errors) 

        $errors.Count | Should Be 0 
    } 

    It "Can import cleanly" { 
        { Import-Module $ModuleRoot -Force -ErrorAction Stop } | Should Not Throw 
    } 
} 

Describe "Help Tests for $ModuleName" { 
    $commands = & { 
        # Import-Module Profile 
        Get-Command -Module $ModuleName 
    } 
    $help = $commands | ForEach-Object { Get-Help $_.Name } 

    foreach ($node in $help) { 

        Context $node.Name { 

            It "Has a Description" { 
                $node.Description | Should Not BeNullOrEmpty 
            } 

            It "Has an Example" { 
                $node.Examples | Should Not BeNullOrEmpty 
            }

            $parameterTests = 
                $node.Parameters.Parameter | 
                Where-Object Name -notin 'WhatIf', 'Confirm' | 
                ForEach-Object { 
                    @{ 
                        Name = $_.Name 
                        Description = $_.Description.Text 
                    } 
                } 

            if ($ParameterTests.Name -notin '', $null) { 

                It "Has described Parameter <name>" -TestCases $parameterTests { 
                    param ($description) 

                    $description | Should Not BeNullOrEmpty 
                } 
            } 
        } 
    } 
} 

#endregion
