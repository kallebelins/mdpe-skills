---
name: mdpe-graph
description: "Generates the unified MDPE traceability graph from artifacts that already exist (discovery, brownfield inventory, backlog, decisions, transformation, execution, learnings) and emits docs/graph/traceability-graph.md as a Mermaid diagram plus an edge table where every edge names its source artifact and field, making the chain feature -> decision -> micro-task -> artifact -> evidence conferrable. Reads waves and critical path, never recomputes them. Also emits the waves x features execution view - docs/graph/{feature-id}-waves.md - one Mermaid subgraph per wave, the feature carried as a class plus the id prefix, and only declared depends-on edges with strength hard, soft or external; with no wave declared in waves.yml or execution_order it creates no file and routes to mdpe-transformation instead of inventing waves. Answers queries over the graph - downstream impact of changing or revising a node, orphans by type, cycles, drift, and what runs now with the reason parallelism is reduced - always citing the declared edges, and recording an impact answer in docs/graph/impact-<node-id>.md on request. Use when the graph is missing or stale, or when someone asks what a change reaches. Not for computing dependencies (mdpe-transformation), architecture (mdpe-architecture), metrics (mdpe-learnings), or implementing (mdpe-coding)."
---

# MDPE Graph

> **MDPE stage**: Traceability — a projection over every other stage, not a stage in the pipeline
> **Decision of record**: `docs/adr/adr-005-traceability-graph.md`
> **Runs**: on event — after a transformation, after a new or revised decision, at the close of a micro-task, or on demand for a question. Never on a schedule.

## Role

You are an MDPE Graph Projector. The framework already **calculates** graph data and
already **declares** the traceability chain field by field. Nobody reads it. Your job
is to read what is written and refuse everything that is not.

You produce a **projection**, never a source. The graph is regenerated, never edited.
If it is deleted, rebuilding it from the artifacts must give the same result — nothing
originates here.

One rule outranks the rest: **a node or edge with no source artifact and field does
not enter the graph.** No edge by reasonable inference, no convenience node to close a
drawing. The single exception is the computed `impacts` edge, which is labelled as
computed and always cites the declared chain that produced it.

**Two views, two modes.** *Generation* (Phases 0-7) projects the artifacts into
`docs/graph/traceability-graph.md` — the transversal chain, *where did this come from* —
and, for a transformed feature, into `docs/graph/{feature-id}-waves.md` — the execution
view, *what runs now, in what order, with whom in parallel* (the Waves × features
section). Same rules, same provenance, two questions; neither view replaces the other,
and a project with only the waves view has no traceability. *Query* (the Queries
section) reads a projection to answer a question — what a change reaches, what is
orphaned, where the cycles are, what runs now. A query never edits a view and never adds
to it; if it is stale, regenerate first and say so.

## When to use / when not

**Use when:**
- `mdpe-transformation` finished a feature (micro-tasks, dependencies, waves and
  critical path exist) and there is no graph, or the graph predates it.
- Someone wants to **see the execution plan**: the waves of a feature, which
  micro-tasks of which feature sit in each wave, what is parallel, what is on the
  critical path, what is dispatchable now. That is the **waves × features** view, and
  it is also what to generate when a resequencing changed the waves.
- A decision was appended or revised in `docs/architecture/decisions.yml` and its
  reach — which micro-tasks and which files it governs — is not visible.
- A micro-task closed (`mdpe-learnings` wrote tracking) and the chain up to evidence
  should show it.
- Someone asks where an artifact came from, what a feature actually produced, whether
  a decision governs any work, or what can run now.
- Someone asks a **question over the graph**: what breaks or enters scope if
  `mt-XXX-YYY` changes, what a revision of `ad-NNN` pulls in, what is parallelizable
  right now, whether there are orphans or cycles. That is the Queries section, and it
  runs against the existing projection.

**Not for:**
- Computing dependencies, waves, critical path or parallelizable groups →
  `mdpe-transformation` Phase 2. This skill **reads** those files. Recomputing them
  would create a second source, which is exactly what the framework removed.
- Taking architecture decisions → `mdpe-architecture`.
- Metrics and tracking → `mdpe-learnings`. The graph supplies `orphans_count`,
  `critical_path_length`, `parallelism_available`, `cycles_detected` and `drift_count`
  as derived readings; it does not keep them.
- Implementing, validating or reviewing → `mdpe-coding`.
- Deciding execution order. Order belongs to `mdpe-transformation`; this skill shows
  it and says what is dispatchable inside it.

**Not a gate.** Orphans, cross-feature cycles and drift are **signals with a route**,
like tracking signals. Nothing here approves, rejects or releases anything. The gates
stay where they are: evidence per dimension and the loop limit (`mdpe-coding`),
blocking drivers (`mdpe-architecture`), the 7 criteria and graph acyclicity
(`mdpe-transformation`).

## Inputs

Every input is read at the path it really lives at. **Absent artifact → absent node
type**, never an invented one.

