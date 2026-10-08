---
name: sdlc
description: "Coordinate a phase-gated prerelease product workflow across the narrower SDLC skills. Use when the user wants a feature, refactor, UX change, bug fix, contract change, or implementation wave refined, planned, reviewed, implemented slice by slice, verified, and closed with durable artifacts. This skill is the orchestrator: it must create and follow an explicit checklist, load the relevant phase skill before each phase, enforce gates, and prevent skipping required reviews or confirmations."
---

# SDLC

Use this skill as the human-directed workflow owner for prerelease product
work. That owner may be:

- a coordinator preparing or handing work to another execution task; or
- the current single task directly owning the implementation wave.

Keep it lightweight: it owns phase order, checklist discipline, gate
enforcement, and subskill loading. Detailed rules belong in the narrower phase
skills and the repo artifacts they maintain.

## Portability And Authority

Load the active platform adapter and consuming-repo instructions before using
platform-specific capabilities. Those instructions define concrete model
routing, setup commands, provider-test authority, deployment exceptions, and
coordination tooling. Do not assume another project's scripts or services exist.
Skill invocation does not override host restrictions on task creation, messaging,
scheduling, model selection, or external actions. Follow the user's authorized
scope and any higher-priority permission requirements.

## Boundary With Agentic SDLC

This is the human-directed workflow. Do not import autonomous operational-agent
behavior such as self-healing queues, preserved-candidate retries, or
agent-generated accept/merge gates unless the user explicitly asks for
`$agentic-sdlc`.

Reviewer sub-agents used here are independent reviewers for a human-directed
task. They are not autonomous workers.

The hard context rule is: do not fork broad parent chat context into a child
implementation worker. A single task may directly continue into implementation
in its own lane and use only compact-context subagents for bounded helper or
review work.

## Direct-Owner Decision

After an isolated lane exists, decide ownership before requesting or requiring
another task:

- **Current-task direct owner:** when the current task created or selected the
  lane and remains responsible for the current phase or assigned substantive
  implementation slice, it must continue in that lane through that unit's
  clean exit. Record launch mode `current-task-direct`, parent thread id
  `none`, and parent-context fork state `no`. Do not require a second visible
  task inside the same assigned slice.
- **Orchestrated slice boundary:** in a multi-slice implementation wave, the
  default owner boundary is one user-user-visible top-level task per substantive
  slice. Retain that task through review, verification, its own
  `$golden-merge`, protected merge verification, and closeout. Then persist the
  handoff/result/telemetry boundary and transfer the next slice to a fresh
  visible task. Reusing one task for multiple substantive slices requires an
  explicit plan-level `single-task-wave-owner` exception with rationale; it
  must never be inferred from shared lane or wave ownership.
- **Separate-task handoff:** use a fresh visible task and compact lane-local
  handoff only when ownership is intentionally transferred to another task.
  That worker must not inherit or fork the sending task's chat. When the
  accepted plan selects `serial-exclusive-lane-transfer`, the fresh task may
  take over the existing clean lane only under the ownership-transfer contract
  in Hard Gates; this is not permission for overlapping writers.

Lack of a thread-creation tool is never a blocker for the current-task direct
owner. It is a blocker only after the workflow has chosen a separate-task
handoff and no fresh task can be created.

## First Action

Immediately create an explicit checklist before doing substantial phase work.
Use the platform plan tool when available. Exactly one checklist item may be
`in_progress` at a time.

Default full-run checklist:

1. Worktree setup discovery with `$worktree-setup`
2. Initial problem framing and required external-practice research brief
3. Independent research challenge and AC-evidence review
4. Requirements discovery and Product/Negative AC draft
5. Requirements confirmation from user
6. Phase 0 refactor-health assessment
7. Phase 0 planning-artifact commit
8. Functional plan draft
9. Independent functional-plan review
10. Functional-plan updates from review
11. Functional-plan commit
12. Technical plan draft
13. Independent technical-plan review
14. Technical-plan updates from review
15. Technical-plan commit
16. Execution plan draft
17. Independent execution-plan review
18. Execution-plan updates from review
19. Execution-plan commit
20. Ready-for-implementation checkpoint
21. One-slice implementation
22. Independent slice review
23. Slice review fixes or explicit deferrals
24. Targeted slice verification
25. Slice commit
26. Final clean-code retirement slice
27. Final wave verification, when required
28. Worktree/lane closeout with `$worktree-setup`, when applicable
29. Merge-current-main integration check on the task branch before PR merge
30. Final acceptance/deployment/status closeout

Worktree setup means: load `$worktree-setup`, follow the repo's configured
branch/worktree/lane workflow, record the selected checkout and any required
verification URL/bootstrap command, and keep any canonical/shared root checkout
clean on `main` and updated only by fetch/pull from `origin/main`. If the repo
has no worktree/lane concept, mark setup and closeout `not applicable` with a
reason.

