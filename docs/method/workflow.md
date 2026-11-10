# Workflow: card → spec → plan → worktree → executors → gates → one question → merge

## Trail
```
backlog card ─▶ spec ─▶ plan ─▶ worktree ─▶ executor/step ─▶ gates ─▶ ONE question ─▶ merge
 (what/why)   (contract) (steps)  (isolated)  (subagents)    (done?)    (human: yes)    (+docs, cleanup)
```

## Stages
1. **Card** (`backlog/templates/*.md`): problem, why it matters, expected result, verifiable acceptance criteria. See `backlog-standard.md`.
2. **Spec** (`specs/_template.md`): the contract. Behavior, edge cases, rule IDs (`R-AREA-NN`), out of scope, open questions. Decisions with alternatives rejected go to `decisions/_template.md`.
3. **Plan** (`plans/_template.md`): ordered steps. Each step declares:
   - `depends:` step ids or `—`
   - `files:` files it touches
   - `model:` model tier (see `model-routing.md`)
   - `reads:` exact file + section the executor must read
   - checkbox, acceptance, verification command
4. **Worktree**: execution never happens in the main checkout.
   - `git worktree add .worktrees/<name> -b feat/<name> main`
   - Untracked plan/card files: *move* into the worktree (copying breaks the merge).
   - Uncommitted tracked changes do not travel; the worktree starts from the last commit.
   - Own dev-server port per worktree. Secrets never copied by hand.
   - Already inside a worktree: reuse it.
5. **Execution**: one executor subagent per step, same session, one prompt flow.
6. **Gates**: `gates.md`. Every item reports `ok` or `n/a` with reason.
7. **One question** to the human, only after all gates pass.
8. **Merge** on "yes": merge, deploy, docs, log line, worktree cleanup.

## Roles
| Role | Does | Does not |
|---|---|---|
| Orchestrator (main session) | reads step list + open questions only; one round of questions up front; launches executors; checks commit + checkbox + gate report; asks the final question | implement, read the whole plan, screenshot, re-run builds |
| Executor (subagent) | one step, alone, start to commit; reads only its `reads:`; runs gates; commits files of the step; pushes the branch | ask the human, touch files outside `files:`, widen scope |

Executors start with zero context. The prompt must carry: worktree path, branch, plan path, step id, `reads:`, human decisions so far, what earlier steps left behind, do/don't list, and a required report (`STATUS: done|failed|blocked`, commit hash, one line per gate).

## Parallelism
- Default: sequential, in plan order.
- Parallel only for steps whose `depends:` allow it AND whose `files:` do not overlap.
- No `depends:`/`files:` declared → sequential.
- The orchestrator consolidates; parallel executors never edit the same file.

## Cheap verification by the orchestrator
`git log --oneline -3`, `git show --stat <hash>`, checkbox `[x]`, gate lines present. It does not re-run tests.

## Failure handling
- `failed`: one retry with a fresh executor, the failure report, and the next model tier up.
- Fails again, or `blocked` on a human decision: stop the plan, keep work committed and pushed, ask, resume.

## When NOT to use it
- Chat, Q&A, exploration, research.
- Reading or editing 1–2 files.
- One-step plan or tiny tweak: do it directly, no executor (still: gates before asking).

## Light/standard/full rigor (suggested per card)
- light: fix directly and test.
- standard: mini-spec + short plan before coding.
- full: spec, 2–3 alternatives, adversarial review.
