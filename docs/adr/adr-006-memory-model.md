# ADR-006 — MDPE Memory Model

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 28/08/2026 |
| **Origin task** | `tasks-v1.md` → Phase 7 → 7.1 |
| **Rubric axis** | Axis 6 — Memory (baseline **1**, target **4**; level 5 with the curation from 7.2 + wiring from 9.2) |
| **Implemented by** | Task 7.2 (`project-memory-template.yml`, `aggregated-learnings.yml` template, read contracts in the skills) · reclassified in 8.1 · stitched together in 9.2 · rescored in 9.3 |
| **Associated adoptions** | A6 (readable project memory with resumption contract) · A12 (`candidate` → `confirmed` lessons, with embedded curation) · A5 (lazy creation) · A4 (verification chain: evidence beats snapshot) · A13 (cross-artifact pending items) |
| **Depends on** | ADR-001 (datable inventory: `verified_at` + commit, §3 conventions with evidence, §7 debt; **D7 delegates reconciliation with memory to this ADR**) · ADR-002 (`decisions.yml` as decision log; **D5 and alternative (f) delegate durable principles and conventions to this ADR**) · ADR-003 (`root_cause_diagnosis.symptom`, status vocabulary, escalation routes) · ADR-004 (tracking as a projection; E2 `recurring_signatures` named as raw material for a confirmed lesson; block E conditional due to missing template; D8 metric is not a gate) · ADR-005 (graph as an adjacency retrieval index; D1 provenance; D9 regeneration and drift) |

---

## 1. Context

The MDPE **writes** memory and **does not read** memory. This is not a metaphor: it is literal, and it is
verifiable by opening the eleven skills and looking for a step that opens a learning artifact before deciding.
It exists in one — the one that writes it.

### 1.1 No entry skill has a read step (Gap 6.1)

Inventory of what each skill declares it reads, field by field:

| Skill | Reads decisions? | Reads inventory? | Reads learnings? | Evidence |
|---|:---:|:---:|:---:|---|
| `mdpe-router` | — | — | **no** | Entire `SKILL.md`: routing table, return loops, skill directory. Zero state-reading step. |
| `mdpe-backlog-discovery` | — | — | **no** | `## Inputs`: vision, problem, market, goals, stakeholders, constraints, *"optional prior inputs: research, interviews, user data"* — external research, not an MDPE artifact |
| `mdpe-backlog` | — | — | **no** | `## Inputs`: only `docs/discovery/01..05-*.yml` + session metadata |
| `mdpe-code-discovery` | — | (it is the writer) | **no** | prior documentation enters as *secondary input*, with *"code beats documentation"* |
| `mdpe-architecture` | **yes** | **yes** | **no** | `decisions.yml` is *"Yes, when it exists"*; inventory §2/§3/§7 is a binding constraint. Learnings appear only as a possible standalone **driver**, with no path and no step |
| `mdpe-transformation` | **yes** | **yes** | **no** | *"Technical context — by reference, not from memory"* points to `decisions.yml` and the inventory |
| `mdpe-execution-context` | **yes** | **yes** | **almost** | `## Inputs` says *"Repository state: stack, conventions, existing structure, **aggregated learnings from prior tasks**"* — and **names no file at all**. Dimension 6 repeats: *"prior learnings applicable to this task"*. No phase opens anything |
| `mdpe-coding` | **yes** | **yes** | **no** | the Phase 0 command-resolution chain has **six** numbered sources (`quality_criteria[].how_to_verify` → `setup.yml` → actual manifest → `ad-NNN` `verification` → `inventory.md` §6 → ask). `aggregated-learnings.yml` is not among them |
| `mdpe-tasks` | **yes** | **yes** | **no** | *"take it **by reference** instead of from memory"* cites `decisions.yml` and the inventory; not learnings |
| `mdpe-learnings` | **yes** | — | **writes** | the only one that produces learnings — and routes them to Discovery/Transformation/Next executions |

`mdpe-graph` sits outside the purpose table: it is a derived projection of the artifacts (ADR-005 D1) and
decides nothing, so it has nothing to consult. Its role here is the opposite — **providing** the
retrieval index (D8).

The pattern is stark and asymmetric: `mdpe-learnings` routes a lesson to three targets
(*Discovery* · *Transformation* · *Next executions*) and **none of the three has a matching read
contract**. The output end of the loop exists; the input end does not. This is Gap 6.1 in its
rawest form: the framework is cognitive on write and amnesiac on read.

A detail worth calling out because it is the closest thing to a near-miss: `mdpe-execution-context`
**knows** it should read learnings — it says so twice in `SKILL.md` — and has nowhere to point.
Promising a read with no path is the same defect ADR-004 removed from measurement: a reference with
no artifact.

### 1.2 The two learning artifacts have no template (Gap 6.2)

`mdpe-learnings/SKILL.md` → `## Outputs` promises three files:

1. `docs/transformation/{feature-id}/execution/{microtask-id}-learnings.yml`
2. `docs/learning-loops/aggregated-learnings.yml`
3. `docs/tracking/mdpe-tracking.yml`

`skills/mdpe-learnings/assets/templates/` contains **one** file: `mdpe-tracking.yml`. The first two
are promised output with no model artifact, and the repository already records this in three
independent places:

- `mdpe-tracking.yml`, block E: *"CONDITIONAL by decision (ADR-004 D4/E): that artifact has no template
  yet (Phase 7). No file → DELETE this block."*
- `mdpe-graph/SKILL.md`: *"`{microtask-id}-learnings.yml`, `docs/learning-loops/aggregated-learnings.yml`
  | No | learning nodes — **no template exists yet**, so treat as condition, never as a required node"*
- `traceability-graph-template.md`: *"learnings | … | absent — no template exists yet"*

A chained consequence, already paid for across two phases: the ADR-004 propagation metric (block E,
E1/E2) was born **conditional**, and the ADR-005 `learning` node was born **conditional**. Two phases
delivered a partial contract because this one was missing. Closing Gap 6.2 is what returns block E and
the `learning` node to their owners.

And there is a quieter effect: of the four learning types `mdpe-learnings` defines
(*technical, process, strategic, problems*), **none has a field in any template**. Before this ADR, the word
`pitfall` appeared exactly once across all skills and templates — in the list of the four types itself, in
`mdpe-learnings/SKILL.md`. There is nowhere to store a pitfall.

### 1.3 Memory already exists in three layers — and three ADRs deliberately reserved its place

This is the finding that changes the design: **two of the three layers are already in place, dated, and
have provenance.** What is missing is one layer and, above all, the read contract.

