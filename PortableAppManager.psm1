$APP_CONTAINERS = @(
    "S:/Software/Storage"
)

function Get-AppUpdateInfo {
    $appUpdateInfos = @()
    
    foreach ($appContainer in $APP_CONTAINERS) {
        $appInfosJsonFile = Join-Path $appContainer "AppInfos.json"
        if (-not (Test-Path $appInfosJsonFile)) {
            Write-Warning "App container $appContainer does not exist; unable to retrieve application information"
            continue
        }

        $appInfos = Get-Content ($appInfosJsonFile) | ConvertFrom-Json
        foreach ($appInfo in $appInfos) {
            $fileInfo = Get-Item (Join-Path $appContainer $appInfo.EntryName)
            $appUpdateInfos += [PSCustomObject]@{
                AppName     = $appInfo.AppName;
                FileVersion = $fileInfo.VersionInfo.FileVersion;
                UpdateDate  = $fileInfo.LastWriteTime;
                FullName    = $fileInfo.FullName
            }
        }
    }

    function GetUpdateTipColor {
        param(
            [datetime] $x
        )

        $outdateDays = ((Get-Date) - $x).Days
        if ($outdateDays -gt 90) {
            return $PSStyle.Foreground.FromRgb(255, 64, 64)
        }
        elseif ($outdateDays -gt 30) {
            return $PSStyle.Foreground.FromRgb(255, 255, 64)
        }
        else {
            return $PSStyle.Foreground.FromRgb(128, 255, 128)
        }
    }
    
    $appUpdateInfos | Format-Table @{
        Label      = "AppName";
        Expression = {
            $color = GetUpdateTipColor($_.UpdateDate)
            "$color$($_.AppName)$($PSStyle.Reset)"
        };
    },
    @{
        Label      = "FileVersion";
        Expression = {
            $color = GetUpdateTipColor($_.UpdateDate)
            "$color$($_.FileVersion)$($PSStyle.Reset)"
        };
    },
    @{
        Label      = "UpdateDate";
        Expression = {
            $color = GetUpdateTipColor($_.UpdateDate)
            "$color$($_.UpdateDate.ToString("yyyy/MM/dd"))$($PSStyle.Reset)"
        }
    },
    @{
        Label      = "FullPath";
        Expression = {
            "$($PSStyle.Dim)$($_.FullName)$($PSStyle.Reset)"
        }
    }
}

Set-Alias gaui Get-AppUpdateInfo