If the user asks for only one phase or a resumed phase, create the smaller
checklist needed for that phase.

## Research Gate

Treat external-practice research as a required decision gate, not a preamble.
It exists to prevent the team from rediscovering settled engineering practice,
copying a familiar local pattern into the wrong problem, or writing acceptance
criteria before understanding viable alternatives.

Before drafting Product AC or Negative AC for any non-trivial feature,
refactor, reliability change, workflow, data model, retrieval system, or
cross-boundary behavior:

1. Write the decision question and the local constraints that make it
   consequential.
2. Research current primary sources where available: official documentation,
   specifications, maintained reference implementations, or original papers.
   Use secondary material only as a lead, never as the sole basis for a design
   decision.
3. Compare at least two viable approaches, including their failure modes,
   operational cost, testability, and fit with the local architecture. State
   the rejected approach and why it is rejected.
4. Identify the narrowest verification strategy that can distinguish the
   selected approach from the rejected alternatives.
5. Persist a concise research brief in the requirements artifact or a linked
   durable research artifact. It must include sources, retrieval date where
   temporal change matters, applicability, and explicit open decisions.

The research gate may be `not needed` only when a concrete rationale shows
that no material design choice exists (for example, a mechanical rename with an
already-approved contract). "This is familiar," a prior implementation, or a
generic best-practice claim is not a rationale.

An independent TPM or architect reviewer must challenge the research before
requirements confirmation: check that sources are appropriate, alternatives
are real, local constraints were applied, and acceptance criteria actually
follow from the evidence. A research brief that only lists links, summarizes
one preferred option, or lacks rejected alternatives fails the gate.

Do not enter Phase 0, functional planning, or implementation until the
requirements artifact records a passing research gate and AC-evidence review.
If later discovery changes a material decision, reopen the focused research
gate and revise the affected AC before proceeding.

## Bounded Defect Fast Path

Use this path instead of the default full-run checklist when all of the
following are true:

- the user asks to fix a concrete observed defect and authorizes implementation;
- the intended behavior is already established, so no new product, UX,
  product, security, privacy, or ownership semantics must be chosen;
- the repair is expected to fit one implementation slice in known architecture
  seams;
- the change does not introduce a new public contract, data migration, or broad
  cross-system redesign.

Create this smaller checklist:

1. Worktree/lane setup and defect evidence capture
2. Compact defect packet with scope, Product AC, Negative AC, architecture seam,
   targeted proof, and explicit deferrals
3. Bounded architecture-fit check and independent review of the packet
4. One-slice implementation
5. Independent slice review and fixes
6. Targeted verification plus regression proof
7. Slice commit and requested merge/deployment closeout

The compact defect packet replaces separate requirements, Phase 0, functional,
technical, and execution-plan documents. Record those separate phases as
`combined in bounded defect packet`, not silently skipped. A separate user
confirmation gate is unnecessary when the user already stated the expected
behavior, narrowed the scope, and explicitly authorized the fix.

Escalate immediately to the default full workflow when investigation reveals
new semantics, multiple independently risky slices, a migration, an unknown
architecture boundary, or material security/privacy/ownership impact. Do not
escalate merely because the repository is large, tests are slow, or the defect
touches a golden path with an established adapter pattern.

## Review, Verification, And Evidence Defaults

Keep the existing review gates:

- refinement uses proportional, phase-level TPM and architect review. Treat the
  complete phase artifact or a genuinely semantic delta as the review unit.
  Batch minor wording, citation, threshold-label, formatting, and internally
  consistent precision fixes, then request one consolidated final re-review;
  never trigger a reviewer round after each small edit. Re-review immediately
  only when a fix changes scope, AC behavior/classification, architecture or
  ownership, provider calls/cost, security/privacy, persistence, or another
  reviewer finding. One CLEAN consolidated TPM+architect pass closes the phase;
- implementation normally uses independent slice review before targeted
  verification. An authorized repair of an already captured LLM semantic
  failure is the narrow exception: after the generic fix and only the minimum
  provider-free safety/admission check, replay that exact failed row first and
  iterate until GREEN, then run the fresh configured unseen group on the
  candidate branch. Perform independent review and the remaining affected
  deterministic verification only after those live proofs are GREEN;
- terminal cleanup/conformity review checks architecture drift, obsolete or
  duplicate paths, unused code, temporary helpers, and implementation cruft;
- final architect and TPM/acceptance review run when the accepted plan requires
  an end-of-wave acceptance gate.