| Layer requested by 7.1 | Artifact that already implements it | What it already provides |
|---|---|---|
| **(1) project memory** — decisions and conventions | `docs/architecture/decisions.yml` (ADR-002) | stable `ad-NNN`, `date`, `status`, `type` (`ratify`/`adopt`/`deviate`/`revise`/`defer`), `implications[].type` including **`conventions`**, checkable `verification`, `supersedes`/`superseded_by`, `spike` on `defer` |
| | `docs/brownfield/inventory.md` (ADR-001) | §3 observed conventions (`Convention` · `Observed rule` · `Evidence`, ≥1 is a gate) · §7 concerns/debt with evidence · header with **`verified_at` + branch@commit** · staleness rule |
| **(2) aggregated learnings** | `docs/learning-loops/aggregated-learnings.yml` | **only the path exists** — no template, no schema, no known structure |
| **(3) execution** | `docs/tracking/mdpe-tracking.yml` (ADR-004) | projection derived from a closed micro-task, `signals` with a route, `reconciliation.pending[]` and — decisively — `aggregates.project.propagation.recurring_signatures` with `signature` + `occurrences[]`, annotated in the template itself as *"raw material for a confirmed lesson (Phase 7)"* |

And three earlier ADRs **explicitly declined to occupy this space**, each one naming the seam:

- **ADR-002 D5:** *"A `principles[]` block at the top of `decisions.yml` is optional and admitted only for
  principles that have a real driver. Durable memory of project principles and conventions is in scope of
  ADR-006 (Phase 7); this ADR does not implement it, it only avoids occupying its place."* The same text is
  repeated in `architecture-decisions-template.yml`, right above the `principles:` key.
- **ADR-002, alternative (f):** *"Stable project principles are useful, but they are **memory**, not a
  one-off decision: their place is ADR-006, where project memory with conventions and pitfalls (A6) is
  already planned."*
- **ADR-001 D7:** *"`verified_at` makes the inventory datable. On resumption, if the repo has changed
  since `verified_at`, **current evidence beats the inventory** and the affected sections are
  re-inventoried. The formal connection to project memory is left for Phase 7 (ADR-006)."*
- **ADR-005 D15 / `graph-queries.md`:** *"the adjacency of the node currently being worked on
  (`derives-from`, `implements`, `learned-from`) is the short list of decisions and lessons relevant to
  it, so a session can read by neighborhood instead of loading every artifact. The format of memory is
  decided elsewhere; this skill provides the index and assumes nothing about it."*

In other words: the **retrieval** mechanism (graph adjacency) was already delivered in Phase 6, the
**decision log** was already delivered in Phase 3, **dated evidence of conventions** was already
delivered in Phase 2, and the **raw material for lessons** was already delivered in Phase 5. What is
missing is the lesson layer and the read trigger.

### 1.4 Where memory is genuinely absent

Five real absences, and none of them is "we're missing a database":

1. **There is no home for lessons or pitfalls to be written.** §1.2.
2. **`code_conventions` is retyped per micro-task, with no provenance.** In
   `execution-context-template.yml`, every sibling of the `architecture` block carries
   `*_source: ad-NNN` (`overall_pattern_source`, `target_layer_source`,
   `layer_dependencies_source`, `directory_structure[].source`, `architectural_patterns[].source`,
   `verification[].source`). The `code_conventions` block — which the template's own comment maps
   as the destination of the `conventions` implication — **has no source field at all**. Worse: it is
   language-hardcoded (`database_naming`, `csharp_naming`). Conventions are, today, the only piece of
   technical context the framework requires filling in **from memory** — exactly what it forbids in five
   other places (*"by reference, not from memory"*).
3. **There is no resumption contract.** The word `session` in the repository means **discovery
   session** (`discovery_session_id`, `persona-NNN`), never a working session. There is no
   `session-brief`, no safe next step, no handoff snapshot. Whoever starts a new session discovers the
   state by opening files in whatever order they guess.
4. **The inventory's staleness rule has no consumer.** `mdpe-code-discovery` says that, on
   resumption, current evidence beats an outdated inventory and only the affected sections are
   re-inventoried — but **there is no field** recording which section was updated, nor any mechanism to
   tell another skill that the inventory has aged. It is a narrative rule with no hook.
5. **Pending items are scattered.** `defer` + `spike` live in `decisions.yml`;
   `reconciliation.pending[]` lives in tracking; the pending execution path item (ADR-005 D6) lives in
   the graph. Three places to answer "what is still open in this project?" — a question that is
   memory, and one of the most useful kinds.

### 1.5 What the benchmark says about memory

`docs/analysis/competitive-analysis.md` marks the **MDPE with ○** on four memory features
(*retrievable decision log across sessions*, *reconciled handoff/resumption*, *archiving/
consolidation on completion*, *project principles*) and **◐** on *curated lessons*. Two P0/P1 adoptions
point here:

- **A6 (P0) — TLC 5.5 · OSpec 4.6.** TLC keeps `STATE.md`: a decision log with an id and a handoff
  snapshot, and on resumption **the snapshot is reconciled against git — real evidence beats a stale
  snapshot**. OSpec emits a `session-brief` showing active changes, queue state, and **the next safe
  command**, before touching anything. The "evidence beats snapshot" detail is built-in anti-
  hallucination, and it is the rule this ADR adopts wholesale.
- **A12 (P1) — TLC 5.6.** Curated lesson layer: canonical, machine-owned state,
  **only confirmed lessons** are loaded during decision phases — candidates never — and a **clean
  outcome logs nothing**. It is the antidote to the risk that 7.2 itself names in the negative
  scenario: memory that grows without bound.
- **OpenSpec 2.4** closes the loop through **archiving**: the delta is merged into the main spec and the
  change folder goes into a dated archive — the spec now describes the new reality. Translated here: a
  confirmed lesson that becomes a rule **graduates** into the artifact that governs it, instead of
  accumulating.
- **TLC 5.7** declares a context budget: on-demand loading, forbidding loading multiple specs at once.
  Memory that requires loading everything before acting is not memory, it's a tax.

---

## 2. Decision

### D1 — Memory is not a new artifact: it is a **read contract** over three layers, of which only one is missing

The inversion in this ADR is different from previous ones. ADR-004 and ADR-005 inverted *where the
truth lives*. Here the truth already lives in the right place — what is missing is **someone opening the
file**.

| Layer | Artifact | Owner (who writes) | Situation |
|:--:|---|---|---|
| **C1 — Constraints** (decisions + conventions + observed debt) | `docs/architecture/decisions.yml` · `docs/brownfield/inventory.md` | `mdpe-architecture` · `mdpe-code-discovery` | **exists**; this ADR changes not a single field |
| **C2 — Lessons** (aggregated learnings, the loops) | `docs/learning-loops/aggregated-learnings.yml` | `mdpe-learnings` | **path exists, structure does not**; 7.2 creates the template (D5) |
| **C3 — Execution** (what has already run) | `docs/tracking/mdpe-tracking.yml` | `mdpe-learnings` | **exists** (ADR-004); memory only **reads** |

Three hard rules follow from this:

1. **Memory copies nothing from C1 or C3.** Whoever wants the decision reads `decisions.yml`. Whoever
   wants the number reads tracking. Duplicating here would recreate the drift ADR-004 D7 just
   eliminated.
2. **Memory has no writes of its own.** Each layer is written by its own owner, on its own trigger.
   There is no "write to memory" as an independent action (D4).
