# Skills by Category

The other documents in this repository (`README.md`, `docs/mdpe-flow.md`,
`docs/mapping-commands-to-skills.md`) organize the 18 MDPE skills **by lifecycle
position** — where each one sits between Discovery and Execution. This document
organizes the same 18 skills **by role**: what kind of work each skill does,
regardless of when it runs. Use it when you know *what you need done* (plan
something, transform it, execute it, check it, learn from it, or use a
cross-cutting tool) but not which specific skill name to reach for.

The category names below borrow from Plan–Do–Check–Act, adapted to MDPE's own
vocabulary (`Plan/Prepare → Produce/Proof → Propagate`, see
`docs/mdpe-flow.md`). They are an organizational grouping, not new skills or new
folders under `skills/` — every skill still lives at its existing path
(`skills/<name>/SKILL.md`); nothing was moved.

## Category index

| Category | Question it answers | Skill count |
|----------|----------------------|:---:|
| [Plan](#1-plan--discovery-backlog--architecture) | What should we build, and why? | 8 |
| [Transform](#2-transform--technical-decomposition) | How does that become work an agent can execute? | 1 |
| [Do](#3-do--prepare--produce) | Who gets the task ready, and who writes the code? | 2 |
| [Check](#4-check--proof) | How do we know the work is actually correct? | 1 (shared with Do) |
| [Learn](#5-learn--propagate) | What did we learn, and where does it go next? | 2 |
| [Tools](#6-tools--orchestration--cross-cutting-utilities) | What helps me navigate, visualize, or report on all of the above? | 4 |
| [Fast path](#7-fast-path--plan--transform--do-prepare-in-one-file) | I just have one small item — can I skip the pipeline? | 1 |

---

## 1. Plan — Discovery, Backlog & Architecture

**What it does:** organizes and defines what should be built, before any
technical decomposition happens. Covers five different entry points depending
on what raw material exists (a vision statement, an existing codebase, a legacy
database, a frontend, a Figma prototype, or plain images), plus the two steps
that turn that raw material into a structured, prioritized backlog and, when a
driver demands it, a recorded architecture decision.

| Skill | Purpose |
|-------|---------|
| `mdpe-backlog-discovery` | Greenfield discovery: vision, personas, feature brainstorm, MoSCoW/RICE prioritization, hypotheses & risks |
| `mdpe-code-discovery` | Brownfield entry point: inventories an existing repository into `docs/brownfield/inventory.md` |
| `mdpe-data-discovery` | Brownfield entry point, sibling of `mdpe-code-discovery`: inventories a legacy schema/database with no readable application code |
| `mdpe-frontend-discovery` | Design-led entry point: reconstructs features from an existing frontend codebase |
| `mdpe-figma-discovery` | Design-led entry point: reconstructs features from a Figma prototype |
| `mdpe-image-discovery` | Design-led entry point: reconstructs features from plain images/screenshots |
| `mdpe-backlog` | Structures any of the discovery outputs above into a traceable, versioned cognitive backlog |
| `mdpe-architecture` | Enabler: turns a backlog/inventory driver into a recorded architecture decision that later stages consume |

---

## 2. Transform — Technical Decomposition

**What it does:** takes one planned feature and turns it into requirements an
agent can actually act on — atomic micro-tasks with IOQD, a dependency graph,
sequencing into waves, and a project-level task list. This is the "discovery
becomes a technical spec" step.

| Skill | Purpose |
|-------|---------|
| `mdpe-transformation` | Decomposes a feature into validated, sequenced, prioritized micro-tasks and generates `tasks.md` |

---

## 3. Do — Prepare & Produce

**What it does:** the two steps that actually get work executed. First, one
micro-task's context and environment are prepared (branch, dependencies, file
structure — "Ready to Code"). Then the code is written. `mdpe-coding` is the
skill that does the producing; it also owns the Check phase below in the same
pass.

| Skill | Purpose |
|-------|---------|
| `mdpe-execution-context` | Prepares: generates the 6-dimension execution context and sets up the environment |
| `mdpe-coding` | Produces: implements the micro-task (SOLID/TDD) |

---

## 4. Check — Proof

**What it does:** validates and reviews what was produced before it can be
called done. In MDPE this is not a separate skill — it is two phases inside
`mdpe-coding` (validation against 6 dimensions, then a 7-dimension code
review) — but it is listed as its own category here because it answers a
distinct question ("is this actually correct?") from "Do" ("build the thing").
A micro-task cannot skip this and go straight to `mdpe-learnings`.

| Skill | Purpose |
|-------|---------|
| `mdpe-coding` (Proof phase) | Validates (6 dimensions, evidence-backed) and reviews (7 dimensions) the same micro-task it produced |

---

## 5. Learn — Propagate

**What it does:** closes the loop. Reviews what happened during execution and
feeds it back into future discovery, transformation, and execution — either
per micro-task, or aggregated across a whole declared cycle.

| Skill | Purpose |
|-------|---------|
| `mdpe-learnings` | Extracts learnings per micro-task, feeds discovery/transformation/execution, and owns the project memory index |
| `mdpe-retro` | Aggregates multiple `mdpe-learnings` closes over a declared cycle/sprint into What Went Well / What to Improve / Action Items |

---

## 6. Tools — Orchestration & Cross-cutting Utilities

**What it does:** doesn't belong to a single lifecycle stage. These skills
route you to the right place, visualize what other skills already produced, or
project completed work outward to an audience outside the framework's own
vocabulary (software consumers, non-technical stakeholders).

| Skill | Purpose |
|-------|---------|
| `mdpe-router` | Entry point: detects where you are in the MDPE cycle and routes to the right skill |
| `mdpe-graph` | Renders the traceability graph (Mermaid/DOT) from what transformation and coding already produced; answers impact/orphan/cycle/critical-path questions |
| `mdpe-release` | On demand: projects completed, evidenced micro-tasks into `CHANGELOG.md` for whoever consumes the software |
| `mdpe-status-report` | On demand: turns tracking, the graph, and memory into a one-page, jargon-free brief for a non-technical stakeholder |

---

## 7. Fast path — Plan → Transform → Do (Prepare) in one file

**What it does:** for a single backlog item, feature, or piece of free text
that doesn't need the full traceable, multi-artifact pipeline. It consolidates
a lite version of discovery framing (Plan), decomposition (Transform), and
execution-context (Do/Prepare) into a single Markdown checklist, then hands
off directly to `mdpe-coding` for Do/Produce and Check.

| Skill | Purpose |
|-------|---------|
| `mdpe-tasks` | From a text/backlog item/feature, produces one Markdown file with phased, checkbox-driven tasks, each with IOQD, dependencies, priority, and inline execution context |

---

## How this maps to the lifecycle view

The category view above and the lifecycle view in `docs/mdpe-flow.md` describe
the same 18 skills from two angles:

```
Plan        Transform      Do              Check           Learn
──────────  ─────────────  ──────────────  ──────────────  ──────────────
discovery   transformation execution-      (inside         learnings
(6 entry               →   context    →    mdpe-coding) →  retro
points)                    → coding
   ↓                                                            │
backlog                                                         │
   ↓                                                            │
architecture                                                    │
   ↑____________________________________________________________│
                    (loops back to Plan / Transform / Do)

Tools (mdpe-router, mdpe-graph, mdpe-release, mdpe-status-report) sit outside
this line — they support, visualize, or project it, on demand, without gating
any stage.

Fast path (mdpe-tasks) is a shortcut through Plan → Transform → Do(Prepare) for
a single small item.
```

Start from `docs/mdpe-flow.md` when you want to know **what comes next**.
Start from this document when you want to know **which kind of skill you
need**.