Make verification impact-based. Map the diff and current-main conflicts to
affected behavior, boundaries, tests, and AC rows. Run the smallest meaningful
deterministic proof plus the smallest required integration boundary. Reuse
unchanged passing proof. Repairs rerun failed/affected checks and genuine
dependents only. A complete repository or catalog sweep requires explicit
accepted-plan authority tied to a release-level, migration, security, or
cross-system risk; final acceptance alone does not imply one.

LLM/provider tests are not part of the standard suite. Run only impacted rows
when the user authorizes them, the accepted plan explicitly requires them, or
the changed behavior is materially model/provider-dependent and deterministic
proof cannot establish the boundary. For a new scenario, run the minimum
provider-free safety/admission proof first. For an already captured semantic
failure, make the narrow generic fix, replay that exact failed LLM row
immediately after the minimum safety check, and iterate it until GREEN. Then
run the fresh configured unseen qualification group on the candidate branch
before independent review, broader deterministic checks, or merge. If review
changes provider-visible behavior, rerun the affected diagnostic and unseen
live proof; if it changes the scenario generator, hydration, oracle, or test
definition, generate a new unseen group. Never rerun a passing provider row
merely to refresh evidence, hashes, timestamps, or commit identity.

Paid replay remains within the accepted provider, budget, and retry authority.
Do not interpret `until GREEN` as unlimited spending or permission to change
approved semantics. Stop dependent paid attempts when the authorized budget or
retry limit is reached, provider access is unavailable, or a repeated failure
cannot be repaired safely within the reviewed scope; preserve the candidate
and report the concrete unresolved boundary.

Commit formal, human-reviewable artifacts: requirements, research, plans, AC,
review verdicts, and concise signoff/results. Keep raw prompts/responses,
hydration packets, retrieval traces, provider witnesses, failed attempts,
token/latency/cost captures, invocation journals, telemetry, operation
receipts, caches, and generated corpora local, machine-generated, and
gitignored. Do not require an LLM to maintain or reconcile raw run output.

Bind integrity to stable semantic identities, schemas, canonical inputs, and
protected expectations. Whole-file, documentation, artifact-placement,
timestamp, and Git-head hashes do not invalidate behavior proof. Do not create
separate verification-budget documents, invocation indexes, retention proofs,
or evidence-only commits for ordinary work.

## Subskill Loading Rule

Before doing phase work, load and follow the relevant subskill `SKILL.md`. Do
not rely on memory or on this coordinator's summary. Use the current
workspace's installed skills root or the repo's `skills/` directory rather than
hardcoding a personal path.

Phase skills:

| Phase | Skill |
| --- | --- |
| Requirements and Product/Negative AC | `$requirements-discovery` |
| Phase 0 architecture fit | `$refactor-health` |
| Functional planning | `$functional-plan` |
| Technical planning | `$technical-plan` |
| Execution planning | `$execution-plan` |
| Worktree/lane setup | `$worktree-setup` |
| Cheap lane bootstrap and handoff-doc prep | `$lane-bootstrap`, when installed and the user wants a new execution lane prepared for another agent or thread |
| One-slice implementation | `$slice-implement` |
| Slice review | `$slice-review` |
| Merge/rollout closeout | `$golden-merge`, when installed and the user wants merge-to-main closeout for either golden or non-golden work |
| Durable execution state | `$sdlc-state` |

When delegating to a sub-agent, include the relevant skill name, the current
phase or checklist item, and any local or repo-relative path the platform needs
to load that skill.

When the user wants a fresh implementation lane or a visible execution thread
to take over after setup, load `$lane-bootstrap` when it is installed. The
orchestrator delegates lane procurement to a bounded setup agent with parent
context forking disabled. That setup agent prepares the fresh branch/worktree/
lane and lane-local handoff, then returns control to the orchestrator. The
orchestrator launches the visible execution owner from that compact handoff;
the setup agent does not implement the slice.

## Hard Gates

Treat this workflow as gated, not advisory.

- start with worktree setup discovery unless the user explicitly narrowed or
  resumed the task
- do not edit code or planning artifacts until applicable setup is recorded or
  marked `not applicable`
- do not use a canonical/shared repo root checkout for task-owned planning,
  implementation, retry, review-fix, or merge work when repo-local instructions
  require isolated task work; if the root checkout is found on a task branch or
  has task-owned dirty files, stop and report it unless the user explicitly
  asked for repair
- provision every newly created independent top-level refinement or
  implementation lane from current `origin/main` in a fresh isolated worktree.
  Do not base a new lane on another worker branch or fork/copy that worker's
  chat context; use the lane-local handoff and bounded retrieval packet instead.
  A shared-seam integration exception must name its exact commit, reason,
  locks, and merge order, and is merged into the fresh lane after provisioning.
