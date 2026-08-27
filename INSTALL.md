# Installing MDPE Skills

MDPE skills follow the Kiro skill format: each skill is a folder under `skills/`
containing a `SKILL.md` (YAML frontmatter + body) and an `assets/` folder with its
templates and schemas.

## Option A — Copy into your Kiro skills directory

Copy each skill folder into `~/.kiro/skills/`:

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

## Option B — Symlink (keeps the repo as source of truth)

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
