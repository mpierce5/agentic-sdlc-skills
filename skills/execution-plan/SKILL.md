---
name: execution-plan
description: Create and review a slice-based execution plan for prerelease product work after the functional and technical plans are stable. Use when the user wants small independently shippable slices with tests-first expectations, Product AC, Technical AC, Negative AC, AC traceability, verification, and review checkpoints before implementation starts.
---

# Execution Plan

Use this skill after the functional and technical plans are reviewed.

## Rules

- break the work into small, independently reviewable slices
- convert Phase 0 hotspot findings into early prep slices, explicit no-growth guardrails, or a documented reason no refactor slice is needed
- do not put feature behavior ahead of a required prep refactor when Phase 0 marked the touched seam as `hotspot` or `stop-and-refactor`
- include a terminal clean-code retirement slice after feature slices and before final wave verification, unless the plan explicitly records that no cleanup slice is needed after checking the full inventory
- attach tests-to-write-first to every slice
- include slice-level Product AC, Technical AC, Negative AC, and targeted verification
- include an AC trace table mapping Product AC, Technical AC, and Negative AC to planned tests, affected files, and responsible slices
- include a final AC verification matrix separate from the trace table; the trace table maps planned coverage, while the final matrix records behavior-level proof and reviewer signoff
- include the expected review/fix loop before broad verification so agents do not rerun expensive tests after every small review-finding fix
- include the planned model for each slice review and the escalation trigger, if any
- include the review-agent lifecycle plan for each slice: reuse the same-run combined reviewer, spawn a fresh reviewer, keep the reviewer open through same-slice finding fixes and re-review, or close the reviewer after resolution
- include the refinement-bench handoff plan: keep the persistent refinement TPM and architect reviewers through execution-plan approval, then close them before routine slice implementation unless the user explicitly wants them kept open
- include the compact context package each reviewer should receive, defaulting code review to diff-only and avoiding full docs, unrelated files, or broad chat history unless specifically justified
- include cached-context entries reviewers and implementers should reuse instead of re-reading unchanged files or logs
- include the compact AC/TAC packet each slice reviewer should receive: assigned Product AC rows, Technical AC rows, Negative AC rows, trace-table rows, affected files, planned tests, and current verification status
- include the expected proof depth for each AC row, especially when an AC crosses service/API, provider, persistence, FE/backend, model-selection, auth, billing, notification, scheduler, or sync boundaries
- include a token budget note for noisy artifacts: how test output, browser observations, logs, and API payloads will be summarized before review agents see them
- include a browser-verification budget when user-facing work is in scope, defaulting to one pass per target view unless failures require another pass
- define whether the slice uses routine `SHALLOW` review only, allows `DEEP` escalation, or contributes to a later `ACCEPTANCE` gate
- identify any review-independent prep that can run while the previous slice is under review
- identify broader regression requirements for the final slice or an explicit wave-level verification gate, not for every intermediate slice commit
- identify cleanup inventory requirements for the terminal clean-code retirement slice: unused/deprecated code, unreachable branches, duplicate paths, old compatibility shims, DB/schema/data objects, migrations or seed data, images/media/assets, generated files, failed attempts, temporary helpers, obsolete tests, scratch scripts, config flags, debug logs, stale docs, and unused dependencies introduced or exposed during the wave
- include a per-slice architecture-health check: whether the slice touches a hotspot, whether it must reduce/split/delete/contain it, and how review will verify no net worsening
- write the execution plan into a durable repo document before implementation starts
- include a test plan section in that document, not just test notes inside chat
- include per-slice status tracking in that document so progress can be resumed safely later
- commit execution-plan doc changes before implementation starts when the repo workflow permits commits; otherwise report the blocker and dirty doc paths
- keep execution-plan output concise: prefer slice tables or bullets with decisions, gates, and statuses over long narrative explanation
- on every material execution-plan iteration before implementation starts, run both a TPM review pass and an architect review pass
- reuse the same refinement-wave TPM and architect reviewers by default instead of spawning fresh planning reviewers each iteration
- if the refinement reviewers already exist from earlier phases, send the execution-plan delta to those same reviewers instead of spawning new reviewers
- optionally include persistent DBA or UX reviewers in execution-plan review when their expertise was needed earlier or the slice plan introduces database or UX risk
- keep the refinement reviewers open through execution-plan approval, then close TPM, architect, and any DBA/UX specialist reviewers at the ready-for-implementation checkpoint unless the user explicitly asks to keep them open
- when delegated execution-plan review is available, use `frontier-review` for both refinement review passes
- make the slice loop explicit:
  - tests first
  - implement one slice
  - focused tests/checks may run during coding iterations when they directly cover the code being changed; this is not the broad verification pass
  - one combined slice review before slice-level targeted verification
  - fix findings and re-review with the same reviewers until review-clean
  - targeted verification for the slice
  - run the terminal clean-code retirement slice after feature behavior is review-clean
  - broader regression checks only on the final slice or an explicit wave-level verification gate
  - if targeted verification fails, fix and re-enter review/fix before rerunning targeted verification; only widen when this is the final slice or verification gate
  - commit immediately after the slice is review-clean and green
  - safe review-independent prep may continue while reviewers run
  - resolve findings, accept them as no-fix, or explicitly defer them before the next risky slice
