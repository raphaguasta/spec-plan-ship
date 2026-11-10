---
id: STY-001
title: "Shorten a URL"
type: story
category: feature
area: app
parent: EPC-001
status: done
priority: medium
horizon: now
rigor: standard
depends_on: []
plan: plans/shortener-v1.md
origin: human
created: 2026-01-10
---

# STY-001 — Shorten a URL

## Story
As a library user, I want to turn a long URL into a short code and resolve it back, so that I can share compact links.

## Problem today
- No shortening code exists. `[TBC]` whether callers need persistence later.

## Why it matters
Callers need a tiny, dependency-free building block. Without it each caller writes its own ad hoc version.

## Expected result
- `shorten(url)` returns a 6-character code; `resolve(code)` returns the URL.

## Acceptance criteria
- [x] A valid URL gets a 6-character code and resolves back to the original.
- [x] The same URL always gets the same code.
- [x] An unknown code resolves to `undefined`.
- [x] An invalid URL is rejected with an error.

## Subtasks
- [x] Spec, plan, code, tests, decision on storage.

## Out of scope
- Persistence, custom aliases, expiry, statistics.

## Open questions
- [TBC] Should a later version persist codes?

## References
- Spec: `specs/shortener.md`
- Plan: `plans/shortener-v1.md`
- Decision: `decisions/2026-01-15-in-memory-store.md`
