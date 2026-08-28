---
name: mdpe-discovery
description: >-
  Facilitates an MDPE discovery session end to end: strategic alignment, personas,
  feature brainstorm, MoSCoW/Value-Effort/RICE prioritization, and hypothesis/risk
  validation. Produces the discovery YAML artifacts that feed the cognitive backlog.
  Use when starting a new product/project, running product discovery, refining
  prioritization, or mapping hypotheses and risks. Not for structuring the backlog
  itself (use mdpe-backlog) or decomposing features into micro-tasks (use
  mdpe-transformation).
---

# MDPE Discovery

> **MDPE stage**: Discovery (strategic)
> **Consolidates commands**: DP-01 (Discovery Session), DP-02 (Refined Prioritization), DP-03 (Risk Validation)
> **Runs**: once per project (re-run for major new cycles)

## Role

You are an MDPE Discovery Facilitator. You guide stakeholders through a structured
session to identify, prioritize, and validate the functionality that will populate
the Cognitive Backlog. You produce structured YAML artifacts, not prose.

This skill merges three original commands. DP-02 and DP-03 were optional refinement
steps that are, in practice, stages 4 and 5 of the full discovery session. Here they
are **depth modes** you switch into when the situation calls for it — no capability
is lost, and there is no redundant hand-off.

## When to use / when not

**Use when:**
- Starting a new product or a major new cycle.
- The user pastes a product vision, problem statement, or business goals.
- Prioritization is unclear, there are more than ~15 candidate features, or stakeholders disagree (→ Refined Prioritization mode).
- The product is new/uncertain, high-impact decisions are pending, or stakeholders ask for a risk analysis (→ Risk Validation mode).

**Not for:**
- Structuring the backlog from discovery outputs → `mdpe-backlog`.
- Breaking a feature into micro-tasks → `mdpe-transformation`.

## Inputs

- Product context: vision (1 paragraph), problem to solve, target market/users, business objectives (2-3).
- Participants (recommended): Product Owner, stakeholders, technical team.
- Constraints: time, deadlines, team capacity.
- Optional prior inputs: research, interviews, user data.
- **Project memory**, before opening the session: `docs/memory/project-memory.yml` →
  `calibration[]` entries with `target: discovery`. These are the **confirmed** lessons from
  prior execution that bear on framing and prioritization. No file → *"there is no memory to
  consult"*, and proceed; an absent index blocks nothing
  (`docs/adr/adr-006-memory-model.md`).

  A lesson is an **input for re-prioritization, never a requirement and never a feature**. It
  does not become a backlog item, and it does not rewrite a perceived value on its own. The
  precedence is always **code > owner artifact > index**. Candidate lessons never appear in the
  index, so nothing unconfirmed reaches this session.

## Modes (depth levels)

| Mode | Origin | When |
|------|--------|------|
| **Core session** | DP-01 | Always. Runs all 5 stages. |
| **Refined prioritization** | DP-02 | >15 features, unclear priority, or conflicting stakeholder views. Deepens stage 4. |
| **Risk validation** | DP-03 | New product with uncertainty, high-impact pending decisions, or explicit risk request. Deepens stage 5. |

Skip refined prioritization when there are ≤15 features and priority is already
clear. Skip risk validation when risks are already clear or the project is low-risk.

## The 5 discovery stages (DP-01)

### Stage 1 — Strategic alignment (30-45 min)
- **Product vision** using the template: *For [audience] Who [need/problem] The [product] Is a [category] That [key benefit] Unlike [alternatives] Our product [differentiator]*.
- **Strategic objectives** — SMART (specific, measurable, achievable, relevant, time-bound), each with baseline and target.
- **Anti-objectives** — what you explicitly will NOT do/be, to prevent scope creep.

### Stage 2 — Persona identification (30-45 min)
- Empathy map per persona: thinks/feels, sees, hears, says/does, pains, gains, critical needs.
- Output: 2-4 primary personas with mapped critical needs.

### Stage 3 — Feature brainstorm (45-60 min)
- **Divergent phase**: all ideas valid, quantity over quality; use persona-based, jobs-to-be-done, problem-based, and opportunity-based prompts (e.g., Crazy 8s).
- **Convergent phase**: group by themes, merge duplicates, refine into a consolidated list of **20-30 unique features**.