- a fresh visible next-slice owner may take over an existing
  `serial-exclusive-lane-transfer` lane only after the prior owner is
  review-clean, green, committed, and fully stopped as a writer. The durable
  handoff must bind the exact branch/worktree/base/final pushed head, clean
  status, released exclusive lease, and next slice. Before activation, the
  coordinator must bind the new task id, activation epoch, exclusive lease, and
  handoff/result paths; the new owner must verify those ownership identities
  before writing. Optional retrieval and telemetry diagnostics remain local and
  are not activation gates. No parent chat is inherited,
  no two tasks may hold the write lease, and any mismatch fails closed. This
  narrow ownership transfer does not authorize a new parallel lane to start
  from another worker branch; parallel or newly created lanes still use the
  fresh-`origin/main` rule plus explicitly reviewed prerequisite integration.
- do not start functional planning until requirements, Product AC, and Negative
  AC are confirmed by the user
- do not ask for requirements confirmation until the external-practice
  research gate and AC-evidence review are complete, or a documented
  `not needed` rationale explains why external practice cannot materially
  inform the request
- reject a research gate as incomplete unless its durable artifact names the
  decision question, applicable primary sources, alternatives considered,
  rejected alternatives, local constraints, verification implications, and
  AC-evidence mapping; a generic summary or unreviewed link list is not proof
- require the persistent TPM and architect reviewers to review the research
  brief as well as the requirements AC; any material disagreement reopens the
  research gate before Phase 0
- do not start functional planning until Phase 0 is complete
- do not start technical planning until the functional plan was independently
  reviewed and updated
- do not start execution planning until the technical plan was independently
  reviewed and updated
- do not start implementation until the execution plan was independently
  reviewed, updated, committed, and accepted
- do not create planning, slice, merge, or release-bound commits until the
  selected checkout's git author passes repo deployable-author rules when they
  exist
- do not run lane DB/schema repair, refresh, seeding, or template advancement
  from newer `main` code before the task branch integrated that same `main`
- do not start the next risky slice until the previous slice is review-clean,
  verified, and committed, or findings are explicitly accepted as no-fix or
  deferred
- do not accept a worker-reported blocker until the worker has repaired every
  safe, self-contained finding within its lane, rerun the affected proof, and
  obtained the required re-review; a shared-file boundary alone is not a
  blocker
- for failed LLM scenario rows, require a documented contract-hardening audit
  and generic repair/exact-rerun-until-green/fresh-unseen/final-re-review loop before accepting a blocker; presume a
  scenario named in the approved plan is supported. Permit an expectation
  correction only when deterministic evidence and independent review show the
  test is stale or invalid; require a human decision only for a change to
  approved product semantics
- require the hardening repair to stay generic and provider-agnostic: reject
  fixture/provider/row-specific tuning and any validator or executor semantic
  inference used to force the expected LLM outcome
- do not skip the final clean-code retirement slice unless the execution plan
  explicitly records that it is not needed after a full inventory
- do not sign off AC rows from intermediate-only proof
- do not call the wave complete until the final AC verification matrix is fully
  updated and any blocking or partial rows are fixed, accepted, or deferred
- require every implementation handoff to state that it is one uninterrupted
  implementation task: investigate, implement, verify, and repair before the
  next response. Progress updates, a partial implementation, a single green
  test, or a completed milestone are not completion boundaries.
- do not merge production-bound work to `main` until current `main` was
  integrated into the task branch, conflicts were resolved there, required
  verification passed on that integrated branch, and the repo's PR process was
  used unless the user explicitly approved an emergency direct-main exception
- if the user explicitly asks to skip a gate, record the skipped gate and the
  reason in the checklist and planning artifact

When in doubt, stop and ask the user.

## Main, PR, And Database Integration Order

Use this order for long-running or production-bound work:

1. Merge current `main` or `origin/main` into the task branch.
2. Resolve conflicts on the task branch.
3. Restart or refresh the selected lane against that integrated branch.
4. Run any required DB/schema repair, seed/setup, or template refresh from that
   integrated branch only.
5. Run targeted or final verification against that integrated code and data.
6. Push the verified branch, open or update the PR, and merge through the repo
   PR process.
7. After merge, update the canonical/shared root checkout by fetch/pull from the
   merged `origin/main`, verify it is clean/tracking `origin/main`, and run any
   repo-required deployment or status checks.

Never let the lane database move ahead of the branch under test. If it did,
mark verification contaminated in the planning/progress artifact and repair the
branch/data order before signoff.

## Impact-Based Verification And Evidence Reuse

Require valid proof for the behavior and boundaries affected by a change. Do
not optimize for proving that every historical command ran again.

- Before verification, map changed production code, contracts, data/schema,
  configuration, fixtures, and conflict resolutions to the tests and AC rows
  they can affect. Run that proof plus the smallest necessary integration
  boundary.
