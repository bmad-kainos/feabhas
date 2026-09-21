import { test, expect } from '@playwright/test';
import { validOrder } from '../fixtures/payloads';

// quantity spec: 1..999
for (const { quantity, expected } of [
  { quantity: 0, expected: 400 },     // below minimum — rejected
  { quantity: 1, expected: 201 },     // lower boundary — accepted
  { quantity: 999, expected: 201 },   // upper boundary — accepted
  { quantity: 1000, expected: 400 },  // above maximum — rejected
]) {
  test(`quantity=${quantity} -> ${expected}`, async ({ request }) => {
    const response = await request.post('/api/v1/orders', {
      data: { ...validOrder(), quantity },
    });
    expect(response.status(), await response.text()).toBe(expected);
  });
}
