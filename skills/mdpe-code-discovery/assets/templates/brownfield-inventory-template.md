<!--
====================================================================
MDPE Framework - Brownfield Inventory - Template
====================================================================
Version: 1.0.0
Purpose: Fill-in skeleton for the mdpe-code-discovery skill.
         One single artifact describing an EXISTING repository:
         stack, structure, conventions, and the features the code
         already implements.
Decision of record: docs/adr/adr-001-brownfield-discovery.md

How to use:
  1. Copy this file to docs/brownfield/inventory.md
     (or docs/brownfield/inventory-{scope}.md when scoping a module)
  2. Fill the header, then sections 1-4 (essential)
  3. Sections 5-7 are CONDITIONAL: keep one only if there is real
     evidence for it. DELETE the ones you have no evidence for -
     an empty section is worse than a missing one.
  4. Remove these instruction comments when done

Hard rules (see SKILL.md "Anti-fabrication rules"):
  - Verify every path before writing it. Unverified path -> leave it out.
  - No "TBD" and no placeholders. No data -> "unknown", or drop the field.
  - Low confidence beats invention.
  - No code in scope -> do not create this file at all; answer
    "no code to discover" and route to mdpe-discovery.
  - Code beats documentation; current evidence beats an old inventory.
  - Describe what exists. No effort, priority, or business value here.
====================================================================
-->

# Brownfield inventory — {repo or scope name}

- **repo:** {absolute path or remote URL}
- **scope:** {subfolder / module / service, or `root`}
- **verified_at:** {YYYY-MM-DD} · {branch @ short-commit, or `no git`}
- **depth:** {S | M | L} ({N} code files in scope)

<!--
Depth (auto-sizing, from the scope size - never a fixed target):
  S = up to ~50 code files   -> sections 1-4
  M = ~50-300                -> sections 1-4 + applicable conditional ones
  L = >300 or monorepo       -> sections 1-4 limited to the declared scope
There is no minimum number of features. 3 features observed = 3 rows.
-->

---

## 1. Stack & runtime

<!-- Essential. Only what a real manifest states. Cite the manifest as evidence. -->

| Item | Value | Evidence |
|---|---|---|
| Language(s) | {e.g. C# 12} | `{path/to/manifest}` |
| Framework(s) | {e.g. ASP.NET Core 8} | `{path/to/manifest}` |
| Package manager | {e.g. NuGet / npm / uv} | `{path/to/lockfile}` |
| Runtime / target | {e.g. net8.0} | `{path/to/manifest}` |
| Data store | {e.g. PostgreSQL via EF Core} | `{path/to/file}` |
| Build command | {command, or `unknown` + reason} | `{path/to/manifest or CI file}` |
| Test command | {command, or `unknown` + reason} | `{path/to/manifest or CI file}` |

<!-- Add or drop rows freely. A row with no evidence must read `unknown` plus the reason. -->

---

## 2. Structure & modules

<!-- Essential. The tree AS OBSERVED, limited to the declared scope. -->

```
{relevant directory tree - only the parts that matter, not the full listing}
```

**Observed layers / modules**

| Module or layer | Path | Responsibility as observed | Evidence |
|---|---|---|---|
| {name} | `{path}` | {what the code in it actually does} | {imports/namespaces/entry points} |

<!--
Record the layers the imports and namespaces actually show. If a boundary is
unclear, say "boundary unclear" instead of naming a layer the code does not
exhibit.
-->

---

## 3. Observed conventions

<!-- Essential. At least ONE convention with evidence is required by the gate. -->

| Convention | Observed rule | Evidence |
|---|---|---|
| Naming | {e.g. PascalCase for types, suffix `Service` for app services} | `{path/to/sample}` |
| File organization | {e.g. one type per file, folder per aggregate} | `{path/to/sample}` |
| Tests | {e.g. xUnit, `*Tests.cs` next to a mirrored folder tree} | `{path/to/sample}` |
| Error handling | {e.g. exceptions mapped in a middleware} | `{path/to/file}` |
| Lint / format | {e.g. ESLint + Prettier, `.editorconfig`} | `{path/to/config}` |

---

## 4. Reconstructed features

<!--
Essential. One row per feature the code ALREADY implements.
Sources of candidates: routes/endpoints, handlers/controllers, use
cases/services, screens/views, scheduled jobs and consumers, data entities.

  id          cf-NNN, sequential and stable. Promoted to the backlog it
              becomes feat-NNN, and that feat records `origin: cf-NNN`.
  name        taken from the language of the code itself. Not invented.
  description one line, PRESENT TENSE: what the system does today.
  files       >=1 real verified path. BLOCKING: no path -> do not emit
              the feature.
  confidence  high   = entry point + test + data model
              medium = clear code, no test
              low    = inferred from name/structure, unconfirmed
  gaps        optional. What could not be determined -> `unknown`.
              Never fill by deduction.
-->

| id | name | description (today) | files | confidence | gaps |
|---|---|---|---|:---:|---|
| cf-001 | {name} | {what it does today} | `{path}`, `{path}` | {high\|medium\|low} | {unknown / —} |
| cf-002 | {name} | {what it does today} | `{path}` | {high\|medium\|low} | — |

<!--
Long `files` lists? Use one block per feature instead of the table, keeping
the same fields:

### cf-001 — {name}
- **description (today):** {one line}
- **files:**
  - `{path}`
  - `{path}`
- **confidence:** {high | medium | low}
- **gaps:** {unknown / -}
-->

---

<!--
====================================================================
SECTIONS 5-7 ARE CONDITIONAL.
Keep a section only if you have real evidence for it. Otherwise DELETE
the whole section - absence of evidence is a valid result and does not
fail the quality gate.
====================================================================
-->

## 5. External integrations

<!-- Only when there is an HTTP client, SDK, queue, broker, or service credential in the code. -->

| Integration | Type | Direction | Evidence |
|---|---|---|---|
| {service name} | {HTTP API \| SDK \| queue \| broker \| file/storage} | {outbound \| inbound} | `{path/to/client}` |

---

## 6. Test strategy

<!--
Only when there ARE tests. If there are none, DELETE this section and record
"no tests detected" under section 7 instead.
-->

- **Frameworks:** {e.g. xUnit + FluentAssertions} — evidence: `{path}`
- **Levels present:** {unit / integration / e2e} — evidence: `{path}`
- **How to run:** `{command}` — evidence: `{manifest or CI file}`
- **Coverage:** {only if a real report or config states it, otherwise delete this line}

---

## 7. Concerns / debt

<!--
Only with concrete evidence: real TODO/FIXME, missing tests, observed
duplication, visible coupling, unmaintained dependency, or documentation that
contradicts the code. No speculation.
-->

| Concern | Evidence | Note |
|---|---|---|
| {e.g. no automated tests in scope} | {what you checked and did not find} | {impact as observed} |
| {e.g. README describes an endpoint that does not exist} | `README.md` vs `{path}` | code is the truth |

---

## Next step

<!-- Pick the one route that applies and state how this inventory is consumed. -->

- **Route:** {mdpe-tasks | mdpe-backlog -> mdpe-transformation | architecture decisions | done}
- **How this inventory is consumed:** {e.g. the `files` of cf-002 become the Reference
  files of the new tasks; sections 2, 3 and 7 are carried forward as the
  existing-architecture constraint}
