# Method B: ZAPI Script

## Step 1: Fetch the story

Use the Jira MCP search tool to fetch the story:

```
mcp_jira_search(jql="key = PROJ-XXXX", fields="key,summary,description,status,issuetype")
```

From the response, extract:
- **Story key** (e.g. `PROJ-123`)
- **Story summary** (used in the Test issue summary)
- **Acceptance Criteria** - lines matching `AC0\d:` pattern in the description
- **Testing Notes** - lines under a `*Testing Notes*` heading
- **Out of Scope** - lines under `*Out of Scope*` heading (do NOT create steps for these)

---

## Step 2: Create one Test issue for the story

Create a single `Test` issue using the Jira MCP:

```
mcp_jira_create_issue(
    project_key="<PROJECT_KEY>",
    summary="Tests: <story summary>",
    issue_type="Test",
    description="<brief description: story key, AC count, test approach>"
)
```

**Summary format:** `Tests: PROJ-123 - <story summary>`

**Description** - a structured table summarising all ACs and testing notes. Verification steps are entered separately via the ZAPI in Step 3; this table is a human-readable at-a-glance reference on the issue itself.

Use Jira wiki markup:

```
*Story:* [PROJ-123|<jira-base-url>/browse/PROJ-123]
*Story Summary:* <story summary>
*Sprint:* Sprint 9
*Test Approach:* Manual - GitHub Actions / PR inspection
*Test Type:* Functional

*Preconditions:*
- <list any environment or setup requirements before the test can be run>
- Sprint N Zephyr test cycle created

*Acceptance Criteria and Testing Notes Coverage:*

|| AC Ref || Step Description || Test Data / Preconditions || Expected Result || Attachment Required ||
| AC01 | <what the tester does for this AC> | <input values, URLs, config, or "None"> | <observable outcome confirming the AC is met> | Yes - <describe evidence> / No |
| AC02 | <what the tester does for this AC> | <input values, URLs, config, or "None"> | <observable outcome confirming the AC is met> | Yes - <describe evidence> / No |
| TN01 | <what the tester does for this testing note> | <input values or "None"> | <expected outcome> | Yes - <describe evidence> / No |

*Out of Scope:*
- <items from the story's Out of Scope section, or "None">
```

**Table column guidance:**
- **AC Ref** - AC01, AC02, ..., TN01, TN02 for Testing Notes
- **Step Description** - plain-English description of the action the tester takes
- **Test Data / Preconditions** - URLs, file paths, payload values, or environment state needed. Write "None" if not applicable
- **Expected Result** - the specific, observable outcome that confirms the AC is satisfied
- **Attachment Required** - `Yes - <what to capture>` (e.g. screenshot, curl output, console log) or `No`

Record the returned **issue key** (e.g. `PROJ-456`) and **numeric issue ID** (e.g. `1921300`). Both are needed in subsequent steps.

---

## Step 3: Add structured test steps via the Zephyr ZAPI

Post each AC as a numbered step to the Zephyr test steps endpoint. This populates the **Step / Test Data / Expected Result** table in the Zephyr Test Details panel.

The endpoint is: `POST /rest/zapi/latest/teststep/{issueId}`

> **`issueId`** is the numeric issue ID from Step 2, not the key.

> **Auth note:** The Zephyr ZAPI only accepts HTTP Basic auth with `username:password`. It does not accept Personal Access Tokens (PATs) or Bearer tokens. PATs work for `/rest/api/2/` but are rejected by the ZAPI with `401 AUTHENTICATED_FAILED`. This is a Zephyr Server limitation. Use `JIRA_PASSWORD` (your actual Jira password) for ZAPI calls, keeping `JIRA_TOKEN` (PAT) for the MCP.

```python
import os, httpx

JIRA_URL = os.environ["JIRA_URL"]  # your Jira base URL, e.g. https://your-org.atlassian.net
ZAPI_AUTH = (os.environ["JIRA_USER"], os.environ["JIRA_PASSWORD"])

def add_test_steps(issue_id: str, steps: list[dict]) -> None:
    """
    Post structured test steps to a Zephyr Test issue.

    Each step dict must have:
      - "step":   the action to perform (what the tester does)
      - "data":   test data or preconditions (empty string "" if none)
      - "result": the expected outcome for this specific step
    """
    for i, step in enumerate(steps, start=1):
        response = httpx.post(
            f"{JIRA_URL}/rest/zapi/latest/teststep/{issue_id}",
            json={
                "step": step["step"],
                "data": step.get("data", ""),
                "result": step["result"],
            },
            auth=ZAPI_AUTH,
        )
        if response.status_code in (200, 201):
            print(f"  ✓ Step {i} added")
        else:
            print(f"  ✗ Step {i} FAILED - {response.status_code}: {response.text}")
```

