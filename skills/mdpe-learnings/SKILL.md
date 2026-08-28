---
name: mdpe-learnings
description: >-
  Closes the MDPE loop for a completed micro-task by extracting learnings (technical,
  process, strategic, problems), comparing expected vs achieved metrics, and routing
  actionable feedback to three targets - Discovery, Transformation, and next
  executions - each with a concrete action, owner, and horizon. Maintains an aggregated
  learnings file that makes the framework cognitive, and writes the execution tracking
  projection, whose metrics are derived from named fields of the validation report and
  code review and reconciled against those artifacts. Use after a micro-task is
  validated and reviewed. Not for implementing (mdpe-coding) or decomposing features
  (mdpe-transformation).
---

# MDPE Learnings

> **MDPE stage**: Execution — Propagate
> **Consolidates command**: EX-02 (Learnings Extraction)
> **Runs**: once per micro-task (aggregated across the project)

## Role

You are an MDPE Learning Curator. After a micro-task is done, you extract what was
learned and feed it back into earlier stages so the next tasks and cycles improve.
This is the "Propagate" step that makes MDPE a *cognitive* methodology rather than a
one-way pipeline.

## When to use / when not

**Use when:**
- A micro-task has been implemented, validated, and reviewed (`mdpe-coding` done).
- You want to aggregate learnings across tasks or feed insights into future cycles.

**Not for:**
- Implementing/validating code → `mdpe-coding`.
- Decomposing features → `mdpe-transformation`.

## Inputs

- The micro-task contract: `docs/transformation/{feature-id}/microtasks/{microtask-id}.yml`.
- `docs/transformation/{feature-id}/execution/{microtask-id}-validation.yml` — the loop, the
  criteria coverage, the fidelity block, the timestamps.
- `docs/transformation/{feature-id}/execution/{microtask-id}-code-review.yml` — findings,
  open counts, architectural conformance.
- The context and setup files of the micro-task (`-context.yml`, `-setup.yml`).
- `docs/transformation/{feature-id}/microtasks-index.yml` — for status reconciliation and the wave.
- The existing aggregated learnings file and `docs/tracking/mdpe-tracking.yml` (if any).

## Four learning types

1. **Technical** — patterns that worked, pitfalls, reusable solutions, stack/tooling insights.
2. **Process** — what helped or hindered flow: estimation accuracy, decomposition quality, context completeness.
3. **Strategic** — signals about feature value, user assumptions, or scope that affect the backlog/discovery.
4. **Problems** — blockers, defects, rework, and their root causes.

## Validated metrics (expected vs achieved)

Compare expected vs achieved and record the deltas — but read each number for what it is.
Decision of record: `docs/adr/adr-004-execution-metrics.md`.

**Measured (class D)** — read straight out of the artifacts, recomputable by anyone:
- Iterations to green and whether the loop overran (`validation` → `loop`).
- Acceptance criteria declared vs passing, and fidelity complete or not
  (`validation` → `acceptance_criteria.coverage`, `fidelity`).
- Verification coverage: how many criteria closed `not_verifiable`
  (`validation` → `summary.not_verifiable_count`).
- Open findings by severity and how many blockers/majors sent the task back
  (`code-review` → `verdict.open`, `findings[]`).
- Wall-clock span between the frozen verification plan and the closed review.

**Declared (class C)** — testimony, optional, never combined with a measured number:
- Estimated vs actual effort. Nothing in the framework timestamps effort, so this is what the
  executor reports and nothing confirms it.
- Predicted vs actual complexity, and any AERT mis-estimation (e.g., the task was not atomic).

Do not compute rework or attempts separately: they are **derived from the loop block**. Counting
them in parallel is how two files start disagreeing.

## Execution tracking (the derived projection)

At the close of each micro-task, update `docs/tracking/mdpe-tracking.yml` using
`assets/templates/mdpe-tracking.yml`. This is part of Propagate, not an optional extra.

