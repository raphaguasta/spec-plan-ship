---
id: 2026-01-15-in-memory-store
date: 2026-01-15
status: active
review_on: 2026-07-15
---

# Use an in-memory Map as the v1 store

## Context
The shortener needs a code-to-URL mapping. v1 targets a small library with zero dependencies and fast tests. Callers who need persistence are `[TBC]`.

## Decision
Keep the mapping in two in-process `Map`s (code to URL, URL to code). Persistence is out of scope for v1.

## Alternatives discarded
- **File (JSON on disk)**: adds I/O, error handling and concurrent-write issues for a need nobody has confirmed.
- **Database**: adds a dependency and setup, against the zero-dependency goal.

## Consequences
- Easier: no dependencies, deterministic tests, simple code.
- Harder: all codes are lost on restart; one instance per process.
- Change elsewhere: the store is isolated in `src/store.ts`, so a persistent store can replace it later.

## Review date
`review_on`: 2026-07-15, or earlier if a caller needs codes to survive a restart.
