# ADR-009 — Stakeholder communication (`mdpe-status-report`)

| Field | Value |
|---|---|
| **Status** | Accepted |
| **Date** | 29/08/2026 |
| **Source task** | `tasks-v1.md` → Phase 10 → 10.5 |
| **Rubric axis** | Axis 10 — Stakeholder communication (baseline **0**, target **4**) |
| **Implemented by** | Task 10.6 (skill + template) · routed in 10.9 · verified in 10.10 |
| **Associated adoptions** | None from `competitive-analysis.md`. External source: RAG format and status report "1-pager" (web research, see Section 8). |
| **Depends on** | ADR-004 (`mdpe-tracking.yml` — reconciled status) · ADR-005 (`mdpe-graph` — waves, critical path, dispatch, signals) · ADR-006 (`docs/memory/project-memory.yml` — decisions/conventions in force, staleness) |

---

## 1. Context

The framework already knows how to answer "where are we" — but only in a vocabulary that requires opening YAML or reading
Mermaid. Evidence:

- `skills/mdpe-router/SKILL.md` (Step 0) announces state by reading `docs/memory/project-memory.yml` and
  cites `ad-NNN`, `staleness[]`, `metadata.repo_state` — aimed at someone who already knows the framework's
  vocabulary.
- `skills/mdpe-graph/SKILL.md` (Phase 6 — Dispatch) answers "what runs now" by naming `mt-XXX-YYY`
  and citing the source artifact field — correct and traceable, but unreadable to someone who just wants to
  know if the project is on schedule.
- `skills/mdpe-learnings/SKILL.md` writes `mdpe-tracking.yml` with derived metrics (throughput,
  iterations to green, findings by severity) — real data, execution vocabulary.
- No framework artifact has a **beacon** reading (on track / at risk / blocked), nor a
  section that omits technical ids by default.

Practical consequence: a sponsor, client, or non-technical manager has no way to ask "how
is the project going" and get an answer in 30 seconds without someone translating the YAML for them. This is
Gap R.3.

External reference (research for this task, Section 8): the **RAG** format (Red-Amber-Green) is the de facto
standard for status beacons in project reports; the **"1-pager"** format — accomplished /
in-progress / risks-and-blockers / next, each section with a few bullets — is the most cited way to
compress status for decision-makers with no time to read a long report.

---

## 2. Decision

### D1 — New skill `mdpe-status-report`, observer-style like `mdpe-graph` — not a router step

Reasons:

1. **Audience opposite to that of router Step 0.** The router already reads memory and announces state — for the
   **agent to decide the next route**. This report exists for a **person outside the execution
   cycle** to decide something different (approve budget, remove a blocker, adjust a deadline). The same
   text cannot serve both readings without compromising one of them.
2. **On-demand cadence, never route-triggered.** The router reads memory on every interaction; this report is
   requested, typically weekly/biweekly or before a meeting — a communication cadence, not an
   execution one.
3. **Precedent already accepted.** Same structural decision as `mdpe-graph` (ADR-005 D2): observer,
   derived projection, never a mandatory step in another skill.

### D2 — Point in the cycle: cross-cutting projection, read on demand

```mermaid
graph TD
    TR[(docs/tracking/mdpe-tracking.yml)] -.-> SR[mdpe-status-report]
    GR[mdpe-graph] -.dispatch/signals.-> SR
    MEM[(docs/memory/project-memory.yml)] -.-> SR
    B[(docs/backlog/backlog-index.yml)] -.-> SR
    SR -->|"1-pager"| ST[(non-technical stakeholder)]
```

Runs **on demand**, never on an automatic trigger. It recomputes nothing: it reads `mdpe-tracking.yml`
(ADR-004), the dispatch/signal reading that `mdpe-graph` already produces (ADR-005 D10, Phase 5-6), and
`docs/memory/project-memory.yml` (ADR-006) — the same "read, never recompute" rule as the other
projections.

### D3 — Body structure: beacon + 4 sections, no technical jargon

