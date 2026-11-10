import { test } from "node:test";
import assert from "node:assert/strict";
import { createShortener, encodeCounter, CODE_LENGTH } from "../src/index.ts";

test("R-SHORT-01: code is 6 base62 characters", () => {
  const code = createShortener().shorten("https://example.com/a");
  assert.equal(code.length, CODE_LENGTH);
  assert.match(code, /^[0-9A-Za-z]{6}$/);
});

test("R-SHORT-02: codes are deterministic from the counter", () => {
  assert.equal(encodeCounter(1), "000001");
  assert.equal(encodeCounter(62), "000010");
  const a = createShortener();
  const b = createShortener();
  const urls = ["https://example.com/1", "https://example.com/2"];
  assert.deepEqual(urls.map((u) => a.shorten(u)), urls.map((u) => b.shorten(u)));
  assert.equal(a.shorten(urls[0]), "000001");
  assert.equal(a.shorten(urls[1]), "000002");
});

test("R-SHORT-03: resolve returns the original URL", () => {
  const s = createShortener();
  const url = "https://example.com/path?q=1";
  assert.equal(s.resolve(s.shorten(url)), url);
});

test("R-SHORT-04: invalid URL is rejected", () => {
  const s = createShortener();
  for (const bad of ["", "not a url", "ftp://example.com", "javascript:alert(1)"]) {
    assert.throws(() => s.shorten(bad), TypeError);
  }
});

test("R-SHORT-05: same URL returns the same code", () => {
  const s = createShortener();
  const first = s.shorten("https://example.com/x");
  s.shorten("https://example.com/y");
  assert.equal(s.shorten("https://example.com/x"), first);
});

test("R-SHORT-06: unknown code resolves to undefined", () => {
  assert.equal(createShortener().resolve("zzzzzz"), undefined);
});
