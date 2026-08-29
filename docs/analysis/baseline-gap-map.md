# Baseline Gap Map — Audit of the 8 MDPE skills

> **Source task:** `tasks-v1.md` → Phase 1 → 1.1 (Audit the current state of the 8 skills and map gaps).
> **Objective:** survey, per skill, inputs/outputs, generated artifacts, required vs optional
> fields, and coupling points; and consolidate a gap map that cross-references each user question
> with **evidence in a file** (with a quoted excerpt).
> **Applied acceptance rule:** every gap here cites a file (and excerpt/line) and has an observable
> criterion. No gap is a generic opinion.

## Method

1. Full reading of the 8 `SKILL.md` files, all templates (`assets/templates/*`) and schemas
   (`assets/schemas/*`), the docs (`docs/mdpe-flow.md`, `docs/mapping-commands-to-skills.md`), and
   `README.md`/`INSTALL.md`.
2. Verification that referenced artifacts exist via repository search
   (`tools/mdpe-status.py`, `.github/`, `aggregated-learnings.yml`).
3. Count of required vs optional fields based on the `required`/`minItems` arrays of the schemas
   and the structure of the YAML templates.

---

## Section A — Audit per skill (inputs, outputs, artifacts, coupling)

| Skill | Inputs | Outputs / artifacts | Coupling (consumes ← / feeds →) | Accompanying assets |
|-------|----------|--------------------|--------------------------------------|-----------------------|
| **mdpe-router** (`skills/mdpe-router/SKILL.md`) | User situation (free text) | Routing decision (no file) | → all skills; no memory-reading step | none |
| **mdpe-backlog-discovery** (`skills/mdpe-backlog-discovery/SKILL.md`) | Vision, problem, market, objectives, participants | `docs/discovery/00..05-*.yml` (+ `hypotheses/`, `risks/`, `validation/`) | → `mdpe-backlog` | `discovery-session-template.yml`, `validation-risks-template.yml`, `discovery-session.schema.json` |
| **mdpe-backlog** (`skills/mdpe-backlog/SKILL.md`) | `docs/discovery/01..05-*.yml` | `docs/backlog/backlog-index.yml`, `features/feat-XXX.yml`, `roadmap.yml` | ← discovery; → `mdpe-transformation` | `cognitive-backlog-template.yml`, `cognitive-backlog.schema.json` |
| **mdpe-transformation** (`skills/mdpe-transformation/SKILL.md`) | `feat-XXX.yml`, "technical context" (free text) | `microtasks/`, `dependencies/*.yml`, `validation/*.yml`, `prioritization/*.yml`, `docs/tasks.md` | ← backlog; → `mdpe-execution-context` | 6 templates + `mdpe-microtask.schema.json` |
| **mdpe-execution-context** (`skills/mdpe-execution-context/SKILL.md`) | `mt-XXX-YYY.yml`, `feat-XXX.yml`, "aggregated learnings" | `docs/execution/{id}-context.yml`, `{id}-setup.yml` | ← transformation; → `mdpe-coding` | `execution-context-template.yml`, `environment-setup-template.yml` |
| **mdpe-coding** (`skills/mdpe-coding/SKILL.md`) | `{id}-context.yml`, `{id}-setup.yml`, branch | code, `{id}-validation-report.yml`, `{id}-code-review.yml` | ← execution-context; → `mdpe-learnings` | **only** `validation-report-template.yml` |
| **mdpe-learnings** (`skills/mdpe-learnings/SKILL.md`) | context, setup, validation, code-review | `{id}-learnings.yml`, `learning-loops/aggregated-learnings.yml` | ← coding; → discovery/transformation/execution-context | **only** `mdpe-tracking.yml` |
| **mdpe-tasks** (`skills/mdpe-tasks/SKILL.md`) | Free text / `feat-XXX.yml` | `docs/mdpe-tasks/{item}.md` (a single file) | shortcut: replaces `T → EC`; → `mdpe-coding` | `mdpe-tasks-template.md` |

