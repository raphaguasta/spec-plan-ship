# CLAUDE.md — project rules for Claude Code

Template: copy to your repo root, replace the `[TBC]` markers, delete what you don't need.
Keep it short. Claude reads it every session; every line costs context.

## Project

- What it is: [TBC one sentence]
- Stack / run / test commands: [TBC e.g. `npm test`, `make check`]
- Where things live: specs in `specs/`, plans in `plans/`, backlog in `backlog/`, decisions in `decisions/`, method docs in `docs/method/`.

## Golden rules (highest priority)

1. **Don't invent.** If a fact is not in the repo or was not said by the human, write `[TBC]`. Never fill a gap with a plausible guess.
2. **Provenance.** Say whether a note or decision is the human's position or an AI proposal (`origin: human | ai-confirmed | ai`). Treat `ai` as a hypothesis.
3. **Relevant decision → `decisions/`.** Use the template; include discarded alternatives and a `review_on` date.
4. **Specs are current state only.** Telegraphic, requirement IDs `R-AREA-NN`, no history. Run `bash scripts/check-rule-ids.sh` after editing them.
5. **No secrets in the repo.** Tokens, passwords, `.env`, personal data, real customer names: never. Run `bash scripts/check-sensitive.sh` before pushing.
6. **Pending work is born in `TASKS.md`, never only in a log.** Anything left to do (deploy, validation, open worktree, decision) gets an item under "In progress / waiting" with an owner. At wrap-up run `bash scripts/loose-ends.sh --fix` and leave no `!`.
7. **Be a critical partner.** Point out contradictions with specs, decisions or the plan before executing.

## The path of every change

card → spec → plan → worktree → one executor subagent per step → gates → **one** production question → merge.

1. Card in `backlog/<product>/` says what and why.
2. Spec (`specs/`) states the requirements that must hold afterwards.
3. Plan (`plans/`, via `/plan`) lists steps with `depends:`, `files:`, `model:`, `check:`.
4. Execution (`/run-plan`) starts in a git worktree on its own branch. The session only orchestrates; each step runs in a subagent.
5. Gates ([docs/method/gates.md](docs/method/gates.md)) pass locally: tests, typecheck/lint, secret scan, rule-id check, diff review.
6. Ask the human **once**: what to validate and everything that changes in production. "Yes" releases merge, deploy, docs and cleanup.

Skip the trail for chat, research and edits of 1–2 files.

## Model routing

- Cheap/fast model (haiku-class), effort medium: mechanical work verifiable by a command (search, collection, repetitive edits, docs, tests that exist).
- Mid model (sonnet-class), effort low: delicate new logic, migrations, production data, or a step the cheap model already failed.
- `model: sonnet-class` in a plan needs a written reason; otherwise haiku-class if it passes the test.
- Top model (opus-class) in a subagent: rare exception, state the reason.
- Operational session (≥5 consecutive CLI/log/curl commands): delegate the rest to a mid-tier subagent or switch model.
- The main session keeps decisions, strategy, delicate code and final text.
- Always set `model` and `effort` explicitly when spawning a subagent. Details: [docs/method/model-routing.md](docs/method/model-routing.md).

## Context cost

- Files over ~15 KB: `grep -n '^#'`, then read only the section needed.
- Never read whole logs or CSVs: use `head`, `grep` or a script.
- Delegate ≥4 consecutive read/search calls to a subagent; ask for a short answer.
- One big task per session; start a new session for the next one.
- Details: [docs/method/context-economy.md](docs/method/context-economy.md).

## Working with the human

- Ask all clarifying questions up front, in one batch. After that, execute without pausing; decide small doubts yourself and note them.
- Stop only for real blockers: missing credential, external failure, destructive or irreversible action.
- End a work session with: what changed, what is pending or risky (max 3 lines).
