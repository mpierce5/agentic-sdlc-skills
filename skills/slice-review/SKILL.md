---
name: slice-review
description: "Independently review one Full slice or Light/Defect compact change. Check correctness, architecture, cleanup, and outcome AC, reporting code-review status separately from acceptance proof."
---

# Slice Review

Agent routing: Independent review at the adapter's review model and effort.
Resolve concrete model and effort through the active platform adapter or explicit
task/repo policy. See the shared [routing policy](../sdlc/SKILL.md#model-and-agent-policy);
helper loading retains the existing owner/model.

## Mode-specific packet and two verdicts

Full is the default. Light/Defect accept `$sdlc`'s compact packet with scope,
accepted outcome/negative/technical checks, proof boundaries, affected seam,
guardrails, verification status, and cleanup expectations. It replaces separate
plan excerpts, trace rows, and final matrices everywhere below. Missing a Full-only
artifact is not a finding; missing expected behavior or proof depth is.

The independent LLM reviewer combines correctness, AC drift, architecture
conformance, and cleanup for bounded work. No separate refinement bench or human
code reviewer is required. Full retains its planned refinement/acceptance roles.
Humans confirm AC or assist with unresolved design/architecture decisions.

Return code-review and acceptance as separate verdicts in every mode:

- `code_review: CLEAN | FINDINGS` for the diff, architecture, and cleanup;
- `acceptance: pending | verified | partial | blocked` for required outcome proof;
- `architecture_conformance: CLEAN | FINDINGS` and `cleanup: CLEAN | FINDINGS`.

Code-review CLEAN with acceptance pending permits targeted verification only.
Unrun planned proof is pending, not a blocking code finding. Failed proof or
insufficient completed proof remains blocked/partial. Never sign off unproven
AC, merge, or call the change green from code-review CLEAN alone. After targeted
checks, inspect the evidence summary with the same reviewer; this evidence
follow-up does not restart full diff review unless a material fix changed it.
The final verdict binds the final diff/commit and proves each required AC at
its boundary. Preserve all applicable provider/genericity/domain-authority checks.

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
- validate the slice against its supplied AC/TAC packet and mode-specific proof
  record: Full's final matrix or Light/Defect's single compact AC/proof table
- verify each assigned AC at its named proof depth before signing it off
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
- compare available proof to expected behavior row by row before acceptance
  signoff; intermediate-only proof is partial/blocked, while planned unrun proof
  is pending and does not prevent an independent code-review verdict
- mark AC coverage `partial` or `blocked` when the proof validates only
  intermediate implementation behavior rather than the promised outcome
- mark acceptance blocked when owned AC, proof depth, or the later gate for a
  partial row is missing. Before planned checks run, mark proof evidence pending;
  do not block code review solely because targeted verification comes next
- do not convert pending verification into acceptance verified or overall
  completion; code-review CLEAN may explicitly coexist with acceptance pending
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
- `ACCEPTANCE`: outcome acceptance using the mode-specific AC/proof record,
  architecture review, correctness sweep, and UX review
  when applicable
- `CLEANUP`: terminal clean-code retirement review; validates removals,
  no-reference proof, no supported-behavior regression, and no broad unrelated
  cleanup beyond the plan

In Full mode, end-of-wave `ACCEPTANCE` review must use two separate
reviewers:

- one architect reviewer
- one TPM or acceptance reviewer

## Model Routing

Resolve concrete models and reasoning through the active platform adapter or
repo-local policy. Use `economy-review` for bounded routine review,
`standard-review` for cross-file or contract risk, and `frontier-review` for
high-risk or ambiguous architecture judgment. These scope aliases may map to
the same concrete model and effort; follow the adapter's mapping rather than
inferring a price tier from the name. Record the actual assignment and increase
review depth/context when the reviewer cannot reliably resolve the issue.

Increase review depth and context when the slice touches auth, permissions, privacy, payments,
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
  proof and completed evidence does not directly prove that outcome; planned
  unrun proof is pending and does not alone force deeper code review
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
  `scope: <diff-only|changed-files|expanded-to-contract>; model: <model>; workflow_mode: <full|light|defect>; code_review: <CLEAN|FINDINGS>; architecture_conformance: <CLEAN|FINDINGS>; cleanup: <CLEAN|FINDINGS>; acceptance: <pending|verified|partial|blocked>; AC coverage: <pending|complete|partial|blocked|not applicable>; unchecked AC: <ids|none>; AC signoff: <pending|signed-off|partial|blocked|deferred|not applicable>`
- if AC coverage is `partial` or `blocked`, include a finding naming the
  uncovered row
- use AC coverage `pending` for planned unrun proof; include unchecked IDs
  without manufacturing a code finding for verification that comes next
- if AC signoff is `partial` or `blocked`, include a finding naming the row and
  the gap between the evidence and the expected behavior
- do not sign off outcome AC from route labels, helper return values, mocks,
  CSS selectors, local state labels, or object-shape checks
- `No code findings.` may accompany acceptance pending before planned proof.
  Do not output an unqualified `No findings.` or acceptance verified while any
  required AC remains unproven
- for terminal clean-code retirement slices, include a finding for any leftover
  unused/deprecated code or non-code surface lacking an explicit retained reason
- output bullet issues only
- include no prose summary unless there are zero findings
- if code has no findings but planned proof is pending, output the metadata
  followed by `No code findings; acceptance pending.` Once all required proof
  is independently inspected, output the metadata followed by `No findings.`

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
- assigned Product/Technical/Negative AC, planned checks, affected files,
  forbidden states, and expected coverage; trace rows apply only to Full
- assigned mode-specific AC/proof rows, exact outcome, required proof depth,
  current evidence, and requested signoff status
- whether each assigned AC row closes now or remains partial for a named later
  gate
- cleanup expectation: inline for Light/Defect, planned retirement for Full
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
- AC signoff verdict for mode-specific proof rows
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
