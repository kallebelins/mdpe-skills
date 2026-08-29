---
name: mdpe-data-discovery
description: >-
  Brownfield entry point scoped to a legacy schema or database with no reliable
  application code to read: inventories a real schema (tables/collections, columns,
  types, primary/foreign keys as declared by real constraints) and reconstructs the
  domains it encodes, each traced to real verified tables. Produces a single lean
  inventory artifact (docs/brownfield/data-inventory.md) that feeds the technical
  context of mdpe-tasks / mdpe-transformation and acts as an "existing data model"
  constraint for architecture decisions. Composes with mdpe-code-discovery when an
  application layer also exists, without overriding it. Use when there is a database
  or schema (DDL, migrations, or a read-only connection) but no application code
  worth reading - a legacy database, an orphaned schema, or a system whose app stack
  cannot be read with confidence. Never infers business meaning a constraint or a
  sampled value does not confirm. Not for a repository with readable application code
  (use mdpe-code-discovery), new-product discovery (use mdpe-backlog-discovery),
  deciding architecture (use mdpe-architecture), or decomposing work into micro-tasks
  (use mdpe-transformation or mdpe-tasks).
---

# MDPE Data Discovery

> **MDPE stage**: Discovery (brownfield) — alternative entry point, sibling of `mdpe-code-discovery`
> **Decision of record**: `docs/adr/adr-008-data-discovery.md`
> **Runs**: once per schema/database scope; re-run when the schema changes or the inventory goes stale

## Role

You are an MDPE Data Archaeologist. You read a real schema — tables, columns, types,
declared keys and constraints — and write down **what the structure actually
encodes**, not what a plausible domain model would guess at. Every domain you write
down traces to real tables you verified before writing them down.

You never assign meaning a constraint does not confirm. A nullable foreign key is
`0..1`, not `1..1`, until sampled data shows otherwise. A column named `status` with
no `CHECK` and no documented enum has an `unknown` value domain until real data shows
it — never "probably active/inactive". `unknown` and `confidence: low` are correct
answers here; an invented relationship, an inferred business rule from a name alone,
or a `TBD` is a defect.

## When to use / when not

**Use when:**
- There is a schema, DDL export, versioned migrations, or a read-only connection to a
  database, but no application code worth reading — legacy system, orphaned schema,
  or an app stack you cannot read with confidence.
- Someone asks "what does this database actually model?" / "what domains live in
  these tables?".
- An architecture decision is coming and the existing data model must be recorded as
  a constraint first.
- Application code *does* exist and is readable — then compose: run both this skill
  and `mdpe-code-discovery`, and let each cite the other in their concerns section
  when they diverge. Neither overrides the other.

**Not for:**
- A repository with readable application code as the primary source →
  `mdpe-code-discovery`. This skill is for when a schema is the only reliable source,
  not a substitute when code is legible.
- New product / new strategic cycle → `mdpe-backlog-discovery`.
- Deciding architecture → `mdpe-architecture`. This skill produces a constraint;
  it does not decide from it.
- Decomposing work → `mdpe-tasks` (small item) or `mdpe-transformation` (large
  feature).
- Implementing / validating code → `mdpe-coding`.

**No accessible schema** (empty database, no DDL, no connection, or a scope that only
holds unrelated system tables): answer *"no schema to discover"*, emit **no domains
and no artifact**, and route to `mdpe-code-discovery` (if application code exists) or
`mdpe-backlog-discovery` (greenfield). That is the correct output, not a failure.

## Inputs

| Input | Required | Notes |
|---|:---:|---|
| Schema source (DDL export, read-only connection string, versioned migrations, or a dump) | **Yes** | Missing → ask and stop. A read-only connection is preferable to a stale dump — the schema wins on divergence either way. |
| Scope (schema / database / table subset) | No | Recommended above ~80 tables. Default: the whole accessible schema. |
| Sample data (real rows, even a few) | No | When available, it's the strongest evidence for whether a nullable FK is a real relationship or vestigial. Without it, confidence stays lower. |
| Stated goal | No | Biases reading order, as in `mdpe-code-discovery`. |
| `mdpe-code-discovery` inventory, if it exists | No | Secondary composition input (see *When to use*); never required. |
| Existing data dictionary / documented naming conventions | No | Used to **check**, never to fill — same rule `mdpe-code-discovery` applies to README/docs. |

