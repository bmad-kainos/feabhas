---
name: Setup
description: Use when preparing the local branch and dependencies for ticket implementation.
argument-hint: '[TICKET_ID][TICKET_CONTEXT]'
tools: [execute/getTerminalOutput, execute/killTerminal, execute/sendToTerminal, execute/runTask, execute/createAndRunTask, execute/runTests, execute/testFailure, execute/runNotebookCell, execute/runInTerminal, read/terminalSelection, read/terminalLastCommand, read/getTaskOutput, read/getNotebookSummary, read/problems, read/readFile, read/viewImage, read/readNotebookCellOutput]
agents: []
user-invocable: true
---

Prepare the workspace for development.

Check the current branch first. If it already matches the task, keep it. Otherwise pull the latest default branch (usually `main`) and create a feature branch following any branch naming conventions documented in the project (look for a `CONTRIBUTING.md`, `.github/` docs, or similar). If no convention is documented, use `feat/<short-description>` by default.

Install dependencies using the project's standard install command (e.g. `npm install`, `pip install -r requirements.txt`, `poetry install`). If no install command is obvious, ask the user before running anything. Report the branch name and any setup issues.
