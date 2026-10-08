---
name: slice-review
description: Review exactly one slice for prerelease product work. Use when the user wants a combined slice review for a current slice diff or slice commit, with findings resolved before broad verification and before the next risky slice begins.
---

# Slice Review

Use this skill only after a coherent slice diff or slice commit exists.

When this skill is used as part of `$sdlc`, inherit `$sdlc`'s standing
reviewer-agent permission. Reviewer sub-agents must not fork or inherit the full
parent chat context. They should receive only the named diff or commit, changed
files, the relevant plan excerpt, assigned AC/TAC rows, final AC verification
rows, focused proof, and any narrowly scoped excerpts needed for the decision.
When a parent agent delegates review to a sub-agent, the prompt should
explicitly reference this `slice-review` skill by name and, when the platform
needs it, the local path or repository-relative path to this skill.

## Rules

- review exactly one slice diff or slice commit
- default routine review mode is `SHALLOW`
- default code-review scope is diff-only
- treat AC verification as the primary gate and code review as supporting
  evidence
- inspect changed files only when the diff is insufficient
- inspect unchanged files only for a concrete risk such as contract
  compatibility, shared utility behavior, security/privacy/auth impact,
  architecture boundary changes, failing tests, or a specific uncertainty
- do not browse the whole repo, reload broad planning context, or inspect
  unrelated files during routine review
- do not analyze broad diff stats, full branch history, or large tool outputs
  unless a failure or uncertainty specifically requires that expansion
- run one combined review focused on correctness, AC drift, maintainability, and
  whether the slice still matches the approved plan and architecture intent
- validate the slice against the supplied compact AC/TAC packet and the supplied
  final AC verification matrix rows
- verify each assigned AC row at the proof depth named in the final AC
  verification matrix before calling that row signed off
- block the review when the AC/TAC packet is missing or too vague to validate
- when a slice touches LLM-facing prompts, contracts, manifests, structured-output
  tests, validators, deterministic field assembly, or provider-visible payload shaping,
  explicitly check that reusable source stays provider-agnostic, that contract
  grammar asks the model only for model-authored semantic fields, and that values
  already known from selected refs, authority facts, or contract-shape
  singletons are not redundantly requested from the model
- for a failed LLM scenario, verify the implementation audited lookup/authority
  facts, template/adapter eligibility, contract/slot shape, provider-agnostic
  grammar, and required execution/persistence/hydration proof before changing
  any scenario expectation; presume planned scenarios are supported, and block
  a review that broadens the test merely to accept a structurally valid but
  unintended model choice. Permit a test correction only when deterministic
  evidence and the independent review establish it is stale or invalid against
  the approved plan; require human acceptance only when the correction changes
  approved product semantics. Reject any validator or executor semantic
  inference that forces the expected outcome instead of accepting a
  model-authored contract.
- for a final review of an authorized LLM hardening repair, require both the
  selected failed diagnostic replay and the fresh configured unseen group to
  be GREEN on the candidate branch. If that live proof is missing, return the
  slice as not ready for final review rather than making review a prerequisite
  for provider execution. If a review fix changes provider-visible behavior,
  require the affected diagnostic and unseen live proof again; if it changes
  generator, hydration, oracle, or test definition, require a new unseen group.
- compare the available proof to the exact expected behavior row by row before
  signoff; if the evidence proves only intermediate mechanics, return `partial`
  or `blocked`
- mark AC coverage `partial` or `blocked` when the proof validates only
  intermediate implementation behavior rather than the promised outcome
- mark the review `blocked` when the packet is missing owned AC rows, required
  proof depth, proof evidence, or the later gate allowed to close a partial row
- do not convert `pending verification` into `review clean`
- validate the slice against its clean-code retirement expectation; leftovers
  introduced or made obsolete by the wave are blocking unless the plan
  explicitly retains them with a reason
- reuse the same-run combined reviewer when appropriate; do not spawn unlimited
  fresh review agents
- log concrete findings
- triage findings before the next risky slice begins
- do not batch multiple slice reviews at the end of the wave

## Review Modes

Use the lightest review mode that still protects correctness.

- `SHALLOW`: routine per-slice review; diff-first, mandatory AC/TAC validation,
  and top findings only
- `DEEP`: expanded context, stronger architecture or contract validation, and a
  broader correctness sweep
- `ACCEPTANCE`: full acceptance-criteria validation using the final AC
  verification matrix, architecture review, correctness sweep, and UX review
  when applicable
