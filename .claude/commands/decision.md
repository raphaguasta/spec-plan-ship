---
description: Record a decision with discarded alternatives and a review date
argument-hint: <topic>
---

Record a decision about: $ARGUMENTS

1. Read `decisions/_template.md`. Search `decisions/` for an existing record on the same topic; if one exists, propose superseding it instead of duplicating.
2. Create `decisions/YYYY-MM-DD-<slug>.md` (today's date, kebab-case ASCII slug) from the template.
3. Fill in context, the decision, consequences and a `review_on:` date with the trigger for an earlier review. List at least one discarded alternative with the reason it was not chosen.
4. Use only what the owner said or the repo states. Anything unknown is `[TBC]`. Keep it short. Set `status: proposed` unless the owner confirmed it, then `active`.
5. Do not commit. Report the path.