The tracking is a **projection**: the source of truth is the execution artifacts. If the file were
deleted it must be rebuildable by reading them again. Six rules govern the write:

1. **Read before writing.** Open the validation report and the code review. Do not write from
   memory of the session.
2. **Reconcile, and let the artifact win.** A micro-task is `completed` only when the validation
   report closes `approved` / `approved_with_reservations` **and** the review verdict agrees; it is
   `blocked` only with a `root_cause_diagnosis` and a route. Divergence with an artifact is
   corrected in the same write. Divergence with `microtasks-index.yml` is recorded as a pendency,
   never resolved by deduction.
3. **Every number names a field.** If you cannot point at the artifact and the field it came from,
   the line does not exist. No composite scores. No unmeasured zero — an absent line, never `0`.
4. **Counts before ratios.** Ratios ship with the denominator written out, and only once 5
   micro-tasks have closed.
5. **Pointers, not copies.** Title, type, priority, dependencies and estimates stay in the
   contract. The micro-task enters the tracking when it **closes**, not when it is planned.
6. **No metric is a gate.** Nothing in the tracking approves, blocks or releases anything — the
   gates are in `mdpe-coding` (evidence per dimension, loop limit) and `mdpe-architecture`
   (blocking drivers). A blocked micro-task with a documented root cause is a correct outcome and
   makes no metric worse. The moment `iterations_to_green` becomes a target, the incentive turns to
   under-reporting it and the framework loses both the metric and the evidence.

Three signals may route work onward: an overrun goes to the route in its root-cause diagnosis; two
or more reviews with no architecture decision in scope call for a round of `mdpe-architecture`; two
or more environment aborts go to `mdpe-execution-context`.

No script, workflow or dashboard computes any of this. The agent recomputes it by reading
artifacts, and a human can check it with two files open.

## Feedback routing (the loops)

Route each learning to one of the **three feedback targets** with a concrete
recommended action:

| Target | Feeds | Example action |
|--------|-------|----------------|
| **Discovery** (`mdpe-discovery` / `mdpe-backlog`) | requirements, perceived value, new features, re-prioritization | revisit a hypothesis, value assumption, or risk |
| **Transformation** (`mdpe-transformation`) | decomposition calibration (too granular / too coarse), estimate adjustment, dependency mapping | adjust sizing heuristics; split a recurring big task type |
| **Next executions** (`mdpe-execution-context` / `mdpe-coding`) | context improvements, extra quality criteria, useful references | add a missing context dimension; tighten a quality check |

## Recommended actions

Classify actions by horizon: **immediate** (apply to the next task), **short term**
(this feature/cycle), **long term** (framework/backlog level). Each action has an
owner and a success signal.

## Outputs

- Per task: `docs/transformation/{feature-id}/execution/{microtask-id}-learnings.yml`
  (alongside the validation report and code review of the same micro-task).
- Aggregated: `docs/learning-loops/aggregated-learnings.yml` (updated each task).
- Tracking: `docs/tracking/mdpe-tracking.yml` — one file per project, versioned, updated at each
  micro-task close.

## Quality gate

- [ ] Learnings captured across the 4 types.
- [ ] Measured metrics read from the artifacts; declared metrics labelled as declared.
- [ ] Each learning routed to a target with a concrete action, owner, and horizon.
- [ ] Aggregated learnings file updated.
- [ ] Tracking updated: status reconciled against the artifacts, every number traceable to a
      field, no ratio without its denominator, no aggregate the file's own list cannot rebuild.

## Assets

- `assets/templates/mdpe-tracking.yml` — project-level execution tracking (derived projection).

## Next skill

- **Next micro-task** → `mdpe-execution-context`.
- **Next feature** → `mdpe-transformation`.
- **New strategic cycle** → `mdpe-discovery` (carry insights into the backlog via `mdpe-backlog`).
- Unsure where to go? → `mdpe-router`.
