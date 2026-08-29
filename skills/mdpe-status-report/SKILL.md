---
name: mdpe-status-report
description: >-
  Projects project state into a one-page report for a non-technical stakeholder - a
  RAG traffic light (on track / at risk / blocked) plus four sections (accomplished,
  in progress, risks & blockers, next), with zero micro-task ids, decision ids, or
  file paths in the main body. Reads docs/tracking/mdpe-tracking.yml, the dispatch and
  signals mdpe-graph already computed, docs/memory/project-memory.yml, and
  CHANGELOG.md when mdpe-release has cut one for the period - never recomputes any of
  them. The traffic light is derived from a fixed decision tree over real signals
  (blocked micro-tasks, open cross-feature cycles, unavailable external dependencies,
  loop overruns), never from opinion, and every claim in the body has a matching row
  in a provenance appendix naming the artifact and field. Decides nothing and approves
  nothing - it reports and names what is needed from the reader. Use when a
  stakeholder asks how the project is doing, or before a status meeting. Not for
  rendering the traceability graph or dispatch details (mdpe-graph), execution
  metrics and learnings (mdpe-learnings), what shipped for users (mdpe-release), or a
  cycle retrospective (mdpe-retro).
---

# MDPE Status Report

> **MDPE stage**: Traceability/Propagate — a projection over tracking, graph and memory, for an audience outside the execution cycle
> **Decision of record**: `docs/adr/adr-009-status-report.md`
> **Runs**: on demand, when someone wants to know how the project is doing. Never on a schedule.

## Role

You are an MDPE Status Translator. The framework already reconciles execution status
(`mdpe-tracking.yml`), already computes what's dispatchable and what's stuck
(`mdpe-graph`), and already knows what's in force and what's stale
(`docs/memory/project-memory.yml`). Your job is to turn all three into something a
person with no technical vocabulary can read in one page.

You write for someone who was never going to open a YAML file. A body that reads
`mt-004-002 blocked, root cause: external API unavailable` is a defect — the same
information belongs in your report as *"blocked: waiting on an external service to
become available"*, with the id available only in the appendix for whoever wants to
verify it.

One rule outranks the rest: **no technical id in the main body.** No `mt-XXX-YYY`, no
`ad-NNN`, no `feat-XXX`, no file path — those live exclusively in the provenance
appendix. And the traffic light is never an opinion: it follows a fixed decision tree
over real signals, and the signal that produced it is always citable.

## When to use / when not

**Use when:**
- A stakeholder — sponsor, client, non-technical manager — asks how the project is
  doing.
- Someone needs a one-page brief before a status meeting.
- You want to know if the project is on track without reading the graph or the
  tracking file yourself.

**Not for:**
- Rendering the traceability graph, dispatch, or answering impact/orphan/cycle
  queries → `mdpe-graph`. This skill reads what `mdpe-graph` already computed; it
  never recomputes a wave, a cycle, or a dispatch decision.
- Execution metrics, learnings, or the memory index → `mdpe-learnings`.
- What shipped for users, in changelog form → `mdpe-release`. When one exists for the
  period, this skill cites it instead of recalculating the same list (see Phase 2).
- A cycle/sprint retrospective (what went well, what to improve) → `mdpe-retro`.
- Implementing, validating or reviewing code → `mdpe-coding`.

**Nothing to report** (no tracking, no graph, no memory index yet — no execution
cycle has produced data): answer *"nothing to report; no execution cycle has produced
data yet"*, and create no artifact.

## Inputs

| Input | Required | What it yields |
|---|:---:|---|
| `docs/tracking/mdpe-tracking.yml` | **Yes** | reconciled micro-task status, overruns, findings by severity — **read, never recomputed** |
| `docs/graph/traceability-graph.md` and/or `docs/graph/{feature-id}-waves.md` | No, but strongly recommended | dispatch ("what runs now" and why parallelism is reduced), orphans, cross-feature cycles — read from the graph's own signal sections, never recalculated |
| `docs/memory/project-memory.yml` | No | decisions/conventions in force, `staleness[]` |
| `CHANGELOG.md` | No | if `mdpe-release` cut a version in the report's period, **Accomplished** cites its entries instead of recomputing the list (see Phase 2) |
| `docs/backlog/backlog-index.yml` (+ `features/feat-XXX.yml`) | No | feature names in product language, for translating ids in the body |
| Report period (since last report, or a stated date range) | No | Default: since the last `docs/status/*.md` report, if one exists; otherwise, the whole project to date |

## Process

### Phase 0 — Preflight

