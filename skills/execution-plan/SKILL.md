---
name: execution-plan
description: Create and review a slice-based execution plan for prerelease product work after the functional and technical plans are stable. Use when the user wants small independently shippable slices with tests-first expectations, Product AC, Technical AC, Negative AC, AC traceability, verification, and review checkpoints before implementation starts.
---

# Execution Plan

Use this skill after the functional and technical plans are reviewed.

## Rules

- break the work into small, independently reviewable slices
- carry forward every AC-evidence classification from requirements discovery.
  If execution planning adds a material decision, reopen focused
  external-practice research and revise the affected AC before implementation.
- convert Phase 0 hotspot findings into early prep slices, explicit no-growth
  guardrails, or a documented reason no refactor slice is needed
- do not put feature behavior ahead of a required prep refactor when Phase 0
  marked the seam `hotspot` or `stop-and-refactor`
- include a terminal clean-code retirement slice after feature slices and before
  final wave verification unless the plan explicitly records that none is needed
  after a full inventory
- attach tests-to-write-first, slice-level Product AC, Technical AC, Negative
  AC, and targeted verification to every slice
- include an AC trace table and a separate final AC verification matrix
- make the review/fix loop explicit before broad verification so agents do not
  rerun expensive tests after every small finding fix
- include the planned review model, escalation triggers, reviewer lifecycle,
  compact review context, and reviewer no-fork rule
- include cached context, noisy-artifact summarization rules, an impact map for
  targeted verification, and review-independent prep that may run while
  reviewers work. Do not create a separate verification-budget document
- default every substantive implementation slice in an orchestrated wave to a
  fresh user-user-visible top-level task. Include its handoff, retrieval,
  execution model/reasoning, and serial-lane or parallel-worktree routing
  explicitly. A multi-slice task requires an accepted-plan
  `single-task-wave-owner` exception with rationale
- include a per-slice architecture-health check whenever a slice touches a
  hotspot: reduce, split, delete, contain, or explicitly mark not applicable
- write the execution plan into a durable repo document on the selected task
  branch/worktree before implementation starts
- include a test plan section and per-slice progress tracking in that document
- commit execution-plan doc changes from the selected task branch/worktree
  before implementation starts when the workflow permits it; otherwise report
  the blocker and dirty doc paths
- keep execution-plan output concise: prefer slice tables or bullets over long
  narrative explanation
- on every material execution-plan iteration before implementation starts, run
  both a TPM review pass and an architect review pass
- treat the complete execution plan or a genuinely semantic slice/gate delta as
  the review unit. Collect all minor row wording, path/citation, formatting,
  proof-label, and internally consistent trace corrections, apply them together,
  and request one consolidated final re-review. Do not review each corrected row
  separately. Re-review immediately only when a fix changes slice ownership or
  order, dependencies, AC closure/proof depth, provider/cost authority,
  security/privacy, merge gates, or another material finding.
- reuse the same refinement-wave TPM and architect reviewers by default
- optionally keep persistent DBA or UX reviewers only when their expertise is
  actually needed
- close refinement reviewers at the ready-for-implementation checkpoint unless
  the user explicitly wants them kept open
- when delegated execution-plan review is available, use `frontier-review` for
  both refinement review passes
- make the slice loop explicit:
  - tests first
  - implement one slice
  - focused checks may run during coding when they directly cover the change
  - one combined slice review before slice-level targeted verification
  - fix findings as one batch and re-review the complete affected artifact with
    the same reviewer until review-clean; do not create one round per minor fix
  - targeted verification for the slice
  - run the terminal clean-code retirement slice after feature behavior is
    review-clean
  - broader regression checks only when an explicit risk-based wave-level gate
    requires them; a final slice alone does not require a full suite
  - if targeted verification fails, fix and re-enter review/fix before
    rerunning targeted verification; widen only when the impact map or an
    explicit risk-based verification gate requires it
  - commit immediately from the selected task branch/worktree after the slice is
    review-clean and green
  - safe review-independent prep may continue while reviewers run
  - resolve findings, accept them as no-fix, or explicitly defer them before
    the next risky slice
- review the execution plan before implementation starts

## AC Traceability

The execution plan must include an AC trace table before implementation starts.

Each row should map:

