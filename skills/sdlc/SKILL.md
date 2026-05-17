---
name: sdlc
description: "Coordinate a phase-gated prerelease product workflow across the narrower SDLC skills. Use when the user wants a feature, refactor, UX change, bug fix, contract change, or implementation wave refined, planned, reviewed, implemented slice by slice, verified, and closed with durable artifacts. This skill is the orchestrator: it must create and follow an explicit checklist, load the relevant phase skill before each phase, enforce gates, and prevent skipping required reviews or confirmations."
---

# SDLC

Use this skill as the coordinator for the full refinement-to-delivery loop. Keep this skill lightweight. It owns phase order, checklist discipline, gate enforcement, and subskill loading. The detailed work belongs in the narrower phase skills.

## First Action

When this skill is invoked, immediately create an explicit checklist before doing substantial phase work.

Use the agent platform's plan/checklist tool when one is available. If no plan tool exists, maintain the checklist in the planning artifact and in concise status updates.

Exactly one checklist item may be `in_progress` at a time. Do not mark an item complete until its exit criteria from the relevant subskill are met.

Default full-run checklist:

1. Requirements discovery and Product/Negative AC
2. Requirements confirmation from user
3. Phase 0 refactor-health assessment
4. Phase 0 planning-artifact commit
5. Functional plan draft
6. Independent functional-plan review
7. Functional-plan updates from review
8. Functional-plan commit
9. Technical plan draft
10. Independent technical-plan review
11. Technical-plan updates from review
12. Technical-plan commit
13. Execution plan draft
14. Independent execution-plan review
15. Execution-plan updates from review
16. Execution-plan commit
17. Ready-for-implementation checkpoint
18. One-slice implementation
19. Independent slice review
20. Slice review fixes or explicit deferrals
21. Targeted slice verification
22. Slice commit
23. Final wave verification, when required by the execution plan
24. Final acceptance/deployment/status closeout

If the user asks for only one phase, create the smaller checklist needed for that phase and use the corresponding phase skill directly.

## Subskill Loading Rule

Before doing phase work, load and follow the relevant subskill's `SKILL.md`. Do not rely on memory or on this coordinator's summary.

Use the current workspace's installed skills root or this repository's `skills/` directory. Do not hardcode a personal machine path.

Phase skills:

| Phase | Skill |
| --- | --- |
| Requirements and Product/Negative AC | `$requirements-discovery` |
| Phase 0 architecture fit | `$refactor-health` |
| Functional planning | `$functional-plan` |
| Technical planning | `$technical-plan` |
| Execution planning | `$execution-plan` |
| One-slice implementation | `$slice-implement` |
| Slice review | `$slice-review` |
| Durable execution state | `$sdlc-state` |

When delegating to a sub-agent, include the relevant skill name and, when the platform needs it, the local path or repository-relative path to that skill. The prompt must say which phase is being performed and which checklist item it satisfies.

After loading a subskill, follow its rules and exit criteria over any shorter summary in this coordinator.

## Hard Gates

Treat this workflow as gated, not advisory.

- start in requirements discovery unless the user explicitly asks for a narrower phase or a resumed phase
- do not start functional planning until requirements, Product AC, and Negative AC are confirmed by the user
- do not start functional planning until Phase 0 refactor-health is completed and documented
- do not start technical planning until the functional plan has been independently reviewed and updated
- do not start execution planning until the technical plan has been independently reviewed and updated
- do not start implementation until the execution plan has been independently reviewed, updated, committed, and accepted
- do not start the next risky slice until the previous slice is review-clean, verified, and committed, or findings are explicitly accepted as no-fix or deferred
- do not mark an AC checked, review-clean, or signed off when the proof covers only an intermediate implementation detail and not the expected product or technical behavior named by the AC
- do not call the wave complete until the final AC verification matrix is filled in and all blocking or partial rows are fixed, explicitly accepted as no-fix, or explicitly deferred by the user or required reviewer
- if the user explicitly asks to skip a gate, record the skipped gate and reason in the checklist and planning artifact

When in doubt, stop and ask the user instead of silently advancing.

## AC Signoff Standard

The AC trace table is planning traceability. It is not final signoff.

Every implementation wave must maintain a final AC verification matrix that is updated during slice closeout and completed at the final acceptance gate. Each AC row must record:

- AC id and type: Product AC, Technical AC, or Negative AC
- exact expected behavior in outcome terms
- concrete proof/test, including the command, browser/API check, contract test, or review evidence
- proof level: `behavior/API/service`, `contract`, `unit/helper`, `visual`, or `manual`
- reviewer signoff status: `signed-off`, `partial`, `blocked`, `deferred`, or `not applicable`
- unchecked/deferred notes and the owner or follow-up gate

Reviewers must mark AC coverage `partial` or `blocked` when the proof validates only an intermediate signal, such as a route label, helper return value, mock call, CSS class, or local state transition, but the AC promises a cross-module, service/API, provider, persistence, model-selection, permission, billing, notification, or user-visible outcome.

When an AC crosses module boundaries, final proof must include service/API-level or end-to-end behavior at that boundary unless the execution plan explicitly justifies why a narrower proof is sufficient.

## Documentation And State

Planning artifacts must live in the repo, not only in chat. If the repo already has a planning-doc pattern, follow it.

Before implementation starts, the current planning artifact must capture:

- approved scope
- Product AC, Technical AC, and Negative AC
- AC trace table mapping AC rows to tests, affected files or contracts, and responsible slices
- architecture or technical decisions
- slice-by-slice execution plan
- explicit test and verification plan
- final AC verification matrix separate from the trace table, with exact expected behavior, proof/test, reviewer signoff status, and unchecked or deferred notes for every Product AC, Technical AC, and Negative AC row
- out-of-scope items
- current risks, guardrails, and open defects relevant to the wave
- progress tracking that can be updated during implementation

