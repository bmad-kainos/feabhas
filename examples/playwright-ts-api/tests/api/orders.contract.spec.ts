import { test, expect } from '@playwright/test';
import { validOrder } from '../fixtures/payloads';

test.describe('POST /api/v1/orders — contract', () => {
  test('valid request returns 201', async ({ request }) => {
    const response = await request.post('/api/v1/orders', { data: validOrder() });
    expect(response.status()).toBe(201);
  });

  test('missing customerId returns 400', async ({ request }) => {
    const { customerId, ...body } = validOrder();
    const response = await request.post('/api/v1/orders', { data: body });
    expect(response.status()).toBe(400);
  });

  test('response has id and status', async ({ request }) => {
    const response = await request.post('/api/v1/orders', { data: validOrder() });
    const body = await response.json();
    expect(body).toMatchObject({ id: expect.any(String), status: expect.any(String) });
  });

  test('unauthenticated request returns 401', async ({ request }) => {
    const response = await request.post('/api/v1/orders', {
      data: validOrder(),
      headers: { Authorization: '' },
    });
    expect(response.status()).toBe(401);
  });
});
