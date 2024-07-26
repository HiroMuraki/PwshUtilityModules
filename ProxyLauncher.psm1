$PATHS = @(
    "C:/Windows",
    "C:/Windows/System32"
)

function Start-ProgramProxy {
    if ($args.Length -le 0) {
`
            Write-Error "Program name is required to proceed"
        return
    }

    $targetProgramName = $args[0]
    $targetProgramArgs = $args[1..($args.Length)]

    $validPaths = $PATHS | Get-Unique | Where-Object { Test-Path $_ -PathType Container } 
    foreach ($path in $validPaths) {
        $targetFile = (Get-ChildItem -File $path
            | Where-Object { $_.Name -ieq "$($targetProgramName).exe" }
            | Select-Object -First 1)?[0] ?? $null

        if ($null -ne $targetFile) {
            &$targetFile $targetProgramArgs
            return
        }
    }

    Write-Error "No programs match the name `"$targetProgramName`""
}

function Test-ProxyPaths {
    function TestInvalidPaths {
        $invalidPaths = @()

        foreach ($path in $PATHS) {
            if (-not (Test-Path $path -PathType Container)) {
                $invalidPaths += $path
            }
        }

        if ($invalidPaths.Length -gt 0) {
            Write-Warning "Detected $($invalidPaths.Length) invalid proxy path(s)"
            $invalidPaths | ForEach-Object { Write-Warning $_ }
        }
        else {
            Write-Host "All proxy paths are valid" -ForegroundColor Green
        }
    }
    function TestConflictingNames {
        $conflictingGroups = ($PATHS 
            | Where-Object { Test-Path $_ -PathType Container } 
            | Get-ChildItem -File  
            | Where-Object { $_.Extension -ieq ".exe" } 
            | Select-Object -Property Name, DirectoryName 
            | Group-Object -Property Name 
            | Where-Object { $_.Count -gt 1 })

        if ($conflictingGroups.Length -gt 0) {
            Write-Warning "Detected $($conflictingGroups.Length) conflicting program names"
            foreach ($group in $conflictingGroups) {
                Write-Warning "[$($group.Name)]"
                foreach ($item in $group.Group) {
                    Write-Warning "    $($item.DirectoryName)" 
                }
            }
        }
        else {
            Write-Host "No conflicting program names found" -ForegroundColor Green
        }
    }

    TestInvalidPaths
    TestConflictingNames
}

Set-Alias spp Start-ProgramProxy
Set-Alias tpp Test-ProxyPaths