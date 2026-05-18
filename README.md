# SDLC Skills

Reusable agent skills for phase-gated product refinement, planning, implementation, review, clean-code retirement, and verification.

This repository is intended to stay generic and safe to publish. Project-specific details belong in the consuming repository's local agent instructions, not in these shared skills.

## License

Copyright is retained by the repository owner. This repository is public for inspection and reference, but no permission is granted to copy, modify, redistribute, sublicense, or use the contents except where explicitly authorized in writing.

## Design

`skills/sdlc` is intentionally a lightweight orchestrator. When invoked, it must create and follow an explicit checklist, load the correct narrower skill before each phase, and enforce confirmation, review, documentation, AC signoff, clean-code retirement, verification, and commit gates.

The detailed phase behavior lives in the subskills. The orchestrator should not perform requirements discovery, planning, implementation, or review from memory.

## Contents

- `skills/sdlc` coordinates the full workflow, checklist, gates, and subskill loading.
- `skills/requirements-discovery` refines problem statements and acceptance criteria.
- `skills/refactor-health` runs the Phase 0 architecture-fit check.
- `skills/functional-plan`, `skills/technical-plan`, and `skills/execution-plan` create reviewed planning artifacts.
- `skills/slice-implement` and `skills/slice-review` run one reviewed implementation slice at a time.
- `skills/sdlc-state` maintains compact resumable execution state.
- `adapters/` maps generic workflow terms to a specific agent platform.

## Quality Gates

The workflow treats AC traceability and AC signoff as separate gates. Execution plans must include a trace table for planned coverage and a final AC verification matrix for behavior-level proof, proof depth, reviewer signoff status, and deferred/unchecked notes.

Every implementation wave must also include a terminal clean-code retirement slice unless the execution plan explicitly records that it is not needed after checking the full inventory. That retirement slice covers unused or deprecated code, unreachable branches, duplicate implementations, compatibility shims, DB/schema/data objects, migrations or seed data, images/media/assets, tests, docs, scripts, config flags, dependencies, generated files, debug output, and failed-attempt work introduced or made obsolete by the wave. Reviewers should treat leftover unused/deprecated surfaces as blocking unless the plan explicitly retains them with a product or technical reason.

## Public Skill Boundary

The shared skills should contain portable workflow rules only. They may say to read repo-local instructions and use repo-documented commands, but they should not name private commands, domains, users, ports, account files, or deployment lanes.

Use adapters for agent-platform behavior, such as model-tier mapping, plan tools, subagents, and browser automation. Use consuming-repo instructions for project behavior, such as test commands, local URLs, deployment status checks, fixtures, and release policy.

## Local Overrides

Keep these details out of this repository:

- project, customer, employer, or product names
- local filesystem paths and usernames
- private URLs, deployment lanes, ports, callback URLs, or account files
- credentials, secrets, tokens, emails, or OAuth/client identifiers
- company-specific policy or private process details

Put them in the consuming repository's `AGENTS.md`, Claude instructions, Codex instructions, or another private local override.

## Model Tiers

The skills use portable model tiers instead of provider-specific model names:

- `economy-review`: routine diff-first review and checklist work
- `standard-review`: medium-risk architecture, contract, or cross-file review
- `frontier-review`: refinement reviews, hard debugging, broad refactors, and high-correctness-risk reviews

Map those tiers in an adapter file or private local instructions.

## Before Publishing

Run the publication checklist and leak scan:

```powershell
pwsh ./scripts/scan-publication.ps1
```

Do a manual review before pushing any release tag.
