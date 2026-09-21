---
name: tech-report-generation
description: "Generate a tech report or team update from git commit history. Use when: someone asks to generate a tech report, weekly tech update, or team notes; summarising what the team shipped in a date range; preparing sprint review talking points; producing a concise 'what did we deliver?' summary; creating the tech team's weekly update for Slack. Trigger phrases: 'create a tech report', 'generate tech report', 'tech report for the last X weeks/months', 'tech report from last X weeks', 'what did we ship', 'weekly team notes', 'sprint summary', 'weeknotes', 'DPSP update', 'weekly update', 'team weekly update', 'business update'. Default output mode is concise unless the user specifies standard, detailed, business, or slack-weekly-update."
argument-hint: "Provide a date range and output format, e.g. 'tech report from last 2 weeks' or 'generate tech report since 2026-05-19, business'."
user-invocable: true
---

# Skill: Tech Report Generation

---

## ⚠️ Mandatory First Step — Always Run the Git Command

**Before writing a single word of output, run the git log command in the terminal.**

Do not use prior conversation context, cached knowledge, or workspace file contents to infer what was shipped. The only valid source of truth is the live git history for the requested date range.

Run the git log command that matches the user's requested range (use `--since` when only a start is given; use `--after/--before` when a start and end are given):

```bash
# Open-ended range (start date only)
git log --since="<start-date>" --no-merges --format="%h | %ad | %an | %s" --date=short

# Bounded range (start and end date)
git log --after="<start-date>" --before="<end-date>" --no-merges --format="%h | %ad | %an | %s" --date=short
```

If the command returns **no output**, the period has no commits. Report that and stop immediately — do not fall back to an earlier period.

---

## ⚠️ No Commits — Hard Stop Rule

If the git command returns no results:

