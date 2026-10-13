---
name: slice-implement
description: "Implement one approved Full execution-plan slice or accepted Light/Defect compact change through independent LLM review, targeted outcome proof, cleanup, and a coherent commit."
---

# Slice Implement

## Mode-specific input and review status

Full is the default and uses the reviewed execution plan. Light/Defect use the
accepted compact packet defined by `$sdlc`: scope, outcome/negative/technical AC
with proof boundaries, existing seam/owner, targeted checks, and cleanup
expectation. For Defect also require observed failure, established expected
behavior, diagnosis, and regression proof. That packet replaces separate plan,
trace, and final matrix inputs throughout this skill; missing Full-only artifacts
are not blockers. One task owns this coherent change through requested closeout.
No separate planning bench, retirement slice, state file, or execution task is
required solely for a bounded mode.

Full keeps planned tests-first work. Bounded logic changes use meaningful new or
existing affected tests; a defect should have proof detecting the original
failure. Copy/spacing changes may use focused visual/manual verification without
invented unit tests. Keep cleanup local to the change and include it in the
combined final LLM review.

Use independent LLM code/architecture/cleanup review before targeted verification,
except for the repo's authorized exact-row-first provider repair loop. Record
code-review CLEAN separately from acceptance pending/verified. After proof passes,
the same reviewer inspects its summary to verify AC; do not repeat the whole diff
review unless a material fix changed it. Commit only after required review and
proof are complete. Humans review AC or support unresolved design/architecture
decisions, never as a mandatory code-review or routine implementation gate.
Mode selection does not authorize merge/deployment/provider calls; perform only
the requested closeout with the applicable repo safeguards.

Use this skill for exactly one slice at a time.

For orchestrated multi-slice waves, one invocation is also one visible
top-level slice-owner task by default. Shared branch/worktree ownership does not
silently extend task ownership into the next substantive slice. A multi-slice
task is allowed only when the accepted plan explicitly records
`single-task-wave-owner` and its rationale.

## Rules

- do not re-plan the whole project
- keep coding in the primary implementation agent by default; do not spawn a separate coding agent unless the task is isolated, non-critical-path, and has a clear disjoint write scope
- in Full, write or update the planned failing tests first; in Light/Defect, use
  the meaningful regression or outcome proof specified by the compact packet
- before coding, identify assigned Product/Technical/Negative AC and expected
  coverage from the accepted plan or compact packet; trace-table rows apply only to Full
- identify the mode-specific AC/proof record: Full's final verification matrix
  or Light/Defect's compact table, including expected outcome, proof depth, and signoff
- identify cleanup expectations: inline cleanup for Light/Defect, or the Full
  plan's slice/terminal retirement expectations
- for a legacy-to-golden conversion, add mandatory AC to inventory legacy
  runtime/test/fixture/helper/compatibility/assertion surfaces, replace their
  coverage with approved replacement-path proof, delete superseded paths, and give
  every retained legacy-named surface an explicit distinct purpose plus
  non-bypass proof
- implement the smallest coherent change for the slice
- reuse valid cached file summaries, plan excerpts, and prior test results from the active planning/progress artifact instead of re-reading unchanged files or logs
- refresh only stale cache entries whose source files, commands, or commits changed
- during coding iterations, run focused checks that directly cover the code being changed, such as one unit test, one targeted pytest/vitest test, a touched-file typecheck, or formatting/syntax checks
- treat these as focused checks, not as the broad verification pass
- when tests, browser checks, or commands emit large output, keep the raw output
  local and gitignored; capture only a compact formal summary with exact failing
  test names, files, endpoints, or error lines
- do not trigger broad diff analysis or repeated browser verification during implementation unless a concrete failure requires that escalation
- do not run broad suites, full repo tests, or wide regression verification after every small review-finding fix
- run focused checks before routine slice review when they help tighten the next review/fix loop
- run one combined slice review before slice-level targeted verification
- pass the combined reviewer the compact AC/TAC packet for this slice rather than only a general plan excerpt
- pass the reviewer the mode-specific AC/proof rows, expected behavior, proof
  depth, available evidence, and unchecked/deferred notes
- fix review findings and re-review with the same reviewers until there are no blocking findings, findings are accepted as no-fix, or findings are explicitly deferred
- treat safe, self-contained defects revealed by the slice or review as owned
  repair work even when they expand beyond the initial file list; record the
  justified scope expansion, fix it, rerun affected proof, and re-review
  before reporting a blocker
- do not escalate a shared seam merely because it crosses an initially named
  file boundary; escalate only for an active lock conflict, an unsafe/broad
  change outside the slice's reviewable scope, or a genuine human
  product/architecture decision
- do not run LLM/provider tests as part of the standard suite. Run only impacted
  rows when the user authorizes them, the accepted plan requires them, or the
  change is materially model/provider-dependent and deterministic proof cannot
  establish the boundary
