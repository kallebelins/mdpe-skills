<!--
====================================================================
MDPE Framework - Consolidated Task List - Template
====================================================================
Version: 1.0.0
Purpose: Fill-in skeleton for the mdpe-tasks skill.
          A single Markdown output consolidating discovery-lite +
          transformation-lite + execution-context-lite per task.

How to use:
  1. Copy this file to docs/mdpe-tasks/{item-id-or-slug}.md
  2. Fill in the "Item summary" (Phase 1 of the skill)
  3. Duplicate the "Phase N" block for each dependency wave
  4. Duplicate the task block for each micro-task in the wave
  5. Remove these instruction comments when done
====================================================================
-->

# Tasks — {item title}

<!-- Item summary: discovery-lite framing (Phase 1 of the skill) -->
## Item summary

- **Objective:** {what this item delivers and to whom}
- **Problem / value:** {problem solved and value generated}
- **Scope (in):** {what is included}
- **Scope (out):** {what is explicitly not included}
- **Item-level acceptance criteria:**
  - [ ] {objective acceptance criterion at the item level}
  - [ ] {objective acceptance criterion at the item level}
- **Stakeholders/personas:** {who is impacted, if known}
- **Risks/constraints:** {known risks or constraints at the item level}
- **Default technical context:** {stack, patterns, conventions that apply to all tasks unless stated otherwise}
<!--
CONDITIONAL line. Keep it only when an architecture decision actually
constrains this item; cite the ad-NNN from docs/architecture/decisions.yml.
Most small items have no architectural driver - DELETE the line then,
rather than writing "none". Do not name a pattern that has no ad-NNN
behind it; an unwritten architecture is a driver for mdpe-architecture.
-->
- **Architecture decisions in scope:** `ad-NNN` — {title} · check: {the decision's verification}

---

<!--
Duplicate this Phase block for each wave (Phase 1 = Wave 1 = no
dependencies, Phase 2 = Wave 2 = depends only on Phase 1, etc.).
Within a phase, order tasks by logical layer:
Database → Domain → Infrastructure → Application → API → Frontend → Tests → Docs.
-->
## Phase 1 — {phase label, e.g. "Foundation"} (Wave 1)

<!-- Duplicate this task block for each micro-task in the phase -->
- [ ] **{task-id}** — {task title}
  - **Category:** {backend | frontend | database | infra | docs | tests} · **Estimate:** {N}h · **Priority:** {Critical | High | Medium | Low}{ · Quick win | · Spike, if applicable}
  - **Description:** {what must be done, in one paragraph}
  - **Input:** {what must exist before: files, data, contracts, upstream artifacts}
  - **Output:** {what must be produced: files, artifacts, side effects}
  - **Acceptance criteria:**
    - [ ] {verifiable criterion 1}
    - [ ] {verifiable criterion 2}
  - **Dependencies:** upstream: {ids or "—"} · downstream: {ids or "—"}
  - **Reference files:** `{path/to/existing-file}`, `{path/to/new-file}`
  - **Execution context:**
    - Strategic: {why this task matters for the item's objective}
    - Technical: {stack/pattern/convention notes specific to this task, if different from the item's default}
    - Validation: `{command or test name}` → {expected result}
  - **Setup/branch:** `feature/{item-id}/{task-id}`

---

## Phase 2 — {phase label} (Wave 2)

- [ ] **{task-id}** — {task title}
  - **Category:** {category} · **Estimate:** {N}h · **Priority:** {priority}
  - **Description:** {description}
  - **Input:** {input}
  - **Output:** {output}
  - **Acceptance criteria:**
    - [ ] {criterion 1}
  - **Dependencies:** upstream: {ids} · downstream: {ids or "—"}
  - **Reference files:** `{path}`
  - **Execution context:**
    - Strategic: {text}
    - Technical: {text}
    - Validation: `{command/test}` → {expected result}
  - **Setup/branch:** `feature/{item-id}/{task-id}`

<!-- Add as many phases as needed, following the same pattern -->

---

## Summary

| Phase | Tasks | Total estimate |
|------|---------|-------------------|
| Phase 1 | {N} | {N}h |
| Phase 2 | {N} | {N}h |
| **Total** | **{N}** | **{N}h** |
