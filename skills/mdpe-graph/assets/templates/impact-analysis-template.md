<!--
====================================================================
MDPE Framework - Impact Analysis (recorded Q3 answer) - Template
====================================================================
Version: 1.0.0
Skill: mdpe-graph
Decision of record: docs/adr/adr-005-traceability-graph.md (D5, D7 case 3)

Save to:
  docs/graph/impact-{node-id}.md      # e.g. impact-ad-002.md, impact-mt-001-003.md

--------------------------------------------------------------------
WHEN THIS FILE EXISTS AT ALL
  A Q3 answer in the conversation is the DEFAULT and it is enough.
  Write this file only when someone wants the record - typically
  before revising a decision, dropping a micro-task, or negotiating
  scope, where the answer will be reopened later.
  NEVER create it empty, and never create it "for completeness".

--------------------------------------------------------------------
OBLIGATION LEGEND (per block)
  [E] essential    - the answer is invalid without it
  [C] conditional  - required only in the stated situation
  [O] optional     - include only if it carries real content
Delete every block that does not apply. A deleted block is correct;
a block filled by deduction is a fabricated answer.

--------------------------------------------------------------------
HARD RULES (the template exists to enforce these)
  1. CITE OR STAY QUIET. Every reached node carries the CHAIN of
     declared edges from the seed, each edge with its source ARTIFACT
     and FIELD. A node with no chain is rejected - that is the
     negative test of this capability, not a style preference.
  2. `impacts` IS COMPUTED. It is the transitive closure of
     depends-on(hard) U implements^-1 U produces U derives-from^-1.
     No artifact declares it. Say so, once, in section 5.
  3. SOFT AND EXTERNAL ARE NEVER DROPPED. Soft changes the ORDER of
     the plan; an external with status != available is the most common
     real blocker. A hard-only answer is wrong even when its hard part
     is right.
  4. NO REACH BY INFERENCE. Similarity, plausibility and "it probably
     touches that too" are not edges. Not in the edge table of the
     projection -> not in this answer.
  5. READ, NEVER RECOMPUTE. Waves, critical path and parallelizable
     groups are quoted from their files. Your own calculation is a
     second source, not an answer.
  6. STATE THE PROJECTION YOU READ, and its staleness if any. A stale
     answer looks exactly like a current one.
  7. BOUNDED, AND SAY SO. What was checked and NOT reached is a
     result. Silence about it is not.
  8. ROUTES, NOT DECISIONS. Nothing here approves, blocks, releases,
     reorders a wave or launches work. Every route already exists in
     the signal and orphan catalogue of the skill.
  9. NO MANDATORY TOOLING. The traversal is done by reading the edge
     table. No line here may point at a script, workflow, CLI or
     dashboard.
 10. THIS FILE IS A SNAPSHOT, NOT A SOURCE. It is dated against one
     projection. When the graph is regenerated, the answer is redone -
     never patched.

--------------------------------------------------------------------
TRAVERSAL (fix it once, keep it everywhere)

  PROPAGATING - re-expanded from every node reached:
    depends-on hard   predecessor -> dependent        class: blocks
    implements^-1     ad -> mt that implements it     class: decision in scope
    derives-from^-1   origin -> what derives from it  class: scope expansion
    produces          mt -> artifact                  class: files in scope
                      (an artifact has no outgoing declared edge, so
                       the branch ends there)

  TERMINAL - swept ONCE over the propagating set, never re-expanded:
    depends-on soft   predecessor -> dependent        class: reorders
    depends-on ext    mt <-> ext:*                    class: blocks if status
                                                             != available,
                                                             else watch
    implements (fwd)  reached mt -> the ad it implements  class: decision to honour
    validates^-1      mt|artifact|ad -> its evidence  class: evidence to redo
    supersedes        ad -> ad (feature granularity)  class: decision under revision
    affects           NOT traversed - reported as a note in section 4

  `implements` runs BOTH ways and they are different questions:
  backwards from an ad seed it PROPAGATES (revising the decision
  reaches every micro-task it governs); forwards from a changed
  micro-task it is TERMINAL (the decision is not impacted, the code
  still has to satisfy it - the review dimension checks that).

  Soft gets exactly ONE hop because it changes order, not content:
  propagating it transitively makes everything impact everything,
  which says nothing; dropping it hides the reordering the plan
  actually suffers.

  Carry a VISITED SET: a soft cycle or a cross-feature cycle must not
  loop the walk. Record `hops` per reached node. Stop when no new node
  appears. A node that entered through a TERMINAL relation is not
  swept in turn - it contributes no artifacts, no evidence and no
  dependents of its own.

  A NODE REACHED TWICE keeps the worse news: most severe class,
  shortest chain, other relation noted.
    blocks > decision in scope > decision under revision >
    files in scope > evidence to redo > reorders > watch

