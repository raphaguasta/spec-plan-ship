# spec-plan-ship

A stack-agnostic kit for shipping software with [Claude Code](https://claude.com/claude-code) without losing control of it.

**card → spec → plan → worktree → one executor subagent per step → gates → one question → merge**

The model does the typing. You keep the decisions: what to build (card, spec), how (plan), and the single go/no-go before anything touches production.

```
 backlog card ──► spec ──► plan ──► git worktree ──► executors (1 subagent / step)
  what & why     R-AREA-NN  steps:      isolated        parallel only if the plan
                 current    depends:    branch          declares depends: / files:
                 state      files:
                            model:
                                          │
   merge, deploy, docs, cleanup ◄── "yes" ◄── ONE question ◄── gates (tests, lint,
                                              what to validate     secret scan, rule ids,
                                              + what changes       diff review)
                                              in production
```

## Why this shape

- **Specs hold only the current state**, with testable requirement IDs, so the AI reads a short truth instead of a history.
- **Plans declare dependencies and files per step**, so parallelism is safe and sequential is the default.
- **One subagent per step, with a cheap model by default**, keeps the main session small and the bill low; escalate only when a step fails.
- **Gates before the question**: the human is asked once, with evidence, not at every step.
- **Never invent**: unknown facts are marked `[TBC]`.

## Quickstart

1. Copy into your repo: `CLAUDE.md`, `.claude/`, `specs/`, `plans/`, `backlog/`, `decisions/`, `scripts/` (and `docs/method/` as reference).
2. Edit `CLAUDE.md`: fill the `[TBC]` markers (stack, test command).
3. Review `.claude/settings.json` (safe defaults, destructive commands denied) and adapt it to your stack.
4. In Claude Code:
   - `/backlog-new <product>` scaffold a backlog
   - `/plan <card>` write a plan (does not execute)
   - `/run-plan plans/<file>.md` execute in a worktree, one subagent per step
   - `/next` refill the short task queue
   - `/decision <topic>` record a decision with discarded alternatives
5. Optional: copy `.github/workflows/` for secret scanning and rule-id checks in CI.

## What's inside

| Path | Purpose |
|---|---|
| `CLAUDE.md` | Template of project rules |
| `.claude/commands/` | `plan`, `run-plan`, `next`, `backlog-new`, `decision` |
| `docs/method/` | workflow, model routing, gates, context economy, backlog standard |
| `specs/`, `plans/`, `backlog/`, `decisions/` | Guides and templates |
| `scripts/` | `check-rule-ids.sh`, `check-sensitive.sh` |
| `examples/shortener/` | A small Node/TypeScript app built end to end with this kit: card → spec → plan → code → decision |

## Try the example

Needs Node 22.6+ (type stripping; Node 24 recommended). No dependencies to install.

```bash
cd examples/shortener
npm test
```

Read the trail in this order: `backlog/` → `specs/` → `plans/` → `src/` → `decisions/`.

## Philosophy

Plan first, execute in isolation, verify mechanically, ask once. Prefer a script to an AI call, a cheap model to an expensive one, and a short file to a long one.

## License

MIT. See [LICENSE](LICENSE) and [CONTRIBUTING.md](CONTRIBUTING.md).
