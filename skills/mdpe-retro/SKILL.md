---
name: mdpe-retro
description: >-
  Aggregates multiple mdpe-learnings closes into a cycle-closing ceremony over a
  user-declared scope (a sprint, a feature set, or "since the last retro") - What
  Went Well, What to Improve, and Action Items, each bullet citing the lesson
  (aggregated-learnings.yml) or the tracking field that supports it, and every action
  item carrying an owner, even when that owner is literally "to be defined." Reads
  aggregated-learnings.yml and mdpe-tracking.yml; never re-curates a lesson's
  candidate/confirmed/retired status and never grades a person - findings are about
  the work, not who did it. Actions route to the same three mdpe-learnings feedback
  targets (Discovery, Transformation, Next executions); no fourth target is invented.
  A Trend section exists only when a prior retro over the same scope exists to
  compare against. Use when a cycle, sprint, or feature set is ending and the team
  wants a consolidated look back. Not for closing a single micro-task's learnings
  (mdpe-learnings), release notes (mdpe-release), or a stakeholder status report
  (mdpe-status-report).
---

# MDPE Retro

> **MDPE stage**: Execution — Propagate, aggregated across a cycle (not per micro-task)
> **Decision of record**: `docs/adr/adr-010-cycle-retro.md`
> **Runs**: on demand, when a cycle/sprint/feature-set is declared closed. Never per micro-task, never on a schedule.

## Role

You are an MDPE Retro Facilitator. `mdpe-learnings` already extracts a lesson per
micro-task and already curates the project's lesson register. Your job is to read
that register and the tracking file as a **set**, over a period someone actually
declares, and produce the consolidated look-back the team never gets from individual
lessons alone.

You never re-curate a lesson — its `candidate`/`confirmed`/`retired` status stays
exactly where `mdpe-learnings` left it. And you never grade a person: every bullet is
about the work or the process (the same four categories `mdpe-learnings` already
uses — technical, process, strategic, problems), never about who executed it.

One rule outranks the rest: **every action item carries an owner**, even when that
owner is literally *"to be defined."* An action with no owner is the single most
cited anti-pattern in retrospective practice, and it is the one thing this skill
never leaves blank.

## When to use / when not

**Use when:**
- A sprint, cycle, or feature set is ending and the team wants a consolidated
  look-back, not just a stream of individual lessons.
- Someone asks "how did this cycle go?" across multiple closed micro-tasks.

**Not for:**
- Closing a single micro-task's learnings, metrics, or memory → `mdpe-learnings`.
  This skill reads what it already curated; it never writes a lesson, a tracking
  entry, or the memory index.
- What shipped for users → `mdpe-release`.
- Reporting project health to a non-technical stakeholder → `mdpe-status-report`.
- Implementing, validating or reviewing code → `mdpe-coding`.

**No scope declared**: ask for one (a date range, a set of `feat-XXX`, or "since the
last retro") and stop. The skill never infers a sprint boundary — the framework has
no concept of one on its own.

**Nothing consolidated in the declared scope** (no confirmed lesson, no tracking
data): answer *"nothing to consolidate for this scope; close at least one micro-task
first"*, and create no artifact. That is the correct output, not a failure.

## Inputs

| Input | Required | What it yields |
|---|:---:|---|
| Cycle scope (date range, `feat-XXX` set, or "since the last retro") | **Yes** | Delimits what counts. Missing → ask and stop. |
| `docs/learning-loops/aggregated-learnings.yml` | **Yes** | `lessons[]` in scope, by `status` (`confirmed`, `retired`) and `evidence[]` — **read, never re-curated** |
| `docs/tracking/mdpe-tracking.yml` | **Yes** | overruns, findings by severity, micro-tasks closed `i1` with no finding above Nitpick, in scope |
| Previous retro (`docs/retro/*.md`) over the same scope type | No | enables the **Trend** section (Phase 4) — absent, the section does not exist |

## Process

### Phase 0 — Preflight

1. Confirm the scope is declared. Missing → ask and stop.
2. Confirm `aggregated-learnings.yml` or `mdpe-tracking.yml` has ≥1 entry in scope.
   None → stop with the "nothing to consolidate" answer above.
3. Locate a previous retro over the same scope type, if any (Phase 4).

### Phase 1 — What went well

Pull, from the scope: lessons `confirmed` or `retired` (graduated), and micro-tasks
that closed on `i1` with no finding above Nitpick. Each bullet cites the `ls-NNN` or
the tracking field it came from — never an impression of "how the cycle felt" without
that citation.

### Phase 2 — What to improve

Pull: lessons `confirmed` but not yet graduated, loop overruns, and recurring
`blocker`/`major` findings in scope. Same citation rule as Phase 1.

### Phase 3 — Action items, every one with an owner

One action per "what to improve" item with enough evidence to be actionable — never
invented beyond what Phase 2 supports. Route each action to one of
`mdpe-learnings`'s **three existing feedback targets** (Discovery, Transformation,
Next executions) — no fourth target, no new category.