Remove this whole instruction block when done.
====================================================================
-->

# Impact analysis — {seed node id}

<!-- [E] Identify the question and the projection it was answered from. Without the
projection anchor this file cannot be told apart from a stale one. -->

- **seed given:** `{id or path as asked}`
- **normalized to:** `{node the traversal started from}` — {why, one line}
- **kind of change:** {content | revise | remove}
- **question:** {the question in the words it was asked}
- **answered at:** {YYYY-MM-DD HH:MM} · **by:** {agent or person}
- **projection read:** `docs/graph/traceability-graph.md` · generated_at {YYYY-MM-DD HH:MM} · {branch} @ {short commit}
- **staleness:** none <!-- [C] If the projection is behind the repository, say it HERE
  and say what that leaves uncertain. Regenerating first is cheaper than qualifying. -->

<!-- Seed normalization, for reference - state which row applied:
  artifact path            -> the mt that `produces` it (keep the artifact in the answer)
  feat-XXX | cf-NNN | session -> itself, expanded first through derives-from^-1
  ad-NNN                   -> itself, expanded first through implements^-1 and supersedes
  {mt}:validation|review|learnings -> the mt it verified or came from
-->

---

## 1. Answer in one line

<!-- [E] The reader who stops here must still get the actionable part: how many nodes,
the worst class, and the one thing that has to happen. No hedging, no restating the
question. -->

{N} nodes reached, {M} of them `blocks`; {the single most consequential consequence}.

---

## 2. Affected nodes

<!-- [E] THE ANSWER, and its proof in the same row.

`chain` is the sequence of DECLARED edges from the seed, each with the artifact and
field that declares it. One row, one chain. A row with no chain is a fabricated reach -
delete it or find the edge.

`status` comes from docs/tracking/mdpe-tracking.yml (reconciled), and it is what makes
the row actionable: `completed` means evidence to redo, `pending` means only the plan
moves, `in_progress` means someone is building on a moving base right now.

Order rows by class severity, then by hops. Do not sort by id - severity is the reason
someone opened this file. -->

| node | type | class | hops | chain (declared edges, with source) | status | route |
|---|---|---|---|---|---|---|
| `{mt-XXX-YYY}` | microtask | blocks | 1 | `{seed}` --depends-on hard--> `{mt-XXX-YYY}` · `dependencies/hard-dependencies.yml` → `dependencies[].source/.target` | in_progress | interrupt the executor |
| `{mt-XXX-ZZZ}` | microtask | blocks | 2 | `{seed}` --hard--> `{mt-XXX-YYY}` --hard--> `{mt-XXX-ZZZ}` · same file, both hops | pending | re-plan |
| `{path/to/File.ext}` | artifact | files in scope | 2 | `{seed}` --hard--> `{mt-XXX-YYY}` --produces--> `{path}` · `microtasks/mt-XXX-YYY.yml` → `output.generated_artifacts[].location` | exists: true | `mdpe-coding` |
| `{mt-XXX-AAA}` | microtask | reorders | 1 | `{seed}` --depends-on soft--> `{mt-XXX-AAA}` · `dependencies/soft-dependencies.yml` → `dependencies[].source/.target`, reason quoted there | pending | dispatch note only |
| `ext:{resource-slug}` | external | watch | 1 | `{mt-XXX-YYY}` --depends-on external--> `ext:{slug}` · `dependencies/external-dependencies.yml` → `dependencies[].microtask/.resource`, status available | — | monitor |
| `{mt-XXX-YYY}:validation` | evidence | evidence to redo | 2 | `{mt-XXX-YYY}:validation` --validates--> `{mt-XXX-YYY}` · `execution/mt-XXX-YYY-validation.yml` → `summary.overall_status` | approved → invalidated | `mdpe-coding`, then `mdpe-learnings` |
| `ad-NNN` | decision | decision in scope | 1 | `{seed}` --implements--> `ad-NNN` · `execution/{id}-context.yml` → `technical_context.architecture.applies[].id` | accepted | `mdpe-architecture` |

**Classes and routes** — the full catalogue, so nothing here is improvised:

| class | reached through | route |
|---|---|---|
| `blocks` | `depends-on` hard, or an external whose status is not `available` | hold the dependent; re-plan in `mdpe-transformation` if the order changes |
| `reorders` | `depends-on` soft, one hop | no route — a note in the dispatch answer |
| `decision in scope` | `implements`⁻¹ from an `ad` seed — the decision is being revised | `mdpe-architecture` — the `needs_architecture` route |
| `decision to honour` | `implements` forward from a changed `mt` — the decision stands, the change must still satisfy it | `mdpe-coding` — the architecture dimension of the review |
| `decision under revision` | `supersedes` / `superseded_by` | `mdpe-architecture` |
| `files in scope` | `produces` | `mdpe-coding` |
| `evidence to redo` | `validates`, over a reached node | `mdpe-coding` to re-validate, `mdpe-learnings` to reconcile status |
| `scope expansion` | `derives-from`⁻¹ from a feature, `cf-NNN` or session | `mdpe-backlog` or `mdpe-transformation`, depending on where the scope moves |
| `watch` | external with status `available` | monitor — no action |

