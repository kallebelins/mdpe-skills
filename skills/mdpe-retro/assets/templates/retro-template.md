# Retro — {scope description} — {YYYY-MM-DD}

<!--
Rules (docs/adr/adr-010-cycle-retro.md):
- Scope is always declared by the user (date range, feat-XXX set, or "since the last
  retro") — never inferred.
- Every bullet below cites the lesson (ls-NNN) or the tracking field that supports
  it. No impression of "how the cycle felt" without a citation.
- Every action item has an owner filled in, even if it's literally "to be defined".
  Never leave it blank.
- No bullet attributes a failure to a person. Findings are about the work/process,
  never about who executed it.
- Trend section only exists when a prior retro over the same scope type exists.
-->

**Scope:** {date range, feature set, or "since the last retro on {date}"}

## What went well

<!-- Confirmed/retired (graduated) lessons in scope, and micro-tasks closed i1 with
     no finding above Nitpick. -->

- {bullet} — evidence: `ls-NNN` | `mdpe-tracking.yml:{field}`

## What to improve

<!-- Confirmed-but-not-graduated lessons, loop overruns, recurring blocker/major
     findings in scope. -->

- {bullet} — evidence: `ls-NNN` | `mdpe-tracking.yml:{field}`

## Action items

<!-- One action per "what to improve" item with enough evidence to be actionable.
     Target is one of mdpe-learnings' three existing feedback targets — never a
     fourth one. -->

| Action | Target | Owner | Horizon |
|---|---|---|---|
| | Discovery / Transformation / Next executions | {name/role, or "to be defined"} | immediate / short term / long term |

## Trend

<!-- Only include this section if a prior retro over the same scope type exists.
     Counts before ratios; a ratio always carries its denominator. Delete this
     section entirely if there is no prior retro to compare against — do not
     invent a trend from a single data point. -->

- {metric}: {count this cycle} vs {count in previous retro on {date}}
