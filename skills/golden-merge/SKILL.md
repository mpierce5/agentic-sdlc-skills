---
name: golden-merge
description: Merge reviewed work to main using protected-root-safe closeout rules. Use when the user asks to merge, roll out, sync to main, or close a reviewed branch, especially when the repo distinguishes golden-architecture merges from ordinary merges and the agent must choose the correct path.
---

# Golden Merge

Use this skill for merge and rollout closeout after implementation or planning
work is already reviewed and ready.

The substantive slice worker invokes this skill from the existing reviewed
slice lane. Creating a separate hardening lane, merge lane, or routine
coordinator-takeover lane is deprecated. A new lane is permitted only for a
genuine abnormal-recovery or explicitly planned multi-branch integration gate.

Keep it short and operational:

- choose the correct merge mode;
- perform merge work from the task branch/worktree, not the protected root;
- satisfy repo review/verification requirements before merge;
- update the concise formal result and any existing coordination row without
  creating telemetry paperwork;
- sync the protected root only after the merge is complete.

## Merge Mode Selection

Choose one mode before merging:

1. `golden`
2. `non-golden`

Use `golden` when any of these are true:

- the user explicitly asks for a golden merge;
- repo instructions or `AGENTS.md` name golden architecture, golden
  persistence, golden lanes, or a golden playbook/runbook for the touched work;
- the execution plan or handoff doc says the slice is a golden lane or touches
  golden runtime boundaries.

Use `non-golden` when the repo does not mark the work as golden and no golden
merge authority is required for the touched surface.

If the mode is ambiguous, stop and ask or read the repo-local authority docs
named by `AGENTS.md`, the execution plan, or the lane handoff doc.

## Required Reads

Before merging:

1. read `AGENTS.md`;
2. read the current execution plan, lane handoff doc, or closeout artifact;
3. read any repo-local merge/playbook docs named there;
4. for golden work, read the repo-local golden authority docs named by the repo
   instructions before making merge decisions.

Examples of repo-local golden authority docs can include:

- golden architecture playbooks
- golden persistence runbooks
- lane merge/closeout docs
- domain-specific hardening docs when those rows are part of readiness

## Hard Rules

- never do task-owned merge preparation from the protected root checkout;
- never treat "merge to main" as permission to bypass the repo's branch/worktree
  merge path;
- never merge before current `main` or `origin/main` is integrated into the
  task branch and required verification has been rerun there;
- never use direct-main unless the user explicitly approves an emergency
  exception and the repo rules permit it;
- use the repo PR path when the repo expects PR-based merge;
- do not treat merge as complete until the concise lane result and any existing
  coordination state are current. Missing optional telemetry is not a merge
  gate;
- sync the protected root only after the merge is complete.

## Impact-Based Verification And Evidence Reuse

Merge readiness requires current, valid proof for affected behavior; it does
not require replaying every previously passing command after unrelated changes.

- Map the lane diff and current-main conflict resolutions to affected tests,
  AC rows, contracts, and integration boundaries.
- Rerun affected proof and genuinely dependent checks. Reuse retained passing
  evidence for unchanged surfaces.
- Do not rerun tests solely because the commit SHA changed or unrelated main
  work was integrated.
- Do not regenerate evidence merely to refresh whole-file hashes, timestamps,
  source locations, or other incidental bytes. Integrity bindings should cover
  canonical protected semantics, identities, or artifacts.
- Do not require cryptographic approval by default. A signature gate must come
  from an explicit user-accepted security/compliance or external-release
  requirement, not from ordinary SDLC bookkeeping.
- If integration conflicts or upstream edits touch a proved boundary, widen
  verification only to that newly affected boundary.

Record reused evidence and its unchanged scope concisely. Never represent reused
evidence as a new run.

## Merge Workflow

Run this sequence:

1. Confirm the selected task branch/worktree is the merge owner.
2. Confirm the protected root is clean and remains read-only for task work.
3. Confirm required reviews are complete or explicitly accepted.
4. Confirm affected verification is current and unaffected proof is still
   applicable.
5. Integrate current `main` or `origin/main` into the task branch/worktree.
6. Resolve conflicts on the task branch/worktree.
7. Run the required impact-based verification on the integrated branch.
8. Push the verified branch and open or update the PR if the repo uses one.
9. Merge through the repo-approved path.
10. Complete concise merge closeout in the lane:
    - update the lane result or handoff artifact with final status
    - for LLM-facing work, record whether review confirmed
      provider-agnostic reusable source, generic contract wording, and
      deterministic runtime ownership of already-known contract values
    - update any existing shared coordination ledger row to `completed`,
      `inactive`, or another repo-approved closeout state
    - keep raw telemetry, token totals, command journals, and live-validation
      payloads local and gitignored
11. Only after the formal merge closeout is current, update the protected root
    checkout by fetch/pull from the merged `origin/main`.