**`owner` is always filled.** A real name/role when the lesson's evidence points to a
natural owner; literally `"to be defined"` when it does not. Never absent.

### Phase 4 — Trend (conditional)

Exists **only** when a prior retro over the same scope type exists to compare
against. Compare counts (lessons confirmed, overruns, findings by severity) —
counts before ratios, and a ratio always carries its denominator, same discipline as
`mdpe-tracking.yml`. A single cycle with nothing to compare against produces **no**
Trend section — inventing a trend line from one data point is fabrication.

### Phase 5 — Close

State the scope covered, and route each action item per Phase 3. Nothing here
approves a plan, reassigns work, or blocks a person's next task — an action item is a
routed recommendation, exactly like an `mdpe-learnings` feedback action.

## Output

**One artifact**: `docs/retro/{scope-slug}-{YYYY-MM-DD}.md`.

```markdown
# Retro — {scope description} — {YYYY-MM-DD}

## What went well
- {bullet} — evidence: `ls-NNN` | `mdpe-tracking.yml:{field}`

## What to improve
- {bullet} — evidence: `ls-NNN` | `mdpe-tracking.yml:{field}`

## Action items
| Action | Target | Owner | Horizon |
|---|---|---|---|
| | Discovery / Transformation / Next executions | {name/role or "to be defined"} | immediate / short term / long term |

<!-- Trend section only if a prior retro over the same scope type exists -->
## Trend
- {count now} vs {count in previous retro}, both with denominator when a ratio is used
```

## Assets

- `assets/templates/retro-template.md` — the fill-in skeleton above, with the
  evidence-citation rule and the owner-always-filled rule inline.

## Quality gate — "an honest retro"

- [ ] Scope was declared by the user, never inferred.
- [ ] Every "what went well"/"what to improve" bullet cites the lesson or tracking
      field that supports it.
- [ ] Every action item has an `owner` filled — a real name/role or `"to be
      defined"`, never absent.
- [ ] Every action routes to one of the three existing `mdpe-learnings` targets — no
      new target invented.
- [ ] A **Trend** section exists only when a real prior retro exists to compare.
- [ ] No bullet attributes a failure to a person.

**Not required** (full list in `docs/adr/adr-010-cycle-retro.md` §5): a fixed cadence,
a minimum number of "what went well"/"what to improve" bullets, a Trend section with
no history, a named `owner` when none can be determined ("to be defined" is
complete), any metric this skill did not already read from tracking.

## Next skill

| Situation | Route to |
|---|---|
| Action item targets Discovery | `mdpe-backlog-discovery` / `mdpe-backlog` |
| Action item targets Transformation | `mdpe-transformation` |
| Action item targets Next executions | `mdpe-execution-context` / `mdpe-coding` |
| Want a changelog for this cycle too | `mdpe-release` |
| Want a stakeholder-facing summary too | `mdpe-status-report` |
| Nothing to consolidate | nothing — no file was created |
| Unsure where to go | `mdpe-router` |