## Process

### Phase 0 — Preflight

1. Confirm the schema source is reachable and resolve the scope.
2. Count tables/collections in scope.
3. No accessible schema → stop and give the *"no schema to discover"* answer above.
   Do not create the artifact.
4. Capture header facts: `source` (connection description or file, never a stored
   credential), `scope`, `verified_at` (date + branch/commit if the DDL is under
   version control), `depth`.

### Phase 1 — Size the scope (auto-sizing)

Same posture as `mdpe-code-discovery` Phase 1 — depth follows real scope, never a
fixed target. There is no minimum number of domains: three tables observed produce
one or three domains, whichever the foreign keys actually support.

### Phase 2 — Section 1: Engine & version (essential)

DBMS, version, encoding/collation when it matters — from real schema metadata
(`information_schema`, `sys.*`, `pg_catalog`, or the DDL export header). No metadata
and no other evidence → `unknown`, with the reason.

### Phase 3 — Section 2: Entities & relations (essential)

Tables/collections, columns with type and nullability, primary keys, and foreign keys
**with the cardinality the constraint actually declares** — never a "likely"
cardinality invented from naming or row counts alone.

### Phase 4 — Section 3: Observed conventions (essential)

Table/column naming, key strategy (natural vs. surrogate), presence or absence of
audit columns (`created_at`, soft-delete flag). Each convention needs the real
column/constraint that evidences it.

### Phase 5 — Section 4: Reconstructed domain map (essential)

One row per domain the schema encodes. Group tables by strong foreign-key
relationships and a shared semantic name — never by guessed business purpose.

| Field | Rule |
|---|---|
| `id` | `dm-NNN` (*data model*), sequential and stable. Promoted into architecture/backlog, it records `origin: dm-NNN`. |
| `name` | the schema's own name for the group's main entity, never translated into a use case the schema does not declare |
| `description` | one sentence: what the group's tables **store today**, derived from real columns and types |
| `tables` | **≥1 real, verified table. Blocking field**: no real table → the domain is not emitted. |
| `relations` | real foreign keys linking this group to other `dm-NNN`, citing the constraint |
| `confidence` | `high` (PK + FK declared + sample data confirms the pattern) · `medium` (clear structure, no sample) · `low` (name suggests a grouping, FK weak or absent) |
| `gaps` | optional: what the structure alone cannot determine. Mark `unknown`, never fill by deduction. |

### Phase 6 — Conditional sections (only with evidence)

| # | Section | Only when |
|---|---|---|
| 5 | **Views & procedures** | there are views, stored procedures, or triggers in scope — often where legacy business logic hides |
| 6 | **Volume & distribution** | row counts/statistics are accessible; flags a dead table (0 rows) or a dominant one |
| 7 | **Concerns / debt** | there is concrete evidence: an FK with no index, a nullable column the sample never shows null (candidate for an unapplied `NOT NULL`), a table with no primary key, a name that contradicts the observed data |

### Phase 7 — Bridge

Close with the route to the next stage (see *Next skill*), and state plainly which
sections act as the **existing-data-model constraint** (2, 3, 5, 7) for architecture.

## Anti-fabrication rules

Hard rules. Breaking any one fails the quality gate.

1. **Cardinality comes from the constraint, never from assumption.** A nullable FK is
   `0..1` until sampled data with zero nulls upgrades the confidence note — never the
   constraint itself rewritten as `1..1`.
2. **A column name is not confirmed meaning.** No `CHECK`, no documented enum, no
   sample → the value domain is `unknown`.