3. **Memory is not a source.** In a divergence between memory and an artifact — or between memory and
   the **code** — the artifact wins, and code wins over the artifact. This is rule A6/TLC 5.5 (*evidence
   beats snapshot*) and is the same stance already written in `mdpe-code-discovery` (*"code beats
   documentation, and current evidence beats an old inventory"*).

### D2 — A derived read index: `docs/memory/project-memory.yml`

The read contract needs to be **cheap**, or no one honors it. The three layers add up to hundreds of
lines spread across four paths; requiring every skill to open all of it before acting is the opposite
of a context budget (TLC 5.7) and would be abandoned on day two.

Decision: an **index**, derived and regenerable, under the same contract as the graph (ADR-005 D1/D9)
and tracking (ADR-004 D1) — **projection, never a source**.

**Location:** `docs/memory/project-memory.yml`. Template at
`skills/mdpe-learnings/assets/templates/project-memory-template.yml` (destination recorded in 7.2).

**What the index carries — and nothing more:**

| Block | Content | Source (artifact → field) | Requirement |
|---|---|---|---|
| `metadata` | `generated_at`, `branch@commit` read, `generated_by` | the generation itself | **essential** |
| `constraints[]` | one line per decision **in effect**: `ref: ad-NNN` + the `title` as written + `type` | `decisions.yml` → `id`, `title`, `type`, `status: accepted` | essential when `decisions.yml` exists |
| `conventions[]` | one line per convention in effect: `rule` + `source` + `evidence` | `decisions.yml` → `implications[].type: conventions`; `inventory.md` §3 → line (`Observed rule` + `Evidence`) | essential when any of the sources exist |
| `pitfalls[]` | one line per **`confirmed`** lesson of type `technical`/`problem`: `ref: ls-NNN` + `statement` | `aggregated-learnings.yml` → lessons `status: confirmed` | conditional (C2 with ≥1 confirmed) |
| `calibration[]` | `confirmed` lessons of type `process`/`strategic`, with the routing target | same + `target` | conditional |
| `open_questions[]` | what is open: `defer` without a resolved spike · `reconciliation.pending[]` · pending graph path item | `decisions.yml` → `type: defer` + `spike`; `mdpe-tracking.yml` → `reconciliation.pending[]`; graph view | conditional |
| `staleness[]` | items whose evidence may have aged: `inventory.md` with `verified_at` earlier than the current commit; a cited path that no longer exists | inventory header vs repo state; graph drift audit (ADR-005 D9) | conditional |
| `next` | **pointer** to the dispatch, never a recalculation | `mdpe-graph` wave view (ADR-005 D10) or `microtasks-index.yml` | optional |

**One copy is admitted, and only one:** the `title`/`statement` of a line, so the index is readable
without opening five files — exactly as the graph's edge table carries a label and tracking carries a
pointer. In a divergence, **the owner wins and the index is regenerated** (D1 rule 3). No other field of
the owner is included: no `drivers`, no `alternatives`, no `consequences`, no `verification`, no full
lesson `evidence[]`.

**Lazy creation (A5).** With no `decisions.yml`, no inventory, and no closed micro-task → **no file at
all**, and the correct answer is *"there is no memory to consult"*. An empty index would signal that a
project existed when it did not.

**Size as a sensor.** The index only admits `accepted` decisions, conventions in effect, `confirmed`
lessons, and open pending items — so its size is bounded by construction. When it exceeds a screen, the
signal is not "paginate": it is that a lesson is pending **graduation** (D5). Index growth is a
thermometer for curation, not a formatting problem.

### D3 — **Read** contract: who reads, when, and what is forbidden to conclude from the reading

This is the section that closes Gap 6.1. The general rule: **read the index, not the layers**; a layer
is opened only when the index points to an item relevant to the matter at hand.

| Skill | When it reads | What it reads | What it **cannot** do with it |
|---|---|---|---|
| `mdpe-router` | **before routing** | the whole index (it is bounded by D2) | does not decide architecture or scope; announces what is in effect, what is open, and what is *stale*, and routes |
| `mdpe-backlog-discovery` | before opening a session | `calibration[]` with `target: discovery` | does not treat a lesson as a requirement; a lesson is a reprioritization input, not a feature |
| `mdpe-backlog` | before structuring | same | does not rewrite perceived value based on a lesson with no evidence |
| `mdpe-code-discovery` | Phase 0 | `staleness[]` + `conventions[]` sourced from the inventory | **code beats memory**: an index convention is used to check, never to fill in §3 without sampling a file |
| `mdpe-architecture` | Phase 0, alongside `decisions.yml` | confirmed `pitfalls[]`, `open_questions[]`, `conventions[]` | a lesson is **not a driver** on its own: it becomes a driver only with `evidence[]` pointing to an artifact and field (ADR-002 D6) |
| `mdpe-transformation` | Phase 1, alongside technical context | `conventions[]`, `pitfalls[]`, `calibration[]` with `target: transformation` | does not change the decomposition range on a guess; calibration requires a `confirmed` lesson |
| `mdpe-execution-context` | when assembling dimensions | `conventions[]` (with `source`) and applicable `pitfalls[]` | **replaces** retyping conventions: what enters `code_conventions` now has an origin (D6). With no source, the field stays empty |
| `mdpe-coding` | **before Phase 1 (Act)**, after the Phase 0 plan is frozen | applicable confirmed `pitfalls[]` | **does not enter the command chain.** Commands come from an executable artifact, never from a lesson (ADR-003). A lesson informs the implementation; it never becomes evidence, never becomes a gate, never becomes `verification` |
| `mdpe-tasks` | one read, at the header | the whole index | fast path: one read, one file. Opens no layer |
| `mdpe-learnings` | on closing a micro-task | C2 + C3 + `decisions.yml` | the only one that **writes** and regenerates (D4) |
| `mdpe-graph` | — | nothing | does not consult memory: **provides** the adjacency retrieval index (D8) and is never a source of constraints |

Three prohibitions apply to everyone, and they are what keeps memory from becoming a source of
hallucination:

1. **A lesson is not evidence.** Nothing in a `validation-report` or `code-review` can be filled in
   from a lesson. Evidence is a command executed with a result (ADR-003 D3). A lesson can say *where to
   look*; never *what happened*.
2. **Memory does not decide.** No architecture decision, no micro-task status, no verdict is born
   from the index. The index says what has already been decided, by whom, and where to check.
3. **A missing index does not block.** With no memory, every skill proceeds with what it already read
   today. Reading is an **enabler, not a gate** (OpenSpec 2.5), a stance `mdpe-architecture` already
   adopts in writing.

### D4 — **Write** contract: triggers per layer, no new owner

| Layer | When it is written | By whom |
|---|---|---|
| **C1** — `decisions.yml` | when a driver requires a decision (`adopt`/`ratify`/`deviate`/`revise`/`defer`) | `mdpe-architecture` — **unchanged** |
| **C1** — `inventory.md` | first adoption; re-inventory by scope or when `staleness[]` flags it | `mdpe-code-discovery` — **unchanged** |
| **C2** — `{id}-learnings.yml` | on the close of each micro-task | `mdpe-learnings` |
| **C2** — `aggregated-learnings.yml` | on the same close: a new lesson enters as `candidate`; an existing lesson gains an occurrence; promotion/graduation per D5 | `mdpe-learnings` |
| **C3** — `mdpe-tracking.yml` | on the same close (ADR-004 D6) | `mdpe-learnings` — **unchanged** |
| **Index** | **regenerated**, never edited: on micro-task close, on decision accept/revise, on (re)inventory, and on demand | whoever wrote the layer, or `mdpe-learnings` at close |

Event-driven writes, never periodic — same rationale as ADR-004 D6: a periodic cadence with no tooling
is a promise no one keeps.

**A clean outcome writes nothing** (A12). A micro-task that closes in `i1`, with no finding and no
`root_cause_diagnosis`, generates no lesson. Recording a trivial success is exactly how the framework
would produce volume without information — the Phase 8 problem reintroduced through the memory door.

### D5 — Curation: `candidate` → `confirmed` → `retired`, and graduation instead of accumulation

The negative scenario from 7.2 is explicit: *"memory that grows without bound/curation fails."* The
mechanism has three states and one exit.

**Fields of a lesson** (the structure 7.2 will template in `aggregated-learnings.yml`):

| Field | Required | Content |
|---|:---:|---|
| `id` | essential | `ls-NNN`, sequential and stable — never renumbered |
| `kind` | essential | `technical` · `process` · `strategic` · `problem` — **the four types `mdpe-learnings` already defines**; no new vocabulary |
| `statement` | essential | one line, imperative, on what to do or avoid |
| `status` | essential | `candidate` · `confirmed` · `retired` |
| `evidence[]` | essential, ≥1 | micro-task + artifact + **field** (e.g., `mt-001-003` → `{id}-validation.yml` → `loop.iterations[1].failed[].dimension`) |
| `target` | essential | `discovery` · `transformation` · `next_executions` — the three targets `mdpe-learnings` already routes to |
| `action` · `owner` · `horizon` | essential | already required today by `mdpe-learnings`'s quality gate |
| `applies_to` | conditional | `system` · `feature` · `module` (+ layer/technology when applicable) — this is the index's relevance filter |
| `signature` | conditional | normalized `root_cause_diagnosis.symptom`, when the lesson originated from a failure (links to ADR-004 E2) |
| `first_seen` / `last_seen` | essential | close date of the first and last micro-task that evidenced it |
| `promoted_to` | conditional | `ad-NNN`, convention line, or skill item where the lesson **graduated** |
| `superseded_by` | conditional | `ls-NNN` that replaces it |

**Promotion to `confirmed`** — one of two, never by judgment:

1. **≥2 occurrences** with `evidence[]` naming distinct micro-tasks. This is literally
   `aggregates.project.propagation.recurring_signatures` from tracking (ADR-004 E2), which its own
   template already annotates as *"raw material for a confirmed lesson (Phase 7)"*; or
2. **1 occurrence of verifiable weight**: a `blocker` finding in `code-review`, or `loop.overrun: true`
   with a `root_cause_diagnosis`. A failure that stopped the loop does not need to repeat to count.

Outside these two, the lesson stays `candidate` — **and candidates do not enter the index, so no one
reads them before deciding** (A12). A candidate is an archived hypothesis, not advice.

**Graduation (the exit, adapted from OpenSpec 2.4).** A confirmed lesson that has become a rule **leaves
memory and enters the artifact that governs it**:

| The lesson became | Goes to | And then |
|---|---|---|
| an architecture or boundary rule | `decisions.yml`, as a decision with a driver and `verification` | `status: retired`, `promoted_to: ad-NNN` |
| a code convention | a `conventions` implication of an `ad-NNN`, or inventory §3 when it is an observed practice | `status: retired`, `promoted_to` filled in |
| a process adjustment to the framework itself | a skill change (Phase 9) | `status: retired`, `promoted_to` = the skill |

**Retirement without graduation:** a confirmed lesson whose owning decision became `superseded`, or
that has not reappeared in 10 closed micro-tasks, becomes `retired` **with a reason**. Retired items
leave the index and **remain in the file** — deleting them would destroy the evidence that it was
already considered. History is cheap; the index is what needs to stay short.

It is this graduation/retirement pair that answers the negative scenario: memory does **not** grow, it
**graduates**. A mature project tends to have few confirmed lessons and many graduated ones — a sign of
health, not of forgetting.

### D6 — The only field addition: convention provenance

`code_conventions` in `execution-context-template.yml` is today the only technical context block with
no origin field (§1.4 item 2). A minimal, one-line fix:

- **`code_conventions_source`**, **conditional**: `ad-NNN` (`conventions` implication) or
  `inventory.md §3`. No source → the block stays **empty**, and empty is the correct outcome — the same
  rule already written for `overall_pattern` (*"Leave the field EMPTY and record the absence"*).
- And the welcome side effect: with no source, there is no convention to retype from memory. The
  language-hardcoded field (`csharp_naming`, `database_naming`) stops being filled by habit; reclassifying
  the block into something language-agnostic is 8.1's job, not this ADR's.

No other field is added to any existing template. `aggregated-learnings.yml` and `project-memory.yml`
are **new structure for an already-promised path** — closing a phantom reference, not creating an
obligation.

### D7 — Resumption: reconciliation against the repo, evidence beats snapshot

Resumption is the use case that justifies memory's existence (A6 / TLC 5.5 · OSpec 4.6), and the MDPE
has none of this today (§1.4 item 3).

**When starting a session** (`mdpe-router`, or the entry skill when the router is skipped):

1. Read the index. No index → *"there is no memory"*, proceed.
2. Compare the index's `metadata.branch@commit` with the repository's current state. Diverged →
   **regenerate** before using it.
3. Check `staleness[]`: inventory `verified_at` earlier than the current commit, a cited path that no
   longer exists, a `superseded` `ad-NNN` still referenced. Each item becomes a **warning with a
   route**, never a correction by inference.
4. Announce in one line: what is in effect, what is open, what is *stale*, and the next step — the
   latter **read** from the graph's dispatch or the micro-task index, never recomputed
   (ADR-005 D10).

**The rule governing all of this:** in any divergence, the precedence order is
**code > owner's artifact > index**. A snapshot that disagrees with the repository is wrong by
definition. This is the built-in anti-hallucination mechanism the benchmark highlights in TLC 5.5, and
it is the same precedence `mdpe-code-discovery` already applies to documentation.

**Closes the ADR-001 D7 seam:** the index's `staleness[]` item is the consumer the inventory's
staleness rule never had. The rule remains *re-inventory only the affected sections* — the novelty is
that now someone notices it is time.

### D8 — Retrieval by adjacency; the index is the floor, the graph is the ceiling

Two ways to retrieve, and the order matters:

| Situation | How it is retrieved |
|---|---|
| A graph view exists (`mdpe-graph`) | **by adjacency** of the node at hand: `implements` → decisions that govern it; `derives-from` → where it came from; `learned-from` → lessons linked to it. This is the mechanism ADR-005 D15 and `graph-queries.md` Q3 already delivered |
| No graph exists | **via the index**, filtered by `applies_to` (scope/layer/technology) and by the scope of the work at hand |

**C2 is never loaded in full.** `aggregated-learnings.yml` grows with the project and contains
`candidate` and `retired` items, which by definition should not influence a decision. Loading all of it
would import a discarded hypothesis as advice — the most direct hallucination vector a memory layer
can create.

This is also the context budget (TLC 5.7) with no new mechanism invented: the index is short by
construction (D2), adjacency is short by definition, and a layer opens only at the pointed-to item.

### D9 — Memory is **not** a gate

Same rule as ADR-004 D8 and ADR-005 D12, and for the same mechanical reason.

No memory item approves, rejects, blocks, or releases anything. The gates stay where they are: ADR-003
(evidence per dimension, loop limit), ADR-002 (blocking `drivers`), `mdpe-transformation`
(7 criteria), `mdpe-code-discovery` (5 items).

The reason: whoever writes the lesson is the same agent who closes the micro-task. The instant "number
of lessons" or "adherence to a lesson" becomes a target, the pressure shifts to **fabricating a lesson**
— and the layer that existed to reduce hallucination starts producing it. A lesson is advice with
provenance, not an executable rule. When it **needs** to become an executable rule, the path is
graduation (D5): it becomes a decision with `verification`, and only then does review check it — in the
right place, with the right mechanism.

### D10 — No infrastructure, no tooling, no service

Explicit refusal, because the 7.1 negative scenario demands it and because the repository's history
calls for it (Gap 4.1):

- **No vector database, embeddings, memory MCP server, external service, or binary index.** The
  minimum viable solution is versioned YAML and Markdown in the project's repository, checkable in
  diffs and in review.
- **No script.** If a memory tool ever exists, its contract is the same as ADR-004 D12: **a checker,
  never a source** — it recomputes the index from the layers and returns non-zero on divergence. No
  template references a tool before it exists.
- **No harness context window as a layer.** Memory that lives in the conversation does not survive the
  session, which is exactly the problem.

### D11 — Bridge to Kiro's `steering`: **optional export, one direction only**

7.1 raises *"potential bridge to `.kiro` steering"*. Verified: the repository does not mention
`steering` in any skill or ADR — the only occurrences of `.kiro` are in `README.md` and
`INSTALL.md`, and they refer to the **skill installation location** (`~/.kiro/skills`), not project
artifacts.

Decision: **optional, derived, one-way export**. A steering file can be generated from the index (or
simply **point** to it), and never the reverse. Three reasons:

1. **Portability.** The MDPE's skills are text and run on any harness. Tying the minimum viable
   solution to a specific IDE directory would make memory unavailable outside it.
2. **Single source.** A hand-edited steering file would become a second source of conventions, with no
   precedence rule — the error ADR-004 D11 removed from the graph and ADR-002 D5 avoided in
   principles.
3. **Marginal gain.** Steering's value is automatic context injection; this ADR's value is the read
   contract. With the contract written into the skill, injection is a convenience.

Recorded as a host convenience, not a mechanism — and with no reference in any template until it
exists.

### D12 — What this ADR **refuses** to create

| Refused | Reason |
|---|---|
| A `principles[]` block generated in the index | ADR-002 D5 admitted `principles[]` **optional and only with a real driver** in `decisions.yml`. A generic AI-generated principle (*"prefer simplicity"*) is exactly the filler Phase 8 cuts. A principle enters memory **only through graduation** of a confirmed lesson or as a decision with a driver — never authored by the index |
| A "conversation memory"/session history layer | it is not derivable from an artifact, grows without bound, and is not checkable. What a session needs to know is state, and state lives in the three layers |
| Copying decisions or conventions into an "authoritative" memory artifact | would be a third representation of the same thing, with no precedence — the error ADR-005 alternative (c) rejected |
| A `severity`/score/numeric weight for a lesson | a score with no formula is the ADR-004 §1.3 `quality_score` coming back through another door. A lesson has `status` and `evidence[]`; it has no grade |
| A target count of lessons per micro-task | a number of lessons is a number of things learned. A target would produce fabricated lessons (D9) |
| Deleting a `retired` lesson | would destroy the evidence that the hypothesis was already considered. It leaves the index, stays in the file |

### D13 — Seams for the following phases

| Phase | What this ADR delivers or sets up |
|---|---|
| **7.2** (implementation) | the three named layers (D1), the index with blocks and sources (D2), the per-skill read table (D3), the write triggers (D4), the curated lesson structure (D5), the conditional `code_conventions_source` addition (D6) |
| **5 — metrics** | **returns block E to ADR-004**: with `aggregated-learnings.yml` templated, E1 (`learnings_by_target`) and E2 (`recurring_signatures`) stop being conditional for lack of an artifact. E2 gains structural backing: `signature` is now a lesson field |
| **6 — graph** | **returns the `learning` node to ADR-005**: it stops being conditional for lack of a template. The `learned-from` edge gains a destination with a known structure (`ls-NNN`), and `promoted_to` creates a new traceable graduation edge (`ls-NNN` → `ad-NNN`) — to be recorded in 9.1, not here |
| **3 — architecture** | closes the ADR-002 D5 and alternative (f) delegations: durable conventions and principles have an owner, and `decisions.yml` remains only for one-off decisions |
| **2 — brownfield** | closes the ADR-001 D7 delegation: `staleness[]` is the consumer the re-inventory rule never had |
| **4 — fidelity** | nothing changes in the gate. A lesson informs the implementation and **does not** enter the command chain or the evidence (D3, prohibition 1) |
| **8 — anti-hallucination** | a single conditional field addition (D6); everything else is derived or fills an already-promised path. Three mechanisms are directly anti-fabrication: *evidence beats snapshot* (D7), *only confirmed is read* (D5), and *never load all of C2* (D8). The classification of lesson fields is already flagged for the 8.1 audit |
| **9 — wiring** | `mdpe-router` gains a read step (9.2); `docs/memory/` enters the 9.1 path table; the `ls-NNN` ↔ `promoted_to` pair closes the *backlog → architecture → micro-task → evidence → lesson → rule* traceability chain 9.1 asks for; the `docs/memory/` vs `docs/learning-loops/` split is a consolidation candidate (Section 6) |

---

## 3. Completion criteria for memory ("honest memory")

A project's memory is valid when **all** of the following hold:

- [ ] Every line of the index points to an **artifact + field** of origin (or is the copy of an owner's
      line, regenerable).
- [ ] No decision, convention, number, or verdict is **authored** in the index.
- [ ] `metadata` carries `generated_at` + `branch@commit`; no manual edits.
- [ ] Only **`confirmed`** lessons appear in the index; `candidate` and `retired` stay out.
- [ ] Every lesson has `evidence[]` with a micro-task **and** a field; no lesson promoted without
      satisfying one of the two promotion rules (D5).
- [ ] No lesson used as validation evidence, as a verification command, or as a gate.
- [ ] `staleness[]` present whenever there is divergence between `verified_at`/paths and the repo's
      state — and **reported, not corrected by inference**.
- [ ] Precedence respected in every divergence: **code > owner's artifact > index**.
- [ ] No generic principles block; no lesson score.
- [ ] No instruction points to a nonexistent script, service, vector database, or tool.
- [ ] No memory file created with no memory to index (lazy creation).
- [ ] At least 1 entry skill exists whose read step is executable and verifiable — write-only memory
      **fails** by definition.

**Operational test (7.2's positive scenario):** a decision recorded in one session and a lesson
confirmed at the close of a micro-task are **readable in the index in the following session**,
pointing to the source artifacts, with nothing retyped.

---

## 4. Alternatives considered

### (a) Keep it as is: write `aggregated-learnings.yml` and hope someone reads it — **rejected**

This is the baseline (score 1). The artifact has no template, no one opens it, and the rubric is
explicit: level 1 is *"write-only memory: it logs learnings, but no one reads them before deciding;
output with no template"*. It does not even reach level 2, which requires a readable artifact.

### (b) A single memory file, authored by the agent, with decisions + conventions + lessons — **rejected**

This is the intuitive design, and it's what 7.1 could suggest if read literally from *"project memory
template (decisions + conventions + pitfalls)"*. Rejected for three reasons:

1. **It duplicates C1 and C3.** Decisions already live in `decisions.yml` with a driver, alternative,
   consequence, and `verification`; observed conventions already live in the inventory with evidence
   and a date. Copying them creates the drift ADR-004 D7 just removed — in two weeks the two files
   disagree and nothing says which one is right.
2. **Authored is fabricable.** A file the agent writes freely is the natural place for generic
   principles and conventions the repository doesn't have. It's the Phase 8 problem inside the Phase 7
   solution.
3. **It doesn't solve reading.** It would still be writing with no consultation trigger — the real
   defect.

What survives from this idea, and is adopted: an **index** with the same convenience purpose, but
**derived** (D2), with per-line provenance and regeneration as a rule.

### (c) No index: each skill reads the three layers directly — **rejected**

Purer (zero new artifacts, zero copying) and tempting. Rejected because the read contract would be
expensive enough to be ignored:

- Conventions in effect are **scattered** across N `implications[].type: conventions` from N
  decisions, plus inventory §3. There is no single place to read "this project's conventions."
- Open pending items live in three different files (§1.4 item 5).
- A relevant lesson would require scanning all of C2, including `candidate` and `retired` — exactly
  what D8 forbids.
- Resumption would require opening four paths before any decision, against the context budget
  (TLC 5.7).

A contract no one honors scores the same as having no contract.

### (d) Kiro steering (`.kiro/steering`) as a memory mechanism — **partially adopted**

Automatic context injection is genuinely appealing and would solve "when to read" without relying on
discipline. Rejected **as a mechanism** for the three reasons in D11 (portability across harnesses,
risk of a second hand-editable source, marginal gain over the written contract) and adopted as
**optional, one-way export**. Worth noting the asymmetry: the MDPE already installs into
`~/.kiro/skills`, but its artifacts live in the project's repository — memory follows the artifacts'
rule, not the installation's.

### (e) Vector database / embeddings / memory MCP server — **rejected**

Semantic retrieval would resolve relevance better than `applies_to`. Rejected because it directly
contradicts the 7.1 negative scenario (*"a proposal requiring external infrastructure for the minimum
viable solution fails"*), repeats Gap 4.1 at another scale, and breaks three properties the v1 depends
on: diff, review, and clone. Memory outside the repository is not checkable.

### (f) Lesson as a gate ("do not implement against a confirmed lesson") — **rejected**

Would give memory teeth and looks the most like "making memory count." Rejected by D9: the same agent
writes and is measured by the lesson, so the gate creates an incentive to fabricate it. And it is
unnecessary — when a lesson needs to be executable, graduation (D5) turns it into a decision with
`verification`, and review then checks it through a mechanism that already exists and already has
evidence.

### (g) Log every closed micro-task as a learning — **rejected**

Would guarantee "rich memory" and produce noise at volume. A12 is explicit to the contrary: a clean
outcome logs nothing. Without this refusal, the index would fill with zero-value lessons and the
relevance mechanism would die within the first month.

### (h) Read contract over three layers + derived index + curation with graduation (D1-D13) — **chosen**

Against rubric 1.2:

| Axis | Effect |
|---|---|
| **6 — Memory** (1 → 3 here) | Level 3 literally asks for *"ADR defines layers, format, location, and read/write contracts, with no implementation"* — D1, D2, D3, D4. Level 4 (*router/discovery/architecture/coding consult before deciding; learnings updates on close*) is fully contracted for 7.2. Level 5 requires *"consolidation/curation rule and no duplication of aggregated-learnings/tracking"* — that is D5 (graduation) and D1 (nothing is copied) |
| **4 — Measurability** | Returns block E to ADR-004: E1/E2 stop being conditional for lack of an artifact, and `signature` gives `recurring_signatures` structural backing |
| **5 — Graphs** | Returns the `learning` node to ADR-005 and gives the `learned-from` edge a destination; `promoted_to` adds a traceable chain from lesson to rule |
| **2 — Architecture** | Closes the ADR-002 D5/(f) delegation without duplicating `decisions.yml`, and resolves the one technical context block with no provenance (`code_conventions`, D6) |
| **1 — Brownfield** | Closes the ADR-001 D7 delegation: the staleness rule now has a consumer (`staleness[]`) |
| **3 — Fidelity** | No change to the gate; the explicit prohibition on lesson-as-evidence protects the ADR-003 contract |
| **7 — Cognitive cost** | The index is short by construction, and its growth is a sensor for pending curation (D2). Retrieval by adjacency or by filter, never full load (D8) |
| **8 — Hallucination** | Three hard mechanisms: *evidence beats snapshot* (D7), *only confirmed is read* (D5), *never load all of C2* (D8). Plus the D12 refusals — generic principles, lesson scoring, authoritative copying |
| Cost | Zero new skills. Two new templates (`aggregated-learnings.yml`, `project-memory.yml`), one conditional field, a read step in up to six skills, a `docs/memory/` directory, and regeneration discipline |

---

## 5. What is **NOT** required

Nothing below is a prerequisite for memory to be valid, nor for any skill to move forward:

**Content-wise:**

- The whole index, on a project that hasn't decided or closed anything yet: **lazy creation** (A5).
  With no memory, the correct answer is *"there is no memory to consult"*.
- `pitfalls[]` and `calibration[]` before a `confirmed` lesson exists. Zero confirmed is the normal
  state of a new project.
- `open_questions[]`, `staleness[]`, `next` — conditional/optional.
- A lesson for a micro-task that closed clean (A12). Absence is the correct outcome.
- `applies_to`, `signature`, `promoted_to`, `superseded_by` — conditional.
- A principles block, project constitution, manifesto, values — **these do not exist** (D12).
- A convention in the index when neither `decisions.yml` nor the inventory evidences it. A convention
  with no source does not enter; the micro-task's `code_conventions` stays empty (D6).
- A minimum number of lessons, conventions, or constraints. One decision in effect → one line.

**Format-wise:**

- A JSON schema for memory. The templates are enough, as with `decisions.yml`.
- A steering file, automatic context injection, host integration (D11).
- A database, binary index, embeddings, server, script, workflow, dashboard (D10).
- A single file unifying C1, C2, and C3 (alternative b).
- Conversation history, transcript, session summary.

**Process-wise:**

- Periodic regeneration. The triggers are event-driven (D4).
- A human opening, approving, curating, or filling in memory. Nothing blocks waiting for this.
- Running `mdpe-learnings` to produce memory before the first micro-task closes.
- Reading memory when it doesn't exist — the read degrades to "nothing to read," without failing.
- Resolving `staleness[]`, `open_questions[]`, or promoting a candidate lesson for memory to be valid:
  reporting is enough (D9).
- Graduating a lesson within a set deadline. Graduation is an opportunity, not an SLA.

**General rule:** the absence of an item on this list never invalidates memory. What invalidates it is
a line with no source artifact, a decision or convention **authored** in the index, a `candidate`
lesson being read as advice, a lesson used as evidence or as a gate, a snapshot overriding the code, a
lesson score, a generic principles block, hand-edited memory, a file created with no memory to index,
and any instruction pointing to a tool or service that doesn't exist.

---

## 6. Consequences

**Positive**

- Axis 6 goes from 1 to 3 with this ADR and leaves level 4 fully contracted for 7.2. It closes Gap
  6.1 through the read contract (D3) and Gap 6.2 through the C2 layer template (D5).
- **Two of the three layers already exist**, so Phase 7 is mostly **reading**, not instrumentation —
  the same finding that made Phase 6 cheap. The real cost is one new template and one read step per
  skill.
- **Returns two named pending items** that earlier phases had to leave open: the ADR-004 block E and
  the ADR-005 `learning` node stop being conditional for lack of an artifact.
- **Closes the three explicit delegations** ADR-001 (D7) and ADR-002 (D5, alternative f) made to this
  ADR. None of them is left unanswered, and none is answered by duplicating the delegator's artifact.
- Eliminates the last place in the framework that requires filling in technical context **from
  memory** (`code_conventions`, D6) — in a framework whose five skills repeat *"by reference, not from
  memory"*.
- Creates the MDPE's first **resumption** contract (D7), with the
  code > artifact > index precedence written as a rule, not a recommendation.
- Curation through **graduation** (D5) resolves unbounded growth structurally: the lesson that matters
  most is the one that leaves memory and becomes a verifiable rule.
- No new required field in any existing template. One conditional addition, and it **removes** filling
  work instead of adding it.

**Negative / costs**

- **One more derived artifact to keep fresh.** The index ages silently like the graph;
  `generated_at` + `branch@commit` make the aging visible, not impossible. A stale index is worse than
  none, because it looks true — mitigated by D7 step 2 (regenerate before use), which is discipline,
  not a mechanism.
- **The read step touches up to six skills in 7.2.** It's the most widespread change in v1 so far, and
  every touch is an opportunity for inconsistency across skills. 9.2 has to check this.
- **`docs/memory/` is one more top-level directory**, adding to `docs/architecture/`,
  `docs/brownfield/`, `docs/backlog/`, `docs/tracking/`, `docs/learning-loops/`, `docs/transformation/`,
  `docs/graph/`, and `docs/adr/`. And there's the oddity of layer C2 staying in
  `docs/learning-loops/` while the index lives in `docs/memory/` — deliberate, because moving
  `aggregated-learnings.yml` would break the path already declared in `mdpe-learnings/SKILL.md`, in
  `mdpe-tracking.yml` (`sources.aggregated_learnings`), and in two `mdpe-graph` templates. An explicit
  consolidation candidate for 9.1.
- **Lesson promotion is a rule, but lesson wording is not.** `statement` is free text written by the
  agent; two occurrences of the same problem can produce two lessons with different wording and never
  reach the two-occurrence threshold. `signature` mitigates this (normalizing by the
  `root_cause_diagnosis` symptom), it doesn't eliminate it.
- **Graduation depends on someone wanting to graduate it.** With no SLA (§5) and no gate (D9), a
  confirmed lesson can sit in the index for years. The size sensor (D2) exposes this; it doesn't force
  it.
- **`retired` accumulates in the file.** The index stays short, the file doesn't. Accepted: history in
  YAML is cheap, and deleting would destroy the evidence that the hypothesis was already considered.
- **One field addition** (D6), even though conditional and reducing, still needs to be classified in
  the 8.1 audit.
- **Nothing guarantees the agent actually reads it.** The contract is in the skill, and a skill is
  text. This ADR creates no enforcement — and the benchmark is honest about this: TLC and OSpec use
  scripts/hooks for what here is discipline. The refusal of tooling (D10) is deliberate and has a
  price.

**Neutral**

- No new skills. `mdpe-learnings` gains a layer to write to; the others gain a read step.
- `decisions.yml`, `inventory.md`, and `mdpe-tracking.yml` have not a single field changed. Their
  owners and triggers remain.
- Gates stay exactly where they were (D9); memory informs and routes.
- Anyone who doesn't want memory simply has no index: each skill keeps reading what it already read.
- The graph remains the preferred retrieval mechanism when it exists (D8); the index is the floor, not
  a replacement.

---

## 7. Verification against task 7.1's test scenarios

| Scenario | Where it is addressed |
|---|---|
| + The ADR defines memory layers, format, location, and read/write triggers | D1 (three layers, with owner and situation for each) · D2 (index format, block by block, with source per block; location `docs/memory/project-memory.yml`) · D3 (per-skill read triggers) · D4 (per-layer write triggers) · D5 (lesson format in C2) |
| + Describes how discovery/architecture/coding consult memory before deciding | D3 — table covering the eleven skills: `mdpe-backlog-discovery` reads `calibration[]` with `target: discovery` before opening a session; `mdpe-architecture` reads `pitfalls[]`/`open_questions[]`/`conventions[]` in Phase 0 alongside `decisions.yml`; `mdpe-coding` reads confirmed `pitfalls[]` **before Phase 1**, with an explicit prohibition on entering the command chain; `mdpe-router` reads the whole index before routing (D7 steps 1-4) |
| + Avoids duplicating what already exists (aggregated-learnings, tracking) — integrates, does not recreate | D1 (C1 and C3 **exist** and have not a single field changed; C2 is the already-promised path, just missing a template) · D1 rule 1 (memory copies nothing from C1 or C3) · D2 (the index is a pointer, with a single admitted copy, one line, regenerable) · alternative (b) rejected precisely for duplicating · alternative (c) rejected for not solving reading · D12 (refusal of authoritative copying) |
| − Write-only memory (no one reads it) fails | D3 is the read contract, with "when" and "what" per skill; D7 is the resumption contract; Section 3 makes the existence of ≥1 executable read step a **validity condition** — write-only memory fails by definition |
| − A proposal requiring external infrastructure for the minimum viable solution fails | D10 (no vector database, embeddings, memory MCP, service, or script; the minimum viable solution is versioned YAML/Markdown) · D11 (Kiro steering is an optional export, never a mechanism) · alternative (e) rejected with the reason written down · Section 3 (no instruction points to a nonexistent tool) |
| Requested layers: (1) project memory (decisions/conventions), (2) aggregated learnings, (3) execution | D1 maps them one to one: C1 = `decisions.yml` + `inventory.md` §3/§7 · C2 = `aggregated-learnings.yml` · C3 = `mdpe-tracking.yml` |
| Curation/consolidation (Axis 6 level 5; 7.2's negative scenario) | D5 — `candidate` → `confirmed` → `retired`, promotion by ≥2 occurrences with named evidence or 1 occurrence of weight, **graduation** to `decisions.yml`/convention/skill, retirement with a reason, and a clean outcome that logs nothing |

---

## 8. Sources

**Internal (read for this ADR):** `skills/mdpe-learnings/SKILL.md` (four learning types —
*technical, process, strategic, problems*; three feedback targets with action, owner, and horizon; three
promised outputs, two of which have no template; *"Do not write from memory of the session"*;
six tracking write rules) ·
`skills/mdpe-learnings/assets/templates/mdpe-tracking.yml` (`sources.aggregated_learnings` and
`sources.learnings` marked `[C] block E`; block E annotated as conditional *"that artifact has no
template yet (Phase 7)"*; `aggregates.project.propagation.recurring_signatures` with `signature` +
`occurrences[]` and the note *"raw material for a confirmed lesson (Phase 7)"*; `signals` with three
routes; `reconciliation.pending[]`) · `skills/mdpe-router/SKILL.md` (routing table, return loops,
skill directory — no state-reading step) · `skills/mdpe-backlog-discovery/SKILL.md`
(`## Inputs`: *"optional prior inputs: research, interviews, user data"*) ·
`skills/mdpe-backlog/SKILL.md` (`## Inputs`: only `docs/discovery/01..05-*.yml` + metadata) ·
`skills/mdpe-code-discovery/SKILL.md` (header `verified_at` + `branch @ commit`; §3 observed
conventions as an essential section with ≥1 evidence gate; §7 concerns/debt conditional; rule
5 *"code beats documentation, and current evidence beats an old inventory"*; *Staleness* paragraph
with partial re-inventory) ·
`skills/mdpe-code-discovery/assets/templates/brownfield-inventory-template.md` (§3 columns
`Convention` · `Observed rule` · `Evidence`; §7 columns `Concern` · `Evidence` · `Note`, no id, no
severity, no date) · `skills/mdpe-architecture/SKILL.md` (Phase 0 reads `decisions.yml` and the
inventory; `implications[].type: conventions`; Phase 5 and the paragraph delegating *"durable project
memory for principles and conventions … MDPE Phase 7"*; reentrancy via `revise`) ·
`skills/mdpe-architecture/assets/templates/architecture-decisions-template.yml` (`principles:` block
with the same delegation written above the key) ·
`skills/mdpe-execution-context/SKILL.md` (`## Inputs`: *"aggregated learnings from prior tasks"* with
no path; dimension 6 *"prior learnings applicable to this task"*; outputs at
`docs/execution/{microtask-id}-context.yml` and `-setup.yml`) ·
`skills/mdpe-execution-context/assets/templates/execution-context-template.yml`
(`architecture.*_source: ad-NNN` across six fields, `decisions_ref`, `applies[]`,
`no_decision_in_scope`; `code_conventions` block with `database_naming`/`csharp_naming` and **no
source field**; `project_patterns` likewise) · `skills/mdpe-coding/SKILL.md` (the six-source command
chain in Phase 0, with no learnings; dimension 2 severity; recording the absence of an `ad-NNN` as
a driver of `mdpe-architecture`) · `skills/mdpe-transformation/SKILL.md` (*"Technical context — by
reference, not from memory"*; `derived_work` as a micro-task candidate) · `skills/mdpe-tasks/SKILL.md`
(*"take it by reference instead of from memory"*; header with conditional `ad-NNN`) ·
`skills/mdpe-graph/SKILL.md` and `assets/templates/traceability-graph-template.md` (conditional
`learning` node, *"no template exists yet"*; pending execution path item) ·
`skills/mdpe-graph/assets/references/graph-queries.md` (Q3 with `ad-NNN` seed; neighborhood reading as
a mechanism, memory format left to this phase) ·
`docs/adr/adr-001-brownfield-discovery.md` (D7: `verified_at`, current evidence beats the inventory,
partial re-inventory, *"the formal connection to project memory is left for Phase 7 (ADR-006)"*) ·
`docs/adr/adr-002-architecture-skill.md` (D5 and alternative (f): durable principles and conventions
are in scope of ADR-006; phase table row: *"`decisions.yml` is the decision-log layer that ADR-006
will formalize"*; D6 blocking driver; D8 typed implications) ·
`docs/adr/adr-003-loop-engineering.md` (evidence contract; `root_cause_diagnosis.symptom` and
routes; status vocabulary) · `docs/adr/adr-004-execution-metrics.md` (D1 derived projection;
D5 numeric integrity; D6 event-driven writes; D7 pointer instead of copy; D8 metric is not a
gate; D12 tooling as a checker; conditional block E and E2 as lesson raw material) ·
`docs/adr/adr-005-traceability-graph.md` (D1 provenance as a condition of existence; D9 regeneration and
drift audit; D12 graph is not a gate; D15 graph as Phase 7's retrieval index) ·
`docs/analysis/baseline-gap-map.md` (Gaps 6.1 and 6.2, with observable criteria) ·
`docs/analysis/evaluation-rubric.md` (Axis 6: anchors 0-5, baseline 1, target 4) ·
`docs/analysis/competitive-analysis.md` (5.5, 5.6, 5.7, 4.6, 2.4, 2.5; adoptions A4, A5, A6, A12, A13;
Section 6 with the MDPE marked ○ on decision log, handoff, archiving, and principles) ·
`docs/analysis/impact-analysis-example.md` (adjacency retrieval as a mechanism) ·
`README.md` and `INSTALL.md` (the only mentions of `.kiro`, both about the skill installation
location).

**External:** TLC Spec-Driven —
[SKILL.md v3.3.0](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md)
(project memory with a decision log and a handoff snapshot reconciled against real state, where
evidence beats a stale snapshot; a lesson layer where only confirmed ones are loaded during decision
phases and a clean outcome logs nothing; a context budget with on-demand loading) · OSpec —
[clawplays/ospec](https://github.com/clawplays/ospec) (a session briefing with active changes, queue
state, and the next safe step, read before touching anything) ·
OpenSpec — [docs/overview.md](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md)
(archiving that merges the delta into the main spec and dates the completed change, so the spec comes to
describe the new reality; *enablers, not gates*) · Spec-Kit —
[github/spec-kit](https://github.com/github/spec-kit) (a project constitution as principles established
once — adopted only partially, see D12).

> Content paraphrased from the sources for licensing compliance; URLs reused from
> `competitive-analysis.md`, verified on 28/08/2026.
