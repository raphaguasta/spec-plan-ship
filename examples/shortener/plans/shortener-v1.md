---
id: plan-shortener-v1
card: STY-001
status: done
created: 2026-01-12
---

# Plan: Shortener v1

## Goal
A zero-dependency TypeScript library exposing `createShortener()` with `shorten` and `resolve`, covered by one test per requirement in `specs/shortener.md`. Runs with `npm test` on Node 22.6+.

## Out of scope
- Persistence, custom aliases, expiry, statistics.
- Publishing a build step (the library ships as `.ts` source in v1).

## Steps

### S1: Types and code generator
depends: —
files: `src/code.ts`, `package.json`
model: haiku-class
specs: R-SHORT-01, R-SHORT-02
do: Create `package.json` (`"type": "module"`, `test` script `node --test`, no dependencies). In `src/code.ts` export `encodeCounter(counter)`: base62 alphabet `0-9A-Za-z`, left-padded with `0` to 6 characters, `RangeError` outside the valid range.
check: `node -e "import('./src/code.ts').then(m=>{if(m.encodeCounter(1)!=='000001')process.exit(1)})"`

### S2: Store and resolve
depends: S1
files: `src/store.ts`, `src/index.ts`
model: haiku-class
specs: R-SHORT-03, R-SHORT-04, R-SHORT-05, R-SHORT-06
do: In `src/store.ts` export `createShortener()` returning `{ shorten, resolve }` backed by two `Map`s and a counter. `shorten` validates http/https with `new URL`, throws `TypeError` otherwise, and returns the existing code for a known URL. `resolve` returns `undefined` for unknown codes. Re-export from `src/index.ts`.
check: `node -e "import('./src/index.ts').then(m=>{const s=m.createShortener();if(s.resolve(s.shorten('https://example.com'))!=='https://example.com')process.exit(1)})"`

### S3: Tests per requirement
depends: S1, S2
files: `test/shortener.test.ts`
model: sonnet-class
specs: R-SHORT-01, R-SHORT-02, R-SHORT-03, R-SHORT-04, R-SHORT-05, R-SHORT-06
do: Write at least one `node:test` test per requirement. Each test name starts with its R-ID. Include bad inputs for R-SHORT-04 (empty, free text, non-http scheme) and an interleaved sequence for R-SHORT-05.
check: `npm test`

### S4: Docs
depends: S3
files: `README.md`
model: haiku-class
do: Write `README.md`: what the library is, the trail in reading order, how to run `npm test`.
check: `grep -q "npm test" README.md`

## Gates
- `npm test`
- `bash ../../scripts/check-sensitive.sh`
- `bash ../../scripts/check-rule-ids.sh specs`

## Production question
Nothing runs in production. The only external change is publishing the package to a registry, which v1 does not do. Validate: all gates passed and the spec matches the tests. Publish to a registry now? (yes/no) Answer: no, keep it as a source example.

## Rollback
- Revert the merge commit. No external state exists to undo.
