# Installing MDPE Skills

MDPE skills follow the open [Agent Skills standard](https://agentskills.io): each
skill is a folder under `skills/` containing a `SKILL.md` (YAML frontmatter + body)
and an `assets/` folder with its templates and schemas. That standard is shared by
Kiro, Cursor, Claude Code, and VS Code (GitHub Copilot), so the same skill folders
work unmodified across all of them — only the destination directory differs.

## Option A — PowerShell scripts (recommended, cross-tool)

`scripts/Install-Skills.ps1` and `scripts/Uninstall-Skills.ps1` handle every
supported tool and scope in one command. Run from the repo root (Windows
PowerShell 5.1+ or PowerShell 7+):

```powershell
# Install every skill for every tool, at User (global) scope — the default
.\scripts\Install-Skills.ps1

# Preview only, no changes
.\scripts\Install-Skills.ps1 -ListOnly

# Install for specific tools only
.\scripts\Install-Skills.ps1 -Tool Kiro,Cursor

# Install into this project's checkout instead of the global user directory
.\scripts\Install-Skills.ps1 -Scope Project

# Symlink instead of copy, so the repo stays the single source of truth
# (Windows: needs Developer Mode enabled, or an elevated PowerShell session)
.\scripts\Install-Skills.ps1 -Mode Symlink

# Install only selected skills
.\scripts\Install-Skills.ps1 -Skill mdpe-router,mdpe-tasks

# Overwrite existing installs
.\scripts\Install-Skills.ps1 -Force
```

```powershell
# Uninstall everything this repo installed, from every tool, User scope
.\scripts\Uninstall-Skills.ps1

# Preview only
.\scripts\Uninstall-Skills.ps1 -ListOnly

# Uninstall from specific tools/scope/skills
.\scripts\Uninstall-Skills.ps1 -Tool Claude -Scope Project -Skill mdpe-router
```

Supported `-Tool` values and where they read skills from:

| Tool | User (global) scope | Project scope |
|------|----------------------|----------------|
| `Kiro` | `~/.kiro/skills` | `.kiro/skills` |
| `Cursor` | `~/.cursor/skills` | `.cursor/skills` |
| `Claude` | `~/.claude/skills` | `.claude/skills` |
| `VSCode` | `~/.copilot/skills` | `.github/skills` |
| `Agents` (generic Agent Skills standard, any compliant tool) | `~/.agents/skills` | `.agents/skills` |

Cursor and VS Code Copilot also read the Claude/Agents locations for
compatibility, so `-Tool All` (the default) never writes the same files twice.
Uninstalling only removes folders matching a known MDPE skill name (or your
explicit `-Skill` list), so unrelated skills from other sources are left alone.

Run `Get-Help .\scripts\Install-Skills.ps1 -Full` (or `-Uninstall-Skills.ps1`) for
the complete parameter reference.

## Option B — Copy manually (Kiro example, macOS/Linux, or no PowerShell)

Copy each skill folder into the target tool's skills directory — e.g. Kiro's
`~/.kiro/skills/` (swap the path for `~/.cursor/skills`, `~/.claude/skills`,
`~/.copilot/skills`, or `~/.agents/skills` for the other tools):

**PowerShell (Windows):**
```powershell
$src = "c:\Dev\Github\mdpe\mdpe-skills\skills"
$dst = "$HOME\.kiro\skills"
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item "$src\*" $dst -Recurse -Force
```

**bash (macOS/Linux):**
```bash
mkdir -p "$HOME/.kiro/skills"
cp -R ./skills/* "$HOME/.kiro/skills/"
```

## Option C — Symlink manually (keeps the repo as source of truth)

**PowerShell (admin):**
```powershell
Get-ChildItem "c:\Dev\Github\mdpe\mdpe-skills\skills" -Directory | ForEach-Object {
  New-Item -ItemType SymbolicLink -Path "$HOME\.kiro\skills\$($_.Name)" -Target $_.FullName
}
```

**bash:**
```bash
for d in ./skills/*/; do
  ln -s "$(pwd)/$d" "$HOME/.kiro/skills/$(basename "$d")"
done
```

## Verify

- Confirm each skill folder has a `SKILL.md` with valid YAML frontmatter (`name`, `description`).
- Ask the agent to activate `mdpe-router` and route a sample request (e.g., "I'm starting a new project").
- Optionally validate copied assets against their schemas with a JSON-Schema validator (e.g., `ajv`).

## Notes

- The `description` field drives when a skill activates, so keep the "Use when / not for" phrasing intact.
- Templates/schemas live inside each skill's `assets/` folder so skills are self-contained and usable offline.
