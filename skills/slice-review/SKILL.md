---
name: slice-review
description: Review exactly one slice for prerelease product work. Use when the user wants a combined slice review for a current slice diff or slice commit, with findings resolved before broad verification and before the next risky slice begins.
---

# Slice Review

Use this skill only after a coherent slice diff or slice commit exists.

When a parent agent delegates review to a sub-agent, the prompt should explicitly reference this skill by name and, when the agent platform needs it, the local path or repository-relative path to this skill. The reviewer should follow this skill rather than inventing a shorter ad hoc review loop.

## Rules

- review exactly one slice diff or slice commit
- default routine review mode is `SHALLOW`
- default code-review scope is diff-only
- inspect changed files only when the diff alone is insufficient to understand the change
- inspect unchanged files only when needed to validate a concrete risk, such as API contract compatibility, shared utility behavior, security/privacy/auth impact, architecture boundary changes, failing tests, or a specific uncertainty found in the diff
- do not browse the whole repo, reload broad planning context, or inspect unrelated files during routine review
- do not analyze broad diff stats, full branch history, or large tool outputs unless a failure or uncertainty specifically requires that expansion
- run one combined review focused on correctness, acceptance-criteria drift, maintainability, and whether the slice still matches the approved plan and architecture intent
- validate the slice against the compact AC/TAC packet supplied by the parent agent: Product AC rows, Technical AC rows, Negative AC rows, trace-table mappings, planned tests, affected files, and forbidden states
- validate the slice against the final AC verification matrix rows supplied by the parent agent; do not treat trace-table coverage as signoff
- mark AC coverage `partial` or `blocked` when the supplied proof validates only intermediate implementation behavior and not the exact behavior promised by the AC
- validate the slice against its clean-code retirement expectation; unused, deprecated, failed-attempt, duplicate, temporary, generated, debug, stale, unreachable, DB/schema/data, asset/image, script, config, dependency, or compatibility surfaces introduced or made obsolete by the wave are blocking unless the plan explicitly retains them with a reason
- when using review sub-agents, pass explicit model-tier and reasoning-depth values when the agent platform supports them instead of inheriting the implementation agent's model by default
- reuse the same-run combined reviewer when appropriate; do not spawn unlimited fresh review agents
- log concrete findings
- triage findings before the next risky slice begins
- do not batch multiple slice reviews at the end of the wave

## Review Modes

Use the lightest review mode that still protects correctness.

- `SHALLOW`: default per-slice review; diff-first, focused correctness check, mandatory AC/TAC trace validation for assigned rows, and top findings only
- `DEEP`: escalated review; expanded context, stronger architecture or contract validation, broader correctness sweep
- `ACCEPTANCE`: full acceptance gate; full acceptance-criteria validation using the final AC verification matrix, architecture review, correctness sweep, and UX review when applicable
- `CLEANUP`: terminal clean-code retirement review; validates removed code and non-code surfaces, absence of references, no supported behavior regression, and no broad unrelated cleanup beyond the plan

`SHALLOW` is the routine slice-review mode. `DEEP` and `ACCEPTANCE` are explicit escalations, not the default for every slice. `CLEANUP` is required for the terminal clean-code retirement slice.

`ACCEPTANCE` review at the end of the full slice wave must use two separate reviewers:

- one architect reviewer
- one TPM or acceptance reviewer

Those two end-of-wave reviewers must be separate agents. Do not collapse the final acceptance gate into one combined reviewer.

## Model Routing

Default to cheaper independent reviewers unless the slice risk justifies escalation:

- routine combined slice review: `economy-review`, medium reasoning
- medium-risk architecture, contract, or cross-file review: `standard-review`, medium or high reasoning
- high-risk review or ambiguous architecture judgment: `frontier-review`, medium or high reasoning

Escalate from `economy-review` to `standard-review` or `frontier-review` when any of these are true:

- the slice diff touches auth, permissions, privacy, payments, notifications, scheduler, sync, deployment, environment variables, database shape, API contracts, or production-facing integration wiring
- the slice changes architecture boundaries, ownership boundaries, shared data flow, persistence semantics, or FE/backend contracts
- the slice is a broad cross-file refactor, modifies shared utilities used by multiple workflows, or changes more than roughly 400 lines
- tests failed during implementation, required verification was skipped, or the implementation agent recorded uncertainty
- the economy-tier reviewer reports uncertainty, finds a plausible correctness issue, or recommends deeper architectural review

Do not require separate code-review and PM or architecture-review passes on routine slices. Use one combined reviewer by default, and escalate to `DEEP`, `ACCEPTANCE`, or a fresh independent reviewer only when the slice risk or escalation triggers justify it.

The cost-saving default is reviewer reuse plus compact context, not weak acceptance checking. A reused routine reviewer may keep context across slices, but every slice prompt must identify the current AC/TAC rows and require a fresh verdict for that slice.

Escalate from `SHALLOW` to `DEEP` or trigger an `ACCEPTANCE` pass early when any of these are true:

