---
name: mdpe-release
description: >-
  Closes a version for whoever consumes the software - end users, customers, support -
  by projecting completed, evidenced micro-tasks into CHANGELOG.md in the Keep a
  Changelog format: one entry per feature touched (never per micro-task), category
  assigned only when the evidence for it exists (otherwise the safe default is
  Changed, never Added/Fixed/Security), and a hidden provenance comment naming the
  micro-tasks behind each line. Reads docs/tracking/mdpe-tracking.yml for reconciled
  status and the feature/micro-task contracts for names and artifacts; never
  recomputes status and never writes an entry for a pending, in_progress, or blocked
  micro-task. A published version section is never rewritten. Suggests a semver bump
  from the categories present and waits for confirmation before writing it. Use when
  cutting a release or asked what changed for users since the last version. Not for
  closing a single micro-task's learnings (mdpe-learnings), tracking execution metrics
  (mdpe-learnings), reporting project status to stakeholders (mdpe-status-report), or
  running a cycle retrospective (mdpe-retro).
---

# MDPE Release

> **MDPE stage**: Execution — Propagate, closing outward (a projection for the software's consumers, not for the framework)
> **Decision of record**: `docs/adr/adr-007-release-notes.md`
> **Runs**: on demand, when someone decides to cut a version. Never per micro-task, never on a schedule.

## Role

You are an MDPE Release Writer. The framework already reconciles which micro-tasks
are `completed` and evidenced. Your job is to turn that into one thing a person who
never opens YAML can read: what changed, in this version, in their language.

You write for the software's consumers, not for the team. A line in `CHANGELOG.md`
that reads like a micro-task title ("implemented the entity X repository") is a
defect, not a shortcut.

One rule outranks the rest: **an entry exists only if a `completed`, evidenced
micro-task exists behind it.** No entry for planned, in-progress, or blocked work — a
changelog is a record of what shipped, never of what is intended. When the evidence
for a specific category (`Fixed`, `Security`, `Deprecated`, `Removed`) is not
citable, the entry falls back to `Changed` — the safe default, never the more
dramatic label.

## When to use / when not

**Use when:**
- Someone is about to cut a release and wants `CHANGELOG.md` updated.
- Someone asks "what changed for users since version X?" or "what's in this
  release?".
- Micro-tasks have accumulated as `completed` in `mdpe-tracking.yml` since the last
  version and it's time to project them outward.

**Not for:**
- Closing a single micro-task's learnings, metrics, or memory → `mdpe-learnings`.
  This skill reads what `mdpe-learnings` already reconciled; it never writes tracking,
  lessons, or the memory index.
- Reporting project status/health to stakeholders → `mdpe-status-report`. A status
  report answers "how is the project doing"; a changelog answers "what shipped".
- Aggregating what went well/poorly across a cycle → `mdpe-retro`.
- Implementing, validating or reviewing code → `mdpe-coding`.

**Nothing completed since the last cut**: answer *"nothing to release since version
{X}; no new section was created"*, and leave `CHANGELOG.md` untouched. That is the
correct output, not a failure.

## Inputs

| Input | Required | What it yields |
|---|:---:|---|
| Target version identifier (e.g. `1.4.0`) | **Yes** | The section header. Missing → ask and stop. |
| `docs/tracking/mdpe-tracking.yml` | **Yes** | The reconciled set of `completed` micro-tasks since the last cut. **Read, never recomputed** — same posture as `mdpe-graph` toward `dependencies/*.yml`. |
| `docs/transformation/{feature-id}/microtasks/mt-XXX-YYY.yml` | **Yes, per included micro-task** | `traceability.feature_id`, `output.generated_artifacts[].location` |
| `{microtask-id}-validation.yml` | **Yes, per included micro-task** | `fidelity.declared_outputs[].exists`, `summary.overall_status` — the second half of the evidence triple |
| `docs/backlog/features/feat-XXX.yml` | No | Feature name/description in product language, for the entry's wording |
| `{microtask-id}-learnings.yml` | No | `problems`-type learnings, used only to support a `Fixed` category (see Categorization) |
| `{microtask-id}-code-review.yml` | No | `findings[]` with `severity: blocker`/`major` that motivated the micro-task, used only to support `Fixed` |
| `docs/architecture/decisions.yml` | No | `drivers[].evidence` for `Security`; `implications[]` for `Deprecated`/`Removed` — both require a literal citation, never inferred from a name |
| Previous `CHANGELOG.md` | No | Delimits "since the last version" and confirms no published section gets touched |

**Zero `completed` micro-tasks since the last cut → no new section, no file
change.**

## Process

### Phase 0 — Preflight

1. Confirm the target version identifier. Missing → ask and stop.
2. Read `mdpe-tracking.yml`. Confirm it reconciles at least one micro-task as
   `completed` since the last cut (by date, or by absence from the existing
   `CHANGELOG.md`). None → stop with the "nothing to release" answer above.
3. Read the existing `CHANGELOG.md`, if any. Locate the highest published version —
   it is never touched again (Phase 4 rule 1).

### Phase 1 — Collect the evidence triple, per candidate micro-task

For each micro-task the tracking reconciles as `completed` since the last cut, all
three must hold before it counts toward any entry:

1. `mdpe-tracking.yml` reconciles it as `completed` (not a pendency, not a
   divergence with the index).
2. Its `{microtask-id}-validation.yml` closes `approved` or
   `approved_with_reservations`.
3. Its declared artifacts (`fidelity.declared_outputs[].exists`) are `true`.

Any of the three missing → **excluded**, silently. It is not "in progress" for the
purpose of this changelog; it simply is not evidence yet.

### Phase 2 — Group by feature, not by micro-task

One entry per `feat-XXX` touched by at least one qualifying micro-task from Phase 1
— never one entry per micro-task. A feature delivered across 6 micro-tasks produces
**one** line.

Draft the wording from the feature's `description` (backlog) or, absent a backlog
entry, from the micro-tasks' titles read together — rewritten in present tense, as
something the user can now do, never copied verbatim from implementation language.

### Phase 3 — Categorize, evidence first

| Category | Assigned when |
|---|---|
| **Added** | Default for a `feat-XXX` whose first appearance in any version of `CHANGELOG.md` is this one. |
| **Changed** | Default for a `feat-XXX` that already appeared in a prior version and gained qualifying micro-tasks in this window. **Also the fallback** for anything below that lacks its required citation. |
| **Fixed** | Only when a qualifying micro-task's `-learnings.yml` classifies it under `problems`, **or** its originating code review had a `blocker`/`major` finding traceable via `traceability.origin_decisions` or feature adjacency. |
| **Security** | Only when the `ad-NNN` a qualifying micro-task `implements` cites, in `drivers[].evidence`, a verifiable security concern — literal citation required. |
| **Deprecated** / **Removed** | Only when an `ad-NNN` has an `implications[]` entry covering removal/deprecation, cited by id. |

No citable evidence for `Fixed`/`Security`/`Deprecated`/`Removed` → the entry is
`Changed`. Never infer a stronger category from a micro-task's title or from
plausibility.

### Phase 4 — Write

1. **Never rewrite a published section.** A version already in `CHANGELOG.md` is
   immutable; a correction becomes a new entry in the next version ("Fixed:
   corrected the description of version X's entry"), never a retroactive edit.
2. New section at the top, under `[Unreleased]` if one exists and is being cut now,
   otherwise as a fresh `## [{version}] - {date}` block.
3. One line per feature (Phase 2), grouped under its category (Phase 3), in product
   language.
4. Append a hidden provenance comment naming the qualifying micro-tasks, so an
   internal reader can audit the entry without trusting the prose:
   ```html
   <!-- feat-004: mt-004-001, mt-004-002, mt-004-005 (completed, validated) -->
   ```
5. **Suggest** a semver bump from the categories present — `Removed`/`Deprecated`
   with a compatibility impact → major; `Added` → minor; only `Fixed`/`Security` →
   patch — and **wait for confirmation** before writing the version number. Never
   decide and write it unconfirmed.

## Output

**One artifact**: `CHANGELOG.md` at the consumer repository's root (Keep a Changelog
convention — not under `docs/`, unlike every other MDPE artifact).

```markdown
## [Unreleased]

## [1.4.0] - 2026-08-29

### Added
- <one line, product language> (`feat-004`)
<!-- feat-004: mt-004-001, mt-004-002 (completed, validated) -->

### Fixed
- <one line, product language> (`feat-007`)
<!-- feat-007: mt-007-003 (completed, validated) -->
```

## Assets

- `assets/templates/changelog-template.md` — the fill-in skeleton above, with the
  category table and the provenance-comment convention inline.

## Quality gate — "an honest release"

Valid when **all** hold:

- [ ] Every entry cites ≥1 `feat-XXX` backed by ≥1 `completed`, evidenced micro-task
      (the Phase 1 triple).
- [ ] No entry exists for a `pending`, `in_progress`, or `blocked` micro-task.
- [ ] Category follows Phase 3; nothing above `Changed` without its required
      citation.
- [ ] The provenance comment lists the real micro-tasks behind the line.
- [ ] No previously published version was rewritten.
- [ ] The version number was confirmed by the user, never written unconfirmed.

**Not required** (full list in `docs/adr/adr-007-release-notes.md` §5): Conventional
Commits, a release CI/tooling, one entry per micro-task, a category other than
`Changed` when the stronger evidence does not exist, an `[Unreleased]` section when
nothing qualifies, cutting a version at every micro-task close, translation, or any
platform-specific release-notes format (GitHub Releases, App Store, etc.) — those are
manual adaptations from this file, out of this skill's scope.

## Next skill

| Situation | Route to |
|---|---|
| Version cut, want to tell stakeholders how the project is doing beyond "what shipped" | `mdpe-status-report` |
| Version cut, cycle is also ending and a retrospective is due | `mdpe-retro` |
| Nothing `completed` since the last cut | nothing — no file was created |
| Unsure where to go | `mdpe-router` |