- `CLEANUP`: terminal clean-code retirement review; validates removals,
  no-reference proof, no supported-behavior regression, and no broad unrelated
  cleanup beyond the plan

`ACCEPTANCE` review at the end of the full slice wave must use two separate
reviewers:

- one architect reviewer
- one TPM or acceptance reviewer

## Model Routing

Resolve concrete models and reasoning through the active platform adapter or
repo-local policy. Use `economy-review` for bounded routine review,
`standard-review` for cross-file or contract risk, and `frontier-review` for
high-risk or ambiguous architecture judgment. Record the actual assignment and
escalate when the assigned reviewer cannot reliably resolve the issue.

Escalate when the slice touches auth, permissions, privacy, payments,
notifications, scheduler, sync, deployment, environment variables, database
shape, API contracts, production-facing integration wiring, architecture
boundaries, shared data flow, persistence semantics, FE/backend contracts,
broad shared utilities, or more than roughly 400 changed lines; when tests or
verification failed; or when the reviewer reports uncertainty or a plausible
correctness issue.

Escalate from `SHALLOW` to `DEEP` or early `ACCEPTANCE` when:

- the slice introduces or significantly changes an abstraction
- the slice changes shared contracts, ownership boundaries, persistence
  semantics, or FE/backend data flow
- the slice is materially UX-facing and shallow review cannot validate it
- repeated findings suggest a broader issue set
- any assigned AC row requires `behavior/API/service`, `visual`, or `manual`
  proof and the evidence does not directly prove that outcome yet
- any assigned AC crosses service/API, provider, persistence, FE/backend, auth,
  billing, notification, scheduler, sync, deployment, or other cross-module
  boundaries

## Review Scope And Token Budget

Use the narrowest context that can produce a correct review.

- routine review: diff only
- if needed, expand to changed files or focused excerpts around changed symbols
- inspect a callee module only when the diff creates a concrete correctness,
  contract, or ownership question
- use the supplied plan excerpt and assigned AC rows; avoid full planning docs
  unless a concrete ambiguity requires them
- if expected behavior, required proof depth, or proof evidence is missing,
  return a blocking finding instead of inferring signoff
- if an LLM-facing slice needs provider-agnostic, genericity, or known-value
  elision checks and the packet or proof does not let you validate them, return
  a blocking finding instead of assuming the architecture is acceptable
- broad repo exploration is an escalation, not a default
- record any scope expansion in the review result

For `SHALLOW` review, return a cheap, high-signal pass, usually the top 3-5
highest-impact findings, but do not suppress known critical findings or call the
slice clean when likely blocking issues remain.

## Cached Context

Use cached context before requesting raw context.

- prefer cached plan excerpts, file summaries, hotspot notes, prior review
  findings, and test summaries when still valid
- ask for raw files only when the diff plus cached context is insufficient for a
  concrete risk
- do not re-read unchanged file contents, full test logs, full planning docs,
  or broad chat history
- when logs or outputs are large, work from a compact failure summary and
  request only the smallest raw excerpt needed
- when validating a fix, use the original finding plus the fix diff and any
  still-valid cached context

## Review Output Contract

Use terse findings-only output by default.

- always include one compact metadata line:
  `scope: <diff-only|changed-files|expanded-to-contract>; model: <model>; AC coverage: <complete|partial|blocked|not applicable>; unchecked AC: <ids|none>; AC signoff: <signed-off|partial|blocked|deferred|not applicable>`
- if AC coverage is `partial` or `blocked`, include a finding naming the
  uncovered row
- if AC signoff is `partial` or `blocked`, include a finding naming the row and
  the gap between the evidence and the expected behavior
- do not sign off outcome AC from route labels, helper return values, mocks,
  CSS selectors, local state labels, or object-shape checks
- do not output `No findings.` when any assigned AC row is still unproven at its
  required proof depth
- for terminal clean-code retirement slices, include a finding for any leftover
  unused/deprecated code or non-code surface lacking an explicit retained reason
- output bullet issues only
- include no prose summary unless there are zero findings
- if there are no findings, output the metadata line followed by exactly
  `No findings.`

## Sub-Agent Lifecycle

Review agents are scarce. Keep review independent from implementation, but
avoid an unbounded series of agents.

- treat each reviewer as temporary
- never fork or copy the full chat context for slice review
- pass compact context only
- prefer file paths, commit ids, focused excerpts, test names, and concise
  verification summaries
- if a reviewer is completed and no same-slice follow-up is needed, close it
- if a reviewer is stale, blocked, superseded, or duplicative, close it
- keep at most one combined slice-review agent active by default
- reuse an idle combined reviewer for later slices in the same SDLC run when
  that still preserves independence