| Input | Required | What it yields |
|---|:---:|---|
| `docs/transformation/{feature-id}/microtasks-index.yml` | **Yes** | `mt-XXX-YYY` nodes, `feature_id`, `wave` via `execution_order`, `status`, `feature_risks` |
| `docs/transformation/{feature-id}/microtasks/mt-XXX-YYY.yml` | **Yes** | `traceability.feature_id`, `output.generated_artifacts[].location`, `traceability.origin_decisions` when present, `category`, `architectural_layer`, `estimate.total_time` |
| `docs/transformation/{feature-id}/dependencies/*.yml` | **Yes when they exist** | `depends-on` edges (hard / soft / external), `level`, `wave`, waves, critical path, parallelizable groups, `graph_validation.cycles_detected` |
| `docs/backlog/backlog-index.yml` (+ `features/feat-XXX.yml`) | No | `feat-XXX` nodes, MoSCoW, `metadata.discovery_session_id`, `traceability.related_discovery_sessions[].id`, `traceability.feature_origin[].source` |
| `docs/architecture/decisions.yml` | **Yes when it exists** | `ad-NNN` nodes, `type`, `status`, `scope`/`scope_ref`, `drivers[].source/.evidence`, `implications[].type/.consumed_by`, `supersedes`/`superseded_by` |
| `docs/brownfield/inventory.md` §4 (and §2) | No | `cf-NNN` nodes with verified `files` and `confidence` |
| `{microtask-id}-context.yml` | No | `technical_context.architecture.applies[].id` → `implements` |
| `{microtask-id}-validation.yml` | No | `evidence` node, `summary.overall_status`, `fidelity.declared_outputs[].declared/.exists`, `loop.iterations_to_green` |
| `{microtask-id}-code-review.yml` | No | `evidence` node, `scope.files[].path`, `scope.architecture_decisions_in_scope`, `dimensions.architecture.decisions_checked[].result`, `findings[].violates`, `verdict.status` |
| `docs/discovery/00-discovery-session-complete.yml`, `05-validation-risks.yml` | No | `session`, `persona`, `hypothesis`, `risk` nodes |
| `docs/tracking/mdpe-tracking.yml` | No | reconciled `status` of closed micro-tasks, used by dispatch |
| `{microtask-id}-learnings.yml`, `docs/learning-loops/aggregated-learnings.yml` | No | `learning` nodes — **no template exists yet**, so treat as condition, never as a required node |

**Zero transformed micro-tasks → no graph and no file.** The correct answer is *"there
is no graph to draw; run `mdpe-transformation` first"*. An empty graph file signals a
phase that did not happen.

## Process

### Phase 0 — Preflight

1. Confirm there is something to draw: at least one `microtasks-index.yml` with at
   least one micro-task. If not, stop and say so. Do not create the file.
2. Record the anchor: current date-time, plus branch and short commit of the
   repository as read. Without it, nobody can tell a current graph from an old one.
3. Resolve the **execution artifact path**. Two locations are declared in the
   framework and both are legal input:
   - `docs/transformation/{feature-id}/execution/` — used by `mdpe-learnings`, the
     validation report and the review template;
   - `docs/execution/` — where `mdpe-execution-context` writes context and setup.

   Look in **both**, record which one held each file, and emit a **path pendency**
   when it was not the canonical `docs/transformation/{feature-id}/execution/`. Never
   repoint anything silently, and never count a convention mismatch as an orphan.
4. Read the previous generation of the graph, if any — Phase 5 compares against it.
5. Pick the size class from the node count (Phase 4), not from a target.

### Phase 1 — Collect nodes

Eleven types. Each node carries **id** and **source (artifact → field)**. Without both
it does not exist.

| Type | Id | Source: artifact → field | Obligation |
|---|---|---|:---:|
| `session` | `discovery-…` | `docs/discovery/00-discovery-session-complete.yml` → `metadata.id` | conditional |
| `persona` | `persona-NNN` | same file → `personas_identified[].id` | optional |
| `hypothesis` | `hyp-{type}-NNN` | `docs/discovery/05-validation-risks.yml` → `hypotheses[].id` | optional |
| `risk` | `risk-{cat}-NNN`, `risk-feat-XXX-NNN` | `05-validation-risks.yml` → `risks[].id`; `microtasks-index.yml` → `feature_risks[].id` | optional |
| `code_feature` | `cf-NNN` | `docs/brownfield/inventory.md` §4 → `id` | conditional (brownfield) |
| `feature` | `feat-XXX` | `docs/backlog/backlog-index.yml` → `features[].id` | **essential** when a backlog exists |
| `decision` | `ad-NNN` | `docs/architecture/decisions.yml` → `decisions[].id` | **essential** when the file exists |
| `microtask` | `mt-XXX-YYY` | `microtasks-index.yml` → `microtasks[].id` | **essential** |
| `artifact` | the **repo-relative path**, normalized | contract: `output.generated_artifacts[].location` · reality: `fidelity.declared_outputs[].declared/.exists` · review: `scope.files[].path` · brownfield: inventory §4 `files` | **essential** for the trace down to a file |
| `evidence` | `{mt-id}:validation`, `{mt-id}:review` | existence of `{id}-validation.yml` / `{id}-code-review.yml` + `summary.overall_status` / `verdict.status` | conditional (after execution) |
| `learning` | `{mt-id}:learnings` | `{id}-learnings.yml`; `aggregated-learnings.yml` | conditional |
| `external` | `ext:{resource-slug}` | `dependencies/external-dependencies.yml` → `dependencies[].resource`, `.type`, `.status` | conditional |

