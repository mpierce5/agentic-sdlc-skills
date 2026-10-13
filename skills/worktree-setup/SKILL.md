---
name: worktree-setup
description: "Discover, select, verify, and close the correct branch/worktree/lane for SDLC work. Use at the start of SDLC planning or implementation in any repo to determine whether repo-local worktree, lane, port, database, or verification setup exists; mark not applicable when absent."
---

# Worktree Setup

## Workflow mode

Full is the default. Light/Defect use `$sdlc`'s accepted compact packet as the
plan/result; use that packet instead of separate phase docs or execution matrices.
The current task may provision and own its one coherent change directly. Do not
require a separate setup worker, execution task, coordinator heartbeat, or handoff
when ownership stays in this task. Record `current-task-direct`, parent task
`none`, and parent-context forked `no`. A compact handoff is needed only for an
actual ownership transfer. Mode does not waive factual lane/status, protected-root,
author, environment, or safe cleanup checks. Human code review is not a gate.

Use this skill at SDLC start and closeout when branch/worktree/lane setup may
affect correctness.

## Start

1. Read repo-local workflow instructions first, such as `AGENTS.md`,
   `CONTRIBUTING.md`, `.codex/`, `.sdlc/`, or workflow docs.
2. Discover supported setup commands. Prefer repo scripts over ad hoc ports,
   databases, or hand-created worktrees.
3. Choose the setup:
   - Planning-only: record current branch/worktree and whether isolated setup
     will be needed before implementation.
   - Implementation or parallel agent work: create or select the repo-approved
     isolated branch/worktree/lane before task-owned edits or commits.
   - Independent top-level refinement or implementation: provision a fresh
     worktree from current `origin/main`, record the base SHA/proof in the
     handoff, and do not fork another worker branch or chat context. A prior
     lane's changes arrive through `main` or an explicitly approved shared-seam
     integration commit merged after fresh-lane provisioning.
   - No repo setup: mark `not applicable`, inspect branch/status, and use the
     safest available checkout workflow.
   - Orchestrated multi-slice wave: the coordinator delegates each new lane's
     procurement to a bounded setup agent with parent-context forking disabled.
     The setup agent provisions from current `origin/main`, records the lane
     identity and compact handoff, and returns it to the coordinator; it does
     not implement the slice.
4. Record branch, worktree, frontend URL, backend URL, database, cleanup
   command, and any required local dependency/bootstrap command when known.
   If another agent or thread will take over after setup, also record the
   lane-local handoff doc path and result path when known.
5. For production-bound work, inspect the selected checkout's local git author.
   If the repo defines deployable-author rules, repair a missing or blocked
   local author before any commit and record the resulting author.

Prefer the repo's single-purpose agent entrypoints when they exist. Operational
setup is a low-freedom workflow: do not reconstruct a maintainer command from
its internal parameters.

Discover the consuming repo's status, lane creation, optional coordination,
and lane retirement entrypoints in its local instructions. Use their documented
agent-facing inputs and returned worktree path. Interpret protected-root status
according to those instructions; do not assume a particular exit code.
Optional task-state reports are observational and never grant write permission.
If no repo utility exists, use the supported platform/Git worktree mechanism
and record ownership and cleanup explicitly.

If a separate execution agent or visible thread will take over after setup,
prefer using `$lane-bootstrap` when installed so the branch/worktree creation
and lane-local handoff doc are produced by a cheap setup worker instead of
being restated in long prompts.

The slice worker keeps that lane through its own review/fix/re-review loop,
targeted verification, commit, and `$golden-merge`. A separate hardening or
merge worktree for routine closeout is deprecated and must not be required.

## Minimum Checks

- inspect current branch and dirty state before edits
- if git worktrees are available, inspect existing worktrees before creating or
  cleaning one
- if implementation or verification depends on repo-local tooling, verify the
  selected worktree can resolve required packages from that checkout
- when the repo exposes a worktree status/bootstrap command, run it or record it
  before the first verification attempt
