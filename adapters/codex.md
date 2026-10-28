# Codex Adapter

Use this adapter when these skills run in Codex.

## Host Authority

Use only capabilities exposed by the current host and authorized by the user.
An SDLC request authorizes the required bounded independent reviewer subagents
when host policy permits them; it does not bypass separate host requirements
for visible task creation, messaging other tasks, scheduling, or model overrides.
Map user-visible execution tasks to Codex chats only when creation is authorized.
If a separate task is required but unavailable, return the compact handoff;
current-task ownership can continue within its assigned slice.

## Skill References

When delegating to a sub-agent, include the skill name and the local `SKILL.md` path if the platform does not already expose the skill metadata.

## Plan Tracking

When `skills/sdlc` is invoked, use the available plan-tracking tool for the Operational Checklist before doing substantial phase work. Keep exactly one item in progress, and do not mark a phase complete until the loaded subskill's exit criteria are met.

## Subskill Loading

Before doing phase work, load the relevant subskill `SKILL.md` from the installed skills root or repository-relative `skills/` path. Do not rely on the coordinator summary for phase details.

## Sub-Agent Context

For routine review, spawn reviewers without full-context forking. Pass compact context:

- current diff or commit
- changed files
- assigned Product AC, Technical AC, and Negative AC rows
- mode-specific proof: Full trace/matrix rows, or Light/Defect compact AC/proof table
- cleanup expectation: Full retirement inventory, or bounded inline disposition
- planned tests and verification status
- unresolved prior findings
- review mode and model tier

## Model Tier Mapping

Explicit user, accepted task, and consuming-repo routing override these defaults.
Resolve the actual assigned role rather than giving every phase the same model.

| Skill / assigned role | Model | Reasoning |
| --- | --- | --- |
| `sdlc` coordinator | `gpt-6.1-sol` | `medium` |
| `requirements-discovery` | `gpt-6.1-sol` | `medium` |
| `refactor-health` assessment owner | `gpt-6.1-sol` | `medium` |
| `functional-plan` | `gpt-6.1-terra` | `medium` |
| `technical-plan` | `gpt-6.1-sol` | `medium` |
| `execution-plan` | `gpt-6.1-sol` | `medium` |
| `implement` wave coordinator | `gpt-6.1-sol` | `medium` |
| `slice-implement` bounded implementation | `gpt-6.1-terra` | `medium` |
| `slice-review`, independent TPM, architecture, acceptance and cleanup reviews | `gpt-6.1-sol` | `high` |
| `sdlc-state` separately assigned factual index maintenance | `gpt-6-luna` | `medium` |
| `worktree-setup`, `lane-bootstrap` separately assigned setup | `gpt-6-luna` | `medium` |
| `golden-merge` separately assigned closeout | `gpt-6.1-terra` | `medium` |
| `worktree-setup-template` | `gpt-6.1-terra` | `medium` |

Use `gpt-6.1-terra` / `high` for harder bounded implementation within accepted
contracts. Use `gpt-6.1-sol` / `medium` for a genuinely new capability,
architecture decision, or materially ambiguous functional behavior. Terra may
gather bounded Phase 0 inventory; Sol owns assessment and decisions. Luna setup
follows known repo commands and returns unresolved ownership/setup ambiguity to
the owner. Luna state maintenance records established facts, never acceptance
or review verdicts inferred from activity.

All three review aliases (`economy-review`, `standard-review`, `frontier-review`)
default to `gpt-6.1-sol` / `high`. Risk changes review depth and context, not the
default model or required reviewer count. Reuse the required reviewers. Astra
requires a recorded exceptional reason and user approval.

Loading a helper skill does not switch the current model or require a new task.
A direct slice owner retains its selected model through `implement`, setup,
state maintenance, and its own `golden-merge` closeout. Separate helper defaults
apply only when that role is actually assigned separately; do not introduce an
extra worker just to obtain a cheaper helper profile.

For every separately created or resumed worker, select the model for its actual
remaining scope and pass exact model and reasoning in the task-control fields.
Check returned routing when available and record the assignment in the existing
packet. If required routing is unavailable, report the blocker rather than
silently falling back. Preserve explicit task exceptions and healthy ownership;
do not restart completed proof to refresh model identity. These are execution
agent choices, independent of provider-test models and authorization.

Human review concerns AC and unresolved product/design/architecture decisions.
An unavailable LLM reviewer is a tooling blocker, not a mandatory human
code-review fallback. Light/Defect use one combined reviewer and its evidence
follow-up; they do not inherit Full's refinement bench or extra execution tasks.

## Context Isolation And Progress

Disable parent-context forking for bounded setup, helper, and reviewer agents
using the actual tool's supported option (for example, `fork_turns: "none"`).
Give fresh execution owners compact durable handoffs rather than forked chats.
Follow the host's progress-update requirements; keep required updates concise.
An update never ends the assigned work or creates a new approval checkpoint.

## Recovery Scheduling

When the user authorizes scheduled abnormal-stop recovery, use the host's
automation capability for one 15-minute coordinator heartbeat. Stay quiet while
work is healthy; notify only on a meaningful change or required action. Do not
create recurring work from a skill invocation alone. Retire the heartbeat when
no nonterminal lanes remain.
