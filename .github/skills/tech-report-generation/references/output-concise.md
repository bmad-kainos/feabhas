# Output Format: Concise

Use for: standups, quick team reference, "what did we ship?" glance.

---

## Format

```txt
Period: [DATE] to [DATE]

- [Theme 1 — group all related commits into one sentence]
- [Theme 2 — group all related commits into one sentence]
- [Theme 3 — optional, only if a genuinely separate workstream exists]
```

---

## Rules

- Maximum 3 bullets — if everything fits in 2, use 2
- Each bullet describes a theme or workstream, not an individual commit
- Group related commits together — do not include commit hashes
- Write in plain English — no commit message shorthand
- Include brief implementation detail where it clarifies what changed (e.g. naming specific dependencies removed or patterns replaced), but keep it terse
- Omit noise: chore: bumps, formatting fixes, and minor tidy-ups unless they are the only work
