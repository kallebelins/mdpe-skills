<!--
====================================================================
MDPE Framework - Architecture Decision Record (narrative) - Template
====================================================================
Version: 1.0.0
Purpose: Light narrative ADR for the mdpe-architecture skill.
Decision of record: docs/adr/adr-002-architecture-skill.md

WHEN TO USE THIS TEMPLATE - it is CONDITIONAL:
  Write an ADR only when BOTH hold:
    - the decision type is `adopt`, `deviate`, or `revise`, AND
    - >=2 REAL alternatives were in dispute.
  A `ratify` with no alternative lives as an entry in
  docs/architecture/decisions.yml alone. A narrative ADR for it would
  be a facade file.

How to use:
  1. Copy to docs/adr/adr-NNN-{slug}.md - lowercase, `NNN` matching
     nothing in particular except its own sequence (the decision keeps
     its own `ad-NNN` id in decisions.yml).
  2. Fill the header table, then sections 1-5.
  3. Record this file's path in the decision's `adr` field.
  4. Remove these instruction comments when done.

Hard rules:
  - An ADR with no alternatives and no consequences fails the gate.
    That is a summary, not a decision record.
  - Every driver cites a real artifact AND field. Nonexistent path fails.
  - No "TBD". No data -> `unknown`, or drop the line.
  - This file NARRATES; decisions.yml REGISTERS. Do not let them
    disagree - the YAML entry is the machine-readable truth.
  - Keep it short. Length is not evidence of rigour.
====================================================================
-->

# ADR-NNN — {the decision in one line}

| Field | Value |
|---|---|
| **Decision id** | `ad-NNN` (in `docs/architecture/decisions.yml`) |
| **Status** | {proposed \| accepted \| superseded} |
| **Date** | {YYYY-MM-DD} |
| **Type** | {adopt \| deviate \| revise} |
| **Scope** | {system \| feature \| module} — {scope_ref} |
| **Drivers** | {source → field}, {source → field} |
| **Supersedes** | {`ad-NNN`, or delete this row} |
| **Verification** | {the check, one line — same as the YAML entry} |

---

## 1. Context

<!--
What situation forces a decision. State the drivers with their real
sources - not background colour, not a history of the project.
Say what is true today (in brownfield, cite the inventory) and what
about it does not satisfy the drivers.
-->

{the situation, and what makes it insufficient}

**Drivers**

| Driver | Source | Evidence |
|---|---|---|
| {what it demands} | {feat-XXX / inventory.md / risk id} | {real field or section} |

<!--
Brownfield: the architecture observed in inventory.md §2, §3 and §7 is
a BINDING constraint here. If this ADR departs from it, the type is
`deviate` and section 4 must carry the migration note.
-->

---

## 2. Decision

<!--
One paragraph, PRESENT IMPERATIVE. What IS decided - not what will be
studied, preferred, or attempted.
-->

{the decision}

**Implications**

| Type | Implication | Consumed by |
|---|---|---|
| {layers \| boundaries \| structure \| patterns \| stack \| conventions \| derived_work} | {the concrete rule or work it imposes} | {the downstream field or skill} |

---

## 3. Alternatives considered

<!--
REQUIRED. >=1 real alternative that was genuinely in play, each
rejected AGAINST THE DRIVER - not against taste, popularity, or a
generic benefits list. "Do nothing" counts as an alternative when it
was a live option.
-->

### (a) {alternative} — **rejected**

{why it fails the driver named in section 1}

### (b) {alternative} — **chosen**

{why it serves the driver, and what it costs — the cost belongs here too}

---

## 4. Consequences

<!--
REQUIRED, and costs are not optional. A consequences section with only
upsides means the trade-off was not examined.
-->

**Positive**

- {what gets better}

**Costs**

- {what gets worse, harder, slower, or more expensive}

**Neutral** <!-- optional - delete if empty -->

- {what changes without getting better or worse}

<!--
REQUIRED when type is `deviate` - delete this block otherwise.
-->
**Migration** — {what already follows the old pattern (real paths)};
approach: {migrate now \| migrate on touch \| leave and fence off};
{consequence of the coexistence, while it lasts}.

---

## 5. Verification

<!--
How conformance is confirmed by someone who did not take this
decision. This is what mdpe-coding runs in review dimension 2, and it
must match the `verification` field of the YAML entry.
Not a restatement of the decision.
-->

- **Method:** {static-check \| path-exists \| test \| command \| inspection}
- **Check:** {e.g. no file under `src/Domain/` imports `src/Infrastructure/`}
- **Expected:** {e.g. zero matches}

---

## 6. Sources <!-- optional - delete if there are none -->

<!--
Internal artifacts read for this decision, and external references
consulted. Only sources you actually read. If an external claim
supports the decision, link it; unverified capability is a reason to
`defer`, not to cite loosely.
-->

**Internal:** {paths read}

**External:** [{title}]({url})

> Content paraphrased from the sources for licensing compliance. URLs verified on {YYYY-MM-DD}.