- the slice introduces a new abstraction or significantly changes an existing one
- the slice changes shared contracts, ownership boundaries, persistence semantics, or FE/backend data flow
- the slice affects auth, permissions, privacy, payments, notifications, scheduler, sync, deployment, or production-facing integration wiring
- the slice is materially UX-facing, changes a UX-critical flow, or has user-visible behavior that shallow review cannot confidently validate
- repeated findings or repeated failures suggest more issues are likely than the shallow pass should continue to drip-feed
- the reviewer suspects additional blocking issues remain and cannot honestly call the slice clean from the bounded pass

Verification may be pending during review. Do not ask the implementation agent to run broad suites or wide regression verification for every small finding fix. It is acceptable and expected for the implementation agent to run focused tests or checks that directly cover the code being changed during coding iterations.

## Review Scope And Token Budget

Use the narrowest context that can produce a correct review.

- routine code review: review the diff only
- if the diff lacks enough context, inspect only the changed files or focused excerpts around changed symbols
- if a changed file calls into another module, inspect the callee only when the diff creates a concrete correctness, contract, or ownership question
- the combined reviewer may use the relevant plan excerpt and assigned Product AC, Technical AC, Negative AC, and trace rows, but should still avoid full planning docs unless a concrete ambiguity requires them
- the combined reviewer must use the assigned AC/TAC packet before calling the slice clean; if the packet is missing or too vague to validate, return a blocking finding instead of guessing
- the combined reviewer must use the assigned final AC verification matrix rows before calling AC coverage complete; if expected behavior, required proof depth, or proof evidence is missing, return a blocking finding instead of inferring signoff from nearby tests
- broad repo exploration is an escalation, not a default
- record any scope expansion in the review result, for example `scope: diff-only`, `scope: changed-files`, or `scope: expanded-to-contract`

For `SHALLOW` review, the goal is a cheap, high-signal pass, not a full sweep. It may return the top 3-5 highest-impact findings first, but it must not suppress known critical findings or call the slice clean when likely additional blocking issues remain. In that situation, escalate instead of claiming clean.

## Cached Context

Use cached context before requesting raw context.

- prefer cached plan excerpts, file summaries, Phase 0 hotspot notes, prior review findings, and test summaries from the active planning/progress artifact
- treat cached entries as valid only when their source files, commands, or commits have not changed
- ask for or inspect raw files only when the diff plus cached context is insufficient for a concrete risk
- do not re-read or re-send unchanged file contents, full test logs, full planning docs, or broad chat history
- if test output, browser output, API payloads, or logs are large, work from a compact failure summary and only request the smallest raw excerpt needed to confirm the finding
- when validating a fix, use the original finding plus the fix diff and any still-valid cached context
- record stale cache invalidations briefly when they affect review scope

## Review Output Contract

Use terse findings-only output by default.

- Always include one compact metadata line before findings:
  `scope: <diff-only|changed-files|expanded-to-contract>; model: <model>; AC coverage: <complete|partial|blocked|not applicable>; unchecked AC: <ids|none>; AC signoff: <signed-off|partial|blocked|deferred|not applicable>`
- If AC coverage is `partial` or `blocked`, include a finding that names the uncovered Product AC, Technical AC, or Negative AC row.
- If AC signoff is `partial` or `blocked`, include a finding that names the AC row and explains the gap between the available proof and the exact expected behavior.
- Do not sign off an AC based only on route labels, helper return values, mocks, CSS selectors, local state labels, or object-shape checks when the AC promises provider model selection, API/service behavior, persistence, permissions, billing, notification delivery, sync behavior, or user-visible outcome.
- For terminal clean-code retirement slices, include a finding for any leftover wave-introduced or wave-obsoleted unused/deprecated code, unreachable branch, failed-attempt work, unused export, DB/schema/data object, image/media/asset, abandoned test/doc/script/config, debug output, generated file, duplicate path, compatibility shim, or dependency that lacks an explicit retained reason.
- output bullet issues only
- include no prose summary unless there are zero findings
- each finding should be one bullet with severity, file/path or symbol, and the concrete problem
- add explanation only when critical to understand impact or fix direction
- omit praise, narration, restating the prompt, methodology, and broad recap
- if there are no findings, output the metadata line followed by exactly `No findings.`
- keep scope/model/AC metadata to one compact line
- keep each finding to the minimum text needed to make it actionable
- in `SHALLOW` or `DEEP` mode, prefer returning only the top 3-5 highest-impact findings for the current pass
- do not repeat previously reported findings unless the implementation failed to address them or the reviewer must restate them for clarity
- in `ACCEPTANCE` mode, return the complete set of blocking findings needed for the acceptance decision
- at the final end-of-wave `ACCEPTANCE` gate, record findings from the architect reviewer and the TPM or acceptance reviewer separately
- do not include any extra review summary, process commentary, or recap beyond what is needed to act on the findings

## Sub-Agent Lifecycle

Review agents are a scarce run resource. Keep the review independent from the implementation agent, but avoid creating an unbounded series of agents.

Token and cleanup constraints:

