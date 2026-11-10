# Contributing

Thanks for helping improve spec-plan-ship.

## How to propose changes

1. Open an issue describing the problem or the change you want.
2. Fork the repo and create a branch from `main`.
3. Keep the change small and focused on one topic.
4. Open a pull request that explains the motivation and the result.

## Ground rules

- Keep everything generic and stack-agnostic. No framework-specific assumptions in the method or templates.
- English only, in code, docs, comments and commit messages.
- Never add real client, company or product names, personal data, or secrets (tokens, keys, `.env` contents).
- Use placeholders such as `example-product` or `<project>` in examples.

## Before opening a PR

Run the sensitive-content check and fix anything it reports:

```bash
bash scripts/check-sensitive.sh
```

CI also runs gitleaks and the rule-ID check; both must pass.
