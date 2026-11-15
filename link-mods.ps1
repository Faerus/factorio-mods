$source = "D:\Projects\factorio-mods"
$destination = "$env:APPDATA\Factorio\mods"

Get-ChildItem -Path $source -Directory | ForEach-Object {

    $modPath = $_.FullName
    $linkPath = Join-Path $destination $_.Name

    if (Test-Path "$modPath\info.json") {

        if (-not (Test-Path $linkPath)) {

            New-Item -ItemType Junction `
                -Path $linkPath `
                -Target $modPath

            Write-Host "Link created : $($_.Name)"
        }
        else {
            Write-Host "Link already present : $($_.Name)"
        }
    }
}