#!/usr/bin/env bash
set -euo pipefail

# Feabhas uninstaller — removes the pack's Copilot customizations from a target repo's .github/.

usage() {
  cat <<'EOF'
Usage: uninstall.sh [--dry-run] [--force] <target-repo-path>

Removes Feabhas's agents, skills, and instructions from <target-repo-path>/.github/.
Your copilot-instructions.md is KEPT if it looks customized (differs from the
template), so you don't lose project config. An empty .github/ is removed too.

Options:
  --dry-run   Show what would be removed without deleting anything.
  --force     Also remove copilot-instructions.md even if it has been customized.
  -h, --help  Show this help.
EOF
}

DRY_RUN=0
FORCE=0
TARGET=""

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --force) FORCE=1 ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage; exit 1 ;;
    *) TARGET="$1" ;;
  esac
  shift
done

if [ -z "$TARGET" ]; then
  echo "Error: target repo path is required." >&2
  usage
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo "Error: target '$TARGET' is not a directory." >&2
  exit 1
fi

# Resolve the directory this script lives in (the Feabhas checkout).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/.github"
DEST="$TARGET/.github"

if [ ! -d "$DEST" ]; then
  echo "Nothing to uninstall: $DEST does not exist."
  exit 0
fi

do_rm() {
  if [ "$DRY_RUN" -eq 1 ]; then echo "[dry-run] rm -rf $1"; else rm -rf "$1"; fi
}

echo "Uninstalling Feabhas from: $DEST"

# The three directories the installer copies in are always safe to remove.
for item in agents skills instructions; do
  if [ -e "$DEST/$item" ]; then do_rm "$DEST/$item"; fi
done

# copilot-instructions.md may hold project config — only remove it if it is
# unchanged from the bundled template, or if --force is given.
if [ -f "$DEST/copilot-instructions.md" ]; then
  if [ "$FORCE" -eq 1 ]; then
    do_rm "$DEST/copilot-instructions.md"
  elif [ -f "$SRC/copilot-instructions.md" ] && cmp -s "$SRC/copilot-instructions.md" "$DEST/copilot-instructions.md"; then
    do_rm "$DEST/copilot-instructions.md"
  else
    echo "Kept $DEST/copilot-instructions.md (looks customized; use --force to remove)."
  fi
fi

# Remove .github itself if it is now empty (never touch a .github with your own files).
if [ "$DRY_RUN" -eq 1 ]; then
  echo "[dry-run] rmdir $DEST if it ends up empty"
elif [ -d "$DEST" ] && [ -z "$(ls -A "$DEST" 2>/dev/null)" ]; then
  rmdir "$DEST"
  echo "Removed empty $DEST."
fi

echo
echo "Done."
