# Field Obligation Audit — Required vs Optional Fields

> **Source task:** `tasks-v1.md` → Phase 8 → 8.1 (Audit required vs optional fields across
> all templates/schemas).
> **Input:** `docs/analysis/baseline-gap-map.md` (Section B, Gaps 8.1-8.3), `docs/analysis/evaluation-rubric.md`
> (Axis 7 — cognitive cost/verbosity, Axis 8 — hallucination risk).
> **Goal:** classify each relevant field as **essential** (required, the only source of
> traceability/verification), **conditional** (required only when the situation applies), or
> **optional** (fill in only if there is real content), with justification; identify concrete
> "forced fill-in" points; re-evaluate rigid minimums as size-oriented ranges.
> **Output consumed by:** Phase 8 → 8.2 (applies this classification to the templates/schemas/SKILL.md).

## Method

1. Re-read all `SKILL.md` files, templates (`assets/templates/*`), and schemas (`assets/schemas/*`)
   across the 11 skills.
2. Two generations of artifacts already coexist in the repository:
   - **Generation 1 (pre-Phase 2-7):** `mdpe-backlog-discovery`, `mdpe-backlog`, `mdpe-transformation`,
     `mdpe-execution-context`. Templates without an obligation legend, without an explicit
     anti-fabrication rule, with fixed numeric minimums in `SKILL.md` ("20-30 features", "15-25 micro-tasks"), and
     sections that are always present regardless of the item's size.
   - **Generation 2 (Phases 2-7, already born with the discipline this Phase 8 calls for):** `mdpe-architecture`,
     `mdpe-code-discovery`, `mdpe-coding` (validation-report/code-review), `mdpe-graph`,
     `mdpe-learnings`, `mdpe-tasks`. All of these already have an `[E]/[C]/[O]` legend per field, a "Hard rules"
     block stating "no TBD / unknown is a valid answer / do not invent content to fill a field", and ranges instead
     of fixed minimums ("roughly 3-25", "auto-sizing S/M/L").