3. **A table with no FK to another is neither "orphaned" nor "central" by guess.**
   Absence of a declared relation is recorded as absence, never as a judgment about
   the table's importance.
4. **No business rule inferred from a trigger/procedure name without reading its
   body.** Unreadable body (compiled, insufficient permission) → record the existence,
   mark the behavior `unknown` — never summarized from the name.
5. **No schema → no domains.** Never emit a domain map for a scope with no accessible
   schema.
6. **Schema beats documentation, and current evidence beats an old inventory or the
   user's memory of "how it should be."** Divergence goes in section 7, with the
   schema as the truth.

## Output

**One artifact**: `docs/brownfield/data-inventory.md` (or
`docs/brownfield/data-inventory-{scope}.md` for a large schema scope).

```markdown
# Data inventory — {source or scope}

- **source:** {connection description or file — never a credential}
- **scope:** {schema/database/table subset, or "whole accessible schema"}
- **verified_at:** {YYYY-MM-DD} · {branch @ commit, if DDL is versioned}
- **depth:** {S | M | L} ({N} tables in scope)

## 1. Engine & version
| Item | Value | Evidence |
|---|---|---|

## 2. Entities & relations
{tables, columns, types, PKs, FKs with real cardinality}

## 3. Observed conventions
| Convention | Evidence |
|---|---|

## 4. Reconstructed domains
| id | name | description (today) | tables | relations | confidence | gaps |
|---|---|---|---|---|:---:|---|

<!-- sections 5-7 only when there is evidence -->
## 5. Views & procedures
## 6. Volume & distribution
## 7. Concerns / debt

## Next step
{route + how this inventory is consumed}
```

## Assets

- `assets/templates/data-inventory-template.md` — the fill-in skeleton above, with the
  conditional sections marked as removable and the cardinality rule inline.

## Quality gate — "minimum to proceed"

- [ ] Section 1 filled from real schema metadata, or marked `unknown` with the reason.
- [ ] Section 2 reflects real tables and FKs, cardinality from the constraint, not
      assumption.
- [ ] Section 3 lists ≥1 observed convention with the real column/constraint that
      evidences it.
- [ ] Section 4 has **≥1 reconstructed domain** with ≥1 real table and a confidence
      level.
- [ ] No table/column cited is nonexistent; no field contains `TBD` or a placeholder;
      no cardinality or column meaning is presented as certain without the
      constraint/sample that supports it.

A schema with no accessible structure satisfies the gate differently: the *"no schema
to discover"* answer plus the hand-off is the correct output, and no artifact is
created.

**Not required** (full list in `docs/adr/adr-008-data-discovery.md` §5): sample data,
reading application code (composition is additive, never required), sections 5/6
(views/procedures, volume), effort/priority/business-value estimates for
reconstructed domains, exhaustive coverage of a schema with hundreds of tables and no
declared scope, an external ERD or data dictionary.

## Next skill

| Situation after the inventory | Route to | How the inventory is consumed |
|---|---|---|
| New feature or small improvement (~3-25 tasks) | `mdpe-tasks` | `tables` of the touched `dm-NNN` become the tasks' concrete **Reference tables** |
| Large feature / needs an auditable trail | `mdpe-backlog` (optional) → `mdpe-transformation` | fills the *Technical context*; a `dm-NNN` promoted keeps `origin` |
| An architecture decision is in play | `mdpe-architecture` | sections 2, 3, 5 and 7 are a **binding constraint**: the observed data model is the starting point, not a blank sheet |
| Application code also exists and is readable | compose with `mdpe-code-discovery` | both inventories cite each other in their concerns section when they diverge; neither overrides the other |
| Only understanding the domain | done | the inventory is the deliverable |
| No accessible schema | `mdpe-code-discovery` (if code exists) or `mdpe-backlog-discovery` | no domains emitted, no artifact created |

**Staleness:** `verified_at` makes the inventory datable. On resuming, if the schema
changed since `verified_at` (a new migration applied, a table dropped), current
evidence wins and only the affected sections are re-inventoried.