Use `$sdlc-state` when the repo uses `.sdlc/state.json` or the user asks for durable execution state. State is an execution index, not a replacement for planning artifacts, reviews, or verification gates.

## Commit Discipline

If a planning phase creates or updates repo docs, commit those planning-doc changes at that phase boundary when the repo allows commits.

- stage only the planning artifacts touched by that phase
- leave unrelated dirty work alone
- do not stage source code, generated files, lockfiles, or unrelated changes with planning-doc commits
- record the planning-doc commit hash in the planning artifact or progress log
- if committing is impossible, report the blocker and exact dirty doc paths before continuing

Implementation slice commits are governed by `$slice-implement`.

## Context Discipline

Read repo-local instructions before planning or coding:

- repo-level agent instructions, such as `AGENTS.md`, if present
- workflow docs, architecture docs, contract docs, UX docs, defects logs, or existing implementation plans relevant to the request
- `skills/sdlc/references/repo-sources.md` for source-selection guidance

Cache stable context in repo artifacts when it will be reused. Pass compact references and deltas to sub-agents instead of repeatedly pasting unchanged docs, logs, DOM dumps, API payloads, or diffs.

## Model And Agent Policy

Invoking `$sdlc` is standing explicit permission to spawn, reuse, message, wait on, and close the separate reviewer agents required by this workflow. Do not pause to ask for additional permission before creating TPM, architect, specialist, execution-plan, or slice-review agents unless the requested reviewer would modify live production systems or perform another action that independently requires user approval.

Use the model tiers defined by the active adapter or repo-local instructions:

- `economy-review`
- `standard-review`
- `frontier-review`

The coordinator decides which role needs review and which checklist item the review satisfies. The detailed model-tier selection, review scope, review-agent lifecycle, and escalation behavior belong to `$execution-plan` and `$slice-review`.

The implementation agent still must not be the only reviewer of its own work. Treat reviewer-agent spawning permission as authorization to satisfy the independent review gate, not as permission to skip it, self-review, or weaken AC signoff standards.

If independent review tooling is unavailable, use a separate fresh reviewer session or a human reviewer and record that fact plainly in the planning/progress artifact.

## Refinement Review Bench

During refinement, maintain one persistent TPM reviewer and one persistent architect reviewer across requirements, Phase 0, functional-plan, technical-plan, and execution-plan review.

- if the TPM and architect reviewers do not exist yet, create them once when the first material refinement review is needed
- if they already exist, send the current phase delta to those same reviewers instead of spawning fresh reviewers
- optionally add a persistent specialist reviewer, such as DBA or UX, when the refined work materially needs that expertise
- create a DBA reviewer only for data modeling, migrations, query performance, persistence semantics, data integrity, reporting, analytics, or database-risk-heavy work
- create a UX reviewer only for user-facing flows, interaction design, accessibility, visual hierarchy, content clarity, or usability-risk-heavy work
- reuse specialist reviewers across the relevant refinement phases instead of spawning fresh specialist reviewers for each phase
- every follow-up prompt must name the current phase, changed artifact or delta, decision under review, and checklist item being satisfied
- do not replace a refinement reviewer unless the reviewer is stale, unavailable, anchored on a disputed conclusion, context is materially noisy, independence is in doubt, or the risk profile escalated enough to justify a fresh reviewer
- record any replacement reason in the planning/progress artifact
- keep the refinement bench open through execution-plan approval
- after the execution plan is accepted and the ready-for-implementation checkpoint is reached, close the refinement TPM, architect, and specialist reviewers unless the user explicitly asks to keep them open
- routine slice reviews use `$slice-review` and the execution-plan review lifecycle, not the refinement bench, unless the execution plan explicitly escalates a slice back to TPM/architect review

## Phase Flow

Run the full workflow in this order unless the user explicitly narrows or resumes the task:

1. Load `$requirements-discovery`; refine the request into a confirmed problem statement, Product AC, Negative AC, early Technical AC notes, assumptions, and risks.
2. Load `$refactor-health`; run Phase 0 with concrete hotspot and architecture-fit evidence before functional planning.
3. Load `$functional-plan`; create and independently review the user-facing plan.
4. Load `$technical-plan`; create and independently review the architecture, contract, boundary, and test strategy.
5. Load `$execution-plan`; create and independently review the slice plan, AC trace table, model-tier plan, review plan, and verification plan.
6. Stop at the ready-for-implementation checkpoint unless the user has asked to execute.
7. For each approved slice, load `$slice-implement`; implement exactly one slice according to the reviewed execution plan.
8. For each slice review, load `$slice-review`; require independent review, fix or explicitly triage findings, and only then run planned targeted verification.
9. Repeat slice implementation and review until the execution plan is complete.
10. Run final verification, acceptance review, deployment checks, or status checks only as required by the execution plan, repo instructions, or user request.

## Output Economy

Keep coordinator output concise:

- current checklist item
- result or blocker
- artifact path or commit when relevant
- next action

Do not restate unchanged requirements, plans, diffs, logs, or review text when the artifact already contains them.

## Exit Criteria

Do not call an SDLC run complete until:

- the checklist reflects every required gate
- planning artifacts are current
- required independent reviews happened or the blocker is recorded
- slice commits exist for completed implementation slices
- planned verification passed or unresolved failures are recorded
- final status names the verified URL or environment, backend/API origin when relevant, and commit when applicable

## Trigger Examples

Use this skill for prompts like:

- `Use SDLC to turn this bug into a reviewed implementation plan.`
- `Act as TPM, principal architect, and implementation reviewer for this feature.`
- `Run the full prerelease planning and slice implementation loop.`
- `Coordinate the SDLC wave and keep the gates/checklist honest.`
