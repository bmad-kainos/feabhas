# Framework best-practice instructions

Per-stack coding standards for test automation, organised as
`frameworks/<tool>/<language>.instructions.md`. VS Code discovers `.github/instructions/`
**recursively**, so these nested files load automatically.

Each file carries an `applyTo` glob and only activates for its own file types — a pytest repo
never triggers the Playwright rules, and vice versa. Where two tools share an extension (for
example Jest and Playwright both use `*.spec.ts`), run the **Configure** agent to prune the
stacks you don't use, so only your conventions apply.

## Available stacks

- `playwright/` — typescript, javascript, python
- `pytest/` — python
- `cypress/` — typescript
- `selenium/` — java
- `cucumber/` — java
- `jest/` — typescript

Language-level standards live in [../languages/](../languages/).

## Add a stack

Copy [`_TEMPLATE.md`](./_TEMPLATE.md) to `<tool>/<language>.instructions.md`, set the `applyTo`
glob to that stack's test files, and fill in the sections. (The template is a plain `.md` so it
is not loaded as an active instruction.) Or ask Copilot to generate it.