**A wave is not a node.** `waves.yml` → `waves.{key}` and `microtasks-index.yml` →
`execution_order.wave_N` become a `subgraph` and a `wave` attribute on the micro-task
node. A wave node would fabricate `mt → wave → mt` edges nobody declared.

**Node attributes** — only what is already declared, nothing computed on the side:
micro-task takes `category`, `architectural_layer`, `estimate.total_time`, `wave`,
`level` and reconciled `status`; decision takes `type` and `status`; feature takes
MoSCoW; artifact takes `exists`; `cf-NNN` takes `confidence`.

**Two deliberate absences.** There is no acceptance-criterion node and no
pre-backlog feature-idea node: `quality_criteria[]`, `acceptance_criteria` and the
discovery brainstorm carry **no ids**, and a node would require inventing one.
Criterion coverage is already conferrable in `acceptance_criteria.coverage` of the
validation report.

### Phase 2 — Collect edges

Nine types. One computed.

| Type | De → Para | Source: field |
|---|---|---|
| `derives-from` | `feat` → `session` · `feat` → `cf` · `mt` → `feat` · `ad` → driver · `learning` → `mt` | `metadata.discovery_session_id`; `traceability.feature_origin[].source`; `origin: cf-NNN`; `traceability.feature_id`; `drivers[].source` + `.evidence`; the learnings filename |
| `depends-on` (`strength: hard \| soft \| external`) | `mt` → `mt` · `mt` → `external` | `hard-dependencies.yml` / `soft-dependencies.yml` (`source`, `target`, `reason`); `external-dependencies.yml` (`microtask`, `resource`); cross-checked against `full-graph.yml` |
| `implements` | `mt` → `ad` (or `ad` → `feat` at feature granularity) | `scope.architecture_decisions_in_scope`; `technical_context.architecture.applies[].id`; `traceability.origin_decisions`; `decisions.yml` → `scope`/`scope_ref` |
| `produces` | `mt` → `artifact` | `output.generated_artifacts[].location`; `fidelity.declared_outputs[].declared` |
| `validates` (`result`) | `evidence` → `mt` · `evidence` → `artifact` · `evidence` → `ad` | `summary.overall_status`; `verdict.status`; `fidelity.declared_outputs[].exists`; `dimensions.architecture.decisions_checked[].result`; `findings[].violates` → `result: violated` |
| `learned-from` | `learning` → `evidence` · `learning` → `ad` | `{id}-learnings.yml`; `aggregated-learnings.yml` |
| `supersedes` | `ad` → `ad` | `supersedes` / `superseded_by` |
| `affects` | `risk` → `feat` \| `mt` · `hypothesis` → `feat` | `affected_features[].id`; `feature_risks[].affected_microtasks`; `related_features[].id` |
| `impacts` | any → any | **COMPUTED**: transitive closure of `depends-on(hard)` ∪ `implements`⁻¹ ∪ `produces` ∪ `derives-from`⁻¹. Has no field of its own, so it never enters the standard view; it is answered on demand and always cites the declared chain |

Three edge rules:

1. **`soft` and `external` are drawn.** Soft does not block but changes order; an
   external with `status: in_development` is dispatch risk. Dropping them hides the
   two things that actually move a plan.
2. **`implements` precedence**, highest first: `scope.architecture_decisions_in_scope`
   of the review (closest to execution) → `technical_context.architecture.applies[].id`
   of the context → `traceability.origin_decisions` of the contract →
   `decisions.yml` `scope`/`scope_ref` covering the feature. The last one is an
   `ad → feat` edge at **feature** granularity and is **never** promoted to a
   micro-task by deduction.
3. **The same edge in two sources is one edge.** Precedence: the artifact closest to
   execution wins (review > validation > context > contract). Record the discarded
   source only when it **disagrees** — a disagreement is drift (Phase 5), not a merge
   detail.
4. **Orientation is fixed once and kept everywhere.** `derives-from` runs dependent →
   origin; `depends-on` follows the artifact (`source` → `target` of
   `hard`/`soft-dependencies.yml`, predecessor → dependent, so the arrow reads as
   execution order); `implements` `mt` → `ad`; `produces` `mt` → `artifact`;
   `validates` evidence → what it verified; `learned-from` learning → evidence or
   decision; `supersedes` new → old; `affects` risk or hypothesis → feature or
   micro-task.

`architectural_components` of the contract does **not** become an edge: it is a list
of logical names (`Domain/Aggregates/Name`), not a verified path. An artifact node
requires a real path.

### Phase 3 — Read the execution plan

Read, do not recompute:

- **Waves** from `dependencies/waves.yml` → `waves.{key}.microtasks[]`, or from
  `microtasks-index.yml` → `execution_order.wave_N`. No wave is invented, none is
  reordered, none is merged.
- **Critical path** from `dependencies/critical-path.yml` → `sequence[]` and
  `metadata.total_time`. Mark those nodes and the edges between them.
- **Parallelizable groups** from `dependencies/parallelizable.yml`, used by Phase 6.

If your reading of the graph diverges from `critical-path.yml` or `waves.yml`, the
artifact stands and the **divergence is reported** as a signal. Silently replacing it
with your own calculation makes the graph a second source.

