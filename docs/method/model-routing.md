# Model routing

Principle: pay for the smallest model that can do the step *and be checked by a command*. Tiers are generic; map them to whatever models you have.

## Tiers
| Tier | Use for | Typical effort |
|---|---|---|
| haiku-class (cheap, fast) | mechanical, verifiable-by-command work: search, collection, checks, repetitive edits across files, docs, backlog upkeep, steps whose files and result are already in the plan | medium |
| sonnet-class (mid) | delicate new logic, migrations/schema, data in production, access rules, billing, secrets handling, anything a haiku-class run already failed | low (medium only for tricky code or plan review) |
| opus-class (top) | exception only: hard architecture decision, or the human asks. State the reason in the prompt | low/medium |
| main session | decisions, strategy, tradeoffs, final text, the orchestration itself | session default |

## Haiku-class test (all must hold)
1. Scope and expected result are defined.
2. No design decision inside the step.
3. Checkable by a command, a gate, or a diff.
4. Low risk (no migration, no auth rules, no secrets, no money).

Fail any item → sonnet-class.

## Per-step selection
- Plan step has `model:` → obey it.
- No `model:` → apply the test above.
- `model: sonnet-class` needs a written reason on the same line. No reason → haiku-class if the step passes the test.
- Diagnosis and operations work (cloud CLIs, logs, curl, deploys) runs on the mid tier, also outside a plan.
- Risky domains are always mid tier or higher, regardless of how simple the step looks.

## Explicit settings on every subagent call
- Always pass `model` explicitly. Never rely on a default you cannot see.
- Always pass `effort`: low for mid/top tiers, medium for cheap tier. Raise only if the task demands (delicate code, plan review).
- Set a cheap default for subagents globally so an omitted `model` is not expensive.

## Escalation
```
haiku-class ──fail──▶ sonnet-class ──fail──▶ stop, report, ask human
```
- A failed step gets one retry: fresh executor + failure report + next tier.
- Second failure, or a human-only decision: stop the plan, keep commits, ask.
- Opus-class is not a step in the ladder; it is a deliberate exception with a written reason.

## Operational drift
Main session on the top model that turned operational (≥5 consecutive CLI/log/curl commands): delegate the rest to a mid-tier subagent with a goal and a stop criterion, or switch model.
Rule of thumb: a subagent turn carries a fraction of a long main-session turn's context; measure your own setup before tuning thresholds.

## Phases of a task (example split)
- Writing and reviewing the spec/plan: strongest model you can justify, in the main session.
- Orchestrating and executing: mid tier for the main session, cheap/mid for executors.
- Switch model/effort only at session start; each switch invalidates the prompt cache.

## Writing plans for routing
- Put `model: haiku-class` on every step verifiable by test/build/grep/diff.
- Put `model: sonnet-class` on new delicate logic, migrations, production data, or a step that already failed, and write the reason on the line.
- No automatic reviewer agent by default; quality comes from the definition of done (`gates.md`). Add a reviewer only on request, mid tier.

## Free/local tier (optional)
A free or local model may do low-stakes reading/summarizing of 1–2 files. Never for counts, checks, or inputs to decisions. On error, redo on the cheap tier without asking.
