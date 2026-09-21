#!/usr/bin/env bash
set -euo pipefail

# Feabhas installer — copies the pack's Copilot customizations into a target repo's .github/.

usage() {
  cat <<'EOF'
Usage: install.sh [--dry-run] [--force] [--verify] [target-repo-path]

Copies Feabhas's agents, skills, and the copilot-instructions.md template into
<target-repo-path>/.github/ (target defaults to the current directory).

Options:
  --dry-run   Show what would be copied without writing anything.
  --force     Overwrite an existing .github/copilot-instructions.md (default: keep it).
  --verify    Check an existing install instead of copying; report missing items
              and warn if copilot-instructions.md is still unconfigured.
  -h, --help  Show this help.

After installing, open the target repo in VS Code and run the "Configure" agent
to fill in .github/copilot-instructions.md for the project.
EOF
}

DRY_RUN=0
FORCE=0
VERIFY=0
TARGET=""

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --force) FORCE=1 ;;
    --verify) VERIFY=1 ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage; exit 1 ;;
    *) TARGET="$1" ;;
  esac
  shift
done

# No target given? Default to the current directory.
if [ -z "$TARGET" ]; then
  TARGET="."
fi

if [ ! -d "$TARGET" ]; then
  echo "Error: target '$TARGET' is not a directory." >&2
  exit 1
fi

# Normalize to an absolute path so messages and the self-repo guard are clear.
TARGET="$(cd "$TARGET" && pwd)"

# Resolve the directory this script lives in (the Feabhas checkout).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/.github"

if [ ! -d "$SRC/agents" ] || [ ! -d "$SRC/skills" ]; then
  echo "Error: could not find Feabhas's .github/agents and .github/skills next to this script." >&2
  exit 1
fi

DEST="$TARGET/.github"

if [ "$VERIFY" -eq 1 ]; then
  echo "Verifying Feabhas in: $DEST"
  missing=0
  for item in agents skills instructions copilot-instructions.md; do
    if [ -e "$DEST/$item" ]; then
      echo "  OK       $item"
    else
      echo "  MISSING  $item"
      missing=1
    fi
  done
  if [ -f "$DEST/copilot-instructions.md" ] && grep -q '<!--' "$DEST/copilot-instructions.md"; then
    echo "  WARN     copilot-instructions.md still has unfilled placeholders - run the \"Configure\" agent."
  fi
  echo
  if [ "$missing" -eq 1 ]; then
    echo "Feabhas is NOT fully installed in $DEST."
    exit 1
  fi
  echo "Feabhas is installed in $DEST."
  exit 0
fi

# Don't copy the pack into its own source repo.
if [ "$TARGET" = "$SCRIPT_DIR" ]; then
  echo "Error: refusing to install Feabhas into its own source repo." >&2
  echo "cd into the repo you want it in, or pass its path (e.g. feabhas install /path/to/your-repo)." >&2
  exit 1
fi

do_mkdir() {
  if [ "$DRY_RUN" -eq 1 ]; then echo "[dry-run] mkdir -p $1"; else mkdir -p "$1"; fi
}

do_cp() {
  if [ "$DRY_RUN" -eq 1 ]; then echo "[dry-run] cp -R $1 -> $2"; else cp -R "$1" "$2"; fi
}

echo "Installing Feabhas into: $DEST"
do_mkdir "$DEST"
do_cp "$SRC/agents" "$DEST/"
do_cp "$SRC/skills" "$DEST/"
do_cp "$SRC/instructions" "$DEST/"

if [ -f "$DEST/copilot-instructions.md" ] && [ "$FORCE" -eq 0 ]; then
  echo "Kept existing $DEST/copilot-instructions.md (use --force to overwrite)."
else
  do_cp "$SRC/copilot-instructions.md" "$DEST/copilot-instructions.md"
fi

echo
echo "Done. Next steps:"
echo "  1. Open $TARGET in VS Code."
echo "  2. Run the \"Configure\" agent (chat agent dropdown) to fill in .github/copilot-instructions.md."
echo "  3. For the Jira / Confluence / Zephyr skills, configure the Atlassian MCP server."
