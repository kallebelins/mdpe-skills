#Requires -Version 5.1
<#
.SYNOPSIS
    Removes MDPE skills previously installed into one or more AI agent tools
    (Kiro, Cursor, Claude Code, VS Code Copilot) or any tool following the
    generic Agent Skills standard (agentskills.io).

.DESCRIPTION
    Deletes the matching skill folders (or symlinks) from each tool's skills
    directory, at User (global, default) or Project scope. Only removes
    folders whose name matches a known MDPE skill (from .\skills\ in this
    repo) or an explicit -Skill list, so it never touches unrelated skills a
    tool or another vendor may have installed alongside them.

    Target directories per tool/scope (see scripts\SkillTargets.ps1):
      Kiro    User: ~/.kiro/skills          Project: .kiro/skills
      Cursor  User: ~/.cursor/skills        Project: .cursor/skills
      Claude  User: ~/.claude/skills        Project: .claude/skills
      VSCode  User: ~/.copilot/skills       Project: .github/skills
      Agents  User: ~/.agents/skills        Project: .agents/skills

.PARAMETER Tool
    One or more of: Kiro, Cursor, Claude, VSCode, Agents, All. Default: All.

.PARAMETER Scope
    User (global, default), Project (this repo's checkout), or Both.

.PARAMETER Skill
    One or more skill names to remove. Default: all MDPE skills found under
    .\skills\ in this repo (so unrelated third-party skills are left alone).

.PARAMETER ProjectPath
    Root used for -Scope Project targets. Default: current directory.

.PARAMETER WhatIf
    Preview what would be removed without deleting anything (built-in
    ShouldProcess switch).

.PARAMETER ListOnly
    List resolved target paths and matching installed skills, then exit
    without removing anything.

.EXAMPLE
    .\Uninstall-Skills.ps1 -WhatIf
    Shows what would be removed from every tool's User-scope directory.

.EXAMPLE
    .\Uninstall-Skills.ps1 -Tool Kiro,Cursor
    Removes all MDPE skills from Kiro's and Cursor's User-scope directories.

.EXAMPLE
    .\Uninstall-Skills.ps1 -Tool Claude -Scope Project -Skill mdpe-router
    Removes only mdpe-router from .claude/skills in the current project.
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [ValidateSet('Kiro', 'Cursor', 'Claude', 'VSCode', 'Agents', 'All')]
    [string[]]$Tool = @('All'),

    [ValidateSet('User', 'Project', 'Both')]
    [string]$Scope = 'User',

    [string[]]$Skill,

    [string]$ProjectPath = (Get-Location).Path,

    [switch]$ListOnly
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'SkillTargets.ps1')

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsSrcRoot = Join-Path $repoRoot 'skills'

# Known MDPE skill names, used as the default removal scope so we never
# delete a third-party skill that happens to sit in the same directory.
$knownSkills = if (Test-Path $skillsSrcRoot) {
    Get-ChildItem -Path $skillsSrcRoot -Directory | Select-Object -ExpandProperty Name
} else {
    @()
}

$skillsToRemove = if ($Skill) { $Skill } elseif ($knownSkills) { $knownSkills } else {
    throw "No skill names given and could not discover MDPE skills under '$skillsSrcRoot'. Pass -Skill explicitly."
}

$targets = Get-SkillTargetRoots -Tool $Tool -Scope $Scope -ProjectPath $ProjectPath
$uniqueTargets = $targets | Sort-Object Path -Unique

Write-Host "MDPE Skills uninstaller" -ForegroundColor Cyan
Write-Host "  Skills : $($skillsToRemove.Count) selected ($($skillsToRemove -join ', '))"
Write-Host ""

$removedCount = 0
$notFoundCount = 0

foreach ($target in $uniqueTargets) {
    $destRoot = $target.Path
    Write-Host "[$($target.Tool)/$($target.Scope)] $destRoot" -ForegroundColor Yellow

    if (-not (Test-Path $destRoot)) {
        Write-Host "    (directory does not exist, nothing to remove)" -ForegroundColor DarkGray
        continue
    }

    foreach ($s in $skillsToRemove) {
        $dest = Join-Path $destRoot $s

        if (-not (Test-Path $dest)) {
            $notFoundCount++
            continue
        }

        if ($ListOnly) {
            Write-Host "    would remove: $s"
            continue
        }

        if ($PSCmdlet.ShouldProcess($dest, "Remove skill '$s'")) {
            Remove-Item -LiteralPath $dest -Recurse -Force
            Write-Host "    removed: $s" -ForegroundColor Green
            $removedCount++
        }
    }
}

if ($ListOnly) {
    return
}

Write-Host ""
Write-Host "Done. Removed: $removedCount. Not found (already absent): $notFoundCount." -ForegroundColor Cyan
