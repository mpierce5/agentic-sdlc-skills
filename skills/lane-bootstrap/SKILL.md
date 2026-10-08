---
name: lane-bootstrap
description: Create or refresh a task branch/worktree/lane and write the lane-local handoff doc for the next agent. Use when the user wants a cheap setup worker to prepare a new execution lane, bootstrap a worktree, capture branch/worktree/result paths, or hand off a prepared lane to another execution task or agent.
---

# Lane Bootstrap

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
transfer. For a newly created lane, invoke the repo provisioner with
`-SeparateTaskHandoff` and an explicit `fresh-visible-task` or
`fresh-manual-handoff` launch mode so it cannot silently retain the direct-owner
default. For an accepted `serial-exclusive-lane-transfer`, do not create a
competing worktree: verify the prior owner is review-clean, green, committed,
and stopped; bind its exact pushed head and clean lane; then have the
coordinator rebind the exclusive lease, task id, activation epoch, registry,
retrieval gate, and telemetry baseline before the fresh next task writes.

For a separate-task lane, follow the consuming repo's documented provisioner
and owner-binding flow. Keep an unbound lane read-only until the real owner is
known and exclusive write ownership is verified. Do not reconstruct internal
provisioner parameters or require optional telemetry to activate an otherwise
valid owner.

## Required Reads

Before acting:

1. read `AGENTS.md` or equivalent repo instructions;
2. read the current execution plan, planning artifact, or lane assignment note;
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
  branch or context; pass only a compact handoff and targeted retrieval packet.
  Shared-seam exceptions must be explicitly approved and integrated into the
  fresh lane after creation.
- reuse an existing lane for another top-level task only when the reviewed plan
  selects `serial-exclusive-lane-transfer`. Require exact branch/worktree/base/
  final pushed head, clean status, prior writer shutdown, released/acquired
  exclusive lease, new activation epoch and task binding, compact handoff,
  and compact ownership evidence. Fail closed on an ownership mismatch and
  never allow overlapping writers. Optional diagnostics do not gate transfer.
  This does not relax fresh-`origin/main` provisioning for
  a new or parallel lane.
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
- record provider-test authority from the consuming repo and accepted slice:
  required provider, optional comparisons, admission rules, and paid-test
  limits. Optional comparisons must not become hidden prerequisites.

## Workflow

1. Identify the intended lane owner, slice, or work item.
2. Discover whether the repo already provides:
   - status script
   - bootstrap/setup script
   - worktree provisioning script
   - shared coordination ledger
3. Create or select the lane using repo rules.
4. Run the repo status/bootstrap commands needed to make the lane usable. For a
   separate task, follow the documented provisioner and owner-binding flow
   using the real task id. Keep it read-only until ownership is verified;
   optional telemetry does not determine whether activation succeeds.
5. Record:
   - branch
   - worktree
   - base commit or parent
   - result path
   - owned work item
   - required docs/artifacts
   - lock or ownership state
   - for a serial transfer: prior and next task ids, activation epoch, exact
     pushed head, clean-lane proof, lease release/acquisition, compact handoff,
     and optional local diagnostic closeout/new baseline
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
Activation epoch:
Prior owner task id, when serial transfer:
Exact prior pushed head, when serial transfer:
Next owner task id, when serial transfer: pending bootstrap_wait | <id>
Lane registry path and bound lane identity, when serial transfer:
Retrieval packet path, when supported:
Prior owner telemetry closeout, when enabled (nonblocking):
Next owner telemetry baseline, when enabled (nonblocking):
Exclusive lease release evidence, when serial transfer:
Exclusive lease acquisition evidence, when serial transfer:
Activation state, when serial transfer: bootstrap_wait | active
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
Task/epoch/registry/ownership binding verification, when serial transfer:
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

`pending bootstrap_wait` is permitted only while the coordinator obtains the
real next task id and completes the transfer bindings. The next task must not
enter `active` or write until required ownership fields are filled, verified,
and consistent with the lane registry or documented ownership mechanism.
Optional retrieval and telemetry fields do not prevent activation.

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
