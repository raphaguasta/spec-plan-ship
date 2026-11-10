---
id: plan-card-id
card: CARD-000
status: draft        # draft | ready | running | done | superseded
created: YYYY-MM-DD
---

# Plan: <short title>

## Goal
One paragraph: the observable result when all steps are done.

## Out of scope
- <what this plan does not do>

## Steps

### S1: <short title>
depends: —
files: `path/to/file-a`, `path/to/file-b`
model: haiku-class
specs: R-AREA-01
do: <exact change, or the behavior to implement, in full sentences>
check: `<command that exits 0 when the step is done>`

### S2: <short title>
depends: S1
files: `path/to/file-c`
model: sonnet-class
specs: R-AREA-02
do: <exact change, or the behavior to implement>
check: `<command>`

## Gates
- `<test command>`
- `<build command>`
- `bash scripts/check-sensitive.sh`
- `bash scripts/check-rule-ids.sh`

## Production question
One paragraph: what changes in production, what to validate, then one yes/no question.

## Rollback
- <how to revert, step by step>