1. Calculate the exact calendar dates for the requested range (e.g. "last 3 weeks" from today's date = `[today minus 21 days]` to `[today]`).
2. Output only this (saved as TECH_UPDATE_[START-DATE]_to_[END-DATE].txt):

```txt
Period: [START DATE] to [END DATE]

No commits were made during this period.
```

3. Stop. Do not append summaries from an earlier period. Do not mention prior work. Do not explain what the project does.

---

## Prerequisites

Most modes require only git access. The **Slack weekly update** mode additionally requires the Atlassian MCP server to be configured, as it queries Jira for in-progress tickets via `mcp_atlassian_mcp_jira_search`.

---

## Overview

Extracts and formats git commit history into structured summaries suitable for sprint reviews, weekly team notes, and stakeholder communications.

Five output modes serve different audiences. Each mode has a dedicated format file that is loaded on demand:

| Mode | Audience | Format | File |
|---|---|---|---|
| **Concise** *(default)* | Quick reference, internal team | Bulleted list of work items | `references/output-concise.md` |
| **Standard** | Weekly notes, team lead | Full-sentence descriptions grouped by type | `references/output-standard.md` |
| **Detailed** | Sprint review, retrospective, audit | Comprehensive change descriptions with context | `references/output-detailed.md` |
| **Business** | DPSP weeknotes, non-technical stakeholders | Outcome-focused, jargon-free bullets | `references/output-business.md` |
| **Slack weekly update** | Tech team weekly update in the DPSP Slack channel | This week / Next week / Blockers in Slack format | `references/output-slack-weekly-update.md` |

> **Default:** Use **concise** mode (load `references/output-concise.md`) unless the user explicitly requests standard, detailed, business, or slack-weekly-update.

---

## When to Use

**Perfect for:**
- Preparing sprint review demo talking points
- Writing weekly team notes
- Generating a changelog for a release
- Reviewing what changed in a date range before writing a test plan
- Onboarding someone to recent changes

**Not suitable for:**
- Reviewing code quality
- Generating test cases from commits
- Publishing reports to Confluence

---

## Input Format

Invoke with a date range and output mode. Examples:

```txt
since 2 weeks ago, concise
since 2026-05-19, standard
since 2026-05-01, detailed for sprint review
last sprint (2026-05-19 to 2026-06-01), standard
since last Monday, concise
```

Optionally narrow by path or branch:

```
since 2 weeks ago, standard — lambdas/ only
since 2026-05-19, detailed — main branch
```

---

## Git Commands

> These commands are provided explicitly for reproducibility. Run them yourself to verify output matches the generated summary.

### List all commits since a date (one-line overview)

```bash
git log --since="2 weeks ago" --no-merges --oneline
git log --since="2026-05-19" --no-merges --oneline
```

### List commits with author, date, and subject

```bash
git log --since="2 weeks ago" --no-merges \
  --format="%h | %ad | %an | %s" --date=short
```

### List commits with full body (for detailed mode)

```bash
git log --since="2 weeks ago" --no-merges \
  --format="commit %h%nDate:    %ad%nAuthor:  %an%nSubject: %s%nBody:%n%b%n---" \
  --date=short
```

### Filter by path (e.g. Lambda code only)

```bash
git log --since="2 weeks ago" --no-merges --oneline -- lambdas/
```

### Filter commits by conventional commit type

```bash
# Features only
git log --since="2 weeks ago" --no-merges --format="%s" | grep "^feat"

# Bug fixes only
git log --since="2 weeks ago" --no-merges --format="%s" | grep "^fix"

# All types — grouped summary
git log --since="2 weeks ago" --no-merges --format="%s" | \
  sed 's/:.*//' | sort | uniq -c | sort -rn
```

### Date range between two specific dates

```bash
git log --after="2026-05-19" --before="2026-06-01" --no-merges --oneline
```

### Supported `--since` date formats

| Input | Example |
|---|---|
| Relative | `"2 weeks ago"`, `"last Monday"`, `"3 days ago"` |
| ISO 8601 | `"2026-05-19"` |
| Descriptive | `"yesterday"`, `"last month"` |

---

## Conventional Commits Format

This project follows [Conventional Commits](https://www.conventionalcommits.org/). Parse commit messages using this table:

| Prefix | Meaning | Typical audience |
|---|---|---|
| `feat:` | New feature or capability | Sprint review, stakeholders |
| `fix:` | Bug fix | Sprint review, QA |
| `refactor:` | Code restructure (no behaviour change) | Team notes |
| `test:` | Test additions or changes | QA, team notes |
| `ci:` | CI/CD pipeline changes | Team notes |
| `build:` | Build system, infrastructure as code | Team notes |
| `docs:` | Documentation updates | Team notes |
| `chore:` | Maintenance, dependency updates | Usually omit from stakeholder summaries |
| `perf:` | Performance improvements | Sprint review |
| `security:` | Security fixes | Always include, flag explicitly |

**Breaking changes** are marked with `!` after the type (e.g. `feat!:`) or with `BREAKING CHANGE:` in the commit body. Always call these out explicitly in any output format.

---

## Output File

Save the report as a plain .txt file named:

    TECH_UPDATE_[START-DATE]_to_[END-DATE].txt

Example: TECH_UPDATE_2026-05-12_to_2026-06-02.txt

Use the actual calendar dates of the requested range, not today's date.

---

## Output Modes

> All output is plain text (.txt). Use no markdown formatting — no # headers, no ** bold, no backticks. Use hyphens for bullet points and plain dashes or equals signs for section dividers.

Five modes are available. Only the relevant format file is loaded — do not load files for modes that were not requested.

When trigger phrases overlap, **Slack weekly update** takes precedence over Standard and Business if the request explicitly mentions Slack, a channel, or a weekly update for the team.

| Mode | When requested | File to read |
|---|---|---|
| **Concise** *(default)* | no mode specified, or "concise" | `references/output-concise.md` |
| **Standard** | "standard", "weekly notes" | `references/output-standard.md` |
| **Detailed** | "detailed", "sprint review", "retrospective" | `references/output-detailed.md` |
| **Business** | "business", "weeknotes", "DPSP", "non-technical" | `references/output-business.md` |
| **Slack weekly update** | "slack", "slack update", "slack weekly update", "team weekly update", "weekly update for slack" | `references/output-slack-weekly-update.md` |

**Before generating any output:**
1. Determine the requested mode (default: concise).
2. Read the corresponding `references/output-*.md` file using the `read_file` tool.
3. Use only the plain-text template shown under the "Format" section in that file, and apply the "Rules" section as constraints.

**Slack weekly update mode — additional step:**
After running the git log command, use the `mcp_atlassian_mcp_jira_search` tool to fetch in-progress tickets:

```
tool: mcp_atlassian_mcp_jira_search
jql: project = <PROJECT_KEY> AND status = "In Progress"
fields: ["summary", "assignee"]
```

Use the ticket summaries (not IDs) to populate the "Next week" bullets. Ask the user for their project key (e.g. `PROJ`) if it is not set in `.github/copilot-instructions.md`.

---

## Handling Edge Cases

**No commits in the date range:**

See the **⚠️ No Commits — Hard Stop Rule** section at the top of this skill. Do not scroll past it.

**Commits not following conventional commits format:**
- Group non-conventional commits under "Other changes"
- Note the inconsistency so the team can improve commit hygiene
- Do not fabricate types — label them as `[untyped]`

**Merge commits:**
- Always use `--no-merges` to exclude them
- Merge commits add noise without adding information to summaries
