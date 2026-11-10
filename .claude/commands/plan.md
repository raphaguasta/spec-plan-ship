---
description: Turn a backlog card or an idea into an executable plan (plan only, no execution)
argument-hint: <card-id-or-idea>
---

Produce a plan for: $ARGUMENTS

Deliver the plan only. Do NOT execute any step and do NOT change code.

1. Locate the input. If it is a card ID, read the card in `backlog/<product>/` and its linked spec in `specs/`. If it is a free idea, treat it as a draft and say so.
2. Read `plans/README.md`, `plans/_template.md`, `docs/method/model-routing.md`. Read only the needed sections of other files.
3. Ask ALL clarifying questions up front, in one batch (scope, edge cases, architecture, trade-offs). Wait for the answers. After that, decide minor doubts yourself and do not ask again. Unknown facts are written as `[TBC]`, never guessed.
4. Write `plans/<id>-<slug>.md` from `plans/_template.md` with `status: draft`:
   - Goal and out of scope.
   - Steps, each with `depends:` (ids or `—`), `files:` (every file touched), `model:` (`haiku-class` only if scope is defined, no design decision, checkable by command, low risk; otherwise `sonnet-class`), `specs:` when relevant, `do:` (self-contained, the executor sees no conversation) and `check:` (a command that exits 0 when done, runnable without a human).
   - Declare `depends:` and `files:` accurately; steps without them run sequentially.
   - Gates from `docs/method/gates.md`, adapted to the repo.
   - End with the single production question (what changes, what to validate, one yes/no) and a rollback.
5. If the plan changes behavior, name the spec rules (`R-AREA-NN`) to add or update in the same change.
6. Reply with the plan path, the step list (id, model, depends) and any open `[TBC]`. Then stop.
