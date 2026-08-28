# Command → Skill Mapping (Traceability)

> **Source of truth** for the consolidation of the 15 MDPE Framework commands into
> 7 Kiro skills (6 functional + 1 router). Every original command is represented in
> exactly one destination skill, with no capability lost.

## Consolidation summary

| Commands | Target skill | MDPE stage |
|----------|--------------|------------|
| DP-01, DP-02, DP-03 | `mdpe-discovery` | Discovery |
| BC-01 | `mdpe-backlog` | Discovery → Backlog |
| TL-01, TL-02, TL-03, TL-04, TG-01 | `mdpe-transformation` | Transformation |
| EX-01, CD-01 | `mdpe-execution-context` | Execution: Plan/Prepare |
| CD-02, CD-03, CD-04 | `mdpe-coding` | Execution: Produce/Proof |
| EX-02 | `mdpe-learnings` | Execution: Propagate |
| (all) | `mdpe-router` | Orchestration |

15 commands → 6 functional skills + 1 router.

An additional **`mdpe-tasks`** skill exists outside this 15→7 traceability: it does
not map 1:1 to any original command, but composes a *lite* version of DP-01 (framing
only), TL-01/02/03/04, and EX-01/CD-01 into a single consolidated Markdown output for
one backlog item/feature. See its own `SKILL.md` for scope and boundaries; use the
full skills above when the traceable, multi-artifact pipeline is required.

## Enabler skills (no original command — gap-driven)

Three further skills exist outside the 15→7 traceability above. Each was added to
close a gap identified in `docs/analysis/baseline-gap-map.md` (Section D) against the
original MDPE Framework's own baseline — not to consolidate an existing command. Each
has its own decision of record (ADR) justifying why it exists as a **separate skill**
rather than a mode inside an existing one.

| Skill | Gap closed (baseline-gap-map §D) | Why a separate skill, not a mode | Decision of record |
|-------|-----------------------------------|-----------------------------------|---------------------|
| `mdpe-code-discovery` | Lacuna 2.1/2.2 — discovery was greenfield-only; router had no route for an existing codebase | A different contract (inventory vs. vision/personas/MoSCoW), different anti-hallucination rules (every path must resolve to a real file), and a different quality gate; folding it into `mdpe-discovery` would have added a second "when to use" branch to a skill whose gate assumes a blank slate | `docs/adr/adr-001-brownfield-discovery.md` |
| `mdpe-architecture` | Lacuna 1.1/1.2 — architecture only existed as an unwritten `mdpe-coding` review dimension, or as free text typed into "technical context" | A decision (with drivers, alternatives, consequences, verification) is a distinct artifact from a pass/fail review checklist; conflating them would let `mdpe-coding` decide and grade its own decision | `docs/adr/adr-002-architecture-skill.md` |
| `mdpe-graph` | Lacuna 5.1/5.2 — dependency data was generated per feature by `mdpe-transformation` but never unified, rendered, or made queryable for impact/orphans/cycles | Rendering and querying a graph is a read-only, on-demand concern with its own drift/staleness checks; embedding it as a step inside `mdpe-transformation` would force a render on every decomposition even when nothing changed | `docs/adr/adr-005-traceability-graph.md` |

None of the three gate the core pipeline: each is an enabler with an explicit "nothing
to do here yet" exit (no driver, no code, or no transformed micro-task, respectively).
See `skills/mdpe-router/SKILL.md` for how they are routed to.

## Full traceability table

| # | Command file | Command | Detailed prompt | Target skill | Justification |
|---|--------------|---------|-----------------|--------------|---------------|
| 01 | `01-dp-01-discovery-session.txt` | DP-01 Discovery Session | `dp-01-facilitacao-sessao.md` | `mdpe-discovery` | Discovery core (5 stages) |
| 02 | `02-dp-02-priorizacao-refinamento.txt` | DP-02 Refined Prioritization | `dp-02-priorizacao-features.md` | `mdpe-discovery` | Already stage 4 of DP-01; becomes an internal depth mode |
| 03 | `03-dp-03-validacao-riscos.txt` | DP-03 Risk Validation | `dp-03-validacao-hipoteses-riscos.md` | `mdpe-discovery` | Already stage 5 of DP-01; becomes an internal depth mode |
| 04 | `04-bc-01-backlog-cognitivo.txt` | BC-01 Cognitive Backlog | `bc-01-estruturacao-backlog.md` | `mdpe-backlog` | Distinct artifact + own schema; PM→dev handoff gate |
| 05 | `05-tl-01-decomposicao.txt` | TL-01 Decomposition | `tl-01-decomposicao-features.md` | `mdpe-transformation` | Transformation core (IOQD, AERT) |
| 06 | `06-tl-02-dependencias.txt` | TL-02 Dependencies | `tl-02-analise-dependencias.md` | `mdpe-transformation` | Sequential, same artifacts (graph, waves) |
| 07 | `07-tl-03-validacao.txt` | TL-03 AERT Validation | `tl-03-validacao-atomicidade.md` | `mdpe-transformation` | QA gate coupled to TL-01 (>85%) |
| 08 | `08-tl-04-priorizacao-tecnica.txt` | TL-04 Technical Prioritization | `tl-04-priorizacao-tecnica.md` | `mdpe-transformation` | Sequential, small; quick wins/spikes |
| 15 | `15-tg-01-geracao-tasks.txt` | TG-01 Task Generation | `tg-01-geracao-tasks.md` | `mdpe-transformation` | Output step of transformation (tasks.md) |
| 09 | `09-ex-01-contexto.txt` | EX-01 Context Generation | `ex-01-geracao-contexto.md` | `mdpe-execution-context` | Context engineering (6 dimensions) |
| 11 | `11-cd-01-preparacao-ambiente.txt` | CD-01 Environment Setup | `cd-01-preparacao-ambiente.md` | `mdpe-execution-context` | "Ready to Code" closes preparation |
| 12 | `12-cd-02-implementacao.txt` | CD-02 Implementation | `cd-02-implementacao.md` | `mdpe-coding` | Produce (SOLID/TDD, 5 phases) |
| 13 | `13-cd-03-validacao-testes.txt` | CD-03 Validation & Tests | `cd-03-validacao-testes.md` | `mdpe-coding` | Proof; overlaps CD-04 (6 dimensions) |
| 14 | `14-cd-04-code-review.txt` | CD-04 Code Review | `cd-04-code-review.md` | `mdpe-coding` | Proof; consolidates quality gates (7 dimensions) |
| 10 | `10-ex-02-aprendizados.txt` | EX-02 Learnings Extraction | `ex-02-extracao-aprendizados.md` | `mdpe-learnings` | Propagate (learning loops) |

