# Error Handling & Environment Requirements

## Environment Requirements

| Variable | Source | Used by |
|----------|--------|---------|
| `JIRA_URL` | Env / `.env` | Both methods |
| `JIRA_SERVER_TOKEN` | Env | Excel import script (`/rest/api/2/` Bearer auth) |
| `JIRA_TOKEN` | Env (fallback) | Jira MCP and Excel import script |
| `JIRA_USER` | Env | ZAPI method only |
| `JIRA_PASSWORD` | Secret | ZAPI method only — real password, not PAT |

> **Why two auth schemes?** The standard Jira REST API accepts PATs as Bearer tokens.
> The Zephyr ZAPI plugin (Server/DC) predates PAT support and only accepts Basic auth
> with a real password. The Excel import method avoids the ZAPI entirely.

---

## Error Reference

| Error | Likely cause | Fix |
|-------|-------------|-----|
| `issuetype "Test" not found` | Zephyr Essential not enabled on project | Confirm in Jira project settings; use "Test" (capital T) |
| Issue link 404 | Link type name wrong | Call `mcp_jira_get_link_types()` and use the correct name |
| ZAPI 401 `AUTHENTICATED_FAILED` | Using PAT/API token for ZAPI call | Use `JIRA_PASSWORD` (real password) not `JIRA_TOKEN` for ZAPI auth |
| AC not found in description | Description uses different formatting | Parse manually and ask user to confirm ACs before creating |
| Import: rows 2–N all fail | `Name` was blank on step rows | Ensure `Name` is repeated on every row (not just the first) |
| Import: 3+ issues created unexpectedly | `Name` was blank — each blank row became a nameless issue | Delete the created issues; ensure `Name` is populated on every row |
| Import: link not set | Link type value wrong | Use `is a test for` (outward from Test → Story), not `is tested by` |
