# Data inventory — {source or scope}

- **source:** {connection description or file path — never a stored credential}
- **scope:** {schema / database / table subset, or "whole accessible schema"}
- **verified_at:** {YYYY-MM-DD} · {branch @ commit, if the DDL is version-controlled}
- **depth:** {S | M | L} ({N} tables/collections in scope)

<!--
Anti-fabrication rules (docs/adr/adr-008-data-discovery.md D6):
1. Cardinality comes from the constraint, never from assumption. Nullable FK = 0..1
   until sampled data with zero nulls says otherwise (note it as evidence, don't
   rewrite the constraint).
2. A column name is not confirmed meaning. No CHECK/enum/sample -> value domain is
   "unknown".
3. A table with no FK to another is neither "orphaned" nor "central" by guess.
4. No business rule inferred from a trigger/procedure name without reading its body.
   Unreadable body -> record existence, mark behavior "unknown".
5. No accessible schema -> no domains, no artifact.
6. Schema beats documentation and beats the user's memory of "how it should be".
-->

## 1. Engine & version

| Item | Value | Evidence |
|---|---|---|
| DBMS | | |
| Version | | |
| Encoding / collation | | |

## 2. Entities & relations

<!-- One block per table, or a compact table if the schema is small. Every FK cites
     the real constraint name and its declared cardinality — not an inferred one. -->

### {table_name}

| Column | Type | Nullable | Key |
|---|---|:---:|---|

**Foreign keys:**

| Constraint | Column(s) | References | Cardinality (as declared) |
|---|---|---|---|

## 3. Observed conventions

| Convention | Evidence (real column/constraint) |
|---|---|

## 4. Reconstructed domains

| id | name | description (what it stores today) | tables | relations | confidence | gaps |
|---|---|---|---|---|:---:|---|
| dm-001 | | | | | high / medium / low | |

<!-- Sections 5-7: only when there is concrete evidence. Do not create an empty
     section to look thorough. -->

## 5. Views & procedures

<!-- Only if views/procedures/triggers exist in scope. For each: name, whether the
     body was readable, and behavior only if the body was actually read — otherwise
     mark "unknown". -->

## 6. Volume & distribution

<!-- Only if row counts/statistics are accessible. Flag dead tables (0 rows) or
     dominant ones. -->

## 7. Concerns / debt

<!-- Only with concrete evidence: FK with no index, nullable column the sample never
     shows null, table with no primary key, name contradicting observed data,
     divergence from an existing data dictionary (schema wins). -->

## Next step

{Route to mdpe-tasks / mdpe-backlog+mdpe-transformation / mdpe-architecture, and how
this inventory is consumed — see SKILL.md "Next skill" table. If application code
also exists and is readable, note composition with the mdpe-code-discovery inventory
here.}