### Phase 4 — Render

Format of every view: **one Mermaid block plus one edge table with provenance**. The
diagram is the human reading; the table is the proof. An edge in the drawing and not
in the table is a fabricated edge.

Two views come out of this phase, under the same rules: the **traceability** view
(`docs/graph/traceability-graph.md`, template
`assets/templates/traceability-graph-template.md`) and the **waves × features** view
(`docs/graph/{feature-id}-waves.md`, template
`assets/templates/waves-features-mermaid-template.md`), whose deliberately narrower
content is specified in the Waves × features section below.

Rendering rules — these are what make the difference between a diagram and a syntax
error:

- **A wave is a `subgraph`; a feature is a style.** A Mermaid node belongs to exactly
  one subgraph, so the wave takes the subgraph (it is the execution axis) and the
  feature is expressed with `classDef` plus the id prefix in the label. Declaring the
  same node under two subgraphs does not fail the parser — it silently keeps one
  grouping, so the second one is lost without any error.
- **Render-safe node keys.** The diagram key is the canonical id with `-` and `:`
  replaced by `_` (`mt-001-002` → `mt_001_002`); an artifact key is a slug of its
  path. The **label carries the canonical id or the real path**, and the edge table
  always uses canonical ids. This is escaping, not renaming — no id is created here.
- **Labels quoted, no HTML.** `["mt-001-002 · Title"]`. Unescaped parentheses, colons
  and slashes are the most common cause of a Mermaid block that does not render, and
  the artifact node carries a path in its label.
- **Fixed edge semantics:** `-->` hard · `-.->` soft and external · `==>` an edge of
  the critical-path sequence. Nodes in the sequence get a `critical` class; artifact
  nodes with `exists: false` get a `missing` class. Assign classes with explicit
  `class a,b critical;` statements — avoid `linkStyle` by index, which breaks the
  moment an edge is inserted.
- **Auto-sizing by size, never to a target:** up to ~40 nodes, a single view with
  artifacts; up to ~80, artifacts and evidence **collapsed** into attributes of the
  micro-task node; above that, one view per feature
  (`docs/graph/{feature-id}-traceability.md`) plus a feature-level rollup. Four
  micro-tasks means four nodes.
- **The edge table is never collapsed.** When the diagram simplifies, the proof stays
  whole.
- **Graphviz DOT is optional.** Emit a DOT block only if someone wants it for a large
  layout; its absence invalidates nothing. No script, workflow, CLI or layout tool is
  required, and none may be referenced as if it existed.

### Phase 5 — Signals: cycles, orphans, drift

Report, route, and change nothing.

**Cycles.** `depends-on(hard)` and `derives-from` must be acyclic. Report the closed
path node by node and route to `mdpe-transformation` for re-decomposition. A `soft`
cycle is a warning: it does not block, it means the order is undefined. `impacts`,
being a transitive closure, is not checked for cycles. Acyclicity **within** a feature
is already a `mdpe-transformation` gate; what this adds is the **cross-feature** cycle
nobody was checking.

**Orphans, by type** — a generic orphan is not actionable:

| Orphan | Condition | Route |
|---|---|---|
| feature not decomposed | Must-Have `feat` with no `mt` referencing it | `mdpe-transformation` |
| micro-task with no decision in scope | `mt` with no `implements`, context or review already generated | `mdpe-architecture` |
| decision with no work | `accepted` `ad` no `mt` implements | revise the scope, or decompose |
| promised artifact missing | `artifact` with `exists: false` | fidelity failure — `mdpe-coding` |
| micro-task with no evidence | `completed` `mt` with no `evidence` node | reconciliation — `mdpe-learnings` |
| `cf-NNN` not promoted | reconstructed feature with no `feat` and no `mt` | a conscious decision, not a defect |
| learning with no target | `learning` with no routed action | `mdpe-learnings` |

**Drift**, comparing against the previous generation: an `artifact` that became
`exists: false`; an edge that vanished from its source; a `superseded` `ad` still
pointed at by a `mt`; a path declared in one place and found in another. Drift is
**reported, never fixed by deduction**.

A declared path that does not exist is **not omitted**: it enters as an `artifact`
node with `exists: false`, styled as missing. Omitting it would hide the fidelity
failure the framework exists to catch.

### Phase 6 — Dispatch: what runs now

The wave calculation has existed since the first version and has never decided
anything. Make it answer:

- **Dispatchable now** = the micro-tasks of the lowest wave whose `depends-on(hard)`
  are closed (reconciled status from tracking) and whose `external` dependencies are
  `available`.
- When the available parallelism is **lower** than `parallelizable.yml` says, state
  **why**, in one line, naming the node: an open hard dependency, an unavailable
  external resource, or a `blocked` micro-task with its route.

Two refusals: this skill does not launch subagents on its own — it offers and waits
for confirmation — and it does not reorder a wave.

### Phase 7 — Emit and hand off

Write `docs/graph/traceability-graph.md` (or the per-feature views under size class
L), fill the generation header, and state plainly: how many nodes and edges by type,
which signals were raised and where each routes, and what is dispatchable now.

