---
name: mdpe-learnings
description: >-
  Closes the MDPE loop for a completed micro-task by extracting learnings (technical,
  process, strategic, problems), comparing expected vs achieved metrics, and routing
  actionable feedback to three targets - Discovery, Transformation, and next
  executions - each with a concrete action, owner, and horizon. Owns the project's
  memory: a curated lesson register where a lesson moves candidate to confirmed only on
  repeated or heavy evidence and graduates out into a decision, a convention, or a
  skill; plus the derived read index other skills consult before deciding. Also writes
  the execution tracking projection, whose metrics are derived from named fields of the
  validation report and code review and reconciled against those artifacts. A clean
  close writes nothing. Use after a micro-task is validated and reviewed. Not for
  implementing (mdpe-coding) or decomposing features (mdpe-transformation).
---

# MDPE Learnings

> **MDPE stage**: Execution — Propagate
> **Decisions of record**: `docs/adr/adr-004-execution-metrics.md` (tracking) ·
> `docs/adr/adr-006-memory-model.md` (memory)
> **Consolidates command**: EX-02 (Learnings Extraction)
> **Runs**: once per micro-task (aggregated across the project)

## Role

You are an MDPE Learning Curator. After a micro-task is done, you extract what was
learned and feed it back into earlier stages so the next tasks and cycles improve.
This is the "Propagate" step that makes MDPE a *cognitive* methodology rather than a
one-way pipeline.

You are also the **owner of the project's memory**. Every other skill *reads* memory;
you are the only one that writes it. Two things separate memory from a logbook, and both
are your job: a **curation rule** that keeps the readable set short, and an **index**
cheap enough that the other skills actually open it.

**A clean close writes nothing.** A micro-task that finished on `i1` with no failed
dimension, no root-cause diagnosis, and no finding above Nitpick taught nothing.
No `-learnings.yml`, no lesson, no index churn. Recording the trivial success is how
the framework would produce volume without information.

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
- `docs/learning-loops/aggregated-learnings.yml` — the lesson register, to merge into rather
  than restart. Read the entries whose `signature` or statement could match; **never load it
  whole** (it holds `candidate` and `retired` entries that must not influence anything).
- `docs/tracking/mdpe-tracking.yml` (if any) — in particular
  `aggregates.project.propagation.recurring_signatures`, which is the raw material of a
  promotion.
- `docs/architecture/decisions.yml` (if any) — to check whether a lesson is ready to
  **graduate** into a decision, and whether a lesson's owning decision became `superseded`.

## Four learning types

1. **Technical** — patterns that worked, pitfalls, reusable solutions, stack/tooling insights.
2. **Process** — what helped or hindered flow: estimation accuracy, decomposition quality, context completeness.
3. **Strategic** — signals about feature value, user assumptions, or scope that affect the backlog/discovery.
4. **Problems** — blockers, defects, rework, and their root causes.

---

## Project memory: three layers, one owner

Decision of record: `docs/adr/adr-006-memory-model.md`.

Memory is not a new artifact — it is a **reading contract** over three layers, two of which
already existed before this skill owned any of them:

| Layer | Artifact | Written by | Your job |
|:--:|---|---|---|
| **C1** restrictions | `docs/architecture/decisions.yml` · `docs/brownfield/inventory.md` §3/§7 | `mdpe-architecture` · `mdpe-code-discovery` | read only; never edit |
| **C2** lessons | `docs/learning-loops/aggregated-learnings.yml` | **you** | write and curate |
| **C3** execution | `docs/tracking/mdpe-tracking.yml` | **you** | write (see below) |

Plus one **derived index**, `docs/memory/project-memory.yml`, which you **regenerate** (never
hand-edit). It carries a pointer plus one copied line per item — decisions in force,
conventions in force, confirmed lessons, open questions, staleness — and it is what the other
skills read before deciding. The full list of who reads which block is in
`assets/templates/project-memory-template.yml` → `usage.read_contract`.