- review the execution plan before implementation starts

## AC Traceability

The execution plan must include an AC trace table before implementation starts.

Each row should map:

- AC id and type: Product AC, Technical AC, or Negative AC
- pass/fail statement
- planned test or verification command
- affected files or contracts
- slice id responsible for implementing or preserving it
- final verification gate when the row cannot be fully proven inside one slice

Every slice must name the AC rows it owns or preserves. A slice may defer completion of an AC only when the execution plan says which later slice or acceptance gate will close it.

Routine review remains cost-controlled through reused reviewers and compact context, but it is not allowed to be vague: the reviewer must validate the assigned AC/TAC trace rows before the slice can be called review-clean.

## Final AC Verification Matrix

The execution plan must also include a final AC verification matrix before implementation starts. This matrix is separate from the trace table and is the only place an AC can be marked signed off.

Each matrix row must include:

- AC id and type: Product AC, Technical AC, or Negative AC
- exact expected behavior in outcome terms
- required proof depth: `behavior/API/service`, `contract`, `unit/helper`, `visual`, or `manual`
- concrete proof/test to run or inspect
- responsible slice or final acceptance gate
- reviewer signoff status: `unchecked`, `signed-off`, `partial`, `blocked`, `deferred`, or `not applicable`
- unchecked/deferred notes, including why narrower proof is sufficient if the AC is not proven at the service/API or user-visible boundary

The matrix must distinguish intermediate proof from outcome proof. Route-tier classification, helper output, mocks, local state labels, CSS selectors, or object-shape checks are not enough to sign off an AC whose expected behavior is provider model choice, API behavior, persistence result, permission result, billing effect, notification delivery, sync outcome, or user-visible behavior.

For cross-module AC, require service/API-level, integration, or end-to-end proof unless a reviewer explicitly signs off a narrower proof as sufficient and records why.

Reviewers must mark rows `partial` or `blocked` when tests prove only an implementation detail but not the AC's stated behavior. A partial row is blocking for the wave unless the execution plan names a later gate to close it or the user explicitly accepts the deferral.

## Clean-Code Retirement Slice

Every execution plan must include a terminal clean-code retirement slice unless it explicitly records `not needed` with the full inventory checked.

This slice is a clean-code gate, not a light artifact sweep. It is for all unused, deprecated, duplicate, temporary, superseded, unreachable, failed-attempt, or compatibility-preserving leftovers introduced or exposed by the current wave.

The retirement slice must cover code and non-code surfaces:

