---
name: refactor-health
description: Run the mandatory Phase 0 refactor-health and architectural-fit review before functional planning or feature work. Use when an agent needs to assess whether current code seams are healthy enough for the next wave, identify oversized files, weak boundaries, coupled async/UI state, CSS sprawl, duplicated logic, bending contracts, obsolete prerelease paths, required prep refactors, and explicit guardrails before deeper SDLC planning.
---

# Refactor Health

Use this skill for mandatory Phase 0 in the SDLC loop.

This is not implementation and not feature planning. It is an architecture-fit gate that answers whether the repo is healthy enough to proceed directly, needs bounded prep refactors, or should pause for a standalone refactor before product work deepens.

It is okay, and often correct, to spend meaningful time here before feature work. Do not rush past this phase just because the user is eager to build the feature.

## Required Context

Before assessing:

- read the repo-level `AGENTS.md` if present
- read the repo workflow doc if present, such as `docs/dev-workflow.md`
- read the most relevant architecture, contract, UX, or existing plan docs for the request
- inspect the current code seams that the upcoming work will touch
- identify the currently supported FE-facing or external contract that still matters
- run a concrete file-size and hotspot audit for the target area before making the Phase 0 decision
- inspect likely duplicate orchestration, async refresh, data mapping, validation, formatting, and UI-state patterns in and around the target area

## Mandatory Hotspot Audit

Phase 0 must include evidence, not only judgment. Before choosing a decision, produce a short hotspot table for the target area and any obviously related shared seams.

The table must include:

- file path
- approximate line count
- current responsibility
- why the upcoming wave is likely to touch it
- health classification: `healthy`, `watch`, `hotspot`, or `stop-and-refactor`
- proposed action: leave alone, guardrail, extract, split, delete obsolete path, or pause for standalone refactor

Use repo-appropriate commands or tools to gather line counts and duplicate-pattern evidence. Prefer fast local search. Examples include counting lines for relevant source files, listing the largest files under the touched package, and searching for repeated function names, async refresh flows, duplicated mapping blocks, repeated API calls, repeated selectors, repeated CSS classes, or duplicated state transitions.

Default size guidance:

- under roughly 300 lines: usually healthy if responsibility is clear
- 300-500 lines: `watch`; do not add unrelated responsibility
- 500-800 lines: `hotspot`; touching it should usually include an extraction, split, deletion, or explicit no-growth guardrail
- over 800 lines: `stop-and-refactor` unless the file is generated, declarative data, or there is a concrete reason a bounded slice cannot safely reduce it first

These are heuristics, not a substitute for judgment. A 250-line file can still be unhealthy if it mixes ownership boundaries; a 900-line declarative fixture may be acceptable. When deviating from the size guidance, explain why.

## No Net Worsening Rule

Phase 0 should protect the architecture trend, not merely permit the next feature.

- do not approve a wave that adds meaningful responsibility to an existing hotspot without an extraction, deletion, split, or explicit containment plan
- if the wave must touch a hotspot, prefer making the first implementation slice a bounded prep refactor
- if a touched file is already above the hotspot threshold, the plan should reduce responsibility, reduce duplication, or prevent line-count growth in that file
- if the agent chooses `Proceed directly`, it must explain why the target files are not hotspots and why the wave will not increase coupling, duplication, or ownership ambiguity
- guardrails must be concrete enough to enforce in code review, for example "do not add another refresh branch to `X`; extract `Y` first" rather than "keep this clean"
- deletion of obsolete prerelease paths counts as architecture improvement and should be preferred over preserving unused compatibility paths

## Assessment Areas

Inspect for:

- oversized files or modules that should not absorb more responsibility
- weak ownership boundaries
- duplicated logic or repeated orchestration patterns
- CSS sprawl or UI state/copy/styling coupling
- coupled async state and product state
- API contracts or data contracts that are bending under new requirements
- obsolete prerelease paths that should be deleted instead of extended
- hidden dependencies that could make implementation slices risky
- test seams that are too weak to support safe TDD
- files whose line count or responsibility has grown enough that feature work should first split or extract them
- places where the upcoming wave would make the same async, mapping, validation, or UI-state pattern appear a third time

