# Backlog standard

One standard for every product's backlog. Each product follows it.
Product-only differences go in that product's `config.md`.

## Layout
```
backlog/
├── README.md          # this standard
├── config.md          # example product config (copy per product)
├── templates/         # initiative, epic, story, task
└── <product>/         # one folder per product
    ├── config.md      # prefix, areas, statuses, links to specs and plans
    ├── initiatives/   # <PREFIX>-NNN-slug.md
    ├── epics/
    └── cards/         # stories and tasks
```

## Hierarchy
`initiative -> epic -> story | task`
- Initiative: a business objective made of several epics. Optional.
- Epic: a deliverable made of several stories or tasks. Optional. Use it when more than about three items move together.
- Story: user value. "As <who>, I want <what>, so that <why>". Has acceptance criteria.
- Task: technical work with no user story: debt, infra, tests, cleanup, bug fix.
- Subtask: a `- [ ]` checklist line inside a story or task. If it grows, promote it to a task.

Parent rules:
- Initiative has no parent.
- Epic has an initiative or no parent.
- Story and task have an epic, an initiative, or no parent.
- Story and task are never parents.

## IDs
- Format: `<PREFIX>-NNN`. Prefixes: `INI` (initiative), `EPC` (epic), `STY` (story), `TSK` (task).
- One sequence per product across all types. The type lives in frontmatter.
- File name: `<ID>-<slug>.md`. Slug: title in kebab-case, ASCII, at most 60 characters.
- Take the next free number before creating an item. Do not reuse numbers.

## Content
Every card must be understandable without opening the code.
- Story: story sentence, problem today, why it matters, expected result, acceptance criteria, subtasks, out of scope, open questions, references.
- Task: summary, problem today, why it matters, expected result, acceptance criteria, subtasks, out of scope, open questions, references.
- Acceptance criteria: one line each, testable. Happy path first, then empty state, permission, failure, rollback.
- Unknowns: `[TBC]`.
- References: links, never bare file names.

## Status
`todo -> doing -> done`, or `blocked` at any point. Discarding a card needs a reason written in it; never delete a card.
- `todo`: not started.
- `doing`: work started.
- `blocked`: cannot proceed. Name the blocker in the card.
- `done`: acceptance criteria met.

Parent status follows its children:
- `doing` when any child is `doing` or `done`, and not all children are `done`.
- `done` when all children are `done`.

## Ownership
- Owner: sets priority, horizon (`now | quarter | later | undefined`), and moves cards from `todo` to `doing`.
- Assistant (human or AI): drafts and refines cards, lists open questions, keeps generated lists current.
  Does not set priority or estimate effort.
- Severity, if the product uses it, is technical risk. It is not priority.

## Rigor
`rigor` on each story or task is a suggestion for how much process the work needs:
- `light`: fix directly, test.
- `standard`: short spec or plan before coding.
- `full`: spec, two or three alternatives with trade-offs, and an explicit decision record.

## Frontmatter
All types: `id`, `title`, `type`, `parent`, `status`, `priority`, `horizon`, `origin`, `created`.
Stories and tasks also: `category`, `area`, `rigor`, `depends_on`, `plan`.
- `origin`: `human` (the owner wrote it), `ai` (proposed, not confirmed), `ai-reviewed` (AI wrote it from an owner decision).
- Relation fields hold IDs, for example `parent: EPC-001`.

## Changing this standard
Edit this file and the templates in one change. Record the reason in `decisions/`.
Product configs that conflict with a new rule must list the difference under their own deviations.