Three rules govern all of it:

1. **Memory copies nothing from C1 or C3.** Whoever wants the decision reads `decisions.yml`;
   whoever wants the number reads the tracking. Duplicating here recreates the drift the
   tracking's pointer rule exists to prevent.
2. **Memory is not a source.** On divergence the precedence is
   **code > owner artifact > index**. A snapshot that disagrees with the repository is wrong
   by definition, and the index is regenerated — not patched to match.
3. **Memory is not a gate.** No lesson approves, blocks, or releases anything. The gates stay
   in `mdpe-coding` (evidence per dimension, loop limit), `mdpe-architecture` (blocking
   drivers), `mdpe-transformation` (7 criteria), `mdpe-code-discovery` (5 items). The moment
   "number of lessons" becomes a target, the incentive turns to fabricating them — and the
   layer built to reduce hallucination starts producing it.

And one prohibition that protects the loop contract: **a lesson is never evidence.** Nothing
in a validation report or a code review may be filled from a lesson. Evidence is a command
that ran with a result. A lesson can say *where to look*; never *what happened*.

### Curation: `candidate` → `confirmed` → `retired`

This is what keeps memory from growing without limit.

**Promotion to `confirmed`** — one of exactly two, never by judgement:

1. **≥2 occurrences** with `evidence[]` naming **distinct** micro-tasks. This is literally the
   tracking's `recurring_signatures`; or
2. **one occurrence of verifiable weight**: a `blocker` finding in the code review, or
   `loop.overrun: true` with a `root_cause_diagnosis`. A failure that stopped the loop does not
   need to repeat to count.

Outside those two the lesson stays `candidate` — **and a candidate never reaches the index, so
nobody reads it before deciding.** A candidate is an archived hypothesis, not advice.

**Graduation** — the exit, and the point of the whole mechanism. A confirmed lesson that became
a rule leaves memory and enters the artifact that governs it:

| The lesson became | Goes to | Then |
|---|---|---|
| an architecture rule or boundary | `decisions.yml`, as a decision with a driver and a `verification` | `status: retired`, `promoted_to: ad-NNN` |
| a code convention | a `conventions` implication of an `ad-NNN`, or inventory §3 when it is observed practice | `status: retired`, `promoted_to` filled |
| a framework process adjustment | a change in the skill itself | `status: retired`, `promoted_to` = the skill |

**Retirement without graduation:** a confirmed lesson whose owning decision became
`superseded`, or that has not reappeared in 10 closed micro-tasks, becomes `retired`
**with a reason**. A retired lesson leaves the index and **stays in the file** — deleting it
would destroy the evidence that the hypothesis was already considered.

So memory **does not grow, it graduates**. A mature project tends to hold few confirmed lessons
and many graduated ones. When the index grows past a screen, the signal is not "paginate it" —
it is that a confirmed lesson is due for graduation.

### Write triggers

Event-driven, never periodic. At the close of a micro-task, in one write:

| Artifact | Rule |
|---|---|
| `{microtask-id}-learnings.yml` | only when there **is** something to learn — a clean close produces no file |
| `aggregated-learnings.yml` | new lesson enters as `candidate`; an existing one gains an occurrence and is re-tested for promotion; graduation and retirement applied |
| `mdpe-tracking.yml` | as below |
| `docs/memory/project-memory.yml` | **regenerated** from the layers — confirmed lessons only |

`mdpe-architecture` regenerates the index when it accepts or revises a decision;
`mdpe-code-discovery` regenerates it when it (re)inventories. Nobody edits it by hand.

**Lazy creation.** No decisions, no inventory, and no closed micro-task → **no index file**,
and the correct answer to a memory read is *"there is no memory to consult"*.

---

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