1. Confirm at least one of `mdpe-tracking.yml`, a graph projection, or the memory
   index exists. None → stop with the "nothing to report" answer above.
2. Resolve the report period.
3. Read the previous report, if any, to avoid re-reporting the same accomplishment.

### Phase 1 — Derive the traffic light (never an opinion)

Walk this decision tree; the **first** condition that matches decides the color —
stop there:

| Light | Condition (first match wins) |
|:---:|---|
| 🔴 **Blocked** | ≥1 micro-task `blocked` with an unresolved root-cause route in `mdpe-tracking.yml`, **or** the graph reports an open cross-feature cycle in the report's scope |
| 🟡 **At risk** | ≥1 `external` dependency `unavailable`/`in_development` on the critical path, **or** the graph shows available parallelism below its declared group with a named reason, **or** ≥2 loop overruns in scope since the last report |
| 🟢 **On track** | none of the above apply |

Record, for the appendix, the exact signal (artifact + field) that produced the
color. A color with no citable signal is not a valid output.

### Phase 2 — Accomplished

If a `CHANGELOG.md` was cut within the report's period, **cite its entries** —
translated to a sentence each if needed — instead of recomputing the list from
tracking. This avoids two artifacts disagreeing about what shipped.

If no changelog exists for the period, derive directly from `mdpe-tracking.yml`,
using the same evidence triple `mdpe-release` uses (completed + validated + artifact
exists), grouped by feature — never by micro-task.

### Phase 3 — In progress

Name the **features** with open work right now (an active wave, or micro-tasks
`in_progress`), never the micro-tasks themselves. One line per feature, in product
language.

### Phase 4 — Risks & blockers

Translate, never cite raw: an open overrun becomes *"one piece of work needed more
attempts than expected; root cause: {plain-language summary}"*; an unavailable
external dependency becomes *"blocked: waiting on {what}, from {who/what}"`; a
cross-feature cycle becomes *"two pieces of planned work depend on each other and
need re-planning."* State explicitly **what is needed from the reader**, when
something is needed (a decision, an unblock, a budget call) — never resolved by this
skill.

### Phase 5 — Next

Translate the graph's dispatch answer (what runs in the next open wave) into feature
names and a plain-language description of what's coming, plus the reason if
parallelism is reduced (Phase 1 signal, restated in plain language if it changed the
light).

### Phase 6 — Provenance appendix

One row per claim made in the body: `claim` → `artifact + field` → `technical id`.
Every sentence in the body must have a corresponding row. This is what makes the
report checkable without forcing the reader to see a single id in the main text.

## Output

**One artifact**: `docs/status/{YYYY-MM-DD}-status-report.md` (or a path the user
names).

```markdown
# Status report — {project name} — {YYYY-MM-DD}

## 🟢/🟡/🔴 {On track / At risk / Blocked}
{one sentence, the reason in plain language}

## Accomplished
- {one line, product language}

## In progress
- {one line, product language}

## Risks & blockers
- {one line, plain language} — needs: {what's needed from the reader}

## Next
- {one line, plain language}

---
## Appendix — provenance
| Claim | Artifact → field | Technical id |
|---|---|---|
```

## Assets

- `assets/templates/status-report-template.md` — the fill-in skeleton above, with the
  traffic-light decision tree and the provenance-appendix convention inline.

## Quality gate — "an honest report"

- [ ] No technical id (`mt-*`, `ad-*`, `feat-*`, file path) appears in the main body.
- [ ] The traffic light follows the Phase 1 decision tree; its triggering signal is in
      the appendix.
- [ ] Every body claim has a matching appendix row with artifact + field.
- [ ] Accomplished cites `CHANGELOG.md` when one exists for the period (Phase 2),
      instead of recomputing it.
- [ ] Nothing in the report is presented as a decision, an approval, or a confirmed
      deadline — only a report, with what is needed named explicitly.

**Not required** (full list in `docs/adr/adr-009-status-report.md` §5): a fixed
reporting cadence, a dashboard or chat integration, micro-task detail in the body,
recomputing what `mdpe-release` already published, a color other than 🟢 with no
qualifying signal, an appendix when the body is empty.

## Next skill

| Situation | Route to |
|---|---|
| Report shows a blocker needing a technical decision | `mdpe-architecture` or `mdpe-execution-context` (per the graph's own routing) |
| Stakeholder wants "what shipped" in changelog form instead | `mdpe-release` |
| Cycle is ending and a retrospective is due | `mdpe-retro` |
| Nothing to report | nothing — no file was created |
| Unsure where to go | `mdpe-router` |
