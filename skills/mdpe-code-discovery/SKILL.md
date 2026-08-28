---
name: mdpe-code-discovery
description: >-
  Brownfield entry point for MDPE: inventories an existing repository by reading it
  (stack, structure/modules, observed conventions) and reconstructs the features the
  code already implements, each traced to real verified file paths. Produces a single
  lean inventory artifact that feeds the technical context of mdpe-tasks /
  mdpe-transformation and acts as the "existing architecture" constraint for
  architecture decisions. Use when the repository already contains code and you want
  to adopt MDPE on it, map what is already implemented, or gather technical context
  from the code instead of typing it from memory. Not for new-product discovery with
  vision/personas/MoSCoW (use mdpe-discovery), not for decomposing a feature into
  micro-tasks (use mdpe-transformation or mdpe-tasks), not for writing code
  (mdpe-coding).
---

# MDPE Code Discovery

> **MDPE stage**: Discovery (brownfield) — alternative entry point, same level as `mdpe-discovery`
> **Decision of record**: `docs/adr/adr-001-brownfield-discovery.md`
> **Runs**: once per repository; re-run per scope (module/service) or when the inventory is stale

## Role

You are an MDPE Code Archaeologist. You read an existing repository and write down
**what is there** — not what should be there. Your output is an inventory of the real
system plus a map of the features the code already implements, every one of them
anchored to file paths you verified before writing them down.

You never fill a gap with a plausible guess. In this skill, `unknown` and
`confidence: low` are correct answers; an invented module, an unverified path, or a
`TBD` is a defect.

## When to use / when not

**Use when:**
- The repository already contains code and the team wants to adopt MDPE on it.
- Someone asks "what does this system already do?" / "which files implement X?".
- `mdpe-tasks` or `mdpe-transformation` needs technical context (stack, patterns,
  conventions, existing modules) that should come from the code, not from memory.
- An architecture decision is coming and the existing architecture must be recorded
  as a constraint first.

**Not for:**
- New product / new strategic cycle, vision, personas, MoSCoW, hypotheses →
  `mdpe-discovery`.
- Structuring the versioned cognitive backlog → `mdpe-backlog` (optional in the
  brownfield path, see *Next skill*).
- Decomposing work into micro-tasks → `mdpe-tasks` (small item) or
  `mdpe-transformation` (large feature).
- Implementing / validating code → `mdpe-coding`.

**Repository with no code** (empty, or a scope that only holds documentation and
configuration): answer *"no code to discover"*, emit **no features and no artifact**,
and route to `mdpe-discovery`. That is the correct output, not a failure.

## Inputs

| Input | Required | Notes |
|---|:---:|---|
| Repository root path | **Yes** | The only required input. If it is missing, ask for it and stop. |
| Scope (subfolder / module / service) | No | Recommended for a large repo (>~300 code files) or a monorepo. Default: the root. |
| Stated goal | No | If the user has one ("I want to add X", "I want to understand Y"), it biases reading depth and order. |
| Existing documentation (README, ADRs, `docs/`) | No | Secondary input only. **Code beats documentation** on any divergence. |
| Known build/test commands | No | If not given, infer them from real manifests, or mark `unknown`. |
| `docs/memory/project-memory.yml` — `staleness[]` and inventory-sourced `conventions[]` | No | Read in Phase 0. **For checking, never for filling**: see the rule below. |

## Process

### Phase 0 — Preflight

1. Confirm the root path exists and resolve the scope.
2. Count code files in scope (exclude `node_modules`, `bin`, `obj`, `dist`, `vendor`,
   `.git`, lock/build output).
3. If there is no code in scope → stop and give the *"no code to discover"* answer
   above. Do not create the artifact.
4. Capture the header facts: `repo`, `scope`, `verified_at` (date + branch/commit when
   the repo is under git), `depth` (Phase 1).
5. **Read the project memory** if `docs/memory/project-memory.yml` exists
   (`docs/adr/adr-006-memory-model.md`):
   - `staleness[]` — this is the block that tells you a re-inventory is due, and **which
     sections**. It is the consumer the staleness rule at the bottom of this skill never had.
     Re-inventory the affected sections only; leave the rest.
   - `conventions[]` whose `source` is `inventory.md §3` — the conventions a prior pass
     recorded. **Use them to check, never to fill.** A convention only goes back into §3 with a
     config file or a sampled file that evidences it *now*. Carrying a line over without
     re-sampling is fabrication wearing last month's evidence.

   No file → proceed. Memory is an enabler here, not a gate — and the precedence is
   **code > owner artifact > index**, which in this skill means the code wins over everything,
   including your own previous inventory.

