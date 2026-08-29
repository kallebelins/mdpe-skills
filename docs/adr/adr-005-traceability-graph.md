# ADR-005 — MDPE traceability graph model

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 28/08/2026 |
| **Origin task** | `tasks-v1.md` → Phase 6 → 6.1 |
| **Rubric axis** | Axis 5 — Visualization and traceability (baseline **2**, target **4**; level 5 with 6.3) |
| **Implemented by** | Task 6.2 (skill + traceability graph template) · 6.3 (queries and impact) · 6.4 (waves × features view) · stitched in 9.2 · re-scored in 9.3 |
| **Associated adoptions** | A10 (feature ↔ file locator) · A11 (graph that dispatches, not just draws) · A13 (cross-artifact consistency, orphans and broken path) · A5 (lazy creation) |
| **Depends on** | ADR-001 (`cf-NNN` and verified `files`: the file node in brownfield) · ADR-002 (`ad-NNN`, `drivers[].source/evidence`, `implications[].type/consumed_by`, `supersedes`) · ADR-003 (evidence per dimension, `fidelity.declared_outputs[].exists`, status vocabulary, escalation routes) · ADR-004 (D1 derived projection; D11 removed the competing `dependency_graph`; block G reserved) |

---

## 1. Context

The MDPE **computes** a graph and **has no** graph. The data exists, is correct, and dies in the
directory where it was born.

### 1.1 Graph data generated per feature, and never unified or drawn

`skills/mdpe-transformation/SKILL.md` Phase 2 produces seven files under
`docs/transformation/{feature-id}/dependencies/`: `full-graph.yml` (upstream/downstream, `level`,
`wave`, convergence and divergence points, `graph_validation.cycles_detected`),
`hard-dependencies.yml`, `soft-dependencies.yml`, `external-dependencies.yml`, `waves.yml`,
`critical-path.yml`, and `parallelizable.yml`. It is real computation, with a justification per edge
(`reason`) and cycle detection.

No step in the framework reads them afterward. This is **Gap 5.1**. The `microtasks-index-template.yml`
even admits this in writing, in the `dependency_graph` block: *"Use a visualization tool for the full graph"* —
an instruction that points nowhere, next to an example ASCII drawing
(`mt-XXX-001 → mt-XXX-002`) that no one generates.

The only Mermaid diagrams in the repository (`docs/mdpe-flow.md`, `skills/mdpe-router/SKILL.md`) are
**skill-to-skill routing** diagrams, hand-written. They do not derive from any YAML and do not change
when the project changes. Rubric level 1, inside a framework that has data for level 4.

ADR-004 (D11) already removed the competitor from the path: the `dependency_graph: nodes/edges` in
`mdpe-tracking.yml`, which duplicated `full-graph.yml` in a reduced form and without a precedence rule.
Today there is **one** dependency source per feature, and no view.

### 1.2 Tracing at the two extremes: only micro-task ↔ micro-task

`dependencies-template.yml` links exclusively `mt-XXX-YYY` to `mt-XXX-ZZZ`. This is **Gap 5.2**. Nothing
in the framework traverses the chain that question 5 asks for: discovery → feature → micro-task →
architecture decision → artifact/file → learning.

The practical effect is not cosmetic. Without the cross-cutting chain, none of the questions that
justify having a graph can be answered:

- *does this file exist because of which decision?*
- *if `ad-004` is revised, which micro-tasks and which files come into scope?*
- *was this feature actually implemented, or only decomposed?*
- *where did this learning come from, and where should it flow back to?*

### 1.3 The chain already exists field by field — and no one traverses it

This is the finding that underpins the ADR: **the cross-cutting edges do not need to be invented.**
Four phase ADRs each deposited, for their own reasons, exactly the fields that link the pieces.
Inventory of what is already declared in the templates:

| Chain link | Field that already declares it | Where |
|---|---|---|
| discovery session → backlog | `metadata.discovery_session_id`; `traceability.related_discovery_sessions[].id`; `personas_identified[].id` | `cognitive-backlog-template.yml`; `discovery-session-template.yml` |
| feature → origin | `traceability.feature_origin[].source` | `cognitive-backlog-template.yml` |
| reconstructed feature → real files | §4 `id` (`cf-NNN`) + `files` (verified path, **blocking** field) | `brownfield-inventory-template.md` |
| `cf-NNN` → `feat-NNN` | promotion records `origin: cf-NNN` | ADR-001 / inventory §4 |
| decision → driver | `drivers[].source` + `drivers[].evidence` (real artifact **and** field) | `architecture-decisions-template.yml` |
| decision → scope | `scope` + `scope_ref` (`system` \| `feature` \| `module`) | idem |
| decision → derived work | `implications[].type: derived_work` + `consumed_by` | idem |
| decision → decision | `supersedes` / `superseded_by` | idem |
| micro-task → feature | `traceability.feature_id` | `mdpe-microtask-template.yml` |
| micro-task → promised artifact | `output.generated_artifacts[].location` | idem |
| micro-task → decisions in scope | `technical_context.architecture.applies[].id` | `execution-context-template.yml` |
| micro-task → wave | `execution_order.wave_N`; `waves.{wave}.microtasks[]` | `microtasks-index-template.yml`; `waves.yml` |
| promised artifact → real artifact | `fidelity.declared_outputs[].declared` + `.exists` | `validation-report-template.yml` |
| evidence → micro-task | existence of the report + `summary.overall_status`, `loop.*` | idem |
| review → files read | `scope.files[].path` | `code-review-template.yml` |
| review → verified decision | `scope.architecture_decisions_in_scope`; `dimensions.architecture.decisions_checked[].result`; `findings[].violates` | idem |
| risk → features/micro-tasks | `affected_features[].id`; `feature_risks[].affected_microtasks` | `validation-risks-template.yml`; `microtasks-index-template.yml` |
| external dependency → micro-task | `dependencies[].microtask` + `resource` + `status` | `dependencies-template.yml` |
| learning → micro-task | path `{microtask-id}-learnings.yml` (by construction) | `mdpe-learnings/SKILL.md` |

Twenty declared links, zero traversed. The work of Phase 6 is not to create traceability: it is to
**read what is already written** and reject everything that is not.

### 1.4 Where the chain actually breaks (and the graph is what will show it)

