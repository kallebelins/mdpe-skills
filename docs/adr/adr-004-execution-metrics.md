# ADR-004 — Minimum set of execution metrics and source of truth

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 28/08/2026 |
| **Origin task** | `tasks-v1.md` → Phase 5 → 5.1 |
| **Rubric axis** | Axis 4 — Measurability (baseline **1**, target **4**) |
| **Implemented by** | Task 5.2 (`mdpe-tracking.yml` + `mdpe-learnings/SKILL.md`) · consumed in 6.3 (orphans, critical path) and in 7.2 (recurring signatures) · reclassified in 8.1 · verified in 9.3 |
| **Associated adoptions** | A9 (metric derived from artifact, never from nonexistent tooling) · A5 (lazy creation) · A12 (embedded curation) · A11 (dispatching graph) |
| **Depends on** | ADR-003 (`loop` block, status vocabulary, and evidence contract are the primary source of the metrics) · ADR-002 (`ad-NNN` and `verification` as the source of architectural conformance metrics) |

---

## 1. Context

MDPE has a tracking artifact with **more metrics than sources**. The problem isn't lack of
measurement ambition: it's that almost nothing it declares can be recomputed from some field
of some artifact that the framework actually produces.

### 1.1 Phantom references: promised automation that doesn't exist

`skills/mdpe-learnings/assets/templates/mdpe-tracking.yml` instructs, in the *USAGE INSTRUCTIONS* section:

- `python3 tools/mdpe-status.py update --task MT-XXX --status done` (§3)
- `python3 tools/mdpe-status.py report --by-executor / --bottlenecks` (§4)
- *"Workflow updates automatically when a PR is merged. See: `.github/workflows/mdpe-tracking-update.yml`"* (§5)
- `config.auto_calculations: [avg_completion_time, velocity_story_points, rejection_rate, blocker_duration]`
- `config.integrations.github.sync_on_pr_merge: true` and `config.integrations.slack.notify_on_events`
- `blocker_duration: "3h"  # calculated automatically` (MT-004)

**None of these artifacts exist in the repository** (gap-map Section C: search for `mdpe-status` → 0
results; search for `.github` → 0 results). This is Gap 4.1. The practical effect is worse than
absence: an agent reading the template concludes that automatic calculation exists and **recomputes
nothing**, leaving the metrics block exactly as the template delivered it.

### 1.2 The template's own example doesn't reconcile

This is the most direct evidence of Gap 4.2. In the same file:

| What the micro-task list shows | What the `metrics` block claims |
|---|---|
| 6 micro-tasks (MT-001 to MT-006) | `total_tasks: 15` |
| 2 with `status: done` (MT-001, MT-002) | `completed: 5` |
| — | `by_type` sums to 15 · `by_priority` sums to 15 |
| MT-006 with `validation_attempts: 1`, `rework_count: 1` | `rejection_rate: 0.17  # 1/6` — denominator 6, inconsistent with `completed: 5` and with `tasks_approved_first_try: 4 + tasks_rejected: 1 + tasks_rework: 1` |

The template **teaches how to write aggregates that the listed data doesn't support**. Whoever fills it
in reproduces the pattern: plausible numbers, with no verifiable origin.

### 1.3 Numbers with no formula and no source

| Field | Why it's not a metric |
|---|---|
| `quality_score: 0.90` / `0.95` / `avg_quality_score: 0.88, 0.92, 0.93` | No formula, no source field, no defined scale. It's opinion with two decimal places — the same defect as the `0` defaults in `validation-report-template.yml` that ADR-003 (D3.4) removed. |
| `velocity_story_points: 12` | No MDPE artifact records story points. It doesn't exist in `mdpe-microtask-template.yml`, nor in the backlog, nor in the index. |
| `avg_lead_time: "4.5h"` | Lead time requires a request date. No artifact records it. |
| `avg_cycle_time: "2.1h"` | Depends on `started_at`/`completed_at`, which no MDPE skill writes. |
| `progress_percentage: 60` (MT-003) | Self-declared progress percentage, with no possible measurement. |
| `code_lines_generated: 120` (MT-002) | No source, and with an inverted incentive: more lines is not more delivery. |
| `avg_blocker_resolution_time: "6h"` / `longest_blocker: "12h"` | ADR-003 gives a blocker a **route and root cause**, not a duration; nothing marks the end of a blocker. |
| `test_coverage: 0.85` / `test_coverage_avg: 0.82` | Coverage only exists **when the project measures it** — and ADR-003 (D3.4) prohibits unmeasured numbers and rejects coverage as a target. |

### 1.4 Contract duplication: two places, one truth

Per micro-task, the tracking re-declares `id`, `title`, `feature_origin`, `type`, `priority`,
`dependencies`, `artifacts`, and `effort_estimated` — all already present in
`docs/transformation/{feature-id}/microtasks/mt-XXX-YYY.yml` and in `microtasks-index.yml`. Duplication
without a precedence rule is **guaranteed drift**: in two weeks the two files disagree and nothing says
which one is authoritative. The same applies to `auto_checks_passed: [linting, unit_tests, coverage_80, security_scan]`
(MT-002), which summarizes without evidence the dimensions that `validation-report` records **with**
evidence, and to `validation_attempts` / `rework_count`, which today compete with ADR-003's `loop` block.

