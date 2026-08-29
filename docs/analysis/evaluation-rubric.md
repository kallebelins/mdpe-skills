# Evaluation Rubric — MDPE Framework Assessment Scale

> **Source task:** `tasks-v1.md` → Phase 1 → 1.2 (Define the framework's evaluation scale).
> **Input:** `docs/analysis/baseline-gap-map.md` (audit 1.1).
> **Objective:** an objective rubric (0-5 per criterion) across 8 axes, reusable as the **definition of done**
> for Phases 2-9, with the **current baseline scored** and the **target** each phase must reach.
> **Acceptance rule applied:** every criterion has a definition, a 0-5 scale with anchors at **every level**
> (not just numbers), a concrete example for score 0 and score 5, and an initial score traced to a gap in the gap-map.

## How to read this rubric

- **Axis:** the dimension being evaluated. There are 8, one per user theme-question (except verbosity and hallucination,
  which share Phase 8).
- **0-5 scale:** each level has a descriptive anchor. No anchor → invalid score.
- **Baseline:** current score (August/2026), with evidence citing a gap from `baseline-gap-map.md`.
- **Target / phase:** the minimum score the responsible phase must deliver to consider the axis "done".
- **Use as DoD:** when closing a phase, re-score the axis; if the score < target, the phase is not complete
  (see Phase 9.3 — final re-scoring).

### Common level semantics (cross-cutting anchor)

| Level | General meaning |
|-------|-------------------|
| **0** | Absent. The capability does not exist in any form. |
| **1** | Incidental. Only appears as a side effect/example, with no contract or trigger. |
| **2** | Partial. Data or a foundation exists, but it's fragmented and not operable end to end. |
| **3** | Defined. There is a contract/specification (ADR/skill/template), but it is not consistently applied or verifiable. |
| **4** | Implemented and verifiable. Works with real evidence; solid, traceable minimum viable version. |
| **5** | Optimized. Verifiable, integrated into the flow and into memory/metrics, with no phantom references or regression. |

Each axis below specializes these levels with its own anchors.

---

## Axis 1 — Brownfield coverage

**Definition.** The ability to adopt MDPE on a repository that **already contains code**, without requiring a
full greenfield discovery session: inventorying stack/modules/conventions and reconstructing features from
the real code, serving as a bridge into transformation/tasks. Measurable by: is there an entry trigger for
existing code? Does the output reference real, verifiable files? Does the minimum path skip
personas/MoSCoW?

| Level | Anchor |
|-------|--------|
| 0 | No path for existing code; greenfield only. |
| 1 | A fast path exists, but it frames things via text/invention, without reading the repository. |
| 2 | There is guidance to look at the code, but with no structured inventory or file traceability. |
| 3 | An ADR defines the brownfield mode (minimum inputs/outputs, what can be skipped), without implementation. |
| 4 | A brownfield skill/mode generates an inventory + ≥1 reconstructed feature citing real files; an empty repo does not generate invented features. |
| 5 | Brownfield is routed by the router, feeds architecture/transformation, and never cites a nonexistent path; integrated into the flow and into memory. |

- **Score 0 example:** asking "I already have code, now what?" and the framework only offering new-product discovery.
- **Score 5 example:** pointing at the repo root, receiving a stack/layer inventory + reconstructed features
  with links to real files, and moving straight into architecture/transformation.
- **Baseline: 1.** Discovery is greenfield-only and requires 20-30 features/personas/MoSCoW; the router has no
  brownfield route; the `mdpe-tasks` fast path derives from text, not from code (gap-map Gaps 2.1, 2.2, 2.3).
- **Target: 4 — Phase 2** (ADR 2.1 brings it to 3; implementation 2.2 brings it to 4). Reaches 5 with the Phase 9.2 wiring.

---

## Axis 2 — Architecture definition

**Definition.** The ability to **decide** architecture patterns from the backlog/discovery (style,
layers, patterns, trade-offs, non-functional requirements) and feed those decisions into transformation/execution-context —
instead of architecture entering as free text or only being assessed during review.
Measurable by: is there a decision artifact (ADR) traced to a backlog item? Does transformation consume
that output? In brownfield, does it respect the inventoried architecture?

| Level | Anchor |
|-------|--------|
| 0 | Architecture does not appear as its own concept. |
| 1 | Architecture only exists as a review dimension and/or as free text/hardcoded example. |
| 2 | There is a place to record architecture, but with no traceability to the backlog or downstream consumption. |
| 3 | An ADR defines how architecture decisions arise from the backlog and where they fit in the flow, with no skill. |
| 4 | `mdpe-architecture` generates decisions + ADR(s) traced to the item; transformation/execution-context reference the output. |
| 5 | Decisions consult memory/conventions, respect existing brownfield architecture, and the "Architecture" dimension of `mdpe-coding` validates against them instead of re-evaluating from scratch. |

- **Score 0 example:** no step in the entire cycle mentions an architectural choice.
- **Score 5 example:** an ADR (style, layers, trade-offs, NFRs) comes out of `feat-012`, which transformation
  cites and review uses as a benchmark, respecting the pattern already present in the repo.
- **Baseline: 1.** Architecture only appears as dimension 2 of review in `mdpe-coding` and as "technical
  context" in free text; `execution-context-template.yml` hardcodes `overall_pattern: "Clean Architecture
  with DDD"`; ADRs only exist as examples with no producer (gap-map Gaps 1.1, 1.2; Section C).
- **Target: 4 — Phase 3** (ADR 3.1 → 3; skill 3.2 → 4). Reaches 5 with memory (P7) and wiring (P9).

---

## Axis 3 — Implementation fidelity and loop engineering

**Definition.** The degree to which execution follows an explicit loop contract (plan → act → verify): the agent
**runs** build/lint/tests, iterates until green or up to a limit, never declares "done" without execution
evidence, diagnoses root cause after N failures, and the output matches the acceptance criteria/IOQD of the
microtask. Measurable by: does the "approved" verdict require command evidence? Is there an iteration limit and
behavior when it's exceeded? Is there traceability from microtask → acceptance?

| Level | Anchor |
|-------|--------|
| 0 | There is no notion of verifying before concluding. |
| 1 | A return-to-fix loop exists, but it depends on the agent and allows "approved" without running anything. |
| 2 | Verification is recommended, but with no evidence field or stopping criterion. |
| 3 | An ADR defines the contract (steps, commands, iteration limit, root cause, fidelity), without enforcement. |
| 4 | `mdpe-coding` requires evidence per dimension (command + result) and counts iterations until green; a failing test blocks "approved". |
| 5 | Fidelity is traced microtask → IOQD → acceptance; evidence feeds metrics (P5) and the gate automatically blocks approval without proof. |

- **Score 0 example:** implementing and marking as done with no notion whatsoever of testing/verification.
- **Score 5 example:** each dimension of the report carries the command executed and its output, the number of
  iterations until green is recorded, and a microtask with a failing test cannot reach "approved".
- **Baseline: 1.** `mdpe-coding` has a "return to Phase 1" loop without requiring build/tests;
  `validation-report-template.yml` allows `overall_status: approved` without `commands_executed`/`evidence`
  and has no iteration field (gap-map Gaps 3.1, 3.2).
- **Target: 4 — Phase 4** (ADR 4.1 → 3; reinforcement 4.2 → 4). Reaches 5 when connected to metrics (P5).

---

## Axis 4 — Measurability (execution metrics)

**Definition.** The ability to measure the process with a **sustainable** set of metrics derived from
artifacts MDPE already generates (validation-report, code-review, learnings), without depending on
nonexistent tooling. Measurable by: does each metric point to its source field/artifact? Is what's not
sustainable optional/removed? Are frequency and owner defined?

| Level | Anchor |
|-------|--------|
| 0 | There are no metrics. |
| 1 | Tracking exists but promises nonexistent automation (missing scripts/CI) and metrics with no derivable source. |
| 2 | Some metrics have a clear source, but coexist with unmarked "phantom references". |
| 3 | An ADR defines the minimum set, the source of each metric, and the automatic vs. manual split, without applying it. |
| 4 | `mdpe-tracking.yml` only requires what's derivable from existing artifacts; no instruction points to a nonexistent script/workflow without a note. |
| 5 | Metrics are fillable from 1 real microtask; fed by loop evidence (P4) and the graph (number of orphans, critical path). |

- **Score 0 example:** nowhere records throughput, rework, or cycle time.
- **Score 5 example:** tracking is filled only with real data from a microtask, each metric points to the
  artifact field it comes from, and there's no promise of automatic calculation without tooling.
- **Baseline: 1.** `mdpe-tracking.yml` cites `tools/mdpe-status.py`, `.github/workflows/...` and
  `config.auto_calculations` which don't exist, and metrics don't point to a source field (gap-map Gaps
  4.1, 4.2; Section C).
- **Target: 4 — Phase 5** (ADR 5.1 → 3; reconciliation 5.2 → 4). Reaches 5 with the loop (P4) and the graph (P6).

---

## Axis 5 — Visualization and traceability (graph engineering)

**Definition.** The ability to unify graph data scattered across features into a traceability graph that
links the whole chain (discovery → feature → microtask → architecture decision → artifact/file → learning)
and render it (Mermaid/DOT), supporting critical path, impact, orphans, and cycles. Measurable by: is there
a unified graph? Is every edge traceable to an artifact? Does it render in the repo's Markdown without paid
tooling?

| Level | Anchor |
|-------|--------|
| 0 | There is no dependency data or diagram. |
| 1 | Only hardcoded routing diagrams; none derived from the YAMLs. |
| 2 | Graph data is generated per feature (`dependencies/*.yml`), but never unified or rendered. |
| 3 | An ADR defines nodes/edges/sources and use cases (visualize, critical path, impact, orphans, cycles), without generation. |
| 4 | Generates a Mermaid diagram whose nodes/edges match the YAMLs, distinguishing waves and critical path, with no invented edge. |
| 5 | Cross-cutting traceability (backlog→architecture→microtask→artifact→learning) + impact analysis/queries, feeding metrics (P5) and memory (P7). |

- **Score 0 example:** there's no way to know that microtask B depends on A.
- **Score 5 example:** a generated diagram shows waves and critical path, answers "what changes if
  microtask X changes?", and every edge points to the artifact that originates it.
- **Baseline: 2.** `mdpe-transformation` generates `dependencies/full-graph.yml`, `waves.yml`,
  `critical-path.yml`, `parallelizable.yml`, and tracking has `dependency_graph`, but nothing unifies or
  draws them; traceability only covers microtask↔microtask (gap-map Gaps 5.1, 5.2).
- **Target: 4 — Phase 6** (ADR 6.1 → 3; generation 6.2 + skill `mdpe-graph` 6.4 → 4; impact 6.3 → 5).

---

## Axis 6 — Memory

**Definition.** The ability to build and **retrieve** memory across sessions: the agent consults decisions,
conventions, and recurring errors **before** acting, and updates memory at the end. Layers: project
(decisions/conventions), aggregated learnings (loops), and execution (tracking). Measurable by: is there a
read contract (when to read) and a write contract (when to update)? Is a recorded decision readable in the
next session? Is there curation/consolidation?

| Level | Anchor |
|-------|--------|
| 0 | Nothing is remembered across sessions. |
| 1 | Write-only memory: learnings are recorded, but no one reads them before deciding; no output template. |
| 2 | A readable artifact exists, but with no read trigger in the entry-point skills. |
| 3 | An ADR defines layers, format, location, and read/write contracts, without implementation. |
| 4 | Router/discovery/architecture/coding consult memory before deciding; learnings updates it when closing the microtask. |
| 5 | Decisions from one session are available in the next, with a consolidation/curation rule and no duplication between aggregated-learnings/tracking. |

- **Score 0 example:** the same error repeats every session because nothing is consulted.
- **Score 5 example:** when routing, the agent reads project memory, applies a previously decided
  convention, and when closing the microtask records the new decision — which the next session already sees.
- **Baseline: 1.** `mdpe-learnings` writes `aggregated-learnings.yml`, but the router has no read step
  and there is no template for the aggregate (gap-map Gaps 6.1, 6.2; Section C).
- **Target: 4 — Phase 7** (ADR 7.1 → 3; implementation 7.2 → 4). Reaches 5 with curation + wiring (P9).

---

## Axis 7 — Cognitive cost / verbosity

**Definition.** The degree to which the framework avoids forcing volume: essential fields are required,
the rest are conditional/optional, and rigid minimums (e.g., "15-25 microtasks") become ranges guided by
size. Measurable by: does every field have a justified classification (essential/conditional/optional)?
Can optional fields be left blank without failing the gate? Are small items exempt from the minimum?

| Level | Anchor |
|-------|--------|
| 0 | Everything is required and minimums are fixed regardless of item size. |
| 1 | Templates with no optional marking; rigid minimums (20-30 features, 15-25 microtasks, always 6 dimensions). |
| 2 | Some fields marked as optional, but rigid minimums remain. |
| 3 | An audit classifies each field (essential/conditional/optional) with justification, without applying it. |
| 4 | Non-essential fields are optional and can be left empty without failing the gate; minimums become "size-appropriate" ranges. |
| 5 | Volume proportional to the item, without losing traceability/verification; reconciled with the evidence requirement from P4. |

- **Score 0 example:** a 4-task item forced to become 15-25 microtasks and to fill in 6 dimensions.
- **Score 5 example:** the same small item generates few microtasks, leaves optional fields blank, and
  still keeps the essential traceability.
- **Baseline: 1.** Rigid minimums in discovery/transformation/execution-context; schemas with deep
  requiredness; **0 fields** marked optional in the templates (gap-map Gaps 8.1, 8.2,
  8.3; Section B).
- **Target: 4 — Phase 8** (audit 8.1 → 3; trimming 8.2 → 4). Reaches 5 reconciled with P4/P9.

---

## Axis 8 — Hallucination risk

**Definition.** The degree to which the framework prevents invented content: an explicit "don't invent to
fill in" guideline, fields that can be left empty/"unknown", and the guarantee that every cited file path
is real (never "TBD" or a phantom reference). Measurable by: does each skill have an anti-fabrication
sentence? Is there any reference to a nonexistent artifact? Does the output cite only verifiable files?

| Level | Anchor |
|-------|--------|
| 0 | Nothing discourages invention; fictitious placeholders and paths are accepted. |
| 1 | No anti-hallucination guideline; phantom references exist (scripts/workflows/outputs with no producer). |
| 2 | The guideline is mentioned in some skills, but phantom references persist. |
| 3 | The guideline is specified and phantom references are inventoried, without correction applied. |
| 4 | Every affected skill has an anti-fabrication sentence; optional fields accept empty; no cited path is nonexistent. |
| 5 | Output is always traceable to a real artifact; brownfield/graph never invent files/edges; verified end to end (P9.3). |

- **Score 0 example:** a reconstructed feature pointing to a file that doesn't exist in the repo.
- **Score 5 example:** when data is missing, the skill leaves the field empty/"unknown" instead of
  inventing it, and every cited path resolves.
- **Baseline: 1.** No `SKILL.md` has a "don't invent" sentence; there are phantom references
  (`tools/mdpe-status.py`, a CI workflow, outputs with no template) and templates that induce filling
  (gap-map Gap 8.3; Section C).
- **Target: 4 — Phase 8** (together with 8.1/8.2). Reaches 5 with the evidence loop (P4) and e2e validation (P9.3).

---

## Axis 9 — Release communication

**Definition.** The ability to close out a feature/version with an artifact aimed at whoever consumes the
software (user, customer, support) — not the agent or the developer — derived only from
micro-tasks actually completed and evidenced, following a standardized format (categories,
reverse chronological order). Measurable by: does a release artifact exist? Does every entry trace to a
completed microtask with evidence? Is the language directed at the consumer, not the implementer?

| Level | Anchor |
|-------|--------|
| 0 | No release artifact exists; nothing communicates what changed. |
| 1 | Informal mention of a "changelog" with no defined format or source. |
| 2 | There's an intent to record changes, but with no categories or traceability to a completed microtask. |
| 3 | An ADR defines the format (Keep a Changelog), the source of each entry, and the inclusion criterion, with no skill. |
| 4 | `mdpe-release` generates the changelog only from `completed`+evidenced microtasks; no invented change; correct categories. |
| 5 | Changelog + internal provenance trail coexist; a previous version is never rewritten; feeds and is fed by memory/tracking. |

- **Score 0 example:** a feature closes and nothing anywhere states what it delivered, except technical YAML.
- **Score 5 example:** `CHANGELOG.md` lists the feature in user-facing language, each line traces to
  1+ `mt-XXX-YYY` `completed` with an existing artifact, and the previous version remains intact.
- **Baseline: 0.** No release artifact exists in the framework (gap-map Gap R.1).
- **Target: 4 — Phase 10** (ADR 10.1/10.2 → 3-4). Reaches 5 with wiring and the provenance trail.
- **Re-scored: 4.** `docs/adr/adr-007-release-notes.md` defines the source/format/rules;
  `skills/mdpe-release/SKILL.md` + `assets/templates/changelog-template.md` implement the skill; evidence-based
  categorization (D5) and immutability of a published version (D7) are in the gate. Routed
  in the router, `mdpe-flow.md`, `mapping-commands-to-skills.md`, and README (task 10.9). Level 5 depends
  on a real execution of the framework producing `CHANGELOG.md` from microtasks actually
  completed — not yet verifiable without a running project (deferred to
  10.10/e2e validation).

---

## Axis 10 — Stakeholder communication (status report)

**Definition.** The ability to project project state in plain language, with no technical jargon
or mandatory IDs in the main body, for decision-makers who don't read YAML — while keeping, in an appendix,
traceability to artifact+field for anyone who wants to verify. Measurable by: is there a RAG/1-pager
reading? Is every statement in the main body backed by a citable artifact in the appendix? Does the report
decide something, or just report?

| Level | Anchor |
|-------|--------|
| 0 | No projection of state in non-technical language exists. |
| 1 | State can only be communicated by reading YAML/Mermaid directly (mdpe-graph, tracking). |
| 2 | There is a state reading (router Step 0), but in technical vocabulary (ad-NNN, mt-XXX-YYY). |
| 3 | An ADR defines the format (RAG/1-pager), the sources per section, and the appendix traceability rule, with no skill. |
| 4 | `mdpe-status-report` generates a report with no jargon in the body, with a provenance appendix; nothing is decided in the report. |
| 5 | The report distinguishes accomplished/in-progress/risks-blockers/next steps with a source for each bullet; never a gate; integrated with the graph and memory. |

- **Score 0 example:** a stakeholder can only find out the state by asking a developer who opens the YAML.
- **Score 5 example:** the report has a status light (green/yellow/red) + 4 sections on one page, and the
  appendix shows where each bullet comes from.
- **Baseline: 0.** No projection in plain language exists (gap-map Gap R.3).
- **Target: 4 — Phase 10** (ADR 10.5/10.6 → 3-4). Reaches 5 with graph/memory integration.
- **Re-scored: 4.** `docs/adr/adr-009-status-report.md` defines the status light derived from a decision
  tree (D4), the zero-jargon-in-the-body rule (D3), and the provenance appendix (D5);
  `skills/mdpe-status-report/SKILL.md` + `assets/templates/status-report-template.md` implement the
  skill, already integrated with `mdpe-tracking.yml`, `mdpe-graph`, and `project-memory.yml` as sources (D2, D6).
  Routed in the router/flow/mapping/README (task 10.9). Level 5 depends on a real execution with actual
  signals (blockage, cross-feature cycle) to confirm the status light is never an opinion — deferred to
  e2e validation (10.10).

---

## Axis 11 — Cycle retrospective

**Definition.** The ability to aggregate multiple microtask closures (via `mdpe-learnings`) into
an end-of-cycle/feature/sprint ceremony: what worked, what to improve, action items — each
with an owner and a horizon — and a metrics trend reading when there are ≥2 cycles to
compare. Measurable by: does every bullet cite evidence (learning/tracking/verdict)? Does every action item have
an owner, even if "to be defined"? Does the trend only appear with ≥2 cycles?

| Level | Anchor |
|-------|--------|
| 0 | Learnings are never seen together; each microtask stays isolated. |
| 1 | The learnings record aggregates occurrences (`candidate`→`confirmed`), but produces no cycle ceremony. |
| 2 | There's enough data (tracking + learnings) for a retro, but no artifact reads them as a cycle. |
| 3 | An ADR defines the format (what worked / to improve / action), the source of each bullet, and the owner rule, with no skill. |
| 4 | `mdpe-retro` generates the retro only from evidence (learning/tracking/verdict); every action item has an `owner` (or "to be defined", never absent). |
| 5 | A metrics trend across cycles is cited when history exists; action items route to the same 3 targets as `mdpe-learnings`; never a gate. |

- **Score 0 example:** the team never sees a consolidated picture of what closed well or poorly in the cycle.
- **Score 5 example:** the retro cites 3 confirmed learnings with evidence, points out 2 overruns with root cause,
  and each action has an owner and a horizon — compared against the previous retro.
- **Baseline: 0.** No cycle ceremony exists; aggregation stops at the microtask level (gap-map
  Gap R.4).
- **Target: 4 — Phase 10** (ADR 10.7/10.8 → 3-4). Reaches 5 with history across cycles.
- **Re-scored: 4.** `docs/adr/adr-010-cycle-retro.md` defines the format (D4), the rule that `owner`
  is always present (D5), routing to the 3 existing targets of `mdpe-learnings` (D6), and the existence
  condition for the Trend section (D7); `skills/mdpe-retro/SKILL.md` +
  `assets/templates/retro-template.md` implement the skill, reading (never re-curating)
  `aggregated-learnings.yml` and `mdpe-tracking.yml`. Routed in the router/flow/mapping/README (task
  10.9). Level 5 depends on ≥2 real cycles to exercise the Trend section — deferred to e2e validation
  (10.10) and to the project's second real cycle.

---

## Consolidated scoreboard (baseline × target)

| # | Axis | Question | Baseline | Target | Responsible phase | Key evidence (gap-map) |
|---|------|----------|:-------:|:----:|------------------|---------------------------|
| 1 | Brownfield coverage | 2 | 1 | 4 | Phase 2 | Gaps 2.1-2.3 (greenfield-only discovery) |
| 2 | Architecture definition | 1 | 4 | Phase 3 | Gaps 1.1-1.2 (only review + free text) |
| 3 | Fidelity / loop | 3 | 1 | 4 | Phase 4 | Gaps 3.1-3.2 (approves without evidence) |
| 4 | Measurability | 4 | 1 | 4 | Phase 5 | Gaps 4.1-4.2 (nonexistent tooling) |
| 5 | Visualization / graphs | 5 | 2 | 4 | Phase 6 | Gaps 5.1-5.2 (graph never unified) |
| 6 | Memory | 6 | 1 | 4 | Phase 7 | Gaps 6.1-6.2 (write-only; no template) |
| 7 | Cognitive cost / verbosity | 8 | 1 | 4 | Phase 8 | Gaps 8.1-8.3 (rigid minimums; 0 optional) |
| 8 | Hallucination risk | 8 | 1 | 4 | Phase 8 | Gap 8.3 + Section C (phantom references) |
| 9 | Release communication | R.1 | 0 | 4 | Phase 10 | Gap R.1 (no release artifact) — **re-scored: 4** |
| 10 | Stakeholder communication | R.3 | 0 | 4 | Phase 10 | Gap R.3 (state only in technical vocabulary) — **re-scored: 4** |
| 11 | Cycle retrospective | R.4 | 0 | 4 | Phase 10 | Gap R.4 (learning never aggregated into a cycle) — **re-scored: 4** |

- **Aggregate baseline (v1, Axes 1-8):** 9/40 (average ≈ 1.1/5).
- **Aggregate target for v1 (Axes 1-8):** 32/40 (average 4.0/5) — minimum to consider v1 done.
- **Aggregate baseline (Axes 9-11, Phase 10):** 0/12 (all three start at 0 — no artifact existed).
- **Aggregate target for Phase 10 (Axes 9-11):** 12/12 (4/5 each) — minimum to consider Phase 10 done.
- **Phase 10 re-scoring (after ADRs 007-010 + the 4 skills + wiring):** 12/12 (4/5 each) — **target
  reached** through specification and static implementation (ADR + SKILL.md + templates + routing with no
  orphans). Level 5 for each axis remains a post-implementation objective: it requires a real execution
  of the framework (microtasks actually completed, ≥2 cycles for the `mdpe-retro` Trend section, real
  status-light signals for `mdpe-status-report`) — verification that only task 10.10/e2e validation can
  close, not the writing of the artifacts.
- **Level 5** for each axis is a maturity objective for post-v1/post-Phase 10, reached when wiring and
  e2e validation confirm integration + memory + absence of regression.

**Axis 1 (brownfield) receives an extension in Phase 10**, without changing its original target (4, already reached in
v1): Gap R.2 (legacy schema/database with no readable application code) is a variant of the same
brownfield coverage gap, closed by `mdpe-data-discovery` as a sibling skill to `mdpe-code-discovery` —
same anti-fabrication stance, same level of rigor, different scope (schema instead of application
code). It does not open an axis 12: it is the same axis, plus one more entry point.

**Re-scored extension: level 4 maintained, new entry point confirmed.**
`docs/adr/adr-008-data-discovery.md` + `skills/mdpe-data-discovery/SKILL.md` +
`assets/templates/data-inventory-template.md` close Gap R.2 with the same discipline as
`mdpe-code-discovery` (`dm-NNN`, blocking `tabelas` field, cardinality only from real constraints —
D6). Routed in the router/flow/mapping/README (task 10.9), including composition with
`mdpe-code-discovery` when both exist.

> **Use as Definition of Done.** When closing each phase, re-score the corresponding axis. If the score falls
> below the target, the phase is not complete (Phase 9.3 re-scores every axis and compares against this baseline).
> Correction after 2 repeated failures: diagnose the axis's root cause instead of raising the score by opinion.

> Content written from `baseline-gap-map.md` and direct reading of the repository files.
> Baseline scores are traced to evidenced gaps; targets follow the phase map in `tasks-v1.md`.
