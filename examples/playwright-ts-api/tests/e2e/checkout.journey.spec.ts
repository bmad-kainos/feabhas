import { test, expect } from '@playwright/test';
import { validOrder } from '../fixtures/payloads';

test('create then fetch an order', async ({ request }) => {
  const created = await request.post('/api/v1/orders', { data: validOrder() });
  expect(created.status()).toBe(201);
  const { id } = await created.json();

  const fetched = await request.get(`/api/v1/orders/${id}`);
  expect(fetched.status()).toBe(200);
  expect((await fetched.json()).id).toBe(id);
});