The tracking's `dependency_graph: nodes/edges` is the clearest case: it duplicates
`docs/transformation/{feature-id}/dependencies/full-graph.yml` in reduced form, and is exactly the data
that Phase 6 is going to unify (Gap 5.1).

### 1.5 The artifact measures a process that MDPE doesn't run

`team_members[].autonomy_level` (`L1_supervised`/`L2_assisted`/`L3_monitored`), `sprint`,
`events` with `daily_standup` and `attendance: 5`, `alerts` with hand-assigned severity, Slack
integration: this is **team sprint management** instrumentation, inherited from the artifact's origin
(`framework/12-gestao-paralela-humano-ia.md`, cited in the header). None of this derives from an MDPE
artifact, and none of it answers Phase 5's question — *how to measure the execution process*.

### 1.6 Identifier inconsistency

Tracking uses `MT-001` and `feature-001`. The rest of the framework uses `mt-XXX-YYY` (the format
declared in `mdpe-microtask-template.yml`: `mt-{feature-number}-{sequence}`) and `feat-XXX`. An
aggregated metric by id that doesn't match the contract's id is a metric that connects to nothing. Id
standardization belongs to task 9.1; the fix **in this file** belongs to 5.2, since it's the same file
being rewritten (the same stance ADR-003 took with the legacy `.txt` references).

### 1.7 What changed in our favor: real raw material now exists

ADR-003 created, for the first time, artifact fields that are **measurement, not assertion**:

- `loop.iterations_to_green`, `loop.limit`, `loop.overrun`, `loop.iterations[].outcome`, `loop.iterations[].failed[].dimension`
- `acceptance_criteria.coverage.{declared_in_contract, reported_here, passing, failing, not_verifiable}`
- `fidelity.criteria_coverage_complete`, `fidelity.declared_outputs[].exists`
- `summary.overall_status`, `summary.not_verifiable_count`, `root_cause_diagnosis.route`
- `verification_plan.frozen_at` and `metadata.validated_at` — **two real timestamps**, which
  close an execution interval without depending on an invented `started_at`
- in `code-review`: `verdict.open.{blockers,majors,minors,nitpicks}`, `findings[].severity`,
  `findings[].violates: ad-NNN`, `scope.architecture_decisions_in_scope`,
  `dimensions.architecture.decisions_checked[].result`, `metadata.reviewed_at`

ADR-003 (D13) already reserved this list for Phase 5. This ADR turns it into a catalog with formula,
source, class, and trigger — and cuts the rest.

External reference: OSpec persists execution metrics in an artifact (`execution-metrics.json`) and makes
metrics **distinguish complete, partial, and absent coverage** instead of presenting a single number
(competitive-analysis 4.4). This is adoption A9: a metric points to a source field; anything requiring a
script is optional or removed.

---

## 2. Decision

### D1 — The artifact is a **derived projection**; execution artifacts are the source of truth

Explicit inversion of the current model:

| | Today (implicit) | From here on |
|---|---|---|
| Where the truth lives | in tracking, updated by hand | in execution artifacts (`validation`, `code-review`, `learnings`, micro-task contract) |
| What tracking is | parallel primary record | **derived view**, recomputable at any time from the artifacts |
| In case of divergence | undefined | **the artifact wins**; tracking is corrected, never the other way around |

Hard consequence: **a metric that can't be recomputed by reading artifacts doesn't go into tracking.**
If tracking is deleted, it must be reconstructible — except for the declared block (D4, class C),
which is the only information born there.

### D2 — One file, per project, versioned: `docs/tracking/mdpe-tracking.yml`