- run after feature slices are review-clean and before final wave verification
- inventory branch-local additions, touched files, and coupled existing paths for unused/deprecated code, unreachable branches, duplicate implementations, temporary bridges, compatibility shims, fallback paths, debug helpers, stale docs, unused tests, scratch scripts, config flags, DB/schema/data objects, migrations/seed data, images/media/assets, generated files, and unused dependencies
- delete branch-introduced leftovers and delete or update coupled existing deprecated paths when the wave made them obsolete
- prove removed symbols, files, routes, DB objects, assets, scripts, flags, and dependencies have no remaining references with focused searches plus build/type/test coverage appropriate to the surface
- update docs, state, dependency manifests, asset references, DB/schema docs, and the final AC verification matrix if retirement changes behavior, contracts, or verification evidence
- receive a normal slice review; reviewers must treat leftover unused/deprecated code or non-code surfaces as blocking unless explicitly retained with a product or technical reason

The retirement slice is not a license for broad opportunistic refactoring. If the inventory reveals unrelated pre-existing dead code, DB objects, assets, or docs, record it as follow-up unless it is directly coupled to the wave's AC, touched architecture, or architecture-health requirements.

## Planning Artifact Commit

If this phase creates or updates repo docs, commit those doc changes before exiting the phase when the repo workflow permits commits.

- check the worktree before editing and note unrelated existing changes
- stage only the execution-plan docs touched by this phase
- do not stage source code, generated files, lockfiles, or unrelated user/agent changes
- if the worktree is already dirty, leave unrelated changes alone and commit only the explicit planning-doc paths touched by this phase
- use a clear message such as `docs: add execution plan` or `docs: update execution plan`
- record the commit hash in the planning artifact or progress log
- if committing is impossible, report the blocker and the exact dirty doc paths

## Review Model Planning

Use this model policy for refinement-wave execution-plan review:

- TPM refinement reviewer: `frontier-review`, medium or high reasoning
- architect refinement reviewer: `frontier-review`, medium or high reasoning
- reuse the same refinement-wave TPM and architect reviewers by default across execution-plan iterations

Use this model policy when writing slice review steps:

- routine slice code review: `economy-review`, medium reasoning
- medium-risk architecture, contract, or cross-file review: `standard-review`, medium or high reasoning
- high-risk review or ambiguous architecture judgment: `frontier-review`, medium or high reasoning

Escalate planned review model when the slice touches auth, permissions, privacy, payments, notifications, scheduler, sync, deployment, environment variables, database shape, API contracts, production-facing integration wiring, architecture boundaries, shared data flow, persistence semantics, FE/backend contracts, broad shared utilities, or more than roughly 400 changed lines.

Each slice entry in the implementation-plan document must include:

- assigned Product AC rows
- assigned Technical AC rows
- assigned Negative AC rows
- AC coverage expectation: `complete`, `partial`, or `not applicable`, with the reason and follow-up gate for any partial row
- final AC verification matrix rows owned by this slice, including exact expected behavior, required proof depth, current signoff status, and unchecked or deferred notes
- clean-code retirement expectation: `not applicable`, `feature slice must leave no unused/deprecated surfaces`, or `terminal clean-code retirement slice`, with the inventory/proof required
- combined review model and reasoning effort
- escalation reason, or `none`
- Phase 0 hotspot touched, or `none`
- architecture-health expectation: reduce responsibility, extract, split, delete obsolete path, no-growth containment, or `not applicable`
- whether an economy-tier reviewer should be allowed to request a follow-up `standard-review` or `frontier-review` pass
- review-agent lifecycle: reuse same-run role reviewer by default, or the reason a fresh reviewer is required
- whether reviewers should stay open for same-slice finding fixes and re-review
- whether reviewers should be closed after findings are resolved, accepted as no-fix, or explicitly deferred
- compact review context to pass: current diff or commit, changed files, plan excerpt, verification status, unresolved prior findings if relevant, and rubric
- compact AC/TAC packet to pass: assigned Product AC, Technical AC, Negative AC, trace-table rows, tests, affected files, and forbidden states
- AC signoff packet to pass: final matrix rows owned or preserved by the slice, required proof depth, and whether available tests prove outcome behavior or only intermediate implementation behavior
- review mode plan: `SHALLOW` by default, explicit `DEEP` triggers, and whether this slice is an `ACCEPTANCE` gate slice
- if this is the final end-of-wave `ACCEPTANCE` gate, name the two required separate reviewers: architect reviewer and TPM or acceptance reviewer
- code-review scope budget: `diff-only` by default, `changed-files` if needed, or named expanded context with justification
- review output budget: terse bullet issues only; no prose summary unless there are zero findings; explanations only when critical
- iterative finding budget: routine `SHALLOW` or `DEEP` passes may return only the top 3-5 highest-impact findings, but must not suppress known critical findings
- cached context to reuse: file summaries, plan excerpts, test summaries, API/browser verification summaries, and invalidation rules
- verification batching plan: which focused tests/checks may run during coding iterations, which targeted tests belong to each slice, which broad or full-suite tests wait until the final slice or explicit wave-level verification gate, and which failures require returning to review before rerunning targeted or final verification
- model-routing note: which routine orchestration or diff-only review steps may use a lighter model or lighter reasoning setting, and what conditions force escalation
- token or agent-slot guardrails if this slice needs extra reviewers
- review-independent prep allowed while this slice is under review, or `none`
- whether the next slice is risky-gated on this slice's review findings
- refinement-bench close point: usually `close after execution plan accepted`, otherwise name the explicit reason to keep them open
- optional specialist refinement reviewers: DBA, UX, or `none`, with the reason each is needed and the close point