## Coverage checklist (per destination skill)

Each destination skill must preserve 100% of its source commands' substance. The
checklist below is the acceptance criterion referenced by the build tasks.

### mdpe-discovery (DP-01 + DP-02 + DP-03)
- [ ] 5 discovery stages: strategic alignment, personas, feature brainstorm, prioritization, hypotheses/risks
- [ ] MoSCoW classification (Must/Should/Could/Won't) + 30% scarcity rule
- [ ] Value × Effort matrix and score `Value × (10 - Effort)`; optional RICE
- [ ] Hypotheses by type (value, usability, feasibility) with confidence levels
- [ ] Risk categories (technology, regulatory, market, operational, financial) + probability × impact matrix
- [ ] 6 YAML outputs under `docs/discovery/`
- [ ] Depth modes documented: refined prioritization (DP-02), risk validation (DP-03)

### mdpe-backlog (BC-01)
- [ ] Metadata + version history
- [ ] Strategic context (vision, objectives, anti-objectives, success metrics)
- [ ] Personas, features with MoSCoW + value/effort + score, user stories, validated/unvalidated hypotheses, strategic risks
- [ ] Traceability (discovery sessions, prior-cycle insights) + indicative roadmap
- [ ] Outputs: `backlog-index.yml`, `features/feat-XXX.yml`, `roadmap.yml`

### mdpe-transformation (TL-01 + TL-02 + TL-03 + TL-04 + TG-01)
- [ ] Decompose feature into 15-25 atomic micro-tasks (IOQD contract; categories backend/frontend/database/infra/docs/tests; estimate < 8h)
- [ ] AERT self-check in decomposition (Atomicity, Executability, Traceability, Testability)
- [ ] Dependency graph (hard/soft/external), waves (from Wave 1), critical path, parallelization
- [ ] Quality validation against the 7 criteria; score 0-100; classes Approved (≥85) / Needs Adjustment (70-84) / Rejected (<70); > 85% approval target
- [ ] Technical prioritization score 0-40 (feasibility, risk impact, 11-complexity, unblock value); classes Critical/High/Medium/Low; quick wins, spikes
- [ ] Project-level `docs/tasks.md` grouped by logical layer, ordered by wave/priority, links to micro-task and context files

### mdpe-execution-context (EX-01 + CD-01)
- [ ] 6 context dimensions: strategic, technical, input, output, validation, reference
- [ ] Environment preparation: context review, dependency validation, environment setup, file structure, references
- [ ] "Ready to Code" checklist + branch creation convention
- [ ] Outputs: `mt-XXX-YYY-context.yml`, `mt-XXX-YYY-setup.yml`

### mdpe-coding (CD-02 + CD-03 + CD-04)
- [ ] Implementation 5 phases: core, tests, integration, documentation, self-review
- [ ] SOLID + Clean Code principles; incremental commits
- [ ] Validation 6 dimensions: automated tests, static analysis, acceptance criteria, performance, security, integration
- [ ] Code review 7 dimensions: requirements, architecture, code quality, tests, performance, security, maintainability
- [ ] Feedback categories (Blocker/Major/Minor/Nitpick) + PR template + return-to-fix loop
- [ ] Output: `mt-XXX-YYY-validation.yml`, `mt-XXX-YYY-code-review.yml`

Added beyond the original commands (task 4.2, per `docs/adr/adr-003-loop-engineering.md`):
- [ ] Phase 0 verification plan, frozen before implementation, commands resolved through a 7-step chain
- [ ] Evidence contract: `pass` requires `command` + `exit_code: 0` + `output_summary` + `run_at` newer than the last in-scope commit
- [ ] Bounded loop: 1 verification + up to 3 repairs, root-cause diagnosis on repeat symptom, `blocked` + escalation route on overrun
- [ ] Implementation fidelity: criteria coverage, declared-output existence, scope adherence, closed trace chain

### mdpe-learnings (EX-02)
- [ ] 4 learning types: technical, process, strategic, problems
- [ ] Feedback to 3 targets: Discovery, Transformation, Next executions
- [ ] Validated metrics (expected vs achieved), recommended actions (immediate/short/long term)
- [ ] Outputs: `{microtask-id}-learnings.yml`, `learning-loops/aggregated-learnings.yml`

### mdpe-router (orchestration)
- [ ] Routing table mapping user situation → skill
- [ ] Forward flow and return flows (next task / next feature / new cycle)
- [ ] Cross-references to all 6 functional skills