- Reuse retained passing evidence when its covered implementation, inputs,
  environment-sensitive contract, and expected behavior are unchanged.
- Do not invalidate evidence solely because the branch head changed, unrelated
  files merged, a timestamp changed, documentation moved, or a mixed-purpose
  source file received unrelated edits.
- Do not rerun passing tests merely to refresh a whole-file hash. Bind integrity
  checks to canonical protected payloads such as stable row ids and semantic
  expectations, not incidental file bytes or test placement.
- A repair reruns its failed/affected proof and any genuinely dependent checks.
  It does not restart the entire final suite. A final acceptance owner runs
  affected checks plus checks previously `not_evaluable` or `not_run`, retains
  unaffected proof, and performs a broad sweep only when the accepted plan
  explicitly requires it for a named risk.
- Clean-code retirement evidence is regenerated only when the retired surface,
  authority boundary, forbidden dependency/artifact set, protected denominator,
  or canonical expected semantics changed. Ordinary code layout, test layout,
  and unrelated feature changes require at most the inexpensive verifier.
- Cryptographic signatures are not a default SDLC, evaluation, retirement, or
  merge requirement. Require one only for an explicit security/compliance
  threat model or external release authority accepted by the user in the plan.
  Hashes provide change detection, not proof that work was valuable.

When current `main` is integrated, repeat the impact assessment. Conflict
resolution or upstream edits touching an affected boundary expand verification;
non-overlapping upstream changes do not invalidate unrelated passing evidence.

## AC Signoff Standard

The AC trace table is planning traceability, not final signoff. Every
implementation wave must maintain a final AC verification matrix that records
for each row:

- AC id and type
- exact expected behavior
- concrete proof/test
- proof level: `behavior/API/service`, `contract`, `unit/helper`, `visual`, or
  `manual`
- reviewer signoff status: `signed-off`, `partial`, `blocked`, `deferred`, or
  `not applicable`
- unchecked/deferred notes and the owner or follow-up gate

If the proof shows only intermediate mechanics, the row stays `partial` or
`blocked`. When an AC crosses service/API, persistence, provider, permission,
billing, notification, scheduler, sync, FE/backend, or other module boundaries,
final proof must reach that boundary unless the execution plan explicitly
justifies a narrower proof.

## Documentation And State

Planning artifacts must live in the repo on the selected task branch/worktree,
not only in chat. Do not create, update, stage, or commit planning artifacts in
a canonical/shared root checkout.

Raw execution evidence is not a planning artifact. Keep provider payloads,
transcripts, packets, traces, telemetry, receipts, token snapshots, command
journals, caches, and generated corpora in local gitignored storage. Formal
results summarize the executed check, outcome, relevant identity, and
limitations without embedding raw payloads.

Before implementation starts, the planning artifact must capture:

- approved scope
- Product AC, Technical AC, and Negative AC
- AC trace table
- architecture or technical decisions
- slice-by-slice execution plan
- final clean-code retirement expectation
- explicit verification plan
- final AC verification matrix
- out-of-scope items
- current risks and guardrails
- progress tracking
- for every legacy-to-golden conversion: the legacy-surface inventory, golden
  replacement proof path, deletion/retention decisions, focused reference/import
  retirement checks, and independent-review AC rows

Use `$sdlc-state` when the repo uses `.sdlc/state.json` or the user asks for
durable execution state. State is an execution index, not a replacement for the
planning artifact or review gates.

## Commit Discipline

When a planning phase updates repo docs:

- verify the selected checkout's local git author passes repo deployable-author
  rules when they exist
- verify the selected checkout is not the canonical/shared root
- stage only the planning artifacts touched by that phase
- leave unrelated dirty work alone
- do not stage source code, generated files, lockfiles, or unrelated changes
  with planning-doc commits
- record the planning-doc commit hash in the planning artifact or progress log
- if committing is impossible, report the blocker and the exact dirty doc paths

Implementation slice commits are governed by `$slice-implement`.

## Context Discipline

Read repo-local instructions before planning or coding:

- repo-level agent instructions such as `AGENTS.md`
- workflow, architecture, contract, UX, defect, or implementation-plan docs
  relevant to the request
- `skills/sdlc/references/repo-sources.md` for source-selection guidance

Cache stable context in repo artifacts when it will be reused. Pass compact
references and deltas to sub-agents rather than repeatedly pasting unchanged
docs, logs, DOM dumps, payloads, or diffs.

Reviewer sub-agents must not inherit the full parent chat context. Give them a
compact packet with the diff or commit, changed files, relevant AC/TAC rows,
final AC verification rows, focused proof, and only the excerpts needed for the
decision.

Execution-context isolation is a hard gate, not a preference:

