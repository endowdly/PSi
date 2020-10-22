# We need to do the following because Reflection.Assembly is deprectiated :(
# But, it is used as a final back up

# Only needed for PowerShell younger than v5.0
if ($PSVersionTable.PSVersion.Major -ge 5) {
    return
}

$Success = 'ComplexNumbers -> System.Numerics Assembly loaded!'
$Failure = 'ComplexNumbers -> System.Numerics Assembly load failed!' 
$NumericsAssembly = @{
    AssemblyName = 'System.Numerics'
    ErrorAction = 'Stop'
    PassThru = $true 
}
$FromAssemblyDirectory = @{
    Path = 'C:\Windows\Microsoft.Net\assembly'
    Include = 'System.Numerics.dll'
    Recurse = $true
    Force = $true
}
$TryToAddType = {
    try {
        $script:ObjAssem = Add-Type -Path $_ -PassThru -ErrorAction SilentlyContinue
        Write-Verbose $Success
    }
    catch {
        continue
    } 
}

# --- Xeq 
try { 
    $ObjAssem = Add-Type @NumericsAssembly
    Write-Verbose $Success
} 
catch { 
    # FIND IT BRUCE BANNER STYLE! This may take a second. 
    Get-ChildItem @FromAssemblyDirectory | Foreach-Object $TryToAddType
}
finally { 

    if ($ObjAssem) {
        Write-Verbose $Success
    }
    else {
        
        # Last Resort
        [void] [Reflection.Assembly]::LoadWithPartialName('System.Numerics')
        
        if ($?) {
            Write-Verbose $Success
        }
        else {
            Write-Verbose $Failure
        }
    }
}
# EOF