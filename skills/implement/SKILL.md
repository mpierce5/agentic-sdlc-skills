---
name: implement
description: "Execute an approved Full SDLC plan or an explicitly selected Light/Defect compact change through implementation, independent LLM review, affected verification, and authorized closeout. Do not restart Full refinement or require human code review."
---

# Implement

Agent routing: Wave coordination; a direct slice owner retains its selected implementation profile.
Resolve concrete model and effort through the active platform adapter or explicit
task/repo policy. See the shared [routing policy](../sdlc/SKILL.md#model-and-agent-policy);
helper loading retains the existing owner/model.

## Workflow mode and authorization

Full is the default when neither the user nor accepted continuation packet names
a mode. Full requires its approved execution plan. Explicit Light/Defect execution
accepts the compact packet specified by `$sdlc` instead: accepted AC, bounded
scope, existing seam/pattern, targeted proof, and defect evidence when applicable.
Do not demand completed Full phases, matrices, a planning bench, or a separate
retirement slice for that packet. If compact inputs are missing, capture them
from the authorized request and known repo behavior; ask only about materially
ambiguous AC or design/architecture decisions. This is bounded preparation,
not a restart of Full refinement.

Humans confirm AC and resolve decisions the LLM needs support on. Independent
code and architecture reviews are LLM reviews. No human code-review, routine
implementation approval, or routine merge approval is a required gate.
Reuse accepted AC rather than asking for redundant confirmation. Light/Defect
retain one direct owner and combined code/architecture/cleanup review, followed
by targeted proof and reviewer evidence inspection before green completion.
The instructions below about Full planning/slices/matrices and whole-wave
retirement apply to Full only. Shared repo safety/provider/verification rules
apply to every mode. Merge/deploy only when authorized by the user's request or
accepted scope; the execution wrapper does not expand external action authority.

Use this skill as an execution-only wrapper around `$sdlc`. It does not replace `$sdlc`; it tells the execution agent that refinement and planning are already complete and the user has authorized implementation and closeout.

This skill starts at the ready-for-implementation checkpoint. It must not perform the SDLC refinement phases.

## Required Behavior

- Load and follow `$sdlc` before doing substantial work, but only for the implementation and closeout portions of the SDLC workflow.
- Treat the user's `$implement` invocation as permission to proceed from an already completed ready-for-implementation checkpoint.
- If the current task is already the intended owner of the currently assigned
  slice, continue directly in the selected lane through that slice's clean
  commit. Do not force another task inside the same slice.
- For an orchestrated multi-slice wave, default to one user-visible top-level task
  per substantive slice. The implementation orchestrator owns wave continuity;
  each slice worker owns only its assigned slice plus its reviewer/fix loop.
  Reusing one task across multiple substantive slices requires an explicit
  accepted-plan `single-task-wave-owner` exception with rationale.
- For Full, confirm there is an approved execution plan with refined slices before editing code. If that artifact or approval is missing, stale, ambiguous, or not discoverable, stop and ask for human input instead of running refinement.
- Ensure all refined and approved execution-plan slices are implemented one
  slice at a time using `$sdlc`, `$slice-implement`, and `$slice-review` gates.
  The orchestrator continues forcefully through the wave by launching and
  monitoring the next visible slice owner; an individual slice worker stops
  writable work after its assigned slice is durably handed off.
- Continue through the full approved implementation wave until every approved
  slice is complete, reviewed, verified, committed, and closed out, or until
  genuinely blocked. A fresh slice-task boundary is continuation, not a pause
  requiring new user permission.
- Do not pause after a slice, review, verification pass, partial checkpoint, or progress summary waiting for the user to say "continue." The user's `$implement` invocation already grants that permission.
- Work silently through intermediate checkpoints. Do not send routine progress
  updates about searches, reads, commands, tests, or partial slices; record
  only the compact durable state needed for handoff or review. Keep raw command
  output and telemetry local and gitignored.
- Only stop before full wave completion when blocked by missing requirements, failed gates, unavailable tooling, unsafe repository state, unresolved review findings, verification failures, merge conflicts requiring judgment, authentication, permissions, or other human input that you cannot clear yourself.
- If one slice completes cleanly and no real blocker exists, the orchestrator
  immediately launches or activates the next approved visible slice task from
  the durable handoff. The completed slice worker must not start the next risky
  slice unless `single-task-wave-owner` was explicitly approved.
- If a review finds issues, stay inside the same `$implement` run: fix the findings, rerun verification, and re-review as needed, then continue the wave.
- For authorized LLM/provider hardening, follow the provider-specific order in
  `$slice-implement` and repository policy: repair, immediately retry the exact
  failed provider row through the maintained runner's built-in guards until
  green, and run the complete fresh
  configured unseen group on the candidate branch before requesting the final
  review of the completed diff. Do not reinterpret the ordinary
  review-before-targeted-verification default as review-before-paid diagnostic
  replay or unseen qualification.
- Do not run requirements discovery, Phase 0 refactor-health, functional planning, technical planning, execution-plan drafting, or refinement review under this skill.
- Do not invent new scope or revise the plan beyond the normal implementation-slice review/fix loop. If plan changes are needed, stop and report the needed refinement.
- Keep the selected mode's independent LLM review, targeted proof, and AC updates.
  Full uses its planned retirement and final matrix; Light/Defect use inline
  cleanup and the compact table. Handoff checks apply only to actual transfers.
- Do not end the run merely because a useful status report can be given. Reporting is secondary to continuing execution.

## Merge And Main Sync

After the authorized work is complete, follow `$sdlc` closeout rules. When merge
is included in the accepted scope, merge through the repo path and sync main;
otherwise preserve the reviewed lane and report the implemented commit.

Required closeout expectations:

- Integrate current `main` or `origin/main` into the task branch before PR merge.
- Resolve conflicts on the task branch and rerun required verification from the integrated branch.
- Use the repository's PR-based merge process unless the user explicitly approves a direct-main emergency exception.
- After merge, update the local canonical `main` checkout so it is in sync with `origin/main`.
- Verify and report that local `main` is clean, on `main`, tracking `origin/main`, and at the expected commit.

## Reporting

Report only a genuine blocker, a required user decision or approval, final
completion, or the required minimal fresh-task handoff when a separate task
handoff is actually required and the host cannot create that task. Treat
unavailable host task creation as a blocker only for that handoff case, not
when the current task is the direct execution owner. A final completion report
names the result, verification, relevant artifact/commit/PR, and any next
required human action. Do not send routine progress notes.

## Automatic semantic phase movement (Full mode)

When the consuming repo exposes a documented semantic phase-transition
entrypoint, invoke it once after clean independent slice review using only its
documented phase intent. Let it derive lane identity and optional diagnostics.
Otherwise continue normal verification directly; no repo utility is assumed.

## Telemetry Tool Failure Logging

Telemetry, retrieval diagnostics, command journals, and accounting captures are
optional local debugging data. When an enabled telemetry operation fails,
record one local incident and do not retry it merely to improve paperwork.
Keep raw output gitignored and out of formal closeout.

This does not waive a substantive launch/lease, review, product verification,
security, Git-head, or protected-merge failure independently established
without telemetry. Missing reporting or accounting telemetry alone is
non-blocking.

## Accounting Telemetry Failure Rule

If accounting telemetry is enabled, attempt it once. On failure, record one
local `telemetry_incomplete_non_product` incident and do not retry, reconstruct,
replay, backfill, or create an evidence-only commit. Continue through the
independently validated product, review, Git, and merge gates. Accounting
telemetry never changes the completion claim.
