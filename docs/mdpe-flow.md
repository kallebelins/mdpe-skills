# MDPE Skills Flow

This document shows how the **11 MDPE skills** connect across the MDPE lifecycle
(Code Discovery/Discovery → Backlog → Architecture → Transformation → Execution),
including the feedback loops that make MDPE cognitive, the brownfield entry point,
the architecture enabler, the traceability graph, and the project memory that both
feeds and is fed by every stage.

## Skill routing flow

```mermaid
graph TD
    R[mdpe-router] --> CF[mdpe-code-discovery]
    R --> D[mdpe-discovery]
    CF --> AR[mdpe-architecture]
    D --> B[mdpe-backlog]
    B --> AR
    AR --> T[mdpe-transformation]
    B --> T
    T --> EC[mdpe-execution-context]
    EC --> C[mdpe-coding]
    C --> L[mdpe-learnings]
    L -->|next micro-task| EC
    L -->|next feature| T
    L -->|new cycle| D
    T -.-> GR[mdpe-graph]
    C -.-> GR
    L -.regenerates.-> M[(docs/memory/project-memory.yml)]
    M -.read before acting.-> R
    M -.-> D
    M -.-> AR
    M -.-> T
    M -.-> EC
    M -.-> C
```

`mdpe-code-discovery` replaces `mdpe-discovery` when the repository already contains
code (brownfield): it inventories stack, modules, and reconstructed features instead
of running a greenfield vision/persona/MoSCoW session. `mdpe-architecture` is an
enabler, not a mandatory stage between backlog/code-discovery and transformation — it
runs only when a driver demands an architectural choice. `mdpe-graph` is an observer
that renders the traceability already produced by transformation and coding; it never
gates the pipeline. `docs/memory/project-memory.yml` is a derived index, regenerated
by `mdpe-learnings` (and by `mdpe-architecture`/`mdpe-code-discovery` at their own
triggers), and read by every skill before it acts — see
`docs/adr/adr-006-memory-model.md`.

## Lifecycle mapping

| MDPE stage | Skill | Runs | Main outputs |
|------------|-------|------|--------------|
| Code Discovery (brownfield entry point) | `mdpe-code-discovery` | once per repository, or when it goes stale | `docs/brownfield/inventory.md` |
| Discovery (greenfield) | `mdpe-discovery` | once per project | `docs/discovery/*.yml` |
| Backlog | `mdpe-backlog` | once per project | `docs/backlog/backlog-index.yml`, `features/feat-XXX.yml` |
| Architecture (enabler) | `mdpe-architecture` | once per driver-set, when a driver demands it | `docs/architecture/decisions.yml`, conditional `docs/adr/adr-NNN-{slug}.md` |
| Transformation | `mdpe-transformation` | once per feature | `docs/transformation/{feature-id}/**`, `tasks.md` |
| Execution — Plan/Prepare | `mdpe-execution-context` | once per micro-task | `*-context.yml`, `*-setup.yml` |
| Execution — Produce/Proof | `mdpe-coding` | once per micro-task | code, `*-validation.yml`, `*-code-review.yml` |
| Execution — Propagate | `mdpe-learnings` | once per micro-task | `*-learnings.yml`, `aggregated-learnings.yml`, `docs/memory/project-memory.yml` |
| Graph (observer) | `mdpe-graph` | on demand, when the graph is missing or stale | traceability graph + waves×features Mermaid, impact analyses |
| Fast path (Discovery-lite → Transformation → Plan/Prepare) | `mdpe-tasks` | once per item/feature | single `docs/mdpe-tasks/{item-id}.md` |

## The MDPE cycle (Plan → Prompt → Produce → Proof → Propagate)

```mermaid
graph LR
    P1[Plan/Prepare<br/>execution-context] --> P2[Produce<br/>coding: implement]
    P2 --> P3[Proof<br/>coding: validate + review]
    P3 --> P4[Propagate<br/>learnings]
    P4 -.feeds back.-> P1
    P4 -.feeds back.-> T[transformation]
    P4 -.feeds back.-> D[discovery]
```

## Minimal path

For a minimum viable run of the framework:

1. `mdpe-discovery` (produce discovery YAMLs)
2. `mdpe-backlog` (structure the cognitive backlog)
3. `mdpe-architecture` — only if a driver in the backlog demands an architectural
   choice; otherwise skip straight to step 4
4. `mdpe-transformation` (decompose the first feature, generate `tasks.md`)
5. `mdpe-execution-context` (context + setup for the first micro-task)
6. `mdpe-coding` (implement → validate → review)
7. `mdpe-learnings` (extract learnings, regenerate the memory index), then loop back
   to step 5 or 4.

## Brownfield path (repository already has code)

For adopting MDPE on an existing codebase, without running a greenfield discovery
session:

1. `mdpe-code-discovery` — inventory the repository (stack, modules, conventions,
   reconstructed features) into `docs/brownfield/inventory.md`.
2. `mdpe-architecture` — ratify the observed architecture as a binding constraint
   before new work starts (`type: ratify`), and decide on any new driver.
3. `mdpe-transformation` or `mdpe-tasks` — decompose a reconstructed or new feature,
   citing the inventory and the `ad-NNN` decisions as technical context.
4. Continue as the minimal path from step 5 onward.

See `docs/adr/adr-001-brownfield-discovery.md` for what is explicitly **not**
required in this path (personas, MoSCoW, a 20-30 feature brainstorm, and the rest of
the greenfield discovery apparatus).

## Fast path (single item/feature)

For a single backlog item, feature, or piece of free text that doesn't need the
full traceable pipeline:

1. `mdpe-tasks` — produces one Markdown file with phased, checkbox tasks, each
   carrying its own IOQD, dependencies, priority, and inline execution context.
2. `mdpe-coding` per task (the inline context replaces a separate
   `mdpe-execution-context` step).
3. Optionally `mdpe-learnings` once the item is fully done.
