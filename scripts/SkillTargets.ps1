<#
.SYNOPSIS
    Shared helper: resolves the on-disk skills directory for each supported
    tool (Kiro, Cursor, Claude Code, VS Code Copilot) and the generic
    Agent Skills standard location, at User (global) or Project scope.

.DESCRIPTION
    Dot-sourced by Install-Skills.ps1 and Uninstall-Skills.ps1. Not meant to
    be run directly.

    Source locations per tool (see docs cited in each skill's comments):
      - Kiro    : ~/.kiro/skills        (User)   .kiro/skills        (Project)
      - Cursor  : ~/.cursor/skills      (User)   .cursor/skills      (Project)
                  (Cursor also reads .claude/skills and .agents/skills for
                  compatibility, which this script covers via the Claude and
                  Agents targets.)
      - Claude  : ~/.claude/skills      (User)   .claude/skills      (Project)
      - VSCode  : ~/.copilot/skills     (User)   .github/skills      (Project)
                  (VS Code Copilot also reads .claude/skills and .agents/skills
                  project-side, covered via the Claude and Agents targets.)
      - Agents  : ~/.agents/skills      (User)   .agents/skills      (Project)
                  Generic open Agent Skills standard (agentskills.io) location,
                  used as a fallback by any other tool that follows the spec.
#>

function Get-SkillTargetRoots {
    [CmdletBinding()]
    param(
        [ValidateSet('Kiro', 'Cursor', 'Claude', 'VSCode', 'Agents', 'All')]
        [string[]]$Tool = @('All'),

        [ValidateSet('User', 'Project', 'Both')]
        [string]$Scope = 'User',

        [string]$ProjectPath = (Get-Location).Path
    )

    $toolMap = [ordered]@{
        Kiro   = @{ User = (Join-Path $HOME '.kiro\skills');    Project = (Join-Path $ProjectPath '.kiro\skills') }
        Cursor = @{ User = (Join-Path $HOME '.cursor\skills');  Project = (Join-Path $ProjectPath '.cursor\skills') }
        Claude = @{ User = (Join-Path $HOME '.claude\skills');  Project = (Join-Path $ProjectPath '.claude\skills') }
        VSCode = @{ User = (Join-Path $HOME '.copilot\skills'); Project = (Join-Path $ProjectPath '.github\skills') }
        Agents = @{ User = (Join-Path $HOME '.agents\skills');  Project = (Join-Path $ProjectPath '.agents\skills') }
    }

    $selectedTools = if ($Tool -contains 'All') { $toolMap.Keys } else { $Tool }
    $selectedScopes = if ($Scope -eq 'Both') { @('User', 'Project') } else { @($Scope) }

    foreach ($t in $selectedTools) {
        foreach ($s in $selectedScopes) {
            [PSCustomObject]@{
                Tool  = $t
                Scope = $s
                Path  = $toolMap[$t][$s]
            }
        }
    }
}
