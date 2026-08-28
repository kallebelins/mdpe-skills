---
name: mdpe-execution-context
description: >-
  Prepares a single MDPE micro-task for coding: generates a complete 6-dimension
  execution context (strategic, technical, input, output, validation, reference) and
  sets up the environment to a Ready-to-Code state (dependencies, branch, file
  structure, references). Use right before implementing a micro-task. Not for
  decomposing features (mdpe-transformation) or writing/validating the code itself
  (mdpe-coding).
---

# MDPE Execution Context

> **MDPE stage**: Execution — Plan / Prepare
> **Consolidates commands**: EX-01 (Context Generation), CD-01 (Environment Preparation)
> **Runs**: once per micro-task

## Role

You are an MDPE Execution Preparer. Before any code is written, you assemble the
full context an implementer (human or agent) needs to execute a micro-task without
ambiguity, then bring the environment to a **Ready-to-Code** state. Context
generation (EX-01) and environment setup (CD-01) are sequential steps on the same
micro-task, so they run together here as **two phases**.

## When to use / when not

**Use when:**
- A micro-task from `tasks.md` is next and needs full context before coding.
- The environment/branch/dependencies must be prepared for a specific task.

**Not for:**
- Decomposing a feature into micro-tasks → `mdpe-transformation`.
- Implementing, validating, or reviewing code → `mdpe-coding`.

## Inputs

- The micro-task YAML `docs/transformation/{feature-id}/microtasks/mt-XXX-YYY.yml` (IOQD, AERT, category, dependencies).
- The feature and backlog context (`feat-XXX.yml`), acceptance criteria, value criteria.
- The architecture decisions in scope: `docs/architecture/decisions.yml` — the `ad-NNN`
  whose scope covers this task. They are the source of dimension 2 (see Phase 1).
- Repository state: stack, existing structure. In brownfield, `docs/brownfield/inventory.md`
  §1-§3 is the evidenced version of this.
- **Project memory**: `docs/memory/project-memory.yml` — `conventions[]` (each with its
  `source`) and the `pitfalls[]` that apply to this task's scope. This is the named artifact
  that the vague "aggregated learnings from prior tasks" used to stand for; it replaces
  retyping conventions from memory (`docs/adr/adr-006-memory-model.md`). No file → the
  conventions fields stay **empty**, which is the correct result — see Phase 1, dimension 2.

---

## Phase 1 — Context generation (EX-01): the 6 dimensions

Produce a self-contained context document covering all six dimensions. The six dimensions are the
structure — every one is addressed — but depth inside each is proportional to the micro-task: a
trivial task (e.g. a config file move) needs a short strategic note and no troubleshooting section,
while a complex one needs more. Sub-sections with no real content (no known risk, no external API,
no applicable tutorial) are left empty or omitted — never filled with an invented risk or a generic
tutorial link just to look complete.

1. **Strategic context** — why this task matters: the feature, user story, value delivered, and the acceptance criteria it contributes to.
2. **Technical context** — stack, architecture/patterns, conventions, relevant existing modules, and constraints. **Architecture is referenced here, not decided here**: each field carries `source: ad-NNN` from the decision's typed implication (`layers` → target layer, `boundaries` → layer dependencies, `structure` → directory structure, `patterns` → patterns and their justification, `stack`, `conventions`), plus the decision's `verification` the review will check. With no applicable `ad-NNN`, leave the fields **empty** and record the absence — do not improvise a pattern per task; that absence is the driver for a round of `mdpe-architecture`.

   **Conventions carry provenance too.** `code_conventions` was the last field in the framework
   filled from memory; it now takes `code_conventions_source` — an `ad-NNN` whose implication
   type is `conventions`, or `inventory.md §3` — and the readable list of both lives in
   `conventions[]` of `docs/memory/project-memory.yml`. **No source → the block stays empty**,
   exactly as `overall_pattern` does. An empty conventions block is a correct result and a real
   signal; a plausible naming convention typed from habit is not.
3. **Input context** — what the task receives: data, interfaces, contracts, upstream artifacts from dependency tasks.
4. **Output context** — what the task must produce: files/artifacts, interfaces exposed, expected side effects.
5. **Validation context** — how "done" is verified: acceptance criteria, test expectations, quality thresholds (ties into `mdpe-coding` validation).
6. **Reference context** — pointers: relevant files, docs, examples, and the prior learnings that apply to this task, cited by `ls-NNN` from `pitfalls[]` in `docs/memory/project-memory.yml`. Only **confirmed** lessons reach that index, so there is nothing unconfirmed to inherit. A lesson here is a pointer for the implementer — it never becomes a quality criterion, a verification command, or evidence.

Output: `docs/execution/{microtask-id}-context.yml` using
`assets/templates/execution-context-template.yml`.

---

## Phase 2 — Environment preparation (CD-01): Ready to Code

Take the environment to an executable state:

1. **Context review** — confirm the generated context is complete and unambiguous.
2. **Dependency validation** — verify all upstream micro-tasks are done and their outputs are available; verify external/third-party dependencies are installed.
3. **Environment setup** — install/verify packages, configuration, environment variables, and tooling needed for this task.
4. **File structure** — create/confirm the target files/folders the task will touch.
5. **References ready** — collect the reference materials from dimension 6 within reach.
6. **Branch** — create the working branch following convention `feature/{feature-id}/{microtask-id}` (e.g., `feature/feat-001/mt-001-001`); never work directly on `main`/`master`.

Output: `docs/execution/{microtask-id}-setup.yml` using
`assets/templates/environment-setup-template.yml`.

## Anti-hallucination

Every file path, tool, service, or documentation link cited must be real and verifiable — never
`TBD` or a plausible-sounding placeholder. A dimension with nothing real to add (no upstream
dependency, no external resource, no known risk) stays short or empty rather than being padded to
match the template's example content.

## Ready-to-Code checklist

- [ ] All 6 context dimensions filled and unambiguous.
- [ ] Dimension 2 either cites the applicable `ad-NNN` per architecture field, or records
      that no decision was in scope — no unsourced pattern.
- [ ] `code_conventions` either carries `code_conventions_source` (an `ad-NNN` or
      `inventory.md §3`), or is **empty**. No convention typed from memory.
- [ ] All hard dependencies satisfied; upstream outputs available.
- [ ] External dependencies installed and verified.
- [ ] Environment/config/tooling ready.
- [ ] Target file structure created/confirmed.
- [ ] References gathered.
- [ ] Working branch created off the correct base.

## Assets

- `assets/templates/execution-context-template.yml` — the 6-dimension context.
- `assets/templates/environment-setup-template.yml` — the environment preparation record.

## Next skill

- Proceed to **`mdpe-coding`** to implement, validate, and review the micro-task.
- If a hard dependency is missing, return to `mdpe-transformation` or execute the blocking task first.
