---
name: implement
description: "Execute an already refined and approved SDLC wave only. Use when the user says $implement after SDLC refinement/planning is complete and wants Codex to run the approved implementation slices, reviews, verification, merge to main, and local main sync. Do not use for requirements discovery, Phase 0, functional planning, technical planning, or execution-plan drafting."
---

# Implement

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
- Confirm there is an approved execution plan with refined slices before editing code. If that artifact or approval is missing, stale, ambiguous, or not discoverable, stop and ask for human input instead of running refinement.
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
  `$slice-implement` and repository policy: repair, run affected deterministic
  safety proof, retry the same provider row until green, and run the fresh
  configured unseen group on the candidate branch before requesting the final
  review of the completed diff. Do not reinterpret the ordinary
  review-before-targeted-verification default as review-before-paid diagnostic
  replay or unseen qualification.
- Do not run requirements discovery, Phase 0 refactor-health, functional planning, technical planning, execution-plan drafting, or refinement review under this skill.
- Do not invent new scope or revise the plan beyond the normal implementation-slice review/fix loop. If plan changes are needed, stop and report the needed refinement.
- Do not skip independent reviews, targeted verification, final clean-code retirement, AC verification matrix updates, or repository-specific handoff checks required by `$sdlc`.
- Do not end the run merely because a useful status report can be given. Reporting is secondary to continuing execution.

## Merge And Main Sync

After all slices are completed, follow `$sdlc` closeout rules to merge the changes into `main`.

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

## Automatic semantic phase movement

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
