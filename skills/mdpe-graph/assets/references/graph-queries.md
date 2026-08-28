# Graph queries — full procedure

> **Skill:** `skills/mdpe-graph/SKILL.md` (section **Queries**)
> **Decision of record:** `docs/adr/adr-005-traceability-graph.md` — D5 (edge catalogue and the
> `impacts` closure), D7 (the five use cases), D10 (dispatch), D14 (derived readings).
> **Worked example, with two rejected answers:** `docs/analysis/impact-analysis-example.md`.

Read this when running a query. The skill carries the six queries, the protocol and the gate;
this file carries the traversal, because only Q3 is computed per question and only Q3 needs a
procedure. Q1, Q2, Q4, Q5 and Q6 read a section of the projection that generation already wrote.

---

## Q3 — Downstream impact, step by step

**Input.** A seed node id plus the kind of change: `content` (its implementation changes),
`revise` (a decision reopened), `remove` (dropped from scope). The kind changes the classes and
the routes, never the traversal.

### 1. Normalize the seed

Do this first and state it, because the seed people name is often not the node with the edges:

| Seed given | Normalize to | Why |
|---|---|---|
| an artifact path | the `mt` that `produces` it, keeping the artifact in the answer | a file declares no outgoing edge; its producer does |
| `feat-XXX` / `cf-NNN` / a session | itself, expanded first through `derives-from`⁻¹ | reach is scope expansion, not execution order |
| `ad-NNN` | itself, expanded first through `implements`⁻¹ and `supersedes` | this is the "what does revising this decision pull in" question |
| `{mt}:validation` / `{mt}:review` / `{mt}:learnings` | the `mt` it verified or came from | evidence has no dependents of its own |

### 2. Propagating versus terminal relations

`impacts` is the transitive closure of `depends-on(hard)` ∪ `implements`⁻¹ ∪ `produces` ∪
`derives-from`⁻¹ (ADR-005 D5), while the answer must also report soft, external and evidence
(D7 case 3). The two are reconciled by expanding the first set and sweeping the second **once**:

| Relation | Traversed from a reached node | Re-expanded | Class assigned |
|---|---|:---:|---|
| `depends-on` hard | predecessor → dependent | **yes** | `blocks` |
| `implements`⁻¹ | `ad` → every `mt` that implements it | **yes** | `decision in scope` |
| `derives-from`⁻¹ | origin → everything that derives from it | **yes** | `scope expansion` |
| `produces` | `mt` → artifact | yes, and the branch ends there | `files in scope` |
| `depends-on` soft | predecessor → dependent | **no — one hop** | `reorders` |
| `depends-on` external | `mt` ↔ `ext:*` | **no — one hop** | `blocks` when status is not `available`, else `watch` |
| `implements` forward | reached `mt` → the `ad` it implements | **no — one hop** | `decision to honour` |
| `validates`⁻¹ | reached `mt` / artifact / `ad` → the evidence that verified it | **no — one hop** | `evidence to redo` |
| `supersedes` | `ad` → `ad`, at feature granularity | **no — one hop** | `decision under revision` |
| `affects` | not traversed | no | reported as a note: the risk or hypothesis already declared over a reached node |

`implements` runs in **both** directions and they are not the same question. Backwards from an
`ad` seed it propagates — revising a decision reaches every micro-task governed by it. Forwards
from a changed micro-task it is terminal: the decision is not impacted by the code, the code
still has to satisfy it, which the review dimension checks. Two directions, two classes, two
routes.

Why soft gets exactly one hop: it changes **order**, not content, so the dependent's own
dependents are not reached. Propagating it transitively makes everything impact everything,
which says nothing; dropping it hides the reordering the plan actually suffers. One hop,
labelled `reorders`, is the honest middle — and protocol rule 4 makes it mandatory.

**A node reached twice keeps the worse news.** When two relations reach the same node, assign the
most severe class and the shortest chain, and note the other relation:

`blocks` > `decision in scope` > `decision under revision` > `files in scope` >
`evidence to redo` > `reorders` > `watch`

### 3. Walk

Breadth-first over the propagating relations from the normalized seed, carrying a visited set — a
`soft` cycle or a cross-feature cycle must not loop the walk. Record `hops` per reached node.
When no new node appears, sweep the **propagating set** once through the terminal relations; a
node that entered through a terminal relation is **not** swept in turn, so it contributes no
artifacts, no evidence and no dependents of its own.

`impacts` never enters the graph file or its edge table. It exists only inside the answer,
labelled computed.

### 4. Cross with status

Status is what makes the answer actionable. Take the reconciled status from
`docs/tracking/mdpe-tracking.yml`:

| Reached `mt` status | Meaning for the change | Urgency |
|---|---|---|
| `in_progress` | work happening right now on a moving base | interrupt and tell the executor |
| `completed` | done against the old base — its `evidence` is no longer valid | re-validate (`mdpe-coding`), reconcile (`mdpe-learnings`) |
| `pending` / `blocked` | only the plan is affected | re-plan, nothing to redo |