- `parent lane` means branch/worktree/file ownership only; it never means
  parent-chat inheritance, forking, copying, or summarization;
- if the current task is the intended owner of the current phase or assigned
  slice, it may continue directly in its selected lane without creating
  another top-level thread inside that unit;
- for orchestrated multi-slice implementation, a green slice commit ends that
  task's default writable ownership. The coordinator launches the next
  substantive slice as a fresh visible task from compact durable state unless
  the accepted plan explicitly records `single-task-wave-owner`;
- record that direct continuation as `current-task-direct` with parent thread
  id `none` and parent-context fork state `no`; it is valid launch evidence,
  not an unrecorded or inherited-context exception;
- if execution is being handed from one task to another, the receiving
  implementation or continuation worker must start from a compact lane-local
  handoff and bounded retrieval packet rather than inherited parent chat;
- when that handoff reuses a serial-exclusive lane, the receiving task must
  also prove exact-head continuity and the coordinator's exclusive-lease,
  activation-epoch, and ownership-registry rebinding before it writes; absent
  that proof, provision a fresh lane instead;
- when a host cannot create a visible task, return the minimal handoff prompt
  only if a separate task handoff is actually required. Do not substitute an
  inherited-context subagent for full execution;
- for bounded bootstrap, helper, or reviewer subagents, explicitly set parent
  context forking to `false` when the spawn tool supports it and pass only the
  compact packet;
- do not continue a long execution thread by spawning a child that inherits its
  conversation. Either keep ownership in the current task or persist the state
  in the handoff/result artifact and start a fresh task from that durable
  state;
- record launch mode, parent thread id when applicable, explicit fork state,
  and execution role in the compact handoff. Missing ownership/context
  isolation evidence is `review-needed`; retrieval hashes and telemetry are
  optional local diagnostics.

Silent execution is required: do not send routine progress reports about
searching, reading, tools, tests, or partial checkpoints. Record state in the
compact lane artifact; keep raw telemetry local. Send a user-facing message only for a
genuine blocker, a required decision or approval, final completion, or the
required minimal fresh-task handoff when a separate task handoff is actually
required and the host cannot create that task. Treat unavailable host task
creation as a blocker only for that handoff case; it is not a blocker when the
current task is the direct execution owner.

When the user asks to merge or roll work to `main`, load `$golden-merge` when
it is installed instead of carrying the full merge/closeout procedure inline.
Treat that skill as the merge closeout authority for both golden and non-golden
work, including concise formal and coordination closeout. Any captured
telemetry remains optional local diagnostic data.

## Model And Agent Policy

Invoking `$sdlc` is standing permission to spawn, reuse, message, wait on, and
close the reviewer agents required by this workflow. Use the model tiers defined
by the active adapter or repo-local instructions:

- `economy-review`
- `standard-review`
- `frontier-review`

Default routing comes from the active platform adapter or repo-local policy:

- use a lower-cost capable model for bounded lane/bootstrap work;
- use the documented execution model and reasoning for writable slice owners;
- map routine review to `economy-review` and escalate to `standard-review` or
  `frontier-review` when risk or reviewer uncertainty requires it;
- keep repository provider-test policy separate from execution-agent routing.
  Required providers, optional comparisons, admission rules, and paid-test
  limits come from the consuming repo and accepted plan.

The implementation agent must not be the only reviewer of its own work. If
independent review tooling is unavailable, use a separate fresh reviewer session
or a human reviewer and record that plainly in the planning/progress artifact.

Visible-thread rule:

- creating a separate user-visible execution task is a tool-dependent action,
  not a guaranteed capability of every session;
- orchestrated multi-slice implementation defaults to one visible top-level
  task per substantive slice. This keeps slice status observable, permits
  explicit model routing, isolates failure/recovery, and enables real
  dependency-safe parallelism;
- direct ownership remains valid within the currently assigned slice. A
  single task may own multiple substantive slices only when the accepted plan
  explicitly selects `single-task-wave-owner` and records why visibility,
  model specialization, and parallelism are not required for that wave;
- before promising a visible execution thread, check whether the thread
  creation tool is actually exposed in the current session;
- if the current task is already the intended execution owner, continue in the
  assigned lane and use subagents only for bounded helper or review work with
  parent-context forking disabled;
