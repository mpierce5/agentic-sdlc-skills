---
name: slice-implement
description: Implement exactly one reviewed execution-plan slice for prerelease product work. Use when the user wants one slice executed with tests-first expectations, a review/fix loop before broad verification, targeted verification after review is clean, immediate commit after the slice is green, and no batching of multiple slices into one commit.
---

# Slice Implement

Use this skill for exactly one slice at a time.

## Rules

- do not re-plan the whole project
- keep coding in the primary implementation agent by default; do not spawn a separate coding agent unless the task is isolated, non-critical-path, and has a clear disjoint write scope
- write or update the planned failing tests first
- before coding, identify the slice's assigned Product AC, Technical AC, Negative AC, trace-table rows, and expected AC coverage verdict from the execution plan
- implement the smallest coherent change for the slice
- reuse valid cached file summaries, plan excerpts, and prior test results from the active planning/progress artifact instead of re-reading unchanged files or logs
- refresh only stale cache entries whose source files, commands, or commits changed
- during coding iterations, run focused checks that directly cover the code being changed, such as one unit test, one targeted pytest/vitest test, a touched-file typecheck, or formatting/syntax checks
- treat these as focused checks, not as the broad verification pass
- when tests, browser checks, or commands emit large output, capture a compact summary with the exact failing test names, files, endpoints, or error lines before asking another agent to reason about it
- do not trigger broad diff analysis or repeated browser verification during implementation unless a concrete failure requires that escalation
- do not run broad suites, full repo tests, or wide regression verification after every small review-finding fix
- run focused checks before routine slice review when they help tighten the next review/fix loop
- run one combined slice review before slice-level targeted verification
- pass the combined reviewer the compact AC/TAC packet for this slice rather than only a general plan excerpt
- fix review findings and re-review with the same reviewers until there are no blocking findings, findings are accepted as no-fix, or findings are explicitly deferred
- after the review/fix loop is clean, run only the narrowest meaningful targeted verification for this slice unless this slice is explicitly marked as the final slice or a wave-level verification gate
- do not run the full repo suite, broad regression set, or wave-level verification on intermediate slices unless the execution plan explicitly marks that slice as the verification gate
- if targeted verification fails, fix the failure and repeat review/fix before rerunning the targeted verification; only widen to broad or full-suite verification when the plan says this is the final slice or verification gate
- update the relevant docs for the slice
- commit immediately after the slice is review-clean and green
- do not batch multiple slices into one commit
- after committing, record the `$slice-review` results and use the review model tiers recorded in the execution plan instead of allowing review sub-agents to inherit the implementation model
- record the reviewer's AC coverage verdict: `complete`, `partial`, `not applicable`, or `blocked`, plus any uncovered AC ids and follow-up gate
- while review sub-agents run, continue with review-independent prep named in the execution plan when it is safe; do not start or commit the next risky slice until prior review findings are resolved, accepted as no-fix, or explicitly deferred
- in prerelease work, do not add migration scripts or compatibility code unless the user explicitly asks for them or a still-supported contract truly requires them
- prefer removing deprecated code over extending it
- keep implementation output concise: report changed files, focused checks, blockers, and the next action; do not write an implementation diary

## Verification Batching

Focused checks during coding are expected. Broad verification is deliberately delayed until the review/fix loop is clean.

- run focused tests/checks while editing when they directly cover the code under change
- treat focused checks as implementation feedback, not as the slice's final verification
- run one combined review before targeted slice verification
- after review findings are fixed or triaged, run the planned targeted verification for the slice
- run broad regression checks or full-suite commands only when the execution plan marks this slice as the final slice or an explicit wave-level verification gate
- keep browser or Playwright verification to one clean pass per target view by default; repeat only if the first pass fails or code changed again
- if targeted verification fails, fix the failure, then return to review/fix before rerunning targeted verification when the fix materially changes product code, contracts, tests, or architecture
- if a verification fix is purely mechanical and cannot affect behavior, rerun only the failed verification first, then widen as needed

## Review Concurrency

Avoid idle time while review sub-agents are running, but do not stack risky commits ahead of unresolved findings.

- immediately continue with review-independent work only when the execution plan names it as safe
- allowed work may include reading next-slice context, updating planning docs, preparing a test checklist, inspecting files, running harmless verification, or doing explicitly non-overlapping low-risk prep
- do not commit the next risky slice until the prior slice review has returned and findings are resolved, accepted as no-fix, or explicitly deferred
- do not make next-slice implementation changes that would be invalidated by likely review findings from the previous slice
- if review findings arrive while other work is in progress, pause at the next safe point and triage whether to finish, adjust, or discard the in-progress work



## State Updates

If the repo uses `.sdlc/state.json`, update it as a small execution index while preserving the existing slice loop.

- at slice start: set phase `slice-implement`, slice id, status `in_progress`, and changed `none`
- after tests-first edits: set changed `tests` when tests were added or changed
- after product-code edits: set changed `code`
- before review: set status `review_pending` and verification status `not_run` or `focused_passed`
- after same-slice findings are fixed or triaged: keep the same slice id and reviewer lifecycle state current
- after review-clean plus required verification: set status `green` and record the slice commit
- if a finding is accepted as no-fix or explicitly deferred, record that status in state and the durable progress doc

Do not use state to skip required combined slice review, targeted slice verification, or the final planned wave-level verification gate. State only prevents redoing work that is already review-clean, green, and unchanged.
## Exit Criteria

- one slice is review-clean and green
- that slice has its own commit
- verification for that slice is recorded after the review/fix loop
- AC coverage verdict is recorded with Product AC, Technical AC, and Negative AC rows that were checked or intentionally deferred
- updated test-result and file-summary cache entries are recorded when relevant
- the combined review result is recorded with the explicit planned review model
- any concurrent prep is recorded and does not stack a risky commit ahead of review resolution
