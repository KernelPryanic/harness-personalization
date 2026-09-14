param(
    [ValidateSet("install", "remove")]
    [string]$Target = "install"
)

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$skills = @("concise", "peers", "grimoire-note-taking")

function Assert-Junction {
    param([string]$Path, [string]$TargetPath)
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent | Out-Null
    }
    if (Test-Path -LiteralPath $Path) {
        $item = Get-Item -LiteralPath $Path -Force
        if ($item.LinkType -eq "Junction") {
            if ("$($item.Target)" -eq $TargetPath) {
                Write-Host "ok      $Path"
                return
            }
            throw "$Path is a junction to '$($item.Target)', expected '$TargetPath'"
        }
        throw "$Path exists and is not a junction; move it aside and re-run"
    }
    New-Item -ItemType Junction -Path $Path -Target $TargetPath | Out-Null
    Write-Host "linked  $Path -> $TargetPath"
}

function Remove-Junction {
    param([string]$Path, [string]$TargetPath)
    if (Test-Path -LiteralPath $Path) {
        $item = Get-Item -LiteralPath $Path -Force
        if ($item.LinkType -ne "Junction") {
            throw "$Path exists and is not a junction; remove it manually"
        }
        if ("$($item.Target)" -ne $TargetPath) {
            throw "$Path is a junction to '$($item.Target)', not this repo; remove it manually"
        }
        [System.IO.Directory]::Delete($Path)
        Write-Host "removed $Path"
        return
    }
    Write-Host "absent  $Path"
}

function Install-Opencode {
    $ocDir = "$env:USERPROFILE\.config\opencode"
    if (-not (Test-Path -LiteralPath $ocDir)) {
        New-Item -ItemType Directory -Path $ocDir | Out-Null
    }

    foreach ($s in $skills) {
        Assert-Junction -Path "$ocDir\skills\$s" -TargetPath "$repo\skills\$s"
    }

    $cmdDir = "$ocDir\command"
    $src = "$repo\command"
    if (Test-Path -LiteralPath $cmdDir) {
        $item = Get-Item -LiteralPath $cmdDir -Force
        if ($item.LinkType -eq "Junction") {
            if ("$($item.Target)" -eq $src) {
                Write-Host "ok      $cmdDir"
                return
            }
            throw "$cmdDir is a junction to '$($item.Target)', expected '$src'"
        }
        $others = @(Get-ChildItem -LiteralPath $cmdDir | Where-Object { $_.Name -ne "start.md" })
        if ($others.Count -gt 0) {
            Copy-Item -LiteralPath "$src\start.md" -Destination $cmdDir -Force
            Write-Host "copied  start.md into $cmdDir (dir holds other commands; not junctioned)"
            return
        }
        Remove-Item -LiteralPath $cmdDir -Recurse
    }
    New-Item -ItemType Junction -Path $cmdDir -Target $src | Out-Null
    Write-Host "linked  $cmdDir -> $src"
}

function Remove-Opencode {
    $ocDir = "$env:USERPROFILE\.config\opencode"

    foreach ($s in $skills) {
        Remove-Junction -Path "$ocDir\skills\$s" -TargetPath "$repo\skills\$s"
    }

    $cmdDir = "$ocDir\command"
    if (Test-Path -LiteralPath $cmdDir) {
        $item = Get-Item -LiteralPath $cmdDir -Force
        if ($item.LinkType -eq "Junction") {
            Remove-Junction -Path $cmdDir -TargetPath "$repo\command"
        } else {
            if (Test-Path -LiteralPath "$cmdDir\start.md") {
                Remove-Item -LiteralPath "$cmdDir\start.md" | Out-Null
                Write-Host "removed $cmdDir\start.md"
            } else {
                Write-Host "absent  $cmdDir\start.md"
            }
            $others = @(Get-ChildItem -LiteralPath $cmdDir | Where-Object { $_.Name -ne "start.md" })
            if ($others.Count -eq 0) {
                [System.IO.Directory]::Delete($cmdDir)
            }
        }
    } else {
        Write-Host "absent  $cmdDir"
    }
}

if ($Target -eq "install") { Install-Opencode }
if ($Target -eq "remove") { Remove-Opencode }