### 5. Shape the answer

| Block | Obligation | Content |
|---|:---:|---|
| seed and kind | essential | the id given, what it normalized to, and `content` / `revise` / `remove` |
| graph read | essential | the `generated_at` and commit of the projection used |
| affected nodes | essential | one row per node: `node` · `type` · `class` · `hops` · `chain` (the declared edges, each with artifact + field) · `status` · `route` |
| not reached | conditional | what was checked and does not enter scope |
| notes | conditional | `affects` rows over reached nodes, path pendencies touched, divergences seen |
| computed label | essential | one line stating the reach is `impacts`, computed as the closure above, not a declared edge |

### 6. Classes and routes

The full catalogue, so no route is improvised:

| class | reached through | route |
|---|---|---|
| `blocks` | `depends-on` hard, or an external whose status is not `available` | hold the dependent; re-plan in `mdpe-transformation` if the order changes |
| `reorders` | `depends-on` soft, one hop | no route — a note in the dispatch answer |
| `decision in scope` | `implements`⁻¹ from an `ad` seed — the decision is being revised | `mdpe-architecture`, the `needs_architecture` route |
| `decision to honour` | `implements` forward from a changed `mt` — the decision stands | `mdpe-coding`, the architecture dimension of the review |
| `decision under revision` | `supersedes` / `superseded_by` | `mdpe-architecture` |
| `files in scope` | `produces` | `mdpe-coding` |
| `evidence to redo` | `validates`, over a reached node | `mdpe-coding` to re-validate, `mdpe-learnings` to reconcile |
| `scope expansion` | `derives-from`⁻¹ from a feature, `cf-NNN` or session | `mdpe-backlog` or `mdpe-transformation`, depending on where the scope moves |
| `watch` | external with status `available` | monitor — no action |

### 7. Rejection list

A Q3 answer is rejected when any of these holds — failure modes, not style preferences:

- a reached node arrives with **no chain** of declared edges from the seed;
- `soft` or `external` dependencies were left out of the answer;
- `impacts` is presented as if some artifact declared it;
- a node is reached "by reasonable inference" instead of by a declared edge path;
- a route is invented that no orphan or signal table defines;
- the projection was stale and the answer did not say so.

**Recording.** The conversation is the default. Write `docs/graph/impact-{node-id}.md` from
`assets/templates/impact-analysis-template.md` only when someone wants the record — typically
before revising a decision or dropping a micro-task, where the answer will be reopened. Never
create an empty query file.

---

## Q4, Q5 — the standing signals

Procedure and catalogue are in the skill, Phase 5. Do not restate them in an answer, cite them.
Two things worth keeping in view:

- **The cross-feature cycle only exists here.** Acyclicity inside one feature is already a
  `mdpe-transformation` gate, and it keeps being right: each feature's
  `graph_validation.cycles_detected` can be empty and correct while a closed path crosses the two.
  Nothing checked that before the unified projection.
- **Orphans are answered by type, never as a count in prose.** The count is a derived reading;
  the actionable answer is the type plus its route.

## Q6 — parallelism, and the coherence rule

Phase 6 computes it. One rule governs the answer: the dispatchable set must be a **subset of a
declared group** in `parallelizable.yml`, inside the lowest open wave. If a larger or different
set looks parallelizable to you, that is a **divergence report** to `mdpe-transformation`, not a
dispatch — assembling your own group would make this skill a second source of order. And when
the set is smaller than the declared group, name the node that reduced it: an open hard
dependency, an unavailable external resource, or a `blocked` micro-task with its route.

## Derived readings for `mdpe-learnings`

The queries are where ADR-004's reserved block G comes from. Each is a **reading**, taken when
asked; this skill keeps no series and carries no target — a sensor with a target attached ends up
measuring the target (ADR-004 D8).

| Reading | Query | Value from |
|---|---|---|
| `orphans_count` | Q4 | §7 orphan table, counted **by type** |
| `critical_path_length` | Q2 | `critical-path.yml` → `metadata.total_time` and the length of `sequence[]` |
| `parallelism_available` | Q6 | dispatchable set, with the reason for the reduction |
| `cycles_detected` | Q5 | §7 cycle table, including cross-feature |
| `drift_count` | generation Phase 5 | §7 drift table |

## Retrieval by adjacency

Q3 with an `ad-NNN` seed answers *"what does revising this decision pull into scope"* — the
impact of a **recorded decision**, which is what a memory layer needs to be worth reading. More
generally, the adjacency of the node being worked on (`derives-from`, `implements`,
`learned-from`) is the shortlist of decisions and lessons relevant to it, so a session can read
by neighbourhood instead of loading every artifact. The memory format is decided elsewhere; this
skill supplies the index and presumes nothing about it.