- when the repo exposes a one-input lane closeout helper, use it after protected
  merge verification; do not reconstruct telemetry or coordination state
  manually
- treat the canonical/shared repo root checkout as protected: it must remain
  clean on `main` and must only be updated by fetching/pulling from
  `origin/main`
- do not switch the shared root checkout to a task branch or use it for
  requirements, planning docs, progress docs, state updates, implementation,
  test fixes, retry work, investigation commits, merge commits, or any
  task-owned file change
- if a task branch needs fixes after merge, review, or verification, make those
  fixes in the task's own worktree/lane
- if the shared root checkout is discovered on a task branch or with task-owned
  dirty files, stop and report the branch, dirty files, and likely owner unless
  the user explicitly asks you to restore it
- do not overwrite, revert, or clean unrelated dirty changes
- do not point queued or parallel agents at the shared human/dev checkout or
  lane
- do not create a new top-level execution lane from another worker's branch.
  Bounded helpers may use a parent worktree only with a narrow packet and no
  parent-chat inheritance; reviewers remain read-only.
- do not inherit provider, OAuth, payment, deployment, or worker secrets into
  agent lanes unless repo instructions explicitly allow it
- do not let production-bound agent lanes inherit local/test/operational git
  authors that the deploy platform ignores

## Main Integration And Lane Database Order

Frequent integration from `main` is encouraged. The safety invariant is that
the selected lane database must not be advanced beyond the code currently
checked out on the task branch.

Use this order whenever a task branch needs current `main` changes, runtime
schema repair, migrations, seeded lane data, database-template refresh, or
production-bound merge closeout:

1. Preserve unrelated local edits without staging or reverting them.
2. Merge current `main` or `origin/main` into the task branch.
3. Resolve conflicts on the task branch.
4. Restart or refresh the lane so it runs the integrated task-branch code.
5. Run runtime migrations, schema repair, seed/setup-trial commands, or DB
   template refresh only from that integrated code.
6. Run verification against that integrated code and database.
7. For production-bound work, verify the selected checkout's commit author and
   the branch commits are deployable according to repo-local rules.
8. Push the verified task branch and open or update a GitHub pull request to
   `main`; do not use a local merge-to-main plus direct push as the normal
   closeout path.
9. Merge through the GitHub PR process after required checks/reviews pass,
   preferably with non-interactive GitHub/API/CLI commands so the canonical root
   checkout does not need to leave `main`.
10. After PR merge, update the canonical/shared root checkout by fetching/pulling
    the merged `origin/main`, verify it is clean and tracking `origin/main`,
    and run the repo's required deployment/status checks before reporting the
    work live.

Do not repair, migrate, reseed, or refresh an agent lane database from newer
`main` code before the task branch has merged those same `main` changes. If you
discover the lane database was advanced first, treat verification as
contaminated and either merge `main` immediately then rerun schema repair plus
verification, or recreate/reset the lane database from a baseline that matches
the checked-out branch.

When reporting setup or closeout, note whether the lane database was:

- newly created from the repo-approved baseline
- preserved from an existing lane and repaired after merging `main`
- reset/recreated because it had advanced ahead of the branch

Production-bound closeout must preserve the PR evidence trail. A direct push to
`main` or a locally merged `main` push is an emergency/manual exception only
when the user explicitly approves it for that task.

## Verification

- for planning-only work: setup is complete after branch/worktree applicability
  is recorded
- for implementation: run the repo's lane/status check when available and
  complete any required local dependency/bootstrap setup before the first test
  or typecheck command
- if backend behavior will be tested, verify the selected backend/API origin
- if frontend behavior will be reviewed, verify the selected browser URL

## Closeout

Before final SDLC closeout, stop only task-owned servers/watchers and other
resources holding its worktree open, then clean through the repo command.
All modes record a factual worktree disposition in the existing result:
`removed`, `not_applicable`, `retained`, or `blocked`. `removed` requires both
directory absence and Git registration absence; exit zero alone is insufficient.
Retain a lane only for a concrete ongoing review, unmerged work, or planned
ownership transfer; name the reason, next action, and responsible owner.
An actual deletion failure is `blocked`, not optional telemetry or completed
cleanup. Record the exact error and recovery owner; do not silently abandon it.