**Fragile coupling points identified (evidence):**

- **"Technical context" enters as free text** in transformation and execution-context, with no
  traceable origin. `skills/mdpe-transformation/SKILL.md` (*Inputs* section): *"Technical context: architecture,
  backend/frontend stack, database, infrastructure, code patterns, conventions."* Nothing defines where
  this architecture comes from → the architectural decision is coupled to the agent's improvisation.
- **The execution-context-template hardcodes the architecture**: `execution-context-template.yml`
  → `technical_context.architecture.overall_pattern: "Clean Architecture with DDD"` is fixed in
  the template as an example value, not derived from a decision.
- **Output path discontinuity** between skills (see Section E, inconsistency #2).

---

## Section B — Required vs optional fields per template/schema

In the **JSON schemas**, the requirement is formal (`required`/`minItems`). In the **YAML templates**
there is no optional marking: every field is presented as fillable — which is, in itself, a gap (Phase 8).

| Artifact | Required | Optional | Note (evidence) |
|----------|--------------|-----------|------------------------|
| `discovery-session.schema.json` | 5 root sections (`metadata`, `participants`, `agenda`, `outputs`, `next_steps`); ~26 fields required across the tree; `agenda` `minItems:1`; `metadata` 8 required | `facilitator_notes`, `participant_feedback`, `attachments`, `stakeholders`, `technical_team` | `"required": ["metadata","participants","agenda","outputs","next_steps"]` |
| `cognitive-backlog.schema.json` (feature) | **13** at root (`id,name,description,category,priority,functionalities,value_criteria,personas_served,hypotheses,dependencies,risks,acceptance_criteria,metadata`); `value_criteria`/`personas_served`/`acceptance_criteria` `minItems:1`; `priority` with 5 required | `discovery_notes`; `rice` | `hypotheses`/`risks` `minItems:0` (key required, list can be empty) |
| `mdpe-microtask.schema.json` (microtask) | **14** at root; `estimate` 6 required; `metadata` 7 required; `aert_validation` 4 (each requires `validated`+`justification`); `output.generated_artifacts` `minItems:1`; `input.technical_knowledge`/`tools` `minItems:1` | `risks`, `technical_notes`, `external_resources`, `non_functional` (`minItems:0`) | Deep required nesting → strong driver of filler content (Phase 8) |
| `discovery-session-template.yml` | — (no marking) | — | 8 sections, **0 marked as optional** |
| `validation-risks-template.yml` | — | — | 10 model files, **0 optional** |
| `cognitive-backlog-template.yml` | — | — | 3 artifacts (index/feature/roadmap), **0 optional** |
| `mdpe-microtask-template.yml` | — | — | mirrors the schema (16 sections), **0 optional** |
| `execution-context-template.yml` | — | — | 8 dimensions/sections, **0 optional** |
| `environment-setup-template.yml` | — | — | 7 sections, **0 optional** |
| `dependencies-template.yml` | — | — | 7 model files, **0 optional** |
| `validation-report-template.yml` | — | — | 6 dimensions + summary, **0 optional** |
| `mdpe-tracking.yml` | — | — | metrics + graph, **0 optional**; promises non-existent automatic calculation |
| `tasks-template.yml` / `mdpe-tasks-template.md` | — | — | output structure, **0 optional** |

---

## Section C — Referenced artifacts that DO NOT exist in the repository

Confirmed by search (`file_search`/`grep_search`): the items below are cited as if they existed, but
there is no corresponding file. These are "phantom references."

| Referenced | Where it is cited (evidence) | Exists? |
|--------------|---------------------------|---------|
| `tools/mdpe-status.py` | `mdpe-tracking.yml` → *USAGE INSTRUCTIONS* (`python3 tools/mdpe-status.py update/report`) and `config.auto_calculations` | **No** (search for `mdpe-status` → 0 results) |
| `.github/workflows/mdpe-tracking-update.yml` | `mdpe-tracking.yml` → *"CI/CD INTEGRATION … See: .github/workflows/mdpe-tracking-update.yml"* and `config.integrations.github` | **No** (search for `.github` → 0 results) |
| `aggregated-learnings.yml` (template/schema) | `skills/mdpe-learnings/SKILL.md` (*Outputs* and *Quality gate*), `docs/mdpe-flow.md`, `docs/mapping-commands-to-skills.md` | **Output promised without a template**: the learnings assets only contain `mdpe-tracking.yml` |
| `{id}-learnings.yml` (template) | `skills/mdpe-learnings/SKILL.md` → *"Per task: `docs/execution/{microtask-id}-learnings.yml`"* | **No template** |
| `{id}-code-review.yml` (template) | `skills/mdpe-coding/SKILL.md` → *"Output: `docs/execution/{microtask-id}-code-review.yml`"* | **No template** (coding assets only have `validation-report-template.yml`) |
| ~~`docs/architecture/decision.md`, `docs/adr/ADR-005-user-schema.md`~~ | ~~`mdpe-microtask-template.yml` (example input) and `mdpe-tracking.yml` (example artifact)~~ | **Resolved in Phase 3/9** — `mdpe-architecture` now produces `docs/architecture/decisions.yml` and, conditionally, `docs/adr/adr-NNN-{slug}.md`; the four phantom examples (`mdpe-microtask-template.yml`, `mdpe-tracking.yml`, and the two in `environment-setup-template.yml`) were realigned in task 9.1 |

---

## Section D — Gap map: user questions × evidence

Each question has ≥1 gap, with file/excerpt and observable criterion. The *Phase* column links to the
phase that must close the gap (per the map in `tasks-v1.md`).

### Question 7 — "What do current frameworks have that is strong, which we lack" → **Phase 1**

- **Gap 7.1 — There is no competitive benchmark or evaluation rubric.**
  Evidence: `docs/` contains only `mapping-commands-to-skills.md` and `mdpe-flow.md`; there is no
  `docs/analysis/competitive-analysis.md` or `evaluation-rubric.md`.
  Observable criterion: files absent from the repo (this very Phase 1 creates them).

### Question 2 — "We already have code: minimum needed to proceed via discovery of existing code" → **Phase 2**

- **Gap 2.1 — Discovery is greenfield-only.**
  Evidence: `skills/mdpe-backlog-discovery/SKILL.md` (*When to use*): *"Use when: Starting a new product or a
  major new cycle"*; it requires *"20-30 unique features"*, *"At least 2 personas"* and MoSCoW (see *Quality gate*).
  Observable criterion: there is no mode/trigger for "repository with existing code"; a search for
  `brownfield`/`existing code` in the repo → 0 occurrences outside `tasks-v1.md`.
- **Gap 2.2 — The router has no route for existing code.**
  Evidence: `skills/mdpe-router/SKILL.md` (*Routing table*) only covers "Starting a new product/project";
  no line for repo inventory.
  Observable criterion: routing table with no brownfield entry.
- **Gap 2.3 — The fast-path (`mdpe-tasks`) still frames things by invention, not by reading code.**
  Evidence: `skills/mdpe-tasks/SKILL.md` Phase 1 asks for *Objective/Problem/Value* derived from text,
  not from existing code.
  Observable criterion: no instruction to inventory stack/modules from the repo.

### Question 1 — "How to define architecture standards from the backlog (`mdpe-architecture`)" → **Phase 3**

- **Gap 1.1 — Architecture only exists as a review dimension, not as a decision.**
  Evidence: `skills/mdpe-coding/SKILL.md` Phase 3, dimension 2: *"Architecture — respects patterns,
  boundaries, and dependency direction"* — it evaluates, but does not decide.
  Observable criterion: there is no skill/step that produces architectural decisions.
- **Gap 1.2 — Architecture enters as free text with no origin.**
  Evidence: `skills/mdpe-transformation/SKILL.md` (*Inputs*): *"Technical context: architecture … code
  patterns, conventions"*; `execution-context-template.yml` hardcodes `overall_pattern: "Clean Architecture
  with DDD"`.
  Observable criterion: no `architecture-decisions`/ADR artifact is generated; ADRs only appear as
  examples in `mdpe-microtask-template.yml`/`mdpe-tracking.yml` with no producer.

### Question 3 — "Implementation fidelity + loop engineering" → **Phase 4**

- **Gap 3.1 — The loop depends on the agent and does not force evidence of execution.**
  Evidence: `skills/mdpe-coding/SKILL.md` Phase 2: *"If any dimension fails, return to Phase 1"* —
  with no obligation to run build/tests. `validation-report-template.yml` has `validated: false` /
  `status: "pending"` per dimension and allows `summary.overall_status: approved` without filling in
  `commands_executed`/`evidence`.
  Observable criterion: it is possible to mark `decision: ready_for_review` with no command output at all.
- **Gap 3.2 — No stopping criterion / iteration counter.**
  Evidence: `validation-report-template.yml` has no "iterations until green" field; `mdpe-coding`
  defines no attempt limit or root-cause diagnosis.
  Observable criterion: absence of an iteration/limit field → risk of an endless loop or "done" claims with no proof.

### Question 4 — "How to measure the execution process" → **Phase 5**

- **Gap 4.1 — Tracking promises non-existent automation.**
  Evidence: `mdpe-tracking.yml` cites `tools/mdpe-status.py`, `.github/workflows/mdpe-tracking-update.yml`
  and `config.auto_calculations` — **none of them exist** (Section C).
  Observable criterion: searches return 0 results for `mdpe-status` and `.github`.
- **Gap 4.2 — Metrics with no clear derivable source.**
  Evidence: `mdpe-tracking.yml` `metrics` section (throughput, cycle/lead time, rejection_rate) with
  no link to an artifact field that MDPE already generates.
  Observable criterion: no metric points to the `validation-report`/`code-review`/`learnings` field
  it is derived from.

### Question 5 — "Visualize the relationship between tasks/features (graphs)" → **Phase 6**

- **Gap 5.1 — Graph data is generated but never unified or rendered.**
  Evidence: `skills/mdpe-transformation/SKILL.md` Phase 2 generates `dependencies/full-graph.yml`,
  `waves.yml`, `critical-path.yml`, `parallelizable.yml` (per feature); `mdpe-tracking.yml` has
  `dependency_graph: nodes/edges`. No step unifies or draws them.
  Observable criterion: no unified graph artifact exists; the Mermaid diagrams present
  (`docs/mdpe-flow.md`, `mdpe-router/SKILL.md`) are **hardcoded** routing diagrams, not generated
  from the dependency YAMLs.
- **Gap 5.2 — Traceability only covers microtask↔microtask.**
  Evidence: `dependencies-template.yml` only links micro-tasks to each other; there is no
  discovery→feature→microtask→architecture→artifact→learning edge.
  Observable criterion: absence of cross-cutting node/edge types in the templates.

### Question 6 — "How to build memory" → **Phase 7**

- **Gap 6.1 — Memory is write-only; no one reads it before acting.**
  Evidence: `skills/mdpe-router/SKILL.md` has no "consult memory" step; `mdpe-learnings` writes
  `aggregated-learnings.yml`, but discovery/transformation/coding have no contract to read it.
  Observable criterion: no entry-point skill instructs reading memory before deciding/routing.
- **Gap 6.2 — `aggregated-learnings.yml` has no template.**
  Evidence: `mdpe-learnings` assets contain only `mdpe-tracking.yml` (Section C).
  Observable criterion: promised output with no model artifact.

### Question 8 — "Reduce AI-generated content / optional vs required / anti-hallucination" → **Phase 8**

- **Gap 8.1 — Rigid minimums force volume.**
  Evidence: `mdpe-backlog-discovery/SKILL.md` *"20-30 unique features"*; `mdpe-transformation/SKILL.md`
  *"15-25 atomic micro-tasks"*; `mdpe-execution-context/SKILL.md` always 6 dimensions.
  Observable criterion: quality gates require these counts regardless of the item's size.
- **Gap 8.2 — Schemas with deep required nesting.**
  Evidence: `mdpe-microtask.schema.json` 14 required fields at root + `estimate` (6) + `metadata`
  (7) + `aert_validation` (4×2).
  Observable criterion: count of `required` (Section B).
- **Gap 8.3 — Templates with no optional marking and no anti-hallucination guideline.**
  Evidence: all `*.yml` files in `assets/templates` have 0 fields marked as optional; no
  `SKILL.md` contains a "do not invent to fill this in" statement.
  Observable criterion: search for "optional"/"do not invent" in the templates → absent.

### Question 9 — "Improvements to what will be produced" → **Phase 9**

- ~~**Gap 9.1 — Inconsistent output paths between skills.**~~ **Resolved in task 9.1.**
  `mdpe-execution-context/SKILL.md` and `environment-setup-template.yml` were realigned to
  write to `docs/transformation/{feature-id}/execution/` — the same canonical path that
  `tasks-template.yml`, `validation-report-template.yml`, and `mdpe-tracking.yml` already used.
  `mdpe-graph` still accepts the legacy path `docs/execution/` as valid input (for
  artifacts written before the realignment) and continues to flag a path issue when it
  finds a file outside the canonical location — never reclassifying it as an orphan.
- ~~**Gap 9.2 — Divergent scoring formula between documents.**~~ **Resolved in task 9.1.**
  `docs/mapping-commands-to-skills.md` was fixed to `Value × (10 - Effort)`, aligned with
  `mdpe-backlog-discovery/SKILL.md` and `mdpe-backlog/SKILL.md`.
- ~~**Gap 9.3 — Inconsistent schema `$id` (exposed copy origin).**~~ **Resolved in
  task 9.1.** `cognitive-backlog.schema.json` and `mdpe-microtask.schema.json` were aligned to
  `https://mdpe.dev/...`, the same domain as `discovery-session.schema.json`, and gained the
  `$schema` key that was missing.

---

## Section E — Cross-cutting inconsistencies (evidence for Phase 9)

1. ~~**Divergent execution output path**~~ — resolved in task 9.1 (see Gap 9.1).
2. ~~**Value×(10-Effort) vs Value×(11-Effort) formula**~~ — resolved in task 9.1 (see Gap 9.2).
3. ~~**Mixed schema `$id` domains (`hubturismo.com` vs `mdpe.dev`)**~~ — resolved in
   task 9.1 (see Gap 9.3).
4. **Outputs with no template** (`aggregated-learnings.yml`, `{id}-learnings.yml`, `{id}-code-review.yml`) —
   already resolved in Phases 6/7 (all three gained a dedicated template: see
   `skills/mdpe-learnings/assets/templates/{aggregated-learnings,microtask-learnings}-template.yml` and
   `skills/mdpe-coding/assets/templates/code-review-template.yml`). Kept here only as a
   historical record of Section C.

---

## Section F — Additional gaps identified post-v1 (Phase 10)

v1 (Phases 1-9) answered the user's 9 original questions. A second round of analysis —
performed on the already-implemented set of 14 skills, not on the pre-v1 baseline — identified
4 new gaps, outside the scope of the 9 original questions. Each one follows the same acceptance rule:
file evidence + observable criterion.

- **Gap R.1 — No skill produces release communication for those who consume the software.**
  Evidence: `skills/mdpe-learnings/SKILL.md` (*Outputs*) lists only
  `{microtask-id}-learnings.yml`, `aggregated-learnings.yml`, `docs/memory/project-memory.yml`, and
  `mdpe-tracking.yml` — no artifact aimed at those who use the software (end user, client,
  support team). `skills/mdpe-router/SKILL.md` (*Routing table*) has no line for
  "we're about to release a version" / "I need to communicate what changed."
  Observable criterion: search for `CHANGELOG`/`release notes` in the repository → 0 occurrences
  outside this analysis.

- **Gap R.2 — Brownfield discovery is code-centric; there is no path to reconstruct the domain
  from a schema/database when the application code is not the starting point.**
  Evidence: `docs/adr/adr-001-brownfield-discovery.md` and `skills/mdpe-code-discovery/SKILL.md`
  treat "code" as manifests, routes, handlers, and application files; the *Inputs* section of
  `mdpe-code-discovery` does not cite schema, DDL, migration, or database dump as a valid input in
  its own right — a legacy database with no readable application layer (or with an application in
  an unsupported stack) has no entry point.
  Observable criterion: search for `schema`/`DDL`/`migration` in `mdpe-code-discovery/SKILL.md` →
  absent as a first-class concept.

- **Gap R.3 — All project-state communication is technical; there is no plain-language projection
  for non-technical stakeholders.**
  Evidence: `skills/mdpe-router/SKILL.md` (Step 0) announces state using memory-index vocabulary
  (`ad-NNN`, `mt-XXX-YYY`, `staleness[]`); `skills/mdpe-graph/SKILL.md` (Phase 6 — Dispatch)
  answers "what's running now" by citing node ids and artifact fields — both addressed to whoever
  reads YAML/Mermaid, not to someone who just wants to know if the project is on schedule.
  Observable criterion: no framework artifact uses an RAG (red/amber/green) format or
  omits technical ids by default.

- **Gap R.4 — Learnings are curated per microtask; they are never aggregated into a cycle-closing
  ceremony with an action item and an owner.**
  Evidence: `skills/mdpe-learnings/SKILL.md` runs *"once per micro-task (aggregated across the
  project)"* — the aggregation lives inside the learning register (`candidate → confirmed → retired`),
  never as a periodic narrative; no framework structure has an `owner` field on an action item,
  nor any notion of a sprint/cycle boundary.
  Observable criterion: search for `owner`/`sprint`/`cycle boundary` in the `mdpe-learnings`
  templates → absent as a structured field with an owner and an aggregate deadline.

