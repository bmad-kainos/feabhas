---
name: test-retrospective
description: "Generate a QA retrospective summary from sprint test results, pass/fail data, escaped defects, and flaky test history. Use when: closing a sprint and reflecting on test quality; preparing talking points for a retrospective; reporting QA metrics to a team or stakeholder; identifying patterns in test failures or escaped bugs. Works from pasted data, Jira, or a summary description."
argument-hint: "Provide a sprint name, paste test results, describe what happened in testing this sprint, or provide a Jira sprint key"
---

# Test Retrospective

Generate a structured QA retrospective from sprint test results, escaped defects, and test health data.

---

## When to Use

- Sprint close — summarising testing outcomes before the retro
- QA metrics reporting to a team lead or stakeholder
- Identifying patterns in escaped bugs or flaky tests across sprints
- Any request mentioning "test retro", "QA retrospective", "what broke this sprint", "test metrics", "testing summary"

---

## Procedure

### Step 1 — Gather data

Collect as much of the following as is available. Work with whatever the user provides — do not block on missing data, note it as unavailable instead.

| Data point | Source |
|-----------|--------|
| Sprint name / dates | User input or Jira |
| Stories tested | Jira sprint (`mcp_atlassian_mcp_jira_search` if available) |
| Test pass rate | CI output, test report, or user description |
| Tests added this sprint | Git log or user description |
| Flaky tests | CI history or user description |
| Bugs found in testing | Jira bugs raised during sprint |
| Escaped defects (found in prod) | User description |
| Blocked tickets | Jira or user description |
| Manual vs automated breakdown | User description |

If Jira MCP is available and a sprint name is given, fetch:
```
mcp_atlassian_mcp_jira_search(
    jql="project = <PROJECT_KEY> AND sprint = '<sprint name>' AND issuetype = Bug",
    fields="key,summary,priority,status,created,resolutiondate"
)
```

---

### Step 2 — Calculate metrics

From the gathered data, derive:

- **Test pass rate** = passing tests / total tests run × 100%
- **Defect detection rate** = bugs found in testing / (bugs found in testing + escaped defects)
- **Automation coverage change** = tests added vs removed this sprint (net change)
- **Flaky test count** = number of tests that failed intermittently

---

### Step 3 — Generate the retrospective

Produce the following structure:

```
## QA Sprint Retrospective — <Sprint Name>

**Period:** <start date> → <end date>
**Prepared by:** QA / Test Engineer

---

## 1. Sprint Testing Summary

| Metric | Value |
|--------|-------|
| Stories tested | N |
| Test pass rate | N% |
| Bugs found in testing | N |
| Escaped defects (post-release) | N |
| Defect detection rate | N% |
| Net new automated tests | +N |
| Flaky tests identified | N |
| Manually tested stories | N |
| Automated stories | N |

---

## 2. What Went Well

- <Positive outcome — e.g. "All high-risk stories had integration tests before merging">
- <Positive outcome — e.g. "No escaped defects this sprint">
- <Positive outcome>

---

## 3. What Could Be Improved

- <Issue — e.g. "3 stories entered test with incomplete ACs, causing rework">
- <Issue — e.g. "Flaky auth test blocked CI twice">
- <Issue>

---

## 4. Bugs Found This Sprint

| Ticket | Summary | Severity | Found by | Status |
|--------|---------|----------|----------|--------|
| PROJ-201 | Login fails with special chars in password | High | Automated test | Fixed |
| PROJ-202 | Export CSV truncates long field values | Medium | Manual testing | Open |

---

## 5. Escaped Defects

| Issue | Found where | Severity | Root cause |
|-------|------------|----------|-----------|
| <describe escaped defect or "None this sprint"> | | | |

---

## 6. Flaky Tests

| Test | Failure pattern | Action taken |
|------|----------------|-------------|
| <test name or "None identified"> | | |

---

## 7. Actions for Next Sprint

| Action | Owner | Priority |
|--------|-------|----------|
| Fix flaky auth test | QA | High |
| Add negative tests for export endpoint | QA | Medium |
| Define ACs earlier in refinement for complex stories | Team | Medium |

---

## 8. Trend (if prior retros available)

| Metric | Last Sprint | This Sprint | Trend |
|--------|------------|-------------|-------|
| Test pass rate | N% | N% | ↑ / ↓ / → |
| Escaped defects | N | N | ↑ / ↓ / → |
| Flaky tests | N | N | ↑ / ↓ / → |
| Net new tests | +N | +N | ↑ / ↓ / → |
```

---

### Step 4 — Optional Slack / Teams summary

If the user wants a brief stakeholder-friendly version, produce:

```
**QA Summary — <Sprint Name>**
✅ Pass rate: N%
🐛 Bugs found: N (N fixed, N carried over)
🚨 Escaped defects: N
⚡ Flaky tests: N identified, N resolved
📈 Net new tests added: +N

Top action: <single most important improvement for next sprint>
```

---

## Notes

- If data is missing, note it as "Not available this sprint" rather than guessing
- Trend analysis is only meaningful from the third sprint onward — note this if prior data is absent
- Frame "What Could Be Improved" as process observations, not individual blame
