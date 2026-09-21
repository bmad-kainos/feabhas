---
name: analyse-docs
description: Analyse project documentation to answer questions about features, workflows, business rules, architecture, APIs, or team practices. Use when the user wants documentation-based answers. Looks for docs in common locations — `docs/`, `docs/wiki/`, `wiki/`, or as specified by the user.
argument-hint: '[AREA_OF_INTEREST or QUESTION]'
user-invocable: true
---

# Analyse Project Documentation

Use this skill to answer questions against the project documentation by searching relevant pages and synthesizing an answer with citations using the templates.

## When to Use This Skill

- Understanding how something is implemented based on the documentation
- Checking business rules, team practices, ways of working, or workflows
- Exploring architecture, infrastructure, or other project topics covered in docs
- Finding out whether something is already documented

## Step-by-Step Workflows

1. Identify the documentation root: check for `docs/wiki/index.md`, `docs/index.md`, `wiki/index.md`, or `README.md` at the repo root. If ambiguous, ask the user.
2. Analyse the index or root page first to identify relevant documentation
3. Retrieve pages to find the answer to the question
4. If documentation is not found, follow the steps in `references/answer-not-found.md`
5. If documentation is found, follow the steps in `references/answer-found.md`

## Gotchas

- Treat the identified docs root as the primary source of truth
- Do not search outside the docs folder unless the user explicitly asks or approves it
- Stay read-only

## References

- [Answer Found Instructions](references/answer-found.md)
- [Answer Not Found Instructions](references/answer-not-found.md)
