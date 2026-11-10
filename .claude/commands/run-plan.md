---
description: Execute a plan in a git worktree with one subagent per step, run gates, ask the single production question
argument-hint: <plan-file>
---

Execute the plan: $ARGUMENTS

You are the orchestrator only. You do not implement steps yourself. Follow `docs/method/workflow.md`, `docs/method/gates.md` and `docs/method/model-routing.md`.

## Setup
1. Read only the step list and open questions of the plan. Stop if `status` is not `ready` (ask the owner to approve) or if any `[TBC]` blocks a step.
2. Create an isolated worktree on a new branch: `git worktree add .worktrees/<name> -b feat/<name> main` (reuse it if already inside one). Move untracked plan/card files into it; do not copy. Never copy secrets by hand.
3. Set the plan `status: running`.

## Execute
4. One subagent executor per step, launched through the Agent tool with explicit settings:
   - `model: haiku-class` step: model "haiku", effort medium.
   - `model: sonnet-class` step: model "sonnet", effort low.
5. Order: sequential by default. Run steps in parallel (same message) only when their `depends:` are all finished AND their `files:` do not overlap. Missing `depends:` or `files:` means sequential.
6. Each executor gets a self-contained briefing (it starts with zero context):
   - Goal of the step and the exact `do:` text.
   - Worktree path, branch, plan path, step id.
   - `files:` it may touch, and `reads:` sections it must read.
   - The `check:` command and the definition of done: check passes, gates run, files of the step committed, branch pushed.
   - What earlier steps left behind.
   - Forbidden: touching any file outside `files:`, reading or writing secrets or `.env*`, widening scope, asking the human.
   - Required report: `STATUS: done|failed|blocked`, `COMMIT`, one line per gate, `LEFT BEHIND`.
7. Verify cheaply: `git log --oneline -3`, `git show --stat <hash>`, the report lines. Do not re-run tests.
8. On `failed`: one retry with a fresh executor, the failure report and the next tier up. A second failure or a `blocked` step stops the plan; keep commits and ask the owner.

## Gates and the question
9. Run the gates from the plan (`docs/method/gates.md`); every item must be `ok` or `n/a` with a reason. Commit and push the worktree branch.
10. Ask the ONE production question in the format of `docs/method/gates.md`, listing everything that changes in production. Ask it once per plan, never per step.

## After "yes" only
11. Backup and dry run if data or schema is touched, then apply. Merge the branch into main, push, deploy if applicable.
12. Update the spec, the plan `status: done`, the card status and, if a decision was made, a record in `decisions/`.
13. Remove the worktree and branch.

On "no" or partial approval: stop, keep the branch, record what must change.
