# Gates: definition of done

Nothing reaches the human until every gate is `ok` or `n/a` (with reason). Missing or `failed` item = not done.

## Gate list (one report line each)
| # | Gate | Evidence |
|---|---|---|
| 0 | Scope | only files in the step's `files:` changed (`git diff --stat`) |
| 1 | Tests | command + pass count; new behavior has a new test |
| 2 | Lint / typecheck | command + zero errors |
| 3 | Build | command + exit 0 |
| 4 | Secret scan | no keys, tokens, `.env*`, personal data in the diff |
| 5 | Rule-id check | `scripts/check-rule-ids.sh`: every `R-AREA-NN` cited exists in a spec, none orphaned |
| 6 | Diff review | executor re-reads its own diff: dead code, debug output, unrelated edits |
| 7 | UI check (if UI) | viewed at a narrow and a wide viewport; no console errors |
| 8 | Docs | spec, checkbox, map/index updated as the repo requires |
| 9 | Prod impact listed | migrations, env vars, jobs, data writes, deploys, external side effects |

Adapt the list per repo; keep numbering stable so reports are comparable.

## Executor report (required)
```
STATUS: done | failed | blocked
COMMIT: <hash>
VERIFICATION:
 0 scope: ok
 1 tests: ok (42 passed) — <command>
 2 lint: ok
 3 build: ok
 4 secrets: ok
 5 rule-ids: n/a — no spec touched
 ...
LEFT BEHIND: <1–3 lines the next step needs>
```
The orchestrator checks the lines exist; it does not re-run them.

## Local before production
Everything is proven locally first (tests, build, local DB/migration dry-run). Production-touching actions (migration push, deploy, data backfill) wait for the human's answer, preceded by a backup and a dry run where applicable.

## The single production question
Asked once per plan, after all gates, never per step.

Format:
```
Plan: <name>   Branch: feat/<name>   Gates: all ok
VALIDATE (what you should look at):
 - <1–5 observable checks, with URL/command>
CHANGES IN PRODUCTION if you say yes:
 - <migration / schema / data writes>
 - <deploy target and what users will see>
 - <env vars, jobs, external calls>
 - <irreversible parts and the rollback>
Answer "yes" to release: merge, deploy, docs, log entry, worktree cleanup.
```

Rules:
- List *everything* that changes in production; an unlisted change is a violation.
- "Yes" releases the whole chain without further questions.
- "No"/partial: stop, keep the branch, record what to change.
- No production impact: still report gates, ask only for merge approval (or merge if your policy allows).

## After "yes"
1. Backup, dry run, apply (if data/schema).
2. Merge branch into main, push.
3. Deploy.
4. Update docs and the decision/log record (`decisions/_template.md` if a decision was made).
5. Remove worktree and branch.