| Gap | Question it answers | Skill that closes it | Rubric axis |
|---|---|---|---|
| R.1 | "How to communicate what changed to those who use the software?" | `mdpe-release` | Axis 9 (new) |
| R.2 | "I only have a legacy database/schema, with no readable app code" | `mdpe-data-discovery` | Axis 1 (extended) |
| R.3 | "How do I report progress to someone who doesn't read YAML?" | `mdpe-status-report` | Axis 10 (new) |
| R.4 | "How do we close the cycle with a retro, not just isolated learnings?" | `mdpe-retro` | Axis 11 (new) |

## Summary

- **9/9 user questions** have ≥1 mapped gap with a reference to a specific file and an observable
  criterion (Section D). Plus **4 post-v1 gaps** (R.1-R.4, Section F), closed in Phase 10.
- **Required vs optional count** consolidated per template/schema (Section B).
- **Phantom references** explicitly identified (Section C): `tools/mdpe-status.py`,
  `.github/workflows/mdpe-tracking-update.yml`, and three outputs with no template.

| Question | Phase | # gaps | Key evidence |
|----------|------|-----------|-----------------|
| 7 Benchmark | 1 | 1 | absence of `docs/analysis/*` |
| 2 Brownfield | 2 | 3 | `mdpe-backlog-discovery` greenfield-only; router has no route |
| 1 Architecture | 3 | 2 | architecture only as review + free text |
| 3 Fidelity/loop | 4 | 2 | `validation-report` approves with no evidence |
| 4 Metrics | 5 | 2 | `tools/mdpe-status.py` does not exist |
| 5 Graphs | 6 | 2 | per-feature graph never unified/rendered |
| 6 Memory | 7 | 2 | write-only memory; no template |
| 8 Anti-hallucination | 8 | 3 | rigid minimums + heavy schemas + 0 optional |
| 9 Output | 9 | 3 | inconsistent paths/formula/`$id` |

> Content drafted from a direct reading of the repository files. Quoted excerpts were
> paraphrased/shortened for reference; consult the original files for the full text.
</content>