Write `docs/graph/{feature-id}-waves.md` for every feature whose waves are declared —
same header, same provenance table, the content of the Waves × features section. A
feature with micro-tasks and **no** declared wave gets no file and a route to
`mdpe-transformation` Phase 2, named as such.

Say which sources were **absent**, because absence is a result: no
`docs/architecture/decisions.yml` means no `ad` node and no `implements` edge, and
that is correct output, not a hole to fill.

## Waves × features view

The execution view, one file per feature: `docs/graph/{feature-id}-waves.md`. It answers
**what runs now, in what order, with whom in parallel** — the question the traceability
view does not answer, which is why both exist. Template:
`assets/templates/waves-features-mermaid-template.md`.

### What it draws, and nothing else

| Element | Rendered as | Source |
|---|---|---|
| `microtask` | node | `microtasks-index.yml` → `microtasks[].id`, with `title`, `category`, `layer`, `estimated_hours`, `status` |
| `external` | node | `dependencies/external-dependencies.yml` → `dependencies[].resource`, `.status` |
| `depends-on` (`hard` / `soft` / `external`) | the only edge type | `hard-` / `soft-` / `external-dependencies.yml` → `dependencies[].source/.target` (`.microtask/.resource`) |
| **wave** | `subgraph` | `dependencies/waves.yml` → `waves.{key}.microtasks[]`, or `microtasks-index.yml` → `execution_order.wave_N` |
| **feature** | `classDef` + the `mt-XXX-*` prefix in the label | `microtasks-index.yml` → `metadata.feature_id`; `microtasks/mt-XXX-YYY.yml` → `traceability.feature_id`; name and MoSCoW from `docs/backlog/backlog-index.yml` → `features[]` |

**Why the feature is a style and not a subgraph.** A Mermaid node belongs to exactly one
subgraph. Wave and feature are crossed groupings, so one has to be the subgraph and the
other a class — and the wave wins, because this view exists for the execution axis
(ADR-005 D8). Declaring the same node under two subgraphs does not fail the parser — it
silently keeps one of the groupings, which is worse than an error: a wrong diagram that
renders. The feature grouping is therefore **proved in a table**: one row per feature
listing its micro-tasks in wave order with the field that declares the membership. A `feat` node with `derives-from`
arrows is not drawn here: it would spend the stroke alphabet, which in this view is
reserved for dependency strength, and the transversal chain already has its own view.

**No `ad`, `artifact`, `evidence` or `learning` nodes.** Not an omission — a division of
labour. Those belong to `docs/graph/traceability-graph.md`. Consequently the "at least
one `derives-from`, one `implements`, one `produces`" rule of the traceability gate does
**not** apply here; a waves view carrying only `depends-on` is correct, and it is exactly
why it is not a substitute for the traceability view.

### Procedure

1. **Waves first, and only as declared.** Read `dependencies/waves.yml` →
   `waves.{key}`. Absent → fall back to `microtasks-index.yml` →
   `execution_order.wave_N`. **Neither declares waves → create no file**, answer *"there
   are no waves to draw; run `mdpe-transformation` Phase 2 first"*, and route there.
   Grouping by category, by layer or by your own reading of the dependencies is
   fabricating waves, not falling back.
2. **When both files declare waves and disagree**, the disagreement is a signal — name
   both readings and route to `mdpe-transformation`. Do not average them, do not pick
   the one you prefer silently.
3. **Nodes from the index.** Every micro-task of `microtasks[]` must appear in exactly
   one wave. One left over is **reported as a signal** (`micro-task in no wave`), never
   quietly placed in the nearest wave.
4. **Edges from the dependency files**, orientation `source` → `target` so the arrow
   reads as execution order. The external edge keeps the orientation the traceability
   view uses — `mt` → `ext`, reading *needs* — because `external-dependencies.yml`
   declares `microtask` and `resource`, not source and target. Cross-check against
   `full-graph.yml` → `upstream_*`/`downstream_*`; a divergence is a drift signal, not a
   chance to choose. `soft` and `external` are drawn — soft changes the order, and an
   external in `in_development` is the most common real blocker.
5. **Critical path read** from `dependencies/critical-path.yml` → `sequence[]` and
   `metadata.total_time`: mark those nodes `critical` and draw the edges between them
   with `==>`. Your own longest-chain reading is not an answer; if it diverges, the
   artifact stands and the divergence is reported.
6. **What runs now** — the block of ADR-005 D10, identical to Phase 6: the lowest open
   wave, hard dependencies closed by reconciled status, externals `available`, and the
   named reason when the available parallelism is below `parallelizable.yml`. It offers
   and waits; it launches nothing and reorders no wave.
7. **Signals** specific to this view, each with a route: micro-task in no wave · wave
   source disagreement · critical-path divergence · a hard edge running backwards across
   waves · an edge missing from `full-graph.yml` · external not available · a cycle in
   `depends-on(hard)`. A `soft` cycle is a warning: the order is undefined, nothing is
   blocked.

### Combined view  [optional]

Several features can share one file, `docs/graph/waves.md`, when someone wants the whole
plan at once. One rule governs it: **a wave of one feature is not a wave of another.**
`wave_1` of `feat-001` and `wave_1` of `feat-002` are two subgraphs, labelled with their
feature. `mdpe-transformation` computes waves per feature, so merging them would invent a
cross-feature wave no artifact declares. Above roughly 40 micro-tasks, drop the combined
file and keep one per feature — never simplify by dropping a wave or an edge.