Canonical format (Section 8 research, adapted to MDPE's actual sources):

| Block | Content | Source |
|---|---|---|
| **Beacon** | 🟢 on track / 🟡 at risk / 🔴 blocked, with **one sentence** stating the reason | derived from D4 |
| **Accomplished** | what has been delivered since the last report, in product language | features with micro-tasks `completed` since the date of the previous report (same source as `mdpe-release`, without duplicating its output — see D6) |
| **In progress** | what is currently underway, without micro-task detail | features with micro-tasks in `in_progress` state / open wave, named by feature, never by micro-task |
| **Risks & blockers** | what threatens the deadline or is stalled, along with what is needed from the report's reader | `mdpe-tracking.yml` overrun/blocker signals + `mdpe-graph` orphans/cycles relevant to the report's scope, **translated**, never cited by id in the body |
| **Next** | what comes next | `mdpe-graph` dispatch (D10/Phase 6) — what runs in the next wave, translated |

**Hard language rule:** no `mt-XXX-YYY`, `ad-NNN`, `feat-XXX`, or file name appears in the
main body. The body speaks in terms of features and capabilities; the ids live exclusively in the appendix
(D5).

### D4 — Beacon: derived from a real signal, never from opinion

The beacon is not a subjective note from the agent. Derivation rule, in order — the first matching
condition decides the color:

| Beacon | Condition (the first match decides) |
|---|---|
| 🔴 **Blocked** | ≥1 `blocked` micro-task with `root_cause_diagnosis` and no resolved route, **or** `mdpe-graph` reports an open cross-feature cycle within the report's scope |
| 🟡 **At risk** | ≥1 `external` dependency with `status: unavailable`/`in_development` on the critical path, **or** `mdpe-graph` shows available parallelism lower than declared with a named reason, **or** `mdpe-tracking.yml` shows ≥2 loop overruns in scope since the last report |
| 🟢 **On track** | none of the above conditions apply |

Each beacon carries, in the appendix, the exact citation of the signal that produced it — the same
"never a claim without the field that supports it" discipline from `mdpe-graph` (ADR-005 D1), applied here to the color.

### D5 — Provenance appendix: where the ids live

Final section, optional to read, mandatory to exist whenever the body makes any claim: a
table `body claim` → `artifact + field` → `technical id`. Whoever wants to verify reads the appendix;
whoever just wants to know the beacon reads the first line. Same spirit as the `mdpe-graph` edge table
(ADR-005 D3): "the diagram is the human reading; the table is the proof" — here, "the body is the
human reading; the appendix is the proof".

### D6 — Does not duplicate `mdpe-release`; reads what it has already projected when it exists

The **Accomplished** section has the same evidence source as `mdpe-release` (ADR-007 D3: the
`completed` + validated + existing-artifact triple). Precedence rule: if a `CHANGELOG.md` has already
been cut for the report period, **Accomplished cites its entries** instead of recalculating the list
— precedence "artifact closest to the external audience wins", analogous to the `implements`
precedence of `mdpe-graph` (ADR-005 D5 rule 2). Without a changelog in the period, the skill derives
directly from tracking, using the same evidence triple.

### D7 — The report is not a gate, and it does not decide anything

Same clause as `mdpe-graph` (ADR-005 D12) and `mdpe-learnings` (memory is not a gate): nothing here
approves budget, changes a deadline, or resolves a blocker. The report **reports and names what is needed**
("blocked, awaiting a decision on X") — the decision belongs to the reader, always outside the skill.

### D8 — No mandatory tooling; no automatic periodicity

Same contract as ADR-005 D11 and ADR-007 D8: no dashboard, no email/Slack integration,
no scheduling is required. The report is a Markdown file generated on request.

---

## 3. "Honest report" criteria

- [ ] The main body (beacon + 4 sections) cites no technical id (`mt-*`, `ad-*`, `feat-*`,
      file path).
- [ ] The beacon follows the D4 decision tree; the condition that produced it is cited in the appendix.
- [ ] Every claim in the body has a corresponding line in the appendix, with artifact + field.
- [ ] **Accomplished** cites the period's `CHANGELOG.md` when it exists (D6), instead of recalculating.
- [ ] No section states anything that `mdpe-tracking.yml`/`mdpe-graph`/memory does not support.
- [ ] Nothing in the report is presented as a decision, approval, or confirmed deadline — only reporting.

**Without tracking, without a graph, and without memory** → correct response: *"nothing to report; no
execution cycle has produced data yet"*, and no artifact is created.

---

## 4. Alternatives considered

### (a) Step within `mdpe-graph` — **rejected**

`mdpe-graph` already answers "what runs now" (D10) in technical vocabulary, correct for its audience
(whoever dispatches work). Overlaying a stakeholder translation on the same artifact would mix two
audiences in a file whose central rule is "every edge has citable provenance in the body" —
exactly what this report must avoid in its main body (D3).

### (b) New skill `mdpe-status-report` (D1-D8) — **chosen**

| Axis | Effect |
|---|---|
| **10 — Stakeholder communication** (0 → 4) | Dedicated skill, beacon derived from real signal, jargon-free body, provenance appendix — covers level 4 of the new axis. |
| **8 — Hallucination** | D4 is this ADR's application of the "every claim cites the field that supports it" principle, replicated from `mdpe-graph`, for a beacon color instead of an edge. |
| **7 — Cognitive cost** | The report exists to **reduce** the cognitive load of the reader — 1 page, no ids in the body. |
| Cost | +1 skill to wire in; risk of the report going stale between requests (mitigated by a generation timestamp, same practice as `mdpe-graph`). |

### (c) Generate the report from an external dashboard (BI, Grafana) — **rejected**

Would repeat Gap 4.1 (tooling referenced without existing in the repository) that ADR-004 already fixed.
It would fall outside version control and diff-based review.

---

## 5. What is **NOT** mandatory

- Fixed periodicity — on demand only.
- Dashboard, automatic email, Slack/Teams integration.
- Detailing micro-tasks in the body — the **In progress** section names features, never `mt-XXX-YYY`.
- Recalculating what `mdpe-release` has already published in the period — cites the `CHANGELOG.md` (D6).
- A beacon color other than 🟢 when no D4 condition applies — 🟢 with no extra qualification is a
  valid output.
- An appendix when the body is empty (nothing to report) — with no claim, there is nothing to prove.

**General rule:** absence of an item from this list never fails the gate. What fails it is a technical id in the
body, a beacon without the D4 condition that supports it, or a claim without a corresponding line in the appendix.

---

## 6. Consequences

**Positive**

- Axis 10 goes from 0 to 4. The framework now has a state reading that does not require knowing the
  internal vocabulary.
- Reuses three existing sources (tracking, graph, memory) without introducing new computation —
  the same "read, never recompute" discipline as `mdpe-graph`.

**Negative / costs**

- +1 skill to wire in.
- The report may go stale between requests; mitigated by a generation timestamp and by the "on
  demand only" rule (it does not pretend to be continuously updated).
- Translating a technical signal into a beacon (D4) is a fixed decision tree — it may oversimplify a
  genuinely ambiguous case; in that case, the skill names the ambiguity in the appendix instead of forcing a
  color.

**Neutral**

- Does not change any existing artifact (`mdpe-tracking.yml`, graph, memory remain exactly as
  they are).
- Does not participate in any learning loop.

---

## 7. Verification against task 10.5's test scenarios

| Scenario | Where it is addressed |
|---|---|
| + RAG/1-pager format with beacon and 4 sections | D3 |
| + Source per section, no new computation | D2, D4, D6 |
| + Every body claim traceable in the appendix | D5, Section 3 |
| − Never decides or approves anything | D7 |
| − No technical id in the main body | D3 hard rule, Section 3 |

---

## 8. Sources

**Internal:** `docs/adr/adr-004-execution-metrics.md` (tracking, reconciled status) ·
`docs/adr/adr-005-traceability-graph.md` (D1 provenance, D2 observer skill, D10 dispatch, D12 not
a gate) · `docs/adr/adr-006-memory-model.md` (memory index, staleness) ·
`skills/mdpe-router/SKILL.md` (Step 0 — technical vocabulary of the current state reading) ·
`docs/analysis/baseline-gap-map.md` (Gap R.3) · `docs/analysis/evaluation-rubric.md` (Axis 10).

**External:** the RAG format (Red-Amber-Green) for project status beacons and the "1-pager" format
(accomplished / in-progress / risks-and-blockers / next) for reports aimed at non-technical
stakeholders — general web research on agile status report templates, with no single verbatim-citable
source.

> Content paraphrased from multiple general sources for licensing compliance;
> web research conducted on 29/08/2026.

