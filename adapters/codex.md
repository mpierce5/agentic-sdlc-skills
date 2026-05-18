# Codex Adapter

Use this adapter when these skills run in Codex.

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
