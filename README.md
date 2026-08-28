# MDPE Skills

Agent skills for the **MDPE Framework** — a methodology based on **micro-task-oriented
prompt engineering** for software development. This package consolidates the 15 MDPE
executable commands into **7 cohesive Kiro skills** (6 functional + 1 router), so an
AI agent can drive a project end to end: Discovery → Backlog → Transformation →
Execution, with learning loops. An 8th skill, **[`mdpe-tasks`](skills/mdpe-tasks/SKILL.md)**,
offers a fast path: it consolidates discovery framing, transformation, and
execution-context into a single Markdown checklist for one text/backlog item/feature,
without the full multi-artifact pipeline.

Three further skills were added to close gaps identified against brownfield adoption,
architecture decisions, and traceability (see `tasks-v1.md` and `docs/adr/`):
**[`mdpe-code-discovery`](skills/mdpe-code-discovery/SKILL.md)** (brownfield entry
point), **[`mdpe-architecture`](skills/mdpe-architecture/SKILL.md)** (architecture
decisions as an enabler stage), and **[`mdpe-graph`](skills/mdpe-graph/SKILL.md)**
(traceability graph and visualization). The package now totals **11 skills**. A
project memory index (`docs/memory/project-memory.yml`, owned by `mdpe-learnings`) is
read by every skill before it acts — see `docs/adr/adr-006-memory-model.md`.

## Why skills instead of 15 commands

The MDPE Framework ships 15 executable commands (prompt + templates + schemas each).
Mapping them 1:1 to skills would create redundancy, overlapping content, and routing
friction. Tightly-coupled commands that always run together were merged, and optional
refinements became internal depth modes — without losing any capability. See
[`docs/mapping-commands-to-skills.md`](docs/mapping-commands-to-skills.md) for full
traceability (15 → 7).

## The 7 skills

| Skill | Consolidates | Purpose |
|-------|--------------|---------|
| [`mdpe-router`](skills/mdpe-router/SKILL.md) | orchestration | Detects where you are in the MDPE cycle and routes to the right skill |
| [`mdpe-discovery`](skills/mdpe-discovery/SKILL.md) | DP-01, DP-02, DP-03 | Facilitates discovery: vision, personas, features, MoSCoW/RICE prioritization, hypotheses & risks |
| [`mdpe-backlog`](skills/mdpe-backlog/SKILL.md) | BC-01 | Structures a traceable, versioned cognitive backlog from discovery outputs |
| [`mdpe-transformation`](skills/mdpe-transformation/SKILL.md) | TL-01, TL-02, TL-03, TL-04, TG-01 | Decomposes a feature into validated, sequenced, prioritized micro-tasks and generates `tasks.md` |
| [`mdpe-execution-context`](skills/mdpe-execution-context/SKILL.md) | EX-01, CD-01 | Generates a 6-dimension execution context and prepares the environment (Ready to Code) |
| [`mdpe-coding`](skills/mdpe-coding/SKILL.md) | CD-02, CD-03, CD-04 | Implements (SOLID/TDD), validates (6 dimensions), and reviews (7 dimensions) a micro-task |
| [`mdpe-learnings`](skills/mdpe-learnings/SKILL.md) | EX-02 | Extracts learnings and feeds them back to Discovery, Transformation, and Execution |

## Fast-path skill

| Skill | Consolidates (lite) | Purpose |
|-------|----------------------|---------|
| [`mdpe-tasks`](skills/mdpe-tasks/SKILL.md) | discovery framing + TL-01/02/03/04 + EX-01/CD-01 | From a text/backlog item/feature, produces **one** Markdown file with phased, checkbox-driven tasks — each with IOQD, dependencies, priority, and inline execution context |

Use the 7 skills above when you need the full traceable, multi-artifact pipeline
(versioned backlog, per-feature YAML trail, standalone context files). Use
`mdpe-tasks` when a single item/feature just needs to become an actionable
checklist, fast.

## Enabler skills (added post-v0)

