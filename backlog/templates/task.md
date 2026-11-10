---
id: TSK-000
title: ""
type: task
category: debt        # debt | bug | refactor | cleanup | infra | tests | decision
area: app             # one of the areas in the product config.md
parent:               # optional epic or initiative ID, or empty
status: todo          # todo | doing | blocked | done
severity:             # optional technical risk: P1 | P2 | P3 | P4. Not priority.
priority:             # set by owner: high | medium | low
horizon: undefined    # set by owner: now | quarter | later | undefined
rigor: light          # light | standard | full (suggestion)
depends_on: []        # list of IDs
plan:                 # path to the plan, once it exists
origin: human         # human | ai | ai-reviewed
created: YYYY-MM-DD
---

# TSK-000 — <title>

## Summary
One or two sentences in plain language: what must be done and why.

## Problem today
- What happens now, with evidence: file and line, spec ID, migration, log.
- Unknowns: `[TBC]`.

## Why it matters
Impact on users or the business, and the risk of not doing it. Two to four lines.

## Expected result
- How the system must behave afterwards, in observable terms.

## Acceptance criteria
- [ ] Testable. One line each. Happy path first, then empty state, failure, rollback.

## Subtasks
- [ ] Small steps. Optional.

## Out of scope
- What this task does not cover.

## Open questions
- [TBC] Questions for the owner, all at once.

## References
- Links to specs, plans and related cards.