- spawn a fresh reviewer only when no same-role reviewer exists, the existing
  reviewer is busy or stale, or the slice requires fresh independence
- keep reviewers open through same-slice finding fixes and re-review
- close reviewers after findings are resolved, accepted as no-fix, or explicitly
  deferred and no more same-slice follow-up is expected

Every compact new reviewer prompt must include:

- current diff or commit
- changed files
- relevant plan excerpt
- verification status
- unresolved prior findings if relevant
- assigned Product AC, Technical AC, Negative AC, trace rows, planned tests,
  affected files, forbidden states, and expected AC coverage verdict
- assigned final AC verification matrix rows, exact expected behavior, required
  proof depth, current proof evidence, and requested signoff status
- whether each assigned AC row closes now or remains partial for a named later
  gate
- clean-code retirement expectation
- for LLM-facing slices, explicit review checks for provider-agnostic reusable
  source, no fixture/provider/test-case tuning in reusable wording, contract
  grammar minimization, and whether deterministic runtime assembly still owns
  values already known from selected refs or contract-shape singletons

Triage does not complete the review loop. If the reviewer reports findings:

- triage the findings with the parent agent
- implement fixes in the primary agent
- send the fix diff or commit, diff summary, and original finding back to the
  same reviewer when that reviewer is still healthy
- do not spawn a fresh reviewer just to validate the fix unless the original
  reviewer is unavailable, stale, noisy, or the fix changed the risk profile
- close the reviewer only after its finding is fixed and accepted, accepted as
  no-fix, or explicitly deferred

## While Reviews Run

The implementation agent may continue review-independent prep named in the
execution plan, such as reading next-slice context, updating planning docs in
the selected task branch/worktree, preparing tests, inspecting files, or
running harmless verification.

Do not commit the next risky slice, or make implementation changes likely to be
invalidated by review findings, until this slice's combined review has returned
and findings are resolved, accepted as no-fix, or explicitly deferred.

Record in the review result:

- commit or current diff reviewed
- review model and reasoning effort
- escalation reason, or `none`
- AC coverage verdict
- AC signoff verdict for matrix rows
- unchecked or deferred AC ids, or `none`
- which assigned rows were proven at their required boundary versus which remain
  partial or blocked
- reviewer lifecycle: `reused` or `fresh`, whether same-slice follow-up was
  needed, and whether the reviewer was closed after resolution
- compact-context source used for the review
- verification status at review time
- clean-code retirement status
- terse bullet findings and triage decision

## State Updates

If `.sdlc/state.json` exists, reviewers should use only the compact state fields
needed for the current review unless escalation requires history.

- state may identify slice id, reviewed diff or commit, review status,
  verification status, and unresolved prior findings
- do not read full history for a routine first-pass review
- read history only for repeated failures, disputed findings, stale reviewer
  recovery, or explicit parent-agent request
- when review returns findings, set review status `blocking_findings` until
  findings are fixed, accepted as no-fix, or explicitly deferred
- when the combined review is clean or triaged, set review status
  `review_clean`, `no_fix`, or `deferred` as appropriate
- record reviewer lifecycle decisions in the durable progress/review artifact,
  not as long prose in state

## Exit Criteria

- the slice commit exists, or the current slice diff is ready for review before
  broad verification
- the combined review exists
- the review result records selected models and any escalation reason
- findings are resolved, accepted as no-fix, or explicitly deferred before the
  next risky slice starts
- idle or completed review agents from this slice are closed or intentionally
  retained as the same-run role reviewer for the next slice

## Telemetry Tool Failure Logging

Telemetry, retrieval diagnostics, command journals, and accounting captures are
optional local debugging data, not review evidence that an LLM must maintain.
When an enabled telemetry operation fails, record one local incident and do not
retry it merely to improve paperwork. Keep raw output gitignored and out of the
review result.

This does not waive a substantive launch/lease, review, product verification,
security, Git-head, or protected-merge failure independently established
without telemetry. Missing reporting or accounting telemetry alone does not
make an otherwise proven review `review-needed`.

## Accounting Telemetry Failure Rule

If accounting telemetry is enabled, attempt it once. On failure, record one
local `telemetry_incomplete_non_product` incident and do not retry, reconstruct,
replay, backfill, or create an evidence-only commit. Continue through the
independently validated product, review, Git, and merge gates. Accounting
telemetry never changes the completion claim.