- AC id and type
- pass/fail statement
- planned test or verification command
- affected files or contracts
- slice id responsible for implementing or preserving it
- final verification gate when the row cannot be fully proven inside one slice
- evidence classification: `research-backed`, `repo-constrained`,
  `product-choice`, or `not-applicable`, plus source or rationale

Every slice must name the AC rows it owns or preserves. A slice may defer
completion of an AC only when the plan says which later slice or acceptance
gate will close it.

Routine review may stay cost-controlled through reused reviewers and compact
context, but it may not be vague: the reviewer must validate the assigned AC/TAC
rows before the slice can be called review-clean.

A slice must not be called review-clean when any assigned AC row that is
supposed to close in that slice still lacks proof at its required boundary.
Diff plausibility, helper tests, mocks, route labels, local state assertions,
or intended architecture are not substitutes for required proof depth.

## Final AC Verification Matrix

The execution plan must also include a final AC verification matrix before
implementation starts. This matrix is separate from the trace table and is the
only place an AC can be marked signed off.

Each matrix row must include:

- AC id and type
- exact expected behavior in outcome terms
- required proof depth: `behavior/API/service`, `contract`, `unit/helper`,
  `visual`, or `manual`
- concrete proof/test to run or inspect
- responsible slice or final acceptance gate
- reviewer signoff status: `unchecked`, `signed-off`, `partial`, `blocked`,
  `deferred`, or `not applicable`
- unchecked/deferred notes, including why narrower proof is sufficient when it
  is allowed

The matrix must distinguish intermediate proof from outcome proof. Route-tier
classification, helper output, mocks, local state labels, CSS selectors, or
object-shape checks are not enough to sign off an AC whose expected behavior is
provider model choice, API behavior, persistence result, permission result,
billing effect, notification delivery, sync outcome, or user-visible behavior.

For cross-module AC, require service/API-level, integration, or end-to-end
proof unless a reviewer explicitly signs off a narrower proof and records why.

Reviewers must mark rows `partial` or `blocked` when tests prove only an
implementation detail but not the AC's stated behavior. A partial row is
blocking for the wave unless the plan names a later gate to close it or the
user explicitly accepts the deferral.

## Clean-Code Retirement Slice

Every execution plan must include a terminal clean-code retirement slice unless
it explicitly records `not needed` with the full inventory checked.

This slice is a clean-code gate, not a light artifact sweep. It is for unused,
deprecated, duplicate, temporary, superseded, unreachable, failed-attempt, or
compatibility-preserving leftovers introduced or exposed by the wave.

The retirement slice must:

- run after feature slices are review-clean and before final wave verification
- inventory branch-local additions, touched files, and coupled existing paths
  for unused/deprecated code and non-code surfaces
- delete branch-introduced leftovers and remove or update coupled obsolete paths
  when the wave made them unnecessary
- prove removed symbols, files, routes, DB objects, assets, scripts, flags, and
  dependencies have no remaining references with focused searches plus the
  appropriate build/type/test coverage
- update docs, state, manifests, asset references, schema docs, and the final
  AC verification matrix if retirement changes behavior, contracts, or proof
- receive a normal slice review; leftovers are blocking unless explicitly
  retained with a product or technical reason

The retirement slice is not a license for broad opportunistic refactoring. If
the inventory reveals unrelated pre-existing dead surfaces, record them as
follow-up unless they are directly coupled to the wave's AC or touched
architecture.

## Planning Artifact Commit

If this phase creates or updates repo docs, commit those doc changes from the
selected task branch/worktree before exiting the phase when the workflow permits
commits. Do not create, update, stage, or commit execution-plan docs from a
canonical/shared root checkout.

- check the worktree before editing and note unrelated existing changes
- verify the selected checkout is not the canonical/shared root before editing
  or staging planning-doc changes
- stage only the execution-plan docs touched by this phase
- do not stage source code, generated files, lockfiles, or unrelated changes
- if the worktree is already dirty, leave unrelated changes alone and commit
  only the touched planning-doc paths
- use a clear message such as `docs: add execution plan` or `docs: update
  execution plan`
- record the commit hash in the planning artifact or progress log
- if committing is impossible, report the blocker and exact dirty doc paths

## Review Model Planning

Use this model policy for refinement-wave execution-plan review:

- TPM refinement reviewer: `frontier-review`, medium or high reasoning
- architect refinement reviewer: `frontier-review`, medium or high reasoning
- reuse the same refinement-wave TPM and architect reviewers by default across
  execution-plan iterations

Use this model policy when writing slice review steps:

- routine slice code review: `economy-review`, medium reasoning
- medium-risk architecture, contract, or cross-file review: `standard-review`,
  medium or high reasoning
- high-risk review or ambiguous architecture judgment: `frontier-review`,
  medium or high reasoning

Escalate the planned review model when a slice touches auth, permissions,
privacy, payments, notifications, scheduler, sync, deployment, environment
variables, database shape, API contracts, production-facing integration wiring,
architecture boundaries, shared data flow, persistence semantics, FE/backend
contracts, broad shared utilities, or more than roughly 400 changed lines.

Each slice entry in the implementation-plan document must include:

- assigned Product AC rows
- assigned Technical AC rows
- assigned Negative AC rows
- whether the slice needs a dedicated lane bootstrap step before execution
- whether the slice requires a lane-local handoff doc before the main execution
  agent starts
- expected handoff doc path and result path when a handoff is required
- expected bootstrap model and reasoning when a cheap setup worker is planned
- top-level task mode: `fresh-visible-slice-owner` by default, or the explicit
  `single-task-wave-owner` exception and rationale
- planned execution model and reasoning effort for the visible slice owner,
  separate from bootstrap and reviewer models
- task/lane routing: `serial-exclusive-lane-transfer` or
  `parallel-isolated-worktree`, including dependency and merge order. A serial
  transfer must define the exact reviewed/pushed head, clean-lane and prior
  writer shutdown proof, exclusive lease release/acquisition, coordinator
  registry plus activation-epoch rebinding, and compact handoff before writable
  activation. Retrieval and telemetry diagnostics are optional and local
- optional local launch/telemetry diagnostics when supported; raw telemetry is
  gitignored and never a formal slice artifact. Lane id, slice id, and
  task/thread id remain separate identities
- AC coverage expectation: `complete`, `partial`, or `not applicable`, plus the
  reason and follow-up gate for any partial row
- AC closure rule per assigned row: `close in this slice`, `preserve until
  <named later gate>`, or `regression only`
- final AC verification matrix rows owned by this slice, including exact
  expected behavior, required proof depth, current signoff status, and any
  unchecked/deferred notes
- clean-code retirement expectation: `not applicable`, `feature slice must
  leave no unused/deprecated surfaces`, or `terminal clean-code retirement
  slice`
- combined review model and reasoning effort
- escalation reason, or `none`
- Phase 0 hotspot touched, or `none`
- architecture-health expectation: reduce responsibility, extract, split,
  delete obsolete path, no-growth containment, or `not applicable`
- whether an economy-tier reviewer may request a follow-up `standard-review` or
  `frontier-review`
- review-agent lifecycle: reuse same-run reviewer by default, or the reason a
  fresh reviewer is required
- whether reviewers stay open for same-slice fixes and re-review
- whether reviewers close after findings are resolved, accepted as no-fix, or
  explicitly deferred
- compact review context to pass: current diff or commit, changed files, plan
  excerpt, verification status, unresolved prior findings if relevant, and
  rubric
- compact AC/TAC packet to pass: assigned Product AC, Technical AC, Negative
  AC, trace rows, tests, affected files, and forbidden states
- AC signoff packet to pass: final matrix rows owned or preserved by the slice,
  required proof depth, and whether available tests prove outcome behavior or
  only intermediate behavior
- review-clean rule: the reviewer must block the slice if any row marked `close
  in this slice` lacks proof at its required boundary
- review mode plan: `SHALLOW` by default, explicit `DEEP` triggers, and whether
  this slice contributes to a later `ACCEPTANCE` gate
- if this is the final end-of-wave `ACCEPTANCE` gate, name the two required
  separate reviewers: architect reviewer and TPM or acceptance reviewer
- code-review scope budget: `diff-only` by default, `changed-files` if needed,
  or named expanded context with justification
- review output budget: terse bullet issues only; no prose summary unless there
  are zero findings
- iterative finding budget: routine `SHALLOW` or `DEEP` passes may return only
  the top 3-5 highest-impact findings, but must not suppress known critical
  findings
