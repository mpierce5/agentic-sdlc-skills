---
name: worktree-setup-template
description: "Template for creating a project-specific worktree/lane setup skill. Use when documenting how SDLC agents should discover/select branches, worktrees, ports, databases, verification URLs, cleanup commands, and merge policy for a repo."
---

# Worktree Setup Template

Agent routing: Bounded setup-skill authoring.
Resolve concrete model and effort through the active platform adapter or explicit
task/repo policy. See the shared [routing policy](../sdlc/SKILL.md#model-and-agent-policy);
helper loading retains the existing owner/model.

Use this to publish a project-specific worktree setup skill. Keep the final project skill short and command-focused.

## Skill Metadata To Publish

```yaml
---
name: worktree-setup
description: "Discover, select, verify, and close the correct branch/worktree/lane for SDLC work in <project>. Use at SDLC start to follow this repo's configured setup; mark not applicable only when no setup exists."
---
```

## Project Details To Fill In

```text
Branch rule:
Worktree root:
Create/select command:
Start command:
Status command:
Cleanup command:
Frontend port/URL policy:
Backend port/URL policy:
Database policy:
Protected resources:
Verification expectations:
Merge/auto-merge policy:
```

## Agent Workflow To Publish

1. Read repo-local workflow instructions.
2. Create or select the configured branch/worktree/lane before code edits.
3. Record branch, worktree, URLs, database, and cleanup command.
4. For planning-only work, stop after recording applicability.
5. For implementation, verify the selected lane before testing.
6. Work only inside the selected worktree.
7. Handoff with changed files, tests, verification URLs, risk level, and merge recommendation.
8. At closeout, leave the lane for review or clean only owned resources with the configured cleanup command.

If no worktree/lane environment exists, mark setup `not applicable`, record why, and use the safest available branch/checkout workflow. Do not invent ports, databases, or cleanup rules without project approval.
