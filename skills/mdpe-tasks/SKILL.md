---
name: mdpe-tasks
description: >-
  Turns a piece of text, a backlog item, or a single feature into one consolidated
  Markdown task list: discovery framing (why/scope/acceptance), transformation-style
  decomposition (IOQD + AERT micro-tasks, dependencies, waves, priority), and
  execution-context (6 dimensions, Ready-to-Code) all merged into a single file,
  organized in phases, with [ ] checkboxes, file references, inputs, outputs, and
  quality criteria per task. Use when the user pastes a backlog item/feature/free
  text and wants one actionable checklist file instead of the full multi-artifact
  MDPE pipeline. Not for running a full discovery session (mdpe-discovery),
  structuring the versioned cognitive backlog (mdpe-backlog), the full multi-file
  transformation output for a large feature (mdpe-transformation), implementing the
  code (mdpe-coding), or capturing learnings after execution (mdpe-learnings).
---

# MDPE Tasks

> **MDPE stage**: fast path across Discovery (lite) → Transformation → Execution-Context (Plan/Prepare)
> **Consolidates**: the essentials of `mdpe-discovery` (framing only), `mdpe-transformation` (TL-01/02/03/04 lite), and `mdpe-execution-context` (EX-01/CD-01 lite)
> **Runs**: once per backlog item / feature / text input, producing a single file

## Role

You are an MDPE Task Consolidator. Given a text, backlog item, or feature, you
produce **one self-contained Markdown file** that a developer (human or agent) can
work through top to bottom: check the box, read the task's own input/output/criteria,
and move to the next. This skips the multi-file, multi-folder ceremony of running
`mdpe-transformation` and `mdpe-execution-context` separately, while keeping every
piece of information those skills would have produced — just inlined per task.

## When to use / when not

**Use when:**
- The user pastes a backlog item, a feature description, a user story, or free-text
  requirements and wants a ready-to-execute task list, not a formal multi-artifact
  pipeline.
- The item is small/medium in scope (roughly 3-25 tasks). One person or one agent
  session will work through it.
- You want discovery framing + decomposition + execution context **without**
  generating a folder tree of YAML files.

**Not for:**
- A full discovery workshop with personas, MoSCoW, hypotheses across many features →
  `mdpe-discovery`.
- A versioned, traceable Cognitive Backlog spanning the whole product → `mdpe-backlog`.
- A large Must-Have feature that needs the full auditable trail (7-criteria QA report,
  0-40 priority ranking files, dependency graph files, `tasks.md` aggregation across
  many features) → `mdpe-transformation` + `mdpe-execution-context`.
- Writing/validating/reviewing the actual code → `mdpe-coding`.
- Extracting learnings once tasks are done → `mdpe-learnings`.

If, while working through Phase 1, the item turns out to need > ~25 tasks or spans
multiple independent features, say so and suggest routing to `mdpe-backlog` /
`mdpe-transformation` instead of forcing it into one file.

## Inputs

- Free text: a paragraph, user story, bug report, or requirement.
- A backlog item: pasted text, or an existing `feat-XXX.yml` from `mdpe-backlog`.
- Optional technical context: stack, architecture/patterns, conventions, existing
  modules, constraints (deadlines, team capacity). When the project has them, take it
  **by reference** instead of from memory: `docs/architecture/decisions.yml` (the
  `ad-NNN` in scope) and, in brownfield, `docs/brownfield/inventory.md`.

If the input is an existing `feat-XXX.yml`, reuse its fields (id, description,
acceptance criteria, value) instead of re-deriving them in Phase 1.

Most small items have **no architectural driver** and need no `ad-NNN` at all — that is
the normal case, not a gap. Cite decisions only when one actually constrains the item.

## Process

Run the phases in order. Each phase feeds the next; the final phase's job is to
**merge everything into the single output file** — do not emit intermediate YAML
files.

---

### Phase 1 — Framing (discovery-lite)

Extract, in a few lines each:
- **Objective** — what this item delivers and to whom.
- **Problem / value** — the problem solved and the value generated.
- **Scope** — explicitly in-scope and out-of-scope.
- **Item-level acceptance criteria** — the "done" bar for the whole item (a
  developer confirms it later, at the item level, on top of per-task criteria).
- **Stakeholders / personas impacted** (if known).
- **Known constraints or risks** at the item level.

If the input already gives you these (e.g. a `feat-XXX.yml`), summarize rather than
invent. Keep this phase short — it is the header of the final file, not a full
discovery session.

---

### Phase 2 — Decomposition (transformation-lite, TL-01)

Break the item into **atomic micro-tasks**, sized to the item (roughly 3-25; do not
force a feature-sized item into 15-25 if it is genuinely smaller).

Each task needs, using the **IOQD** contract:
- Unique id: `mt-{item-id}-XXX` if a formal `feat-XXX` id exists, otherwise
  `tk-{item-slug}-XXX` (e.g., `tk-cadastro-propriedade-001`).
- Clear title and one-paragraph description.
- **Input** — what must already exist (files, data, upstream artifacts).
- **Output** — what must be produced (files, artifacts, side effects).
- **Quality criteria** — verifiable acceptance criteria for this task alone.
- **Category** — `backend` | `frontend` | `database` | `infra` | `docs` | `tests`.
- **Estimate** — hours, ideally 2-4h, max 8h (if bigger, split it).

Self-check each task against **AERT** (Atomicity, Executability, Traceability to the
item, Testability) before moving on. Anti-patterns: too big (>8h → split), too small
(<1h → merge), vague ("improve X"), hidden dependencies.

---

### Phase 3 — Dependencies & waves (transformation-lite, TL-02)

For each task, identify:
- **Upstream** dependencies (hard = blocking, soft = preferred order) and
  **downstream** tasks that depend on it.