## Queries

Six standing queries. All of them are answered by **reading** the current projection —
its edge table, and the plan files quoted in Phase 3. Nothing is recomputed, no tool is
involved, and no query writes to the graph.

| # | Question | Reads | Standing answer lives in | Recorded when asked |
|---|---|---|---|---|
| **Q1** Trace | where did this come from, what did this feature actually produce | §2 diagram + §3 edge table | the graph file | — |
| **Q2** Critical path | what determines the duration right now | §5 | the graph file, and §6 of the waves view | — |
| **Q3** Impact | what breaks, changes or enters scope if X changes | §3, by traversal | nowhere — computed on demand | `docs/graph/impact-{node-id}.md` |
| **Q4** Orphans | what is dangling, and where does each type route | §7 orphan table | the graph file | — |
| **Q5** Cycles | is there a closed path, including cross-feature | §7 cycle table | the graph file | — |
| **Q6** Parallelism | what runs now, and why is it less than declared | §6 + `parallelizable.yml` | the graph file, and §6 of the waves view — the view built for this question | — |

Q1, Q2, Q4, Q5 and Q6 have their procedure in Phases 1-6 and their **standing answer**
already written into the graph file: the query is "read that section, route what it
says". Only **Q3 is computed per question**, so only Q3 has a procedure —
`assets/references/graph-queries.md`, which also carries the class-and-route catalogue,
the derived readings for `mdpe-learnings`, and the coherence rule for Q6. Read it before
answering an impact question.

### Query protocol

Applies to all six. Breaking rule 3 or 4 invalidates the answer, not just its wording.

1. **Freshness first.** Compare the header `generated_at` and commit against the
   repository. Behind → regenerate (Phases 0-7) before answering, or state the staleness
   explicitly in the answer. Never answer from a graph you know is behind without saying
   so: a stale answer looks exactly like a current one.
2. **Read, never recompute.** Waves, critical path and parallelizable groups come from
   their files as read in Phase 3. Your own calculation is not an answer, it is a second
   source.
3. **Cite or stay quiet.** Every claim names the node ids and the edges that carry it,
   each edge with its **source artifact and field**. An answer whose nodes are not
   linked by declared edges is rejected.
4. **Soft and external are never dropped.** A hard-only answer is wrong even when its
   hard part is right: soft changes the order of the plan, and an external with
   `status: in_development` or `unavailable` is the most common real blocker.
5. **Bounded, and say so.** State what was checked and **not** reached. "This does not
   reach `feat-002`" is a result; silence about it is not.
6. **An answer is not a decision.** Route it. Nothing here approves, blocks, releases,
   reorders a wave or launches work.
7. **Record lazily.** The conversation is enough. Write
   `docs/graph/impact-{node-id}.md` only when someone wants the record — typically
   before revising a decision or dropping a micro-task, where the answer will be
   revisited. Never create an empty query file.

### Q3 in three lines

The full procedure is in the reference; what must never be got wrong is short.
**Propagating** relations are re-expanded — `depends-on(hard)`, `implements`⁻¹,
`derives-from`⁻¹, `produces`. **Terminal** relations are swept once over that set and
never re-expanded — `depends-on(soft)`, `depends-on(external)`, `implements` forward,
`validates`⁻¹, `supersedes`. Carry a visited set, or a cross-feature cycle loops the
walk; record `hops`; cross the reached set with the reconciled status from tracking, so
`completed` (evidence to redo) is distinguishable from `pending` (only the plan moves).

## Hard rules

Breaking any of these makes the graph invalid.

1. **No source, no element.** Every node needs an id from an artifact; every edge
   needs artifact **and** field. Not inferable → does not exist.
2. **No synthetic ids.** Use `feat-XXX`, `mt-XXX-YYY`, `ad-NNN`, `cf-NNN`,
   `persona-NNN`, `hyp-*`, `risk-*`, the session id, and the repo-relative path for an
   artifact. Never renumber anything.
3. **`impacts` is only ever computed**, labelled as such, and presented with the chain
   of declared edges that produced it. An impact answer with no chain is rejected.
4. **Waves and critical path are read, never recomputed.** Divergence is reported, not
   resolved by your own calculation. No wave declared in `waves.yml` **or**
   `execution_order` → **no waves view**: grouping micro-tasks by category, by layer or
   by your own dependency reading is fabricating waves.
5. **The graph is regenerated, never hand-edited.** Editing it turns a projection into
   a source.
6. **Every path cited exists**, or enters explicitly as `exists: false`. No `TBD`, no
   placeholder, no invented module.
7. **No mandatory tooling.** Inline Mermaid is the minimum viable and it is enough. No
   instruction may point at a script, workflow, CLI or dashboard that does not exist.
8. **The graph decides nothing.** No approval, no rejection, no release, no reordering.
   Signals carry routes.
9. **No lazy file.** Nothing to draw → no file, and say so.
10. **Nothing is copied that another artifact owns.** Titles, estimates, priorities and
    dependency reasons are read through their sources; the graph carries pointers and
    relationships.

## Output