If the repo has a script-owned lane closeout path, use its documented
agent-facing entrypoint from outside the target lane. Verify the exact target,
merged/clean state, and inactive ownership before routine disposal; preserve
needed dirty or unmerged work unless its disposal is explicitly authorized.
Inspect both directory and Git-registration absence, not only command exit.
Partial removal remains blocked. Release only owned locks and use documented
safe retry/recovery when supported. Never reconstruct recovery records or
delete an orphan solely from inventory. Use non-forced branch deletion;
an intentionally preserved branch is separate from disk-consuming leftovers.

Also verify that any canonical/shared repo root checkout is clean, on `main`,
tracking `origin/main`, and updated only by fetch/pull from `origin/main`. If
it is not, do not call closeout complete; report the active branch, dirty
files, and whether the checkout should be restored or left for a human.

Never clean protected QA, beta, production, shared human dev, or unrelated
worktree resources.

Before merging a production-bound task branch to `main`, make sure the branch
contains all current changes from `main` and merge through a GitHub PR:

1. Preserve unrelated local edits without staging or reverting them.
2. Update the task branch by merging current `main` or `origin/main` into it.
3. Resolve any merge conflicts on the task branch.
4. Only after that merge, run any runtime schema repair, migrations, lane DB
   refresh/setup, or fixture seeding needed for verification.
5. Run the repo-required verification on the integrated task branch.
6. Run repo-local deployable-author checks before pushing or merging.
7. Push the task branch and open or update the GitHub PR to `main`.
8. Wait for required PR checks/reviews and record any preview/deploy result
   expected by the repo. Apply only explicit repo-authorized deployment
   exceptions; do not bypass a required check based on the hosting provider.
9. Merge through GitHub's PR merge path and record the PR URL/number, merge
   method, and final main commit.
10. After PR merge, update the canonical/shared root checkout by fetching/pulling
    `origin/main`, verify it is on `main`, clean, and tracking `origin/main`.
11. Run the repo's final deploy/status checks and report failed or unavailable
    deployment truthfully. Do not claim an unverified environment is live.

Do not solve a behind-`main` branch by rewriting or pushing `main` first. Keep
`main` as the shared source of truth, integrate it into the task branch, then
merge the verified result through the PR process.

## Output

```text
Worktree setup: <created | selected | not applicable | left for review | cleaned>
Branch: <branch or n/a>
Worktree: <path or n/a>
Frontend: <url or n/a>
Backend: <url or n/a>
Database: <path/name or n/a>
Git author: <name/email or n/a>
Cleanup: <command/status or n/a>
Bootstrap: <command/status or n/a>
```

## Telemetry

Telemetry and accounting are local, optional diagnostics. Agent-facing
entrypoints derive their metadata, attempt enabled telemetry once, and contain
its failure. Do not pass telemetry paths, hashes, timestamps, journals,
retention proofs, or incident-writer arguments during ordinary setup or
closeout. Do not retry, reconstruct, backfill, or commit telemetry.

Apply that interface rule to other exposed process commands as they are
created or revised: an ordinary agent supplies the product/process intent, and
the command derives optional diagnostic metadata internally. Parameter-rich
telemetry commands are maintainer surfaces, not required steps for workers.

This does not weaken product safety. Branch/worktree identity, independent
review, affected verification, security, Git head, protected merge, and
truthful closeout remain substantive policy gates outside the lane utilities.

## Deployment Exceptions

Deployment checks remain governed by consuming-repo policy and the accepted
plan. Treat a service failure as nonblocking only when an explicit applicable
exception permits it. Record the status and reason once, continue only through
independently satisfied review, product, security, Git, and merge gates, and
report deployment as failed or unverified until it is actually proven live.
Do not invent a provider-specific exemption for a new project.