- if it is available, prefer the prepared-lane handoff flow:
  1. spawn a bounded no-parent-context lane/bootstrap setup agent;
  2. have that setup agent procure the fresh `origin/main` worktree and write
     or refresh the lane-local handoff/retrieval packet;
  3. return or record the branch, worktree, result-path, handoff-doc path, and
     lock details;
  4. create the visible top-level execution thread directly from the current
     session;
  5. send only a minimal handoff prompt that tells the new thread to run lane
     status, read the handoff and any available retrieval packet, and remain
     read-only until exclusive ownership is bound;
  6. use the consuming repo's documented owner-binding entrypoint with the
     returned real task id. Never substitute a coordinator id, guessed future
     id, undocumented internal call, or hand-authored ownership-registry patch.
     If no registry tooling exists, record and verify exclusive ownership in
     the durable handoff. Optional retrieval hashes and telemetry are not
     activation gates;
  7. only after ownership is verified may the task perform writable slice work;
- never use a context-forked subagent as a substitute for a full-slice
  execution task, whether that task stays in the current thread or moves to a
  new one;
- reserve top-level visible threads for full-slice execution ownership; use
  subagents inside that execution thread for bounded helper, setup, and review
  work;
  - when selecting a visible-thread model, use the cheapest acceptable explicit
    model exposed on that host/session and only escalate when the plan calls for
    it;
- if it is not available, do not imply that a visible non-subagent thread was
  created. Instead:
  1. run the cheap lane/bootstrap worker if needed;
  2. write or refresh a lane-local handoff doc;
  3. return the branch, worktree, result-path, handoff-doc path, and lock details;
  4. return a minimal copy/paste `bootstrap_wait` handoff prompt for the intended
     execution model. It must remain read-only until the coordinator can bind
     the actual task id and explicitly activate it.

Coordinator heartbeat rule for visible execution lanes:

- When the user authorizes scheduled recovery, use one 15-minute abnormal-recovery heartbeat on the
  coordinator's own task/lane while nonterminal lanes exist. Each wake resumes
  the coordinator from durable coordination state only to recover an abnormal
  stop, process an explicit worker report, or activate newly eligible work. It
  never interrupts healthy active work or becomes a second worker loop.
- Deprecated process: one-minute heartbeat schedules, sentinel/watchdog agents,
  idle-classification automations, automated `resumeDirective` polling, and
  unconditional continuation messages to workers. Do not create or reactivate
  them.
- Workers report normal completion, blocking, and intentional waits directly
  to the coordinator. The coordinator may communicate a concrete unblock,
  ownership transfer, or corrected handoff, but does not interrupt active work
  or use scheduled liveness messages as a second worker loop.
- The coordinator owns abnormal-stop recovery. Recover the same lane when safe;
  after unsafe or repeated recovery failure, have a setup agent provision a
  fresh replacement lane and continue independent eligible slices.
- Pause or remove the 15-minute abnormal-recovery coordinator heartbeat when
  the program has no nonterminal lanes. If scheduled continuation is
  unavailable or unauthorized, record that limitation and use direct status
  checks while the coordinator is active. Do not create a schedule implicitly.

Worker-owned merge rule for orchestrated lanes:

- A substantive lane owner normally completes its own `$sdlc` unit through
  review, targeted verification, `$golden-merge`, protected merge verification,
  concise formal/coordination closeout, and safe local-main sync or a recorded sync
  exception. The owner invokes `$golden-merge` from its existing slice lane;
  creating a separate hardening or merge lane for routine closeout is
  deprecated. Do not stop at `ready-for-integration` merely to hand routine
  merge work to the coordinator.
- Coordinator merge takeover is exception-only: abnormal worker termination,
  repeated unsafe recovery, a human gate, or a planned multi-branch/shared-
  aggregate integration gate that cannot be owned by the current lane. Record
  the reason and exact reviewed head before takeover.

Retrieval and telemetry rule for orchestrated top-level lanes:

- provision a task-specific retrieval packet when it is useful and supported.
  Read a successful packet; record a stale, empty, ambiguous, missing, or failed
  packet once as a non-blocking local tooling limitation;
- when the repo exposes telemetry, treat it as optional local diagnostic data.
  Raw plans, baselines, capture indexes, snapshots, and retention proofs remain
  gitignored and do not become closeout gates;
- a concise formal result records branch/worktree, reviewed commit, affected
  verification, PR, and protected merge head. Missing telemetry does not make
  independently proven product work `review-needed`;
- keep lane/worktree identity, substantive slice identity, and task/thread
  identity separate. Optional usage baselines and deltas remain local
  diagnostics and are not completion gates;
- record the actual execution model and reasoning effort in local diagnostics
  when measurement is enabled; do not create a formal launch-evidence gate
  merely to prove model specialization.

Handoff-doc rule:

- the orchestrator delegates fresh-lane procurement to a bounded setup agent;
  that agent returns the prepared branch/worktree and compact handoff before the
  visible slice owner starts;
- prefer a lane-local handoff doc over a large prompt when resuming work in a
  visible execution thread;
- the visible-thread prompt should be intentionally short and should point the
  agent at:
  - branch
  - worktree
  - handoff doc
  - result path
