---
name: mdpe-coding
description: >-
  Executes a single MDPE micro-task end to end: implementation (SOLID, Clean Code,
  TDD, incremental commits), multi-dimension validation (tests, static analysis,
  acceptance criteria, performance, security, integration), and code review across
  seven dimensions with a Blocker/Major/Minor/Nitpick feedback loop and PR template.
  Use once a micro-task is Ready to Code. Not for context/setup (mdpe-execution-context),
  decomposition (mdpe-transformation), or extracting learnings (mdpe-learnings).
---

# MDPE Coding

> **MDPE stage**: Execution — Produce / Proof
> **Consolidates commands**: CD-02 (Implementation), CD-03 (Validation & Tests), CD-04 (Code Review)
> **Runs**: once per micro-task

## Role

You are an MDPE Implementer & Reviewer. You produce the code for a micro-task, prove
it meets its acceptance criteria, and review it for quality. Implementation (CD-02),
validation (CD-03), and review (CD-04) form the Produce+Proof loop and share quality
concerns (tests, performance, security), so they run here as **three phases with a
single, de-duplicated quality model**.

## When to use / when not

**Use when:**
- A micro-task is Ready to Code (context + setup done by `mdpe-execution-context`).
- You need to implement, validate, or review a micro-task's code.

**Not for:**
- Generating context / preparing the environment → `mdpe-execution-context`.
- Decomposing features → `mdpe-transformation`.
- Extracting learnings after completion → `mdpe-learnings`.

## Inputs

- `mt-XXX-YYY-context.yml` and `mt-XXX-YYY-setup.yml` from `mdpe-execution-context`.
- The micro-task YAML (IOQD, AERT, acceptance criteria) and the working branch.
- The architecture decisions in scope: `docs/architecture/decisions.yml` (the `ad-NNN`
  referenced by the context's `technical_context`), when the project has them. They are
  the baseline for review dimension 2 — see Phase 3.

## Unified quality model

These concerns are checked once and referenced by all three phases (no duplication):
**correctness** (acceptance criteria met), **tests** (unit/integration/e2e as
relevant), **static analysis** (lint, types, complexity), **performance** (no
obvious regressions; meets stated budgets), **security** (input validation, secrets,
authz where relevant), **integration** (works with dependent modules).

---

## Phase 1 — Implementation (CD-02): 5 sub-phases

1. **Core** — implement the primary logic to satisfy the IOQD output; apply **SOLID** and **Clean Code** (clear names, small functions, no duplication).
2. **Tests** — write tests (prefer TDD: red → green → refactor) covering acceptance criteria and edge cases.
3. **Integration** — wire the task into dependent modules/interfaces; no orphaned code.
4. **Documentation** — document public interfaces, decisions, and usage as needed.
5. **Self-review** — quick pass against the unified quality model before formal validation.

Commit incrementally with meaningful messages. Never leave the branch broken.

---

## Phase 2 — Validation & tests (CD-03): 6 dimensions

Evaluate against six dimensions and record pass/fail with evidence:

1. **Automated tests** — all relevant tests pass; coverage adequate for the task.
2. **Static analysis** — lint/type/complexity checks pass.
3. **Acceptance criteria** — every criterion from the micro-task is objectively met.
4. **Performance** — meets stated budgets; no obvious regressions.
5. **Security** — inputs validated, no leaked secrets, authz/authn respected where relevant.
6. **Integration** — behaves correctly with dependent components.

Output: `docs/execution/{microtask-id}-validation-report.yml` using
`assets/templates/validation-report-template.yml`. If any dimension fails, **return
to Phase 1** to fix, then re-validate.

---

## Phase 3 — Code review (CD-04): 7 dimensions

Review the change across seven dimensions:

1. **Requirements** — does it fully deliver the micro-task's intent and acceptance criteria?
2. **Architecture** — conforms to the `ad-NNN` decisions in scope, checked through each
   decision's `verification` field. See *Architecture: validate, don't re-decide* below.
3. **Code quality** — readable, SOLID, no duplication, no dead code.
4. **Tests** — meaningful, cover edge cases, not brittle.
5. **Performance** — efficient enough for the context.
6. **Security** — no introduced vulnerabilities.
7. **Maintainability** — documented, discoverable, easy to change.

Classify each finding:
- **Blocker** — must fix before merge.
- **Major** — should fix before merge.
- **Minor** — fix soon; not merge-blocking.
- **Nitpick** — optional/style.

**Return-to-fix loop**: Blockers and Majors send the task back to Phase 1; re-run
Phase 2 after fixes. When clean, prepare the PR. Final verdict is one of:
Approved (merge released) or Approved with Reservations (merge released, fix later).

Output: `docs/execution/{microtask-id}-code-review.yml`.

### Architecture: validate, don't re-decide

Dimension 2 does not reconstruct what the right architecture is — that decision belongs
to `mdpe-architecture` and lives in `docs/architecture/decisions.yml`. Here you check
the code against it.

- **Run or inspect each decision's `verification`** (a path that must exist, an import
  that must not, a named test, a command) and **cite the `ad-NNN` in every finding**. A
  finding with no decision cited is an opinion, not a review result.
- **Severity follows the implication type**: violating a `boundaries` implication is a
  **Blocker** (broken dependency direction); violating `patterns`, `structure`, or
  `conventions` is **Major** by default.
- **No `ad-NNN` in scope**: dimension 2 still applies heuristically (patterns,
  boundaries, dependency direction as observed), and the review **records the absence**.
  That record is the driver for a round of `mdpe-architecture` — the alternative is to
  keep guessing at a baseline nobody wrote down.
- **Code that needs to violate a decision** routes through `mdpe-architecture` as a
  `revise` (a new `ad-NNN` with `supersedes`), never as a silent deviation approved in
  review.

### PR template

```markdown
## Summary
<what changed and why — link the micro-task id and feature>

## Micro-task
- mt-XXX-YYY — <name>  (feature: feat-XXX)

## What was tested
- <tests run and results>

## Validation (6 dimensions)
- tests / static / acceptance / performance / security / integration: <status>

## Review notes
- Blockers: <none|list>  Majors: <none|list>  Minors/Nitpicks: <list>

## Blocked / follow-ups
- <anything deferred, with reason>
```

## Quality gate (task done)

- [ ] Implementation complete; integrated (no orphaned code); incremental commits.
- [ ] All 6 validation dimensions pass with evidence.
- [ ] Code review done; no open Blockers/Majors.
- [ ] Architecture findings each cite the `ad-NNN` they violate — or the review records
      that no decision was in scope.
- [ ] Validation report and review notes saved.
- [ ] PR prepared to a non-`main` branch.

## Assets

- `assets/templates/validation-report-template.yml` — the 6-dimension validation report.

## Next skill

- Proceed to **`mdpe-learnings`** to capture what this task taught the system.
- Route to **`mdpe-architecture`** when the code had to collide with a decision
  (`revise`), or when the review found no `ad-NNN` in scope and the guesswork should
  stop.
