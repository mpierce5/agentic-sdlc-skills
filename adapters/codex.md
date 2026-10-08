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
- trace-table rows
- final AC verification matrix rows and required proof depth
- clean-code retirement expectation and inventory/proof when applicable
- planned tests and verification status
- unresolved prior findings
- review mode and model tier

## Model Tier Mapping

Choose concrete models according to availability in the current Codex environment.

- `economy-review`: cheapest model that can reliably perform diff-first review
- `standard-review`: stronger model for cross-file, contract, or architectural review
- `frontier-review`: strongest available model for refinement, high-risk review, or hard debugging

Record the concrete model used in the planning/progress artifact when review independence matters.

The active local rules at the refresh used these concrete assignments:

- bootstrap: `gpt-6-luna`, medium reasoning
- writable slice owner: `gpt-6-terra`, medium reasoning
- routine review: `gpt-6-terra`, medium reasoning
- deep, acceptance, or guardrail-sensitive review: `gpt-6-terra`, high reasoning

These names are adapter defaults, not availability guarantees. Check the host's
exposed model list before selecting them. If a named model is unavailable, use
the documented repo mapping or select an available model capable of the tier
when host policy permits selection, and record the substitution. Never issue
an unsupported model assignment or silently weaken a required review tier.

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
