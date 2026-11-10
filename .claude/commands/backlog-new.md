---
description: Scaffold a new product backlog with config and folders from backlog/templates
argument-hint: <product>
---

Create the backlog for product: $ARGUMENTS

1. Read `backlog/README.md`, `backlog/config.md` and the files in `backlog/templates/`. Check that `backlog/<product>/` does not already exist; if it does, stop and report.
2. Ask in one batch what you cannot infer: ID prefix, owner, areas, whether severity is used, links to specs and plans. Use `[TBC]` for anything still unknown.
3. Create `backlog/<product>/` with:
   - `config.md` copied from `backlog/config.md` with the product values (`product`, `prefix`, `standard_version`, `owner`, `areas`, `uses_severity`, `backlog_dir`) and an empty deviations section.
   - `initiatives/`, `epics/`, `cards/` (add a `.gitkeep` in each empty folder).
4. Do not create sample cards unless asked. Do not commit.
5. Report the files created and the first free card ID.
