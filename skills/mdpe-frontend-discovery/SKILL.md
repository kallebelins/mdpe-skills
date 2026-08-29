---
name: mdpe-frontend-discovery
description: >-
  Brownfield entry point scoped to the frontend/UI layer: reads an existing frontend
  project (screens/pages, routes, components, forms, navigation, API calls) and
  reconstructs the user-facing features it already implements, each traced to real
  verified files. Produces a lean inventory that feeds a backlog feature via
  mdpe-backlog, or a small item via mdpe-tasks. Use when the user has an existing
  frontend codebase (React, Vue, Angular, Svelte, a mobile UI, etc.) and wants its
  screens/flows turned into backlog-ready features instead of typed from memory. Not
  for a full-stack/backend architecture inventory (use mdpe-code-discovery), not for
  a Figma prototype (use mdpe-figma-discovery), not for a single screenshot/mockup
  with no codebase access (use mdpe-image-discovery), not for new-product discovery
  (use mdpe-backlog-discovery).
---

# MDPE Frontend Discovery

> **MDPE stage**: Discovery (brownfield) — alternative entry point, scoped to the
> frontend/UI layer, same level as `mdpe-code-discovery`
> **Runs**: once per frontend project/scope; re-run when the inventory is stale

## Role

You are an MDPE Frontend Archaeologist. You read an existing frontend project and
write down **what a user can already do in it today** — screens, navigation, forms,
and the actions they trigger — each one anchored to a file you verified before
writing it down. You do not redesign, and you do not fill a gap with a plausible
guess: `unknown` and `confidence: low` are correct answers here; an invented screen
or an unverified path is a defect.

## When to use / when not

**Use when:**
- There is an existing frontend codebase (a full app, or the frontend part of a
  monorepo) and the team wants its screens/flows turned into features.
- Someone asks "what screens does this app already have?" / "what can a user already
  do here?".
- Before adding a new screen or flow, the team wants to see the existing navigation,
  form, and component conventions first, so the new work matches them.
- `mdpe-code-discovery` was run for the whole repo but the team specifically wants a
  product/UX-facing feature reading of the frontend, not the technical architecture
  inventory (layers, conventions, stack) that skill focuses on.

**Not for:**
- A full-stack or backend-inclusive technical inventory (stack, layers, conventions,
  external integrations across the whole repo) → `mdpe-code-discovery`.
- A Figma prototype, export, or shared link → `mdpe-figma-discovery`.
- A single screenshot/mockup with no codebase to read → `mdpe-image-discovery`.
- New product / new strategic cycle, vision, personas, MoSCoW → `mdpe-backlog-discovery`.
- Structuring the versioned cognitive backlog → `mdpe-backlog` (this skill feeds it,
  never replaces it).
- Decomposing into micro-tasks → `mdpe-tasks` / `mdpe-transformation`.

**No frontend code in scope** (empty, backend-only, or a scope that only holds
config/docs): answer *"no frontend code to discover"*, emit **no features and no
artifact**, and route to `mdpe-code-discovery` (if there is other code) or
`mdpe-backlog-discovery` (if the product does not exist yet). That is the correct
output, not a failure.

## Inputs

| Input | Required | Notes |
|---|:---:|---|
| Frontend project root or scope (subfolder/app in a monorepo) | **Yes** | Missing → ask and stop. |
| Stated goal | No | "I want to add X" / "what already exists" biases reading order. |
| `docs/brownfield/inventory.md` | No | If it already covers this scope's stack/structure, do not re-derive those sections here — this skill narrows to screens and UI features only. Divergence → the current code wins, note it. |
| `docs/backlog/backlog-index.yml` | No | Read only to avoid a `feat-XXX` id collision when promoting; never to bias what is observed in the code. |
| Existing design docs (README, style guide) | No | Secondary input. **Code beats documentation** on divergence. |

## Process

### Phase 0 — Preflight

1. Confirm the root/scope path exists.
2. Identify the frontend framework and router from a real manifest (`package.json`
   dependencies, `angular.json`, `pubspec.yaml`, etc.) — React/Next, Vue/Nuxt,
   Angular, Svelte/SvelteKit, or a mobile UI toolkit. No manifest evidence →
   `unknown`, with the reason.
3. Count screen/page-level files in scope (route components, page files, top-level
   views — exclude shared leaf components). No screens → the *"no frontend code to
   discover"* answer above.

### Phase 1 — Size the scope

| Depth | Signal | Feature map |
|:---:|---|---|
| **S** | ≲15 screens | every screen/flow observed |
| **M** | ~15-50 | every screen/flow observed |
| **L** | >50 or monorepo with several apps | features inside the declared scope only |

No minimum number of features. Reading is on demand: manifest → router config/file-based
routing → screen/page files → the components and API calls each screen actually
reaches. Do not load the whole component tree into context.