- treat each reviewer as temporary; every reviewer should have an expected close point before it is spawned or reused
- never fork or copy the full chat context for routine slice review when compact prompts are possible
- pass compact context only; do not paste full planning docs, entire diffs, long logs, or broad chat history unless the specific finding requires it
- prefer file paths, commit ids, focused excerpts, test names, and concise verification summaries
- if a reviewer has completed its review and no same-slice finding fix, re-review, or follow-up is needed, close it
- if a reviewer is stale, blocked, superseded, or duplicating another active reviewer, close it
- if all sub-agent slots are in use, close idle or dead review agents before spawning anything else

Default lifecycle for one SDLC run:

- keep at most one combined slice-review agent active by default
- add a distinct UX-review agent only when the slice is materially UX-facing and the execution plan explicitly calls for it
- reuse an idle combined reviewer for later slices in the same SDLC run
- pass a compact new prompt for each slice: current diff or commit, changed files, relevant plan excerpt, verification status (`pending` before the review/fix loop is clean, or results after verification), unresolved prior findings if relevant, and review rubric
- every compact new prompt must include the assigned Product AC, Technical AC, Negative AC, trace-table rows, planned tests, affected files, forbidden states, and expected AC coverage verdict for the slice
- every compact new prompt must include assigned final AC verification matrix rows, exact expected behavior, required proof depth, current proof/test evidence, and requested signoff status
- every compact new prompt must include the clean-code retirement expectation, and terminal retirement prompts must include the branch-local and coupled-path inventory summary plus focused no-reference proof
- tell a reused reviewer to treat the prompt as a fresh review of the named diff or commit
- spawn a new reviewer without full-context forking only when no same-role reviewer exists, the existing reviewer is busy, the existing reviewer should be closed, or the slice requires fresh independence
- before spawning, close idle review agents that are no longer needed
- prefer a lighter review model or lighter reasoning setting for routine diff-only review, escalating only when the slice risk or unresolved ambiguity justifies it
- keep review agents open through same-slice finding fixes and re-review
- close review agents only after same-slice findings are resolved, accepted as no-fix, or explicitly deferred, and no further same-slice follow-up is expected
- before starting the next risky slice, either reuse the same-role reviewers for that next slice with compact fresh prompts, or close reviewers that should not carry forward

Fresh reviewers are preferred for high-risk slices, disputed findings, stale or noisy review threads, or when the user explicitly asks for fresh independent review. Reuse the original review sub-agent within the same slice for focused follow-up and fix validation of its own findings.

Triage does not complete the review loop. If the reviewer reports findings:

- triage the findings with the parent agent
- implement fixes in the primary agent
- send the fix diff or commit, diff summary, and original finding back to the same reviewer when that reviewer is still healthy
- do not spawn a fresh reviewer just to validate the fix unless the original reviewer is unavailable, stale, noisy, or the fix changed the risk profile
- only close the reviewer after its finding is fixed and accepted, intentionally accepted as no-fix, or explicitly deferred

## While Reviews Run

The implementation agent does not need to wait idly for review sub-agents. It may continue with review-independent prep named in the execution plan, such as reading next-slice context, updating planning docs, preparing tests, inspecting files, or running harmless verification.

Do not commit the next risky slice, or make implementation changes likely to be invalidated by review findings, until this slice's combined review has returned and findings are resolved, accepted as no-fix, or explicitly deferred.

Record in the review result:

- commit or current diff reviewed
- review model and reasoning effort
- escalation reason, or `none`
- AC coverage verdict: `complete`, `partial`, `blocked`, or `not applicable`
- AC signoff verdict for matrix rows: `signed-off`, `partial`, `blocked`, `deferred`, or `not applicable`
- unchecked or deferred AC ids, or `none`
- reviewer lifecycle: `reused` or `fresh`, whether same-slice follow-up was needed, and whether the reviewer was closed after resolution
- compact-context source used for the review
- verification status at review time: `pending`, `passed`, `failed`, or `not required yet`
- clean-code retirement status: `not applicable`, `clean`, `leftovers found`, or `deferred with reason`
- terse bullet findings and triage decision



## State Updates

If `.sdlc/state.json` exists, reviewers should use only the compact state fields needed for the current review unless escalation requires history.

- state may identify slice id, reviewed diff/commit, review status, verification status, and unresolved prior findings
- do not read full history for routine first-pass review
- read history only for repeated failures, disputed findings, stale reviewer recovery, or explicit parent-agent request
- when review returns findings, set review status `blocking_findings` until findings are fixed, accepted as no-fix, or explicitly deferred
- when the combined review is clean or triaged, set review status `review_clean`, `no_fix`, or `deferred` as appropriate
- record reviewer lifecycle decisions in the durable progress/review artifact, not as long prose in state
## Exit Criteria

- the slice commit exists
- or the current slice diff is ready for review before broad verification
- the combined review exists
- the review result records selected models and any escalation reason
- findings are resolved, accepted as no-fix, or explicitly deferred before the next risky slice starts
- idle or completed review agents from this slice are closed or intentionally retained as the same-run role reviewer for the next slice
