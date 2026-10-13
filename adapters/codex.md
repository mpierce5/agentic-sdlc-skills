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

Choose concrete models according to availability in the current Codex environment.

- `economy-review`: cheapest model that can reliably perform diff-first review
- `standard-review`: stronger model for cross-file, contract, or architectural review
- `frontier-review`: strongest available model for refinement, high-risk review, or hard debugging

Record the concrete model used in the planning/progress artifact when review independence matters.

Concrete model names and reasoning come from the current host's exposed model
list and consuming-repo routing policy. Do not retain historical model names as
launch defaults. If required routing is unavailable, follow the host's escalation
policy rather than silently substituting another tier. Risk alone does not
require the most expensive model when the documented review model is sufficient.

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
