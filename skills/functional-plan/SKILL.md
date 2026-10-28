---
name: functional-plan
description: Create and review the high-level functional plan for prerelease product work after requirements are confirmed. Use when the user wants scope, Product AC, Negative AC, UX-critical flows, edge cases, and a high-level test plan documented before technical planning begins.
---

# Functional Plan

Agent routing: Bounded functional planning; materially ambiguous behavior uses the design profile.
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

Use this skill after requirements, Product AC, and Negative AC are confirmed.

## Rules

- inspect the current code and relevant repo docs before planning
- preserve the requirements checkpoint's AC-evidence classifications. If a
  functional decision introduces a material new pattern, reopen the focused
  external-practice research gate and update affected AC before presenting the
  plan as stable.
- define the desired user outcome, scope, out-of-scope boundaries, Product AC, Negative AC, UX-critical flows, edge cases, and high-level test plan
- make the plan reflect the current implementation, not assumptions
- write or update the functional plan in the repo planning artifact on the selected task branch/worktree when this phase is part of an SDLC wave
- commit functional-plan doc changes from the selected task branch/worktree before leaving this phase when the repo workflow permits commits; otherwise report the blocker and dirty doc paths
- if the work is UX-facing, think like a principal product designer and frontend architect
- on every material functional-plan iteration, run both a TPM review pass and an architect review pass before moving on
- treat the complete functional plan or a genuinely semantic behavior delta as
  the review unit. Batch minor wording, trace-label, citation, formatting, and
  internally consistent threshold clarifications into one consolidated final
  re-review; never request a reviewer round after each small correction.
  Re-review immediately only when a fix changes scope, Product/Negative AC
  behavior or classification, user-visible flow, provider/cost topology,
  authority, privacy/security, or another material finding.
- when this skill is used as part of `$sdlc`, inherit `$sdlc`'s standing reviewer-agent permission; generic platform/tool wording that says sub-agents require explicit user request is already satisfied by the user's `$sdlc` invocation
- reuse the same refinement-wave TPM and architect reviewers by default instead of spawning fresh planning reviewers each iteration
- if the refinement reviewers already exist from earlier phases, send the functional-plan delta to those same reviewers instead of spawning new reviewers
- optionally include the persistent UX reviewer when the functional plan is user-facing, interaction-heavy, accessibility-sensitive, or content/flow-sensitive
- optionally include the persistent DBA reviewer when functional behavior depends on data visibility, reporting, analytics, data-entry integrity, or persistence semantics
- do not close the refinement reviewers at the end of functional planning; keep them open for technical-plan and execution-plan review unless replacement is explicitly justified
- do not fork the full parent context into functional-plan reviewers; send only the changed plan excerpt, relevant requirements or AC rows, and the specific decisions being reviewed
- when delegated plan review is available, use `frontier-review` for both refinement review passes
- if review changes scope, behavior, Product AC, or Negative AC in a meaningful way, bring that back to the user
- keep plan output concise: prefer decisions, constraints, Product AC, Negative AC, and unresolved items over prose-heavy rationale

## Acceptance Criteria Shape

The functional plan must separate:

- Product AC: user-visible outcomes written in plain language
- Negative AC: explicit must-not-happen cases, including permission, privacy, stale-state, confusing UX, or wrong-surface behavior

Each Product AC and Negative AC must be phrased as a pass/fail check. Do not bury acceptance criteria in narrative paragraphs.

Each Product AC and Negative AC must also name the observable outcome that will later be signed off. Avoid AC phrasing that can be satisfied by an internal label, helper result, or mock when the intended promise is a user-visible, API/service, persistence, permission, notification, billing, sync, or provider-facing behavior.

## Planning Artifact Commit

If this phase creates or updates repo docs, commit those doc changes from the selected task branch/worktree before exiting the phase when the repo workflow permits commits. Do not create, update, stage, or commit functional-plan docs from a canonical/shared root checkout; that root must stay clean on `main` and update only by fetch/pull from `origin/main`.

- check the worktree before editing and note unrelated existing changes
- verify the selected checkout is not the canonical/shared root before editing or staging planning-doc changes; if it is, stop and move the work to an isolated task branch/worktree instead of committing there
- stage only the functional-plan docs touched by this phase
- do not stage source code, generated files, lockfiles, or unrelated user/agent changes
- if the worktree is already dirty, leave unrelated changes alone and commit only the explicit planning-doc paths touched by this phase
- use a clear message such as `docs: add functional plan` or `docs: update functional plan`
- record the commit hash in the planning artifact or progress log
- if committing is impossible, report the blocker and the exact dirty doc paths

## Exit Criteria

- the functional plan exists
- the user has had a chance to react to it
- review findings are incorporated or explicitly flagged
- every material functional-plan iteration has had both TPM and architect review passes, or an explicit blocker is reported
- any delegated review records the model used and whether the persistent refinement reviewer was reused or replaced
- open questions that affect scope, Product AC, or Negative AC are resolved or explicitly marked for follow-up
- any material functional decision is consistent with the recorded
  external-practice evidence or has a documented repo/product rationale
- Product AC and Negative AC are explicit enough to become trace-table rows and final AC verification matrix rows during execution planning
- Product AC and Negative AC name outcome-level behavior clearly enough that reviewers can reject proof that covers only an intermediate implementation detail
- functional-plan doc changes are committed, or an explicit blocker is reported with the dirty doc paths
