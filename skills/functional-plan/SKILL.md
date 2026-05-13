---
name: functional-plan
description: Create and review the high-level functional plan for prerelease product work after requirements are confirmed. Use when the user wants scope, Product AC, Negative AC, UX-critical flows, edge cases, and a high-level test plan documented before technical planning begins.
---

# Functional Plan

Use this skill after requirements, Product AC, and Negative AC are confirmed.

## Rules

- inspect the current code and relevant repo docs before planning
- define the desired user outcome, scope, out-of-scope boundaries, Product AC, Negative AC, UX-critical flows, edge cases, and high-level test plan
- make the plan reflect the current implementation, not assumptions
- write or update the functional plan in the repo planning artifact when this phase is part of an SDLC wave
- commit functional-plan doc changes before leaving this phase
- if the work is UX-facing, think like a principal product designer and frontend architect
- on every material functional-plan iteration, run both a TPM review pass and an architect review pass before moving on
- reuse the same refinement-wave TPM and architect reviewers by default instead of spawning fresh planning reviewers each iteration
- if the refinement reviewers already exist from earlier phases, send the functional-plan delta to those same reviewers instead of spawning new reviewers
- optionally include the persistent UX reviewer when the functional plan is user-facing, interaction-heavy, accessibility-sensitive, or content/flow-sensitive
- optionally include the persistent DBA reviewer when functional behavior depends on data visibility, reporting, analytics, data-entry integrity, or persistence semantics
- do not close the refinement reviewers at the end of functional planning; keep them open for technical-plan and execution-plan review unless replacement is explicitly justified
- when delegated plan review is available, use `frontier-review` for both refinement review passes
- if review changes scope, behavior, Product AC, or Negative AC in a meaningful way, bring that back to the user
- keep plan output concise: prefer decisions, constraints, Product AC, Negative AC, and unresolved items over prose-heavy rationale

## Acceptance Criteria Shape

The functional plan must separate:

- Product AC: user-visible outcomes written in plain language
- Negative AC: explicit must-not-happen cases, including permission, privacy, stale-state, confusing UX, or wrong-surface behavior

Each Product AC and Negative AC must be phrased as a pass/fail check. Do not bury acceptance criteria in narrative paragraphs.

## Planning Artifact Commit

If this phase creates or updates repo docs, commit those doc changes before exiting the phase.

- check the worktree before editing and note unrelated existing changes
- stage only the functional-plan docs touched by this phase
- do not stage source code, generated files, lockfiles, or unrelated user/agent changes
- if the worktree is already dirty, leave unrelated changes alone and commit only the explicit planning-doc paths touched by this phase
- use a clear message such as `docs: add functional plan` or `docs: update functional plan`
- record the commit hash in the planning artifact or progress log
- if committing is impossible, report the blocker and the exact dirty doc paths

## Exit Criteria

- the functional plan exists
- the user has had a chance to react to it
- review findings are incorporated or explicitly flagged
- every material functional-plan iteration has had both TPM and architect review passes, or an explicit blocker is reported
- any delegated review records the model used and whether the persistent refinement reviewer was reused or replaced
- open questions that affect scope, Product AC, or Negative AC are resolved or explicitly marked for follow-up
- Product AC and Negative AC are explicit enough to become trace-table rows during execution planning
- functional-plan doc changes are committed, or an explicit blocker is reported with the dirty doc paths