## State Doc Planning

When an SDLC state doc is used, the execution plan must define how state will be updated without changing the review/fix-before-broad-verification loop.

Each slice entry should include:

- slice id used in `.sdlc/state.json`
- initial expected state transitions for that slice
- review status values: `pending`, `blocking_findings`, `review_clean`, `no_fix`, or `deferred`
- verification status values: `not_run`, `focused_passed`, `broad_passed`, or `failed`
- which state fields are safe to pass to reviewers by default
- which history or cached context may be read only on escalation

The state doc is not a substitute for the implementation-plan document. Keep the implementation-plan status section as the human-readable progress record and use state as the machine-readable index.

For planning phases, the execution plan should also define how `phase_gate` moves through `draft`, `review_pending`, `reviewed`, `updated_from_review`, and `committed` so agents do not collapse a reviewed-and-committed gate into a generic "done" state.

When a wave spans many slices, the execution plan may define an `ACCEPTANCE` gate every several low-risk slices or at a feature boundary, but it must not defer architecture, contract, or UX-critical concerns that already meet the escalation triggers for an earlier `DEEP` or `ACCEPTANCE` review.

Intermediate slices should usually stop at targeted verification. If the plan wants a non-final broad or full-suite verification gate, it must name that gate explicitly and explain why it is worth the extra cost.

The final end-of-wave `ACCEPTANCE` gate must use two separate reviewers: one architect reviewer and one TPM or acceptance reviewer. That final gate is the explicit exception to the routine single-reviewer-per-slice rule.
## Exit Criteria

- slices are small enough to commit independently
- required Phase 0 prep refactors are placed before feature slices that depend on the unhealthy seam
- the plan includes a terminal clean-code retirement slice before final verification, or an explicit `not needed` rationale with full inventory scope
- every slice has tests-first expectations
- every material execution-plan iteration has had both TPM and architect review passes, or an explicit blocker is reported
- every slice has explicit review/fix steps before broad verification
- every slice defines review/fix-before-broad-verification expectations
- every slice names review model tiers and escalation rules
- every slice names review-agent cleanup expectations and compact-context inputs
- every slice names cached context to reuse or explicitly says `none`
- every slice names safe review-independent prep, or explicitly says `none`
- every slice has assigned Product AC, Technical AC, Negative AC, and targeted verification
- every Product AC, Technical AC, and Negative AC row is mapped to tests or verification, affected files or contracts, and responsible slices
- the final AC verification matrix exists and every Product AC, Technical AC, and Negative AC row has expected behavior, required proof depth, responsible gate, and initial signoff status
- every slice defines its expected AC coverage verdict and the reviewer packet needed to validate it
- every slice that touches a Phase 0 hotspot has an explicit no-net-worsening check
- the repo implementation-plan document includes the execution slices, test plan, and current slice statuses
- execution-plan doc changes are committed, or an explicit blocker is reported with the dirty doc paths