- **External** dependencies (third-party API/service/library) if any.

Group tasks into **waves**: Wave 1 = no dependencies, Wave 2 = depends only on
Wave 1, and so on. The graph must be acyclic — if you find a cycle, re-decompose.

Waves become the **phases** of the final file (see Output below). Within a phase,
order tasks by the logical layer convention used across MDPE: Database → Domain →
Infrastructure → Application → API → Frontend → Tests → Docs.

---

### Phase 4 — Priority (transformation-lite, TL-03/TL-04 merged)

For each task, assign one combined **Priority**: `Critical` | `High` | `Medium` |
`Low`, from a quick read of feasibility, risk, complexity, and how many downstream
tasks it unblocks (the same signals as TL-04's 0-40 score, applied qualitatively
instead of as a separate scored artifact). Flag:
- **Quick win** — low complexity, unblocks several downstream tasks.
- **Spike** — high uncertainty/low feasibility; recommend a time-boxed investigation
  before committing to the estimate.

Also do a fast pass against the spirit of TL-03's 7 criteria (atomicity,
well-defined input/output, verifiable criteria, mapped dependencies, clarity,
reasonable estimate). If a task clearly fails several, fix it in place — don't emit
a separate validation report; correctness lives in the task itself.

---

### Phase 5 — Execution context per task (execution-context-lite, EX-01 + CD-01)

For each task, inline a condensed version of the 6 context dimensions plus the
Ready-to-Code checklist — this is what makes the file self-contained:

1. **Strategic** — one line: why this task matters for the item's objective.
2. **Technical** — stack/pattern/convention notes specific to this task, if they
   differ from the item-level defaults already stated in the header. When a decision
   constrains the task, cite the `ad-NNN` and its check rather than restating the
   pattern.
3. **Input** — restated concretely (files/data/contracts available).
4. **Output** — restated concretely (files/artifacts to create or change).
5. **Validation** — how to verify done: commands, test names, or manual checks.
6. **Reference** — file paths, existing similar code, or docs to consult.

Ready-to-Code notes: branch suggestion (`feature/{item-id}/{task-id}`), and any
setup step that isn't obvious from Input (e.g., "run migrations first").

## Output

Produce **one Markdown file**: `docs/mdpe-tasks/{item-id-or-slug}.md` (e.g.
`docs/mdpe-tasks/feat-003.md` or `docs/mdpe-tasks/cadastro-propriedade.md`), unless
the user names a different path.

Structure:

```markdown
# Tasks — {item title}

## Item summary
- **Objective:** ...
- **Problem / value:** ...
- **Scope (in):** ...
- **Scope (out):** ...
- **Item-level acceptance criteria:**
  - [ ] ...
- **Stakeholders/personas:** ...
- **Risks/constraints:** ...
- **Architecture decisions in scope:** `ad-NNN` — {title} <!-- omit this line entirely
  when the item has no architectural driver -->


## Phase 1 — {label, e.g. "Foundation"} (Wave 1)
- [ ] **mt-XXX-001** — {title}
  - **Category:** backend · **Estimate:** 3h · **Priority:** High
  - **Description:** ...
  - **Input:** ...
  - **Output:** ...
  - **Acceptance criteria:**
    - [ ] ...
  - **Dependencies:** upstream: — · downstream: mt-XXX-002
  - **Reference files:** `path/to/file.cs`, `path/to/other.md`
  - **Execution context:**
    - Strategic: ...
    - Technical: ...
    - Validation: `command or test` → expected result
  - **Setup/branch:** `feature/{item-id}/mt-XXX-001`

## Phase 2 — {label} (Wave 2)
- [ ] **mt-XXX-002** — {title}
  ...

## Summary
| Phase | Tasks | Total estimate |
|------|---------|-------------------|
| Phase 1 | N | Nh |
| Phase 2 | N | Nh |
| **Total** | **N** | **Nh** |
```

Rules:
- Every task is a top-level `- [ ]` checkbox; every task-level acceptance criterion
  is its own nested `- [ ]` checkbox so both can be ticked independently.
- Phases are ordered by wave; within a phase, order by the layer convention
  (Database → Domain → Infrastructure → Application → API → Frontend → Tests → Docs).
- File references must be concrete paths (existing files to touch, or the paths new
  files will be created at) — never "TBD".
- Keep each task's context section short (a few lines per dimension); this is a
  condensed inline version, not the full `mdpe-execution-context` document.

## Assets

- `assets/templates/mdpe-tasks-template.md` — the fill-in skeleton behind the
  structure above (header + phase + task block), ready to copy and populate.

## Quality gate

- [ ] Item framed (objective, value, scope, item-level acceptance criteria).
- [ ] Item decomposed into atomic, IOQD-complete micro-tasks (estimate < 8h each),
      passing an AERT self-check.
- [ ] Dependency graph acyclic; tasks grouped into waves/phases; downstream tasks
      correctly reference their upstream ids.
- [ ] Every task has a Priority (and quick-wins/spikes flagged where relevant).
- [ ] Every task has all 6 inline context dimensions, concrete file references, and
      a validation step that is actually checkable (command, test, or manual step).
- [ ] Single Markdown file produced at `docs/mdpe-tasks/{item-id}.md` with working
      checkboxes for both tasks and their acceptance criteria.

## Next skill

- Work through the file top to bottom: for each task, go straight to `mdpe-coding`
  (the inline execution context replaces a separate `mdpe-execution-context` step).
- Once a task is implemented and validated, tick its boxes; optionally run
  `mdpe-learnings` after the item is fully done to capture what was learned.
- If the item turns out too large or strategically ambiguous mid-way, step back to
  `mdpe-backlog` / `mdpe-transformation` for the full traceable pipeline.