These 3 skills map to no original MDPE command; each closes a gap found against the
framework's baseline (see `docs/analysis/baseline-gap-map.md` and the linked ADR).
None of them gate the pipeline — each has an explicit "no driver / no code / no graph
yet → no artifact" exit.

| Skill | Runs | Purpose | Decision of record |
|-------|------|---------|---------------------|
| [`mdpe-code-discovery`](skills/mdpe-code-discovery/SKILL.md) | once per repository, or when stale | Brownfield entry point: inventories an existing repo (stack, modules, conventions, reconstructed features) into `docs/brownfield/inventory.md`, so MDPE can be adopted without a greenfield discovery session | `docs/adr/adr-001-brownfield-discovery.md` |
| [`mdpe-architecture`](skills/mdpe-architecture/SKILL.md) | once per driver-set, when a driver demands it | Turns backlog/inventory drivers into recorded architecture decisions (`docs/architecture/decisions.yml`) that transformation, execution-context, tasks, and coding's review consume and check — instead of architecture entering as free text or as an unwritten review opinion | `docs/adr/adr-002-architecture-skill.md` |
| [`mdpe-graph`](skills/mdpe-graph/SKILL.md) | on demand, when the graph is missing or stale | Renders the traceability graph (Mermaid, optionally DOT) and a waves×features view from the YAMLs transformation and coding already produce, and answers impact/orphan/cycle/critical-path questions | `docs/adr/adr-005-traceability-graph.md` |

Flow diagram: [`docs/mdpe-flow.md`](docs/mdpe-flow.md).

## Repository structure

```
mdpe-skills/
├── README.md
├── INSTALL.md                       # how to install into ~/.kiro/skills
├── skills/
│   ├── mdpe-router/SKILL.md
│   ├── mdpe-code-discovery/{SKILL.md, assets/}   # brownfield entry point
│   ├── mdpe-discovery/{SKILL.md, assets/}
│   ├── mdpe-backlog/{SKILL.md, assets/}
│   ├── mdpe-architecture/{SKILL.md, assets/}     # architecture enabler
│   ├── mdpe-transformation/{SKILL.md, assets/}
│   ├── mdpe-execution-context/{SKILL.md, assets/}
│   ├── mdpe-coding/{SKILL.md, assets/}
│   ├── mdpe-learnings/{SKILL.md, assets/}
│   ├── mdpe-graph/{SKILL.md, assets/}            # traceability graph observer
│   └── mdpe-tasks/{SKILL.md, assets/}       # fast-path (see above)
└── docs/
    ├── mapping-commands-to-skills.md
    ├── mdpe-flow.md
    ├── adr/                          # decisions of record, one per gap closed
    └── analysis/                     # baseline, rubric, competitive analysis, audits
```

Each skill is self-describing: the `SKILL.md` body summarizes the original prompt,
and the `.yml` templates / `.json` schemas it uses are copied into that skill's
`assets/` folder as versioned, offline-usable references.

## Installation

See [`INSTALL.md`](INSTALL.md). In short, copy each folder under `skills/` into your
Kiro skills directory (`~/.kiro/skills/`) or point your agent configuration at this
repository.

## Quick start

1. Ask the agent: *"I want to start a new project with MDPE."* → `mdpe-router` routes you to `mdpe-discovery`.
2. Run discovery, then `mdpe-backlog`, then (only if a driver demands it) `mdpe-architecture`, then `mdpe-transformation` for your first feature.
3. For each micro-task: `mdpe-execution-context` → `mdpe-coding` → `mdpe-learnings`.
4. Loop back to the next micro-task, next feature, or a new discovery cycle.

Or, for a single text/backlog item/feature you just want turned into an actionable
checklist: skip straight to `mdpe-tasks`, then work through its tasks with
`mdpe-coding`.

**Already have a codebase?** Say *"this repository already has code, help me adopt
MDPE"* → `mdpe-router` routes you to `mdpe-code-discovery` first, which produces an
inventory instead of a greenfield discovery session. See the *Brownfield path* in
[`docs/mdpe-flow.md`](docs/mdpe-flow.md).

## Credit

Derived from the MDPE Framework technical study (prompts, templates, and schemas).
License: MIT.
