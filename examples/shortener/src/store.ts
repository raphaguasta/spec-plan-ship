import { encodeCounter } from "./code.ts";

export type Shortener = {
  shorten(url: string): string;
  resolve(code: string): string | undefined;
};

function isValidUrl(input: string): boolean {
  try {
    const { protocol } = new URL(input);
    return protocol === "http:" || protocol === "https:";
  } catch {
    return false;
  }
}

export function createShortener(): Shortener {
  const byCode = new Map<string, string>();
  const byUrl = new Map<string, string>();
  let counter = 0;

  return {
    shorten(url) {
      if (!isValidUrl(url)) {
        throw new TypeError(`invalid url: ${url}`);
      }
      const existing = byUrl.get(url);
      if (existing !== undefined) return existing;
      counter += 1;
      const code = encodeCounter(counter);
      byCode.set(code, url);
      byUrl.set(url, code);
      return code;
    },
    resolve(code) {
      return byCode.get(code);
    },
  };
}