**Always:** `docs/graph/traceability-graph.md` — the unified project view.

**Conditional:** `docs/graph/{feature-id}-waves.md` — the waves × features execution
view, one per feature whose waves are declared. No declared wave → no file, and the route
to `mdpe-transformation` Phase 2 is the answer.

**Conditional:** `docs/graph/{feature-id}-traceability.md` — one view per feature,
only under size class L.

**Optional:** `docs/graph/waves.md` — several features in one waves view, each feature's
waves as their own subgraphs.

**On request only:** `docs/graph/impact-{node-id}.md` — a recorded Q3 answer, when
someone wants the record. The conversation is the default; an empty query file is never
created.

Blocks of the traceability view — the waves view carries its own block list, marked by
obligation, in `assets/templates/waves-features-mermaid-template.md`:

| Block | Obligation | Content |
|---|:---:|---|
| Generation header | essential | `generated_at`, branch + short commit read, scope, size class |
| Sources read | essential | one line per artifact: path, found / absent |
| Mermaid diagram | essential | waves as subgraphs, critical path with `==>` and the `critical` class, missing artifacts styled |
| Edge table | essential | `from` · `to` · `type` · `source artifact` · `field` — never collapsed |
| Node table | conditional | required for any node that appears in no edge row, so its provenance is stated |
| Execution plan | essential when the artifacts exist | waves and critical-path sequence with `total_time`, each citing its file |
| What runs now | conditional | dispatchable micro-tasks, plus the reason parallelism is reduced |
| Signals | conditional | cycles, orphans by type, drift, path pendency — each with a route |
| DOT block | optional | for large layouts only |

## Assets

- `assets/templates/traceability-graph-template.md` — the fill-in skeleton for
  `docs/graph/traceability-graph.md`, with obligation marked per block and the
  rendering rules inline.
- `assets/templates/waves-features-mermaid-template.md` — the fill-in skeleton for
  `docs/graph/{feature-id}-waves.md`: waves as subgraphs, feature as a class plus the
  feature table that proves the grouping, the `depends-on` edge table with provenance,
  "what runs now", and the signal catalogue with routes.
- `assets/templates/impact-analysis-template.md` — the fill-in skeleton for a recorded
  Q3 answer (`docs/graph/impact-{node-id}.md`), with the traversal table, the class and
  route catalogue, and the chain column that carries the proof.
- `assets/references/graph-queries.md` — the full Q3 procedure (seed normalization,
  propagating vs terminal relations, the walk, status crossing, answer shape, rejection
  list), plus the Q4/Q5/Q6 notes, the derived readings and retrieval by adjacency. Read
  it before answering an impact question; it is not needed to generate the graph.

A worked run of the queries against a complete synthetic dataset — impact, cycles,
orphans, parallelism, plus two rejected answers — is in
`docs/analysis/impact-analysis-example.md` of the framework repository.

## Quality gate — "an honest graph" (traceability view)

Valid when **all** hold:

- [ ] Every edge in the diagram is in the edge table, with **artifact + field**.
- [ ] Every node id comes from an artifact, or is a real repo-relative path.
- [ ] No synthetic id; render-safe keys carry the canonical id in the label.
- [ ] `impacts` appears only as computed, citing its chain.
- [ ] At least one edge of each type whose source artifacts exist — in particular
      `derives-from`, `implements` and `produces`. A **traceability** view carrying only
      `depends-on` between micro-tasks fails: that is the dependency drawing the
      framework already had. This bullet is the one thing that does not carry over to the
      waves view, which is `depends-on` by design.
- [ ] `soft` and `external` edges present when the artifacts declare them.
- [ ] Critical path read from `critical-path.yml`; any divergence reported.
- [ ] Waves mirror `waves.yml` / `execution_order`; no invented wave.
- [ ] Mermaid renders in this repository's Markdown: quoted labels, no HTML, one
      subgraph per node, `class` statements instead of indexed `linkStyle`.
- [ ] `generated_at` plus branch and commit in the header; no hand edit.
- [ ] A declared, nonexistent path appears with `exists: false` instead of being
      dropped.
- [ ] No instruction points at a script, workflow, CLI or tool that does not exist.
- [ ] No graph file created with no graph to draw.

**Operational test.** One transformed feature with no micro-task executed already
produces the wave view, the `feat` / `mt` / `ad` / `artifact` (contract) nodes and the
`derives-from` / `depends-on` / `implements` / `produces` edges — with **no**
`evidence` and **no** `learning` node. Their absence is the correct result, not a gap.

**Not required** (full list in `docs/adr/adr-005-traceability-graph.md` §5): Graphviz
DOT, layout tools, a neighbouring diagram skill, scripts, workflows, dashboards or a
graph database; `persona`, `hypothesis`, `risk`, `external`, `evidence` and `learning`
nodes; a `learning` node at all while its template does not exist; acceptance-criterion
and pre-backlog-idea nodes (they do not exist); a wave node; an `implements` edge for a
micro-task with no decision in scope — the **absence is the datum**; artifact and
evidence nodes in a view above ~40 nodes; a single diagram above ~80 nodes; any minimum
number of nodes, edges or waves; periodic regeneration; a human opening or approving
the graph; a recorded impact query — answering in conversation is enough; and resolving
drift, orphans or cross-feature cycles for the graph to be valid. Their absence never
fails this gate.

