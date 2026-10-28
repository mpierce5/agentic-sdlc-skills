---
name: lane-bootstrap
description: Create or refresh a task branch/worktree/lane and write the lane-local handoff doc for the next agent. Use when the user wants a cheap setup worker to prepare a new execution lane, bootstrap a worktree, capture branch/worktree/result paths, or hand off a prepared lane to another execution task or agent.
---

# Lane Bootstrap

Agent routing: Known-command bootstrap; select the successor's profile separately from its accepted scope.
Resolve concrete model and effort through the active platform adapter or explicit
task/repo policy. See the shared [routing policy](../sdlc/SKILL.md#model-and-agent-policy);
helper loading retains the existing owner/model.

## Workflow mode

Full is the default. Light/Defect use `$sdlc`'s accepted compact packet as the
plan/result; use that packet instead of separate phase docs or execution matrices.
The current task may provision and own its one coherent change directly. Do not
require a separate setup worker, execution task, coordinator heartbeat, or handoff
when ownership stays in this task. Record `current-task-direct`, parent task
`none`, and parent-context forked `no`. A compact handoff is needed only for an
actual ownership transfer. Mode does not waive factual lane/status, protected-root,
author, environment, or safe cleanup checks. Human code review is not a gate.

Use this skill for the cheap setup pass before the main execution agent starts.

In an orchestrated multi-slice wave, the coordinator spawns one bounded
no-parent-context setup agent to procure or verify each fresh slice lane. The
setup agent writes the compact lane-local handoff and returns it to the
coordinator; it never becomes the substantive implementation owner.

Choose a lower-cost capable bootstrap model from the active adapter or
repo-local routing policy. Record the separately documented writable execution
model and reasoning in the handoff; bootstrap routing does not determine the
execution owner's assignment.

This skill avoids restating branch/worktree/bootstrap instructions in every
handoff.

## Purpose

The bootstrap worker should:

1. create or select the correct task lane;
2. run the repo's status/bootstrap path;
3. record branch, worktree, result path, and lock ownership;
4. write or refresh a lane-local handoff doc for the next agent.

The older pattern in which the coordinator performs every provisioning command
itself is deprecated for orchestrated multi-slice waves. Coordinator direct
setup remains valid only for its own single-lane work or when setup-agent
capability is unavailable and that limitation is recorded.

When it is invoked only to prepare a lane for another task, it should not do
the main implementation work. A current task that owns the planned work is the
exception: it may continue directly after bootstrap without a second task.

When the current task both bootstraps and owns the current phase or assigned
substantive slice, it may continue directly in the prepared lane. Record
`Mode: current-task-direct`, `Parent thread id: none`, and `Parent-context
forked: no`; do not manufacture a second execution task within that assignment.
In an orchestrated multi-slice wave, each later substantive slice defaults to a
fresh user-visible top-level task unless the reviewed plan records the explicit
`single-task-wave-owner` exception. Use the handoff doc for every ownership
transfer. Create new lanes through the repo's maintained entrypoint; do not
invent provisioner flags, activation calls, registries, or lease machinery.
For an accepted serial transfer, verify the prior owner is review-clean,
green, committed, stopped as a writer, and handing over the exact pushed head
and clean lane. Name the next owner and owned scope in the compact handoff.
Apply an additional lease/activation protocol only if current repo authority
actually defines and supports one. Do not reconstruct retired machinery.

Use the consuming repo's documented agent-facing create/status entrypoints
with their documented inputs, then verify the returned worktree. Let maintained
commands derive optional observation details; do not assemble internal inputs.
Task attribution/reporting and retrieval are optional diagnostics; their
absence or failure never blocks an otherwise factual, safe handoff. Do not
require a second provisioning call, telemetry baseline, or retrieval hash.

## Required Reads

Before acting:

1. read `AGENTS.md` or equivalent repo instructions;
2. read the accepted plan, Light/Defect compact packet, or lane assignment note;
3. read any repo-local worktree/bootstrap docs named there;
4. if the repo already has a lane handoff doc, read it before replacing it.

## Hard Rules

- use the protected root checkout only for read-only status/integration checks;
- do not do task-owned edits or commits from the protected root;
- prefer repo scripts over ad hoc worktree commands when they exist;
- if the repo has a status script, run it before bootstrap or handoff signoff;
- if the lane already exists, refresh and verify it instead of silently making
  a second competing lane;
- for an independent top-level execution lane, provision from current
  `origin/main` and record the exact base SHA/proof. Do not fork another worker
  branch or context; pass only a compact handoff and useful retrieval when available.
  Shared-seam exceptions must be explicitly approved and integrated into the
  fresh lane after creation.
- reuse an existing lane for another top-level task only when the reviewed plan
  selects `serial-exclusive-lane-transfer`. Require exact branch/worktree/base/
  final pushed head, clean status, prior writer shutdown, next owner, and
  assigned scope. Verify any additional currently supported repo ownership
  contract. Fail closed on factual identity or competing-writer mismatches;
  optional telemetry/retrieval failures are not mismatches. This does not relax
  fresh-`origin/main` provisioning for a new or parallel lane.
- keep the handoff prompt short and put durable state in the lane-local
  handoff doc.
- for specialized architecture work, include the exact authority docs named
  by repo instructions and the accepted plan. A supported scenario's failed
  provider row requires generic contract-path repair, focused rerun, and
  re-review rather than broadening the expected behavior.
- for legacy-to-golden conversion, include the mandatory retirement AC:
  inventory legacy surfaces, replace coverage with golden proof, delete
  superseded paths, justify retained non-bypassing surfaces, and require
  independent retirement review.
- state that progress commentary never ends the work turn; final handoff is
  permitted only after completion criteria or a genuine blocker after all safe
  work is exhausted.
- for authorized provider proof, record the accepted track's repo-approved
  provider/profile and exact-row-first repair order. Other providers are explicit
  comparisons named by the accepted slice, never hidden prerequisites.

## Workflow

1. Identify the intended lane owner, slice, or work item.
2. Discover whether the repo already provides:
   - status script
   - bootstrap/setup script
   - worktree provisioning script
   - shared coordination ledger
3. Create or select the lane using repo rules.
4. Run the maintained repo status/bootstrap commands needed to make the lane
   usable. Verify Git facts independently of optional task observations.
5. Record:
   - branch
   - worktree
   - base commit or parent
   - result path
   - owned work item
   - required docs/artifacts
   - lock or ownership state
   - for a serial transfer: prior and next owner, exact pushed head, clean-lane
     proof, prior writer shutdown, and any actually supported ownership contract
6. Write or refresh the lane-local handoff doc.
7. Return a minimal handoff prompt that points the next agent at:
   - branch
   - worktree
   - handoff doc
   - result path

## Lane-Local Handoff Doc

The handoff doc should live in the repo lane and be durable enough that a fresh
execution thread can read it instead of relying on a giant prompt.

Minimum contents:

```text
LANE HANDOFF
Date:
Lane / slice:
Branch:
Worktree:
Base commit:
Assigned model:
Assigned reasoning:
Mode: writable | read-only
Launch mode: current-task-direct | fresh-visible-task | fresh-manual-handoff | bounded-subagent
Parent thread id: none | <id>
Parent-context forked: no
Additional repo ownership contract, only if currently supported:
Prior owner task id, when serial transfer:
Exact prior pushed head, when serial transfer:
Next owner task id, when serial transfer: pending | <id>
Prior owner stopped as a writer, when serial transfer:
Optional useful retrieval reference or local limitation:
Owned work item:
Required reads:
- AGENTS.md
- <execution plan or artifact>
- <other exact docs>
Legacy-to-golden conversion AC, when applicable:
- Inventory all legacy runtime/test/fixture/helper/compatibility/assertion surfaces.
- Replace coverage with approved replacement-path proof and delete superseded paths.
- Justify retained legacy-named surfaces and prove they cannot bypass golden runtime.
- Require clean-code retirement inventory and independent review before signoff.
Allowed files:
- <exact files or owned surfaces>
Verification to run first:
- <status/bootstrap/test commands>
Result path:
Lock / ownership state:
Serial transfer verification, when applicable: pending | verified
Prior owner stopped and clean exact-head proof, when serial transfer:
Factual lane/head/owner verification, when serial transfer:
Open risks:
Next safe action:
Execution directive: Treat this as one uninterrupted assigned-slice task, not a
planning or advisory request. Investigate whatever is necessary, implement the
complete assigned slice, run verification, and repair failures before
responding. Do not send progress updates or stop within the assigned slice. A
partial implementation, successful individual test, or intermediate milestone
is not completion. After the clean slice commit, release writable ownership and
do not begin the next substantive slice unless the reviewed plan records the
explicit `single-task-wave-owner` exception.
```

A pending next owner does not authorize overlapping writers. Before writing,
the receiver verifies its assigned branch/worktree/head, prior writer shutdown,
and scope, plus any current supported repo ownership protocol. Optional
diagnostics are not activation fields or handoff gates.

Keep this doc current. If a lane changes branch, worktree, or ownership, update
the doc before handing off.

## Minimal Handoff Prompt

Use a short prompt like this:

```text
Continue the assigned lane.

Branch: <branch>
Worktree: <worktree>
Handoff doc: <path>
Result path: <path>

Read the handoff doc first, then continue exactly from that state.
```

Do not pack the full slice context into the prompt when the handoff doc already
exists.

## Output

Report only:

- lane created or selected
- branch
- worktree
- bootstrap/status result
- handoff doc path
- result path
- minimal handoff prompt

## Telemetry Tool Failure Logging

Attempt an enabled observation once. Preserve failures locally and use a
maintained repo incident logger when available. Retrieval, attribution,
reporting, and telemetry are nonblocking diagnostics; do not reconstruct them
or invent unavailable loggers, registries, or wrappers. Actual checkout,
competing-writer, review, product, security, Git-head, merge, or filesystem
cleanup failures remain substantive failures on their own merits.

## Accounting Telemetry Failure Rule

Attempt enabled accounting once. Record one local limitation if it fails;
never retry, reconstruct, backfill, or commit raw accounting to make it green.
Continue through independently validated product, review, Git, and authorized
closeout gates. Do not require a retired accounting wrapper or receipt.
