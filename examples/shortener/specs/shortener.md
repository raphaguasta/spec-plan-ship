---
id: spec-shortener
area: SHORT
status: active
updated: 2026-01-16
---

# Shortener

## Purpose
In-memory URL shortener library: maps http(s) URLs to short codes and back.
Code: `src/`
Plans: `plans/shortener-v1.md`

## Requirements
- R-SHORT-01: a valid URL is shortened -> the code is exactly 6 characters from `0-9A-Za-z`.
- R-SHORT-02: codes come from a per-instance counter starting at 1, encoded in base62 and left-padded with `0` -> the same sequence of URLs gives the same codes on every instance.
- R-SHORT-03: `resolve(code)` for a code issued by `shorten` -> returns the original URL.
- R-SHORT-04: `shorten` receives a string that is not a valid http or https URL -> throws `TypeError`.
- R-SHORT-05: `shorten` receives a URL already shortened on the same instance -> returns the existing code and does not advance the counter.
- R-SHORT-06: `resolve(code)` for a code never issued -> returns `undefined`.

## Out of scope
- Persistence across restarts.
- Custom aliases, expiry, click statistics.
- URL normalization (two spellings of one URL get two codes).

## Open questions
- [TBC] Behavior when the counter exceeds 62^6 - 1 (currently throws `RangeError`).