## Decision

Choose one:

- `Proceed directly`
  - the seams are healthy enough
  - the hotspot audit does not identify a target-area hotspot that would absorb more responsibility
  - name concrete guardrails
- `Proceed with bounded prep refactors`
  - feature work can continue, but specific enabling extractions or cleanup must be included in early slices
  - name those prep refactors
  - use this by default when the wave touches a hotspot that can be improved with a small extraction before feature behavior changes
- `Pause for standalone refactor`
  - the target seam is too weak or too coupled to safely plan the feature
  - describe the refactor outcome needed before restarting product planning
  - use this when the target area has stop-and-refactor files, pervasive duplication, unclear ownership, or weak tests that would make feature slices compound the problem

Prefer small enabling extractions over broad rewrites, but do not preserve poor prerelease seams just because they already exist. A Phase 0 decision should bias toward improving the architecture trend, not merely avoiding a catastrophe.

## Model Routing

For each material Phase 0 iteration, run both a TPM review pass and an architect review pass before allowing functional planning to start.

- reuse the same refinement-wave TPM and architect reviewers by default instead of spawning fresh planning reviewers each iteration
- if the refinement reviewers already exist from requirements discovery, send the Phase 0 findings and delta to those same reviewers instead of spawning new reviewers
- optionally include the persistent DBA or UX reviewer from discovery when the Phase 0 risks materially involve data architecture, persistence, UX seams, accessibility, or interaction design
- do not close the refinement reviewers at the end of Phase 0; keep them open for functional-plan, technical-plan, and execution-plan review unless replacement is explicitly justified
- when delegated review is available, use `frontier-review` for both refinement review passes

Record the review model used and whether the persistent refinement reviewer was reused or replaced in the Phase 0 assessment when a delegated review is used.

## Required Output

Produce a written Phase 0 assessment in chat or the active repo planning artifact:

- hotspot audit table with file paths, approximate line counts, health classification, and proposed action
- duplicate-pattern notes, including searches performed or concrete repeated patterns found
- inspected seams and files
- health/fit decision
- required prep refactors, if any
- explicit guardrails for where not to add complexity
- no-net-worsening statement that says how the wave will reduce, contain, or avoid worsening hotspots
- obsolete or deprecated paths to remove instead of extend
- relevant risks that must carry into functional, technical, or execution planning
- planning-doc commit hash for the Phase 0 artifact update, if a repo doc was changed
- delegated review model and escalation reason, if any

## Planning Artifact Commit

If Phase 0 creates or updates repo docs, commit those doc changes before exiting the phase.

- check the worktree before editing and note unrelated existing changes
- stage only the Phase 0 planning docs touched by this phase
- do not stage source code, generated files, lockfiles, or unrelated user/agent changes
- if the worktree is already dirty, leave unrelated changes alone and commit only the explicit planning-doc paths touched by Phase 0
- use a clear message such as `docs: add phase 0 refactor-health audit`
- record the commit hash in the planning artifact or progress log
- if committing is impossible, report the blocker and the exact dirty doc paths

## Exit Criteria

Do not allow functional planning to start until:

- Phase 0 has been marked complete
- the hotspot audit has been completed with concrete file sizes and classifications
- duplicate patterns and repeated orchestration paths have been checked in the target area
- the health/fit decision is explicit
- every material Phase 0 iteration has had both TPM and architect review passes, or an explicit blocker is reported
- required prep refactors are named before feature planning deepens
- guardrails are carried forward into the next planning artifact
- the no-net-worsening statement is carried forward into the functional, technical, or execution plan
- Phase 0 planning-doc changes are committed, or an explicit blocker is reported with the dirty doc paths
- unresolved architecture questions are either answered or clearly flagged for the user
