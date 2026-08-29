# Status report — {project name} — {YYYY-MM-DD}

<!--
Traffic-light decision tree (docs/adr/adr-009-status-report.md D4) — first match wins:
  RED    - a blocked micro-task with no resolved route, or an open cross-feature cycle.
  YELLOW - an unavailable/in-development external dependency on the critical path,
           reduced parallelism with a named reason, or >=2 loop overruns since the
           last report.
  GREEN  - none of the above.
Never pick a color by feel. The signal that produced it goes in the appendix below.

Hard rule: no mt-XXX-YYY, ad-NNN, feat-XXX, or file path anywhere in the body above
the appendix. Translate to plain language; the id goes in the appendix row only.
-->

## {🟢 On track | 🟡 At risk | 🔴 Blocked}

{One sentence: the reason, in plain language.}

## Accomplished

<!-- Cite CHANGELOG.md entries for this period if mdpe-release cut a version;
     otherwise derive from mdpe-tracking.yml using the completed+validated+artifact
     evidence triple, grouped by feature. -->

- {one line, product language}

## In progress

<!-- Feature names only, never micro-task ids. -->

- {one line, product language}

## Risks & blockers

<!-- Translate, never cite raw. State explicitly what is needed from the reader,
     when something is needed. This skill never resolves a blocker itself. -->

- {one line, plain language} — needs: {what's needed from the reader, or "nothing — informational"}

## Next

<!-- Translate mdpe-graph's dispatch answer (what runs in the next open wave) into
     feature names and plain language. -->

- {one line, plain language}

---

## Appendix — provenance

<!-- One row per claim made above. No claim without a row; no row without a claim. -->

| Claim | Artifact → field | Technical id |
|---|---|---|
| | | |