- for an authorized failed LLM scenario, presume a behavior named in the approved scenario
  plan is supported and harden the generic path: audit lookup/authority facts,
  template and adapter eligibility, contract/slot shape, provider-agnostic
  prompts, and required execution/persistence/hydration proof; repair the
  code and immediately rerun the exact failed row through the maintained
  runner's built-in guards until green, then run the complete fresh configured
  unseen group on the candidate branch rather than broadening the test to
  accept the failed choice; obtain one final review of the completed live-green
  diff instead of reviewing between retries or before unseen qualification
- for authorized provider qualification, use the accepted track's repo-approved
  provider/profile and maintained runner guards. Do not run a separate
  deterministic command before transport; other providers require an explicit
  comparison scope and never become a hidden prerequisite.
- treat an authorized LLM/provider row as focused implementation feedback, not
  as the post-review targeted verification pass: fix code and immediately retry
  only the exact failed row through the maintained runner's built-in guards;
  iterate until green, and run the complete fresh configured unseen group before
  requesting the combined slice/architecture/acceptance review. If review
  changes provider-visible behavior, rerun the affected diagnostic and unseen
  live proof; if it changes scenario generation, hydration, oracle, or test
  definition, generate a new unseen group
- keep paid repair retries within the accepted provider, budget, and retry
  authority. `Until green` does not grant unlimited spending; preserve the
  candidate and report the unresolved boundary when those limits are reached
  or safe in-scope repair is exhausted.
- do not require independent code-diff/slice review before the first paid
  attempt or between ordinary provider repair retries; provider authorization
  and any required immutable row manifest/oracle review remain pre-transport;
  require a pre-change architecture/acceptance review
  only when the proposal changes approved semantics, authority, privacy,
  provider admission, budget limits, or an unsafe/lock-conflicting boundary
- keep every hardening repair generic and provider-agnostic: never tune shared
  prompts, grammar, schemas, validators, or adapters to a fixture, row, item,
  actor, provider, or eval phrase; never make validation or execution infer the
  expected domain outcome to make the row pass
- correct an LLM test only when deterministic evidence plus independent review
  show that it is stale or invalid against the approved plan; escalate to a
  human only when changing it would alter approved product semantics
- after the review/fix loop is clean, run only the narrowest meaningful targeted verification for this slice
- do not run the full repo suite, broad regression set, or wave-level verification on intermediate slices unless the execution plan explicitly marks that slice as the verification gate
- if non-provider targeted verification fails, fix the failure and repeat review/fix before rerunning it; authorized LLM/provider rows follow the focused repair/rerun-until-green exception above. Widen to broad or full-suite verification only when the accepted plan names an explicit risk-based verification gate. A final slice alone does not authorize a full suite
- update the relevant docs for the slice only in the selected task branch/worktree
- commit immediately from the selected task branch/worktree after the slice is review-clean and green
- do not batch multiple slices into one commit
- after committing, record the `$slice-review` results and use the review model tiers recorded in the execution plan instead of allowing review sub-agents to inherit the implementation model
- record the reviewer's AC coverage verdict: `complete`, `partial`, `not applicable`, or `blocked`, plus any uncovered AC ids and follow-up gate
- update the mode-specific AC/proof record for owned rows; sign off only when
  proof reaches the expected outcome/depth, otherwise record pending, partial,
  blocked, or an explicitly accepted deferral with its later gate
- while review sub-agents run, continue with review-independent prep named in the execution plan when it is safe; do not start or commit the next risky slice until prior review findings are resolved, accepted as no-fix, or explicitly deferred
- in prerelease work, do not add migration scripts or compatibility code unless the user explicitly asks for them or a still-supported contract truly requires them
- prefer removing deprecated code over extending it
- remove failed-attempt code, duplicate implementations, temporary helpers, unreachable branches, unused exports, stale DB/schema/data objects, unused images/media/assets, scratch scripts, debug output, generated files, stale docs, unused tests, and unused dependencies introduced by the current slice before calling the slice ready for review
- if this is the terminal clean-code retirement slice, inventory the whole wave's branch-local additions, touched paths, and coupled existing paths; remove unused/deprecated code, DB/schema/data objects, assets/images, docs, tests, scripts, config flags, dependencies, generated files, compatibility shims, and failed-attempt work made obsolete by the wave; prove removed symbols/files/objects/assets have no remaining references
- do not call a legacy-to-golden conversion ready until independent review has
  accepted its clean-code retirement inventory and verified that any retained
  legacy surface has a documented supported purpose and cannot bypass golden runtime
- keep implementation output concise: report changed files, focused checks, blockers, and the next action; do not write an implementation diary
- do not commit raw provider payloads, transcripts, packets, traces, failed
  attempts, telemetry, receipts, token snapshots, command journals, caches, or
  generated corpora. Commit only formal plans, research, AC, review verdicts,
  and concise results/signoffs
- progress commentary must not terminate the execution turn; after a failed
  test, partial proof, repair, or reviewer finding, continue the next safe
  repair/rerun/re-review action yourself
- send a final handoff only when all assigned AC is proven, reviewed, verified,
  committed, and retirement-clean, or when a genuine external/human blocker
  remains after every safe path is exhausted

## Verification Batching

