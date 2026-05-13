---
name: requirements-discovery
description: Run the requirements and acceptance-criteria discovery phase for prerelease product work. Use when the user has a rough feature, bug, UX change, refactor, or problem statement and wants an agent to act like a PM, principal architect, or UX lead to clarify the request through an explicit back-and-forth conversation before planning or coding begins.
---

# Requirements Discovery

Use this skill only for discovery and alignment. Do not plan implementation and do not write code while this skill is active.

## Rules

- start with an explicit back-and-forth conversation
- restate the request in your own words
- ask focused follow-up questions when requirements, edge cases, constraints, stakeholders, UX expectations, Product AC, Negative AC, or obvious Technical AC are ambiguous
- prefer a short iterative conversation over silent assumptions
- if the repo is prerelease, optimize for the best durable outcome rather than preserving obsolete internal shapes
- keep a persistent refinement review bench by default: one TPM reviewer and one architect reviewer for the whole refinement wave
- reuse those same refinement reviewers across requirements, Phase 0, functional-plan, technical-plan, and execution-plan iterations unless context is stale, the design changed materially, independence is in doubt, or risk escalates
- if those refinement reviewers do not exist yet, create them once when the first material refinement review is needed; if they already exist, send this phase's delta to the existing reviewers instead of spawning fresh reviewers
- optionally add a persistent DBA or UX reviewer when the work materially needs database or user-experience expertise; reuse that specialist across the relevant refinement phases instead of spawning fresh specialist reviewers
- do not close the refinement reviewers at the end of discovery; keep them open for Phase 0, functional-plan, technical-plan, and execution-plan review unless replacement is explicitly justified
- when delegated review tooling is available, use `frontier-review` for both the TPM reviewer and the architect reviewer during refinement
- do not begin planning or coding until the user has confirmed the refined problem statement, Product AC, and Negative AC, unless the user explicitly says to proceed with stated assumptions
- if this phase creates or updates a repo requirements/checkpoint doc, commit those doc changes before leaving discovery
- keep discovery output concise: ask only the smallest set of questions needed, avoid explaining each question, and end with a compact checkpoint instead of a long recap

## Required Output

Produce a requirements checkpoint the user can approve:

- refined problem statement
- in-scope and out-of-scope boundaries
- Product AC: user-visible outcomes written in plain language
- Negative AC: explicit must-not-happen cases, especially privacy, permission, data visibility, contract, and UX-regression failures
- early Technical AC notes when a contract, boundary, invariant, or forbidden state is already known
- open questions, assumptions, and risks

Do not leave acceptance criteria as general intent. Each Product AC and Negative AC should be phrased as a pass/fail statement that a TPM or acceptance reviewer can verify without reinterpreting the feature.

## Planning Artifact Commit

If discovery creates or updates repo docs, commit those doc changes before exiting the phase.

- check the worktree before editing and note unrelated existing changes
- stage only the requirements/checkpoint docs touched by this phase
- do not stage source code, generated files, lockfiles, or unrelated user/agent changes
- if the worktree is already dirty, leave unrelated changes alone and commit only the explicit planning-doc paths touched by this phase
- use a clear message such as `docs: add requirements checkpoint` or `docs: update requirements checkpoint`
- record the commit hash in the planning artifact or progress log
- if committing is impossible, report the blocker and the exact dirty doc paths

## Exit Criteria

- the user has seen the refined problem statement
- the user has seen the proposed Product AC and Negative AC
- any known Technical AC notes are either captured for technical planning or explicitly marked unresolved
- any material refinement iteration has had both TPM and architect review passes, or an explicit blocker is reported
- the user has confirmed them or explicitly asked you to proceed with named assumptions
- any requirements/checkpoint doc changes are committed, or an explicit blocker is reported with the dirty doc paths
- if that confirmation has not happened yet, remain in discovery
