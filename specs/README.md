# Specs

Specs state what the product must do now. One spec per feature or area.
Code is the source of truth for implementation; specs are the source of truth for behavior.

## Form
- English. Short sentences. No preamble.
- `key: value` over tables. Lists only for parallel items.
- Headings with `#`. No bold.
- Link plans and code by path or URL. Do not copy them.
- Unknown: `[TBC]`. Never guess.

## Content
- Current state only. No history, dates, old names or changelog.
  History goes to git, or to a dated line in `decisions/`.
- Each normative rule has an ID: `R-AREA-NN`.
  - AREA: uppercase letters. NN: two digits. Example: `R-AUTH-01`.
  - Unique across all specs.
- Define each ID once, on a line that starts with `R-AREA-NN:`.
  The line may start with `- `, `| ` or `N. `.
- Other files cite the ID only. They do not repeat the rule text.
- Before adding a rule, search for the area's existing IDs and extend them.
- Each rule is testable: a condition and an observable result.
  Reject vague wording such as "fast", "simple" or "should be easy".
- Keep out of specs: secrets, environment values, production identifiers, customer data.
- Schema details (columns, types, indexes) come from generated output or code.
  Specs keep only the rules about them (visibility, invariants), with IDs.

## Files
- `<area>.md`: one spec per area. Kebab-case names.
- `_template.md`: copy it for a new spec. Files starting with `_` and `README.md` are skipped by the checks.

## Before commit
- `bash scripts/check-rule-ids.sh` must print `ok`.
- `bash scripts/check-sensitive.sh` must print `ok`.