Focused checks during coding are expected. Broad verification is deliberately delayed until the review/fix loop is clean.

- run focused tests/checks while editing when they directly cover the code under change
- treat focused checks as implementation feedback, not as the slice's final verification
- run one combined review before targeted slice verification
- after review findings are fixed or triaged, run the planned targeted verification for the slice
- before committing, verify the selected checkout is not the canonical/shared root; if it is, stop and move the work to the task branch/worktree instead of committing there
- before committing, verify the selected checkout's local git author is allowed by the repo's deployable-author rules when present; if the author is missing or blocked, fix the lane-local `user.name` and `user.email` or use an explicitly approved deployable commit author before creating the commit
- after committing in repos with deployable-commit guards, run the repo-approved deployable commit check, such as `npm run verify:deployable-commits`, before handing off or mergeback
- run broad regression checks or full-suite commands only when the execution plan marks this slice as the final slice or an explicit wave-level verification gate
- keep browser or Playwright verification to one clean pass per target view by default; repeat only if the first pass fails or code changed again
- if non-provider targeted verification fails, fix the failure, then return to review/fix before rerunning targeted verification when the fix materially changes product code, contracts, tests, or architecture; authorized LLM/provider retries use the explicit repair/rerun-until-green order above
- if a verification fix is purely mechanical and cannot affect behavior, rerun only the failed verification first, then widen as needed
- targeted verification must prove the AC's expected behavior, not just an intermediate label or helper result, whenever the AC crosses service/API, provider, persistence, model-selection, FE/backend, auth, billing, notification, scheduler, sync, or user-visible boundaries
- clean-code retirement verification must include focused reference searches, build/type/test coverage appropriate to removed code and non-code surfaces, dependency/asset/schema checks when relevant, and any targeted behavior checks needed to prove retirement did not change supported behavior

## Review Concurrency

Avoid idle time while review sub-agents are running, but do not stack risky commits ahead of unresolved findings.

- immediately continue with review-independent work only when the execution plan names it as safe
- allowed work may include reading next-slice context, updating planning docs in the selected task branch/worktree, preparing a test checklist, inspecting files, running harmless verification, or doing explicitly non-overlapping low-risk prep
- do not commit the next risky slice until the prior slice review has returned and findings are resolved, accepted as no-fix, or explicitly deferred
- unless `single-task-wave-owner` is explicitly approved, do not implement the
  next risky slice in this task at all. Harmless next-slice preparation may be
  recorded for the fresh next owner, but writable ownership ends at this
  slice's clean commit and durable handoff;
- do not make next-slice implementation changes that would be invalidated by likely review findings from the previous slice
- if review findings arrive while other work is in progress, pause at the next safe point and triage whether to finish, adjust, or discard the in-progress work



## State Updates

If the repo uses `.sdlc/state.json`, update it as a small execution index in the selected task branch/worktree while preserving the existing slice loop. Do not create, update, stage, or commit state/progress docs from a canonical/shared root checkout; that root must stay clean on `main` and update only by fetch/pull from `origin/main`.

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
- owned mode-specific AC/proof rows record checks, proof depth, reviewer signoff,
  and unchecked/deferred notes; only Full requires a separate final matrix
- clean-code retirement expectation is satisfied: no wave-introduced or wave-obsoleted failed-attempt, temporary, duplicate, unused, deprecated, generated, debug, stale, unreachable, DB/schema/data, asset/image, script, config, dependency, or compatibility surface remains without an explicit retained reason
- updated test-result and file-summary cache entries are recorded when relevant
- the combined review result is recorded with the explicit planned review model
- any concurrent prep is recorded and does not stack a risky commit ahead of review resolution
- for an orchestrated wave, the result artifact records the next slice id,
  intended model/reasoning, handoff path, and whether the next owner will reuse
  the lane serially or use a separate parallel worktree.
  Serial reuse is allowed only after this task is fully stopped as a writer and
  its clean exact pushed head, prior writer shutdown, and named next owner/scope
  are durable. Follow an additional ownership protocol only when current repo
  authority actually defines and supports it. Do not invent retired registry,
  lease, or activation calls. Retrieval and telemetry are optional diagnostics
- the current task releases writable slice ownership after this exit unless an
  explicit `single-task-wave-owner` exception applies

## Telemetry Tool Failure Logging

Telemetry, retrieval diagnostics, command journals, and accounting captures are
optional local debugging data. When an enabled telemetry operation fails,
record one local incident and do not retry it merely to improve paperwork.
Keep raw output gitignored and out of formal closeout.

This does not waive a substantive launch/lease, review, product verification,
security, Git-head, or protected-merge failure independently established
without telemetry. Missing retrieval, reporting, or accounting telemetry alone
is non-blocking.

## Accounting Telemetry Failure Rule

If accounting telemetry is enabled, attempt it once. On failure, record one
local `telemetry_incomplete_non_product` incident and do not retry, reconstruct,
replay, backfill, or create an evidence-only commit. Continue through the
independently validated product, review, Git, and merge gates. Accounting
telemetry never changes the completion claim.
