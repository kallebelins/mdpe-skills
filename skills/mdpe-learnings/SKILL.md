---
name: mdpe-learnings
description: >-
  Closes the MDPE loop for a completed micro-task by extracting learnings (technical,
  process, strategic, problems), comparing expected vs achieved metrics, and routing
  actionable feedback to Discovery, Transformation, and next executions. Maintains
  an aggregated learnings file that makes the framework cognitive. Routes feedback to
  three targets: Discovery, Transformation, and next executions. Use after a
  micro-task is validated and reviewed. Not for implementing (mdpe-coding) or
  decomposing features (mdpe-transformation).
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

- The completed micro-task's artifacts: context, setup, validation report, code review.
- Original estimates and acceptance criteria (expected values).
- The existing aggregated learnings file (if any).

## Four learning types

1. **Technical** — patterns that worked, pitfalls, reusable solutions, stack/tooling insights.
2. **Process** — what helped or hindered flow: estimation accuracy, decomposition quality, context completeness.
3. **Strategic** — signals about feature value, user assumptions, or scope that affect the backlog/discovery.
4. **Problems** — blockers, defects, rework, and their root causes.

## Validated metrics (expected vs achieved)

For the micro-task, compare expected vs achieved and record deltas:
- Estimated vs actual effort/time.
- Predicted vs actual complexity.
- Acceptance criteria met on first pass? Rework count.
- Any AERT mis-estimation (e.g., task was not actually atomic).

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

- Per task: `docs/execution/{microtask-id}-learnings.yml`.
- Aggregated: `docs/learning-loops/aggregated-learnings.yml` (updated each task).

Optionally maintain project tracking via `assets/templates/mdpe-tracking.yml`.

## Quality gate

- [ ] Learnings captured across all 4 types.
- [ ] Expected vs achieved metrics recorded with deltas.
- [ ] Each learning routed to a target with a concrete action, owner, and horizon.
- [ ] Aggregated learnings file updated.

## Assets

- `assets/templates/mdpe-tracking.yml` — project-level tracking/aggregation.

## Next skill

- **Next micro-task** → `mdpe-execution-context`.
- **Next feature** → `mdpe-transformation`.
- **New strategic cycle** → `mdpe-discovery` (carry insights into the backlog via `mdpe-backlog`).
- Unsure where to go? → `mdpe-router`.