**Step authoring rules:**
- One step per AC - label each step clearly with the AC reference (e.g. `AC01:`)
- Add Testing Notes as additional steps after the ACs, labelled `TN01:`, `TN02:` etc.
- `data` holds preconditions, URLs, or input values the tester needs
- `result` is the expected outcome for that specific step
- The final step's `result` should be the overall pass condition for the test

**Example steps for PROJ-123:**
```python
add_test_steps("1921300", [
    {
        "step": "AC01: <describe the action the tester takes for this AC>",
        "data": "<input values, URLs, config, or empty string if none>",
        "result": "<observable outcome that confirms the AC is met. Screenshot attached if required.>",
    },
    {
        "step": "AC02: <describe the action the tester takes for this AC>",
        "data": "<input values or empty string>",
        "result": "<expected outcome>",
    },
    {
        "step": "TN01: <describe the action for this testing note>",
        "data": "<any specific setup or input>",
        "result": "<expected outcome>",
    },
])
        "result": "All three linters (markdownlint, ruff, biome) are present in the command and run. Biome reports files checked.",
    },
    {
        "step": "TN01: Check the workflow trigger configuration and confirm the workflow ran on PR open and re-ran on a subsequent push.",
        "data": "on: pull_request events: [opened, edited, synchronize, reopened]",
        "result": "Two distinct Actions runs confirm the opened and synchronize events fired automatically.",
    },
])
```

---

## Step 4: Link the Test issue to the parent Story

Use the Jira MCP to create an "is tested by" link:

```
mcp_jira_create_issue_link(
    link_type="Tests",
    inward_issue_key="PROJ-456",   # Test issue
    outward_issue_key="PROJ-123"   # Story
)
```

If `"Tests"` returns an error, call `mcp_jira_get_link_types()` first to find the correct link type name.

---

## Step 5: Post a testing progress comment on the Story

Post a comment on the Story using the Jira MCP. The comment format has two states:

**State A - Initial (tests created, not yet executed):**

```
*Test case created for this story (Sprint N):*

|| Test Key || Summary || ACs Covered || Status ||
| [PROJ-XXXX|<url>] | Tests: <story summary> | AC01, AC02, AC03, AC04 | ⬜ Unexecuted |

Test linked to this story via the "Tests" ("is tested by") issue link.
Test added to Sprint N cycle in Zephyr.

_Generated by the create-zephyr-tests skill, {date}_
```

**State B - After execution (update the comment once tests are run):**

Use `mcp_jira_edit_comment` to update the existing comment. Replace the status column and add an Evidence section and Outstanding checklist:

```
*Test case created and executed for this story (Sprint N):*

|| Test Key || Summary || ACs Covered || Status ||
| [PROJ-XXXX|<url>] | Tests: <story summary> | AC01, AC02, AC03, AC04 | ✅ Pass |

Test passed in Sprint N cycle. Linked to story via the "Tests" ("is tested by") issue link.

*Evidence:*
- AC01: <brief description of evidence, e.g. screenshot attached to test issue>
- AC02: <Actions run URL> - <what it showed>

*Outstanding before story can be closed:*
# <any remaining items, e.g. PR merged to main>

_Updated by the create-zephyr-tests skill, {date}_
```

> If any ACs need a screenshot as evidence, note `(screenshot attached to test issue)` in the Evidence section and remind the user to attach it directly to the Zephyr Test issue before marking it as passed.

---

## Step 6: Output pytest marker stub (optional)

If the story will have automated pytest tests, output the marker to add once the test is written:

```python
# Add this marker to your pytest test class or method:

@pytest.mark.jira("PROJ-123")       # Story
@pytest.mark.zephyr("PROJ-456")     # Test issue key
class TestExampleStory:
    def test_ac01_...(self): ...
    def test_ac02_...(self): ...
```

This output is informational only. Use the `api-tests` skill to scaffold the actual test file.
