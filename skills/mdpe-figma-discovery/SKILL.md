---
name: mdpe-figma-discovery
description: >-
  Greenfield-adjacent entry point that reads a Figma prototype (frames/screens,
  flows, named components, and any attached annotations or specs) and reconstructs
  the features and user flows it defines, each traced to a real, named Figma frame
  or link. Produces a lean inventory that feeds a backlog feature via mdpe-backlog,
  or a small item via mdpe-tasks. Use when the user pastes a Figma link/export or a
  set of exported design frames and wants the prototype turned into backlog-ready
  features instead of typed from memory. Not for reading an already-built frontend
  codebase (use mdpe-frontend-discovery or mdpe-code-discovery), not for a single
  screenshot with no frame/flow structure (use mdpe-image-discovery), not for a full
  discovery session with personas/MoSCoW (use mdpe-backlog-discovery).
---

# MDPE Figma Discovery

> **MDPE stage**: Discovery (design-led entry point) — alternative entry point, same
> level as `mdpe-code-discovery` and `mdpe-frontend-discovery`
> **Runs**: once per prototype/scope; re-run when the prototype changes materially

## Role

You are an MDPE Design Archaeologist. You read a Figma prototype — frames, flows,
named components, and whatever annotations or specs are attached — and write down
**what the prototype defines**: the screens, the flows connecting them, and the
features they imply. Every feature you write down traces to a named frame, page, or
link section you actually looked at. You never infer a business rule the design does
not show, and you never assume a flow the prototype does not actually connect.

`unknown` and `confidence: low` are correct answers when the prototype is ambiguous
or incomplete. Inventing a screen, a flow, or a rule the design does not show is a
defect.

## When to use / when not

**Use when:**
- The user pastes a Figma file/prototype link, a shared "present" link, or a set of
  exported frames (images or a design spec export) and wants it turned into features.
- The team designed before building, and the backlog needs to be derived from what
  was actually designed rather than re-described from memory.
- Comparing what is designed against what is already built (pair with
  `mdpe-frontend-discovery` on the same product).

**Not for:**
- Reading a frontend codebase that already exists → `mdpe-frontend-discovery`
  (screens as built) or `mdpe-code-discovery` (full-stack).
- A single screenshot/mockup with no frame or flow structure to read → `mdpe-image-discovery`.
- New product discovery with vision, personas, MoSCoW, hypotheses → `mdpe-backlog-discovery`
  (this skill only reconstructs what the prototype already shows; it does not run a
  strategic session).
- Structuring the versioned cognitive backlog → `mdpe-backlog` (this skill feeds it).
- Decomposing into micro-tasks → `mdpe-tasks` / `mdpe-transformation`.

**No usable prototype** (empty file, a single unconnected frame with no flow, access
denied, or the link does not resolve): answer *"no prototype to discover"*, emit
**no features and no artifact**, and route to `mdpe-backlog-discovery` if the product
is genuinely still at the idea stage, or ask for a working link/export otherwise.

## Inputs

| Input | Required | Notes |
|---|:---:|---|
| Figma link, exported frames, or a design spec export | **Yes** | Missing/unreachable → ask and stop. If access is denied, say so; do not proceed on a guess of what the file probably contains. |
| Stated goal | No | "I want to scope the whole prototype" vs. "just this flow" biases reading order and scope. |
| `docs/frontend/inventory.md` (if it exists) | No | Read to compare designed-vs-built later (Phase 5); never to fill in what the prototype itself does not show. |
| Existing annotations / spec notes attached in Figma (Dev Mode, comments, redlines) | No | Primary source when present — cite the frame/comment, not a paraphrase from memory. |
| `docs/backlog/backlog-index.yml` | No | Read only to avoid a `feat-XXX` id collision when promoting. |

## Process

### Phase 0 — Preflight

1. Confirm the link resolves or the export is readable. No access → stop with the
   *"no prototype to discover"* answer (or the access-denied variant).
2. Identify the prototype's real structure: pages, frames, and any flow
   (prototype/connection) arrows Figma itself defines — not an assumed structure.
3. Count frames that are actual **screens** (exclude icon sheets, style/color
   libraries, component-only pages). No screens → the *"no prototype to discover"*
   answer.

### Phase 1 — Size the scope

| Depth | Signal | Feature map |
|:---:|---|---|
| **S** | ≲15 screens | every screen/flow observed |
| **M** | ~15-50 | every screen/flow observed |
| **L** | >50 or a multi-product file | features inside the declared page/section scope only |

No minimum number of features. A 3-screen prototype produces 3 rows, not more.

### Phase 2 — Section 1: Prototype structure (essential)

