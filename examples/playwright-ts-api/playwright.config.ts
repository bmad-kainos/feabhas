import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  use: {
    baseURL: process.env.API_BASE_URL ?? 'http://localhost:8000',
    extraHTTPHeaders: { Accept: 'application/json' },
  },
  reporter: [['list'], ['html', { open: 'never' }]],
});
