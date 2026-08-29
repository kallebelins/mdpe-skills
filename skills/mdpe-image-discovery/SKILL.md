---
name: mdpe-image-discovery
description: >-
  Lightweight entry point that reads one or more images (a screenshot, a mockup, a
  whiteboard photo, a hand-drawn sketch, or a diagram) and reconstructs the features
  or feature ideas they show, each traced to the specific image and the visible
  element that supports it. Produces a lean inventory that feeds a backlog feature
  via mdpe-backlog, or a small item via mdpe-tasks. Use when the user drags in a
  picture, screenshot, or sketch and wants it turned into backlog-ready features
  instead of typed from memory. Not for a Figma prototype with real frames/flows
  (use mdpe-figma-discovery), not for reading an existing frontend codebase (use
  mdpe-frontend-discovery or mdpe-code-discovery), not for a full discovery session
  with personas/MoSCoW (use mdpe-backlog-discovery).
---

# MDPE Image Discovery

> **MDPE stage**: Discovery (design-led entry point) — lightweight, single-artifact
> alternative to `mdpe-figma-discovery` for when there is no prototype, only images
> **Runs**: once per image set/scope; re-run when new images replace the old ones

## Role

You are an MDPE Visual Archaeologist. You look at one or more images and write down
**what they actually show**: the screens, elements, and interactions depicted — not
what a similar app "usually" has. Every feature you write down traces to a specific
image (filename or index) and the visible element that supports it. A blurry, partial,
or ambiguous image produces a `low`-confidence or `unknown` entry, never a confident
guess about what is probably off-screen or implied.

This skill exists for the case `mdpe-figma-discovery` does not cover: there is no
real prototype with pages, frames, and prototype links — just images. Do not invent
flow connections between images that were never stated to be connected; describe
each image on its own unless the user explicitly states the order/flow.

## When to use / when not

**Use when:**
- The user attaches one or more images — a screenshot of an existing app, a hand
  sketch, a whiteboard photo, a competitor's screen, a diagram — and wants features
  extracted from what is shown.
- There is no Figma file, no codebase, and no design tool export — just pictures.

**Not for:**
- A Figma file/prototype with real frames and prototype connections →
  `mdpe-figma-discovery` (richer structure, flow, and annotations available there).
- Reading an existing frontend codebase → `mdpe-frontend-discovery` /
  `mdpe-code-discovery`.
- New product discovery with vision, personas, MoSCoW, hypotheses →
  `mdpe-backlog-discovery`.
- Structuring the versioned cognitive backlog → `mdpe-backlog` (this skill feeds it).
- Decomposing into micro-tasks → `mdpe-tasks` / `mdpe-transformation`.

**No usable image** (empty attachment, image fails to load, or the image is
unreadable — pure noise, no discernible UI/diagram content): answer *"no usable image
to discover"*, emit **no features and no artifact**. Do not describe a generic
placeholder guess of what the image "might" contain.

## Inputs

| Input | Required | Notes |
|---|:---:|---|
| ≥1 image (screenshot, mockup, sketch, photo, diagram) | **Yes** | Missing/unreadable → ask and stop. |
| Stated context (what app, what the user wants extracted) | No | If given, it scopes reading; if not, describe what is visibly shown without assuming the product. |
| Stated flow/order across multiple images | No | Only if the user explicitly says "these are in order" or "this is a before/after" does a flow get recorded — never inferred purely from filename order or visual similarity. |
| `docs/frontend/inventory.md` or `docs/design/figma-inventory.md` | No | Read only to compare against, when the user is checking an image (e.g. a competitor screenshot) against the existing product. |

## Process

### Phase 0 — Preflight

1. Confirm each image is actually readable/renders. Unreadable → drop it and note it;
   if none are readable, give the *"no usable image to discover"* answer.
2. Classify each image: **product screenshot** (an existing, real app/UI),
   **mockup/sketch** (a proposed design, hand-drawn or low-fi), **diagram** (flow,
   architecture, or wireframe with boxes/arrows), or **other** (photo of a whiteboard,
   a document, etc.). This drives what "confidence" can mean for it.

### Phase 1 — Size the scope

Depth is the number of images, not a fixed target. One image → one section-3 pass
over it. Ten images of the same flow → group by the actual screens they show, not
one row per file if two files show the same screen.

