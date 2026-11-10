# Backlog standard

One standard for every product. Stock (backlog) feeds a small queue (next tasks).

## Hierarchy
`initiative → epic → story | task` (subtasks are checkboxes inside the card)
- Initiative: large business goal; only if several epics serve it.
- Epic: deliverable outcome of several items that move together (rule of thumb: more than ~3).
- Story: user value. "As <who>, I want <what>, so that <why>", with acceptance criteria.
- Task: technical work without a user story (debt, infra, tests, cleanup, fix).
- Parent rules: initiative has none; epic has an initiative or none; story/task has an epic, an initiative, or none. A story/task is never a parent.
- A subtask that grows becomes a task under the same epic, linked from the parent.

## IDs
`<PREFIX>-NNN`, one sequence per product across all types; type lives in front matter. File: `<ID>-<kebab-slug>.md` (slug ≤60 chars). Get the next free number from a script, never by eye.

## Layout (one folder per product)
```
<product>/backlog/
├── README.md       # intro, generated tree + listing, pending decisions
├── config.md       # prefix, standard version followed, areas, local deviations
├── ideas.md        # inbox: one line per idea
├── initiatives/  epics/  cards/
```
Card templates: `backlog/templates/*.md`.

## Card content (readable without opening another thread)
Summary or story · Problem today (with evidence links; unknown = `[to confirm]`) · Why it matters · Expected result (observable) · Acceptance criteria (one verifiable line each, happy path and edges) · Subtasks · Out of scope · Open decisions · References. Target ~25–40 body lines; split if larger.

## Statuses
`idea → refine → ready → in-progress → done`, or `discarded` (with reason, never delete).
- `ready` = may be pulled, not finished.
- Epic/initiative status follows children: in-progress if any descendant moved and not all done; done if all done.

## Front matter
All: `id`, `title`, `type`, `parent`, `status`, `priority`, `horizon` (`now|quarter|later|unset`), `origin`, `created`.
Story/task: `category` (debt, bug, feature, decision, refactor, cleanup, infra, tests), `area` (from config), `rigor` (`light|standard|full`), `depends_on`, `refs`; optional `severity` (technical risk, not priority).
Derived (generated, never hand-edited): epic, initiative.

## Who decides what
- Human: priority, horizon, what enters `in-progress`, `refine → ready`, `discarded`.
- AI: captures, drafts, refines criteria, flags unknowns, keeps generated lists, executes what was pulled. Never prioritizes or estimates.

## Generated blocks
Marker pairs (e.g. `<!-- TREE:START -->…<!-- TREE:END -->`) hold progress counts, child tables, the product listing. An index command regenerates them; never edit inside.

## Config per product (`config.md`)
`product`, `prefix`, `standard_version`, `areas`, `uses_severity`. Body: **Local deviations**, each with date and reason. Local deviations win over global changes; the AI warns on conflict.

## Changing the standard
- **Everywhere**: classify change, check conflicts with local deviations, show the migration plan and get confirmation, edit the standard, bump its version, log the migration, update templates and generated blocks in each product, bump each `standard_version`.
- **One product only**: change that backlog, record it under Local deviations, do not bump the version.
- **New product**: scaffold from the standard with a prefix.
- **Sync**: bring one product to the current version by applying pending migrations from the version history.

## Next-tasks queue
Backlog = stock; queue = what you do now.
- Sections: dated items (overdue or next 7 days), now (**max 5**), next.
- Refill when empty or weekly: read the queue, the goals' priority order, only the index block of each backlog (never whole READMEs), then propose candidates (slots + a few spare), each with why-now and blockers.
- Candidates: `horizon: now` and `ready|in-progress`.
- Human approves before the queue is written; items are links to IDs, not copies.
- Never change priority, horizon or status while refilling. Over 5: warn once, then obey.