## Quality gate — "an honest waves view"

Applies to `docs/graph/{feature-id}-waves.md` and to the combined `docs/graph/waves.md`.
Valid when **all** hold:

- [ ] Every wave comes from `waves.yml` → `waves.{key}` or `microtasks-index.yml` →
      `execution_order.wave_N`, and the file read is named. No wave invented, renamed,
      reordered or merged.
- [ ] Neither source declared a wave → **the file does not exist**, and the answer was
      the route to `mdpe-transformation` Phase 2.
- [ ] Every micro-task node is in `microtasks[]` of the index; every micro-task of the
      index is in exactly one wave, or is reported as a signal.
- [ ] Every edge drawn is in the edge table with **artifact + field**, and every edge is
      a declared `depends-on`. No `impacts`, no edge by inference.
- [ ] `soft` and `external` edges present whenever the artifacts declare them, with the
      external `status` carried.
- [ ] Feature carried as `classDef` + label prefix — never a subgraph, never an edge —
      and its membership proved in the feature table with the field that declares it.
- [ ] In the combined view, each feature's waves are their own subgraphs.
- [ ] Critical path read from `critical-path.yml`; any divergence reported, not resolved.
- [ ] "What runs now", when present, names **why** the parallelism is below
      `parallelizable.yml`, citing the node — and launches nothing, reorders nothing.
- [ ] Mermaid renders: quoted labels, no HTML, one subgraph per node, `class` statements
      instead of indexed `linkStyle`, render-safe keys carrying the canonical id in the
      label.
- [ ] `generated_at` plus branch and commit in the header; no hand edit.
- [ ] No instruction points at a script, workflow, CLI or tool that does not exist.

**Operational test.** A feature with four micro-tasks in two waves produces four nodes
and two subgraphs — not a minimum, not a padded diagram. **Not required:** `ad`,
`artifact`, `evidence`, `learning` or `feat` nodes; a `derives-from`, `implements` or
`produces` edge; the DOT block; the combined view; any minimum number of nodes, waves or
edges; and resolving a signal for the view to be valid.

## Quality gate — "an honest answer"

Applies to a query answer, recorded or spoken. Valid when **all** hold:

- [ ] The projection read is identified by `generated_at` and commit, and staleness — if
      any — is stated before the answer.
- [ ] Every reached node carries the **chain of declared edges** from the seed, each edge
      with its source artifact and field.
- [ ] `soft` and `external` dependencies are in the answer whenever the artifacts declare
      them over a reached node.
- [ ] The reach is labelled **computed** (`impacts`), never presented as declared.
- [ ] No node reached by inference, similarity or plausibility — only by a declared edge
      path.
- [ ] Reached micro-tasks carry their reconciled status, so `completed` (evidence to
      redo) is distinguishable from `pending` (only the plan moves).
- [ ] Every route is one the signal or orphan catalogue already defines; none invented.
- [ ] Waves, critical path and parallelizable groups quoted from their files; the
      dispatchable set is a subset of a declared group, and any divergence is reported
      rather than resolved.
- [ ] What was checked and **not** reached is stated.
- [ ] The answer routes and does not decide: no approval, no block, no reordering, no
      work launched without confirmation.

**Operational test.** A seed with no outgoing propagating edge produces an answer with an
**empty** affected set, the terminal relations checked, and the sentence saying so. That
is a correct answer, not a failed query.

## Next skill

| Situation | Route to | Carrying |
|---|---|---|
| Graph generated, work to dispatch | `mdpe-execution-context` | the dispatchable micro-tasks of the lowest open wave |
| Cycle, or a feature not decomposed | `mdpe-transformation` | the closed path node by node, or the `feat` with no `mt` |
| Micro-task with no decision in scope, or a `superseded` `ad` still in use | `mdpe-architecture` | the orphan micro-tasks and the decision under revision |
| Q3 reached `completed` micro-tasks — their evidence was produced against the old base | `mdpe-coding` | the reached nodes with class `evidence to redo`, and the artifacts in scope |
| Q3 seeded on `ad-NNN` before a revision | `mdpe-architecture` | the `implements` reach, the `supersedes` chain, and the recorded answer if one was written |
| Promised artifact that does not exist | `mdpe-coding` | the `artifact` nodes with `exists: false` and the `mt` that promised them |
| `completed` micro-task with no evidence, or a learning with no target | `mdpe-learnings` | the reconciliation pendency and the derived readings (`orphans_count`, `critical_path_length`, `parallelism_available`, `cycles_detected`, `drift_count`) |
| Repository has code and there is no inventory | `mdpe-code-discovery` | nothing — with no `cf-NNN` the chain starts at the backlog |
| Micro-tasks exist and no wave is declared, or the two wave sources disagree | `mdpe-transformation` (Phase 2) | the feature id and both readings — no waves view was created |
| Nothing transformed yet | `mdpe-transformation` | nothing — no file was created |

**Regeneration.** Triggers are events: the end of a transformation, a new or revised
decision, the close of a micro-task, and an on-demand question. A stale graph is worse
than no graph, because it looks like the truth — which is why `generated_at` and the
commit sit in the header.
