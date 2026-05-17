---
name: technical-plan
description: Create and review the technical architecture and gap-analysis plan for prerelease product work after the functional plan is stable. Use when the user wants architecture boundaries, codebase fit, technical tradeoffs, test strategy, and cleanup decisions defined before execution planning.
---

# Technical Plan

Use this skill after the functional plan is reviewed.

## Rules

- map the approved functional plan onto the current codebase
- define affected seams, ownership boundaries, data flow, contract implications, technical tradeoffs, and test strategy
- convert contract, boundary, invariant, and forbidden-state decisions into explicit Technical AC
- identify prep refactors that should happen before feature work
- carry forward the Phase 0 hotspot audit, including file-size classifications, duplicate-pattern findings, and the no-net-worsening statement
- for every touched `hotspot` or `stop-and-refactor` file, define the extraction, split, deletion, containment rule, or reason feature work must pause
- do not allow the technical plan to add responsibility to a Phase 0 hotspot without a concrete architecture-improvement or containment decision
- in prerelease work, prefer durable architecture over compatibility-preserving accretion
- explicitly state what deprecated paths will be removed
- explicitly state what migration scripts and compatibility layers are intentionally not being created
- write or update the technical plan in the repo planning artifact
- commit technical-plan doc changes before leaving this phase when the repo workflow permits commits; otherwise report the blocker and dirty doc paths
- on every material technical-plan iteration, run both a TPM review pass and an architect review pass before moving on
- reuse the same refinement-wave TPM and architect reviewers by default instead of spawning fresh planning reviewers each iteration
- if the refinement reviewers already exist from earlier phases, send the technical-plan delta to those same reviewers instead of spawning new reviewers
- optionally include the persistent DBA reviewer when the technical plan touches database shape, migrations, indexing, query performance, persistence semantics, reporting, analytics, or data integrity
- optionally include the persistent UX reviewer when technical decisions affect user-facing state, accessibility, interaction boundaries, content behavior, or visual implementation risk
- do not close the refinement reviewers at the end of technical planning; keep them open for execution-plan review unless replacement is explicitly justified
- when delegated technical-plan review is available, use `frontier-review` for both refinement review passes
- keep technical-plan output concise: prefer concrete decisions, boundaries, tradeoffs, and unresolved risks over explanatory narration

## Technical Acceptance Criteria

The technical plan must include Technical AC as first-class pass/fail criteria, separate from implementation notes.

Technical AC should cover applicable:

- FE/backend, route, schema, payload, and persistence contracts
- ownership boundaries and module responsibility
- invariants that must remain true before and after the slice
- forbidden states and forbidden data-flow crossings
- obsolete prerelease paths to delete instead of extend
- compatibility layers, migrations, or adapter code that must not be introduced unless explicitly approved

Every Technical AC must be precise enough for an architect reviewer to check against a diff, targeted tests, and affected files without re-deriving the intended architecture.

Each Technical AC must name the boundary where signoff must happen. For example, if the AC promises provider model selection, API route behavior, persistence, notification delivery, billing effect, sync outcome, FE/backend contract behavior, or permission enforcement, the AC must require service/API-level, integration, or end-to-end proof rather than only helper-level proof unless a reviewer explicitly accepts narrower proof and records why.

## Planning Artifact Commit

If this phase creates or updates repo docs, commit those doc changes before exiting the phase when the repo workflow permits commits.

- check the worktree before editing and note unrelated existing changes
- stage only the technical-plan docs touched by this phase
- do not stage source code, generated files, lockfiles, or unrelated user/agent changes
- if the worktree is already dirty, leave unrelated changes alone and commit only the explicit planning-doc paths touched by this phase
- use a clear message such as `docs: add technical plan` or `docs: update technical plan`
- record the commit hash in the planning artifact or progress log
- if committing is impossible, report the blocker and the exact dirty doc paths

## Exit Criteria

- the technical plan is concrete enough that execution planning does not need to improvise architecture
- Technical AC are explicit and pass/fail, not just design rationale
- Phase 0 hotspot findings are either converted into prep refactors, explicit non-growth guardrails, deletion work, or a documented pause decision
- the plan states how the wave avoids making oversized files, duplicated flows, weak seams, or ownership ambiguity worse
- review findings are incorporated or explicitly flagged
- every material technical-plan iteration has had both TPM and architect review passes, or an explicit blocker is reported
- delegated technical-plan review records the model used and whether the persistent refinement reviewer was reused or replaced
- any still-supported external contract that constrains the wave is named explicitly
- any forbidden state or cross-boundary behavior discovered during technical planning is captured as Technical AC or Negative AC before execution planning begins
- Technical AC are explicit enough to become final AC verification matrix rows with exact expected behavior, proof depth, and reviewer signoff status
- technical-plan doc changes are committed, or an explicit blocker is reported with the dirty doc paths
