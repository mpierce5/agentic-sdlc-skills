---
name: sdlc-state
description: "Maintain a compact execution index for Full, Light, or Defect SDLC work. Preserve the selected mode's gates and distinguish code-review status from acceptance proof; bounded modes may use their packet without a separate state file."
---

# SDLC State

## Mode-aware state

Full is the default; missing `workflow_mode` in legacy state means `full`. Add
`current.workflow_mode: full | light | defect` without rewriting old history.
Light/Defect may use their single compact packet as the only state record; do
not create this file solely to satisfy a bounded workflow. When the repo already
uses this index, point `context.plan_doc` and `context.progress_doc` to that same
packet and use `phase: compact-packet | slice-implement | slice-review |
verification | finalize`. Record `phase_gate: compact_packet` for combined
planning, not fictitious Full-phase completions or skipped-gate waivers.

Keep `context.code_review_status: pending | CLEAN | FINDINGS` separate from
`context.acceptance_status: pending | verified | partial | blocked`, plus
`context.architecture_conformance: pending | CLEAN | FINDINGS` and
`context.cleanup_status: pending | CLEAN | FINDINGS`. Legacy `review_status`
summarizes code review; it never implies acceptance verified. Only inspected
outcome proof closes AC, permits green completion, or supports merge readiness.
The Full matrix remains authoritative in Full; the compact AC/proof table is
authoritative in Light/Defect. No state field creates a human code-review gate.

Use this skill to create or update the SDLC state file. State is a machine-readable execution index, not the full plan and not the source of product rationale.

## Core Rule

Preserve the selected mode's SDLC behavior. State may help resume and reuse
unchanged green proof; it cannot waive that mode's required reviews, proof, or
shared safety gates. Full retains its separate refinement/planning phases.
Light/Defect combine planning in their compact packet by design.

## File

Default path: `.sdlc/state.json` unless the repo defines another path. Create or update this file only in the selected task branch/worktree. Do not create, update, stage, or commit SDLC state from a canonical/shared root checkout; that root must stay clean on `main` and update only by fetch/pull from `origin/main`.

## Shape

```json
{
  "current": {
    "task_id": "string",
    "workflow_mode": "full | light | defect",
    "phase": "compact-packet | requirements | phase0 | functional-plan | technical-plan | execution-plan | slice-implement | slice-review | clean-code-retirement | verification | finalize",
    "phase_gate": "compact_packet | not_applicable | draft | review_pending | reviewed | updated_from_review | committed",
    "slice_id": "string | null",
    "status": "not_started | in_progress | blocked | review_pending | review_clean | verification_pending | green | deferred",
    "depth": "SHALLOW | DEEP",
    "changed": "none | docs | tests | code | behavior",
    "retries": 0,
    "updated_at": "timestamp"
  },
  "context": {
    "plan_doc": "path",
    "progress_doc": "path",
    "files_changed_count": 0,
    "last_commit": "sha | null",
    "review_status": "pending | blocking_findings | review_clean | deferred | no_fix",
    "code_review_status": "pending | CLEAN | FINDINGS",
    "architecture_conformance": "pending | CLEAN | FINDINGS",
    "cleanup_status": "pending | CLEAN | FINDINGS",
    "acceptance_status": "pending | verified | partial | blocked",
    "verification_status": "not_run | focused_passed | broad_passed | failed",
    "ac_signoff_status": "unchecked | partial | blocked | signed-off | deferred | not_applicable",
    "clean_code_retirement_status": "not_applicable | pending | clean | leftovers_found | deferred"
  },
  "history": []
}
```

## Rules

- keep `current` and `context` compact and structured
- append concise history entries; do not overwrite history
- do not store raw logs, raw browser output, long diffs, full test output, chain-of-thought, or broad summaries
- store paths, counts, hashes, commit ids, command names, and terse status values instead of large content
- current state is a convenience execution index for resume and routing; approved repo planning artifacts, checklists, review artifacts, and verification records remain authoritative for gates
- state may summarize AC signoff; the mode-specific matrix or compact AC/proof
  table in the planning/progress artifact remains authoritative
- history is audit/debug only
- never recompute current state from history when `current` exists
- read history only for repeated failures, disputed findings, resume/debug work, or explicit user request
- keep `phase_gate` current during planning phases so draft, review-pending, reviewed, updated-from-review, and committed are distinguishable
- update the human-readable planning/progress artifact when state changes imply material progress, risk, review, verification, or deferral
- before editing state or progress artifacts, verify the selected checkout is not the canonical/shared root; if it is, stop and move the work to an isolated task branch/worktree instead of writing there
- keep state output terse and structured; do not store prose summaries when paths, hashes, counts, statuses, and short deltas are enough

## Step-Scoped Payloads

Pass only what the receiver needs.

Implementation payload:

```json
{ "phase": "slice-implement", "slice_id": "...", "changed": "tests|code|none", "retries": 0 }
```

Review payload:

```json
{ "phase": "slice-review", "slice_id": "...", "review_status": "pending", "verification_status": "focused_passed|not_run", "ac_signoff_status": "unchecked|partial|blocked|signed-off|deferred", "diff_or_commit": "...", "unresolved_prior_finding": "..." }
```

Verification payload:

```json
{ "phase": "verification", "slice_id": "...", "changed": "code|behavior", "review_status": "clean", "ac_signoff_status": "partial|signed-off|blocked|deferred" }
```

Clean-code retirement payload:

```json
{ "phase": "clean-code-retirement", "slice_id": "...", "clean_code_retirement_status": "pending|clean|leftovers_found|deferred", "inventory_source": "git diff/status/search/reference summary" }
```

## Exit Criteria

- `.sdlc/state.json` exists or is intentionally not used for the repo
- current state matches the active SDLC phase or slice
- history has a concise entry for the latest material transition
- large artifacts are referenced, not embedded
- progress/planning docs remain current for human-readable decisions and resume context
- any state AC signoff summary agrees with the selected mode's authoritative
  final matrix or compact AC/proof table
