# Plans

A plan turns one backlog card into executable steps.
One plan per card. File: `plans/<card-id>-<slug>.md`, from `plans/_template.md`.

## Lifecycle
`status` is one word:
- `draft`: written by the orchestrator. Not yet approved.
- `ready`: approved by the owner. Can be executed.
- `running`: steps executing in a dedicated git worktree.
- `done`: all steps checked, gates passed, merged.
- `superseded`: replaced by another plan. Keep for history, do not execute.

## Structure
- Goal: one paragraph.
- Out of scope.
- Steps: one block per step, with the keys below.
- Gates: commands that must pass after all steps.
- Production question: the single question asked before production changes.
- Rollback: how to revert.

## Step keys
Each step block declares exactly these keys:
- `depends:` ids of steps that must finish first, or `—` (none).
- `files:` paths the step creates or edits.
- `model:` `haiku-class` or `sonnet-class`.
- `check:` a shell command. Exit 0 proves the step is done.

Optional: `specs:` requirement IDs the step satisfies.

## Rules
- Steps with no declared `depends:` run sequentially, after the previous step.
- Steps may run in parallel only when their `depends:` are finished and their `files:` do not overlap.
- Two parallel steps never edit the same file.
- `haiku-class`: fully specified, verifiable by a command, no design decision, low risk.
  Examples: tests, grep-based checks, mechanical edits, docs.
- `sonnet-class`: new non-trivial logic, data migrations, or a step that already failed as `haiku-class`.
- Each executor gets a self-contained briefing: goal, files, exact changes or the spec IDs to satisfy,
  the check command, and what not to touch. The executor does not see the planning conversation.
- `check:` must be runnable without a human. Prefer a check that fails before the change.
- Gates run after the last step. Typical gates: test suite, build, sensitive-term scan, rule-ID check.
- No automatic reviewer step. Run a review only when the owner asks for it.
- The plan ends with one production question: what changes, what to validate, one yes/no question.
  Nothing that touches production runs before the answer.
- Specs that change are updated in the same change as the code.
