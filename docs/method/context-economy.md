# Context economy

Cost driver: **number of turns × context size**, not output length. Every main-session tool call re-reads the whole context. A subagent pays a small fixed cost instead. Keep the main session lean.

## Delegate vs do directly
| Delegate to a subagent | Do directly |
|---|---|
| ≥4 consecutive read/search/check calls | 1–3 calls |
| reading >~20k tokens when only the conclusion matters | needs exact text to edit or decide |
| repetitive edits over many files | depends on the conversation |
| browser work, screenshots | — |
Decisions, strategy, delicate code and final text stay in the main session.

## Before delegating
1. Can a script do it with no AI? Use the script.
2. Parts independent? Launch several subagents in one message (no shared files).
3. Batch small; ask for short output or output to a file.

## Prompts for subagents
They start cold. Give: goal, absolute paths, exact sections to read, output format and length cap, what not to do, explicit `model` and `effort` (`model-routing.md`).

## Reading files
- Large file (rule of thumb: >~15 KB): `grep -n '^#' file`, then read with offset/limit for the section only. Whole file only if the task requires it.
- Logs: read the tail only (`tail -15`), never whole. Keep entries one line.
- Archive old log entries into dated files.
- CSV/large data: never read whole; `head`, `grep`, or a script.
- Ignore heavy vendored/cloned dirs via deny rules.
- Executor prompts list which sections to read; plans carry `reads:` per step.

## Sessions
- One big task per session. When done, the AI hands over a ready-to-paste prompt for a fresh session instead of chaining.
- Alarm at ~150k context: before it, decide compact (same task) or fresh session (new task).
- Topic change: clear. Long session: compact, ideally before stepping away while the cache is warm.
- Context cache expires after a while; resuming after a long pause with a large context re-writes it at a higher price. Compact or clear first if substantial work remains.
- Change model/effort only at session start.
- Compaction instruction to keep: current request and what remains, human decisions, files/branches/commits touched, errors and fixes, next steps. Drop: used tool output, file contents already read (keep path + finding), dead ends.

## Orchestrator discipline
- Read only the step list and open questions of a plan.
- Verify cheaply (log, `show --stat`, checkbox), do not re-run.
- Git ceremony was a measured cost driver: commit each step with a single script call, not many git commands.
- No screenshots in the main session; a subagent returns a short summary.

## Keep notes cheap to load
- Short, dense notes written as context for an AI, not as manuals.
- Index file with one line per note; map of "where is what" in the root instruction file.
- Prefer editing an existing note over creating a near-duplicate.

## Measure
Track turns per session, share of sessions using subagents, and cost per model. If most sessions never delegate, the rule above is not being applied.
