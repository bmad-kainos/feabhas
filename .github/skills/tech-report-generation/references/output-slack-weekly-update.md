# Output Format: Slack Weekly Update

Use for: the tech team's weekly update posted in the DPSP Slack channel. Mirrors the format used by other contributors so the update slots in naturally.

---

## Format

```
✅ This week:

- [What shipped — one outcome per bullet, plain English]
- [What shipped — omit if nothing else distinct to add]

⏭ Next week – we plan to:

- [In-progress ticket summary — brief, outcome-focused]
- [In-progress ticket summary]
- [In-progress ticket summary — max 3]

⚡ Any blockers to escalate:
```

---

## Rules

- Maximum 2 bullets under "This week" — derived from git commits
- Maximum 3 bullets under "Next week" — derived from in-progress Jira tickets in the Tech (Build & Test) component
- Omit the ticket ID from the output — it's noise for this audience
- Plain English only: no AWS service names, no CI/CD jargon, no code terms
- Each bullet must be a complete sentence or clear short phrase — not a commit message
- Leave "Any blockers to escalate:" blank if there are none — do not write "None" or "N/A"
- No bold, no markdown — the Slack client handles the emoji formatting automatically

---

## Data Sources

"This week" bullets come from the git log output for the user's requested date range.
"Next week" bullets come from in-progress Jira tickets using this JQL:

```
project = <PROJECT_KEY> AND status = "In Progress"
```

Ask the user for their project key if it is not set in `.github/copilot-instructions.md`.

Prioritise tickets using this order:
1. Tickets where commits were made in the requested date range (cross-reference the git log output)
2. Tickets that are build/delivery focused over review or discovery tasks
3. Oldest in-progress tickets (most likely to be near completion)

Keep to 3 bullets max. If more tickets match, select the best 3 and — separately from the Slack-ready output — tell the user which were omitted and why so they can override the selection if needed.
