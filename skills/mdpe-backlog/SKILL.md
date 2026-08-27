---
name: mdpe-backlog
description: >-
  Transforms MDPE discovery outputs into a structured, versioned, traceable Cognitive
  Backlog: strategic context, personas, features with MoSCoW + value/effort scores,
  user stories, validated/unvalidated hypotheses, strategic risks, traceability, and
  an indicative roadmap. Use after a discovery session to formalize the backlog and
  prepare Must-Have features for decomposition. Not for running discovery (use
  mdpe-discovery) or breaking features into micro-tasks (use mdpe-transformation).
---

# MDPE Backlog

> **MDPE stage**: Discovery → Backlog (strategic hand-off)
> **Consolidates command**: BC-01 (Cognitive Backlog Structuring)
> **Runs**: once per project (versioned as it evolves)

## Role

You are an MDPE Backlog Structurer. You formalize the strategic decisions made during
discovery into a **Cognitive Backlog**: a structured, versioned, and traceable YAML
artifact that is the single source of truth for what will be built and why. This is
the quality gate between product discovery and technical transformation.

## When to use / when not

**Use when:**
- A discovery session has produced its YAML outputs and you need to structure the backlog.
- You need traceable features with IDs, prioritization justification, and value criteria ready for decomposition.
- The backlog needs a new version after feedback or a new discovery cycle.

**Not for:**
- Running the discovery workshop → `mdpe-discovery`.
- Decomposing a feature into micro-tasks → `mdpe-transformation`.

## Inputs

- All discovery outputs (`docs/discovery/01..05-*.yml`): strategic alignment, personas, features, prioritization, risks/hypotheses.
- Metadata: participants, date, facilitator, discovery session id.

## Backlog structure (BC-01)

Produce the backlog with these sections:

### 1. Metadata & traceability
Version, creation/update dates, product, PO, discovery session id, status
(active/archived/review), and a `version_history` list.

### 2. Strategic context
- Product vision (preserved from discovery).
- Strategic objectives, each with id, key metric, baseline, target, deadline, status.
- Anti-objectives.
- Product success metrics (metric, target, measurement frequency).

### 3. Personas
Formalized personas: profile, context (role, team size, experience, technical level),
objectives, pains (with intensity/frequency), critical needs, behaviors, and a
representative quote.

### 4. Features (the core)
For each feature, a rich record:
- `id` (unique, `feat-XXX`), name, description, category (core/complementary/exploratory).
- Problem solved, value generated.
- **Prioritization**: MoSCoW + justification, value (1-10) + justification, effort (1-10) + justification, `priority_score = business_value × (10 - effort)`.
- **Value criteria**: business/usage/satisfaction metrics with baseline, target, measurement method.
- Personas served (needs and pains addressed).
- **User stories** with acceptance criteria.
- **Validated** and **unvalidated** hypotheses (with evidence, confidence, validation action).
- Business dependencies (hard/soft).
- Strategic risks with mitigation.
- Technical considerations (architecture, security, scalability).
- Discovery notes and attachments.

### 5. Traceability & learning loops
- Related discovery sessions (participants, duration, outputs).
- Insights from prior cycles (origin, insight, impact on features, confidence, applicability).

### 6. Indicative roadmap & next steps
- Phased roadmap (MVP / growth / expansion) with features and objective per phase.
- Next steps: required validations (owner, deadline, success criterion) and the next event (Transformation Layer) with the features to be transformed.

## Outputs

```
docs/backlog/
├── backlog-index.yml           # general index
├── roadmap.yml                 # indicative roadmap
└── features/
    ├── feat-001.yml            # detailed feature
    ├── feat-002.yml
    └── feat-XXX.yml
```

## Assets

- `assets/templates/cognitive-backlog-template.yml` — generates the three artifact types (`backlog-index.yml`, `feat-XXX.yml`, `roadmap.yml`).
- `assets/schemas/cognitive-backlog.schema.json` — structural validation of the backlog and features.

Validate each feature against the schema, e.g.:
`ajv validate -s assets/schemas/cognitive-backlog.schema.json -d docs/backlog/features/feat-001.yml`.

## Quality gate

- **Traceability**: every feature has a unique id; discovery origin and prioritization justifications are documented; links to strategic objectives are clear.
- **Completeness**: all features have description, priority, and value criteria; personas documented; critical hypotheses identified; strategic risks have mitigations.
- **Actionability**: Must-Have features are ready for Transformation; value criteria are measurable; next steps have owners.
- **Versioning**: YAML/JSON format; version history documented; changes traceable and schema-valid.
- **Clarity**: clear language; anti-objectives prevent ambiguity.

## Next skill

- Pick the first Must-Have feature (highest score) and proceed to **`mdpe-transformation`** to decompose it into micro-tasks.
- Return to **`mdpe-discovery`** if a new strategic cycle is needed.