---

## 3. Plan consequences  [C]

<!-- [C] Only when the reach touches the execution plan. QUOTED from the files, never
recalculated (hard rule 5). Delete the block when no reached node is on the critical
path and no wave changes. -->

- **critical path touched:** {yes / no} — `dependencies/critical-path.yml` → `sequence[]`
  {name the reached nodes that are in the sequence}
- **declared total_time:** {X hours} — `critical-path.yml` → `metadata.total_time`
  <!-- Do NOT compute a new total. Re-estimating is mdpe-transformation's job; saying
  the critical path is touched is this file's job. -->
- **waves affected:** {wave_N, wave_M} — `dependencies/waves.yml` → `waves.{key}.microtasks[]`
- **parallelism now:** {K} of {declared} in `dependencies/parallelizable.yml`
  (group `{group_N_wave_X}`) — reduced by `{node}`, {reason: open hard dependency,
  unavailable external, or blocked micro-task}

---

## 4. Notes  [C]

<!-- [C] Context that is declared over a reached node but is not part of the reach.
Delete when empty. -->

- **`affects` over reached nodes** — risks and hypotheses already declared, not traversed:
  `{risk-tech-NNN}` → `{feat-XXX}` · `05-validation-risks.yml` → `risks[].affected_features[].id`
- **path pendency touched** — {file}: declared at `docs/transformation/{feature-id}/execution/`,
  found at `docs/execution/`. Recorded, never repointed silently.
- **divergence seen** — {what disagreed between two sources, and which one won:
  review > validation > context > contract}

---

## 5. Bounds of this answer

<!-- [E] Both halves are essential. The first is the anti-fabrication label; the second
is what tells a reader the analysis was bounded rather than lazy. -->

**The reach is computed.** It is the `impacts` closure of ADR-005 D5 —
`depends-on(hard)` ∪ `implements`⁻¹ ∪ `produces` ∪ `derives-from`⁻¹, with soft, external,
`validates` and `supersedes` touched once over the reached set. **No artifact declares an
`impacts` edge**, and none appears in the projection's edge table. Every row of section 2
is justified by declared edges only.

**Checked and not reached:**

| not reached | why |
|---|---|
| `{feat-YYY}` and its micro-tasks | no declared edge path from the seed; the two features share no dependency, no decision and no artifact |
| `{mt-XXX-BBB}` | its only relation to the reach is `depends-on` soft in the **opposite** direction (it feeds a reached node, it does not follow it) |

**Absent sources** — absence is a result, not a hole:
{e.g. no `{id}-learnings.yml` exists yet, so no `learning` node could be reached}

---

## 6. Regeneration

<!-- [E] Short, and honest about what this file is. -->

- **This is a snapshot against one projection**, not a source. When
  `docs/graph/traceability-graph.md` is regenerated, this answer is **redone**, never
  patched — the reach may have changed with the edges.
- **Nothing here decides.** Every line routes. The gates stay in `mdpe-coding`
  (evidence per dimension, loop limit), `mdpe-architecture` (blocking drivers) and
  `mdpe-transformation` (the 7 criteria, graph acyclicity).
- **Skill:** `skills/mdpe-graph/SKILL.md` · **decision of record:**
  `docs/adr/adr-005-traceability-graph.md`

<!--
====================================================================
SELF-CHECK before saving
====================================================================
  - Does EVERY row in section 2 carry a chain of declared edges, each with artifact
    and field? (A row without one is fabricated - remove it or find the edge.)
  - Are soft and external dependencies present wherever the artifacts declare them
    over a reached node? (Hard-only answer = rejected.)
  - Is `impacts` labelled COMPUTED in section 5, and absent from the projection's
    edge table?
  - Was any node reached by inference or plausibility rather than a declared edge?
  - Do reached micro-tasks carry reconciled status, so `completed` (evidence to redo)
    is distinguishable from `pending` (plan only)?
  - Is every route one the catalogue already defines - none invented?
  - Are waves, critical path and parallelizable groups QUOTED, with no new total
    computed here?
  - Is the projection identified by generated_at and commit, with staleness stated?
  - Is "checked and not reached" filled in?
  - Does anything in this file approve, block, release, reorder a wave or launch work?
    Remove it - this file routes.
  - Does any line point at a script, workflow, CLI or dashboard? Remove it.
  - Was this file created without anyone asking for the record? Delete it and answer
    in the conversation.
====================================================================
-->
