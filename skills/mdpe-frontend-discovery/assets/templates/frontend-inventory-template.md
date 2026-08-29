<!--
====================================================================
MDPE Framework - Frontend Inventory - Template
====================================================================
Version: 1.0.0
Purpose: Fill-in skeleton for the mdpe-frontend-discovery skill.
         One single artifact describing an EXISTING frontend project:
         stack, screens/navigation, and the user-facing features the
         code already implements.

How to use:
  1. Copy this file to docs/frontend/inventory.md
     (or docs/frontend/inventory-{scope}.md when scoping one app)
  2. Fill the header, then sections 1-3 (essential)
  3. Sections 4-6 are CONDITIONAL: keep one only if there is real
     evidence for it. DELETE the ones you have no evidence for -
     an empty section is worse than a missing one.
  4. Remove these instruction comments when done

Hard rules (see SKILL.md "Anti-fabrication rules"):
  - Verify every path before writing it. Unverified path -> leave it out.
  - No "TBD" and no placeholders. No data -> "unknown", or drop the field.
  - Low confidence beats invention.
  - No frontend code in scope -> do not create this file at all; answer
    "no frontend code to discover" and route accordingly.
  - Code beats documentation; current evidence beats an old inventory.
  - Describe what exists. No effort, priority, or business value here.
====================================================================
-->

# Frontend inventory — {project or scope name}

- **scope:** {path, or app name in monorepo}
- **verified_at:** {YYYY-MM-DD} · {branch @ short-commit, or `no git`}
- **depth:** {S | M | L} ({N} screens in scope)

<!--
Depth (auto-sizing, from the scope size - never a fixed target):
  S = up to ~15 screens   -> sections 1-3
  M = ~15-50               -> sections 1-3 + applicable conditional ones
  L = >50 or monorepo      -> sections 1-3 limited to the declared scope
There is no minimum number of features. 2 screens observed = 2 rows.
-->

---

## 1. Frontend stack

<!-- Essential. Only what a real manifest/config states. Cite it. -->

| Item | Value | Evidence |
|---|---|---|
| Framework | {e.g. React 18 + Next.js 14} | `{path/to/manifest}` |
| Router / navigation | {e.g. Next.js file-based routing, React Navigation} | `{path/to/config}` |
| State management | {e.g. Redux Toolkit, Zustand, none observed} | `{path}` |
| UI kit / design system | {e.g. MUI, internal `@ui` package} | `{path}` |
| Build tool | {e.g. Vite, Webpack, Next build} | `{path/to/manifest}` |

---

## 2. Screens & navigation

<!-- Essential. Screens/routes AS OBSERVED, limited to the declared scope. -->

| Screen | Route (if any) | File | Purpose as observed |
|---|---|---|---|
| {name} | `{/path}` | `{path/to/file}` | {what actually renders} |

---

## 3. Reconstructed UI features

<!--
Essential. One row per user-facing capability the code ALREADY implements.

  id                ff-NNN, sequential and stable. Promoted to the backlog it
                    becomes feat-NNN, and that feat records `origin: ff-NNN`.
  name              taken from the screen/flow language itself. Not invented.
  description       one line, PRESENT TENSE: what a user can already do today.
  screens           >=1 real verified path. BLOCKING: no path -> do not emit.
  actions_observed  forms/buttons/API calls actually present in the code.
  confidence        high   = screen + working action + test
                     medium = clear screen, action inferred
                     low    = inferred from route/name only
  gaps              optional. `unknown`, never filled by deduction.
-->

| id | name | description (today) | screens | actions observed | confidence | gaps |
|---|---|---|---|---|:---:|---|
| ff-001 | {name} | {what a user can do today} | `{path}` | {e.g. submit form -> POST /api/x} | {high\|medium\|low} | {unknown / —} |

---

<!--
====================================================================
SECTIONS 4-6 ARE CONDITIONAL.
Keep a section only if you have real evidence for it. Otherwise DELETE
the whole section.
====================================================================
-->

## 4. API / data integration

<!-- Only when the frontend calls a real backend endpoint or SDK. -->

| Endpoint / SDK | Called from | Direction | Evidence |
|---|---|---|---|
| {e.g. GET /api/orders} | `{screen/file}` | outbound | `{path/to/client call}` |

---

## 5. UI conventions / design system

<!-- Only when there is a real shared component library, theme, or style guide. -->

| Convention | Observed rule | Evidence |
|---|---|---|
| {e.g. shared form layout} | {description} | `{path}` |

---

## 6. Concerns

<!--
Only with concrete evidence: missing loading/error states observed, inconsistent
screens, real TODO/FIXME, or documentation that contradicts the code.
-->

| Concern | Evidence | Note |
|---|---|---|
| {e.g. no error state on the checkout form} | {what was checked} | {impact as observed} |

---

## Next step

<!-- Pick the one route that applies and state how this inventory is consumed. -->

- **Route:** {mdpe-tasks | mdpe-backlog -> mdpe-transformation | mdpe-architecture | mdpe-code-discovery | done}
- **How this inventory is consumed:** {e.g. the `screens` of ff-002 become the
  Reference files of the new tasks; sections 1 and 5 are carried forward as the
  existing UI-convention constraint}
