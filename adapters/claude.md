# Claude Adapter

Use this adapter when these skills run in Claude or Claude Code.

## Skill References

Reference repository-relative paths such as `skills/slice-review/SKILL.md` when asking a separate Claude session, subagent, or reviewer to follow a phase skill.

When `skills/sdlc` is invoked, create an explicit checklist before doing substantial phase work. Keep the checklist current in Claude's plan/task mechanism when available, or in the planning artifact and concise status updates when no plan tool exists.

Before doing phase work, read the relevant subskill `SKILL.md` and follow that subskill's exit criteria. Treat `skills/sdlc` as the checklist-and-gate coordinator, not as a replacement for the narrower skills.

## Subagents

If Claude subagents are available, use them for required independent review gates. If they are not available, use a separate fresh Claude session or a human reviewer and record that choice in the planning/progress artifact.

Do not paste full chat history into routine reviewers. Give the reviewer a compact packet:

- current diff or commit
- changed files
- assigned Product AC, Technical AC, and Negative AC rows
- AC trace rows
- planned tests and focused test results
- relevant plan excerpt
- open findings or deferrals

## Model Tier Mapping

Map the generic tiers to the Claude models available in the work environment.

- `economy-review`: routine slice review, checklist validation, and low-risk follow-up
- `standard-review`: medium-risk architecture, contract, or cross-file review
- `frontier-review`: requirements, Phase 0, functional, technical, and execution-plan review; high-risk security, privacy, auth, payments, deployment, or data-loss work

Prefer a cheaper reviewer only when the slice is bounded and the compact AC/TAC packet is complete. Escalate when the reviewer reports uncertainty or finds a plausible correctness issue.

## Browser Verification

Use Playwright or the work-approved browser automation tool for user-facing verification. Keep browser passes bounded to one clean pass per target view unless code changes or a concrete failure requires another pass.
