# Repo Sources

Load only the sources relevant to the current request.

## Always read first

- the repo-level `AGENTS.md` if present
- the repo's workflow doc if present, such as `docs/dev-workflow.md`

## Read when architecture or contracts matter

- the repo's architecture doc, such as `docs/architecture-latest.md`
- the repo's contract doc, such as `docs/api-contracts.md`

## Read when the work is UX-heavy

- the repo's UX plan or UX review docs, such as `docs/ux-implementation-plan.md` and `docs/ux-rapid-review.md`
- any narrower plan in the repo's `docs/` folder that matches the feature area

## Read when continuing an existing wave

- the most recent feature-specific refinement or implementation plan in the repo's `docs/` folder
- the repo's defects log if one exists
- the repo's progress log if one exists

## Verification reminders

- verify the intended local lane first
- verify the deployed lane second when the task is deployment-facing
- use the repo's shared review account or test fixture when the work depends on real user data

Use repo scripts instead of ad hoc commands when possible. Prefer commands documented in repo-local agent instructions, package scripts, task runners, CI config, or workflow docs. Common examples include:

- full or focused test commands
- lint, typecheck, formatting, or build commands
- area-specific backend/frontend test lanes
- browser or Playwright verification commands
- deployment or stack-status checks