- if the handoff doc is stale, incomplete, or missing the lane identity, fix
  the doc before handing off.

Reviewer spawn contract:

- explicitly disable parent-context forking when the spawn tool supports it
- do not fork or copy the full parent context
- pass only the review packet: skill name, phase or slice, checklist item, diff
  or commit, changed files, plan excerpt, assigned AC/TAC rows, final AC
  verification rows, proof summary, and any focused excerpts needed
- pass explicit reviewer role/model/reasoning overrides only when the tool
  supports them and the plan calls for them
- if a reviewer lacks enough context, send a narrower follow-up packet instead
  of escalating to a full-context fork

## Refinement Review Bench

During refinement, keep one persistent TPM reviewer and one persistent architect
reviewer across requirements, Phase 0, functional-plan, technical-plan, and
execution-plan review. Reuse them across phases, add specialists only when the
work materially needs them, record replacement reasons if a reviewer is swapped
out, and close the refinement bench once the ready-for-implementation
checkpoint is reached unless the user asks otherwise.

Routine implementation-slice reviews use `$slice-review`, not the refinement
bench, unless the execution plan explicitly escalates the slice back to
TPM/architect review.

## Phase Flow

Run the full workflow in this order unless the user explicitly narrows or
resumes the task:

1. Load `$worktree-setup`.
2. Load `$requirements-discovery`; it frames the problem, runs the
   external-practice research and AC-evidence gate, then drafts AC for user
   confirmation.
3. Load `$refactor-health`.
4. Load `$functional-plan`.
5. Load `$technical-plan`.
6. Load `$execution-plan`.
7. Stop at the ready-for-implementation checkpoint unless the user asked to
   execute.
8. For each approved slice, load `$slice-implement`.
9. For each slice review, load `$slice-review`.
10. Repeat implementation and review until the execution plan is complete.
11. Run the final clean-code retirement slice unless the execution plan
    explicitly says it is not needed.
12. Run final verification, acceptance review, deployment checks, or status
    checks as required. Apply only deployment exceptions explicitly authorized
    by the consuming repo or accepted plan. Record failed or unavailable
    deployment status truthfully; do not claim an unverified environment live.
13. Return to `$worktree-setup` for closeout when applicable.
14. The same substantive slice owner integrates current `main`, resolves
    conflicts on the task branch, runs the required impact-based verification,
    and invokes
    `$golden-merge` through the repo's protected PR process unless an explicit
    takeover exception applies.
15. Confirm concise merge-closeout state is current: lane result/handoff
    status, reviewed commit, affected verification, PR, and protected merge
    head. Do not block on raw telemetry bookkeeping.
16. Report final status.

## Output Economy

Keep coordinator output concise:

- current checklist item
- result or blocker
- artifact path or commit when relevant
- next action

Coordinator and worker progress updates are not stopping points. After an
intermediate status, failed proof, repair, or review finding, continue the next
safe execution step. Do not report a slice or lane final until its AC is fully
proven/reviewed/committed and retirement-clean, or a genuine external/human
blocker remains after all safe work is exhausted.

## Exit Criteria

Do not call an SDLC run complete until:

- the checklist reflects every required gate
- planning artifacts are current
- required independent reviews happened or the blocker is recorded
- slice commits exist for completed implementation slices
- the final clean-code retirement slice is completed or explicitly marked not
  needed with an inventory-based rationale
- worktree/lane closeout is recorded or explicitly marked not applicable
- any canonical/shared repo root checkout is verified clean, on `main`,
  tracking `origin/main`, and updated only by fetch/pull from `origin/main`;
  any root checkout branch drift or dirty task-owned file is recorded as a
  blocker or repaired only by explicit user-approved cleanup
- the task branch integrated current `main` before PR merge and required
  verification passed after that integration
- production-bound work merged through the repo PR process unless an explicit
  user-approved emergency/direct-main exception was recorded
- planned verification passed or unresolved failures are recorded
- final status names the verified URL or environment, backend/API origin when
  relevant, and commit when applicable

## Trigger Examples

Use this skill for prompts like:

- `Use SDLC to turn this bug into a reviewed implementation plan.`
- `Act as TPM, principal architect, and implementation reviewer for this feature.`
- `Run the full prerelease planning and slice implementation loop.`
- `Coordinate the SDLC wave and keep the gates/checklist honest.`

## Automatic semantic phase movement

When the consuming repo exposes a documented semantic phase-transition
entrypoint, invoke it once after each accepted refinement phase and clean slice
review. Supply only the documented phase intent; let the entrypoint derive lane
identity and optional diagnostics. If no entrypoint exists, maintain the
checklist and normal gates directly. Do not assume a script name or CLI shape
from another project.

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
