---
name: Python language standards
description: Language-level conventions for Python files.
applyTo: "**/*.py"
---

# Python — language standards

- Follow PEP 8. Keep imports absolute and ordered.
- Add type hints to all public function signatures; write docstrings for public functions and modules.
- Never use a mutable default argument (`def f(x=[])`); default to `None` and create inside.
- Use `pathlib` over `os.path`, f-strings over `%`/`.format`, and context managers (`with`) for resources.
- Never use a bare `except:`; catch specific exceptions and don't silently swallow them.
- Prefer comprehensions and generators where they improve readability; don't force them when a loop is clearer.
