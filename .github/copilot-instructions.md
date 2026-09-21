# Copilot Instructions — Feabhas Project Configuration

> **How to use this file:**
> This file configures the **Feabhas** pack for your project. Fill in the sections below with
> your project's specifics — or run the **Configure** agent (from the chat agent dropdown) to fill it in interactively.
> Copilot uses these instructions to tailor its suggestions across all agents and skills in the pack.

---

## Project

- **Project name:** <!-- e.g. My API Service -->
- **Jira project key:** <!-- the prefix on issue IDs, e.g. PROJ in PROJ-1234 — NOT a token/PAT or the base URL. Used by jira-testing-analysis, confluence-test-plan, create-zephyr-tests -->
- **Repository:** <!-- e.g. github.com/my-org/my-repo -->

---

## Stack

- **Primary language:** <!-- e.g. Python 3.11 / TypeScript 5 / Java 17 -->
- **Test framework:** <!-- Playwright + TypeScript | Playwright + JavaScript | pytest + Python | other. First-class support: Playwright + TypeScript and pytest + Python. The api-tests and openapi-to-tests skills read this to pick the right conventions. -->
- **API style:** <!-- e.g. REST / GraphQL / gRPC -->
- **Auth mechanism:** <!-- e.g. Bearer token / API key / OAuth2 / mTLS / None -->
- **CI/CD:** <!-- e.g. GitHub Actions / Jenkins / GitLab CI -->

---

## Project Layout

- **Source root:** <!-- e.g. src/ / app/ / lib/ -->
- **Test root:** <!-- e.g. tests/ / __tests__/ / spec/ -->
- **Docs root:** <!-- e.g. docs/wiki / docs / wiki -->
- **Install command:** <!-- e.g. npm install / pip install -r requirements.txt / poetry install -->
- **Validate command:** <!-- e.g. npm run validate / poetry run pytest / ./gradlew test -->
- **Lint command:** <!-- e.g. npm run lint / flake8 src/ -->

---

## Testing Conventions

- **Test naming pattern:** <!-- e.g. test_<what>_<expected_outcome> / should_<outcome>_when_<condition> -->
- **Fixture location:** <!-- e.g. tests/conftest.py -->
- **Test data location:** <!-- e.g. tests/data/ -->
- **Jira marker on tests:** <!-- e.g. @pytest.mark.jira('<TICKET_KEY>') — set to "none" if not used -->
- **Test levels in use:** <!-- tick all that apply: Unit / Integration / E2E / Manual -->

---

## Code Style Preferences

- **Style guide:** <!-- e.g. PEP8 / Airbnb / Google / none -->
- **Max line length:** <!-- e.g. 120 -->
- **Imports:** <!-- e.g. absolute only / relative allowed -->
- **Async style:** <!-- e.g. async/await / callbacks / none -->
- **Key principle:** <!-- e.g. functional preferred / OOP / SOLID -->

---

## Integrations

- **Jira:** <!-- Yes / No — if Yes, the Atlassian MCP server must be running -->
- **Jira base URL:** <!-- e.g. https://your-org.atlassian.net — used by create-zephyr-tests (ZAPI method) -->
- **Confluence:** <!-- Yes / No -->
- **Zephyr:** <!-- Yes / No — for the create-zephyr-tests skill -->

---

## Do Not

<!-- Add any hard rules Copilot should always follow in this project. Examples: -->
- Never disable or skip tests to make them pass
- Do not commit directly to `main`
- Do not hardcode secrets or credentials in test files
<!-- Add your own rules here -->
