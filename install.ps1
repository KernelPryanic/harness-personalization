param(
    [ValidateSet("claude", "opencode", "all")]
    [string]$Target = "all"
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

function Install-Claude {
    foreach ($s in $skills) {
        Assert-Junction -Path "$env:USERPROFILE\.claude\skills\$s" -TargetPath "$repo\skills\$s"
    }

    $claudemd = "$env:USERPROFILE\.claude\CLAUDE.md"
    $import = "@$repo\skills\concise\SKILL.md"
    $rule = 'In every repo, read its `AGENTS.md` (when present) and follow it.'
    $header = "# Standing skill directives"

    if (Test-Path -LiteralPath $claudemd) {
        $lines = @(Get-Content -LiteralPath $claudemd)
        if ($lines -contains $import) {
            Write-Host "ok      $claudemd"
            return
        }
        $oldIndex = [array]::FindIndex($lines, { param($l) $l -match '^@\S*concise' })
        if ($oldIndex -ge 0) {
            $lines[$oldIndex] = $import
            if ($lines -notcontains $rule) { $lines += @("", $rule) }
            Set-Content -LiteralPath $claudemd -Value $lines
            Write-Host "updated $claudemd"
            return
        }
        Add-Content -LiteralPath $claudemd -Value @("", $header, "", $import, "", $rule, "")
        Write-Host "updated $claudemd"
        return
    }

    Set-Content -LiteralPath $claudemd -Value @($header, "", $import, "", $rule, "")
    Write-Host "wrote   $claudemd"
}

function Install-Opencode {
    $ocDir = "$env:USERPROFILE\.config\opencode"
    if (-not (Test-Path -LiteralPath $ocDir)) {
        New-Item -ItemType Directory -Path $ocDir | Out-Null
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

if ($Target -in "claude", "all") { Install-Claude }
if ($Target -in "opencode", "all") { Install-Opencode }
