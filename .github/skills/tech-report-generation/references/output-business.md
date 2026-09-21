# Output Format: Business

Use for: DPSP weeknotes, stakeholder updates, non-technical audiences.

---

## Format

```txt
Period: [DATE] to [DATE]

- [Outcome — what improved or what is now possible, in plain English]
- [Outcome — what improved or what is now possible, in plain English]
- [Outcome — optional, only if a genuinely separate workstream exists]
```

---

## Rules

- Maximum 3 bullets — if everything fits in 2, use 2
- Focus on outcomes and benefits, not what was technically done
- No technical jargon: avoid CI/CD, Lambda, KMS, CDK, AWS service names, commit types
- Each bullet must answer: "So what? Why does this matter?"
  - Bad: "Added CI coverage for Lambda unit tests"
  - Bad: "Improved developer workflow and project guidance" (too generic)
  - Good: "Tests now run automatically on every code change, catching issues earlier"
- Be specific enough to be meaningful — name the capability or risk addressed, not just the area
- Do not group unrelated work into a single vague bullet to stay within the limit;
  if two distinct outcomes matter, use two bullets
- Omit pure housekeeping with no user or operational impact

---

## Language guidance

Translate technical work into plain outcomes using this table:

| Technical commit type | Business framing |
|---|---|
| CI/CD workflow added | Tests/checks now run automatically on every change |
| Security controls (KMS, WAF, IAM) | Strengthened security controls for our cloud environments |
| Infrastructure refactoring | Improved reliability/maintainability of our platform |
| Developer tooling / onboarding | Faster, more consistent setup for the team |
| Bug fix | Resolved an issue that caused [describe impact] |
| New feature / endpoint | [Capability] is now available / users can now [do X] |
| Documentation / skills | Improved guidance and knowledge sharing for the team |
| Dependency updates | Kept platform dependencies up to date and secure |

Use this table as a starting point — always tailor the language to the specific work done.
