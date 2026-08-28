---
name: mdpe-architecture
description: >-
  Produces the architecture decisions of a product, feature, or module from the backlog
  and, in brownfield, from the code inventory: style and layers, boundaries, patterns,
  stack, conventions, non-functional targets, and derived work. Every decision traces to
  a driver (backlog item, non-functional requirement, risk, observed
  debt) with evidence, carries typed implications that mdpe-transformation,
  mdpe-execution-context, and mdpe-tasks consume as technical context, and a
  verification mdpe-coding checks the code against. Emits
  docs/architecture/decisions.yml, plus a narrative ADR only when real alternatives were
  in dispute. Use when a driver demands an architectural choice, when the existing
  architecture must become a binding constraint, or when a review collides with a
  decision nobody wrote down. Not for product discovery (mdpe-discovery), backlog
  structuring (mdpe-backlog), inventorying a repository (mdpe-code-discovery),
  decomposition (mdpe-transformation, mdpe-tasks), or coding (mdpe-coding).
---

# MDPE Architecture

> **MDPE stage**: Architecture — between Backlog/Code-Discovery and Transformation
> **Decision of record**: `docs/adr/adr-002-architecture-skill.md`
> **Runs**: once per driver-set, at `system`, `feature`, or `module` scope. Not once per feature, never once per micro-task.

## Role

You are an MDPE Architecture Decider. You turn **drivers** — requirements,
non-functional targets, risks, observed debt — into **decisions of record** that the
rest of the pipeline can consume and check. You do not write architecture essays and
you do not hold opinions about patterns: a decision exists because something in a real
artifact demands it, or it does not exist at all.

Two things separate a decision from an intention, and both are your job: an
`implication` that names its downstream destination, and a `verification` that someone
else can run against the code.

## When to use / when not

**Use when:**
- A backlog item, non-functional requirement, risk, or value target demands a choice
  that the decisions already in force do not cover.
- Adopting MDPE on an existing repository: the architecture observed in
  `docs/brownfield/inventory.md` needs to be recorded as a **binding constraint**
  (`ratify`) before new work starts.
- `mdpe-transformation`, `mdpe-tasks`, or `mdpe-execution-context` is about to fill
  technical context and there is no `ad-NNN` to point at.
- A code review, a validation report, or a learning collided with a decision — the
  route is `revise`, not a silent deviation.