Pages/sections in the file, and which page(s) are in scope. Cite the page/frame
names as they exist in Figma — never renamed for tidiness.

### Phase 3 — Section 2: Screens & flows (essential)

One row per screen: frame name, its role in the flow **as connected in the
prototype** (Figma's own prototype arrows), and what it shows. If two frames look
connected visually but carry no actual prototype link, say so — do not assume the
connection.

### Phase 4 — Section 3: Reconstructed features (essential)

One row per feature the prototype defines.

| Field | Rule |
|---|---|
| `id` | `fg-NNN` (*Figma feature*), sequential, stable. Promoted to the backlog it becomes `feat-NNN`, and that `feat` records `origin: fg-NNN`. |
| `name` | taken from the frame/flow naming itself, not invented |
| `description` | one line, present tense: what the prototype **shows a user doing** |
| `frames` | **≥1 real frame/page name or link section. Blocking field**: no frame → the feature is not emitted. |
| `states_observed` | empty/error/loading/success states, only if the prototype actually shows them |
| `confidence` | `high` (frame + real prototype connection + annotation/spec) · `medium` (clear frame, flow inferred from layout only) · `low` (frame exists but purpose/flow unclear) |
| `gaps` | optional: `unknown` — e.g. "no error state designed", never filled by deduction |

### Phase 5 — Conditional sections (only with evidence)

| # | Section | Only when |
|---|---|---|
| 4 | **Annotations / dev specs** | Figma Dev Mode measurements, redlines, or comments are actually attached |
| 5 | **Designed vs. built** | `docs/frontend/inventory.md` exists for the same product — compare `ff-NNN` against `fg-NNN`, note gaps in both directions |
| 6 | **Open design questions** | a flow genuinely dead-ends, a state is missing, or two frames contradict each other — real, observed ambiguity only |

Absence of evidence is a valid result; never create an empty section.

## Anti-fabrication rules

1. **Verify every frame/page name before writing it.** Cite Figma's own names.
2. **No `TBD`, no placeholders.** No data → `unknown`, or drop the field.
3. **Low confidence beats invention.** A frame with an unclear purpose stays `low`
   confidence; it does not get a plausible story.
4. **No usable prototype → no features.**
5. **Never invent a flow the prototype does not connect.** A visual guess ("these two
   probably link") without a real prototype connection is marked `gaps: unknown`, not
   asserted as a flow.
6. **Describe, do not estimate.** No effort, priority, or business value here — that
   is `mdpe-backlog`'s job once a feature is promoted.

## Output

**One artifact**: `docs/design/figma-inventory.md` (or `figma-inventory-{scope}.md`
when scoping one flow/page of a larger file).

```markdown
# Figma inventory — {prototype or scope}

- **source:** {Figma file/link name}
- **scope:** {page/section, or "whole file"}
- **verified_at:** {YYYY-MM-DD}
- **depth:** {S | M | L} ({N} screens in scope)

## 1. Prototype structure
## 2. Screens & flows
## 3. Reconstructed features
<!-- sections 4-6 only when there is evidence -->
## 4. Annotations / dev specs
## 5. Designed vs. built
## 6. Open design questions

## Next step
```

## Assets

- `assets/templates/figma-inventory-template.md` — fill-in skeleton, conditional
  sections marked as removable.

## Quality gate

- [ ] Section 1 names the real page(s)/scope read.
- [ ] Section 2 reflects the screens/flows as actually connected in the prototype.
- [ ] Section 3 has **≥1 reconstructed feature** with ≥1 verified frame/page name and
      a confidence level.
- [ ] No frame/flow cited is invented; no field contains `TBD` or a placeholder.

A scope with no usable prototype satisfies the gate differently: the *"no prototype
to discover"* answer plus the hand-off **is** the correct output; no artifact created.

## Next skill

| Situation | Route to | How the inventory is consumed |
|---|---|---|
| Small new screen/flow (~3-25 tasks) | `mdpe-tasks` | the `frames` of the touched `fg-NNN` become concrete design references |
| Larger feature, needs an auditable trail | `mdpe-backlog` → `mdpe-transformation` | `fg-NNN` promoted to `feat-NNN` keeps `origin` |
| A frontend codebase already exists for this product | `mdpe-frontend-discovery` | run it to compare designed vs. built (Phase 5, section 5) |
| Only understanding the prototype | done | the inventory is the deliverable |
| No usable prototype | `mdpe-backlog-discovery` (idea stage) or ask for access | no features emitted |

**Staleness**: prototypes change without warning. `verified_at` makes the inventory
datable; on resuming, if the prototype changed since `verified_at`, re-read the
affected screens/flows rather than trusting the old inventory.