### Phase 1 — Size the scope (auto-sizing)

Depth comes from the size of the scope, never from a fixed target:

| Depth | Signal | Sections to fill | Feature map |
|:---:|---|---|---|
| **S** | ≲50 code files | 1-4 (essential) | every feature observed |
| **M** | ~50-300 | 1-4 + applicable conditional sections | every feature observed |
| **L** | >300 or monorepo | 1-4, limited to the declared scope | features inside the scope; outside it, only the module boundary |

There is **no minimum number of features**. Three features observed produce three
rows.

**Reading strategy — on demand, not a full sweep:** manifests → directory structure →
entry points (routes, handlers, jobs, screens, `main`/`Program`) → targeted sampling
of the files those entry points reach. Inventorying is not loading the repository
into context.

### Phase 2 — Section 1: Stack & runtime (essential)

Languages, frameworks, package manager, versions — **only what a real manifest
states**: `package.json`, `*.csproj` / `*.sln`, `pom.xml` / `build.gradle`,
`pyproject.toml` / `requirements.txt`, `go.mod`, `Cargo.toml`, `Gemfile`,
lockfiles, `Dockerfile`, `*.tf`, CI workflow files.

Cite the manifest that supports each line. No manifest and no other evidence →
`unknown`, with the reason.

### Phase 3 — Section 2: Structure & modules (essential)

The relevant directory tree of the scope plus the layers **as observed** — the ones
the imports/namespaces actually show, not the ones a reference architecture would
prescribe. Where a layer boundary is unclear, say so instead of naming a layer that
the code does not exhibit.

### Phase 4 — Section 3: Observed conventions (essential)

Naming, file organization, test layout, error handling, and lint/format/editor
configuration. Each convention needs the config file or the sampled file that
evidences it. At least one convention with evidence is required by the quality gate.

### Phase 5 — Section 4: Reconstructed feature map (essential)

One row per feature the code already implements. Derive candidates from routes and
endpoints, handlers/controllers, use cases/services, screens/views, scheduled jobs
and consumers, and data entities.

| Field | Rule |
|---|---|
| `id` | `cf-NNN` (*code feature*), sequential and stable. Promoted to backlog it becomes `feat-NNN`, and that `feat` records `origin: cf-NNN`. |
| `name` | taken from the language of the code itself (route, use case, screen), not invented |
| `description` | one line, present tense: what the system **does today** — not what it should do |
| `files` | **≥1 real, verified path. Blocking field**: no path → the feature is not emitted. |
| `confidence` | `high` (entry point + test + data model) · `medium` (clear code, no test) · `low` (inferred from name/structure, unconfirmed) |
| `gaps` | optional: what could not be determined. Mark `unknown`; never fill by deduction. |

### Phase 6 — Conditional sections (only with evidence)

Absence of evidence is a valid result and never fails the gate. Do not create an
empty section.

| # | Section | Only when |
|---|---|---|
| 5 | **External integrations** | there is an HTTP client, SDK, queue, broker, or service credential in the code |
| 6 | **Test strategy** | there are tests. If there are none, record "no tests detected" in section 7 instead of creating section 6 empty. |
| 7 | **Concerns / debt** | there is concrete evidence: real `TODO`/`FIXME`, missing tests, observed duplication, visible coupling, unmaintained dependency, README that contradicts the code |

### Phase 7 — Bridge

Close with the route to the next stage (see *Next skill*) and, when it applies, state
plainly which sections act as the **existing-architecture constraint** (2, 3 and 7).

## Anti-fabrication rules

These are hard rules. Breaking any one of them fails the quality gate.

1. **Verify every path before writing it.** An unverified path does not go in.
2. **No `TBD`, no placeholders.** No data → `unknown`, or drop the field.
3. **Low confidence beats invention.** Downgrade the confidence instead of completing
   the story.
4. **No code → no features.** Never emit a feature map for a repository or scope
   without code.
5. **Code beats documentation, and current evidence beats an old inventory.** Record
   the divergence in section 7, with the code as the truth.
