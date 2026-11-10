const ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
export const CODE_LENGTH = 6;

/** Max counter value that fits in CODE_LENGTH base62 digits. */
export const MAX_COUNTER = ALPHABET.length ** CODE_LENGTH - 1;

/** Encode a counter as a fixed-length base62 code, left-padded with "0". */
export function encodeCounter(counter: number): string {
  if (!Number.isInteger(counter) || counter < 0 || counter > MAX_COUNTER) {
    throw new RangeError(`counter out of range: ${counter}`);
  }
  let n = counter;
  let out = "";
  while (n > 0) {
    out = ALPHABET[n % ALPHABET.length] + out;
    n = Math.floor(n / ALPHABET.length);
  }
  return out.padStart(CODE_LENGTH, ALPHABET[0]);
}
