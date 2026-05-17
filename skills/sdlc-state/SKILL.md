---
name: sdlc-state
description: Maintain a compact, durable SDLC execution state file without replacing the existing phase-gated planning, independent review, verification, or progress-doc behavior. Use when creating or updating `.sdlc/state.json` for an SDLC wave.
---

# SDLC State

Use this skill to create or update the SDLC state file. State is a machine-readable execution index, not the full plan and not the source of product rationale.

## Core Rule

Preserve the existing SDLC behavior. State may help resume, skip already-green unchanged work, and pass compact context to agents. It must not remove requirements discovery, Phase 0 refactor-health, functional planning, technical planning, execution planning, independent reviews, review/fix loops, or verification gates.

## File

Default path: `.sdlc/state.json` unless the repo defines another path.

## Shape

```json
{
  "current": {
    "task_id": "string",
    "phase": "requirements | phase0 | functional-plan | technical-plan | execution-plan | slice-implement | slice-review | verification | finalize",
    "phase_gate": "not_applicable | draft | review_pending | reviewed | updated_from_review | committed",
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
    "verification_status": "not_run | focused_passed | broad_passed | failed",
    "ac_signoff_status": "unchecked | partial | blocked | signed-off | deferred | not_applicable"
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
- state may summarize AC signoff status, but the final AC verification matrix in the planning/progress artifact remains authoritative
- history is audit/debug only
- never recompute current state from history when `current` exists
- read history only for repeated failures, disputed findings, resume/debug work, or explicit user request
- keep `phase_gate` current during planning phases so draft, review-pending, reviewed, updated-from-review, and committed are distinguishable
- update the human-readable planning/progress artifact when state changes imply material progress, risk, review, verification, or deferral
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

## Exit Criteria

- `.sdlc/state.json` exists or is intentionally not used for the repo
- current state matches the active SDLC phase or slice
- history has a concise entry for the latest material transition
- large artifacts are referenced, not embedded
- progress/planning docs remain current for human-readable decisions and resume context
- any state AC signoff summary agrees with the authoritative final AC verification matrix
