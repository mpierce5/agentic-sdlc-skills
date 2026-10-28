# SDLC Skills

Reusable agent skills for Full product SDLC, explicit Light additions, and explicit Defect repairs, with independent LLM review, outcome proof, and verified closeout.

This repository is intended to stay generic and safe to publish. Project-specific details belong in the consuming repository's local agent instructions, not in these shared skills.

## License

Copyright is retained by the repository owner. This repository is public for inspection and reference, but no permission is granted to copy, modify, redistribute, sublicense, or use the contents except where explicitly authorized in writing.

## Design

`skills/sdlc` coordinates the selected mode, creates its checklist, and loads the
correct narrower skills. Full is the default, including legacy packets without a
mode. Light/Defect require explicit selection or an accepted continuation packet;
a bug report alone does not silently select Defect.

Light covers one small addition in established architecture. Defect covers one
observed failure with established expected behavior. Each uses one compact
AC/proof packet, a direct owner, combined independent LLM code/architecture/cleanup
review, targeted proof, and reviewer evidence inspection. Full retains phased
refinement, planning, traceability, matrices, and planned retirement.

Humans confirm new or materially changed AC and support unresolved
product/design/architecture decisions. Accepted instructions or artifacts satisfy
confirmation. Human code review and routine implementation approval are not
required gates. All modes retain repo safety, provider authorization, truthful
outcome proof, and authorized external-action boundaries.

The detailed phase behavior lives in the subskills. The orchestrator should not perform requirements discovery, planning, implementation, or review from memory.

## Contents

- `skills/sdlc` coordinates Full, Light, and Defect workflow, gates, and subskill loading.
- `skills/requirements-discovery` refines problem statements and acceptance criteria.
- `skills/refactor-health` runs the Phase 0 architecture-fit check.
- `skills/functional-plan`, `skills/technical-plan`, and `skills/execution-plan` create reviewed planning artifacts.
- `skills/slice-implement` and `skills/slice-review` run one reviewed implementation slice at a time.
- `skills/sdlc-state` indexes the selected mode; bounded work may use its packet.
- `skills/implement` executes an accepted Full plan or explicit Light/Defect packet.
- `skills/worktree-setup` discovers project setup and protects shared checkouts.
- `skills/lane-bootstrap` prepares isolated lanes and compact owner handoffs.
- `skills/worktree-setup-template` authors a consuming project's setup skill.
- `skills/golden-merge` closes reviewed work through the project's merge policy;
  specialized golden rules apply only when the consuming project defines them.
- `adapters/` maps generic workflow terms to a specific agent platform.

## Active Rules Refresh

The shared bundle and UI prompts were refreshed on 2026-10-13 from the reviewed
Full/Light/Defect workflow and cleanup repair. Full-only artifacts stay scoped to
Full. Bounded work uses compact proof rows and inline cleanup, without a separate
planning bench, execution task, retirement slice, or heartbeat solely for its mode.

Code-review CLEAN and acceptance pending/verified remain separate. CLEAN permits
targeted verification; green completion or merge requires inspected outcome proof
and explicit architecture/cleanup CLEAN. Handoffs use factual identity, prior
writer shutdown, and any currently supported ownership protocol. Optional
retrieval/telemetry and retired bootstrap machinery cannot gate them.

All modes distinguish code cleanup from filesystem cleanup. Routine completed
merged worktrees are removed through the consuming repo's maintained entrypoint.
Verify both directory and Git-registration absence; incomplete deletion is
blocked, not successful telemetry. Use only supported safe retry/recovery. Record
removed/not-applicable, or a precise retained/blocked reason, next action, and
owner in the existing result. Orphan inventory alone never authorizes deletion.

The shared versions intentionally adapt local rules for reuse:

| Active local detail | Shared location or behavior |
| --- | --- |
| Concrete agent models and reasoning | Per-skill defaults in the platform adapter; explicit task/consuming-repo routing overrides |
| Lane provisioning, binding, phase, and cleanup script names | Discover documented consuming-repo entrypoints |
| Required provider and paid qualification policy | Accepted plan and consuming-repo provider authority |
| Provider-specific deployment exceptions | Apply only explicit consuming-repo exceptions |
| Architecture runbook names and domain examples | Read the exact authority docs for the affected project |
| Older bootstrap telemetry gates | Follow the newer optional, nonblocking telemetry rule |
| Scheduled recovery and visible task creation | Respect user authorization and host capabilities |

Installed skills are the comparison source, not a publication-ready mirror.
Do not overwrite the installed copies as part of maintaining this repository.

## Use On Another Project

1. Install the complete `skills/` bundle in the target agent's skill root so the
   orchestrator and all required phase skills are available together.
2. Select the applicable adapter in `adapters/` and expose its instructions to
   the agent. Resolve concrete models against that host's available models.
3. In the consuming project's `AGENTS.md` or equivalent, document its default
   branch/remote, protected checkout rules, supported setup and cleanup commands,
   verification commands and environments, merge/release policy, and any
   provider-test or deployment exceptions.
4. Mark absent lane, database, retrieval, telemetry, or phase utilities as
   unavailable or not applicable. Optional diagnostics are not prerequisites.
5. Invoke `$sdlc` for default Full refinement/planning, `$sdlc light` for a bounded
   addition, or `$sdlc defect` for an established-behavior repair. `$implement`
   accepts the selected mode's approved plan or compact packet.

The current workflow uses `main` and `origin/main` as its baseline convention.
Projects with another default branch or remote must document the equivalent
mapping before use.

## Quality Gates

Full treats AC traceability and AC signoff as separate gates, with execution-plan
trace rows and a final behavior-level AC matrix. Light/Defect use one compact
AC/proof table with expected outcomes, proof boundaries, evidence, and disposition.
Missing Full-only documents are not findings for bounded work.

Full waves include a terminal retirement slice unless their plan records an
inventory-based reason it is not needed. Light/Defect remove introduced or
obsoleted leftovers inline and review cleanup in the final diff. In every mode,
unneeded code, data, assets, tests, docs, scripts, flags, dependencies, generated
files, debug output, and failed-attempt work require removal or explicit retention
with a concrete reason. Disk cleanup is a separate truthful closeout outcome.

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

Map those scope aliases in an adapter file or private local instructions; they
do not require different concrete models or extra reviewers. The
[Codex adapter](adapters/codex.md#model-tier-mapping) defines the approved model
and effort for all 14 shared skills, including distinct bounded implementation,
design, coordination, review, and helper roles. Apply the mapping to both new
assignments and worker resumptions. Loading a helper retains its current owner
and model; it does not create another task. Provider-test model choices remain
separate from execution-agent routing.

## Before Publishing

Run the publication checklist and leak scan:

```powershell
pwsh ./scripts/scan-publication.ps1
```

Do a manual review before pushing any release tag.
