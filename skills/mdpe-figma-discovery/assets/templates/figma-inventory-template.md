<!--
====================================================================
MDPE Framework - Figma Inventory - Template
====================================================================
Version: 1.0.0
Purpose: Fill-in skeleton for the mdpe-figma-discovery skill.
         One single artifact describing an EXISTING Figma prototype:
         structure, screens/flows, and the features it defines.

How to use:
  1. Copy this file to docs/design/figma-inventory.md
     (or figma-inventory-{scope}.md when scoping one flow/page)
  2. Fill the header, then sections 1-3 (essential)
  3. Sections 4-6 are CONDITIONAL: keep one only if there is real
     evidence for it. DELETE the ones you have no evidence for -
     an empty section is worse than a missing one.
  4. Remove these instruction comments when done

Hard rules (see SKILL.md "Anti-fabrication rules"):
  - Verify every frame/page name before writing it - cite Figma's own names.
  - No "TBD" and no placeholders. No data -> "unknown", or drop the field.
  - Low confidence beats invention.
  - Never invent a flow the prototype does not actually connect.
  - No usable prototype -> do not create this file at all; answer
    "no prototype to discover" and route accordingly.
  - Describe what the prototype shows. No effort, priority, or business
    value here.
====================================================================
-->

# Figma inventory — {prototype or scope name}

- **source:** {Figma file/link name}
- **scope:** {page/section, or "whole file"}
- **verified_at:** {YYYY-MM-DD}
- **depth:** {S | M | L} ({N} screens in scope)

<!--
Depth (auto-sizing, from the scope size - never a fixed target):
  S = up to ~15 screens   -> sections 1-3
  M = ~15-50               -> sections 1-3 + applicable conditional ones
  L = >50 or multi-product -> sections 1-3 limited to the declared scope
There is no minimum number of features. 3 screens observed = 3 rows.
-->

---

## 1. Prototype structure

<!-- Essential. Real page/section names as they exist in Figma. -->

| Page / section | In scope? | Notes |
|---|:---:|---|
| {page name} | {yes/no} | {e.g. "onboarding flow only"} |

---

## 2. Screens & flows

<!-- Essential. Screens/flows AS CONNECTED in the prototype (real prototype links). -->

| Screen (frame name) | Connects to | Shows |
|---|---|---|
| {frame name} | {next frame name, or "no outgoing link"} | {what is actually on the frame} |

---

## 3. Reconstructed features

<!--
Essential. One row per feature the prototype ALREADY defines.

  id                fg-NNN, sequential and stable. Promoted to the backlog it
                    becomes feat-NNN, and that feat records `origin: fg-NNN`.
  name              taken from the frame/flow naming itself. Not invented.
  description       one line, PRESENT TENSE: what the prototype shows a user doing.
  frames            >=1 real frame/page name. BLOCKING: none -> do not emit.
  states_observed   empty/error/loading/success states, only if actually shown.
  confidence        high   = frame + real prototype connection + spec/annotation
                     medium = clear frame, flow inferred from layout only
                     low    = frame exists but purpose/flow unclear
  gaps              optional. `unknown`, never filled by deduction.
-->

| id | name | description (today) | frames | states observed | confidence | gaps |
|---|---|---|---|---|:---:|---|
| fg-001 | {name} | {what the prototype shows} | `{frame name}` | {e.g. empty state shown} | {high\|medium\|low} | {unknown / —} |

---

<!--
====================================================================
SECTIONS 4-6 ARE CONDITIONAL.
Keep a section only if you have real evidence for it. Otherwise DELETE
the whole section.
====================================================================
-->

## 4. Annotations / dev specs

<!-- Only when Figma Dev Mode measurements, redlines, or comments are attached. -->

| Frame | Annotation | Evidence |
|---|---|---|
| {frame name} | {measurement/comment content} | {Dev Mode / comment thread} |

---

## 5. Designed vs. built

<!-- Only when docs/frontend/inventory.md exists for the same product. -->

| Designed (`fg-NNN`) | Built (`ff-NNN`) | Gap |
|---|---|---|
| {fg-001} | {ff-003, or "not built yet"} | {what differs} |

---

## 6. Open design questions

<!-- Only with real, observed ambiguity: a dead-end flow, a missing state, contradicting frames. -->

| Question | Evidence | Note |
|---|---|---|
| {e.g. what happens after "Submit" on frame X?} | {no outgoing prototype link found} | {blocking for build?} |

---

## Next step

<!-- Pick the one route that applies and state how this inventory is consumed. -->

- **Route:** {mdpe-tasks | mdpe-backlog -> mdpe-transformation | mdpe-frontend-discovery | done}
- **How this inventory is consumed:** {e.g. the `frames` of fg-002 become the design
  reference of the new tasks}
