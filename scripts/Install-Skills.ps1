#Requires -Version 5.1
<#
.SYNOPSIS
    Installs MDPE skills into one or more AI agent tools (Kiro, Cursor, Claude
    Code, VS Code Copilot) or any tool following the generic Agent Skills
    standard (agentskills.io).

.DESCRIPTION
    Each skill under .\skills\<name>\ is a self-contained folder with a
    SKILL.md (YAML frontmatter + body) and an assets\ folder. This script
    copies (default) or symlinks those folders into the skills directory each
    tool reads from, at User (global, default) or Project scope.

    Target directories per tool/scope (see scripts\SkillTargets.ps1):
      Kiro    User: ~/.kiro/skills          Project: .kiro/skills
      Cursor  User: ~/.cursor/skills        Project: .cursor/skills
      Claude  User: ~/.claude/skills        Project: .claude/skills
      VSCode  User: ~/.copilot/skills       Project: .github/skills
      Agents  User: ~/.agents/skills        Project: .agents/skills

    Cursor and VS Code Copilot also read the Claude (.claude/skills) and
    generic Agents (.agents/skills) locations for compatibility, so installing
    to -Tool Claude or -Tool Agents already covers them without duplication.
    Use -Tool All (default) to install everywhere in one pass; duplicate
    physical paths are only written once.

.PARAMETER Tool
    One or more of: Kiro, Cursor, Claude, VSCode, Agents, All. Default: All.

.PARAMETER Scope
    User (global, default), Project (this repo's checkout), or Both.

.PARAMETER Skill
    One or more skill names to install (folder names under .\skills\).
    Default: all skills in the repo.

.PARAMETER Mode
    Copy (default) duplicates the skill folders. Symlink creates a symbolic
    link per skill pointing back at this repo, so the repo stays the single
    source of truth (edits show up everywhere without re-running install).
    Symlink on Windows needs Developer Mode enabled, or an elevated
    (Run as Administrator) PowerShell session.

.PARAMETER ProjectPath
    Root used for -Scope Project targets. Default: current directory.

.PARAMETER Force
    Overwrite existing destination folders/links without prompting.

.PARAMETER ListOnly
    List available skills and resolved target paths, then exit without
    writing anything.

.EXAMPLE
    .\Install-Skills.ps1
    Copies every skill into every tool's User-scope skills directory.

.EXAMPLE
    .\Install-Skills.ps1 -Tool Kiro,Cursor -Mode Symlink
    Symlinks every skill into Kiro's and Cursor's User-scope directories.

.EXAMPLE
    .\Install-Skills.ps1 -Tool Claude -Scope Project -Skill mdpe-router,mdpe-tasks
    Copies only two skills into .claude/skills in the current project.

.EXAMPLE
    .\Install-Skills.ps1 -ListOnly
    Shows what would be installed and where, without changing anything.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [ValidateSet('Kiro', 'Cursor', 'Claude', 'VSCode', 'Agents', 'All')]
    [string[]]$Tool = @('All'),

    [ValidateSet('User', 'Project', 'Both')]
    [string]$Scope = 'User',

    [string[]]$Skill,

    [ValidateSet('Copy', 'Symlink')]
    [string]$Mode = 'Copy',

    [string]$ProjectPath = (Get-Location).Path,

    [switch]$Force,

    [switch]$ListOnly
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'SkillTargets.ps1')

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsSrcRoot = Join-Path $repoRoot 'skills'

if (-not (Test-Path $skillsSrcRoot)) {
    throw "Could not find the skills source folder at '$skillsSrcRoot'. Run this script from inside the mdpe-skills repo."
}

# Discover installable skills (must contain SKILL.md).
$availableSkills = Get-ChildItem -Path $skillsSrcRoot -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } |
    Select-Object -ExpandProperty Name | Sort-Object

if (-not $availableSkills) {
    throw "No skill folders with a SKILL.md were found under '$skillsSrcRoot'."
}

$skillsToInstall = if ($Skill) {
    foreach ($s in $Skill) {
        if ($s -notin $availableSkills) {
            Write-Warning "Skill '$s' not found under skills\. Skipping. Available: $($availableSkills -join ', ')"
        }
    }
    $Skill | Where-Object { $_ -in $availableSkills }
} else {
    $availableSkills
}

if (-not $skillsToInstall) {
    throw "No matching skills to install."
}

$targets = Get-SkillTargetRoots -Tool $Tool -Scope $Scope -ProjectPath $ProjectPath

# De-duplicate physical destination roots (e.g. -Tool All at Project scope may
# point Cursor/VSCode-compat paths at the same .claude or .agents folder as
# the Claude/Agents targets).
$uniqueTargets = $targets | Sort-Object Path -Unique

Write-Host "MDPE Skills installer" -ForegroundColor Cyan
Write-Host "  Source : $skillsSrcRoot"
Write-Host "  Mode   : $Mode"
Write-Host "  Skills : $($skillsToInstall.Count) selected ($($skillsToInstall -join ', '))"
Write-Host ""

if ($Mode -eq 'Symlink') {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warning "Symlink mode may fail without Administrator privileges or Windows Developer Mode enabled. If links fail to create, either enable Developer Mode (Settings > Privacy & Security > For developers) or re-run this script as Administrator."
    }
}

$installedCount = 0
$skippedCount = 0

foreach ($target in $uniqueTargets) {
    $destRoot = $target.Path
    Write-Host "[$($target.Tool)/$($target.Scope)] $destRoot" -ForegroundColor Yellow

    if ($ListOnly) {
        foreach ($s in $skillsToInstall) {
            Write-Host "    would install: $s"
        }
        continue
    }

    if (-not (Test-Path $destRoot)) {
        if ($PSCmdlet.ShouldProcess($destRoot, "Create skills directory")) {
            New-Item -ItemType Directory -Force -Path $destRoot | Out-Null
        }
    }

    foreach ($s in $skillsToInstall) {
        $src = Join-Path $skillsSrcRoot $s
        $dest = Join-Path $destRoot $s

        $exists = Test-Path $dest
        if ($exists -and -not $Force) {
            Write-Host "    skip (exists, use -Force to overwrite): $s" -ForegroundColor DarkGray
            $skippedCount++
            continue
        }

        if (-not $PSCmdlet.ShouldProcess($dest, "Install skill '$s' ($Mode)")) {
            continue
        }

        if ($exists) {
            Remove-Item -LiteralPath $dest -Recurse -Force
        }

        if ($Mode -eq 'Copy') {
            Copy-Item -LiteralPath $src -Destination $dest -Recurse -Force
            Write-Host "    copied: $s" -ForegroundColor Green
            $installedCount++
        } else {
            try {
                New-Item -ItemType SymbolicLink -Path $dest -Target $src -ErrorAction Stop | Out-Null
                Write-Host "    linked: $s -> $src" -ForegroundColor Green
                $installedCount++
            } catch {
                Write-Warning "    failed to symlink '$s': $($_.Exception.Message)"
                $skippedCount++
            }
        }
    }
}

if ($ListOnly) {
    Write-Host ""
    Write-Host "Available skills in repo: $($availableSkills -join ', ')"
    return
}

Write-Host ""
Write-Host "Done. Installed/updated: $installedCount, skipped: $skippedCount." -ForegroundColor Cyan
