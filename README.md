# Feabhas — a QA & Engineering Copilot Pack

A drop-in pack of GitHub Copilot **agents** and **skills** for test engineers, test managers,
and software engineers. Add it to any repository to get Copilot helping with test design,
Jira / Zephyr / Confluence workflows, documentation, planning, and delivery — tailored to your
project through a single config file.

> **Feabhas** (Irish for excellence) — this pack is opinionated about test quality and engineering discipline.

---

## What's inside

```text
.github/
├── copilot-instructions.md   → one config file that tailors every agent + skill to your project
├── agents/                   → custom agents (configure, plan, explore, implement, docs, setup)
├── skills/                   → agent skills (test design, Jira/Confluence/Zephyr, PRs, reports, coverage)
└── instructions/             → framework + language best-practice rules (auto-apply by file type)
examples/                     → worked example test suites (Playwright + TypeScript, pytest + Python)
feabhas                       → CLI front-end: feabhas install | verify | uninstall | help
install.sh / uninstall.sh     → copy the pack into a repo (re-run install to update) / remove it
```

Everything lives under `.github/` so VS Code Copilot discovers it automatically. Skills follow
the [Agent Skills open standard](https://agentskills.io/) and work in VS Code, the Copilot CLI,
and the Copilot coding agent.

---

## Prerequisites

| Requirement                 | Notes                                                |
| --------------------------- | ---------------------------------------------------- |
| VS Code with GitHub Copilot | Agent mode and skills require a Copilot subscription |
| An Atlassian MCP server     | Only for the Jira / Confluence / Zephyr skills       |

Skills that need **no** MCP: `api-tests`, `openapi-to-tests`, `analyse-docs`, `create-pr`, `test-coverage-gap`.

---

## Install

### Option A — start a new repo (recommended)

Use this repository as a GitHub **template** (the green **Use this template** button), then open
your new repo in VS Code.

### Option B — add to an existing repo

From a clone of this repo:

```bash
./install.sh /path/to/your-repo
# preview first:  ./install.sh --dry-run /path/to/your-repo
```

This copies `.github/agents/`, `.github/skills/`, `.github/instructions/`, and
`.github/copilot-instructions.md` into your repo. It won't overwrite an existing
`copilot-instructions.md` unless you pass `--force`.

**Re-running `install` acts as an update.** Run it again after pulling a newer version of the
pack and it refreshes `agents/`, `skills/`, and `instructions/` in place, keeping your configured
`copilot-instructions.md` untouched (pass `--force` to overwrite that too).

### The `feabhas` command

The `.sh` scripts also have a small front-end, `feabhas`, with subcommands (no npm, no build step —
it's a plain shell script):

```bash
./feabhas install   /path/to/your-repo   # copy the pack in — re-run any time to update
./feabhas verify    /path/to/your-repo   # check an install; warns if not yet configured
./feabhas uninstall /path/to/your-repo   # remove the pack (keeps a customized config)
./feabhas help
```

Flags pass straight through — e.g. `./feabhas install --dry-run ...`, `./feabhas install --force ...`,
or `./feabhas uninstall --force ...`.

`uninstall` deletes the `agents/`, `skills/`, and `instructions/` it added and removes `.github/`
if nothing else is left there. It **keeps your `copilot-instructions.md` if you've customized it**
(pass `--force` to remove that too).

**Optional — put `feabhas` on your PATH** (no sudo):

```bash
# run from the feabhas repo root
mkdir -p ~/.local/bin
ln -s "$(pwd)/feabhas" ~/.local/bin/feabhas
```

Then run `feabhas install /path/to/your-repo` from anywhere. If `~/.local/bin` isn't on your
`PATH`, add `export PATH="$HOME/.local/bin:$PATH"` to your shell rc; undo with `rm ~/.local/bin/feabhas`.

### Then — configure for your project

Open your repo in VS Code and run the **Configure** agent from the chat agent dropdown. It
inspects your repo, interviews you, and fills in
[`.github/copilot-instructions.md`](.github/copilot-instructions.md) — project key, test
framework, paths, commands, and conventions. You can also edit that file by hand.

For the Jira / Confluence / Zephyr skills, configure an [Atlassian MCP server](https://github.com/sooperset/mcp-atlassian).

---

## Agents

Select an agent from the chat agent dropdown.

| Agent            | What it does                                                            |
| ---------------- | ----------------------------------------------------------------------- |
| `Configure`    | Interviews you and fills in`copilot-instructions.md` for your project |
| `Explorer`     | Finds the files, symbols, and flows relevant to a task                  |
| `Researcher`   | Interviews you to clarify requirements and design decisions             |
| `Planner`      | Produces a step-by-step implementation plan                             |
| `Implementor`  | Implements an approved plan, with validation                            |
| `Setup`        | Prepares a feature branch and installs dependencies                     |
| `Docs-Updater` | Updates project documentation from code changes                         |

---

## Skills

Invoke a skill with `/<name>` in chat, or just describe what you need and Copilot loads the
right one automatically.

| Skill                              | What it does                                                             | Needs MCP? |
| ---------------------------------- | ------------------------------------------------------------------------ | :--------: |
| `api-tests`                      | Scaffold unit / integration / e2e tests for a REST API in your framework |     No     |
| `openapi-to-tests`               | Generate a black-box test suite from an OpenAPI / Swagger spec           |     No     |
| `test-coverage-gap`              | Identify untested paths and missing test levels                          |     No     |
| `analyse-docs`                   | Answer questions from your project documentation                         |     No     |
| `create-pr`                      | Draft a structured GitHub pull request                                   |     No     |
| `bug-report`                     | Produce a structured bug report from a failure or description            |  Optional  |
| `risk-based-test-prioritisation` | Rank tickets / tests by risk                                             |  Optional  |
| `test-retrospective`             | Generate a QA retro summary from sprint results                          |  Optional  |
| `tech-report-generation`         | Generate a team update from git history                                  |  Optional  |
| `jira-testing-analysis`          | Assess Jira tickets for QA readiness during refinement                   |    Yes    |
| `confluence-test-plan`           | Generate and publish a sprint test plan to Confluence                    |    Yes    |
| `create-zephyr-tests`            | Create Zephyr Test issues in Jira from a story's ACs                     |    Yes    |

### Test framework support

`api-tests` and `openapi-to-tests` read your **Test framework** from `copilot-instructions.md`
and generate code to match. First-class support:

- **Playwright + TypeScript** (or JavaScript)
- **pytest + Python**

For any other framework the skills ask, then follow the closest bundled conventions. Add a
framework by dropping a `references/<framework>.md` file into the `api-tests` skill and adding a
routing line to its `SKILL.md`.

---

## Framework best practices

[.github/instructions/](.github/instructions/) holds per-stack coding standards that **auto-apply by file type** via each file's `applyTo` glob — so Copilot writes idiomatic tests (Playwright role locators and no hard waits, pytest fixtures and parametrisation, Cucumber declarative Gherkin, and so on) whenever you edit matching files.

Organised as `instructions/frameworks/<tool>/<language>.instructions.md`:

| Tool          | Languages                      |
| ------------- | ------------------------------ |
| Playwright    | TypeScript, JavaScript, Python |
| pytest        | Python                         |
| Cypress       | TypeScript                     |
| Selenium      | Java                           |
| Cucumber      | Java                           |
| Jest / Vitest | TypeScript                     |

Plus language-level rules in `instructions/languages/` (TypeScript, Python). Run the **Configure** agent to prune the stacks you don't use, and add a stack by copying [`_TEMPLATE.md`](.github/instructions/frameworks/_TEMPLATE.md).

---

## Examples

[`examples/`](examples/) has small, generic worked test suites for the same Orders API in both
first-class frameworks — [Playwright + TypeScript](examples/playwright-ts-api/) and
[pytest + Python](examples/pytest-api/). They mirror the conventions the `api-tests` skill produces.

---

## Configuration

[`.github/copilot-instructions.md`](.github/copilot-instructions.md) is the single source of
truth: project key, tech stack, test framework, paths, commands, and conventions. Every agent
and skill reads it. Fill it in with the **Configure** agent or by hand — there are no hardcoded
project specifics anywhere else in the pack.

---

## Extending the pack

- **Skill** → create `.github/skills/<name>/SKILL.md` with a `name` (matching the folder) and a
  `description`. Bundle any scripts or references alongside it.
- **Agent** → create `.github/agents/<name>.agent.md` with frontmatter (`name`, `description`, `tools`).

Keep everything generic — no hardcoded project names, keys, or URLs. Put anything
project-specific in `copilot-instructions.md`.

---

## License

MIT — see [LICENSE](LICENSE).