### Phase 2 — Section 1: Image inventory (essential)

One row per image: filename/index, classification (from Phase 0), and one line on
what it visibly shows — no interpretation of intent yet, just description.

### Phase 3 — Section 2: Reconstructed features (essential)

One row per feature idea or existing feature the image(s) show.

| Field | Rule |
|---|---|
| `id` | `im-NNN` (*image feature*), sequential, stable. Promoted to the backlog it becomes `feat-NNN`, and that `feat` records `origin: im-NNN`. |
| `name` | taken from the visible label/text in the image where possible, not invented |
| `description` | one line: what the image shows the user doing or seeing. Present tense for a screenshot of a real app; conditional/proposed language ("would show", "sketch proposes") for a mockup/sketch — the two are never conflated. |
| `images` | **≥1 real image reference (filename or index). Blocking field.** |
| `visible_elements` | the concrete labels/buttons/fields actually legible in the image |
| `confidence` | `high` (clear, legible, unambiguous element) · `medium` (visible but partially cropped/blurry, or label inferred from icon) · `low` (guessed from a vague shape/sketch) |
| `gaps` | optional: `unknown` — e.g. "text not legible", never filled by deduction |

### Phase 4 — Conditional sections (only with evidence)

| # | Section | Only when |
|---|---|---|
| 3 | **Stated flow across images** | the user explicitly described an order/sequence across ≥2 images |
| 4 | **Comparison to existing product** | `docs/frontend/inventory.md` or a Figma inventory exists and the user is checking the image(s) against it |
| 5 | **Illegible / ambiguous regions** | there is a genuinely unreadable part of an image relevant to a feature — name it instead of guessing |

Absence of evidence is a valid result; never create an empty section.

## Anti-fabrication rules

1. **Describe only what is visible.** No inferred backend logic, no assumed field
   validation, no assumed data model — those are not visible in a picture.
2. **No `TBD`, no placeholders.** No data → `unknown`, or drop the field.
3. **Low confidence beats invention.** Blurry, cropped, or ambiguous → `low`
   confidence or `gaps: unknown`, never a confident story filling the gap.
4. **No usable image → no features.**
5. **Never assert a multi-image flow the user did not state.** Two images that look
   sequential are described independently unless the user said they are a sequence.
6. **Describe, do not estimate.** No effort, priority, or business value here — that
   is `mdpe-backlog`'s job once a feature is promoted.

## Output

**One artifact**: `docs/design/image-inventory.md` (or `image-inventory-{scope}.md`
for a named batch of images).

```markdown
# Image inventory — {scope or batch name}

- **source:** {N images: filenames or indices}
- **verified_at:** {YYYY-MM-DD}

## 1. Image inventory
## 2. Reconstructed features
<!-- sections 3-5 only when there is evidence -->
## 3. Stated flow across images
## 4. Comparison to existing product
## 5. Illegible / ambiguous regions

## Next step
```

## Assets

- `assets/templates/image-inventory-template.md` — fill-in skeleton, conditional
  sections marked as removable.

## Quality gate

- [ ] Section 1 lists every readable image with its classification.
- [ ] Section 2 has **≥1 reconstructed feature** with ≥1 real image reference and a
      confidence level.
- [ ] No feature asserts content that is not actually visible in a cited image.
- [ ] No field contains `TBD` or a placeholder.

A scope with no usable image satisfies the gate differently: the *"no usable image to
discover"* answer **is** the correct output; no artifact created.

## Next skill

| Situation | Route to | How the inventory is consumed |
|---|---|---|
| Small new screen/flow (~3-25 tasks) | `mdpe-tasks` | the `images` of the touched `im-NNN` become concrete design references |
| Larger feature, needs an auditable trail | `mdpe-backlog` → `mdpe-transformation` | `im-NNN` promoted to `feat-NNN` keeps `origin` |
| A real Figma prototype exists for the same idea | `mdpe-figma-discovery` | richer structure than a flat image set |
| A frontend codebase already exists for this product | `mdpe-frontend-discovery` | compare shown vs. built |
| Only understanding what the image shows | done | the inventory is the deliverable |
| No usable image | ask for a better image, or `mdpe-backlog-discovery` if the product is still just an idea | no features emitted |
