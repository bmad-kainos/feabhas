---
name: create-pr
description: Create draft GitHub pull requests that follow this repository's branching strategy, PR template, and ticket-backed summary rules. Use when the user asks to open a PR for the current or specified branch. Draft the PR title and body from the branch diff and any ticket context provided. Use `gh` CLI for operations.
argument-hint: '[branch name]'
user-invocable: true
---

# Create Draft GitHub Pull Request

Create a draft GitHub pull request for this repository using:

- Use `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/skills/create-pr/assets/pull-request-description-example.md`
- `docs/pull-request-conventions.md` if it exists, otherwise use the PR template as the source of truth for title format and summary rules
- Jira or issue tracker ticket details when the branch name contains a ticket key such as `PROJ-1234`

Use `gh` CLI for pull request operations. Prefer the current repository context and avoid extra git or gh commands when they do not change the outcome.

## When to Use This Skill

- Creating a new pull request for a feature branch
- Opening a draft PR with proper formatting
- Using repository PR templates and examples

## Required workflow

### 1. Resolve the source branch

- If the user provides a branch name, use it.
- Validate only that the provided branch exists locally. If it does not, ask the user to confirm the branch name before continuing.
- Only get the current branch from the local repository, for example with `git branch --show-current`, when the user did not provide one.
- If the result is empty, detached, or already `main`, stop and ask the user for the correct feature branch.

### 2. Resolve the base branch and repository context

- Default the base branch to `main` unless the user explicitly provides a different base branch.
- Prefer using the current repository context for `gh` commands.
- Only inspect the git remote if `gh` cannot infer the repository or the working directory is ambiguous.

### 3. Read the repository pull request conventions

- Look for `docs/pull-request-conventions.md` or `.github/PULL_REQUEST_TEMPLATE.md` as the source of truth for the PR title format and the Summary section rules.
- If a conventions file exists, use it. If not, apply sensible defaults based on the PR template structure.
- The PR title must follow `<type>(<optional-scope>)<!>: <summary> [<ticket-id>]`.
- The `<summary>` part must come from the ticket intent and user-facing outcome, not from a recap of the code diff, and it must appear before the trailing ticket id.
- Derive `<type>` from the branch prefix such as `feat`, `fix`, or `chore`.
- Include a scope only when it is clearly supported by the user request, ticket, or diff.
- Include `!` only when the change is clearly not backward compatible.

### 4. Read the PR template and example

- Use `${workspaceFolder}/.github/PULL_REQUEST_TEMPLATE.md` as the required structure.
- Use [assets/pull-request-description-example.md](assets/pull-request-description-example.md) to match tone, level of detail, and formatting style.
- If the example file cannot be read, stop and fix the path or repository checkout before continuing.

### 5. Fetch the ticket details when applicable

- If the branch name contains a ticket key (e.g. `PROJ-1234`, `ABC-456`), use the Jira MCP tool `mcp_atlassian_mcp_jira_search` to fetch the ticket if the MCP server is available. If the MCP server is not running, ask the user to paste the ticket title and description instead.
- If the branch name does not contain a recognisable ticket key, derive the PR summary from the diff and ask the user to confirm the intent before proceeding.
- Use the ticket title and description as the primary source for the PR title wording and `Summary` section of the description.
- Do not invent requirements or user-facing outcomes that are not supported by the ticket or the diff.

### 6. Analyse the branch changes relative to the base branch

- Compare the source branch with the base branch using remote-tracking refs and a three-dot diff: `git diff origin/<base>...origin/<branch>`.
- Use the remote-tracking three-dot diff specifically to match GitHub pull request comparison semantics for the Files changed view and exclude local uncommitted changes.
- If remote-tracking refs are unavailable, ask the user before falling back to a local branch comparison.
- Start with lightweight analysis such as changed files or `--name-status`.
- Use `git diff --stat origin/<base>...origin/<branch>` or the branch-only commit list `git log --oneline origin/<base>..origin/<branch>` only if they materially improve the List of Changes.
- Use the diff to derive the List of Changes and to validate an optional scope. Do not use the diff as the primary source for the `Summary` section.

### 7. Validate branch prefix suitability

- Extract the branch prefix (`feat`, `fix`, or `chore`) from the branch name.
- Analyse the nature of the changes from the diff to determine the appropriate category:
- **`feat`**: functional business changes that deliver new capabilities or modify existing functionality for end users
- **`fix`**: bug fixes and corrections to existing functionality
- **`chore`**: development tasks not related to specific features, such as skills development, PR checks, documentation tidying up, dependency updates, or repository maintenance
- If the branch prefix does not match the nature of the changes, suggest the more suitable prefix to the user.
- Use the `vscode_askQuestions` tool to prompt the user for confirmation:
- Display the current branch prefix and the suggested prefix
- Ask the user to confirm whether to use the suggested prefix or proceed with the original
- If the user chooses the suggested prefix, use it for the PR title; otherwise, proceed with the original
- Do not proceed until the user confirms the prefix choice.

