---
name: requirements-discovery
description: Run the requirements and acceptance-criteria discovery phase for prerelease product work. Use when the user has a rough feature, bug, UX change, refactor, or problem statement and wants an agent to act like a PM, principal architect, or UX lead to clarify the request through an explicit back-and-forth conversation before planning or coding begins.
---

# Requirements Discovery

Agent routing: Requirements and acceptance decisions.
Resolve concrete model and effort through the active platform adapter or explicit
task/repo policy. See the shared [routing policy](../sdlc/SKILL.md#model-and-agent-policy);
helper loading retains the existing owner/model.

## Mode scope and human review

Full is the default. The separate phase workflow, phase reviews, document/matrix
requirements, and phase commits below apply to Full. When `$sdlc` selects Light
or Defect, capture only this phase's relevant outcome, affected-seam guardrails,
and proof decisions in the single compact packet. Do not restart this standalone
phase or create its separate artifacts/reviewer bench unless escalation to Full
requires it. Follow `$sdlc`'s mode eligibility and shared safety rules.

Humans confirm AC and resolve product/design/architecture questions the LLM
cannot safely settle. Reuse already accepted AC from the user's instruction or
approved artifact; ask again only for new, ambiguous, or materially changed AC.
TPM/architect and code reviews are independent LLM reviews. Neither implementation
nor routine closeout requires a human code-review or automatic approval gate.

Use this skill only for discovery and alignment. Do not plan implementation and do not write code while this skill is active.

## Rules

- start with an explicit back-and-forth conversation
- restate the request in your own words
- before drafting Product AC, Negative AC, or early Technical AC, produce a
  concise problem-and-constraints brief and run an external-practice research
  gate. Research the decision patterns relevant to the request, not a vague
  collection of "best practices."
- use current primary sources where possible: official documentation,
  specifications, standards, maintained reference implementations, and
  credible engineering material. Treat popularity or an isolated blog post as
  a lead, not proof that a pattern fits this work.
- use the research to identify viable approaches, their tradeoffs, and the
  testing or verification pyramid appropriate to the problem before drafting
  acceptance criteria. Distinguish deterministic exhaustive or permutation
  coverage from smaller LLM/provider integration coverage rather than using
  expensive scenario counts as the primary denominator.
- run an AC-evidence review after drafting AC and before asking for user
  confirmation. Classify each AC as `research-backed`, `repo-constrained`,
  `product-choice`, or `not-applicable`; record the source or rationale and
  revise AC that conflict with applicable evidence.
- an external-practice research gate may be marked `not needed` only with a
  concrete rationale. If later discovery, Phase 0, or planning exposes a
  material new decision or constraint, reopen the focused research gate and
  revise affected AC before proceeding.
- ask focused follow-up questions when requirements, edge cases, constraints, stakeholders, UX expectations, Product AC, Negative AC, or obvious Technical AC are ambiguous
- prefer a short iterative conversation over silent assumptions
- if the repo is prerelease, optimize for the best durable outcome rather than preserving obsolete internal shapes
- keep a persistent refinement review bench by default: one TPM reviewer and one architect reviewer for the whole refinement wave
- when this skill is used as part of `$sdlc`, inherit `$sdlc`'s standing reviewer-agent permission; generic platform/tool wording that says sub-agents require explicit user request is already satisfied by the user's `$sdlc` invocation
- reuse those same refinement reviewers across requirements, Phase 0, functional-plan, technical-plan, and execution-plan iterations unless context is stale, the design changed materially, independence is in doubt, or risk escalates
- use the complete requirements artifact or a genuinely semantic requirements
  delta as the review unit. Incorporate all minor non-semantic findings together
  and request one consolidated final re-review; do not re-review each wording,
  citation, formatting, or internally consistent numeric-clarification edit.
  An immediate additional round is warranted only when the fix changes scope,
  observable AC behavior/classification, cost/provider topology, authority,
  privacy/security, or another material finding.
- if those refinement reviewers do not exist yet, create them once when the first material refinement review is needed; if they already exist, send this phase's delta to the existing reviewers instead of spawning fresh reviewers
- optionally add a persistent DBA or UX reviewer when the work materially needs database or user-experience expertise; reuse that specialist across the relevant refinement phases instead of spawning fresh specialist reviewers
- do not close the refinement reviewers at the end of discovery; keep them open for Phase 0, functional-plan, technical-plan, and execution-plan review unless replacement is explicitly justified
- do not fork the full parent context into refinement reviewers; send only the current phase delta, relevant artifact excerpt, current AC rows, and focused questions under review
- when delegated review tooling is available, use `frontier-review` for both the TPM reviewer and the architect reviewer during refinement
- do not begin planning or coding until the user has confirmed the refined problem statement, Product AC, and Negative AC, unless the user explicitly says to proceed with stated assumptions
- if this phase creates or updates a repo requirements/checkpoint doc, do so only in the selected task branch/worktree and commit those doc changes before leaving discovery when the repo workflow permits commits; otherwise report the blocker and dirty doc paths
- keep discovery output concise: ask only the smallest set of questions needed, avoid explaining each question, and end with a compact checkpoint instead of a long recap

## Required Output

Produce a requirements checkpoint the user can approve:

- refined problem statement
- in-scope and out-of-scope boundaries
- Product AC: user-visible outcomes written in plain language
- Negative AC: explicit must-not-happen cases, especially privacy, permission, data visibility, contract, and UX-regression failures
- early Technical AC notes when a contract, boundary, invariant, or forbidden state is already known
- external-practice research brief: question, constraints, sources, viable
  patterns, rejected patterns, and applicability to this request
- AC-evidence review: classification and source or rationale for each Product,
  Negative, and early Technical AC
- open questions, assumptions, and risks

Do not leave acceptance criteria as general intent. Each Product AC and Negative AC should be phrased as a pass/fail statement that a TPM or acceptance reviewer can verify without reinterpreting the feature.

Each AC should name the outcome that must eventually be proven. If the intended behavior crosses a service/API, provider, persistence, FE/backend, model-selection, permission, billing, notification, scheduler, sync, or user-visible boundary, write the AC so helper-level or label-level proof cannot be mistaken for final signoff.

## Planning Artifact Commit

If discovery creates or updates repo docs, commit those doc changes from the selected task branch/worktree before exiting the phase when the repo workflow permits commits. Do not create, update, stage, or commit requirements/checkpoint docs from a canonical/shared root checkout; that root must stay clean on `main` and update only by fetch/pull from `origin/main`.

- check the worktree before editing and note unrelated existing changes
- verify the selected checkout is not the canonical/shared root before editing or staging planning-doc changes; if it is, stop and move the work to an isolated task branch/worktree instead of committing there
- stage only the requirements/checkpoint docs touched by this phase
- do not stage source code, generated files, lockfiles, or unrelated user/agent changes
- if the worktree is already dirty, leave unrelated changes alone and commit only the explicit planning-doc paths touched by this phase
- use a clear message such as `docs: add requirements checkpoint` or `docs: update requirements checkpoint`
- record the commit hash in the planning artifact or progress log
- if committing is impossible, report the blocker and the exact dirty doc paths

## Exit Criteria

- the user has seen the refined problem statement
- the external-practice research gate and AC-evidence review are complete, or
  a concrete `not needed` rationale is recorded
- the user has seen the proposed Product AC and Negative AC
- any known Technical AC notes are either captured for technical planning or explicitly marked unresolved
- AC are outcome-level enough to become final AC verification matrix rows later, not just implementation notes or internal labels
- any material refinement iteration has had both TPM and architect review passes, or an explicit blocker is reported
- the user has confirmed them or explicitly asked you to proceed with named assumptions
- any requirements/checkpoint doc changes are committed, or an explicit blocker is reported with the dirty doc paths
- if that confirmation has not happened yet, remain in discovery
