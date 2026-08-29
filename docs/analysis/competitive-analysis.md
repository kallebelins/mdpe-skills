# Competitive Analysis — MDPE vs. spec-driven / agentic frameworks

> **Source task:** `tasks-v1.md` → Phase 1 → 1.3 (Competitive benchmark).
> **Inputs:** `docs/analysis/baseline-gap-map.md` (audit 1.1) and `docs/analysis/evaluation-rubric.md` (rubric 1.2).
> **Objective:** for each framework, ≥3 strengths with **source link** and **T/F** verdict on "MDPE already has it";
> a feature-by-feature table; and a prioritized list of adoptions, each tied to the phase (2-9) that implements it.
> **Applied acceptance rule:** no claim about a framework appears without a source link.
> Where the source does not confirm it, the item is marked as **unconfirmed** and is not approved as fact.
> **Source verification date:** 08/27/2026.

## Method

1. Reading of primary sources (official README/docs of each project), not third-party summaries,
   except where explicitly indicated as a secondary snapshot.
2. For each strength: verdict **T** (MDPE already has it) or **F** (does not have it), justified with the
   corresponding gap from `baseline-gap-map.md`. When MDPE has only part of it, the verdict is **F** and the
   *Nuance* column records what exists.
3. Each recommended adoption is tied to a phase in `tasks-v1.md` and to the target artifact of that phase.

> **Licensing compliance:** all content below has been **paraphrased/summarized** from the sources,
> with no extensive verbatim reproduction. The substance and conclusions of the sources have been preserved.
> *Content was rephrased for compliance with licensing restrictions.*

---

## Section 0 — Resolution of the open item: "TLC Spec-Driven"

The backlog (execution note) asked to confirm whether "TLC Spec-Driven" is a distinct project or a
generic variation of TDD/Spec-Driven. **Confirmed as a distinct project**, with a primary source:

- It is the `tlc-spec-driven` skill, published in the [tech-leads-club/agent-skills](https://github.com/tech-leads-club/agent-skills)
  catalog (highlighted in the README as a Development skill: 4-phase planning, atomic tasks with a
  verification criterion, and persistent memory across sessions).
- Primary source of the content:
  [`packages/skills-catalog/skills/(development)/tlc-spec-driven/SKILL.md`](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md)
  — frontmatter declares `name: tlc-spec-driven`, `version: 3.3.0`, CC-BY-4.0 license, author Felipe Rodrigues.
- Snapshot of an earlier version (used only for the **brownfield** material, which is not present in v3.3.0):
  [LobeHub — tlc-spec-driven](https://lobehub.com/skills/tech-leads-club-agent-skills-tlc-spec-driven).

Consequence: the item **is no longer open**, and TLC enters the benchmark as the fifth framework analyzed.
Separately, "Loop Engineering" is also confirmed as a term with its own project
([clawplays/ospec](https://github.com/clawplays/ospec)), treated here as a distinct framework.

**Frameworks analyzed (5):** Spec-Kit · OpenSpec · Superpowers · OSpec (Loop Engineering) · TLC Spec-Driven.

---

## Section 1 — Spec-Kit (github/spec-kit)

Primary source: [README](https://github.com/github/spec-kit/blob/main/README.md) ·
[methodology](https://github.com/github/spec-kit/blob/main/spec-driven.md) ·
[docs](https://github.github.com/spec-kit/).

| # | Strength | Source | Does MDPE already have it? | Nuance / evidence in MDPE |
|---|-------------|-------|:------------:|----------------------------|
| 1.1 | **Project constitution** (`/speckit.constitution`): principles established once per project, against which subsequent phases are evaluated, keeping dependent templates in sync. | [README §3](https://github.com/github/spec-kit/blob/main/README.md) · [reference/agentic-sdd](https://github.github.com/spec-kit/reference/agentic-sdd.html) | **F** | There is no principles/conventions artifact for the project. MDPE's memory is write-only (gap-map Gap 6.1). |
| 1.2 | **Explicit pipeline with a convergence step**: constitution → specify → plan → tasks → implement → **converge**, repeating implement+converge until the "Converged" verdict. | [README §SDD Quickstart](https://github.com/github/spec-kit/blob/main/README.md) | **F** | MDPE has the D→B→T→EC→C→L chain, but the correction loop depends on the agent and does not require verified convergence (Gap 3.1). |
| 1.3 | **Clarification step** (`/speckit.clarify`, recommended before planning): resolves under-specified areas before planning. | [README §Available Slash Commands](https://github.com/github/spec-kit/blob/main/README.md) | **F** | No skill has an "ask instead of assume" step; the opposite (rigid minimums) forces filling in fields (Gaps 8.1, 8.3). |
| 1.4 | **Cross-artifact analysis** (`/speckit.analyze`): consistency and coverage across spec, plan, and tasks, run after tasks and before implement. | [README §Optional Commands](https://github.com/github/spec-kit/blob/main/README.md) | **F** | MDPE generates chained artifacts but does not verify consistency between them; real inconsistencies exist today (gap-map Section E). |
| 1.5 | **Generated quality checklists** (`/speckit.checklist`): validate completeness, clarity, and consistency of requirements — described as "unit tests for English text". | [README §Optional Commands](https://github.com/github/spec-kit/blob/main/README.md) | **F** | There are *quality gates* per skill, but they are fixed and not derived from the item's content. |
| 1.6 | **Layered extensibility**: project overrides > presets > extensions > core, resolved at runtime; and **bundles** that provision an entire role in a single command. | [README §Extensions & Presets / Bundles](https://github.com/github/spec-kit/blob/main/README.md) | **F** | MDPE is monolithic: 8 skills with no customization layer or optional modules. |
| 1.7 | **Brownfield as a first-class phase** ("Iterative Enhancement": adding features iteratively, modernizing legacy systems), with its own spec-evolution guide. | [README §Development Phases](https://github.com/github/spec-kit/blob/main/README.md) | **F** | Discovery is greenfield-only (Gap 2.1) and the router has no brownfield route (Gap 2.2). |
| 1.8 | **Dedicated flows outside the main path**: a bug extension (assess → fix → test) and an idea-evaluation flow (intake → research → define → shape → decide, with a go / needs-clarification / kill decision). | [README §Bug Fixing / Assessing Ideas](https://github.com/github/spec-kit/blob/main/README.md) | **F** | `mdpe-tasks` is a generic shortcut; there is no bug flow or idea-triage flow with a "kill" verdict. |

---

## Section 2 — OpenSpec (Fission-AI/OpenSpec)

Primary source: [docs/overview.md](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) ·
[docs/getting-started.md](https://github.com/Fission-AI/OpenSpec/blob/main/docs/getting-started.md) ·
[docs/concepts.md](https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md).

| # | Strength | Source | Does MDPE already have it? | Nuance / evidence in MDPE |
|---|-------------|-------|:------------:|----------------------------|
| 2.1 | **Spec as present-state truth**: `openspec/specs/` describes how the system behaves *now*, organized by domain, with requirements and given/when/then scenarios. | [overview §1](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | MDPE produces *intent* artifacts (discovery/backlog/microtask) and never consolidates a "current state" of the system. Without that, brownfield has no anchor. |
| 2.2 | **Delta specs**: within a change, only the diff is written (ADDED / MODIFIED / REMOVED), not the whole document — this is what makes it feasible to specify a change in a large system without first documenting the entire thing. | [overview §3](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | Every MDPE artifact is a full document. Rewriting the entire `feat-XXX.yml` on every adjustment is exactly the volume/hallucination vector from Phase 8 (Gaps 8.1-8.3). |
| 2.3 | **Explore before proposing** (`/opsx:explore`): a no-commitment thinking partner that **reads the code**, weighs options, and turns a vague idea into a concrete plan, before any artifact exists. | [getting-started](https://github.com/Fission-AI/OpenSpec/blob/main/docs/getting-started.md) · [overview §The loop](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | This is literally the missing step in MDPE brownfield (Gaps 2.1-2.3). |
| 2.4 | **Archiving closes the cycle**: upon completion, deltas are merged into the main specs and the change folder is moved to a dated archive — the specs then describe the new reality. | [overview §5](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | MDPE has no consolidation/archiving step; this is the "memory that grows without curation" risk foreseen in Phase 7. |
| 2.5 | **"Enablers, not gates"**: the proposal → specs → design → tasks order indicates what becomes *possible*, not what is *mandatory*; discovering during implementation that the design was wrong allows editing the design and continuing. | [overview §Enablers, not gates](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | MDPE uses rigid *quality gates* per phase; the opposite philosophy. Relevant for Phase 8 without losing the evidence required by Phase 4. |
| 2.6 | **Acknowledged tradeoff**: for a truly trivial adjustment, the ceremony may not be worth it — and this is stated, not hidden. | [overview §Why this is worth the small overhead](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | MDPE has the `mdpe-tasks` shortcut, but it is not framed as "when not to use the full process", and it still starts from free text rather than from the code (Gap 2.3). |

---

## Section 3 — Superpowers (obra/superpowers)

Primary source: [README](https://github.com/obra/superpowers/blob/main/README.md) ·
[skills/writing-skills/SKILL.md](https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md) ·
[skills/test-driven-development/SKILL.md](https://github.com/obra/superpowers/blob/main/skills/test-driven-development/SKILL.md).

| # | Strength | Source | Does MDPE already have it? | Nuance / evidence in MDPE |
|---|-------------|-------|:------------:|----------------------------|
| 3.1 | **Enforced RED-GREEN-REFACTOR TDD**: write a failing test, watch it fail, write the minimum, watch it pass, commit — and delete code written before the test. | [README §The Basic Workflow, item 5](https://github.com/obra/superpowers/blob/main/README.md) | **F** | In `mdpe-coding`, validation is an *after-the-fact* review; the report can be approved with no command ever executed (Gap 3.1). |
| 3.2 | **Skills tested with subagents under pressure scenarios**: creating a skill *is* TDD applied to process documentation — the scenario is run without the skill to observe the failure (RED), the skill is written (GREEN), and it is refactored to close rationalization loopholes. | [writing-skills/SKILL.md](https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md) · [docs](https://obra-superpowers.mintlify.app/development/creating-skills) | **F** | MDPE has no method to verify whether a skill **changes the agent's behavior**. This is the missing piece for rubric 1.2 to stop being self-assessment. |
| 3.3 | **Extreme plan granularity**: 2-5 minute tasks, each with exact file paths, complete code, and verification steps, written for a junior developer with no project context. | [README §The Basic Workflow, item 3](https://github.com/obra/superpowers/blob/main/README.md) | **F** | MDPE's microtasks have IOQD and an estimate, but the count is enforced by a fixed range (15-25) rather than derived from the actual work (Gap 8.1). |
| 3.4 | **Two-stage review with subagents**: a fresh subagent per task, a spec-compliance review followed by a code-quality review; critical issues block progress. | [README §The Basic Workflow, items 4 and 6](https://github.com/obra/superpowers/blob/main/README.md) | **F** | `mdpe-coding` promises `{id}-code-review.yml` but **has no template** for it (gap-map Section C) nor a severity level that blocks progress. |
| 3.5 | **"Evidence over claims"** as a stated principle, with its own skill for verification before declaring completion. | [README §Philosophy / §What's Inside](https://github.com/obra/superpowers/blob/main/README.md) | **F** | The opposite of the current state: `validation-report-template.yml` allows `overall_status: approved` without `commands_executed` (Gap 3.1). |
| 3.6 | **Clean baseline before starting**: an isolated workspace in a new worktree/branch, project setup run, and a verified-clean test baseline. | [README §The Basic Workflow, item 2](https://github.com/obra/superpowers/blob/main/README.md) | **F** | `mdpe-execution-context` generates `{id}-setup.yml`, but does not require a green test baseline before coding. |
| 3.7 | **Skills trigger automatically**: the agent checks relevant skills before any task — mandatory flows, not suggestions. | [README §How it works / §The Basic Workflow](https://github.com/obra/superpowers/blob/main/README.md) | **F** | MDPE depends on `mdpe-router` being invoked; there is no contract for automatic triggering or upfront reading (Gap 6.1). |
| 3.8 | **Separate evaluation harness** for skill-behavior tests. | [README §Contributing](https://github.com/obra/superpowers/blob/main/README.md) | **F** | There is no harness or executable test scenario in the MDPE repo. |

---

## Section 4 — OSpec / Loop Engineering (clawplays/ospec)

Primary source: [README](https://github.com/clawplays/ospec) (includes `docs/loop-engineering.md` as an internal reference).

| # | Strength | Source | Does MDPE already have it? | Nuance / evidence in MDPE |
|---|-------------|-------|:------------:|----------------------------|
| 4.1 | **Loop Engineering as a verifiable plan → act → verify loop**, with proposal, design, plan, tasks, reviews, and **verification evidence** saved in the repo, so that another session/assistant can pick up where the previous one left off. | [README §Why OSpec](https://github.com/clawplays/ospec) | **F** | MDPE has the artifacts, but the loop is not enforced and evidence is not a required field (Gaps 3.1, 3.2). |
| 4.2 | **Execution evidence as a durable record**: verification is recorded with the command, the status, and the exit code (`ospec execute verify --command … --status PASSED --exit-code 0`); current test evidence is a requirement for a goal to be considered complete. | [README §Agent Execution](https://github.com/clawplays/ospec) | **F** | Exactly the fields missing from `validation-report-template.yml` (Gap 3.1). Serves as a direct model for task 4.2. |
| 4.3 | **Limited repair with a hard stop**: a planning review with NEEDS_CHANGES allows **one** batched repair and at most **one** re-review; a repeated semantic failure becomes a stable block instead of looping; the fix→re-verify loop is capped. | [README §Goal / §Fast planning quality](https://github.com/clawplays/ospec) | **F** | MDPE has no iteration cap or root-cause diagnosis after N failures (Gap 3.2). |
| 4.4 | **Execution metrics persisted in an artifact**: `execution-metrics.json` records package/report bytes and task duration; the metrics distinguish full, partial, and missing coverage. | [README §Scoped review evidence and cost metrics / §Measured execution](https://github.com/clawplays/ospec) | **F** | MDPE's tracking promises automatic calculation via a **nonexistent** `tools/mdpe-status.py` (Gap 4.1, Section C). |
| 4.5 | **Task graph used to dispatch work**: the loop reads `task-graph.json` and emits a conflict-safe parallel batch, explaining what reduced parallelism (limits, graph conflicts, budget, capacity). | [README §Goal / §Task graph controller](https://github.com/clawplays/ospec) | **F** | MDPE generates `waves.yml`/`parallelizable.yml` but never uses or renders them (Gap 5.1). |
| 4.6 | **Session brief for resumption**: `session-brief.json`/`.md` shows anyone joining the project the active changes, the queue state, and **the next safe command**, before touching anything. | [README §Session brief and hooks](https://github.com/clawplays/ospec) | **F** | This is the memory "reading contract" that MDPE lacks (Gap 6.1). |
| 4.7 | **Feature ↔ code locator**: doc sections declare a marker with a slug and code paths, a catalog maintains one line per feature, and a command returns the section and the line range — the agent reads a section, not an entire document. | [README §Living feature docs with a locator](https://github.com/clawplays/ospec) | **F** | Solves three things at once in MDPE: feature→file traceability (Phase 2), the "artifact/file" node of the graph (Phase 6), and context savings (Phase 8). |
| 4.8 | **Documentation obligations with warn/strict mode**: obligations are derived from the change type and the features, and the configuration decides whether an unmet obligation warns or **blocks** archiving; before/after hashes prevent an unchanged file from satisfying the obligation. | [README §Documentation obligations / §Verified durable documentation](https://github.com/clawplays/ospec) | **F** | MDPE does not tie output to a verifiable obligation; this is the mechanism that would prevent a "phantom reference" (Section C). |
| 4.9 | **Drift audit**: lists the sections whose code paths have changed since the last recorded change. | [README §Documentation obligations](https://github.com/clawplays/ospec) | **F** | Impact/drift analysis is precisely task 6.3, which does not exist today. |
| 4.10 | **Agent behavior contracts**: "Announce-Before-Act" and "Brainstorm-First" (open decisions asked one at a time before locking in the design), with hooks that **block** subagent dispatch while a decision is pending. | [README §Goal experience contracts](https://github.com/clawplays/ospec) | **F** | MDPE has no "ask before deciding" contract, nor enforcement outside of the skill's text. |

---

## Section 5 — TLC Spec-Driven (tech-leads-club/agent-skills)

Primary source: [`SKILL.md` v3.3.0](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) ·
[catalog README](https://github.com/tech-leads-club/agent-skills) ·
snapshot of an earlier version: [LobeHub](https://lobehub.com/skills/tech-leads-club-agent-skills-tlc-spec-driven).

| # | Strength | Source | Does MDPE already have it? | Nuance / evidence in MDPE |
|---|-------------|-------|:------------:|----------------------------|
| 5.1 | **Auto-sizing as a core principle**: complexity determines depth, not a fixed pipeline. Small (≤3 files) / Medium / Large / Complex determine whether Design and Tasks even exist; Specify and Execute are always mandatory. There is a **safety valve**: if the inline listing reveals more than ~5 steps, it stops and creates the formal `tasks.md`. | [SKILL.md §Auto-Sizing](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | MDPE enforces 20-30 features, 15-25 microtasks, and 6 dimensions always (Gap 8.1). This is the exact antidote, and it comes with the safeguard that avoids the opposite extreme. |
| 5.2 | **Lazy artifact creation**: only write the file when the phase actually produced content; never create empty `design.md`/`tasks.md` files, because **an empty file signals that a phase happened when it didn't** — absence is the correct state for a skipped phase. | [SKILL.md §.specs Structure](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | MDPE's templates have **0 fields marked as optional** (gap-map Section B) and induce forced filling. Ready-made argument for task 8.2. |
| 5.3 | **Deterministic script-based gates, not memory-based**: spec validators, task validators, commit-message validators, and state validators; a nonzero exit means STOP and fix. The **completion gate** requires the verifier's report to exist, with a PASS verdict **citing `file:line` evidence** — a missing report, FAIL, a placeholder, or missing evidence fails the check. | [SKILL.md §Deterministic gates](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | Closes two MDPE gaps at once: approval without evidence (3.1) and promised-but-nonexistent tooling (4.1). Here the script **exists and ships with the skill**. |
| 5.4 | **Independent "evidence-or-zero" verifier**: after the last task, a fresh verifier **always runs, unprompted**, with author ≠ verifier, re-deriving coverage rather than inheriting the implementer's mental model; includes a **discrimination sensor** that injects behavioral faults into an isolated copy and confirms the tests kill them — surviving mutants become fix tasks, and the fix→re-verify loop is capped at 3 iterations before escalating. | [SKILL.md §Sub-Agent Delegation](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | MDPE validates with the same agent that implemented, and with no iteration cap (Gaps 3.1, 3.2). |
| 5.5 | **Explicit project memory (`STATE.md`)**: a decision log with an id (AD-NNN) plus a handoff snapshot; on resumption, the snapshot is **reconciled against git**, and real evidence wins over a stale snapshot. | [SKILL.md §Workflow / §Commands: Memory](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | MDPE has no decision memory nor a resumption contract (Gap 6.1). The "evidence beats snapshot" detail is built-in anti-hallucination. |
| 5.6 | **Self-evolving, curated lessons layer**: canonical state in machine-owned JSON, a playbook rendered by script (not hand-edited), and **only confirmed lessons** are loaded during the Specify/Design phases — candidates never are; a clean PASS logs nothing. | [SKILL.md §Context Loading / §Sub-Agent Delegation (5)](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | MDPE's `aggregated-learnings.yml` has no template (Gap 6.2), no candidate/confirmed status, and nobody reads it before acting (Gap 6.1). |
| 5.7 | **Declared context budget**: on-demand loading, a ban on loading multiple specs at once, a target below ~40k tokens, and a reserve of 160k+ for the work, with a warning when exceeded. | [SKILL.md §Context Loading Strategy](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | MDPE has no context policy; heavy templates are loaded in full. |
| 5.8 | **Knowledge verification chain with an uncertainty step**: code → project docs → documentation MCP → web search → **flag as uncertain**; an explicit rule to never assume or fabricate, with "I don't know" preferable to making something up, because an invented API/pattern causes a cascading failure through design → tasks → implementation. | [SKILL.md §Knowledge Verification Chain](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | No MDPE `SKILL.md` contains an anti-fabrication sentence (Gap 8.3). This is the textual model for task 8.2's guideline. |
| 5.9 | **Requirements in EARS notation + requirement traceability + test-coverage matrix**; tests are derived from the spec's acceptance criteria and never mirror the implementation; the runner decides, not self-assessment. | [SKILL.md §frontmatter / §Execution contract](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | MDPE's `acceptance_criteria` is free text with no testable notation or requirement↔test matrix. |
| 5.10 | **Subagent delegation by batch budget**: counts the tasks, offers subagents above ~8, **offers and confirms — never triggers on its own**, never splits a phase across workers, batches run sequentially, and there is a model-tier rubric per role (mechanical work on a cheap tier, design and verification on a high tier). | [SKILL.md §Sub-Agent Delegation](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | MDPE calculates waves but does not use them to dispatch or to size cost. |
| 5.11 | **Disciplined output behavior**: doing the work instead of narrating the machinery (not announcing the phase), and writing artifacts in a direct voice, leading with the verdict and cutting filler. | [SKILL.md §Output Behavior](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | Directly applicable to rubric axis 7 (cognitive cost/verbosity). |
| 5.12 | **Blast-radius rule**: approving spec/tasks authorizes implementation and **local** commits; push, deploy, and production database changes require explicit authorization for that specific action. | [SKILL.md §Execution contract (5)](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | `mdpe-coding` mentions branches but does not bound destructive actions. |
| 5.13 | **Composition with sibling skills**: checks whether `mermaid-studio` is installed before generating a diagram and delegates to it; likewise `codenavi` for exploring existing code, with a built-in fallback and a recommendation shown at most once per session. | [SKILL.md §Skill Integrations](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | Useful composition/fallback model for Phase 6.2 (Mermaid without mandatory tooling) and for Phase 9's wiring. |
| 5.14 | **Architecture as a family of dedicated skills**, not as a review dimension: the same catalog includes `coupling-analysis`, `modular-decomposition`, `tactical-ddd`, `legacy-migration-planner`, among others, in the architecture category. | [skills catalog](https://github.com/tech-leads-club/agent-skills/tree/main/packages/skills-catalog/skills/%28architecture%29) | **F** | Confirms the direction of Phase 3: in MDPE, architecture exists only as review dimension 2 (Gap 1.1). |
| 5.15 | **Brownfield mapping across 7 documents** (stack, architecture, conventions, structure, tests, integrations, and **concerns/debt**), triggered by "map the codebase", with code docs loaded only on demand. *Fidelity note:* this appears in the earlier-version snapshot; in v3.3.0, code exploration is delegated to the `codenavi` skill. | [LobeHub (earlier snapshot)](https://lobehub.com/skills/tech-leads-club-agent-skills-tlc-spec-driven) · [SKILL.md v3.3.0 §Skill Integrations](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | Ready-made list of sections for task 2.2's `brownfield-inventory-template.md`. The "concerns" doc (debt/fragile areas) is something no other framework analyzed has. |

---

## Section 6 — Feature-by-feature table

**Legend:** ● has it · ◐ partial · ○ does not have it · — not applicable to the project's scope.
The *MDPE today* column uses the evidence from `baseline-gap-map.md`; the *Phase* column indicates who closes the gap.

| Feature | Spec-Kit | OpenSpec | Superpowers | OSpec | TLC | **MDPE today** | Phase |
|---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Project principles/constitution | ● | ◐ | ○ | ◐ | ◐ | ○ | 7 |
| Clarification/discussion step before planning | ● | ● | ● | ● | ● | ○ | 8 / 2 |
| Exploring **existing code** before proposing | ◐ | ● | ○ | ◐ | ● | ○ | 2 |
| Structured brownfield inventory (stack/conventions/debt) | ○ | ◐ | ○ | ◐ | ● | ○ | 2 |
| Durable "current state" spec of the system | ◐ | ● | ○ | ● | ◐ | ○ | 7 / 2 |
| Incremental change via **delta** (ADDED/MODIFIED/REMOVED) | ○ | ● | ○ | ◐ | ○ | ○ | 2 / 8 |
| Auto-sizing of depth by scope | ◐ | ◐ | ○ | ◐ | ● | ○ | 8 |
| Lazy artifact creation (no empty files) | ○ | ◐ | ○ | ◐ | ● | ○ | 8 |
| Explicit anti-fabrication guideline | ○ | ○ | ◐ | ◐ | ● | ○ | 8 |
| Context budget/policy | ○ | ○ | ○ | ● | ● | ○ | 8 |
| Architecture decisions as their own artifact | ● | ● | ◐ | ● | ● (catalog) | ○ | 3 |
| Atomic tasks with a verification criterion | ● | ● | ● | ● | ● | ◐ | 4 |
| Mandatory red-green TDD | ○ | ○ | ● | ◐ | ● | ○ | 4 |
| **Persisted execution evidence** (command + result) | ◐ | ○ | ● | ● | ● | ○ | 4 |
| Independent verifier (author ≠ verifier) | ○ | ○ | ● | ● | ● | ○ | 4 |
| Iteration limit / capped repair | ● | ○ | ◐ | ● | ● | ○ | 4 |
| Deterministic gates executed by script | ◐ | ● | ◐ | ● | ● | ○ | 4 / 5 |
| Cross-artifact consistency analysis | ● | ◐ | ○ | ● | ◐ | ○ | 6 / 9 |
| Execution metrics persisted in an artifact | ○ | ○ | ○ | ● | ◐ | ◐ (phantom) | 5 |
| Task graph used to **dispatch** work | ○ | ○ | ● | ● | ● | ○ | 6 |
| Graph/diagram visualization generated from data | ○ | ○ | ○ | ◐ | ◐ (delegates) | ○ | 6 |
| Impact analysis / drift | ○ | ◐ | ○ | ● | ◐ | ○ | 6.3 |
| Decision log retrievable across sessions | ● | ● | ○ | ● | ● | ○ | 7 |
| Session handoff / reconciled resumption | ○ | ◐ | ○ | ● | ● | ○ | 7 |
| Curated lessons (candidate vs. confirmed) | ○ | ○ | ○ | ◐ | ● | ◐ | 7 |
| Archiving/consolidation on completion | ○ | ● | ◐ | ● | ◐ | ○ | 7 |
| Requirement ↔ test ↔ file traceability | ◐ | ● | ◐ | ● | ● | ◐ | 9 / 6 |
| Budgeted subagent delegation | ○ | ○ | ● | ● | ● | ○ | 6 |
| Extensibility/presets/optional modules | ● | ◐ | ◐ | ◐ | ● (catalog) | ○ | 8 / 9 |
| Behavioral testing of the skill itself | ○ | ○ | ● | ○ | ● (own eval) | ○ | 1 / 9.3 |
| Blast-radius rule (destructive actions) | ○ | ○ | ◐ | ◐ | ● | ○ | 4 |
| Dedicated bug flow / idea triage | ● | ◐ | ○ | ● | ● (quick mode) | ◐ | 9 |
| Cognitive backlog with personas/RICE/MoSCoW | ○ | ○ | ○ | ○ | ○ | ● | — |
| Formalized execution-context dimensions | ○ | ○ | ○ | ◐ | ◐ | ● | — |
| Waves/critical path computed per feature | ○ | ○ | ○ | ● | ◐ | ● (data only) | 6 |

### Where MDPE is ahead

Three features where none of the five frameworks analyzed reach MDPE's level — and which v1 must
**preserve** while trimming down (explicit risk of Phase 8):

1. **Structured cognitive backlog** with personas, value criteria, hypotheses, and prioritization
   (`cognitive-backlog.schema.json`). All five frameworks enter the cycle with the feature already
   decided; none models product discovery. Spec-Kit comes closest, with its idea-evaluation extension
   ([README §Assessing Ideas](https://github.com/github/spec-kit/blob/main/README.md)).
2. **Execution context as a sized artifact** (`execution-context-template.yml`): the others load context
   on demand but do not formalize it as an auditable deliverable.
3. **Wave/critical-path/parallelizable data per feature** already computed (`dependencies/*.yml`).
   OSpec and TLC have the dispatching; MDPE has the computation — the two just need to be connected (Phase 6).

---

## Section 7 — Prioritized adoptions

14 recommendations, each with an origin, the `tasks-v1.md` phase that implements it, and a target artifact.
Priority: **P0** = unlocks the rubric target for an axis · **P1** = high gain on the same axis ·
**P2** = desirable improvement, may be deferred to post-v1.

| # | Prio | Adoption | Origin | **Phase** | Target artifact |
|---|:----:|--------|--------|:--------:|------------------|
| A1 | **P0** | **Mandatory execution evidence**: each validation dimension records the command, the result, and the exit code; without evidence there is no "approved" verdict. | OSpec 4.2 · TLC 5.3 · Superpowers 3.5 | **4.1 / 4.2** | `docs/adr/adr-003-loop-engineering.md`; `skills/mdpe-coding/assets/templates/validation-report-template.yml` |
| A2 | **P0** | **Capped loop**: iteration counter until green, an explicit limit, and after N failures a root-cause diagnosis + stop instead of an incremental patch. | OSpec 4.3 · TLC 5.4 | **4.1 / 4.2** | `adr-003-loop-engineering.md`; `skills/mdpe-coding/SKILL.md` |
| A3 | **P0** | **Auto-sizing**: replace "20-30 features" and "15-25 microtasks" with ranges derived from scope (S/M/L/Complex), **with a safety valve** requiring the formal artifact when the inline listing exceeds the limit. | TLC 5.1 | **8.1 / 8.2** | `docs/analysis/field-obligation-audit.md`; `skills/mdpe-backlog-discovery/SKILL.md`; `skills/mdpe-transformation/SKILL.md` |
| A4 | **P0** | **Anti-fabrication guideline + knowledge verification chain** in every skill: code → docs → external source → flag uncertainty; "I don't know" is a valid answer, making things up is not. | TLC 5.8 | **8.2** | `skills/*/SKILL.md` |
| A5 | **P0** | **Lazy artifact creation**: never generate an empty file/field; absence is the correct state for a skipped phase, and an empty file is treated as a false signal. | TLC 5.2 | **8.1 / 8.2** | `docs/analysis/field-obligation-audit.md`; `skills/*/assets/templates/*` |
| A6 | **P0** | **Readable project memory with a resumption contract**: a decision log with an id + handoff snapshot, reconciled against the repo's actual state (evidence wins over a stale snapshot). | TLC 5.5 · OSpec 4.6 | **7.1 / 7.2** | `docs/adr/adr-006-memory-model.md`; `skills/mdpe-learnings/assets/templates/project-memory-template.yml`; `skills/mdpe-router/SKILL.md` |
| A7 | **P0** | **Exploring the code before proposing + brownfield inventory** with fixed sections: stack, architecture, conventions, structure, tests, integrations, and **concerns/debt**. | OpenSpec 2.3 · TLC 5.15 | **2.1 / 2.2** | `docs/adr/adr-001-brownfield-discovery.md`; `brownfield-inventory-template.md` |
| A8 | **P1** | **Independent verifier (author ≠ verifier)** running when the microtask is closed, re-deriving coverage instead of inheriting the implementer's reasoning. | TLC 5.4 · Superpowers 3.4 | **4.2** | `skills/mdpe-coding/SKILL.md`; `{id}-code-review.yml` template (currently nonexistent — gap-map Section C) |
| A9 | **P1** | **Metric derived from an artifact, never from nonexistent tooling**: each metric points to a source field; anything that requires a script is marked optional or removed. | OSpec 4.4 · TLC 5.3 | **5.1 / 5.2** | `docs/adr/adr-004-execution-metrics.md`; `skills/mdpe-learnings/assets/templates/mdpe-tracking.yml` |
| A10 | **P1** | **Feature ↔ file locator** with declared paths and a one-line-per-feature catalog, serving as the graph's "artifact/file" node and as a traceability anchor. | OSpec 4.7 | **6.1 / 6.2** (consumes 2.2) | `docs/adr/adr-005-traceability-graph.md`; `traceability-graph-template.md` |
| A11 | **P1** | **A graph that dispatches, not just draws**: use `waves.yml`/`parallelizable.yml` to say what runs now and why parallelism was reduced. | OSpec 4.5 · TLC 5.10 | **6.3 / 6.4** | `skills/mdpe-graph/SKILL.md`; `docs/analysis/impact-analysis-example.md` |
| A12 | **P1** | **Lessons with a candidate → confirmed state**, loading only confirmed ones during decision phases, and logging nothing when the outcome is clean (built-in curation). | TLC 5.6 | **7.2** | `skills/mdpe-learnings/SKILL.md`; `aggregated-learnings.yml` template (currently nonexistent) |
| A13 | **P2** | **Cross-artifact consistency analysis** before coding (backlog ↔ architecture ↔ microtask ↔ tasks.md), including orphan detection and broken-path detection. | Spec-Kit 1.4 · OSpec 4.9 | **6.3 / 9.1** | `skills/mdpe-graph/SKILL.md`; `skills/*/SKILL.md` |
| A14 | **P2** | **Behavioral testing of the skill itself** with pressure scenarios in a subagent (baseline without the skill → with the skill → close loopholes), so that rescoring the rubric stops being self-assessment. | Superpowers 3.2 | **9.3** | `docs/analysis/v1-validation-report.md` |

### Deliberately rejected adoptions (with rationale)

Recording the "no" avoids adopting something just because it's trendy — the same discipline required of
Phase 3 (do not generate a trendy pattern without justification):

- **ADDED/MODIFIED/REMOVED deltas as the backlog's change format** (OpenSpec 2.2): conceptually the best
  remedy against volume, but it requires a durable "current state" spec that MDPE does not have before
  Phase 7. Recorded as a post-v1 candidate, dependent on A6 + A7.
- **Proprietary CLI/tooling** (Spec-Kit, OpenSpec, OSpec, and TLC's Python scripts): MDPE already suffers
  from referencing nonexistent tooling (Gap 4.1). Adopting a CLI now would repeat the mistake. v1 keeps
  the principle ("verifiable gate") without the binary dependency — a decision to be formalized in task 5.1.
- **Mandatory worktrees** (Superpowers 3.6): real value, but ties the framework to git + a specific
  workspace layout. Enters as an optional recommendation in Phase 4, not as a gate.
- **Model-tier rubric per role** (TLC 5.10): depends on the harness allowing per-subagent model selection;
  portable only as a suggestion. Out of scope for v1.

---

## Section 8 — Expected impact on the rubric

Each axis of `evaluation-rubric.md` and which adoptions support the leap to target:

| Axis (rubric 1.2) | Baseline | Target | Supporting adoptions | Phase |
|---|:---:|:---:|---|:---:|
| 1 Brownfield coverage | 1 | 4 | A7 (+ A10 for traceability to real files) | 2 |
| 2 Architecture definition | 1 | 4 | TLC 5.14 / Spec-Kit 1.1 as a reference for "architecture is an artifact, not a review dimension" | 3 |
| 3 Fidelity / loop | 1 | 4 | A1, A2, A8 | 4 |
| 4 Measurability | 1 | 4 | A9 (and rejecting a proprietary CLI, which avoids a new phantom reference) | 5 |
| 5 Visualization / graphs | 2 | 4 | A10, A11, A13 | 6 |
| 6 Memory | 1 | 4 | A6, A12 | 7 |
| 7 Cognitive cost / verbosity | 1 | 4 | A3, A5 (+ TLC 5.7 context budget, TLC 5.11 artifact voice) | 8 |
| 8 Hallucination risk | 1 | 4 | A4, A5, A1 (evidence blocks a fabricated verdict) | 8 |

No axis is left without an associated adoption, and no P0/P1 adoption is left without a phase — a
prerequisite for Phase 9.3 to be able to rescore against the 9/40 baseline.

---

## Summary

- **5 frameworks** analyzed, all with primary sources: Spec-Kit (8 strengths), OpenSpec (6),
  Superpowers (8), OSpec/Loop Engineering (10), TLC Spec-Driven (15) — **47 strengths**, each with a
  link and a T/F verdict on "MDPE already has it".
- **Aggregate verdict:** of the 47 points, **0 receive a T**. MDPE has partial overlap in several of
  them (recorded in the *Nuance* column), but none at the verifiable level described by the source —
  consistent with the rubric's aggregate baseline of 9/40.
- **Open item resolved:** "TLC Spec-Driven" **is** a distinct project (the `tlc-spec-driven` v3.3.0
  skill in the tech-leads-club/agent-skills catalog) and turns out to be the densest source in the
  benchmark — on its own it feeds 6 of the 14 adoptions, and the 4 highest-priority ones in
  anti-hallucination and memory.
- **14 prioritized adoptions** (7 P0, 5 P1, 2 P2), all mapped to a phase between 2 and 9 and to a
  named target artifact; **4 rejected adoptions** with recorded rationale.
- **Most actionable finding:** three independent frameworks (OSpec, TLC, Superpowers) converge on the
  same rule — *completion requires execution evidence, with author ≠ verifier and a capped loop*. This
  is exactly MDPE's Gap 3.1/3.2, which is why A1 and A2 are v1's highest-priority adoptions.

### Sources

- github/spec-kit — https://github.com/github/spec-kit · README: https://github.com/github/spec-kit/blob/main/README.md · methodology: https://github.com/github/spec-kit/blob/main/spec-driven.md · docs: https://github.github.com/spec-kit/
- Fission-AI/OpenSpec — https://github.com/Fission-AI/OpenSpec · overview: https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md · getting-started: https://github.com/Fission-AI/OpenSpec/blob/main/docs/getting-started.md · concepts: https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md
- obra/superpowers — https://github.com/obra/superpowers · writing-skills: https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md · test-driven-development: https://github.com/obra/superpowers/blob/main/skills/test-driven-development/SKILL.md · docs: https://obra-superpowers.mintlify.app/development/creating-skills
- clawplays/ospec — https://github.com/clawplays/ospec
- tech-leads-club/agent-skills — https://github.com/tech-leads-club/agent-skills · `tlc-spec-driven` v3.3.0: https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md · architecture catalog: https://github.com/tech-leads-club/agent-skills/tree/main/packages/skills-catalog/skills/%28architecture%29 · earlier-version snapshot: https://lobehub.com/skills/tech-leads-club-agent-skills-tlc-spec-driven
- Mermaid (referenced by Phase 6) — https://mermaid.js.org/ · Graphviz — https://graphviz.org/

> Sources verified on 08/27/2026. Content paraphrased/summarized from the sources, with no extensive
> verbatim reproduction, for licensing compliance. *Content was rephrased for compliance with
> licensing restrictions.*