Tracking is **cross-feature** (it's the only place that compares features against each other), so it
doesn't live inside `docs/transformation/{feature-id}/`. A dedicated directory, in the same
one-directory-per-subject pattern the framework already uses for project-level artifacts in the
consumer repository: `docs/architecture/decisions.yml` (ADR-002), `docs/brownfield/inventory.md` (ADR-001),
`docs/backlog/backlog-index.yml`, and `docs/learning-loops/aggregated-learnings.yml`
(`mdpe-learnings/SKILL.md`).

This replaces the *"project root or .mdpe/"* wording in the current header, which was never a decision.
The path standardization from Gap 9.1 covers the **per-feature** tree and doesn't affect this file.

### D3 — Three metric classes, marked in the artifact itself

The current template doesn't distinguish measurement from assertion. It now distinguishes, with the
class written next to each block:

| Class | Definition | Requirement | How it should be read |
|:--:|---|---|---|
| **D** — derived | recomputable from a field that is a count or is backed by evidence (ADR-003 D3) | **required when the source artifact exists** | measurement |
| **C** — declared | read from an artifact field that someone **asserts**, with no evidence to confirm it (actual effort, executor) | **optional** | testimony, not measurement |
| **M** — manual/external | requires information that MDPE doesn't produce (story points, team cadence, cost) | **out of scope**; doesn't appear in the artifact | — |

Reading rule, written in the template: **no class C number enters a formula with a class D number.**
Averaging `effort_actual` is not combined with `iterations_to_green` to produce an index — that would
be backing measurement with testimony.

### D4 — The minimum catalog

Each row carries a formula, source artifact, and field. Without these three columns, the metric doesn't
exist. `{id}` = `mt-XXX-YYY`; paths follow `docs/transformation/{feature-id}/execution/`.

#### Block A — Loop and rework · source: `{id}-validation.yml` · class D

| # | Metric | Formula | Source field |
|:--:|---|---|---|
| A1 | `iterations_to_green` | literal value, per micro-task | `loop.iterations_to_green` |
| A2 | `first_pass` | count of closed micro-tasks with `iterations_to_green == "i1"`, **over** the total closed | `loop.iterations_to_green` |
| A3 | `overrun` | count of `loop.overrun: true` | `loop.overrun` |
| A4 | `blocked_by_route` | count of `overall_status == blocked`, grouped by route | `summary.overall_status` + `root_cause_diagnosis.route` |
| A5 | `environment_aborts` | count of iterations with `outcome: environment` | `loop.iterations[].outcome` |
| A6 | `failures_by_dimension` | count by dimension that failed in any iteration | `loop.iterations[].failed[].dimension` |
| A7 | `repeated_symptom` | count of micro-tasks with `root_cause_diagnosis` present | existence of the `root_cause_diagnosis` block |

A2 replaces `rejection_rate`; A7 replaces `validation_attempts` and `rework_count`, which become
**derived from the loop** instead of being counted in parallel.

#### Block B — Fidelity and verification coverage · source: `{id}-validation.yml` · class D

| # | Metric | Formula | Source field |
|:--:|---|---|---|
| B1 | `criteria_declared` / `criteria_passing` | literal values, per micro-task | `acceptance_criteria.coverage.declared_in_contract` · `.passing` |
| B2 | `fidelity_complete` | `criteria_coverage_complete == true` **and** every `declared_outputs[].exists == true` | `fidelity.*` |
| B3 | `not_verifiable` | sum of `not_verifiable_count` | `summary.not_verifiable_count` |
| B4 | `coverage_when_measured` | **optional**: recorded only when the evidence brought the number | `automated_tests.metrics.line_coverage` |

B3 measures **verification coverage, not quality** (ADR-003 D13). A high `not_verifiable` is a request
for tooling or authorization, not a code defect — and it's the sensor that prevents `not_verifiable`
from becoming an escape hatch. B4 is the only external quality numeric metric admitted, and it's
**optional by construction**: without measurement, the row doesn't exist (ADR-003 D3, rule 4).

#### Block C — Review and architectural conformance · source: `{id}-code-review.yml` · class D

| # | Metric | Formula | Source field |
|:--:|---|---|---|
| C1 | `open_findings` | counts by severity, at closure | `verdict.open.{blockers,majors,minors,nitpicks}` |
| C2 | `review_returns` | count of `blocker`/`major` findings with `resolved: true` (each one consumed an iteration — rule 4 of the review template) | `findings[].severity` + `.resolved` |
| C3 | `architecture_violations` | count of findings with `violates` filled in, grouped by `ad-NNN` | `findings[].violates` |
| C4 | `scopes_without_decision` | count of reviews with `architecture_decisions_in_scope: []` | `scope.architecture_decisions_in_scope` |
| C5 | `decision_checks` | decision check results, grouped by `result` | `dimensions.architecture.decisions_checked[].result` |

C4 and C5 are the metric Axis 2 was missing: C4 says **how much code was reviewed with no written
baseline** (a trigger for an `mdpe-architecture` round), and C5 says whether decisions' `verification`
field is actually being executed or merely declared.

#### Block D — Flow · source: real timestamps · class D

| # | Metric | Formula | Source field |
|:--:|---|---|---|
| D1 | `execution_span` | `metadata.validated_at` − `verification_plan.frozen_at` | `{id}-validation.yml` |
| D2 | `closure_span` | `metadata.reviewed_at` − `verification_plan.frozen_at` | `{id}-code-review.yml` + `{id}-validation.yml` |
| D3 | `throughput` | count of micro-tasks closed per period, dated by `validated_at` | `{id}-validation.yml` |
| D4 | `status_reconciled` | count by status, **derived from artifact existence and verdict**, reconciled against the index (D6) | artifacts + `microtasks-index.yml` → `summary.overall_status` |

D1/D2 replace `avg_cycle_time` and `avg_lead_time`: they measure the interval the process **actually
stamps** (frozen plan → green → closed review). It's wall-clock time, not effort — and the template
states this on the line, so no one reads it as person-hours.

#### Block E — Propagation · source: learnings artifacts · class D, **conditional**

| # | Metric | Formula | Source field |
|:--:|---|---|---|
| E1 | `learnings_by_target` | count of recommended actions by target (Discovery · Transformation · Next executions) | `{id}-learnings.yml` |
| E2 | `recurring_signatures` | `root_cause_diagnosis.symptom` signature repeated in ≥ 2 micro-tasks | `{id}-validation.yml` + `aggregated-learnings.yml` |

**Conditional for a declared reason:** `{id}-learnings.yml` and `aggregated-learnings.yml` are outputs
promised by `mdpe-learnings/SKILL.md` that **currently have no template** (gap-map Gap 6.2 and Section C).
Declaring E1/E2 as mandatory now would repeat exactly the error of Gap 4.1 — a metric anchored to a
nonexistent artifact. They stay on record, conditioned on the artifact's existence, and closing this gap
belongs to Phase 7 (7.2 / adoption A12). E2 is the raw material for the `candidate → confirmed` lesson.

#### Block F — Declared · class C · **optional**

| # | Field | Why it stays | Source |
|:--:|---|---|---|
| F1 | `executor` (`human` \| `ai` \| `hybrid`, `ai_tool`) | it's the **only** piece of valuable information that no other MDPE artifact records | declared at closure |
| F2 | `effort_actual` vs `estimate.total_time` | calibrates estimation; it's testimony, not measurement | `{id}-learnings.yml` vs micro-task `estimate.total_time` |
| F3 | `complexity_actual` vs `estimate.complexity` | calibrates decomposition | same |

The entire Block F is optional and **labeled as declared** in the template. Absence is a correct result.

#### Reserved for Phase 6 — declared here, **not** required

`orphans_count`, `critical_path_length`, `parallelism_available`, and `cycles_detected` are legitimate
process metrics and **depend on the unified graph that doesn't exist yet** (ADR-005, tasks 6.1-6.4).
They're named in this section of the ADR and **do not enter the template in 5.2**. When Phase 6 delivers
the graph, they enter as Block G, class D. Naming them here without declaring them there is the
difference between a roadmap and a phantom reference.

### D5 — Numeric integrity rules

Inherited from ADR-003 D3 and extended to the aggregate:

1. **No numeric defaults.** A metric with no measurement is an **absent row**, never `0`. A `0`
   presented as a measurement is false evidence.
2. **Count before ratio.** Every ratio is published with an explicit denominator
   (`first_pass: 4 of 7`), never as a bare percentage. With **fewer than 5 closed micro-tasks**, ratios
   are not published — only counts: a percentage over 2 items is theater.
3. **No aggregate without the items that compose it.** Every aggregate must be reconstructible
   from the micro-task list in the same file. This is the rule the current example violates (§1.2).
4. **No composite score.** No quality, health, or maturity index. A number that mixes
   dimensions hides which one moved — and that's how `quality_score` is born.
5. **`unknown` is a valid value.** Better than an estimate presented as a reading.
6. **No promised automatic calculation.** The one who recomputes is the agent reading artifacts (D6).
   No template instruction points to a script, workflow, or integration that doesn't exist.

### D6 — Frequency, owner, and reconciliation

Update is **event-driven, never periodic.** A periodic cadence with no tooling is a promise
nobody keeps — it's the origin of Gap 4.1.

| Write | When | Owner |
|---|---|---|
| Micro-task-derived block (A, B, C, D, E) | at **micro-task closure**, inside `mdpe-learnings` (*Propagate* step) | agent |
| Declared block (F) | at the same closure | whoever executed it (agent or person) |
| Feature aggregates | at the closure of the feature's **last** micro-task | agent |
| Reconciliation (D4/D6) | at **every** write | agent |
| Full recomputation | on demand, when someone asks for the number | agent |

**Reading:** human at any time; agent in Phase 6 (graph) and Phase 7 (memory). **Nothing in the
framework blocks waiting for a human to fill in tracking** — if no one opens the file, the execution
cycle keeps working.

**Reconciliation rule (the antidote to §1.2):** when writing, the agent checks status against the
artifact. A micro-task is only `completed` if `{id}-validation.yml` exists with `overall_status`
equal to `approved`/`approved_with_reservations` **and** `{id}-code-review.yml` has an equivalent
verdict. It's only `blocked` with a `root_cause_diagnosis` and a route. Divergence between tracking and
artifact: **the artifact wins**, and tracking is corrected in the same write. Divergence between
tracking and `microtasks-index.yml`: recorded as a reconciliation pending item — never resolved by
inference.

### D7 — No contract duplication: tracking holds a pointer, not a copy

Per micro-task, tracking carries **only**:

`id` · `feature_id` · artifact paths (`validation`, `code-review`, `learnings`) ·
reconciled `status` · the derived fields from Blocks A-E · the declared fields from Block F.

Removed because they're copies: `title`, `type`, `priority`, `dependencies`, `artifacts`, `effort_estimated`,
`auto_checks_passed`, `validation_attempts`, `rework_count`, `notes`. Whoever wants the title reads the
contract via the pointer. One truth, one place.

### D8 — No metric is a gate

Explicit rule, and the most important one in this ADR.

No number in this catalog approves, rejects, blocks, or releases anything. The gates are in
ADR-003 (evidence per dimension, dimensions 1 and 3 green, loop limit) and in ADR-002 (blocking
`drivers`). Tracking **observes**.

The reason is mechanical, not philosophical: `iterations_to_green` is written by the same agent who
closes the micro-task. The instant it becomes a target, the pressure shifts to **under-reporting
iterations** — and the framework loses both the metric and the evidence at once. The same applies to
`first_pass`, `not_verifiable`, `coverage_when_measured`, and `open_findings`: they're sensors, and a
sensor with an attached target measures the target instead.

Corollary: a `blocked` micro-task with a documented root cause **doesn't worsen** any metric. It's a
correct process outcome (ADR-003 D6), and tracking counts it as such.

### D9 — Aggregation axes: micro-task → feature → project (+ wave when applicable)

The unit is the **micro-task**. It aggregates by **feature** (the unit MDPE actually produces) and by
**project**. When `mdpe-transformation` generated waves, `wave` is a fourth axis — because a wave is the
framework's unit of parallelism.

`sprint` becomes an **optional** metadata field: those who use sprints aren't prevented from recording
one; no metric depends on it. `team_members`, `autonomy_level`, `events`, and `alerts` as currently
defined are removed (§1.5).

### D10 — Routing signals instead of alerts

`alerts` — a prose message with hand-assigned severity — is replaced by `signals`, **optional**,
where each signal cites a metric, a threshold, and a destination. A signal with no destination is
noise; three are enough as canonical:

| Condition | Signal | Destination |
|---|---|---|
| `overrun ≥ 1` | there's a stalled micro-task with a root cause and a pending route | the `root_cause_diagnosis` route |
| `scopes_without_decision ≥ 2` | code being reviewed with no written architectural baseline | `mdpe-architecture` round |
| `environment_aborts ≥ 2` | the environment is consuming the loop | `mdpe-execution-context` |

No other signal is suggested by the template. A catalog of generic alerts is the kind of content that
Phase 8 cuts.

### D11 — What is **removed** and why

| Removed | Reason |
|---|---|
| `quality_score`, `avg_quality_score` | number with no formula, no source, and no scale (§1.3); prohibited by D5.4 |
| `velocity_story_points` | no MDPE artifact has story points |
| `avg_lead_time` | requires a request date that nothing records |
| `avg_cycle_time`, `avg_completion_time` | depend on nonexistent `started_at`/`completed_at` → replaced by D1/D2 |
| `progress_percentage` | self-declared percentage, not measurable |
| `code_lines_generated` | no source, and with an inverted incentive |
| `test_coverage`, `test_coverage_avg` as fixed fields | become B4, optional, only when measured |
| `blocker_duration`, `avg_blocker_resolution_time`, `longest_blocker` | nothing marks the end of a blocker; ADR-003 gives a route, not a timer |
| `auto_checks_passed` | summarizes without evidence what `validation-report` records with evidence |
| `validation_attempts`, `rework_count` | duplicate the `loop` block → derived from A1/A7 |
| `dependency_graph: nodes/edges` | duplicates `dependencies/full-graph.yml`; the graph is Phase 6 (ADR-005) |
| `config.auto_calculations` | names calculations that nothing executes |
| `config.integrations` (github, slack) | nonexistent integrations |
| `config.auto_update: true` | asserts nonexistent automation |
| *USAGE INSTRUCTIONS* §3, §4, §5 | `tools/mdpe-status.py` and `.github/workflows/mdpe-tracking-update.yml` don't exist (§1.1) |
| §7 *Dashboard (Grafana/Metabase)* | external tool as instruction; becomes an optional note, if it stays |
| `events`, `alerts`, `team_members[].autonomy_level`, roster | team sprint management, not derivable (§1.5) → `alerts` replaced by D10 |
| ids `MT-001` / `feature-001` | replaced by `mt-XXX-YYY` / `feat-XXX` (§1.6) |

### D12 — Future work on record (not referenced in the template)

Task 5.2 gives two options for the phantom references: remove them, or record them as future work.
Decision: **remove from the template and record here**, which satisfies both without leaving a broken
pointer.

If metrics tooling ever exists, its contract is defined now, so it doesn't emerge as a parallel source:

- **Name/location:** decided when it exists; **nothing** in the framework references it before then.
- **Role:** *verifier*, not source. It reads the artifacts, recomputes the derived block, compares
  against tracking, and **returns nonzero on divergence**. It doesn't invent new metrics, doesn't write
  a number the agent couldn't derive by hand.
- **Requirement:** never mandatory. Tracking must remain fillable and checkable without it — the same
  reason ADR-003 rejected script-based gates (alternative c).
- **Prerequisite:** Phase 9 decides where tools live in this repository. That place doesn't exist
  today, and creating one now would repeat Gap 4.1.

### D13 — Seams for the following phases

| Phase | What this ADR leaves ready |
|---|---|
| **6** — graph | Block G named and **not declared** (orphans, critical path, parallelism, cycles); removing the duplicated `dependency_graph` clears the competitor for the unified graph; C3/C5 give the `ad-NNN → finding` edge |
| **7** — memory | E2 (`recurring_signatures`) is the raw material for `candidate → confirmed` (A12); A4 (`blocked_by_route`) says **which upstream stage** generates rework; E1 measures whether the three feedback loops are actually running |
| **8** — anti-hallucination | D3 (classes D/C/M), D5 (numeric integrity), D7 (end of duplication), and D11 (removals) enter the 8.1 audit already classified; the template shrinks instead of growing |
| **9** — wiring | ids `mt-XXX-YYY`/`feat-XXX` (§1.6) feed into 9.1's single standard; `docs/tracking/mdpe-tracking.yml` (D2) enters the path table; the criterion → evidence → metric chain closes 9.1's traceability |
| **3** — architecture | C4 (`scopes_without_decision`) is the first sensor that **demands** an `mdpe-architecture` round instead of letting the review guess the baseline |

---

## 3. Completion criteria for the metrics artifact ("honest tracking")

An `mdpe-tracking.yml` is valid when **all** of the following hold:

- [ ] Every present metric points to a source **artifact + field** and carries its class (**D**/**C**).
- [ ] No class **D** metric exists without the source artifact existing in the repository.
- [ ] No aggregate without the items that compose it in the same file (D5.3).
- [ ] No ratio without an explicit denominator; no ratio with fewer than 5 closed micro-tasks (D5.2).
- [ ] No numeric field left at default; no `0` that wasn't actually counted (D5.1).
- [ ] No composite score (D5.4).
- [ ] No instruction points to a nonexistent script, workflow, integration, or dashboard (D5.6).
- [ ] Each micro-task's status **reconciled** against the artifacts, with the artifact winning (D6).
- [ ] No field duplicates the micro-task contract (D7).
- [ ] Ids in the format `mt-XXX-YYY` / `feat-XXX`.
- [ ] Declared block (F) labeled as declared, and absent when there's no data.

**Fillable with a single real micro-task** is the operational test (5.2's positive scenario): a
closed micro-task produces A1-A7, B1-B3, C1-C5, D1-D4 — with no ratios, because the denominator is 1
(D5.2).

---

## 4. Alternatives considered

### (a) Keep the current tracking — **rejected**

This is the baseline (score 1). It keeps nonexistent automation as instruction (Gap 4.1), metrics with
no source (Gap 4.2), and an example that doesn't reconcile with its own data (§1.2). It doesn't even
reach level 2 of Axis 4, which requires that phantom references be at least **flagged**.

### (b) Build `tools/mdpe-status.py` now and keep the metrics as they are — **rejected**

This would solve Gap 4.1 from the other end. Rejected for three reasons, in order: (i) it doesn't solve
Gap 4.2 — no script can compute `quality_score` or `velocity_story_points`, because the data doesn't
exist in any artifact; (ii) it repeats the rejection already recorded in `competitive-analysis.md` §7
and in ADR-003 (alternative c) — MDPE **suffers** from tooling dependency, and v1 has no sustainable
place for binaries; (iii) it would invert D1, turning the script into the source and the artifacts into
supporting cast. The contract for a future tool is kept in D12: verifier, never source.

### (c) New `mdpe-metrics` skill — **rejected**

A metric has no input, output, or gate of its own: it's the closing step that `mdpe-learnings` already
performs (*Propagate*) and that already compares expected vs achieved. A separate skill would create an
eleventh skill to be wired into 9.2, would duplicate reading of the same artifacts, and would worsen
Axis 7 without raising Axis 4 — whose level 4 explicitly talks about `mdpe-tracking.yml`.

### (d) Metrics only inside each per-feature artifact, with no project file — **rejected**

Each `validation-report` already carries its own measurements, and it would be tempting to stop there.
But Phase 5's question is about the **process**, and process only shows up at the intersection:
`first_pass` across features, accumulated `blocked_by_route`, summed `scopes_without_decision`. Without
an aggregation point, every number stays locked in its own file and nobody compares anything.

### (e) Keep the ambitious metrics in the template, marked as "future" — **rejected**

This looks conciliatory and is exactly what 5.1 prohibits in the negative scenario. A field marked as
future inside a fill-in artifact gets filled in: the agent sees the key, doesn't read the comment.
Future belongs in the ADR and the backlog (D12 and Block G reserved in D4), not in the file someone is
going to fill out.

### (f) Keep `dependency_graph` in tracking until Phase 6 arrives — **rejected**

Keeping a reduced copy of the graph "for now" would guarantee that, once the unified graph arrives,
there would be two divergent representations and no precedence rule. Removed now; tracking
**references** `dependencies/full-graph.yml` by path and doesn't copy nodes or edges.

### (g) Tracking as a derived projection + minimum catalog with a source per metric (D1-D11) —
**chosen**

Against rubric 1.2:

| Axis | Effect |
|---|---|
| **4 — Measurability** (1 → 3 here, 4 in 5.2) | Level 3 literally asks for "ADR defines the minimum set, the source of each metric, and the automatic vs manual separation, without enforcing it" — D3, D4, D6. Level 4 (template only requires what's derivable; no instruction points to a nonexistent script) is fully contracted for 5.2, and level 5 depends on F6 (Block G) and F7 (E1/E2). |
| **3 — Fidelity / loop** | Gives **use** to what ADR-003 created: `iterations_to_green`, `overrun`, `not_verifiable_count`, and `coverage` stop being report fields and become process sensors. D8 protects evidence from turning into a target. |
| **8 — Hallucination** | Removes three vectors cataloged here and absent from the gap-map: a score with no formula (`quality_score`), an aggregate that doesn't reconcile with its own list (§1.2), and a self-declared percentage (`progress_percentage`). |
| **2 — Architecture** | C4/C5 are the framework's first architectural conformance sensor: it measures how much code was reviewed with no `ad-NNN` in scope and whether the `verification` field is actually executed. |
| **5 — Graphs** | Removes the competing `dependency_graph` and reserves Block G without declaring it, leaving F6 as the sole graph source. |
| **6 — Memory** | E2 and A4 hand F7 the recurring failure signature and the route distribution — the highest-value raw material for a lesson. |
| **7 — Cognitive cost** | Tracking **shrinks**: end of contract duplication (D7), end of roster/events/alerts (D9/D10), end of the automation blocks (D11). Fewer fields, more recomputable information. |
| Cost | No new skill; 1 template rewritten + 1 section in `mdpe-learnings/SKILL.md` in 5.2. The agent now **needs to reconcile** when closing a micro-task, which adds an artifact-reading step at closure. |

---

## 5. What is **NOT** required

Nothing below is a prerequisite for tracking to be valid, nor for closing a micro-task:

**Metrics:**

- The entire Block F (declared): `executor`, `effort_actual`, `complexity_actual`.
- `coverage_when_measured` (B4) — only exists when the project measures it; absence is normal.
- Block E (propagation) while the learnings artifacts have no template (Gap 6.2).
- Block G (orphans, critical path, parallelism, cycles) — arrives with Phase 6.
- Ratios and percentages with fewer than 5 closed micro-tasks: counts only.
- `signals` (D10) — and no signal beyond the three canonical ones.
- Blocker resolution time, blocker duration, average time of anything other than D1/D2.
- Story points, velocity, burndown, cost, tokens, lines of code.
- Quality, health, maturity, or composite index score of any kind — **prohibited**, not
  merely optional (D5.4).

**Measurement process:**

- Periodic cadence (daily, weekly, per sprint). Updates are event-driven (D6).
- A human filling in any field. The framework doesn't block waiting for tracking.
- Tooling, script, CI workflow, integration, or dashboard (D12).
- Meeting, standup, team event log, roster with autonomy level.
- `sprint` as a concept — optional (D9).

**The artifact:**

- A micro-task block for tasks not yet started: lazy creation (A5) — the micro-task enters
  tracking when it **closes**, not when it's planned. Whoever wants the plan reads `microtasks-index.yml`.
- Free-form note, observation, or comment per micro-task.
- A copy of any field the micro-task contract already declares (D7).

**General rule:** the absence of an item from this list never invalidates tracking. What invalidates it
is a metric with no source field, a class D metric with no source artifact, a numeric default presented
as a measurement, a ratio with no denominator, an aggregate the file's own list doesn't support, a
status not reconciled against the artifact, a composite score, and any instruction pointing to a tool
that doesn't exist.

---

## 6. Consequences

**Positive**

- Axis 4 goes from 1 to 3 with this ADR and enables level 4 in 5.2. It closes Gaps 4.1 and 4.2 from both
  ends: it removes the promised automation and gives every surviving metric a source field.
- The framework now has metrics **a human can check by hand** by opening two files. It's the
  first MDPE measurement artifact that doesn't depend on trusting whoever filled it in.
- It gives purpose to ADR-003's investment: `iterations_to_green`, `overrun`, `not_verifiable_count`,
  and the `coverage` block stop existing only for the record and start informing process decisions.
- It creates the first architectural conformance sensor (C4/C5), which **demands** an
  `mdpe-architecture` round instead of letting the review check against a nonexistent baseline.
- It removes three fabrication vectors the gap-map hadn't cataloged: a score with no formula, an
  aggregate that contradicts its own item list, and a self-declared progress percentage.
- It eliminates a source of structural drift (D7): tracking used to stop matching the micro-task
  contract within two weeks, with nothing saying which one was authoritative.
- It clears the duplicated graph out of Phase 6's path before it even starts.
- The artifact **shrinks** — rare for an ADR that adds contract. Fewer fields, and what remains is
  recomputable.

**Negative / costs**

- **Closing a micro-task gets more expensive.** `mdpe-learnings` now has to read the `validation-report`,
  the `code-review`, and the index to reconcile status. It's reading files that already exist, but it's
  work nobody does today.
- **Visibility that seemed to exist is lost.** No one sees "velocity 12" or "quality score 0.92" anymore.
  This will bother people who read those numbers as information. They were numbers with no source — the
  loss is of comfort, not of data, but the perception of regression is real and needs to be stated.
- **Effort metrics become fragile.** `effort_actual` is class C and optional; without it there's no
  estimate accuracy. Deliberate: no artifact stamps effort anywhere, and inventing one would create the
  next `quality_score`.
- **Block E is born conditional**, leaving the propagation axis only partially measured until Phase 7
  delivers the learnings templates. This is the honest choice, and it's visible as a named pending item.
- **The 5-item rule (D5.2) leaves small projects with no ratios.** A project with 3 closed micro-tasks
  will see only counts. Accepted: a percentage over 3 is worse than a count over 3.
- **D8 is a discipline, not a mechanism.** Nothing stops someone from turning `first_pass` into a team
  target; the ADR just records why that destroys the metric and the evidence along with it.
- **`docs/tracking/` is one more top-level directory** in the tree MDPE creates in the consumer
  repository, which already has `docs/architecture/`, `docs/brownfield/`, `docs/backlog/`,
  `docs/learning-loops/`, `docs/transformation/`, and `docs/adr/`. 9.1 may consolidate this when
  standardizing paths.

**Neutral**

- No artifact is created; one is rewritten (5.2). No new skill; one gains a closing step.
- Micro-tasks keep closing under ADR-003's rules — metrics don't participate in gates (D8).
- Anyone using sprints can keep recording sprints (D9), with nothing depending on it.
- The path `docs/tracking/mdpe-tracking.yml` replaces a suggestion (*"project root or .mdpe/"*) that was
  never a decision, so there's no legacy path to migrate.

---

## 7. Verification against task 5.1's test scenarios

| Scenario | Where it's addressed |
|---|---|
| + Every metric in the minimum set points to which artifact/field it's derived from | D4 — catalog with *Formula* and *Source field* columns in every block A-F; D5.6 and the completion criteria (Section 3) make this a validity condition |
| + Metrics not currently sustainable are marked optional or removed | D11 (removal table, one row per item, with reason) · D3 (class C = optional) · D4 Block E (conditional, with the gap named) · Block G (reserved, not declared) · B4 and all of Block F optional |
| + Defines update frequency and owner (agent vs human) | D6 — write/when/owner table, event-driven update at micro-task closure, human as reader only, plus the reconciliation rule |
| − Keeping a metric that depends on nonexistent tooling as "mandatory" fails | D5.6 and D11 remove `config.auto_calculations`, `config.integrations`, `auto_update`, and the §3/§4/§5 instructions citing `tools/mdpe-status.py` and `.github/workflows/mdpe-tracking-update.yml`; D12 records the tooling as future work **with no** reference in the template; D1 prevents any script from coming back as a source |
| − A metric with no formula/definition fails | D4 (formula required per row) · D5.1-D5.4 (no default, no ratio without denominator, no aggregate without items, no composite score) · D11 removes `quality_score` and `avg_quality_score`, which are exactly that defect |
| + Separate automatic metrics from manual ones | D3 — three classes (**D** derived, **C** declared, **M** external/out of scope), with the rule against mixing classes in the same formula |

---

## 8. Sources

**Internal (read for this ADR):** `skills/mdpe-learnings/assets/templates/mdpe-tracking.yml`
(`microtasks[]` MT-001 to MT-006 with `quality_score`, `progress_percentage`, `code_lines_generated`,
`auto_checks_passed`, `validation_attempts`, `rework_count`, `blocker_duration`; `metrics` block with
`total_tasks: 15` against 6 listed items, `throughput.velocity_story_points`, `avg_cycle_time`,
`avg_lead_time`, `quality.rejection_rate: 0.17 # 1/6`, `blockers.*`; `events`; `alerts`;
`dependency_graph: nodes/edges`; `config.integrations` and `config.auto_calculations`;
*USAGE INSTRUCTIONS* §3-§5 and §7) · `skills/mdpe-learnings/SKILL.md` (*Validated metrics — expected vs
achieved*; three feedback targets; outputs `docs/execution/{microtask-id}-learnings.yml` and
`docs/learning-loops/aggregated-learnings.yml`) ·
`skills/mdpe-coding/assets/templates/validation-report-template.yml` (`loop` block with
`iterations_to_green`/`limit`/`overrun`/`iterations[]`; `acceptance_criteria.coverage`; `fidelity`;
`summary.overall_status` and `not_verifiable_count`; `verification_plan.frozen_at`;
`metadata.validated_at`) · `skills/mdpe-coding/assets/templates/code-review-template.yml`
(`verdict.open.*`; `findings[].severity`/`.violates`/`.resolved`;
`scope.architecture_decisions_in_scope` and `no_decisions_note`;
`dimensions.architecture.decisions_checked[].result`; `metadata.reviewed_at`) ·
`skills/mdpe-transformation/assets/templates/mdpe-microtask-template.yml` (`estimate.total_time`,
`estimate.complexity`, `metadata.status`, id format `mt-{feature-number}-{sequence}`) ·
`skills/mdpe-transformation/assets/templates/microtasks-index-template.yml`
(`summary.overall_status`, `execution_order.wave_N`, `dependency_graph.critical_path`) ·
`skills/mdpe-architecture/assets/templates/architecture-decisions-template.yml` (`ad-NNN`,
`verification`, lazy creation) · `docs/adr/adr-003-loop-engineering.md` (D3 evidence contract
and end of numeric defaults; D4 status vocabulary; D5/D6 loop and routes; D13 metrics reserved
for Phase 5) · `docs/adr/adr-002-architecture-skill.md` (D5 `verification`, D9 integration with the
review) · `docs/analysis/baseline-gap-map.md` (Gaps 4.1, 4.2, 5.1, 6.2, 9.1; Sections B and C) ·
`docs/analysis/evaluation-rubric.md` (Axis 4 and anchors for Axes 2, 3, 5, 6, 7, 8) ·
`docs/analysis/competitive-analysis.md` (4.4 metrics persisted in an artifact; §7 adoptions A5, A9, A11,
A12, and the recorded rejections).

**External:** OSpec — [clawplays/ospec](https://github.com/clawplays/ospec)
(`execution-metrics.json` as a versioned artifact; metrics that distinguish complete, partial, and
absent coverage instead of a single number) · TLC Spec-Driven —
[SKILL.md v3.3.0](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md)
(verifiable evidence as the basis for the verdict, rather than a self-assigned score).

> Content paraphrased from the sources for licensing compliance; URLs reused from
> `competitive-analysis.md`, verified on 27/08/2026.