3. This audit focuses on **Generation 1**, which is where gaps 8.1-8.3 from the gap-map live. Generation 2 is
   cited as the reference standard (the rubric's "level 5") and is not repeated field by field.

---

## Section A — Concrete "forced fill-in" points (≥3 required, 6 found)

| # | Where | Evidence | Effect |
|---|------|-----------|--------|
| 1 | `skills/mdpe-backlog-discovery/SKILL.md`, Stage 3 | *"refine into a consolidated list of **20-30 unique features**"* + Quality gate *"20-30 features identified"* | A small product is forced to invent features to reach 20, or a large product is truncated at 30. |
| 2 | `skills/mdpe-backlog-discovery/SKILL.md`, Stage 2 | *"Output: **2-4 primary personas** with mapped critical needs"* | Domains with 1 clear persona (or 6 genuinely distinct ones) are pushed into the range. |
| 3 | `skills/mdpe-transformation/SKILL.md`, Phase 1 | *"Break the feature into **15-25 atomic micro-tasks**"* + Quality gate *"Feature decomposed into 15-25 atomic micro-tasks"* | A small feature (e.g., 4 real tasks) is forced to fragment up to 15; a large feature is forced to consolidate down to 25, losing atomicity. |
| 4 | `skills/mdpe-transformation/assets/templates/microtasks-index-template.yml`, `validation` and `usage_instructions.quality_criteria` | `estimate_range_validated: true  # 15-25 microtasks` and *"Total of 15-25 micro-tasks per feature"* | The validation template itself assumes the rigid minimum as the "done" criterion, even when the SKILL.md relaxes it. |
| 5 | `skills/mdpe-execution-context/SKILL.md`, Phase 1 | *"Produce a self-contained context document covering **all six dimensions**"* — no mention of any dimension being dispensable | A trivial microtask (e.g., 1 configuration file) still needs 6 context blocks filled in, including `risks_and_troubleshooting` and external tutorials that may not exist. |
| 6 | `skills/mdpe-backlog/assets/templates/cognitive-backlog-template.yml`, `usage_instructions.step_2` | *"Each feature should have **5-30 functionalities**"* | A real feature with 2 or 3 functionalities is pushed to inflate the list up to 5. |

Additional phantom-reference point (linked to hallucination, not volume): `environment-setup-template.yml`
→ `usage_instructions.related_command: "11-cd-01-environment-preparation.txt"` and
`next_command: "12-cd-02-implementation.txt"` — legacy command `.txt` files that **do not exist**
in the repository (the same pattern already fixed in the `mdpe-coding` templates, which carry the note *"Those .txt
command files do not exist in this repository - do not reference them as next steps"*).

---

## Section B — Classification by template/schema (Generation 1)

Legend: **E** = essential (required; the only source of traceability/verification) · **C** =
conditional (required only in the stated situation) · **O** = optional (fill in only with real content).

### B.1 — `mdpe-backlog-discovery`

**`discovery-session-template.yml`** (8 sections, 0 previously marked)

| Field/block | Classification | Justification |
|---|---|---|
| `metadata` (id, date, facilitator, product) | **E** | Identifies the session; without it nothing is traceable. |
| `participants.product_owner` | **E** | Already required by the schema (`required`); this is the decision maker. |
| `participants.stakeholders` / `technical_team` / `optional_guests` | **O** | Schema does not require it; the session may have only the PO. |
| `agenda[]` | **E** (≥1) | This is the session's minimum roadmap; the schema requires `minItems:1`. |
| `agenda[].tools` | **O** | A supporting tool, does not affect the outcome. |
| `outputs.cognitive_backlog` | **E** | It is the link to `mdpe-backlog`. |
| `outputs.personas_identified` / `critical_hypotheses` / `identified_risks` | **C** — required only if the session actually produced personas/hypotheses/risks | A refinement session (DP-02 only) may not generate new hypotheses. |
| `next_steps.required_validations` | **O** | Not every session has an outstanding external validation. |
| `facilitator_notes` / `participant_feedback` / `attachments` | **O** | Already absent from the schema's `required`; they were presented in the template as if they were part of the standard flow. |

**`validation-risks-template.yml`** (10 model files, 0 previously marked)

| Field/block | Classification | Justification |
|---|---|---|
| `05-validation-risks.yml` (index) | **E** — only when ≥1 hypothesis/risk exists | It is the consolidated summary; with no hypothesis/risk there is nothing to consolidate. |
| `hypotheses/*.yml` (value/usability/feasibility) | **C** — each file only exists if there is ≥1 hypothesis of that type | Not every Must-Have feature generates a hypothesis of **all** three types. |
| `risks/*.yml` (technology/regulatory/market/operational) | **C** — same, per category with a real risk | An internal project with no personal data may have no regulatory risk at all. |
| `risks/risk-matrix.yml` | **C** — only when there is ≥1 risk in any category | An empty matrix should not exist. |
| `validation/validation-plans.yml` | **C** — only for low/medium confidence hypotheses | A hypothesis already validated with high confidence does not need a plan. |
| `hypothesis.evidence[]` | **O** | There may be no evidence yet (a newly raised hypothesis) — but it must not be fabricated. |

**`discovery-session.schema.json`** — already relatively lean (see gap-map Section B): `facilitator_notes`,
`participant_feedback`, `attachments`, `stakeholders`, `technical_team` are already optional in the schema. The
problem is not in the schema, it is in the **template and the SKILL.md**, which present everything as a standard flow
without marking what the schema itself already treats as optional.

### B.2 — `mdpe-backlog`

**`cognitive-backlog.schema.json`** (feature) — 13 required fields at the root.

| Field | Classification | Justification |
|---|---|---|
| `id`, `name`, `description`, `category` | **E** | Identity and purpose of the feature; without it there is no backlog item. |
| `priority` (moscow, business_value, estimated_effort, priority_score, justification) | **E** | It is the sequencing criterion; without it nothing indicates what comes first. |
| `functionalities.list` | **E**, but **with no numeric floor** | `minItems:0` is already in the schema — the "5-30" floor only exists in the template (Section A #6), not in the schema. No schema change needed; the fix is template-only. |
| `value_criteria`, `personas_served`, `acceptance_criteria` | **E** (`minItems:1`) | These are the only source of "what proves the feature works" and "for whom"; downgrading them to optional would destroy the traceability the rubric (Axis 7) requires to be preserved. |
| `hypotheses`, `risks` | **C** — the key exists, the list can be `[]` | Already this way in the schema (`minItems:0`); keep as is. |
| `dependencies.business` / `.technical` | **C** — the list can be `[]`, but the key is required | A feature with no real dependency should declare `[]`, not omit the key (this keeps the structure verifiable). |
| `discovery_notes` | **O** | Already absent from `required`; it is a context note. |
| `metadata.changelog` | **E** (`minItems:1`) | Version tracking; without at least the initial entry there is no history at all. |
| `rice` (inside `priority`) | **O** | Already absent from `required`; an alternative prioritization method. |

**Conclusion B.2:** the schema is already well calibrated (Phase 8 does not need to touch it). What needs
fixing is the **template's usage_instructions** (`step_2`, Section A #6) and the `SKILL.md` (no
anti-hallucination sentence and no mention that `functionalities` can have any real count).

### B.3 — `mdpe-transformation`

**`mdpe-microtask.schema.json`** — 14 required fields at the root + deep nesting
(`estimate`: 6; `metadata`: 7; `aert_validation`: 4×2).

| Field | Classification | Justification |
|---|---|---|
| `id`, `title`, `traceability`, `category`, `type`, `architectural_layer`, `description` | **E** | Identity and purpose; without it the microtask is neither traceable nor categorizable. |
| `input.required_artifacts` | **E**, but `minItems:0` | Key required, list can be empty (the first microtask of a feature has no prior artifact). Already correct in the schema. |
| `input.technical_knowledge`, `input.tools` | **E** (`minItems:1`) | This is what guarantees the microtask is executable by someone with no additional context (part of the IOQD contract); downgrading it to optional would break the executability guarantee the skill itself declares (AERT — Executability). |
| `input.external_resources` | **O** | Only exists if the microtask actually depends on something external. |
| `output.generated_artifacts` | **E** (`minItems:1`) | This is the "O" of IOQD — without a declared output there is no way to later validate `fidelity.declared_outputs` in `mdpe-coding`. |
| `output.system_changes`, `output.expected_metrics` | **O** | Not every microtask changes the system in a structured way (e.g., documentation), nor declares a numeric metric. |
| `quality_criteria.functional` (`minItems:1`) | **E** | This is the minimum acceptance criterion; without it there is nothing for `mdpe-coding` dimension 3 to verify. |
| `quality_criteria.non_functional` (`minItems:0`) | **C** | Only when the microtask actually has a non-functional requirement. Already correct in the schema. |
| `quality_criteria.code_quality` (`minItems:1`) | **E** | The minimum verifiable quality standard; without it the code review has no baseline. |
| `quality_criteria.documentation` | **O** | Not every microtask needs its own documentation. |
| `dependencies.upstream`/`downstream` | **E**, but lists can be `[]` | The key is required (dependency mapping is part of AERT-Traceability), the list can be empty (Wave 1). |
| `dependencies.external` | **O** | Only when there is a real external dependency. |
| `estimate.*` (6 fields) | **E** | This is what prevents a microtask from exceeding 8h (atomicity limit); without an estimate there is no way to apply AERT-Atomicity. |
| `aert_validation.*` (4 blocks) | **E** | This is Phase 1's central self-verification; without it the microtask has not passed the very contract that defines it. |
| `risks[]` | **O** | Already absent from `required`. |
| `technical_notes[]` | **O** | Already absent from `required`. |
| `traceability.origin_decisions` | **C** — only when the microtask originates from a `derived_work` of `ad-NNN` | Already documented as conditional in the schema/template itself (comment `# CONDITIONAL`). |

**Conclusion B.3:** the schema, field by field, is already mostly justifiable — the deep requirement
reflects the IOQD/AERT contract that the skill itself defines as necessary for a microtask to be
executable and verifiable without additional context. **No essential field is a candidate for downgrading.**
The real problem is outside the schema:
- the **count floor** ("15-25 micro-tasks", Section A #3-4) in `SKILL.md` and in the
  `microtasks-index-template.yml`;
- the absence of a sentence such as "do not invent a microtask just to hit the count" in `SKILL.md`.

**`dependencies-template.yml`**, **`microtasks-index-template.yml`**, **`category-index-template.yml`**,
**`transformation-template.yml`**, **`tasks-template.yml`** — none of them have an `[E]/[C]/[O]` legend. Blocks
identifiable as optional by their content:

| Template | Block | Classification |
|---|---|---|
| `dependencies-template.yml` | `external_dependencies.dependencies[].notes` | **O** |
| `dependencies-template.yml` | `critical_path.path_comparison.alternative_path_N` | **O** — only when there is a relevant alternative path |
| `microtasks-index-template.yml` | `feature_risks[]` | **C** — only when there is a risk spanning multiple microtasks |
| `category-index-template.yml` | `category_risks[]`, `required_resources.access[]` | **O** |
| `transformation-template.yml` | `architect_notes[]` | **O** |
| `tasks-template.yml` | `completion_note` (per task) | **C** — only when marked `[x]` |

### B.4 — `mdpe-execution-context`

**`execution-context-template.yml`** (8 sections, 0 previously marked) — the skill already correctly resolved
the architecture handling (`architecture` stays empty without an `ad-NNN`) and conventions (`code_conventions_source`
empty without a source) via extensive comments added in Phases 3/7. What is missing is:

| Block | Classification | Justification |
|---|---|---|
| `strategic_context.supported_strategic_objectives[]` | **O** | Only when the microtask connects to a named strategic objective; not every microtask has one. |
| `strategic_context.impacted_personas[]` | **O** | Same for personas. |
| `input_context.required_knowledge[]`, `.external_resources[]` | **O** | Only when there is real external knowledge/resource. |
| `output_context.system_changes[]` | **C** | Only when the microtask actually changes the system in a structural way. |
| `reference_context.relevant_tutorials[]`, `.external_documentation[]` | **O** | Not every microtask has an applicable external tutorial/doc — it must not be invented just to fill the section. |
| `risks_and_troubleshooting` (entire section 7) | **C** — only when there is a real known risk/issue | A trivial microtask (e.g., moving a file) has no identifiable risk or known troubleshooting; forcing this section is the template's most direct hallucination point. |
| `execution_instructions` (step by step) | **E**, but **proportional depth** | The guide is essential (it is what makes the microtask executable without ambiguity), but its size should be proportional to real complexity, not follow the example's "STEP 1/2/3" to the letter. |

**`environment-setup-template.yml`** (7 sections, 0 previously marked):

| Block | Classification | Justification |
|---|---|---|
| `context_review.identified_constraints[]`, `.patterns_to_follow[]` | **O** | Only when there is a real constraint/pattern to follow. |
| `dependency_validation.existing_code[]`, `.interfaces_contracts[]`, `.available_assets[]` | **C** — only when the microtask actually reuses/depends on existing code | The first microtask of a new feature has nothing here. |
| `environment_preparation.services[]` | **C** — only when the project uses external services (DB, cache) | A microtask that is purely domain logic may not need any service running. |
| `file_structure.files_to_modify[]` | **C** — only when there is an existing file to modify | A microtask that only creates new files has no such list. |
| `reference_analysis.external_apis[]`, `.reusable_snippets[]` | **O** | Only with a real external API or reusable snippet. |
| `ready_checklist.additional_risks[]` | **O** | Only with a real additional risk not covered elsewhere. |
| `usage_instructions.related_command` / `.next_command` (`.txt`) | **Remove** | Phantom references — point to legacy command files that do not exist in the repository (the same defect already fixed in `mdpe-coding`). |

### B.5 — Generations already compliant with Phase 8 (reference, no action here)

`mdpe-architecture`, `mdpe-code-discovery`, `mdpe-graph`, `mdpe-learnings`, `mdpe-tasks`, and the templates
of `mdpe-coding` (`validation-report-template.yml`, `code-review-template.yml`) **already** have: an
`[E]/[C]/[O]` legend per field, a "Hard rules" block with "no TBD"/"unknown is a valid answer", lazy creation
of conditional blocks ("no content → no block"), and ranges instead of fixed minimums (`mdpe-tasks`:
"roughly 3-25, do not force a feature-sized item into 15-25 if it is genuinely smaller";
`mdpe-code-discovery`: auto-sizing S/M/L "no minimum number of features"). No change is needed
here — they serve as the model for Section C.

---

## Section C — Rigid minimums → size-oriented ranges (applied in 8.2)

| Where | Current rigid minimum | Proposed range |
|---|---|---|
| `mdpe-backlog-discovery/SKILL.md`, Stage 3 + Quality gate | "20-30 unique features" | "sized to the product's real scope — commonly 15-30 for a broad product discovery, fewer for a narrow one. Never pad the list to hit a number; a genuinely small product may converge on far fewer." |
| `mdpe-backlog-discovery/SKILL.md`, Stage 2 | "2-4 primary personas" | "at least 1, more only if genuinely distinct — do not split one persona into several to hit a count." |
| `mdpe-transformation/SKILL.md`, Phase 1 + Quality gate | "15-25 atomic micro-tasks" | "sized to the feature — commonly 15-25 for a typical Must-Have feature; a narrower feature may need far fewer, a very large one may need to be split into multiple features instead of stretching the range. Never merge unrelated work to hit the floor, and never split atomic work to hit the ceiling." |
| `mdpe-transformation/assets/templates/microtasks-index-template.yml` | `estimate_range_validated: true  # 15-25 microtasks` + *"Total of 15-25 micro-tasks per feature"* | Comment adjusted to "count matches the feature's real scope, not a fixed range" |
| `mdpe-backlog/assets/templates/cognitive-backlog-template.yml`, `step_2` | "Each feature should have 5-30 functionalities" | "Group as many real functionalities as the feature actually has — there is no floor or ceiling; 2 or 40 are both valid if that is what discovery produced." |
| `mdpe-execution-context/SKILL.md`, Phase 1 | "all six dimensions" with no exception | Keep the 6 dimensions as the structure (they are the 6 questions that make the microtask executable), but each can be filled in proportionally, and internal sections clearly marked conditional/optional can remain empty/absent. |

Rules that **do not** change (they are matters of business scope, not volume, and remain justified):
- `mdpe-backlog-discovery`: "Must Have ≤ ~30% of features" — this is a prioritization scarcity rule, not a
  volume floor; it stays.
- `mdpe-transformation`: estimate "< 8h (ideal 2-4h)" per microtask — this is the atomicity limit
  (AERT), not a volume forcer; it stays.
- `mdpe-transformation`: "> 85% approved" in the quality gate — this is the decomposition's quality
  target, not an item count; it stays.

---

## Section D — Summary of actions for 8.2

1. **SKILL.md** — add a range (Section C) + an explicit anti-hallucination sentence in:
   `mdpe-backlog-discovery`, `mdpe-backlog`, `mdpe-transformation`, `mdpe-execution-context`.
2. **Generation 1 templates** — add an `[E]/[C]/[O]` legend block + an anti-fabrication rule at the
   top (in the same format already used by Generation 2) and inline-mark the blocks identified in
   Sections B.1-B.4 as `[C]`/`[O]`:
   `discovery-session-template.yml`, `validation-risks-template.yml`, `cognitive-backlog-template.yml`,
   `mdpe-microtask-template.yml`, `dependencies-template.yml`, `microtasks-index-template.yml`,
   `category-index-template.yml`, `transformation-template.yml`, `tasks-template.yml`,
   `execution-context-template.yml`, `environment-setup-template.yml`.
3. **Phantom reference** — remove `related_command`/`next_command` (`.txt`) from
   `environment-setup-template.yml`, following the fix pattern already applied in `mdpe-coding`.
4. **Schemas** — no structural change needed (Sections B.2 and B.3 conclude that the current `required`
   fields already protect real traceability/verification; the problem was in the templates and the
   `SKILL.md`, not in the JSON schemas).