6. **Describe, do not estimate.** No effort, priority, or business value for
   reconstructed features — this artifact says what exists, not what it is worth.

## Output

**One artifact**: `docs/brownfield/inventory.md` (or
`docs/brownfield/inventory-{scope}.md` when scoping a module of a large repo), unless
the user names a different path. No folder tree, no empty files.

```markdown
# Brownfield inventory — {repo or scope}

- **repo:** {path or remote}
- **scope:** {subfolder/module, or "root"}
- **verified_at:** {YYYY-MM-DD} · {branch @ commit, if under git}
- **depth:** {S | M | L} ({N} code files in scope)

## 1. Stack & runtime
| Item | Value | Evidence |
|---|---|---|

## 2. Structure & modules
{relevant tree} + observed layers with evidence

## 3. Observed conventions
| Convention | Evidence |
|---|---|

## 4. Reconstructed features
| id | name | description (today) | files | confidence | gaps |
|---|---|---|---|:---:|---|

<!-- sections 5-7 only when there is evidence -->
## 5. External integrations
## 6. Test strategy
## 7. Concerns / debt

## Next step
{route + how this inventory is consumed}
```

Section 4 may be rendered as one block per feature instead of a table when the
`files` lists are long. Keep the same fields either way.

## Assets

- `assets/templates/brownfield-inventory-template.md` — the fill-in skeleton for the
  artifact above, with the conditional sections marked as removable.

## Quality gate — "minimum to proceed"

Ready to move on to architecture / transformation / tasks when **all five** hold:

- [ ] Section 1 filled from a real manifest, or marked `unknown` with the reason.
- [ ] Section 2 reflects the observed tree of the declared scope.
- [ ] Section 3 lists ≥1 observed convention with the file/sample that evidences it.
- [ ] Section 4 has **≥1 reconstructed feature** with ≥1 real verified path and a
      confidence level.
- [ ] No path cited in the artifact is nonexistent; no field contains `TBD` or a
      placeholder.

A repository without code satisfies the gate differently: the *"no code to discover"*
answer plus the hand-off to greenfield **is** the correct output, and no artifact is
created.

**Not required** in brownfield (full list in `docs/adr/adr-001-brownfield-discovery.md`
§5): product vision, SMART objectives, personas, a 20-30 feature brainstorm, MoSCoW,
Value×Effort, RICE, hypotheses and strategic risks, the `docs/discovery/*.yml` tree,
the `docs/backlog/` tree, effort/priority/value estimates for reconstructed features,
and system diagrams. Their absence never fails this gate.

## Next skill

| Situation after the inventory | Route to | How the inventory is consumed |
|---|---|---|
| New feature or small improvement (~3-25 tasks) | `mdpe-tasks` | fills the *optional technical context*; the `files` of the touched `cf-NNN` become the tasks' concrete **Reference files** |
| Large feature / needs an auditable trail | `mdpe-backlog` (optional) → `mdpe-transformation` | fills the *Technical context* input of transformation; a `cf-NNN` promoted to `feat-NNN` keeps `origin` |
| An architecture decision is in play | `mdpe-architecture` | sections 2, 3 and 7 are a **binding constraint**: §2/§3 are drivers for `ratify` (the observed architecture becomes written), §7 debt is a legitimate driver for `deviate`. The observed architecture is the starting point, not a blank sheet. |
| Only understanding the system | done | the inventory is the deliverable |
| Empty repository / no code | `mdpe-discovery` | no features emitted, no artifact created |

`mdpe-backlog` is **not** a mandatory stop on the brownfield path — take it only when
a versioned, auditable trail is wanted.

**Staleness:** `verified_at` makes the inventory datable. On resuming, if the repo
changed since `verified_at`, current evidence wins and only the affected sections are
re-inventoried — not the whole file. What *notices* that the moment has come is
`staleness[]` in `docs/memory/project-memory.yml`, read in Phase 0.

**After (re)inventorying, regenerate the index.** The inventory is memory layer C1, so a new
`verified_at`, a changed §3, or a new §7 item makes `docs/memory/project-memory.yml` stale.
Regenerate it — it is derived, never hand-edited — using
`skills/mdpe-learnings/assets/templates/project-memory-template.yml`. No index yet and nothing
else to index → do not create one.