- cached context to reuse and invalidation rules
- verification batching plan: focused checks allowed during coding, targeted
  verification for the slice, and broad/full-suite checks only for an explicit
  accepted risk-based wave-level gate
- model-routing note: which routine orchestration or diff-only review steps may
  use lighter models, and what forces escalation
- reviewer spawn note: reviewers must not fork the parent context
- token or agent-slot guardrails if extra reviewers are needed
- review-independent prep allowed while this slice is under review, or `none`
- whether the next slice is risky-gated on this slice's review findings
- refinement-bench close point: usually `close after execution plan accepted`
- optional specialist refinement reviewers: DBA, UX, or `none`, with the reason
  each is needed and the close point

## State Doc Planning

When an SDLC state doc is used, the execution plan must define how state will be
updated without changing the review/fix-before-broad-verification loop.

Each slice entry should include:

- slice id used in `.sdlc/state.json`
- initial expected state transitions for that slice
- review status values: `pending`, `blocking_findings`, `review_clean`,
  `no_fix`, or `deferred`
- verification status values: `not_run`, `focused_passed`, `broad_passed`, or
  `failed`
- which state fields are safe to pass to reviewers by default
- which history or cached context may be read only on escalation

The state doc is not a substitute for the implementation-plan document. Keep
the implementation-plan status section as the human-readable progress record and
use state as the machine-readable index.

For planning phases, the execution plan should also define how `phase_gate`
moves through `draft`, `review_pending`, `reviewed`, `updated_from_review`, and
`committed` so agents do not collapse a reviewed-and-committed gate into a
generic `done` state.

When a wave spans many slices, the execution plan may define an `ACCEPTANCE`
gate every several low-risk slices or at a feature boundary, but it must not
defer architecture, contract, or UX-critical concerns that already meet the
escalation triggers for an earlier `DEEP` or `ACCEPTANCE` review.

Intermediate slices should usually stop at targeted verification. If the plan
wants a non-final broad or full-suite verification gate, it must name that gate
explicitly and explain why it is worth the extra cost.

Intermediate slices may stop at targeted verification, but they still must
supply the proof needed to close any AC rows marked `close in this slice`. If
that proof is not available yet, the row must remain partial for a named later
gate and the reviewer must not sign it off early.

The final end-of-wave `ACCEPTANCE` gate must use two separate reviewers: one
architect reviewer and one TPM or acceptance reviewer. That final gate is the
explicit exception to the routine single-reviewer-per-slice rule.

## Exit Criteria

- slices are small enough to commit independently
- required Phase 0 prep refactors are placed before feature slices that depend
  on the unhealthy seam
- the plan includes a terminal clean-code retirement slice before final
  verification, or an explicit `not needed` rationale with full inventory scope
- every slice has tests-first expectations
- every material execution-plan iteration has had both TPM and architect review
  passes, or an explicit blocker is reported
- every slice defines review/fix-before-broad-verification expectations
- every slice names review model tiers, escalation rules, reviewer cleanup
  expectations, and compact-context inputs
- every substantive slice names its user-visible top-level task mode, execution
  model/reasoning, handoff/retrieval paths, serial or parallel lane routing, and
  concise closeout boundary; telemetry is optional local diagnostic state
- any `single-task-wave-owner` exception is explicit, reviewed, and explains
  why per-slice visibility, model specialization, recovery isolation, and
  dependency-safe parallelism are not needed
- every slice names cached context to reuse or explicitly says `none`
- every slice names safe review-independent prep, or explicitly says `none`
- every slice has assigned Product AC, Technical AC, Negative AC, and targeted
  verification
- every Product AC, Technical AC, and Negative AC row is mapped to tests or
  verification, affected files or contracts, and responsible slices
- every AC retains its evidence classification and source or rationale from
  requirements discovery, with any reopened research decision recorded
- the final AC verification matrix exists and every Product AC, Technical AC,
  and Negative AC row has expected behavior, required proof depth, responsible
  gate, and initial signoff status
- every slice defines its expected AC coverage verdict and the reviewer packet
  needed to validate it
- every slice that touches a Phase 0 hotspot has an explicit no-net-worsening
  check
- the repo implementation-plan document includes the execution slices, test
  plan, and current slice statuses
- execution-plan doc changes are committed, or an explicit blocker is reported
  with the dirty doc paths
