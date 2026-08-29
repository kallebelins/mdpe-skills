# Changelog

All notable changes to this project are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/) — reverse chronological order, one
section per version, categories below. **A published version section is never
rewritten**; a correction becomes a new entry in a later version.

Every entry names the `feat-XXX` it traces to. A hidden HTML comment under each entry
lists the `completed`, evidenced micro-tasks behind it — not rendered, present for
anyone who wants to verify the line against `docs/tracking/mdpe-tracking.yml`.

<!--
Category rules (docs/adr/adr-007-release-notes.md D5):
- Added        -> feat-XXX's first appearance in any version of this file.
- Changed      -> feat-XXX already appeared before, or evidence for a stronger
                  category (Fixed/Security/Deprecated/Removed) is not citable.
                  This is the safe default: nothing is upgraded to a stronger
                  category without its required citation.
- Fixed        -> qualifying micro-task's -learnings.yml is "problems", or its
                  originating code review had a blocker/major finding.
- Security     -> the implemented ad-NNN cites a verifiable security concern in
                  drivers[].evidence (literal citation required).
- Deprecated / Removed -> an ad-NNN implications[] entry covers it, cited by id.

Never write an entry for a micro-task that is not completed AND validated
(approved / approved_with_reservations) AND has fidelity.declared_outputs[].exists:
true. Missing any one of the three -> excluded from this release, not "in progress".
-->

## [Unreleased]

<!-- Micro-tasks completed and evidenced since the last cut, not yet in a numbered
     version. Empty when nothing qualifies — do not create this section preemptively. -->

## [X.Y.Z] - YYYY-MM-DD

### Added
- <one line, product language, present tense — what the user can now do> (`feat-XXX`)
<!-- feat-XXX: mt-XXX-001, mt-XXX-002 (completed, validated) -->

### Changed
- <one line, product language> (`feat-XXX`)
<!-- feat-XXX: mt-XXX-003 (completed, validated) -->

### Deprecated
### Removed
### Fixed
- <one line, product language> (`feat-XXX`)
<!-- feat-XXX: mt-XXX-004 (completed, validated) -->

### Security

<!-- Omit any category heading with no qualifying entry in this version. Do not
     leave an empty "### Fixed" just to show the section exists. -->