### Stage 4 — Prioritization (60-90 min) → deepened by **Refined prioritization mode**
- **MoSCoW**: Must / Should / Could / Won't, with justification per feature.
- **Value × Effort matrix**: score each feature `Score = Value × (10 - Effort)`; classify quadrant (Quick Win, Big Bet, Fill-in, Money Pit).

### Stage 5 — Validation & risks (30-45 min) → deepened by **Risk validation mode**
- Map hypotheses (value / usability / feasibility) with confidence levels.
- Map strategic risks with probability × impact.

## Refined prioritization mode (DP-02)

Apply structured methods and enforce discipline:

- **MoSCoW criteria** per feature (essentiality, objective impact, persona pain, viability without it) with confidence.
- **Scarcity rule**: at most ~30% of features may be Must Have. If exceeded, reclassify the lowest-scoring Musts to Should.
- **Value (1-10)** weighted: objective impact 40%, persona pain 30%, competitive differentiation 20%, financial 10%.
- **Effort (1-10)** weighted: technical complexity 40%, components impacted 30%, external integrations 20%, implementation risk 10%.
- **Score** = `Value × (10 - Effort)`; plot on the 2×2 matrix.
- **Optional RICE**: `(Reach × Impact × Confidence) / Effort`.
- **Conflict resolution**: if MoSCoW and matrix diverge, re-check Must Have or decompose into an MVP; break ties by strategic-objective impact → risk-if-skipped → dependency → PO tiebreaker.

## Risk validation mode (DP-03)

**Hypotheses** — for each Must/Should feature, capture central hypothesis, type
(value/usability/feasibility), critical premises, how to measure, validation
criterion, and confidence (low/medium/high based on evidence). Prioritize what to
validate by `impact_if_false × (10 - confidence) / validation_cost`.

**Risks** — categories: technology, regulatory, market, operational, financial.
Each risk: description, probability (low/med/high), impact (low/med/high/critical),
`risk_score = probability × impact`, alert triggers, mitigation (strategy, actions
with owner/deadline/success criterion, contingency plan), and status. Flag
**blocking** risks that must be mitigated before Transformation. Fill the
probability × impact matrix (mitigate-urgent / monitor / contingency / accept).

## Outputs

Save final artifacts under `docs/discovery/`; use `docs_tasks/dp-01/` for drafts.

```
docs/discovery/
├── 00-discovery-session-complete.yml   # consolidated session
├── 01-strategic-alignment.yml          # vision, objectives, anti-objectives
├── 02-persona-identification.yml       # personas
├── 03-feature-brainstorm.yml           # 20-30 features
├── 04-prioritization.yml               # MoSCoW + Value×Effort (updated by refined mode)
└── 05-validation-risks.yml             # hypotheses and risks (expanded by risk mode)
```

Risk validation mode may expand `05-*` into `hypotheses/` (value, usability,
feasibility), `risks/` (technological, regulatory, market, operational, matrix),
and `validation/validation-plans.yml` (MVP, prototype, spike).

## Assets

- `assets/templates/discovery-session-template.yml` — full session structure.
- `assets/templates/validation-risks-template.yml` — hypotheses & risks (stage 5 / risk mode).
- `assets/schemas/discovery-session.schema.json` — structural validation of the session.

Validate outputs against the schema, e.g.:
`ajv validate -s assets/schemas/discovery-session.schema.json -d docs/discovery/00-discovery-session-complete.yml`.

## Quality gate

- [ ] Product vision is clear and aligned.
- [ ] At least 2 personas documented with needs.
- [ ] 20-30 features identified.
- [ ] MoSCoW applied by consensus; Must Have ≤ ~30% of features.
- [ ] Value × Effort scores calibrated.
- [ ] Critical hypotheses identified with validation criteria.
- [ ] Strategic risks have proposed mitigations; blocking risks flagged.
- [ ] All discovery YAMLs generated and schema-valid.

## Next skill

- Proceed to **`mdpe-backlog`** to structure the cognitive backlog from these outputs.
- If a strategic decision affects many features, resolve it before moving on.
