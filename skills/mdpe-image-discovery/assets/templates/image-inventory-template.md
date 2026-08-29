<!--
====================================================================
MDPE Framework - Image Inventory - Template
====================================================================
Version: 1.0.0
Purpose: Fill-in skeleton for the mdpe-image-discovery skill.
         One single artifact describing what a set of images shows:
         screenshots, mockups, sketches, or diagrams, and the features
         they imply.

How to use:
  1. Copy this file to docs/design/image-inventory.md
     (or image-inventory-{scope}.md for a named batch)
  2. Fill the header, then sections 1-2 (essential)
  3. Sections 3-5 are CONDITIONAL: keep one only if there is real
     evidence for it. DELETE the ones you have no evidence for -
     an empty section is worse than a missing one.
  4. Remove these instruction comments when done

Hard rules (see SKILL.md "Anti-fabrication rules"):
  - Describe only what is visible. No inferred logic, validation, or data model.
  - No "TBD" and no placeholders. No data -> "unknown", or drop the field.
  - Low confidence beats invention.
  - Never assert a multi-image flow the user did not state.
  - No usable image -> do not create this file at all; answer
    "no usable image to discover".
  - Describe what is shown. No effort, priority, or business value here.
====================================================================
-->

# Image inventory — {scope or batch name}

- **source:** {N images: filenames or indices}
- **verified_at:** {YYYY-MM-DD}

---

## 1. Image inventory

<!-- Essential. One row per readable image. -->

| Image | Classification | Visibly shows |
|---|---|---|
| {filename or index} | {product screenshot \| mockup/sketch \| diagram \| other} | {plain description, no interpretation yet} |

---

## 2. Reconstructed features

<!--
Essential. One row per feature idea or existing feature the image(s) show.

  id                im-NNN, sequential and stable. Promoted to the backlog it
                    becomes feat-NNN, and that feat records `origin: im-NNN`.
  name              taken from a visible label where possible. Not invented.
  description       one line. Present tense for a real screenshot; proposed/
                    conditional language for a mockup/sketch - never conflated.
  images            >=1 real image reference. BLOCKING: none -> do not emit.
  visible_elements  concrete labels/buttons/fields actually legible.
  confidence        high   = clear, legible, unambiguous element
                     medium = visible but partially cropped/blurry/iconic
                     low    = guessed from a vague shape/sketch
  gaps              optional. `unknown`, never filled by deduction.
-->

| id | name | description | images | visible elements | confidence | gaps |
|---|---|---|---|---|:---:|---|
| im-001 | {name} | {what is shown} | `{filename}` | {e.g. "Submit" button, email field} | {high\|medium\|low} | {unknown / —} |

---

<!--
====================================================================
SECTIONS 3-5 ARE CONDITIONAL.
Keep a section only if you have real evidence for it. Otherwise DELETE
the whole section.
====================================================================
-->

## 3. Stated flow across images

<!-- Only when the user explicitly described an order/sequence across >=2 images. -->

| Step | Image | User-stated relation to next |
|---|---|---|
| 1 | {filename} | {e.g. "user taps this button, then sees image 2" - as stated by the user} |

---

## 4. Comparison to existing product

<!-- Only when a frontend or Figma inventory exists for the same product. -->

| Shown in image (`im-NNN`) | Existing (`ff-NNN` / `fg-NNN`) | Gap |
|---|---|---|
| {im-001} | {ff-002, or "not found in existing inventory"} | {what differs} |

---

## 5. Illegible / ambiguous regions

<!-- Only when a genuinely unreadable part of an image is relevant to a feature. -->

| Image | Region | Why it is ambiguous |
|---|---|---|
| {filename} | {e.g. bottom-right corner} | {cropped / blurry / no context} |

---

## Next step

<!-- Pick the one route that applies and state how this inventory is consumed. -->

- **Route:** {mdpe-tasks | mdpe-backlog -> mdpe-transformation | mdpe-figma-discovery | mdpe-frontend-discovery | done}
- **How this inventory is consumed:** {e.g. the `images` of im-002 become the design
  reference of the new tasks}