### 8. Build the PR title and body

- The title must follow the branching strategy format exactly.
- The `summary` portion of the title must start with lowercase
- Use the Jira ticket key from the branch name or fetched ticket details.
- Keep the summary short, user-friendly, and suitable for release notes.
- Fill the PR template exactly.
- Scale the length of `Summary` to the size of the change:
- for small PRs (5 or fewer changed files or fewer than 50 changed lines, excluding changes to files like `package-lock.json`), keep the `Summary` to 2 sentences maximum
- for larger PRs, use up to 4 sentences
- Avoid using the full project title in the summary; use generic terms like "system" or "repository" instead to ensure the summary is clear to the audience.
- If implementation covers only part of the Jira ticket, focus the `Summary` on the user-facing outcome of the implemented part and avoid mentioning unimplemented parts. Do NOT mention that only part of the ticket is implemented as we don't want that in the git log or release notes.
- Avoid unnecessarily bloated preambles, focus on the scope of implementation and business justification - detailed notes on changes are part of `List of Changes`
- Ensure the `Summary` section can be used for git log so do NOT start it with `This pull request` or similar phrasing - instead refer to the user-facing outcome of the change.
- Write the `List of Changes` from the actual diff using short bullets with a **bold** area prefix such as **backend**, **frontend**, **docs**, **automation**, or **copilot**.
- Match the tone and bullet style of the example file.
- If the user asks to omit or reword specific phrasing, apply that change before creation.

### 9. Present the proposed PR title and body to the user in the response

- Show the exact title.
- Show the exact PR body that will be used.
- Output the PR body as raw Markdown only, exactly as it will be posted to GitHub.
- Do not wrap the PR body in code fences, quote blocks, tables, or any other formatting container.
- Do not show the full command output yet as it is less readable. Focus on the title and body content.
- Ask the user to confirm before proceeding with PR creation.

### 10. Create the pull request as a draft and then open it

- Write the confirmed PR body to a temp file using the `create_file` tool.
- Run `gh pr create --title "[title]" --body-file "[temp-file]" --draft --base "[base]" --head "[branch]"`.
- Replace `[title]`, `[temp-file]`, `[base]`, and `[branch]` with the exact confirmed values.
- Prefer `--body-file` over inline multiline `--body` strings because it is faster to reason about and avoids shell escaping errors.
- Open the returned PR URL in the browser after creation.
- Remove the temp file after the command succeeds.
- Do not mark the PR ready for review.

### 11. Return the draft PR link

- Include the PR URL in the final response.
- State clearly that the PR is a draft.

## Command minimisation

- Do not rediscover the branch if the user already supplied it.
- Do not include local uncommitted changes in PR drafting; use remote-tracking refs for diff analysis by default.
- Do not parse the git remote unless `gh` needs help identifying the repository.
- Do not fetch a full patch diff unless file-level changes or `--stat` are insufficient.
- Do not run both `git diff --name-status` and `git diff --stat` by default. Start with one and expand only if needed.
- Do not create browser-first PR flows. Create directly with `gh`, then open the resulting URL.

### Form Processing Workflow

Progress:

- [ ] Step 1: Resolve the source branch
- [ ] Step 2: Resolve the base branch and repository context
- [ ] Step 3: Read the repository pull request conventions
- [ ] Step 4: Read the PR template and example
- [ ] Step 5: Fetch the Jira ticket details if applicable
- [ ] Step 6: Analyse the branch changes relative to the base branch
- [ ] Step 7: Validate branch prefix suitability
- [ ] Step 8: Build the PR title and body
- [ ] Step 9: Present the proposed PR title and body to the user
- [ ] Step 10: Create the pull request as a draft and open it
- [ ] Step 11: Return the draft PR link

## Troubleshooting

- If the PR title or `Summary` format is unclear, reread `docs/wiki/team/pull-request-conventions.md` before drafting content.
- If Jira lookup fails for a detected ticket key, stop and ask the user to confirm the branch name or ticket key.
- If `gh pr create` needs multiline body content, write the body to a temp file and use `--body-file` instead of inlining markdown in the command.
- The create PR script will fail when there is an open PR for the same branch and target (main).

## Requirements

- Use `gh` CLI for pull request search and creation.
- Use `docs/pull-request-conventions.md` as the source of truth for the PR title format and the Summary section rules, if it exists. Otherwise use the PR template structure.
- Use the actual template at `${workspaceFolder}/.github/PULL_REQUEST_TEMPLATE.md`.
- Use `${workspaceFolder}/.github/skills/create-pr/assets/pull-request-description-example.md` as the formatting reference.
- Base the `List of Changes` on the actual GitHub-style diff between remote-tracking refs for source and base branches, using `git diff origin/<base>...origin/<branch>`.
- Use Jira ticket details when the branch contains a Jira key. If the Jira lookup fails, stop and ask the user to correct the ticket context.
- Create a draft PR only. Do not switch it to ready for review.
- Return the created PR link, or the existing PR link when creation of PR fails because a PR already exists for the same branch and target.