12. Verify the protected root is clean, on `main`, tracking `origin/main`, and
    at the expected commit.
13. Retire the completed lane when its cleanup preconditions pass.

## Lane Retirement

Retire a lane only after its merged closeout evidence has landed on `main` and
the protected root has synchronized to that merge.

Before removal, prove all of the following:

- the task branch is an ancestor of `origin/main`;
- the lane ledger row is `merged`, `completed`, or `inactive` with a final
  result/closeout artifact;
- the target worktree has no tracked or untracked task changes;
- no worker or reviewer still needs the lane for a same-slice fix or review.

Run retirement from a coordinator context outside the target worktree. Do not
try to remove the worktree that is the current process directory. A protected
root or a dedicated cleanup worktree may issue the Git maintenance commands,
but must not make task-owned edits.

Use this order:

1. `git -C <lane> status --short`
2. `git -C <repo-root> merge-base --is-ancestor <branch> origin/main`
3. `git -C <repo-root> worktree remove <lane>`
4. `git -C <repo-root> branch -d <branch>`
5. Delete the remote branch only when the PR merge did not already delete it.

Never use `--force`, `git branch -D`, or a destructive clean command for lane
retirement. If any precondition fails, leave the worktree and branch in place,
record the exact blocker in the result/ledger, and hand cleanup back to the
coordinator.

Close temporary reviewer/subagent sessions after their results are accepted.
Keep a user-visible implementation task available unless the user explicitly
asks to archive it; repository cleanup does not authorize task archival.

## Formal And Coordination Closeout

Treat concise formal closeout as required for both `golden` and `non-golden`
merges. Telemetry is optional diagnostic data.

Minimum closeout evidence:

- final lane result or handoff artifact reflects merged, closed, or superseded
  state;
- for LLM-facing work, the closeout artifact explicitly records whether reusable
  source stayed provider-agnostic, whether contract grammar asked only for
  model-authored semantic fields, and whether already-known deterministic values
  remained runtime-owned instead of model-authored;
- if the repo uses a shared coordination ledger, the lane row is updated so the
  branch does not remain falsely active after merge;
- raw live-validation payloads, usage telemetry, thread totals, token snapshots,
  command journals, and receipts remain local and gitignored;
- missing telemetry does not invalidate independently proven product, review,
  Git, or protected-merge gates.

Do not rely on later human reconstruction from chat history, branch archaeology,
or memory for the small set of formal facts needed for closeout: reviewed
commit, affected verification, PR, merged head, AC disposition, and explicit
limitations.

## Golden Merge Addendum

For `golden` merges:

- verify the touched lane still satisfies the repo's golden rules before merge;
- confirm no fallback path, legacy write path, or compatibility-only branch is
  being merged as if it were the golden pattern unless the repo-local plan
  explicitly accepted that boundary;
- verify golden-specific reviews or proofs named by the repo are present;
- for LLM-facing golden work, verify the review/AC/closeout artifacts explicitly
  say whether reusable source remained provider-agnostic, whether contract
  grammar asks only for model-authored semantic fields, and whether fields already
  known from selected refs or contract-shape singletons remained runtime-owned
  instead of model-authored;
- block golden merge if those LLM-facing architecture dispositions are required
  by the touched work but are absent from the recorded review/closeout evidence;
- keep the same concise formal and coordination closeout discipline; golden
  work does not get to skip required reviews or product proof;
- if the repo distinguishes golden and non-golden runtime finalization, do not
  merge a golden lane with non-golden closeout assumptions.

Use repo-local authority for the exact proof bar. This skill chooses the merge
path; it does not replace the repo's golden architecture rules.

## Non-Golden Merge Addendum

For `non-golden` merges:

- use the same protected-root-safe branch/worktree merge discipline;
- do not import golden-only proof requirements unless the repo says they apply;
- still complete concise formal and coordination closeout before reporting the
  lane merged;
- still integrate current `main`, run required impact-based verification, and merge
  through the repo-approved path.

## Output

Report only:

- merge mode: `golden` or `non-golden`
- selected branch/worktree
- verification rerun status
- PR or merge path used
- final merged commit
- formal/coordination closeout status
- protected-root sync result
- any explicit exception taken

## Handoff Back To SDLC

When used alongside `$sdlc`:

- let `$sdlc` own the overall checklist and gate order;
- let `$golden-merge` own merge-mode selection and merge/rollout closeout;
- if the user says "merge to main", `$sdlc` should load this skill rather than
  carrying the whole merge policy inline.

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

## Deployment Exceptions

Deployment checks remain governed by consuming-repo policy and the accepted
plan. Treat a service failure as nonblocking only when an explicit applicable
exception permits it. Record the status and reason once, continue only through
independently satisfied review, product, security, Git, and merge gates, and
report deployment as failed or unverified until it is actually proven live.
Do not invent a provider-specific exemption for a new project.
