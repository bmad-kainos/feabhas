---
name: TypeScript language standards
description: Language-level conventions for TypeScript files.
applyTo: "**/*.ts,**/*.tsx"
---

# TypeScript — language standards

- Run in `strict` mode. Treat type errors as build failures.
- Avoid `any`; prefer `unknown` and narrow, or a precise type. Reason: `any` disables checking and hides bugs.
- Give exported functions explicit parameter and return types; let inference handle locals.
- Model data with `interface`/`type` and discriminated unions rather than loose objects.
- Avoid the non-null assertion `!` — narrow or guard instead.
- Prefer `const`, `readonly`, and immutable updates.
- Never `// @ts-ignore`; if unavoidable, use `// @ts-expect-error` with a short reason.