| Artifact | Path | When |
|---|---|---|
| Per-task learnings | `docs/transformation/{feature-id}/execution/{microtask-id}-learnings.yml` | **only when there is something to learn** — a clean `i1` close produces no file |
| Lesson register (C2) | `docs/learning-loops/aggregated-learnings.yml` | at each close that produced a lesson; `ls-NNN` ids are sequential and never renumbered |
| Memory index | `docs/memory/project-memory.yml` | regenerated at each close, and by `mdpe-architecture` / `mdpe-code-discovery` at their own triggers. No layer to index → no file |
| Tracking (C3) | `docs/tracking/mdpe-tracking.yml` | one file per project, versioned, at each micro-task close |

## Quality gate

**Learnings and routing**

- [ ] Learnings captured across the 4 types **where they occurred** — the 4 types are a
      checklist of *where to look*, not a quota of four entries.
- [ ] Each learning routed to a target with a concrete action, owner, and horizon.
- [ ] Every lesson carries `evidence[]` naming a micro-task **and a field**. No evidence, no
      lesson.
- [ ] No lesson carries a severity, score, weight, or confidence number.
- [ ] A clean close produced **no** learnings file.

**Metrics and tracking**

- [ ] Measured metrics read from the artifacts; declared metrics labelled as declared.
- [ ] Tracking updated: status reconciled against the artifacts, every number traceable to a
      field, no ratio without its denominator, no aggregate the file's own list cannot rebuild.

**Memory**

- [ ] Register updated: new lessons entered as `candidate`; nothing is `confirmed` without
      satisfying one of the two promotion rules, and `promoted_by` records which one.
- [ ] Graduation and retirement checked; every retired entry has a reason, every graduated one a
      `promoted_to`. No retired lesson deleted.
- [ ] Index **regenerated**, not edited: every line names a `ref` and its source artifact,
      `metadata.repo_state` recorded, only `accepted` decisions and `confirmed` lessons present.
- [ ] Nothing authored in the index — no decision, convention, number, verdict, or generic
      principle written there for the first time.
- [ ] No lesson used as validation evidence, as a verification command, or as a gate.

**Not required** (full lists in `docs/adr/adr-004-execution-metrics.md` §5 and
`docs/adr/adr-006-memory-model.md` §5): a learnings file for a clean close, a lesson in each of
the four types, any minimum number of lessons, a `confirmed` lesson at all (zero is the normal
state of a new project), `applies_to` / `signature` / `promoted_to` / `superseded_by` when they
have no content, the `pitfalls[]` / `calibration[]` / `open_questions[]` / `staleness[]` / `next`
blocks of the index, the index itself when there is nothing to index, a JSON schema, a project
principles block, a lesson score, a steering file or any host integration, graduating a lesson
within a deadline, resolving a `staleness[]` or `open_questions[]` item, a human approving or
curating anything, and any script, workflow, dashboard, vector store or service. Their absence
never fails this gate.

## Assets

- `assets/templates/microtask-learnings-template.yml` — the per-micro-task learnings record
  (C2 input). Includes the lazy-creation rule and the `trigger` field that justifies the file
  existing at all.
- `assets/templates/aggregated-learnings-template.yml` — the project lesson register (C2), with
  the full `candidate` → `confirmed` → `retired` curation mechanism.
- `assets/templates/project-memory-template.yml` — the derived read index, with the
  regeneration order, the per-skill read contract, and the session resume contract.
- `assets/templates/mdpe-tracking.yml` — project-level execution tracking (derived projection).

## Next skill

- **Next micro-task** → `mdpe-execution-context`.
- **Next feature** → `mdpe-transformation`.
- **New strategic cycle** → `mdpe-discovery` (carry insights into the backlog via `mdpe-backlog`).
- **A confirmed lesson is ready to graduate into a rule** → `mdpe-architecture`, carrying the
  lesson's `evidence[]` as the driver. It comes back as an `ad-NNN` with a conferrable
  `verification`, and the lesson is then retired with `promoted_to`. That is the only way a
  lesson becomes enforceable — memory itself never gates anything.
- Unsure where to go? → `mdpe-router`.
