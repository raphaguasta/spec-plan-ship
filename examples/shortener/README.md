# Shortener example

A tiny in-memory URL shortener (Node + TypeScript, zero dependencies), built end to end with this kit. It exists to show the trail, not to be a product.

## The trail, in reading order
1. `backlog/epic-link-shortening.md`, `backlog/story-shorten-url.md`: what and why.
2. `specs/shortener.md`: requirements `R-SHORT-01` to `R-SHORT-06`.
3. `plans/shortener-v1.md`: four steps with `depends:`, `files:`, `model:`, `check:`, gates and the production question.
4. `src/`, `test/shortener.test.ts`: the code; each test name carries its R-ID.
5. `decisions/2026-01-15-in-memory-store.md`: why a `Map` and not a file or database.

## Run
Needs Node 22.6+ (type stripping; Node 24 recommended).

```bash
npm test
bash ../../scripts/check-rule-ids.sh specs
```