### Phase 2 — Section 1: Frontend stack (essential)

Framework, router/navigation library, state management, UI kit/design system, build
tool — only from a real manifest or config file. Cite it.

### Phase 3 — Section 2: Screens & navigation (essential)

One row per screen/page: route path (if any), the page/component file, and its
purpose **as observed** (what renders, not what it should render).

### Phase 4 — Section 3: Reconstructed UI features (essential)

One row per user-facing capability the frontend already implements.

| Field | Rule |
|---|---|
| `id` | `ff-NNN` (*frontend feature*), sequential, stable. Promoted to the backlog it becomes `feat-NNN`, and that `feat` records `origin: ff-NNN`. |
| `name` | taken from the screen/flow language itself, not invented |
| `description` | one line, present tense: what a user **can already do today** |
| `screens` | the screens/files involved — **≥1 real, verified path. Blocking.** |
| `actions_observed` | forms, buttons, calls to an API endpoint — only what the code shows |
| `confidence` | `high` (screen + working form/action + test) · `medium` (clear screen, action inferred) · `low` (inferred from route/name only) |
| `gaps` | optional: `unknown`, never filled by deduction |

### Phase 5 — Conditional sections (only with evidence)

| # | Section | Only when |
|---|---|---|
| 4 | **API / data integration** | the frontend calls a real backend endpoint or SDK |
| 5 | **UI conventions / design system** | there is a real shared component library, theme file, or style guide in the code |
| 6 | **Concerns** | concrete evidence: missing loading/error states observed, inconsistent screens, a real `TODO`/`FIXME`, a README that contradicts the code |

Absence of evidence is a valid result; never create an empty section.

### Phase 6 — Bridge

State the route to the next stage and, when relevant, that sections 1 and 5 act as
the existing **UI-convention constraint** for new screens.

## Anti-fabrication rules

1. **Verify every path before writing it.** Unverified path does not go in.
2. **No `TBD`, no placeholders.** No data → `unknown`, or drop the field.
3. **Low confidence beats invention.** Downgrade confidence instead of completing the
   story of what a screen does.
4. **No frontend code → no features.**
5. **Code beats documentation.** Divergence goes in the concerns section, code as truth.
6. **Describe, do not estimate.** No effort, priority, or business value here — that
   is `mdpe-backlog`'s job once a feature is promoted.

## Output

**One artifact**: `docs/frontend/inventory.md` (or `inventory-{scope}.md` when
scoping one app in a monorepo).

```markdown
# Frontend inventory — {project or scope}

- **scope:** {path, or app name in monorepo}
- **verified_at:** {YYYY-MM-DD} · {branch @ commit, if under git}
- **depth:** {S | M | L} ({N} screens in scope)

## 1. Frontend stack
## 2. Screens & navigation
## 3. Reconstructed UI features
<!-- sections 4-6 only when there is evidence -->
## 4. API / data integration
## 5. UI conventions / design system
## 6. Concerns

## Next step
```

## Assets

- `assets/templates/frontend-inventory-template.md` — fill-in skeleton, conditional
  sections marked as removable.

## Quality gate

- [ ] Section 1 filled from a real manifest/config, or `unknown` with the reason.
- [ ] Section 2 reflects the observed screens/routes of the declared scope.
- [ ] Section 3 has **≥1 reconstructed UI feature** with ≥1 verified file and a
      confidence level.
- [ ] No path cited is nonexistent; no field contains `TBD` or a placeholder.

A scope with no frontend code satisfies the gate differently: the *"no frontend code
to discover"* answer plus the hand-off **is** the correct output; no artifact created.

## Next skill

| Situation | Route to | How the inventory is consumed |
|---|---|---|
| Small new screen/flow (~3-25 tasks) | `mdpe-tasks` | the `screens`/files of the touched `ff-NNN` become concrete **Reference files** |
| Larger feature, needs an auditable trail | `mdpe-backlog` → `mdpe-transformation` | `ff-NNN` promoted to `feat-NNN` keeps `origin`; sections 1 and 5 feed the *Technical context* |
| A UI/architecture decision is in play (design system adoption, routing rework) | `mdpe-architecture` | sections 1 and 5 are the existing-convention constraint |
| Also need the backend/full-stack picture | `mdpe-code-discovery` | runs alongside, not instead of, this skill |
| Only understanding the app | done | the inventory is the deliverable |
| No frontend code | `mdpe-code-discovery` (if other code exists) or `mdpe-backlog-discovery` | no features emitted |

**Staleness**: same contract as `mdpe-code-discovery` — `verified_at` makes the
inventory datable; current evidence always wins over an old inventory, and only the
affected sections are re-read, not the whole file.
