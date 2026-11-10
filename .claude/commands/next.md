---
description: Refill the task queue (TASKS.md) from the backlog by priority and dependencies; propose only
---

Refill `TASKS.md`. Do not start any work.

1. Read `TASKS.md`, the owner's priorities if a goals file exists, and for each product only the index/listing block of its backlog (never whole READMEs). Follow the queue rules in `docs/method/backlog-standard.md` if present, and `docs/method/context-economy.md`.
2. Candidates: cards with `horizon: now` and status `todo` or `doing`, whose `depends_on` items are done. Order by priority, then by unblocking value.
3. Propose the queue: dated items first (overdue or due in the next 7 days), then at most 5 items in "now", then "next". Each item links to a card ID (no copies), with a one-line why-now, blockers, and `origin:` (`human`, `ai`, `ai-reviewed`). Add a few spare candidates.
4. Never change priority, horizon or status of any card. Unknowns are `[TBC]`.
5. Show the proposal and wait for approval before writing `TASKS.md`. If more than 5 are requested, warn once, then obey.
