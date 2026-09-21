# Output Format: Standard

Use for: weekly team notes, team lead communications, Slack updates.

---

## Format

```txt
Team update -- week of [DATE] to [DATE]
================================================

New Features
------------
The team implemented [description of feat commits, written as full sentences].
[One paragraph per feature or logical group of related commits.]

Bug Fixes
---------
[description of fix commits as full sentences]

Infrastructure & CI
-------------------
[ci/build commits -- focus on what improved and why it matters]

Testing
-------
[test commits -- what coverage was added or improved]

Code Quality
------------
[refactor/docs commits -- keep brief unless significant]
```

---

## Rules

- Write in plain English, not commit message shorthand
- Group related commits into a single paragraph rather than listing each one
- Explain the why where the commit message makes it clear
- Omit chore: dependency updates unless they resolve a security issue
- Flag any BREAKING CHANGE commits prominently

---

## Workflow Tips

- Run on Friday afternoon or Monday morning
- The standard format is designed for pasting directly into a Confluence page or Slack channel
- Exclude chore: dependency bumps from the output — they add noise without value
- For security fixes (fix(security): or security:), always mention them explicitly even if brief