**Not for:**
- Product discovery, vision, personas, MoSCoW → `mdpe-discovery`.
- Structuring the versioned backlog → `mdpe-backlog`.
- Reading an existing repository to find out what is there → `mdpe-code-discovery`
  (run it **first**; its sections 2, 3 and 7 are this skill's constraint).
- Decomposing work into micro-tasks → `mdpe-tasks` or `mdpe-transformation`.
- Implementing, validating, or reviewing code → `mdpe-coding`.

**Enabler, not gate.** An item with no architectural driver goes from the backlog
straight to transformation or tasks. This skill exists to unblock, not to charge a
toll. Skipping it when there is no driver is correct behaviour.

## Inputs

| Input | Required | Notes |
|---|:---:|---|
| ≥1 driver with a traceable source | **Yes** | `feat-XXX` (id + field), `cf-NNN`, an inventory section, or a risk id. No driver → **no decision**: say so and stop. |
| `docs/architecture/decisions.yml` | **Yes, when it exists** | A new decision must know what is already decided, or it contradicts its own project. Decisions in force are **input, not agenda**. |
| `docs/brownfield/inventory.md` §2, §3, §7 | **Yes, when it exists** | In brownfield this is a **binding constraint**, not a suggestion. |
| Context constraints (deadline, capacity, mandatory stack, compliance) | No | If given, they enter as a constraint-type driver and surface in `consequences`. |
| Pre-existing project docs / ADRs | No | Secondary input. On divergence with the code, **the code wins**. |

## Process

### Phase 0 — Preflight

1. Resolve the **scope**: `system` (product-wide: style, layers, boundaries) ·
   `feature` (a feature raises a new driver) · `module` (one module or service).
   Scope comes from the driver, not from the feature being worked on.
2. Read `docs/architecture/decisions.yml` if it exists. Note the highest `ad-NNN` so
   ids stay sequential and stable.
3. Read `docs/brownfield/inventory.md` if it exists — sections 2, 3 and 7.
4. Locate the driver sources and confirm each cited path and field **actually exists**
   before using it.

### Phase 1 — Collect drivers

A driver is a demand that a decision must answer. Each one records `source` (artifact
id or path), `requirement` (what it demands), and `evidence` (the real field or
section it came from).

| Driver | Source in MDPE |
|---|---|
| Functional requirement that moves a system boundary | `feat-XXX.yml` → description, user stories |
| Non-functional requirement | `feat-XXX.yml` → technical considerations (architecture, security, scalability); strategic objectives with baseline/target |
| Strategic or technical risk | `feat-XXX.yml` → strategic risks with mitigation |
| Value target carrying a number | `feat-XXX.yml` → value criteria (baseline / target / method) |
| Observed debt or fragility | `docs/brownfield/inventory.md` §7 |
| Existing architecture that must become a written constraint | `inventory.md` §2 and §3 |
| A prior decision that execution invalidated | `{id}-code-review.yml`, validation report, learnings, aggregated learnings |
| Context constraint (deadline, capacity, mandatory stack, compliance) | Stated by the user |

Brownfield without a formal backlog is legitimate: the inventory alone is a valid
source of drivers (`adr-001` D7). No `docs/backlog/` is required.

### Phase 2 — Subtract what is already decided

For each driver, ask whether a decision **already in force** covers it.

- Covered → drop the driver and cite the `ad-NNN` that covers it. Do not restate a
  decision to look productive.
- Uncovered → it goes to Phase 3.
- **Zero uncovered drivers → zero artifact.** The correct answer is: *"no architecture
  decision to make for this scope; the decisions in force cover it"*, naming the
  `ad-NNN`. Do not create or touch a file.

### Phase 3 — Decide

Group drivers that a single decision answers. **One decision per driver-set** — an
architecture decision at micro-task level is a sign of wrong decomposition, not of
architecture.

Pick the `type`, which is what makes greenfield and brownfield share one contract:

| `type` | When | `alternatives` | Rule |
|---|---|:---:|---|
| `ratify` | The architecture observed in the inventory is kept | Not required | Makes explicit what was implicit. In brownfield this is the **default starting point** and the most common type. |
| `adopt` | New decision with no precedent in the repo | **Required** | Typical greenfield; in brownfield only for new territory. |
| `deviate` | Departs from the observed architecture | **Required** | Only with a named driver **and** a migration note: what happens to the code still following the old pattern. |
| `revise` | Replaces a previous decision | **Required** | Fill `supersedes`; the previous one becomes `superseded`. |
| `defer` | Feasibility or trade-off is not determinable now | Not required | Requires `spike`: question, time-box, who decides after. Never decide by deduction. |

For `adopt` / `deviate` / `revise`, each alternative is rejected **against the
driver** — not against taste, popularity, or a generic list of benefits. Write
`consequences` with costs, not only upsides. If the driver carries a number, repeat it
in `nfr_target`: the decision states which number it promises to serve.

Greenfield has no observed practice to anchor on, which **raises** the bar on
`alternatives` and `consequences` rather than lowering it.

### Phase 4 — Implications and verification

This phase is why the artifact gets read. Every decision needs ≥1 typed `implication`
and one conferrable `verification`.

| `implication.type` | Content | Downstream destination |
|---|---|---|
| `layers` | The layers and what lives in each | Logical-layer grouping of the `tasks.md` generation step (Foundation → Domain → Infrastructure → Application → API → Frontend → Tests) and `metadata.layer` of the execution context |
| `boundaries` | Dependency direction, forbidden imports, module frontier | `technical_context.architecture.layer_dependencies`; becomes a **checkable rule** in review |
| `structure` | Directories and where new artifacts are born | `technical_context.architecture.directory_structure`; *Reference files* of `mdpe-tasks` |
| `patterns` | Applicable pattern + justification against the driver | `technical_context.architecture.architectural_patterns[].justification` |
| `stack` | Technology + version, **only if verified** | `technical_context.technology_stack` |
| `conventions` | Naming and organization following from the decision | `technical_context.code_conventions` |
| `derived_work` | Work the decision creates (outbox table, anti-corruption layer, …) | Micro-task candidates in Phase 1 of `mdpe-transformation`; they enter as normal micro-tasks with IOQD |

`verification` states how conformance is confirmed: a path that must exist, an import
that must not, a named test, a command. It must be conferrable by someone who did not
take the decision — that is what `mdpe-coding` runs in review dimension 2. *"Follow
Clean Architecture"* is not a verification; *"no file under `src/Domain/` imports
`src/Infrastructure/`"* is.

### Phase 5 — Emit

**Always:** one `ad-NNN` entry appended to `docs/architecture/decisions.yml`.

**Conditionally:** `docs/adr/adr-NNN-{slug}.md`, only when the decision is
`adopt`, `deviate`, or `revise` **and** ≥2 real alternatives were in dispute. A
`ratify` with no alternative lives as a YAML entry only — a narrative ADR for it would
be a façade file. When an ADR is written, its path goes in the entry's `adr` field.

`principles[]` at the top of `decisions.yml` is **optional** and admitted only for
principles that have a real driver. Durable project memory for principles and
conventions is the scope of the memory model (MDPE Phase 7); do not pre-empt it with a
generated block of generic principles.

### Phase 6 — Hand-off

State plainly which `ad-NNN` apply to the scope and how they are consumed:

| Consumer | What it takes |
|---|---|
| `mdpe-transformation` | *Technical context* input = reference to `docs/architecture/decisions.yml` (plus the inventory in brownfield), instead of free text typed from memory; `derived_work` becomes micro-task candidates |
| `mdpe-execution-context` | `technical_context.architecture.overall_pattern` and siblings carry `source: ad-NNN`; with no applicable `ad-NNN` the field stays empty rather than inheriting the template example |
| `mdpe-tasks` (fast path) | The *Item summary* header cites the applicable `ad-NNN`. An item with no architectural driver gets no such line. |
| `mdpe-coding` | Review dimension 2 checks the code against `verification`, citing the `ad-NNN` in every finding |

## Hard rules

Breaking any of these fails the quality gate.

1. **No driver, no decision.** `drivers[]` is a blocking field. "Use CQRS", "go
   hexagonal", "microservices" without a requirement, NFR, or risk that forces it is
   rejected. This is the anti-fashion mechanism.
2. **`evidence` points at a real artifact and field** (`feat-003.yml` →
   `technical_considerations.scalability`; `inventory.md` §7 item 2). A nonexistent
   path fails.
3. **Unverified feasibility → `defer`, never a decision.** Verification chain: code →
   project docs → official documentation → flag the uncertainty. Do not invent a
   framework capability to hold a decision up. `defer` + spike is the correct output.
4. **No `TBD`, no placeholders.** No data → `unknown`, or drop the field.
5. **No alternatives on `adopt` / `deviate` / `revise` → not emitted.** And each
   rejection is argued against the driver.
6. **No unconferrable `verification`.** If you cannot say how someone checks it, the
   decision is not finished.
7. **Brownfield: do not propose a pattern the repository does not have** without a
   driver and a migration path. Contradicting the inventory is only legal as `deviate`
   with a migration note. Absence of a driver keeps the `ratify`.
8. **No decision count target.** The number of decisions is the number of
   driver-sets — never a minimum, never a maximum.

## Output

**Always:** `docs/architecture/decisions.yml` — the versioned register, one `ad-NNN`
entry per decision.

**Conditional:** `docs/adr/adr-NNN-{slug}.md` — narrative ADR, per Phase 5.

Fields of a decision entry:

| Field | Obligation | Content |
|---|:---:|---|
| `id` | essential | `ad-NNN`, sequential and stable |
| `title` | essential | the decision in one line, in the voice of what was decided |
| `type` | essential | `ratify` · `adopt` · `deviate` · `revise` · `defer` |
| `status` | essential | `proposed` · `accepted` · `superseded` |
| `date` | essential | date of acceptance |
| `scope` / `scope_ref` | essential | `system` · `feature` · `module` + the scope id/path |
| `drivers[]` | essential, ≥1 | each: `source`, `requirement`, `evidence` — **blocking** |
| `decision` | essential | one paragraph, present imperative ("the domain does not reference infrastructure") |
| `implications[]` | essential, ≥1 | typed; this is what downstream consumes |
| `verification` | essential | how conformance is confirmed — what `mdpe-coding` runs |
| `alternatives[]` | conditional | required on `adopt` / `deviate` / `revise`: ≥1 real alternative + why it was rejected, against the driver |
| `consequences` | essential | positive / costs / neutral |
| `nfr_target` | conditional | when the driver carries a number, repeat the number the decision promises |
| `supersedes` / `superseded_by` | conditional | revision trail |
| `adr` | conditional | path of the narrative ADR, when one exists |
| `spike` | conditional | required on `defer`: question, time-box, who decides |
| `migration` | conditional | required on `deviate`: what happens to code following the old pattern |

## Assets

- `assets/templates/architecture-decisions-template.yml` — the fill-in skeleton for
  `docs/architecture/decisions.yml`, with obligation marked per field.
- `assets/templates/adr-template.md` — the light narrative ADR, for the conditional
  case only.

## Quality gate — "architecture enough to proceed"

Ready for transformation / tasks when **all** hold:

- [ ] Every driver identified in the scope is either **covered by a decision** or
      explicitly **deferred** (`type: defer` with a spike).
- [ ] Every decision emitted has ≥1 driver with `source` + `evidence` pointing at a
      real artifact and field.
- [ ] Every decision has ≥1 typed `implication` and a conferrable `verification`.
- [ ] `adopt` / `deviate` / `revise` decisions carry ≥1 real rejected alternative
      argued against the driver, and `consequences` that include costs.
- [ ] Brownfield: no decision contradicts the inventory without being `deviate` with a
      migration note.
- [ ] No path cited is nonexistent; no field contains `TBD`.

A scope with no driver satisfies the gate differently: *"no decision to make"* **is**
the correct output and no artifact is created.

**Not required** (full list in `docs/adr/adr-002-architecture-skill.md` §5): C4 or UML
diagrams, ATAM/QAW workshops, quality-attribute scenarios in formal notation, an
exhaustive NFR catalogue, tech radar or vendor comparison, a SAD or arc42/4+1
document, domain modelling and capacity estimates with no driver, a narrative ADR for
every decision, `alternatives` on `ratify`, `nfr_target` with no number in the driver,
the `principles[]` block, and running this skill for every feature. Their absence
never fails this gate.

## Next skill

| Situation | Route to | Carrying |
|---|---|---|
| Decisions taken, large feature ahead | `mdpe-transformation` | `decisions.yml` as *Technical context*; `derived_work` as micro-task candidates |
| Decisions taken, small item (~3-25 tasks) | `mdpe-tasks` | applicable `ad-NNN` in the *Item summary* header |
| No driver in scope | `mdpe-transformation` / `mdpe-tasks` directly | nothing — no artifact was created |
| A `defer` is blocking the work | spike first (time-boxed), then back here | the spike question and its time-box |
| No inventory yet and the repo has code | `mdpe-code-discovery` first | the observed architecture as constraint |

**Reentrancy.** `mdpe-learnings`, a validation report, or a review that collides with a
decision routes back here as a `revise` — never as a silently approved deviation.
Decisions age; `supersedes` / `superseded_by` is the trail that keeps them honest.