Four real breaks, which the model has to address rather than paper over:

1. **Discovery features have no id.** `discovery-session-template.yml` records
   `personas_identified[].id` (`persona-001`), and `validation-risks-template.yml` records
   `hyp-value-001` / `risk-tech-001` — but the feature brainstorm produces counts
   (`features_identified: 15`, `features_must_have: 5`), **not ids**. A feature only gets an id once it
   enters the backlog (`feat-XXX`). So the discovery→feature edge exists at the **session**
   granularity, not the idea's. Inventing `df-001` to close the drawing would be fabricating a node.
2. **Micro-tasks do not declare `ad-NNN` before starting.** `mdpe-transformation/SKILL.md` instructs
   tracing work born from `derived_work` back to the decision (*"Trace it back to the `ad-NNN` in the
   task's origin"*), but `mdpe-microtask-template.yml` → `traceability` only has `feature_id`,
   `feature_name`, `strategic_context`, and `architectural_components`. **There is no field for the
   id.** The mt→ad edge only appears once the execution context is generated
   (`architecture.applies[].id`) — that is, late.
3. **Divergent execution artifact path (Gap 9.1).** `mdpe-execution-context/SKILL.md` writes
   `docs/execution/{microtask-id}-context.yml`; `mdpe-learnings/SKILL.md` and the
   `validation-report-template.yml` read from `docs/transformation/{feature-id}/execution/`. A graph
   that naively resolves paths reports an orphan where there is only a convention mismatch.
4. **`{id}-learnings.yml` and `aggregated-learnings.yml` have no template** (Gap 6.2, also named in
   ADR-004 block E). The learning node exists as a promised path, not as a known structure.

### 1.5 What the benchmark says about graphs

`docs/analysis/competitive-analysis.md` records three P1 adoptions and one uncomfortable finding:

- **A10 / OSpec 4.7** — *feature ↔ code locator*: sections declare a slug and code paths, a catalog
  keeps one line per feature, and a command returns the section. It is the "artifact/file" node with a
  real anchor, and the MDPE already has the raw material in `files` (inventory) and
  `generated_artifacts.location`.
- **A11 / OSpec 4.5 · TLC 5.10** — *graph that dispatches*: the loop reads the task graph and emits a
  safe parallel batch, **explaining what reduced parallelism**. The benchmark's observation about the
  MDPE is direct: *"OSpec and TLC have the dispatch, the MDPE has the computation — the two need to be
  connected"*.
- **A13 / Spec-Kit 1.4 · OSpec 4.9** — *cross-artifact consistency and drift audit*: listing the
  sections whose code paths changed since the last recorded change.
- **TLC 5.13** — composition with a neighboring diagram skill (`mermaid-studio`), with a **built-in
  fallback**. A model for "no mandatory tooling".

---

## 2. Decision

### D1 — The graph is a **derived projection**, and every edge carries provenance

The same inversion ADR-004 (D1) did for metrics, applied here to nodes and edges:

| | Before | From here on |
|---|---|---|
| Where the truth lives | in the per-feature `dependencies/*.yml`, with no view | still in the artifacts; the graph is a **view** |
| What the graph is | nonexistent | a **regenerable** artifact, never hand-edited |
| In case of divergence | — | **the artifact wins**; the graph is regenerated |

Hard rule, and the only one that matters: **a node or edge without an artifact + origin field does not
enter the graph.** There is no edge "by reasonable inference", nor a convenience node to close the
drawing. The only exception is the computed `impacts` edge (D5), which cites the chain of declared
edges that produced it — and is labeled as computed.

Corollary: if the graph is deleted, it must be reconstructible by reading the artifacts. Nothing is
born there.

### D2 — A dedicated `mdpe-graph` skill, not an eighth step in `mdpe-transformation`

Task 6.2 leaves the choice open and 6.4 calls for the skill. Decision: **a dedicated skill**, and both
tasks converge into it.

Reasons, in order of weight:

1. **Scope.** `mdpe-transformation` is per-feature; the traceability question 5 asks for is
   **cross-feature** (one feature does not know about the decisions another one raised, nor the
   learnings from another). A step inside transformation would be born nearsighted.
2. **Cadence.** Transformation runs once per feature; the graph is regenerated on every micro-task
   close, every new decision, and every impact question. Different frequencies, different artifacts.
3. **Cognitive cost.** `mdpe-transformation` already runs four phases plus the `tasks.md` generation
   step. A fifth concern would worsen Axis 7 — which Phase 8 is meant to fix.
4. **Inputs.** The graph reads discovery, inventory, backlog, decisions, transformation, execution,
   learnings, and tracking. None of these reads belong to decomposing a single feature.

What does **not** change: `mdpe-transformation` remains the one that computes `dependencies/*.yml`,
waves, and the critical path. `mdpe-graph` **does not recompute dependencies** — if it did, it would
become a second source, the very error ADR-004 D11 just removed.

**Path consequence:** the two templates go under `skills/mdpe-graph/assets/templates/` —
`traceability-graph-template.md` (6.2) and `waves-features-mermaid-template.md` (6.4). This deviates
from the primary destination noted in task 6.2 (`skills/mdpe-transformation/assets/templates/`) and
uses the alternative the task itself allows for ("or `skills/mdpe-graph/SKILL.md` + assets").
`mdpe-transformation/SKILL.md` only gets a **pointer** to "next skill", not a generation step.

### D3 — Two views, one canonical format, lazy creation

| View | File | Question it answers | Phase |
|---|---|---|---|
| **Traceability** (cross-cutting chain) | `docs/graph/traceability-graph.md` | where this came from, and how far it reached | 6.2 |
| **Waves × features** (execution) | `docs/graph/{feature-id}-waves.md` | what runs now, in what order, in parallel with what | 6.4 |
| **Queries** (impact, orphans, cycles) | sections of the traceability view, or `docs/graph/impact-{node-id}.md` for a recorded query | what changes if X changes | 6.3 |

Canonical format for each view: **Mermaid block + edge table with provenance**. The diagram is the
human reading; the table is the proof. An edge that is in the drawing and not in the table is a
fabricated edge — and the table is what the completion criterion (Section 3) checks.

Required table columns: `from` · `to` · `type` · `source artifact` · `field`. Nothing else is required.

**Lazy creation (A5):** the file is born when there is a graph to draw. Zero transformed micro-tasks →
**no file**, and the correct answer is "there is no graph to generate; run `mdpe-transformation` first"
(explicit positive scenario for 6.4). An empty graph file signals that a phase happened when it did not.

**Location:** `docs/graph/` in the consuming repository, in the same one-directory-per-topic pattern as
`docs/architecture/`, `docs/brownfield/`, `docs/backlog/`, `docs/tracking/`, `docs/learning-loops/`, and
`docs/transformation/`. It is one more top-level directory — cost recorded in Section 6, eventual
consolidation in 9.1.

### D4 — Node catalog

Eleven types. Each row carries **source (artifact → field)** and required/optional status. Without
both columns, the node does not exist (D1).

| Type | Id | Source: artifact → field | Requirement |
|---|---|---|---|
| `session` | `discovery-session-YYYYMMDD-NNN` | `docs/discovery/00-discovery-session-complete.yml` → `metadata.id` | conditional (greenfield with discovery) |
| `persona` | `persona-NNN` | `docs/discovery/00-discovery-session-complete.yml` → `personas_identified[].id` (detail in `02-persona-identification.yml`) | optional |
| `hypothesis` | `hyp-{type}-NNN` | `docs/discovery/05-validation-risks.yml` → `hypotheses[].id` | optional |
| `risk` | `risk-{cat}-NNN` · `risk-feat-XXX-NNN` | `05-validation-risks.yml` → `risks[].id`; `microtasks-index.yml` → `feature_risks[].id` | optional |
| `code_feature` | `cf-NNN` | `docs/brownfield/inventory.md` §4 → `id` | conditional (brownfield) |
| `feature` | `feat-XXX` | `docs/backlog/backlog-index.yml`, `features/feat-XXX.yml` → `id` | **required** when a backlog exists |
| `decision` | `ad-NNN` | `docs/architecture/decisions.yml` → `decisions[].id` | **required** when the file exists |
| `microtask` | `mt-XXX-YYY` | `microtasks-index.yml` → `microtasks[].id`; `microtasks/mt-XXX-YYY.yml` | **required** |
| `artifact` | the repo-relative **path** (D6) | contract: `output.generated_artifacts[].location` · reality: `{id}-validation.yml` → `fidelity.declared_outputs[].declared/.exists` · review: `{id}-code-review.yml` → `scope.files[].path` · brownfield: inventory §4 `files` | **required** for tracing down to file level |
| `evidence` | `{mt-id}:validation` · `{mt-id}:review` | existence of `{id}-validation.yml` / `{id}-code-review.yml` + `summary.overall_status` / `verdict` | conditional (only after execution) |
| `learning` | `{mt-id}:learnings` | `{id}-learnings.yml`; `docs/learning-loops/aggregated-learnings.yml` | conditional — **no template today** (Gap 6.2) |
| `external` | `ext:{resource-slug}` | `dependencies/external-dependencies.yml` → `dependencies[].resource`, `.type`, `.status` | conditional |

**`wave` is not a node, it is a grouping.** `waves.yml` → `waves.{key}` and `microtasks-index.yml` →
`execution_order.wave_N` become a `subgraph` in Mermaid and a `wave` attribute on the micro-task node.
Wave as a node would create artificial mt→wave→mt edges that no artifact declares.

**Node attributes** (only what is already declared, nothing computed separately): micro-task carries
`category`, `architectural_layer`, `estimate.total_time`, `wave`, `level` (from `full-graph.yml`), and
reconciled `status` (ADR-004 D6); decision carries `type` and `status`; feature carries MoSCoW;
artifact carries `exists`; `cf-NNN` carries `confidence`.

**Two deliberate omissions.** There is no acceptance-criterion node (`quality_criteria[]` and
`acceptance_criteria` are lists **without an id** — see alternative (f)) and no pre-backlog "feature
idea" node (§1.4 item 1). Criterion coverage is measured by the `validation-report`
(`acceptance_criteria.coverage`) and by the ADR-004 metrics (B1-B3), where it is already checkable.

### D5 — Edge catalog

Nine types: the six requested by task 6.1 plus three named and justified additions. A single computed
one.

| Type | Semantics | From → To | Source: field |
|---|---|---|---|
| `derives-from` | provenance: exists because of | `feat` → `session` · `feat` → `cf` · `mt` → `feat` · `ad` → driver (`feat` \| `cf` \| `risk` \| inventory) · `learning` → `mt` | `metadata.discovery_session_id`; `traceability.feature_origin[].source`; `origin: cf-NNN`; `traceability.feature_id`; `drivers[].source` + `.evidence`; learnings file name |
| `depends-on` | execution order · attribute **`strength: hard \| soft \| external`** | `mt` → `mt` · `mt` → `external` | `hard-dependencies.yml` / `soft-dependencies.yml` (`source`, `target`, `reason`); `external-dependencies.yml` (`microtask`, `resource`); checked against `full-graph.yml` (`upstream_*`/`downstream_*`) |
| `implements` | fulfills / is governed by a decision | `mt` → `ad` | `{id}-context.yml` → `technical_context.architecture.applies[].id`; `{id}-code-review.yml` → `scope.architecture_decisions_in_scope`; `traceability.origin_decisions` (D13) |
| `produces` | **addition** — without it, the artifact node has no incoming edge | `mt` → `artifact` | `output.generated_artifacts[].location`; `fidelity.declared_outputs[].declared` |
| `validates` | verifies, with a result · attribute `result` | `evidence` → `mt` · `evidence` → `artifact` · `evidence` → `ad` | `summary.overall_status`; `fidelity.declared_outputs[].exists`; `dimensions.architecture.decisions_checked[].result`; `findings[].violates` (`result: violated`) |
| `learned-from` | lesson extracted from | `learning` → `evidence` · `learning` → `ad` (when the lesson collides with a decision) | `{id}-learnings.yml`; `aggregated-learnings.yml` |
| `supersedes` | **addition** — decision revision (ADR-002 D9) | `ad` → `ad` | `supersedes` / `superseded_by` |
| `affects` | **addition** — risk/hypothesis over scope | `risk` → `feat` \| `mt` · `hypothesis` → `feat` | `affected_features[].id`; `feature_risks[].affected_microtasks`; `related_features[].id` |
| `impacts` | **the only COMPUTED one**: reach of a change | any → any | has no field of its own: it is the transitive closure of `depends-on(hard)` ∪ `implements`⁻¹ ∪ `produces` ∪ `derives-from`⁻¹, and **cites the chain** that produced it |

Three edge rules:

1. **`impacts` is never declared, and never appears without the chain.** An impact answer without the
   declared nodes and edges that support it is rejected (negative scenario for 6.3).
2. **`depends-on` with `strength: soft` and `external` enters the graph.** Ignoring them is the other
   negative scenario for 6.3: a soft dependency does not block, but changes order; an external one with
   `status: in_development` is a dispatch risk.
3. **A duplicated edge from two sources does not become two edges.** Precedence: the artifact closest
   to execution wins (review > validation > context > contract). The discarded source is recorded when
   it **disagrees** — divergence is a drift signal (D9), not a merge detail.

### D6 — Identity: ids belong to the artifacts; the path is the file's id

- The graph **does not create ids**. It uses `feat-XXX`, `mt-XXX-YYY`, `ad-NNN`, `cf-NNN`,
  `persona-NNN`, `hyp-*`, `risk-*`, and the session id. A synthetic id would be a node without a source
  (D1).
- **The artifact node has the normalized repo-relative path as its id** (A10 / OSpec 4.7): the path is
  the natural key and is what gets checked. No `ar-001`, no parallel slug.
- **Never renumber.** `ad-NNN` is already declared stable and referenced by the graph
  (`architecture-decisions-template.yml`, instruction 2). The same applies to `mt` and `feat`.
- **Resolving the execution artifact path** (§1.4 item 3): search **both** declared locations —
  `docs/transformation/{feature-id}/execution/` and `docs/execution/` — record **where it was found**,
  and issue a path-reconciliation pending item when it is not the canonical one. The graph **never
  silently repoints anything** and does not count a convention mismatch as an orphan. This pending
  item is the operational evidence of Gap 9.1 for task 9.1.
- **A declared but nonexistent path is not omitted**: it enters as an `artifact` node with
  `exists: false`, flagged as drift (D9). Omitting it would hide the fidelity failure that ADR-003
  (D7.2) is specifically meant to reject.

### D7 — The five use cases, with operational definitions

Each with input, output, and what it rejects. These are the contract that 6.2 and 6.3 implement.

**(1) Visualize.** Input: `microtasks-index.yml`, `waves.yml`, `critical-path.yml`,
`dependencies/*.yml`, `backlog-index.yml`, `decisions.yml`. Output: Mermaid + edge table. Rejects: a
node/edge without provenance; Mermaid that does not render.

**(2) Critical path.** **Read**, not recomputed: `critical-path.yml` → `sequence[]` and
`total_time`. The graph marks the nodes in the sequence and draws the edges between them with a
distinct stroke (D8). Rejects: a critical path "deduced" by the graph diverging from the artifact
without flagging the divergence.

**(3) Impact analysis (downstream).** Given a change in a node, list the reach via `impacts`
(D5), separating: **hard** (blocks), **soft** (changes order), **implements** (decision at stake →
`needs_architecture` route, ADR-003 D6), **produces** (files entering scope), **validates**
(evidence that needs to be redone). Output: list of affected nodes **with each one's edge chain**.
Rejects: an answer without the chain; an analysis that ignores soft/external.

**(4) Orphans.** Definition **by type**, because a generic "orphan" is not actionable:

| Orphan | Condition | Route |
|---|---|---|
| feature not decomposed | Must-Have `feat` with no `mt` referencing it | `mdpe-transformation` |
| micro-task with no decision in scope | `mt` with no `implements`, with context/review already generated | `mdpe-architecture` (this is ADR-004's C4) |
| decision with no work | `ad` `accepted` with no `mt` implementing it | revisit scope or decompose |
| promised artifact nonexistent | `artifact` with `exists: false` | fidelity failure (ADR-003 D7.2) |
| micro-task with no evidence | `mt` `completed` with no `evidence` node | reconciliation (ADR-004 D6) |
| `cf-NNN` not promoted | reconstructed feature with no `feat` and no `mt` | a conscious decision, not a defect |
| learning with no target | `learning` with no routed action | `mdpe-learnings` |

**(5) Cycles.** `depends-on(hard)` and `derives-from` **must** be acyclic. Where a cycle exists, the
graph reports the closed path node by node and routes to `mdpe-transformation` (re-decomposition).
`soft` in a cycle is reported as a warning — it does not block, but indicates undefined order.
`impacts`, being a transitive closure, is not evaluated for cycles.

### D8 — Readability and auto-sizing of the views (what Mermaid actually allows)

Technical decisions, because "generate Mermaid" without them produces a diagram that either does not
render or that no one reads:

- **Wave is a `subgraph`; feature is a style.** A Mermaid node belongs to **one** subgraph. Since wave
  and feature are cross-cutting groupings, the wave becomes the `subgraph` (it is the execution axis,
  and what 6.4 asks for) and the feature is expressed via `classDef` + an id prefix in the label. Trying
  to nest both produces an invalid diagram.
- **Stroke with fixed semantics:** `-->` hard · `-.->` soft and external · `==>` critical-path edge ·
  `classDef critical` on the nodes of the critical sequence. Avoid `linkStyle` by index: it breaks with
  every inserted edge.
- **Quoted labels, no HTML**, and the id is always the artifact's id. Unescaped parentheses, colons, and
  slashes in a label are the most common cause of Mermaid failing to render — and the `artifact` label
  contains a path.
- **Auto-sizing by size, not by fixed target** (TLC 5.1): up to ~40 nodes, a single view with artifacts;
  up to ~80, artifacts and evidence **collapsed** into a micro-task node attribute; above that, one view
  per feature plus a feature-level rollup. No minimum node target: 4 micro-tasks → 4 nodes.
- **The edge table is never collapsed.** When the diagram simplifies, the proof stays complete.

### D9 — Regeneration, timestamp, and drift audit

- **Regenerated, never hand-edited.** Editing the graph by hand turns it into a source — the opposite
  of D1. The header carries `generated_at` and the commit/branch read, the same way the brownfield
  inventory does with `verified_at`.
- **Regeneration triggers:** end of `mdpe-transformation` (new feature or new wave), a new or revised
  decision in `decisions.yml`, micro-task close (`mdpe-learnings`), and on demand for an impact query.
- **Drift audit (A13 / OSpec 4.9):** when regenerating, compare against the previous generation and
  list (i) any `artifact` that turned into `exists: false`, (ii) an edge that disappeared from the
  source, (iii) an `ad` `superseded` with an `mt` still pointing to it, (iv) a path declared elsewhere
  than where it was found (D6). Drift is **reported**, never fixed by inference.

### D10 — The graph dispatches, not just draws (A11)

Wave computation has existed all along and has never been used to decide anything. It now answers
**"what runs now"**: the micro-tasks in the smallest wave whose `depends-on(hard)` are closed
(reconciled status from tracking, ADR-004 D6), with the `external` ones in `available`.

And when the available parallelism is lower than what `parallelizable.yml` allows, **say why** — in
one line, citing the node: an open hard dependency, an unavailable external, or a `blocked` micro-task
with a route. This is the missing half for the MDPE according to the benchmark (OSpec 4.5):
*"OSpec and TLC have the dispatch, the MDPE has the computation"*.

Two explicit refusals: the graph **does not** trigger a subagent on its own (TLC 5.10 — offer and
confirm), and **does not** reorder waves. Order belongs to `mdpe-transformation`.

### D11 — No mandatory tooling

A direct lesson from Gap 4.1 and from ADR-004's stance (D5.6, D12):

- **Inline Mermaid is the minimum viable option** and it is sufficient: it renders in the repository's
  Markdown without installing anything.
- **Graphviz DOT is optional**, for those who want a large-graph layout; its absence invalidates
  nothing.
- No script, workflow, CLI, or layout tool is referenced in a template. If a graph tool ever exists,
  its role is **verifier** (it recomputes and returns nonzero on divergence), never a source — the same
  contract as ADR-004 D12.
- If a neighboring diagram skill is available, delegating is legitimate, with a **built-in fallback**
  to inline Mermaid (TLC 5.13). Composition is never a prerequisite.

### D12 — The graph is not a gate (but it does not loosen any existing gate)

- **Nothing in the graph approves, rejects, or releases anything.** Orphans, cross-cutting cycles, and
  drift are **a signal with a route** (D7, D9), like the `signals` in ADR-004 D10. The gates remain
  where they are: ADR-003 (evidence per dimension, loop limit), ADR-002 (blocking `drivers`),
  `mdpe-transformation` (7 criteria).
- **One exception that is not new:** the acyclicity of `depends-on` **is already** a quality gate of
  `mdpe-transformation` (Phase 2, `graph_validation`). That remains. What the unified graph adds is
  **cross-feature** cycle detection, which no one was checking — and that is reported and routed, not
  turned into a new gate.
- Reason, the same as ADR-004 D8: an orphan count written by the agent that generates the graph, if
  turned into a target, becomes something that gets suppressed. A sensor with an attached target
  measures the target.

### D13 — The only field addition, and the precedence of the `mt → ad` edge

Precedence for `implements` (§1.4 item 2):

1. `{id}-code-review.yml` → `scope.architecture_decisions_in_scope` (closest to execution);
2. `{id}-context.yml` → `technical_context.architecture.applies[].id`;
3. `decisions.yml` → `scope`/`scope_ref` covering the feature — edge at **feature** granularity
   (`ad → feat`), never promoted to micro-task by inference;
4. `traceability.origin_decisions: [ad-NNN]` in the micro-task contract — **new field, CONDITIONAL**.

Item 4 is the only field addition this ADR authorizes, and it is required **only** for micro-tasks born
from a `derived_work` implication (ADR-002 / `mdpe-transformation` Phase 1). Three reasons: the
instruction to trace already exists in `mdpe-transformation/SKILL.md` and has nowhere to be written;
without it, work created by a decision has no edge until the context is generated — that is, the
decision node looks orphaned exactly where it produced the most; and it is **conditional**, so it adds
no obligation to any ordinary micro-task (compatible with Phase 8, which reclassifies fields in 8.1).

The contract's `architectural_components` does **not** become an edge: it is a list of logical names
(`Domain/Aggregates/AggregateName`), not a verified path. An artifact node requires a real path (D4).

### D14 — Block G returned to Phase 5

ADR-004 (D4) reserved and **did not declare** four graph-dependent metrics. This ADR delivers the
source for each, class **D** (derived):

| Metric | Formula | Source |
|---|---|---|
| `orphans_count` | count per orphan type | D7 case (4) |
| `critical_path_length` | `total_time` and number of nodes in the sequence | `critical-path.yml` → `metadata.total_time`, `sequence[]` |
| `parallelism_available` | micro-tasks dispatchable now, and the reason for any reduction | D10 |
| `cycles_detected` | `hard`/`derives-from` cycles, including cross-feature | D7 case (5) |
| `drift_count` | items from the drift audit | D9 |

`scopes_without_decision` (ADR-004 C4) gets its structural counterpart here: `mt` with no `implements`
(D7, orphan type 2).

### D15 — Seams for the following phases

| Phase | What this ADR leaves ready |
|---|---|
| **6.2** | node/edge catalog (D4/D5), canonical format and rendering rules (D3/D8), decided skill (D2) |
| **6.3** | the five use cases with operational definitions, `impacts` as a transitive closure with cited chain, orphan types with routes (D7) |
| **6.4** | wave = `subgraph`, feature = `classDef`, stroke per edge type, behavior without `waves.yml` (D3 lazy creation, D8) |
| **7 — memory** | the graph is the **retrieval index**: `derives-from` and `learned-from` say which decisions and lessons are relevant to the node being worked on, answering the "when to read" from Gap 6.1; `learning` stays conditional until the templates exist (Gap 6.2) |
| **8 — anti-hallucination** | the graph adds no field (one conditional exception, D13) and is 100% derived; D1 is the strongest formulation of the anti-fabrication guideline applied to structure: **an edge with no origin field does not exist** |
| **9 — wiring** | the execution-path pending item (D6) is the evidence for Gap 9.1; `docs/graph/` enters the 9.1 path table; `mdpe-graph` enters the router and `mdpe-flow.md` in 9.2; the `feat → ad → mt → artifact → evidence` chain is the verifiable traceability that 9.1 requires |
| **5 — metrics** | block G with a source per row (D14) |

---

## 3. Completion criterion for the graph artifact ("honest graph")

A graph artifact is valid when **all** of the following hold:

- [ ] Every edge in the diagram is in the edge table, with **artifact + field** of origin.
- [ ] Every node has an id coming from an artifact (or is a real repo-relative path, for `artifact`).
- [ ] No synthetic id created by the graph (D6).
- [ ] `impacts` appears **only** as computed, citing the chain of declared edges.
- [ ] There is at least one edge of each type whose source artifacts exist — in particular
      `derives-from`, `implements`, and `produces`: a graph with only `depends-on` between micro-tasks
      is the negative scenario for 6.1 and is rejected.
- [ ] `soft` and `external` edges present when the artifacts declare them.
- [ ] Critical path **read** from `critical-path.yml`, not recomputed; divergence flagged.
- [ ] Waves reflect `waves.yml` / `execution_order`; no invented wave.
- [ ] Mermaid renders in the repository's Markdown (quoted labels, no HTML, one node per subgraph).
- [ ] `generated_at` + commit/branch in the header; no manual edits.
- [ ] A declared but nonexistent artifact path appears with `exists: false`, not omitted.
- [ ] No instruction points to a nonexistent script, workflow, CLI, or tool.
- [ ] No graph file created with no graph to draw (lazy creation).

**Operational test:** a transformed feature, with no micro-task yet executed, already produces a waves
view + `feat`/`mt`/`ad`/`artifact`(contract) nodes and `derives-from`/`depends-on`/`implements`/
`produces` edges — with no `evidence` or `learning` nodes, whose absence is the correct result.

---

## 4. Alternatives considered

### (a) Keep the per-feature `dependencies/*.yml`, with no unification — **rejected**

This is the baseline (score 2). The data remains correct and still answers none of the §1.2 questions.
It does not reach level 3 of Axis 5, which specifically requires the node/edge/source ADR.

### (b) Generation step inside `mdpe-transformation` — **rejected**

Zero wiring cost and it is the primary path noted in task 6.2. Rejected for the four reasons in D2,
with the greatest weight on the first: transformation is per-feature and the requested traceability is
cross-feature. A nearsighted step would again produce the single-feature micro-task drawing — the
explicit negative scenario for 6.1. Also, 6.4 asks for the skill; having both would create two graph
generators.

### (c) New unified graph YAML (`graph.yml`) as the canonical artifact — **rejected**

It looks like the "right" format for structured data, and it is the trap ADR-004 D11 just removed: it
would be a third representation of dependency, with no precedence rule against `full-graph.yml`, and
guaranteed drift. Markdown with Mermaid + table **is not a source**: it is a reading. The table gives
the rigor one would seek in YAML, and the diagram gives what YAML never did — someone actually looking.

### (d) Graph CLI/tooling (extractor + renderer) — **rejected**

Would solve generation once and for all. Rejected because (i) it repeats Gap 4.1 — this repository has
no sustainable place for a binary, and phase 9.x has not even decided where a tool would live; (ii) it
would make visualization depend on execution, when the minimum viable option is text; (iii) it inverts
D1, with the extractor becoming a source. Contract for a future tool: verifier, never source (D11).

### (e) Graph in an external tool (graph database, Neo4j, paid layout tool) — **rejected**

The literal negative scenario for 6.2. It also drops versioning: a graph outside the repository does
not enter the diff, does not survive a clone, and is not checkable in review.

### (f) Node per acceptance criterion (requirement ↔ test traceability in the graph) — **rejected**

Tempting, because it is the item where the benchmark scores the MDPE ◐ (requirement ↔ test ↔ file
traceability, TLC 5.9). Rejected for lack of a key: `quality_criteria.functional[]` and
`acceptance_criteria` are **lists of strings with no id** — a node would require creating a synthetic
id, forbidden by D1 and D6. Criterion coverage is already checkable where there is support:
`acceptance_criteria.coverage` in the `validation-report` and the ADR-004 B1-B3 metrics. Giving
criteria an id is a natural candidate for 9.1; it is not a prerequisite for Phase 6.

### (g) Derived graph, with a dedicated skill, inline Mermaid, and per-edge provenance (D1-D15) — **chosen**

Against rubric 1.2:

| Axis | Effect |
|---|---|
| **5 — Graphs** (2 → 3 here) | Level 3 asks exactly for "an ADR defining nodes/edges/sources and use cases (visualize, critical path, impact, orphans, cycles), without generation" — D4, D5, D7. Level 4 is fully contracted out to 6.2/6.4 (D3, D8) and level 5 to 6.3 (D7 cases 3-5) plus the seams with Phase 5 and Phase 7 (D14, D15). |
| **1 — Brownfield** | `cf-NNN` and the inventory's verified `files` become first-class nodes (D4), closing A10: reconstructed feature → real file → new micro-task. |
| **2 — Architecture** | `ad-NNN` stops being a textual reference and gets visible reach: `implements`, `supersedes`, and `validates(result: violated)` show which micro-tasks and files a decision governs — and orphan type 2 shows where it governs nothing. |
| **3 — Fidelity / loop** | `produces` + `validates` with `exists: false` make **visible** the fidelity failure that ADR-003 D7.2 rejects, and the `needs_architecture` route gets a map of what enters scope. |
| **4 — Metrics** | Delivers block G, which ADR-004 reserved and did not declare (D14). |
| **6 — Memory** | The graph is Phase 7's retrieval index: it answers "what is relevant to read now" by adjacency, instead of loading the entire memory. |
| **7 — Cognitive cost** | The graph **does not require a new field** (except one conditional, D13) and replaces reading seven YAMLs with a diagram; auto-sizing (D8) keeps the diagram from turning into a wall of text. |
| **8 — Hallucination** | D1 is the strongest formulation of the Phase 8 guideline applied to structure: an edge without an origin field **does not exist**. Computed and labeled `impacts` avoids the classic vector — the plausible-looking drawing. |
| Cost | One new skill (to be stitched in 9.2), two templates, one conditional field in `mdpe-microtask-template.yml`, one `docs/graph/` directory, and regeneration discipline. |

---

## 5. What is **NOT** required

Nothing below is a prerequisite for the graph to be valid, nor for any other phase to advance:

**Content:**

- `persona`, `hypothesis`, `risk`, and `external` nodes — optional/conditional.
- `evidence` and `learning` nodes before the micro-task executes and closes.
- `learning` node while `{id}-learnings.yml` and `aggregated-learnings.yml` have no template
  (Gap 6.2) — same conditionality as ADR-004 block E.
- Acceptance-criterion node and pre-backlog feature-idea node — **do not exist** (D4, alternative f).
- `wave` node — a wave is a grouping, not a node.
- `implements` edge for a micro-task with no decision in scope: the **absence** is the data (orphan
  type 2, `mdpe-architecture` sensor), not a gap to fill.
- `traceability.origin_decisions` on a micro-task that was not born from `derived_work`.
- A project-level graph when only one feature has been transformed: the waves view is enough.

**Format:**

- Graphviz DOT, layout tool, neighboring diagram skill, script, workflow, dashboard.
- A project view with artifact and evidence nodes once the graph passes ~40 nodes (collapsing is
  correct).
- A single diagram: above ~80 nodes, one view per feature plus a rollup is the right form.
- A minimum number of nodes, edges, or waves. 4 micro-tasks → 4 nodes.

**Process:**

- Periodic regeneration. Triggers are event-based (D9).
- A human opening, approving, or filling in the graph. Nothing blocks waiting for that.
- Recording an impact query to a file: answering in conversation is enough; `impact-{node}.md` only
  when someone wants it on record.
- Resolving drift, an orphan, or a cross-feature cycle for the graph to be valid — reporting and
  routing is enough (D12).

**General rule:** the absence of an item from this list never invalidates the graph. What invalidates
it is an edge with no origin field, a node with a synthetic id, `impacts` presented as declared, a
critical path or wave recomputed on its own, a nonexistent artifact omitted, Mermaid that does not
render, a hand-edited graph, a graph file created with no graph, and any instruction pointing to a tool
that does not exist.

---

## 6. Consequences

**Positive**

- Axis 5 goes from 2 to 3 with this ADR, and leaves 4 fully contracted out to 6.2/6.4. It closes Gaps
  5.1 and 5.2 through the same mechanism: unifying what exists and adding the cross-cutting links that
  were already declared in fields.
- **No new traceability needs to be invented.** The twenty links from §1.3 were already written; the
  cost of Phase 6 is reading, not instrumentation. That is what makes the phase cheap.
- The framework can now answer, with a citable chain, the four questions from §1.2 — including "if
  `ad-004` is revised, what comes into scope?", which today has no possible answer.
- Gives **use** to the wave computation that has existed since v0 and never decided anything (D10),
  closing the missing half according to the benchmark.
- Creates the MDPE's first mechanism that **detects inconsistency between artifacts** (A13): orphans by
  type, cross-feature cycles, and path drift. It is born already pointing at a real, known
  inconsistency (Gap 9.1) instead of hiding it.
- Adds no required field to any template. In a phase that delivers new structure, that is unusual — and
  it is what keeps Phase 8 possible.
- Delivers block G to ADR-004 without Phase 5 needing to be reopened.

**Negative / costs**

- **One more skill to stitch in.** `mdpe-graph` is the eleventh, and 9.2 has to put it in the router, in
  `mdpe-flow.md`, in `mapping-commands-to-skills.md`, and in the README, or it is born orphaned — the
  negative scenario for 9.2 itself.
- **Regeneration discipline is human.** Nothing stops the graph from aging silently; `generated_at`
  makes the aging visible, not impossible. A stale graph is worse than none, because it looks like
  truth.
- **The artifact node is inherently fragile.** A path changes with refactoring; until the drift audit
  runs, the graph points to a file that no longer exists. That is the price of using a path as a key
  (A10), and the alternative — a logical name — is not checkable.
- **The project view will get large.** Auto-sizing (D8) manages this, it does not solve it: on a
  project with many features, no one reads the whole diagram, and the value shifts to the table and to
  the 6.3 queries.
- **`docs/graph/` is one more top-level directory**, adding to `docs/architecture/`,
  `docs/brownfield/`, `docs/backlog/`, `docs/tracking/`, `docs/learning-loops/`,
  `docs/transformation/`, and `docs/adr/`. 9.1 may consolidate.
- **One new field, even if conditional** (D13), runs against Phase 8's direction and needs to enter the
  8.1 audit already classified as conditional.
- **Two accepted execution-artifact locations** (D6) is deliberate tolerance for a known inconsistency.
  If 9.1 does not standardize it, the tolerance fossilizes.
- **`learning` is born conditional**, so the final link of the chain stays partially drawn until Phase 7
  delivers the templates. A named pending item, not a hidden one.

**Neutral**

- No existing artifact is rewritten by this ADR. `mdpe-transformation` gets a next-skill pointer, not a
  step.
- `dependencies/*.yml` remain the dependency source, computed where it always was.
- Gates remain exactly where they were (D12); the graph observes and routes.
- Anyone who does not want a graph simply does not run the skill: nothing in the execution cycle
  depends on it.

---

## 7. Verification against task 6.1's test scenarios

| Scenario | Where it is satisfied |
|---|---|
| + The model defines node and edge types, each with the source (artifact/field) it comes from | D4 (11 node types, column *Source: artifact → field*) and D5 (9 edge types, column *Source: field*); D1 makes provenance a condition of existence; Section 3 makes it a condition of validity |
| + Covers the chain backlog → feature → microtask → architecture → artifact → learning | §1.3 inventories the 20 already-declared links; D4 gives a node to each stage (`session`/`cf` → `feature` → `microtask` → `decision` → `artifact` → `evidence` → `learning`); D5 gives the edges (`derives-from`, `implements`, `produces`, `validates`, `learned-from`); Section 3 requires ≥1 edge of `derives-from`, `implements`, and `produces` |
| + Defines the use cases (visualization, critical path, impact, orphans, cycles) | D7 — the five, each with input, output, and what it rejects; orphan defined **by type** with a route; cycles separating `hard`/`derives-from` (blocking) from `soft` (warning) |
| − A graph that only replicates dependencies between microtasks (no cross-cutting traceability) is rejected | D2 rejects the per-feature step for exactly this reason (alternative b); Section 3 rejects a graph with only `depends-on`; D4/D5 make `feature`, `decision`, `artifact`, `evidence`, and their edges part of the minimum when the artifacts exist |
| − A node or edge with no source derivable from an existing artifact is rejected | D1 (hard rule), D6 (ban on synthetic ids; real path as id), D5 rule 1 (`impacts` only computed, with cited chain), D4 (refusal of an acceptance-criterion node and a pre-backlog idea node for lack of an id), Section 3 (checklist) |

---

## 8. Sources

**Internal (read for this ADR):** `skills/mdpe-transformation/SKILL.md` (Phase 2: hard/soft/external,
waves, critical path, cycle detection, `parallelizable`; Phase 1: `derived_work` as a micro-task
candidate and the instruction to trace back to `ad-NNN`; `tasks.md` generation step) ·
`skills/mdpe-transformation/assets/templates/dependencies-template.yml` (7 files;
`full-graph.yml` with `upstream_hard/soft`, `downstream_hard/soft`, `level`, `wave`,
`convergence_points`, `graph_validation.cycles_detected`; `hard/soft` with `source`/`target`/`reason`;
`external-dependencies.yml` with `microtask`/`resource`/`status`/`criticality`; `waves.yml`;
`critical-path.yml` with `sequence[]` and `total_time`; `parallelizable.yml`) ·
`skills/mdpe-transformation/assets/templates/microtasks-index-template.yml`
(`microtasks[].dependencies_upstream/downstream`, `execution_order.wave_N`,
`dependency_graph.critical_path`, and the instruction *"use a visualization tool for the full graph"*,
`feature_risks[].affected_microtasks`) ·
`skills/mdpe-transformation/assets/templates/mdpe-microtask-template.yml` (`traceability.feature_id`,
`architectural_components`, `output.generated_artifacts[].location`, `quality_criteria` with no id) ·
`skills/mdpe-architecture/assets/templates/architecture-decisions-template.yml` (`ad-NNN` stable and
referenced by the traceability graph; `drivers[].source/evidence`; `scope`/`scope_ref`;
`implications[].type/consumed_by` including `derived_work`; `verification`; `supersedes`/`superseded_by`;
lazy creation) · `skills/mdpe-code-discovery/assets/templates/brownfield-inventory-template.md`
(§2 modules with `path`, §4 `cf-NNN` with verified `files` as a blocking field and `confidence`) ·
`skills/mdpe-execution-context/assets/templates/execution-context-template.yml`
(`architecture.applies[].id`, `*_source: ad-NNN`, `directory_structure[].source`,
`verification[].source`, `no_decision_in_scope`) ·
`skills/mdpe-execution-context/SKILL.md` (output at `docs/execution/{microtask-id}-context.yml`) ·
`skills/mdpe-coding/assets/templates/validation-report-template.yml`
(`fidelity.declared_outputs[].declared/.exists`, `out_of_scope_changes[].path`,
`acceptance_criteria.coverage`, `summary.overall_status`, `evidence.artifact`) ·
`skills/mdpe-coding/assets/templates/code-review-template.yml` (`scope.files[].path/change`,
`scope.architecture_decisions_in_scope`, `dimensions.architecture.decisions_checked[].result`,
`findings[].violates`, `verdict.open`) · `skills/mdpe-learnings/SKILL.md` (execution inputs from
`docs/transformation/{feature-id}/execution/`; outputs `{microtask-id}-learnings.yml` and
`docs/learning-loops/aggregated-learnings.yml`; three feedback targets) ·
`skills/mdpe-backlog/SKILL.md` and `assets/templates/cognitive-backlog-template.yml`
(`metadata.discovery_session_id`, `traceability.related_discovery_sessions[].id`,
`traceability.feature_origin[].source`, `feat-XXX`, MoSCoW, `acceptance_criteria` with no id) ·
`skills/mdpe-backlog-discovery/SKILL.md` and `assets/templates/discovery-session-template.yml`
(`metadata.id`, `personas_identified[].id`; brainstorm features **with no id**, only counts) ·
`skills/mdpe-backlog-discovery/assets/templates/validation-risks-template.yml` (`hyp-value-001`,
`risk-tech-001`, `related_features[].id`, `affected_features[].id`) ·
`docs/adr/adr-004-execution-metrics.md` (D1 derived projection; D5 integrity; D8 metric is not a gate;
D11 removal of `dependency_graph`; D12 tooling as verifier; block G reserved) ·
`docs/adr/adr-003-loop-engineering.md` (D6 escalation routes; D7 fidelity and output existence) ·
`docs/adr/adr-002-architecture-skill.md` (`ad-NNN`, typed implications, reentry as `revise`) ·
`docs/adr/adr-001-brownfield-discovery.md` (`cf-NNN`, promotion with `origin: cf-NNN`) ·
`docs/analysis/baseline-gap-map.md` (Gaps 5.1, 5.2, 6.2, 9.1) ·
`docs/analysis/evaluation-rubric.md` (Axis 5: anchors 0-5, baseline 2, target 4) ·
`docs/analysis/competitive-analysis.md` (4.5, 4.7, 4.9, 5.9, 5.10, 5.13; adoptions A5, A10, A11, A13;
Section 6 "where the MDPE is ahead", item 3).

**External:** OSpec — [clawplays/ospec](https://github.com/clawplays/ospec) (task graph that emits a
parallel batch and explains what reduced parallelism; feature ↔ code locator with declared paths;
drift audit by changed code path) · TLC Spec-Driven —
[SKILL.md v3.3.0](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md)
(auto-sizing by scope; composition with a diagram skill and fallback; offer and confirm before
dispatching) · Spec-Kit — [github/spec-kit](https://github.com/github/spec-kit) (cross-artifact
consistency analysis) · Mermaid — [flowchart and `subgraph` syntax](https://mermaid.js.org/syntax/flowchart.html)
(a node belongs to a single subgraph; `-->` / `-.->` / `==>`; `classDef`) ·
Graphviz — [graphviz.org](https://graphviz.org/) (DOT, adopted as optional).

> Content paraphrased from the sources for licensing compliance; URLs reused from
> `competitive-analysis.md` and from `tasks-v1.md`, verified on 28/08/2026.
