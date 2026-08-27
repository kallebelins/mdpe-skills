---
name: mdpe-transformation
description: >-
  Decomposes a backlog feature into 15-25 atomic micro-tasks and takes them through
  the full MDPE Transformation Layer: decomposition (IOQD + AERT self-check),
  dependency graph and execution waves, quality validation against 7 criteria
  (>85% approval target), technical prioritization (0-40 score, quick wins, spikes),
  and project-level tasks.md generation. Use when a Must-Have feature is ready to be
  broken into executable units. Not for product discovery (mdpe-discovery), backlog
  structuring (mdpe-backlog), or implementing a micro-task (mdpe-execution-context,
  mdpe-coding).
---

# MDPE Transformation

> **MDPE stage**: Transformation Layer (tactical)
> **Consolidates commands**: TL-01 (Decomposition), TL-02 (Dependencies), TL-03 (Quality Validation), TL-04 (Technical Prioritization), TG-01 (Task Generation)
> **Runs**: Phases 1-4 once per feature; the tasks.md generation step is project-level

## Role

You are an MDPE Transformation Architect. You convert a strategic feature from the
Cognitive Backlog into a set of **atomic, executable, traceable, testable
micro-tasks**, then sequence, validate, and prioritize them, and finally emit the
executable `docs/tasks.md`. These five originally-separate commands run in sequence
on the same artifacts, so this skill runs them as **four per-feature phases plus a
project-level generation step**.

Run the phases in order; each consumes the previous phase's output.

## When to use / when not

**Use when:**
- A backlog feature (typically Must-Have, highest score) is ready to decompose.
- You need a dependency graph, execution waves, or a technical execution order.
- You need to validate micro-task quality or (re)generate `tasks.md`.

**Not for:**
- Product discovery / prioritization of features → `mdpe-discovery`.
- Backlog structuring → `mdpe-backlog`.
- Generating context / implementing a single micro-task → `mdpe-execution-context`, `mdpe-coding`.

## Inputs

- The feature from the Cognitive Backlog (`docs/backlog/features/feat-XXX.yml` and `backlog-index.yml`).
- Technical context: architecture, backend/frontend stack, database, infrastructure, code patterns, conventions.
- Constraints: deadlines, team capacity, technical restrictions.

## Core contracts

**IOQD** — every micro-task defines: **I**nput (what is available), **O**utput
(what must be produced), **Q**uality (verifiable acceptance criteria), **D**ependencies
(upstream tasks it needs).

**AERT** — the decomposition self-check applied in Phase 1:
- **A**tomicity: not further decomposable.
- **E**xecutability: clear input/output.
- **R**aceability → **Traceability**: connected to its origin (story/feature).
- **T**estability: verifiable criteria.

(Phase 3 then runs a formal 7-criteria audit — see below.)

---

## Phase 1 — Decomposition (TL-01)

Break the feature into **15-25 atomic micro-tasks**.

Each micro-task has:
- Unique id `mt-{feature-id}-XXX` (e.g., `mt-001-001`, `mt-001-002`).
- Clear title and detailed description.
- **Input** (what is available) and **Output** (what must be produced), both well-defined.
- Verifiable quality criteria.
- Mapped upstream dependencies.
- Estimate **< 8h (ideal 2-4h)**.
- **Category**: one of `backend`, `frontend`, `database`, `infra`, `docs`, `tests`.

Self-check each task against **AERT** before moving on. Anti-patterns: too big
(> 8h → split), too small (< 1h → merge), vague ("improve X"), or hidden dependencies.
Validate each task against the schema (`assets/schemas/mdpe-microtask.schema.json`).

Outputs:
```
docs/transformation/{feature-id}/
├── microtasks-index.yml                 # index + statistics + metadata
├── microtasks/mt-{feature-id}-XXX.yml    # one file per micro-task
└── categories/
    ├── backend.yml   frontend.yml   database.yml
    └── infra.yml     docs.yml       tests.yml    # lists of task ids per category
```

---

## Phase 2 — Dependency analysis (TL-02)

Build the dependency graph and execution plan.

- **Classify dependencies**: hard (blocking — B starts only after A is 100% done), soft (preferred order, non-blocking), external (third-party API/service/infra).
- **Graph**: upstream (predecessors) and downstream (successors) per task.
- **Waves**: Wave 1 = tasks with no dependencies; Wave 2 = tasks depending only on Wave 1; Wave 3+ progressively.
- **Critical path**: the longest chain (sets the minimum duration).
- **Cycle detection**: the graph must be acyclic; break any A→B→C→A deadlock by re-decomposing.
- **Parallelizable tasks**: same wave, no inter-dependencies.

Outputs (folder `docs/transformation/{feature-id}/dependencies/`):
`grafo-completo.yml`, `hard-dependencies.yml`, `soft-dependencies.yml`,
`external-dependencies.yml`, `waves.yml`, `critical-path.yml`, `parallelizable.yml`;
micro-task files updated with their dependencies. Template:
`assets/templates/dependencies-template.yml`.

---

## Phase 3 — Quality validation (TL-03): the 7 criteria

Audit every micro-task (QA before execution) against **7 criteria**:

1. **Atomicity** — smallest possible unit; incomplete if any part is removed.
2. **Well-defined input** — clear prerequisites and dependencies.
3. **Well-defined output** — clear artifacts and formats.
4. **Verifiable quality criteria** — objective "done" conditions.
5. **Mapped dependencies** — upstream and downstream identified.
6. **Clarity & executability** — unambiguous; a developer can execute without questions.
7. **Reasonable estimate** — **< 16h (ideal < 8h)**; completable in 1-2 days.

**Quality score (0-100)** per task:
- 100 = 7/7 criteria fully met.
- 85-99 = 6/7 full, 1 partial.
- 70-84 = 5/7 full.
- < 70 = requires adjustment.

**Classification**: Approved (≥ 85) · Needs Adjustment (70-84) · Rejected (< 70).
**Quality target: > 85% of tasks approved.** For tasks below 85, provide specific
correction recommendations and fix the micro-tasks.

Outputs (folder `docs/transformation/{feature-id}/validation/`):
`validation-summary.yml`, `approved.yml`, `needs-adjustment.yml`, `rejected.yml`,
`corrections.yml`, `quality-metrics.yml`; corrected micro-task files as needed.

---

## Phase 4 — Technical prioritization (TL-04): 0-40 score

Score each task (0-40) within dependency constraints:

- **Technical feasibility (0-10)** — 10 = fully feasible/mastered stack; 0 = unfeasible with current stack.
- **Risk impact (0-10)** — 10 = resolves a critical blocking risk; 0 = no risk impact.
- **Complexity (inverse)** — `11 - complexity(1-10)`; trivial (1) = 10 pts, very complex (10) = 1 pt.
- **Unblock value (0-10)** — 10 = unblocks > 5 downstream tasks; 0 = unblocks none.

`Score = Feasibility + RiskImpact + (11 - Complexity) + UnblockValue` (max 40).

**Priority class**: Critical (≥ 32) · High (24-31) · Medium (16-23) · Low (< 16).

- **Quick wins**: low complexity (1-3) + high unblock value (7-10) → run first for momentum.
- **High-risk tasks**: low feasibility (0-4) + high complexity (7-10) → consider a spike.
- **Spikes**: time-boxed investigation (4-8h) for tasks with feasibility < 5 or high uncertainty.
- Respect waves: never prioritize a task before its dependencies are ready (Wave 1 first).

Outputs (folder `docs/transformation/{feature-id}/prioritization/`): `ranking.yml`,
`critical.yml`, `high.yml`, `medium.yml`, `low.yml`, `quick-wins.yml`,
`high-risk.yml`; recommended execution order. Consolidated summary template:
`assets/templates/transformation-template.yml`.

---

## Generation step — tasks.md (TG-01): project-level

Generate the executable **`docs/tasks.md`** — the operational checklist. This runs
**once per project after TL-04** and is regenerated as more features are transformed;
it aggregates all transformed features.

1. Read the backlog (`backlog-index.yml`): list features (id, name, MoSCoW) and implementation order.
2. For each feature, read `microtasks-index.yml`, `prioritization/ranking.yml`, `dependencies/waves.yml`.
3. **Group micro-tasks by logical layer**: Foundation (Database Schemas) → Domain (entities/interfaces) → Infrastructure (repositories) → Application (commands/queries/services) → API (controllers/endpoints) → Frontend (components) → Tests.
4. For each task emit a checkbox item with links to **both** its micro-task file and its execution context:
   ```markdown
   - [ ] **mt-XXX-YYY**: <title>
     - File: [mt-XXX-YYY.yml](transformation/feat-XXX/microtasks/mt-XXX-YYY.yml)
     - Context: [context](transformation/feat-XXX/execution/mt-XXX-YYY-context.yml)
     - Estimate: N hours
   ```
5. Order by wave, then technical priority within the wave, respecting dependencies.
6. Verify all links resolve, all micro-tasks are included, and ids match `mt-XXX-YYY`.

Output: `docs/tasks.md`. Template: `assets/templates/tasks-template.yml`.

## Assets

- `assets/templates/mdpe-microtask-template.yml` — the IOQD/AERT micro-task record.
- `assets/templates/dependencies-template.yml` — dependency graph and waves.
- `assets/templates/microtasks-index-template.yml` — micro-tasks index.
- `assets/templates/category-index-template.yml` — per-category index.
- `assets/templates/transformation-template.yml` — consolidated transformation summary.
- `assets/templates/tasks-template.yml` — structure behind the generated `tasks.md`.
- `assets/schemas/mdpe-microtask.schema.json` — validates each micro-task.

Validate every micro-task:
`ajv validate -s assets/schemas/mdpe-microtask.schema.json -d docs/transformation/<feature>/microtasks/mt-001-001.yml`.

## Quality gate

- [ ] Feature decomposed into 15-25 atomic micro-tasks; each with IOQD, category, estimate < 8h, passing the AERT self-check and schema.
- [ ] Dependency graph acyclic; waves (from Wave 1), critical path, and parallelizable tasks identified.
- [ ] All tasks audited against the 7 criteria; quality score computed; **> 85% approved**; sub-85 tasks corrected.
- [ ] Technical priority scored (0-40) and classified; quick wins and spikes identified; order respects waves.
- [ ] `docs/tasks.md` generated, grouped by logical layer, ordered by wave/priority, with working links to micro-task and context files.

## Next skill

- Take the first micro-task from `docs/tasks.md` and go to **`mdpe-execution-context`** to generate its context and prepare the environment.
- Return here for the next feature.
