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
- Repository state: stack, conventions, existing structure, aggregated learnings from prior tasks.

---

## Phase 1 — Context generation (EX-01): the 6 dimensions

Produce a self-contained context document covering all six dimensions:

1. **Strategic context** — why this task matters: the feature, user story, value delivered, and the acceptance criteria it contributes to.
2. **Technical context** — stack, architecture/patterns, conventions, relevant existing modules, and constraints.
3. **Input context** — what the task receives: data, interfaces, contracts, upstream artifacts from dependency tasks.
4. **Output context** — what the task must produce: files/artifacts, interfaces exposed, expected side effects.
5. **Validation context** — how "done" is verified: acceptance criteria, test expectations, quality thresholds (ties into `mdpe-coding` validation).
6. **Reference context** — pointers: relevant files, docs, examples, prior learnings applicable to this task.

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

## Ready-to-Code checklist

- [ ] All 6 context dimensions filled and unambiguous.
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
